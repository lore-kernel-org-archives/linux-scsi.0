From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 33/39] megaraid_sas: call flush_scheduled_work during
 controller shutdown/detach
Date: Tue, 7 Feb 2017 14:20:56 +0530
Message-ID: <50f21c79b9cfd7cb4606042c623fd577@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <5624644f-c747-6b7a-3d0d-001c4bc46cd1@redhat.com> f1536f3d66ba6e93f018f760c57910a3@mail.gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34910 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdBGIu7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 03:50:59 -0500
Received: by mail-qt0-f169.google.com with SMTP id x49so128210796qtc.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2017 00:50:58 -0800 (PST)
In-Reply-To: f1536f3d66ba6e93f018f760c57910a3@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

> -----Original Message-----
> From: Kashyap Desai [mailto:kashyap.desai@broadcom.com]
> Sent: Monday, February 06, 2017 10:48 PM
> To: 'Tomas Henzl'; Shivasharan Srikanteshwara;
'linux-scsi@vger.kernel.org'
> Cc: 'martin.petersen@oracle.com'; 'jejb@linux.vnet.ibm.com'; Sumit
Saxena;
> 'hare@suse.com'
> Subject: RE: [PATCH 33/39] megaraid_sas: call flush_scheduled_work
during
> controller shutdown/detach
>
> > -----Original Message-----
> > From: Tomas Henzl [mailto:thenzl@redhat.com]
> > Sent: Monday, February 06, 2017 9:35 PM
> > To: Shivasharan S; linux-scsi@vger.kernel.org
> > Cc: martin.petersen@oracle.com; jejb@linux.vnet.ibm.com;
> > kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> hare@suse.com
> > Subject: Re: [PATCH 33/39] megaraid_sas: call flush_scheduled_work
> > during controller shutdown/detach
> >
> > On 6.2.2017 11:00, Shivasharan S wrote:
> > > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > > Signed-off-by: Shivasharan S
> > <shivasharan.srikanteshwara@broadcom.com>
> > > ---
> > >  drivers/scsi/megaraid/megaraid_sas_base.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > > index 04ef0a0..b29cfd3 100644
> > > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > > @@ -6393,6 +6393,7 @@ megasas_suspend(struct pci_dev *pdev,
> > pm_message_t state)
> > >  	if (instance->ev != NULL) {
> > >  		struct megasas_aen_event *ev = instance->ev;
> > >  		cancel_delayed_work_sync(&ev->hotplug_work);
> > > +		flush_scheduled_work();
> > >  		instance->ev = NULL;
> > >  	}
> > >
> > > @@ -6619,6 +6620,7 @@ static void megasas_detach_one(struct pci_dev
> > *pdev)
> > >  	if (instance->ev != NULL) {
> > >  		struct megasas_aen_event *ev = instance->ev;
> > >  		cancel_delayed_work_sync(&ev->hotplug_work);
> > > +		flush_scheduled_work();
> > >  		instance->ev = NULL;
> > >  	}
> > >
> >
> > Why is cancel_delayed_work_sync not good enough?
>
> Megaraid_sas driver use certain work on global work queue.
>
> Below are the listed one -
>
> 	if (instance->ctrl_context) {
> 		INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
> 		INIT_WORK(&instance->crash_init,
> megasas_fusion_crash_dump_wq);
> 	}
> 	else
> 		INIT_WORK(&instance->work_init,
> process_fw_state_change_wq)
>
> Cancel_delayed_work_sync() was mainly targeted for only hotplug AEN
work.
> Calling flush_scheduled_work() we want above listed work to be completed
> as well.

Tomas - Here is one more update. I agree with your assessment. We don't
need this patch.

In our local repo code was like below and as part of sync up activity, I
did not realize that upstream is using cancel_delayed_work_sync() which is
internally doing the same as below.

                cancel_delayed_work(&ev->hotplug_work);
                flush_scheduled_work();

Just for info - Similar patch was posted for mpt2sas long time ago to
replace above combination with cancel_delayed_work_sync()

https://lkml.org/lkml/2010/12/21/127

We will accommodate removal of this patch in V2 submission.



>
> >
> > tomash
