From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Tue, 9 Aug 2016 10:16:52 -0700
Message-ID: <ad12fd05-f931-30a5-2efd-3d8a171a73cb@sandisk.com>
References: <20160801175948.GA6685@redhat.com>
 <1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com>
 <SN1PR0201MB1870C587B123A8F84A49C1BD811B0@SN1PR0201MB1870.namprd02.prod.outlook.com>
 <551419047.135340.1470669997660.JavaMail.zimbra@redhat.com>
 <077d2708-3360-d8d7-fb3c-d3a73a1e03ee@sandisk.com>
 <1345038259.188657.1470696767844.JavaMail.zimbra@redhat.com>
 <1771573384.192110.1470701350622.JavaMail.zimbra@redhat.com>
 <2aaad6b7-bfa4-b965-53bf-4420fe01d3e5@sandisk.com>
 <1494059467.386778.1470762767417.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0048.outbound.protection.outlook.com ([104.47.37.48]:40112
	"EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752234AbcHIRRC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2016 13:17:02 -0400
In-Reply-To: <1494059467.386778.1470762767417.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 08/09/2016 10:12 AM, Laurence Oberman wrote:
> I was talking about this patch
>
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1890,10 +1890,11 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   restart:
>          spin_lock_irqsave(shost->host_lock, flags);
>          list_for_each_entry(sdev, &shost->__devices, siblings) {
> -                if (sdev->sdev_state == SDEV_DEL)
> +                if (sdev->sdev_state == SDEV_DEL || scsi_device_get(sdev) < 0)
>                          continue;
>                  spin_unlock_irqrestore(shost->host_lock, flags);
>                  __scsi_remove_device(sdev);
> +                scsi_device_put(sdev);
>                  goto restart;
>          }
>          spin_unlock_irqrestore(shost->host_lock, flags);

Hello Laurence,

Did you run your tests with that patch applied? If so, it would help if 
you could rerun your tests without that patch. If the above patch makes 
a difference it means that it can happen that __scsi_remove_device() 
does not change the device state into SDEV_DEL. That's a bug and we need 
to know whether or not __scsi_remove_device() behaves correctly.

Thanks,

Bart.
