From: Minwoo Im <minwoo.im@samsung.com>
Subject: Re: [RESEND RFC PATCH] mpt3sas: support target smid for
 [abort|query] task
Date: Sun, 14 Jul 2019 11:17:52 +0900
Message-ID: <20190714021752epcms2p6994026d1e2b3738f2857f8eff307c866@epcms2p6>
References: <CAK=zhgr_T8vA=BCdFCT37RxGCgS3xr8Wp9MEMK_9nZ=oYHy=7Q@mail.gmail.com>
        <20190621063708epcms2p309f4173afabe5de28942ba15d13987f7@epcms2p3>
        <CGME20190621063708epcms2p309f4173afabe5de28942ba15d13987f7@epcms2p6>
Reply-To: minwoo.im@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgr_T8vA=BCdFCT37RxGCgS3xr8Wp9MEMK_9nZ=oYHy=7Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Minwoo Im <minwoo.im@samsung.com>
Cc: "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Euihyeok Kwon <eh81.kwon@samsung.com>, Sarah Cho <sohyeon.jo@samsung.com>, Sanggwan Lee <sanggwan.lee@samsung.com>, Gyeongmin Nam <gm.nam@samsung.com>, "minwoo.im.dev@gmail.com" <minwoo.im.dev@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi Sreekanth,

> >  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> > index b2bb47c14d35..5c7539dae713 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> > @@ -596,15 +596,17 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc,
> struct mpt3_ioctl_command *karg,
> >                 if (priv_data->sas_target->handle != handle)
> >                         continue;
> >                 st = scsi_cmd_priv(scmd);
> > -               tm_request->TaskMID = cpu_to_le16(st->smid);
> > -               found = 1;
> > +               if (tm_request->TaskMID == st->smid) {
> 
> I think it will difficult for the user to find the smid that he want
> to abort. For this user has to enable the scsi logging level and get
> the tag and pass the ioctl with tag +1 value in TaskMID field. And
> hence currently driver will loop over all the smid's and if it fines
> any outstanding smid then it will issue task abort or task query TM
> for this outstanding smid to the HBA firmware.

Sreekanth,

You're exactly right because I have done this kind of abort based on
The scsi logs with logging level configured.

> 
> May be we can do like below,
> * First check whether user provided "TaskMID" is non zero or not. if
> user provided TaskMID is non-zero and if this TaskMID is outstanding
> then driver will issue TaskAbort/QueryTask TM with this TaskMID value

Okay.  If I get it right, you mean to check the given TaskMID(!=0) is
Outstanding or not is by an iteration first.

> else driver will loop over all the smid's and if finds any smid is
> outstanding then it will issue TaskAbort/QueryTask TM with TaskMID
> value set to outstanding smid.

Got your point here.  I'll make a conditional statement for the case
where the TaskMID is zero which is the legacy behaviour.

> With the above logic still legacy application will be supported
> without breaking anything where they provide TaskMID filed as zero.
> And it also allows the user to abort the IO which he wants.

Sure, I'll prepare V2 patch soon.

Thanks Sreekanth,

		Minwoo Im
