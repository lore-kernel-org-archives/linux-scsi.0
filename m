From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 33/39] megaraid_sas: call flush_scheduled_work during
 controller shutdown/detach
Date: Mon, 6 Feb 2017 17:05:15 +0100
Message-ID: <5624644f-c747-6b7a-3d0d-001c4bc46cd1@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752155AbdBFQFS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 11:05:18 -0500
In-Reply-To: <1486375212-17329-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 11:00, Shivasharan S wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 04ef0a0..b29cfd3 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -6393,6 +6393,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
>  	if (instance->ev != NULL) {
>  		struct megasas_aen_event *ev = instance->ev;
>  		cancel_delayed_work_sync(&ev->hotplug_work);
> +		flush_scheduled_work();
>  		instance->ev = NULL;
>  	}
>  
> @@ -6619,6 +6620,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
>  	if (instance->ev != NULL) {
>  		struct megasas_aen_event *ev = instance->ev;
>  		cancel_delayed_work_sync(&ev->hotplug_work);
> +		flush_scheduled_work();
>  		instance->ev = NULL;
>  	}
>  

Why is cancel_delayed_work_sync not good enough? 

tomash
