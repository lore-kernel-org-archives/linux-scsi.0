From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: [PATCH] mptsas: fixed hot-removal processing
Date: Tue, 20 Jul 2010 09:30:00 +0900
Message-ID: <4C44EE08.4080500@jp.fujitsu.com>
References: <4BBC5BB4.2050805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42545 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab0GTAbQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jul 2010 20:31:16 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o6K0VEuQ025668
	for <linux-scsi@vger.kernel.org> (envelope-from tokunaga.keiich@jp.fujitsu.com);
	Tue, 20 Jul 2010 09:31:14 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id AF12645DE55
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jul 2010 09:31:09 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 1807845DE4F
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jul 2010 09:31:08 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 918431DB8016
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jul 2010 09:31:07 +0900 (JST)
Received: from m025.s.css.fujitsu.com (m025.s.css.fujitsu.com [10.0.81.65])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 4813F1DB8014
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jul 2010 09:31:07 +0900 (JST)
In-Reply-To: <4BBC5BB4.2050805@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Desai Kashyap <kashyap.desai@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Kei Tokunaga wrote:
> Hi Kashyap,
> 
> This patch fixes mptsas disk hot-removal processing.  The
> hot-removal processing doesn't complete because of this condition.
> 
>   drivers/message/fusion/mptsas.c:
>   mptsas_taskmgmt_complete()
> 
>   if ((mptsas_find_vtarget(ioc, channel, id)) && !ioc->fw_events_off)
>     mptsas_queue_device_delete(...);
> 
> mptsas_queue_device_delete(), which must be called for
> hot-removal, never gets called because mptsas_find_vtarget()
> always returns 0 here.  At that time, the vtarget has already
> been freed in mptsas_target_destroy(), and also the scsi_device
> has been marked as SDEV_DEL.
> 
> As a result of the issue, port deletion functions won't get
> called and the device ends up being in an incomplete state.
> (Some data structures and sysfs entries, which should be
> removed in hot-removal, remain.)  One side effect of this is
> that a hot-addition of the device (bringing the device back
> on) fails.
> 
> This patch just removes mptsas_find_vtarget() from the if-state
> condition.
> 
> This applies to 2.6.34-rc3.

Kashyap, can you please give it an ACK?  I confirmed it still
applies to the latest git tree (scsi-misc-2.6).

Thanks,
Kei


> Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> ---
> 
>  linux-2.6.34-rc3-kei/drivers/message/fusion/mptsas.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/message/fusion/mptsas.c~fix-mptsas_hot_removal drivers/message/fusion/mptsas.c
> --- linux-2.6.34-rc3/drivers/message/fusion/mptsas.c~fix-mptsas_hot_removal	2010-04-07 16:47:36.000000000 +0900
> +++ linux-2.6.34-rc3-kei/drivers/message/fusion/mptsas.c	2010-04-07 16:48:17.000000000 +0900
> @@ -1221,7 +1221,7 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *io
>  	 * enable work queue to remove device from upper layers
>  	 */
>  	list_del(&target_reset_list->list);
> -	if ((mptsas_find_vtarget(ioc, channel, id)) && !ioc->fw_events_off)
> +	if (!ioc->fw_events_off)
>  		mptsas_queue_device_delete(ioc,
>  			&target_reset_list->sas_event_data);
>  
> 
> _
> 
> 
> 
> 
> 

