From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V2] mpt3sas: support target smid for [abort|query] task
Date: Tue, 23 Jul 2019 22:33:58 +0900
Message-ID: <20190723133358.GB7148@minwoo-desktop>
References: <CGME20190714034415epcms2p25f9787cb71993a30f58524d2f355b543@epcms2p2>
 <20190714034415epcms2p25f9787cb71993a30f58524d2f355b543@epcms2p2>
 <860cc8cf-6419-c649-b2d9-19b82f6ebc99@suse.de>
 <CAK=zhgocY3Ute_6RiowaWsOROx3+Nzq6+WvkobmR_SB0Rt9_1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK=zhgocY3Ute_6RiowaWsOROx3+Nzq6+WvkobmR_SB0Rt9_1g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>
Cc: minwoo.im@samsung.com, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Euihyeok Kwon <eh81.kwon@samsung.com>, Sarah Cho <sohyeon.jo@samsung.com>, Sanggwan Lee <sanggwan.lee@samsung.com>, Gyeongmin Nam <gm.nam@samsung.com>, Sungjun Park <sj1228.park@samsung.com>, Minwoo Im <minwoo.im.dev@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 19-07-23 16:57:49, Sreekanth Reddy wrote:
> On Mon, Jul 15, 2019 at 11:43 AM Hannes Reinecke <hare@suse.de> wrote:
> >
> > On 7/14/19 5:44 AM, Minwoo Im wrote:
> > > We can request task management IOCTL command(MPI2_FUNCTION_SCSI_TASK_MGMT)
> > > to /dev/mpt3ctl.  If the given task_type is either abort task or query
> > > task, it may need a field named "Initiator Port Transfer Tag to Manage"
> > > in the IU.
> > >
> > > Current code does not support to check target IPTT tag from the
> > > tm_request.  This patch introduces to check TaskMID given from the
> > > userspace as a target tag.  We have a rule of relationship between
> > > (struct request *req->tag) and smid in mpt3sas_base.c:
> > >
> > > 3318 u16
> > > 3319 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
> > > 3320         struct scsi_cmnd *scmd)
> > > 3321 {
> > > 3322         struct scsiio_tracker *request = scsi_cmd_priv(scmd);
> > > 3323         unsigned int tag = scmd->request->tag;
> > > 3324         u16 smid;
> > > 3325
> > > 3326         smid = tag + 1;
> > >
> > > So if we want to abort a request tagged #X, then we can pass (X + 1) to
> > > this IOCTL handler.  Otherwise, user space just can pass 0 TaskMID to
> > > abort the first outstanding smid which is legacy behaviour.
> > >
> > > Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > > Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> > > Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> > > Cc: James E.J. Bottomley <jejb@linux.ibm.com>
> > > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > > Cc: MPT-FusionLinux.pdl@broadcom.com
> > > Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
> > > ---
> > >  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> > > index b2bb47c14d35..f6b8fd90610a 100644
> > > --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> > > +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> > > @@ -596,8 +596,16 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,
> > >               if (priv_data->sas_target->handle != handle)
> > >                       continue;
> > >               st = scsi_cmd_priv(scmd);
> > > -             tm_request->TaskMID = cpu_to_le16(st->smid);
> > > -             found = 1;
> > > +
> > > +             /*
> > > +              * If the given TaskMID from the user space is zero, then the
> > > +              * first outstanding smid will be picked up.  Otherwise,
> > > +              * targeted smid will be the one.
> > > +              */
> > > +             if (!tm_request->TaskMID || tm_request->TaskMID == st->smid) {
> > > +                     tm_request->TaskMID = cpu_to_le16(st->smid);
> > > +                     found = 1;
> > > +             }
> > >       }
> > >
> > >       if (!found) {
> > >
> > I think this is fundamentally wrong.
> > ABORT_TASK is used to abort a single task, which of course has to be
> > known beforehand. If you don't know the task, what exactly do you hope
> > to achieve here? Aborting random I/O?
> > Or, even worse, aborting I/O the driver uses internally and corrupt the
> > internal workflow of the driver?
> >
> > We should simply disallow any ABORT TASK from userspace if the TaskMID
> > is zero. And I would even argue to disabllow ABORT TASK from userspace
> > completely, as the smid is never relayed to userland, and as such the
> > user cannot know which task should be aborted.
> 
> Hannes,
> 
> This interface was added long time back in mpt2sas driver and I don't
> have exact reason of adding this interface at that time.
> But I know that this interface is still used by BRCM test team & few
> customers only for some functionality and regression testing.

Actually I have sent this patch for the testing purpose for the SAS storage
that I'm working with now.  Some of test platform could figure out which
command has to be aborted or queried via debugfs and information from the
device itself with some other methods.  If the mpt3sas driver supports
the targeted TMF for a single command, then it would be great for the
testing.

Thanks,
	Minwoo Im
