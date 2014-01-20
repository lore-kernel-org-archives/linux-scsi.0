From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi-sg: pass flag to inhibit setting LUN
Date: Sun, 19 Jan 2014 19:23:03 -0800
Message-ID: <1390188183.341.4.camel@dabdike.int.hansenpartnership.com>
References: <52C56755.7060709@seznam.cz> <52C7193C.20806@interlog.com>
	 <52DBF59F.3050604@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54611 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbaATDXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jan 2014 22:23:07 -0500
In-Reply-To: <52DBF59F.3050604@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: =?UTF-8?Q?Ji=C5=99=C3=AD?= Pinkava <j-pi@seznam.cz>, linux-scsi@vger.kernel.org

On Sun, 2014-01-19 at 10:56 -0500, Douglas Gilbert wrote:
> On 14-01-03 03:10 PM, Douglas Gilbert wrote:
> > On 14-01-02 08:19 AM, Ji=C5=99=C3=AD Pinkava wrote:
> >> Hi,
> >>
> >> This patch implements support for inhibiting setting LUN number
> >> for SCSI custom command send via /dev/sgX with ioctl(.., SG_IO, ..=
=2E) call.
> >>
> >> This solves problems with some devices which claim support of
> >> SCSI v1/v2, but for some special purposes use custom commands
> >> which does not conform with standard message format.
> >> (Like mine Pentax digital single-lens reflex camera)
> >> It does not affect devices with SCSI v3 or latter.
> >>
> >> For this purpose was earlier introduced
> >> SG_FLAG_LUN_INHIBIT / SG_FLAG_UNUSED_LUN_INHIBIT (glibc/kernel) fl=
ag,
> >> but the implementation was lost in some earlier code refactor.
> >>
> >> The only possible issue I see is current implementation supports o=
nly
> >> SG driver but there is few more code paths where the similar ioctl=
 can
> >> be invoked
> >> (eg. anny SCSI device?). I'm not sure about, feel free to say anyt=
hing
> >> about it.
> >
> > Hi,
> > SG_FLAG_LUN_INHIBIT was added to the sg driver around 15
> > years ago. The code to centralize the masking in scsi.c
> > and remove the "LUN inhibit" capability arrived about
> > 10 years ago. A handful of people have complained about
> > it since. An you are the first to do something about it!
> >
> > I have a few comments about the code (see below) but the
> > logic seems okay to me. That said I would be very surprised
> > if this is allowed back in the kernel. If you manage to do
> > that then I'll be studying your technique (because many of my
> > patches to the sg driver are not accepted).
> >
> > So you can takes that as an "ack" with comments and good luck.
> > I'll let others judge.
> >
> >> ---
> >>   drivers/scsi/scsi.c       | 3 ++-
> >>   drivers/scsi/sg.c         | 3 +++
> >>   include/linux/blk_types.h | 2 ++
> >>   3 files changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> >> index fe0bcb1..f6d5fc9 100644
> >> --- a/drivers/scsi/scsi.c
> >> +++ b/drivers/scsi/scsi.c
> >> @@ -693,7 +693,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> >>        * If SCSI-2 or lower, store the LUN value in cmnd.
> >>        */
> >>       if (cmd->device->scsi_level <=3D SCSI_2 &&
> >> -        cmd->device->scsi_level !=3D SCSI_UNKNOWN) {
> >> +        cmd->device->scsi_level !=3D SCSI_UNKNOWN &&
> >> +        !(cmd->request->cmd_flags & REQ_LUN_INHIBIT)) {
> >>           cmd->cmnd[1] =3D (cmd->cmnd[1] & 0x1f) |
> >>                      (cmd->device->lun << 5 & 0xe0);
> >>       }
> >
> > The above being time sensitive code I was thinking a switch
> > might make it clearer and give the compiler more chances to
> > optimize:
> >        switch(cmd->device->scsi_level) {
> >        case SCSI_2:
> >        case SCSI_1_CCS:
> >        case SCSI_1:
> >                if (!(cmd->request->cmd_flags & REQ_LUN_INHIBIT)) {
> >                        cmd->cmnd[1] =3D (cmd->cmnd[1] & 0x1f) |
> >                                       (cmd->device->lun << 5 & 0xe0=
);
> >                }
> >                break;
> >        default:
> >                ;
> >        }
> >
> > Hmm, can a switch's default be made "likely"?
> >
> > More generally folks, with SAS SSDs available that can read at
> > 1100 MB/sec we may want to spend time looking at the fast
> > paths through the SCSI subsystem.
> >
> >
> >> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> >> index df5e961..8e09015 100644
> >> --- a/drivers/scsi/sg.c
> >> +++ b/drivers/scsi/sg.c
> >> @@ -1663,6 +1663,9 @@ static int sg_start_req(Sg_request *srp, uns=
igned
> >> char *cmd)
> >>       rq->sense =3D srp->sense_b;
> >>       rq->retries =3D SG_DEFAULT_RETRIES;
> >>
> >> +    if (hp->flags & SG_FLAG_UNUSED_LUN_INHIBIT)
> >> +        rq->cmd_flags |=3D  REQ_LUN_INHIBIT;
> >> +
> >>       if ((dxfer_len <=3D 0) || (dxfer_dir =3D=3D SG_DXFER_NONE))
> >>           return 0;
> >>
> >> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> >> index 238ef0e..35d436b 100644
> >> --- a/include/linux/blk_types.h
> >> +++ b/include/linux/blk_types.h
> >> @@ -178,6 +178,7 @@ enum rq_flag_bits {
> >>       __REQ_MIXED_MERGE,    /* merge of different types, fail sepa=
rately */
> >>       __REQ_KERNEL,         /* direct IO to kernel pages */
> >>       __REQ_PM,        /* runtime pm request */
> >> +    __REQ_LUN_INHIBIT,    /* pass through for
> >> SG_FLAG_UNUSED_LUN_INHIBIT flag */
> >>       __REQ_END,        /* last of chain of requests */
> >>       __REQ_NR_BITS,        /* stops here */
> >>   };
> >> @@ -230,6 +231,7 @@ enum rq_flag_bits {
> >>   #define REQ_SECURE        (1ULL << __REQ_SECURE)
> >>   #define REQ_KERNEL        (1ULL << __REQ_KERNEL)
> >>   #define REQ_PM            (1ULL << __REQ_PM)
> >> +#define REQ_LUN_INHIBIT    (1ULL << __REQ_LUN_INHIBIT)
> >>   #define REQ_END            (1ULL << __REQ_END)
> >>
> >>   #endif /* __LINUX_BLK_TYPES_H */
> >>
> >
> > And I think the SG_FLAG_LUN_INHIBIT define should be re-instated
> > to sg.h . For backward compatibility (for the last 10 years)
> > please leave the SG_FLAG_UNUSED_LUN_INHIBIT define there. Both
> > defines should have the same value.
>=20
> Not sure if this patch is going anywhere, but I do get queries
> periodically that boil down to a request for this capability
> to be re-instated.
>=20
> In the last week someone sent me a usbmon dump showing how
> sg_raw worked (or at least obeyed the command line supplied
> cdb) from Windows but failed from Linux. Linux masking byte
> 1 of the cdb was the reason.

OK, I'll look at this after the merge window, but please consider

     1. If we're doing this, it has to be SG_IO via block and bsg as
        well, it can't be sg module only
     2. It can't be per-command: a device can't rely on the CDB[1] bits
        for some commands and not for others, it must be all or nothing
        (otherwise how do the exception commands get addressed to non
        zero luns?)
     3. Do we already have a flag we can use for this, like BLIST_NOLUN
        or BLIST_FORCELUN or BLIST_REPORTLUN2

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
