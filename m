From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH v1 3/3] TARGET/sbc,loopback: Adjust command data length
 in case pi exists on the wire
Date: Wed, 11 Jun 2014 21:01:41 -0700
Message-ID: <1402545701.32257.22.camel@haakon3.risingtidesystems.com>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
	 <1402223228-23768-4-git-send-email-sagig@mellanox.com>
	 <1402387450.5774.56.camel@haakon3.risingtidesystems.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46D1D00E@avmb2.qlogic.org>
	 <53980434.1000306@dev.mellanox.co.il>
	 <1402522215.17740.29.camel@haakon3.risingtidesystems.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46D1D8C7@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <504EB66DAC8D234EB8E8560985C2D7AD46D1D8C7-vcA9p2Eq0686wu3ARrlbmA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Quinn Tran <quinn.tran-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-06-11 at 22:32 +0000, Quinn Tran wrote:
> 
> On 6/11/14 2:30 PM, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> 
> >On Wed, 2014-06-11 at 10:24 +0300, Sagi Grimberg wrote:
> >> On 6/11/2014 12:17 AM, Quinn Tran wrote:
> >>
> >> <SNIP>
> >>
> >> > QT> Instead of using existing value within cmd->data_length, can we
> >> > calculated data_length based on secstors & blocksize.
> >> >
> >> > cmd->data_length = sectors * dev->dev_attrib.block_size;
> >>
> >> We can do that I suppose...
> >> Although it seems weird that the core discards the transport
> >>byte-count...
> >> Just wandering if we should recalc on the DIF case only or always.
> >>
> >
> >Yeah, same concern here wrt to discarding the transport length.
> >
> >This effectively makes the residual handling further down in
> >sbc_parse_cdb() -> target_cmd_size_check() always match size ==
> >cmd->data_length, because the latter as been recalculated by the former.
> >
> >Honestly, I don't know if this is a problem for normal READ + WRITE with
> >prot=1 as I've never seen size != cmd->data_length for I/O related
> >commands, but it does seem potentially dangerous.
> >
> >> >
> >> >  From the QLogic perfective, the cmd->data_length is pull directly
> >>from the
> >> > wire (i.e. FCP header) when cmd is received.  In essence, it's
> >>whatever
> >> > the Initiator is set it to.  We does not have any indicator to spot
> >>DIF vs
> >> > none-DIF cmd when 1st received, unless the code do a peek.
> >>
> >> Same for all transports I assume...
> >>
> >
> >So just to confirm Quinn, the Qlogic the initiator includes the PI bytes
> >into the FCP header data_length for the target-side *_PASS and
> >DOUT_STRIP / DIN_INSERT, that is currently passed into
> >qla_tgt_ops->handle_cmd(), right..?
> 
> QT>
> Initiator:
> DOUT_STRIP/DIN_Insert:  FCP_DL = data length only (no dif length)
> Dif PASS: FCP_DL = data length + Dif length.
> 
> Target:
> DOUT_strip/DIN_Insert:  qla_tgt_ops->handle_cmd(data length only)
> 
> sbc_check_prot()
> If (protect)
>    cmd->data_length -= cmd->prot_length;  << truncation
> 
> 

<nod>

> ---
> DIF_PASS: qla_tgt_ops->handle_cmd(data length + Dif length)
> 
> 

Ok, so Sagi's patches for legacy fabric <-> PI backend and
PI fabric <-> PI backend cases look OK, but not for the
PI fabric <-> legacy backend case as noted above..

Given DOUT_STRIP + DIN_INSERT have not been enabled in sbc_check_prot()
just yet, I'll go ahead and merge his v2 series to address the two
existing cases in -rc1 + v3.15.y stable code.

>From there, enabling PI fabric <-> legacy backend support in >= rc2 with
target-core will be easy, as it's just a matter of updating
sbc_set_prot_op_checks() to assign prot_ops, avoid sbc_check_prot()
cmd->data_length recalculation, and making sure PROTECTION control
feature bits are still exposed for legacy -> unprotected backends.

Thanks!

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
