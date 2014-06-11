From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v1 3/3] TARGET/sbc,loopback: Adjust command data length
 in case pi exists on the wire
Date: Wed, 11 Jun 2014 14:30:15 -0700
Message-ID: <1402522215.17740.29.camel@haakon3.risingtidesystems.com>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
	 <1402223228-23768-4-git-send-email-sagig@mellanox.com>
	 <1402387450.5774.56.camel@haakon3.risingtidesystems.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46D1D00E@avmb2.qlogic.org>
	 <53980434.1000306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53980434.1000306@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "roland@kernel.org" <roland@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-06-11 at 10:24 +0300, Sagi Grimberg wrote:
> On 6/11/2014 12:17 AM, Quinn Tran wrote:
> 
> <SNIP>
> 
> > QT> Instead of using existing value within cmd->data_length, can we
> > calculated data_length based on secstors & blocksize.
> >
> > cmd->data_length = sectors * dev->dev_attrib.block_size;
> 
> We can do that I suppose...
> Although it seems weird that the core discards the transport byte-count...
> Just wandering if we should recalc on the DIF case only or always.
> 

Yeah, same concern here wrt to discarding the transport length.

This effectively makes the residual handling further down in
sbc_parse_cdb() -> target_cmd_size_check() always match size ==
cmd->data_length, because the latter as been recalculated by the former.

Honestly, I don't know if this is a problem for normal READ + WRITE with
prot=1 as I've never seen size != cmd->data_length for I/O related
commands, but it does seem potentially dangerous.

> >
> >  From the QLogic perfective, the cmd->data_length is pull directly from the
> > wire (i.e. FCP header) when cmd is received.  In essence, it's whatever
> > the Initiator is set it to.  We does not have any indicator to spot DIF vs
> > none-DIF cmd when 1st received, unless the code do a peek.
> 
> Same for all transports I assume...
> 

So just to confirm Quinn, the Qlogic the initiator includes the PI bytes
into the FCP header data_length for the target-side *_PASS and
DOUT_STRIP / DIN_INSERT, that is currently passed into
qla_tgt_ops->handle_cmd(), right..?

If that is the case, Sagi's v1 to cmd->data_length -= cmd->prot_length
seems like it would still do right thing for *_PASS and DOUT_STRIP /
DIN_INSERT, given that cmd->prot_length is calculated in
sbc_check_prot() based upon dev->prot_length * sectors..

> >
> > With that said, the cmd->data_length does not guarantee to contain both
> > "data length" & "protection length" when cmd is submit to
> > TCM/target_submit_cmd().  In Dif-Insert mode, data_length will only
> > contain the actual data(no Dif).
> 
> No, in the DOUT_INSERT/DIN_STRIP case, protect bits are off and the core 
> will take the data length as is.
> This case is covered.
> 

<nod>

> > It's best that the SBC code re-calculate the actual data length and dif
> > data length based on the number of sectors derived from the cmd.
> 
> Nic, what's your take on this?
> 

Hard to say.  Discarding the transport length in v2 doesn't seem like a
good idea, but subtracting from cmd->prot_length in v1 is using the
sector count from the CDB anyways, so it's essentially the same tradeoff
of recalculating the transport's cmd->data_length from values within the
CDB w/ prot=1.

MKP, WDYT..?

--nab
