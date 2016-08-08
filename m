From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Mon, 8 Aug 2016 07:54:46 -0700
Message-ID: <a11d7b6f-8cad-f658-20b3-960d3c215bcd@acm.org>
References: <20160801175948.GA6685@redhat.com>
	<4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com>
	<20160804235850.GB13132@redhat.com>
	<1649218.8261013.1470359248073.JavaMail.zimbra@redhat.com>
	<1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com>
	<73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com>
	<1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com>
	<ae1a211d-9351-e5fa-e3cb-0a9ba5be9dcd@acm.org>
	<1978328717.106590.1470660359078.JavaMail.zimbra@redhat.com>
	<20160808134440.67am2eafnd4yrkxl@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.43]:42394 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751473AbcHHPXG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2016 11:23:06 -0400
In-Reply-To: <20160808134440.67am2eafnd4yrkxl@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Laurence Oberman <loberman@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On 08/08/16 06:44, Johannes Thumshirn wrote:
> So __scsi_remove_device() is also checking for sdev->sdev_state == SDEV_DEL
> and returns if so. If it would have the chance to do so the goto restart would
> be hit and we'd reatart the list traverse. The if in turn just continues and
> I've seen endless loops with this pattern (check the 40998193560 ->
> 90a88d6ef88edc -> f05795d3d771f30a7bd commit chain).
>
> Might want to give the below patch a shot?
>
>
>>From fee838ebfea88b581994b3f855eab8da20b07fc9 Mon Sep 17 00:00:00 2001
> From: Johannes Thumshirn <jthumshirn@suse.de>
> Date: Mon, 8 Aug 2016 15:41:09 +0200
> Subject: [PATCH] scsi: restart full list search when re-encountering a deleted device
>
> __scsi_remove_device() already checks for reentrency with a deleted device,
> so there's no need to do it in scsi_forget_host() as well.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_scan.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e0a78f5..1c5a4d6 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1890,8 +1890,6 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> -			continue;
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		__scsi_remove_device(sdev);
>  		goto restart;

Hello Johannes,

Sorry but I do not agree with this patch. This patch will namely cause 
scsi_forget_host() to busy-wait until 
scsi_device_dev_release_usercontext() is called if it encounters a SCSI 
device on the host list that is in state SDEV_DEL. Additionally, I don't 
see how this patch can avoid an endless loop.

Thanks,

Bart.
