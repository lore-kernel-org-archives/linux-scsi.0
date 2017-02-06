From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 33/39] megaraid_sas: call flush_scheduled_work during
 controller shutdown/detach
Date: Mon, 6 Feb 2017 22:48:07 +0530
Message-ID: <f1536f3d66ba6e93f018f760c57910a3@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-34-git-send-email-shivasharan.srikanteshwara@broadcom.com> <5624644f-c747-6b7a-3d0d-001c4bc46cd1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:33255 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdBFRSK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 12:18:10 -0500
Received: by mail-qt0-f174.google.com with SMTP id v23so111256077qtb.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 09:18:10 -0800 (PST)
In-Reply-To: <5624644f-c747-6b7a-3d0d-001c4bc46cd1@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Monday, February 06, 2017 9:35 PM
> To: Shivasharan S; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; jejb@linux.vnet.ibm.com;
> kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> hare@suse.com
> Subject: Re: [PATCH 33/39] megaraid_sas: call flush_scheduled_work
during
> controller shutdown/detach
>
> On 6.2.2017 11:00, Shivasharan S wrote:
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > Signed-off-by: Shivasharan S
> <shivasharan.srikanteshwara@broadcom.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index 04ef0a0..b29cfd3 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -6393,6 +6393,7 @@ megasas_suspend(struct pci_dev *pdev,
> pm_message_t state)
> >  	if (instance->ev != NULL) {
> >  		struct megasas_aen_event *ev = instance->ev;
> >  		cancel_delayed_work_sync(&ev->hotplug_work);
> > +		flush_scheduled_work();
> >  		instance->ev = NULL;
> >  	}
> >
> > @@ -6619,6 +6620,7 @@ static void megasas_detach_one(struct pci_dev
> *pdev)
> >  	if (instance->ev != NULL) {
> >  		struct megasas_aen_event *ev = instance->ev;
> >  		cancel_delayed_work_sync(&ev->hotplug_work);
> > +		flush_scheduled_work();
> >  		instance->ev = NULL;
> >  	}
> >
>
> Why is cancel_delayed_work_sync not good enough?

Megaraid_sas driver use certain work on global work queue.

Below are the listed one -

	if (instance->ctrl_context) {
		INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
		INIT_WORK(&instance->crash_init,
megasas_fusion_crash_dump_wq);
	}
	else
		INIT_WORK(&instance->work_init,
process_fw_state_change_wq)

Cancel_delayed_work_sync() was mainly targeted for only hotplug AEN work.
Calling flush_scheduled_work() we want above listed work to be completed
as well.

>
> tomash
