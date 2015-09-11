From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/qla2xxx: Honor max_data_sg_nents I/O transfer
 limit
Date: Fri, 11 Sep 2015 00:07:28 -0700
Message-ID: <1441955248.21634.22.camel@haakon3.risingtidesystems.com>
References: <1439455550-2626-1-git-send-email-nab@daterainc.com>
	 <alpine.LRH.2.00.1508171724150.19116@mvluser04.mv.qlogic.com>
	 <1440112633.14304.23.camel@haakon3.risingtidesystems.com>
	 <1441842255.6836.13.camel@haakon3.risingtidesystems.com>
	 <D2174D86.B2810%himanshu.madhani@qlogic.com>
	 <1441953394.21634.12.camel@haakon3.risingtidesystems.com>
	 <alpine.LRH.2.00.1509102344590.25345@mvluser04.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1509102344590.25345@mvluser04.mv.qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Arun Easi <arun.easi@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Craig Watson <craig.watson@vanguard-rugged.com>, Roland Dreier <roland@purestorage.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-09-10 at 23:56 -0700, Arun Easi wrote:
> On Thu, 10 Sep 2015, 11:36pm -0700, Nicholas A. Bellinger wrote:
>=20
> > On Thu, 2015-09-10 at 22:16 +0000, Himanshu Madhani wrote:
> >> Hi Nic,
> >>
> >> Sorry about the delay in response.
> >>
> >> I have tested with RHEL 6.5 and noticed that IO were not able to c=
omplete
> >> with 16M and 32M read/write. IO=C2=B9s were getting error due to M=
id-layer
> >> underflow
> >>
> >> With initiator running upstream kernel version 4.2 as well I was s=
eeing
> >> error with Mid-layer reporting under-run.
> >>
> >> I made change in the driver to report DID_OK to Mid-layer with res=
idual
> >> count and I was able to see IO completed without any error.
> >> Basically, overriding driver=C2=B9s logic of failing an I/O, when =
residual
> >> makes it an error with scsi_cmnd->underflow set.
> >> In reality, though, with scsi_cmnd->underflow being set, Linux Qlo=
gic
> >> initiator will always see this as an error.
> >> Maybe this is useful in other OSes. We have verified both read and=
 write
> >> data on FC trace and it looks good.
> >>
> >
> > Great.  Thanks for the update.
> >
> >> Here=C2=B9s diff that was done in qla2xxx driver to report respons=
e to
> >> mid-layer as DID_OK.
> >>
> >>
> >> # git diff
> >> diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> >> b/drivers/scsi/qla2xxx/qla_isr.c
> >> index ccf6a7f..fc7b6a2 100644
> >> --- a/drivers/scsi/qla2xxx/qla_isr.c
> >> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> >> @@ -2257,7 +2257,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, s=
truct
> >> rsp_que *rsp, void *pkt)
> >>                                     "detected (0x%x of 0x%x bytes)=
=2E\n",
> >>                                     resid, scsi_bufflen(cp));
> >>
> >> -                               res =3D DID_ERROR << 16;
> >> +                               res =3D DID_OK << 16;
> >>                                 break;
> >>                         }
> >>                 } else if (lscsi_status !=3D SAM_STAT_TASK_SET_FUL=
L &&
> >> (END)
> >>
> >>
> >> Please go ahead and add patch to mainline kernel.
> >>
> >
> > This missed the last linux-next build by a day, but with your Teste=
d-by
> > + Signed-off-by on this patch, I think it's still safe enough to qu=
eue
> > for v4.3-rc1 code.  (Adding JEJB CC')
> >
> > qla2xxx: Allow DID_OK status for residual under/overflow completion
> > https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git=
/commit/?h=3Dfor-next&id=3D46376bdc1e8a77c6d2cc65b77a1e340d4b4c9f1c
> >
> > The target-pending/for-next PULL request will be going out in the n=
ext
> > 48 hours.
> >
> > Please let me know ASAP if you hit any regressions.
> >
>=20
> With existing scsi_cmnd->underflow semantics, LLDs are required (I=20
> believe) to treat the I/O as error if data transferred is less than=20
> underflow. "underflow", I think, is set to scsi_bufflen() today makin=
g any=20
> non-zero residual cases an error. So the above patch would break that=
=20
> semantic. We were not planning to push that change when we made that=20
> internally for testing.
>=20
> From scsi_cmnd.h:
> --8<-- struct scsi_cmnd --
>          unsigned underflow;     /* Return error if less than
>                                     this amount is transferred */
> --8<--
>=20
> That said, I think moving the check (of scsi_cmnd->underflow) to uppe=
r=20
> layers make more sense to me. LLDs would continue to set residual, if=
=20
> there is a residual. SCSI M/L or sd/st can do the enforcement of=20
> "scsi_cmnd->underflow" requirement.
>=20

Er, sorry.  I read Himanshu's response wrong.

Dropping the LLD side patch now.
