From: James Smart <James.Smart@Emulex.Com>
Subject: [Cancel][PATCH] Close list corruption window in __scsi_iterate_devices
Date: Tue, 21 Feb 2006 18:51:57 -0500
Message-ID: <43FBA79D.2060302@emulex.com>
References: <43FB9407.7010102@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:9689 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1161237AbWBUXwV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 18:52:21 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1LNqJrf029549
	for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2006 15:52:20 -0800 (PST)
In-Reply-To: <43FB9407.7010102@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Sorry folks - cold medicine had me seeing things.  Ignore this.

-- james s

James Smart wrote:
> The existing code could allow the use of a list pointer that is
> grabbed prior to the lock, changes while waiting for the lock, thus
> is no longer valid while the lock is held.
> 
> -- james s
> 
> --- a/drivers/scsi/scsi.c    2006-02-06 06:01:12.000000000 -0500
> +++ b/drivers/scsi/scsi.c.NEW    2006-02-21 17:30:31.000000000 -0500
> @@ -1015,11 +1015,12 @@ EXPORT_SYMBOL(scsi_device_put);
>  struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
>                         struct scsi_device *prev)
>  {
> -    struct list_head *list = (prev ? &prev->siblings : &shost->__devices);
> +    struct list_head *list;
>      struct scsi_device *next = NULL;
>      unsigned long flags;
> 
>      spin_lock_irqsave(shost->host_lock, flags);
> +    list = (prev ? &prev->siblings : &shost->__devices);
>      while (list->next != &shost->__devices) {
>          next = list_entry(list->next, struct scsi_device, siblings);
>          /* skip devices that we can't get a reference to */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
