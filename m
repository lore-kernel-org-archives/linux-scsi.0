From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 33/39] megaraid_sas: call flush_scheduled_work during
 controller shutdown/detach
Date: Mon, 6 Feb 2017 12:28:35 +0100
Message-ID: <e7b80533-1cb2-051c-37e7-9d42858a4f3c@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:47649 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdBFL2h (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:28:37 -0500
In-Reply-To: <1486375212-17329-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 11:00 AM, Shivasharan S wrote:
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
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
