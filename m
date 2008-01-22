From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] fix /proc/scsi/sg/devices when no SCSI devices
Date: Tue, 22 Jan 2008 23:11:26 +0100
Message-ID: <47966A0E.10900@torque.net>
References: <4796514D.6010908@cybernetics.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33887 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYAVWLe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 17:11:34 -0500
In-Reply-To: <4796514D.6010908@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Tony Battersby wrote:
> The patch "[SCSI] sg: use idr to replace static arrays" in 2.6.24-rc1
> causes a bogus line to appear in /proc/scsi/sg/devices containing
> "-1 -1 -1 -1 -1 -1 -1 -1 -1" when there are no SCSI devices in the
> system.  In 2.6.23, /proc/scsi/sg/devices is empty when there are no
> SCSI devices in the system.  A similar problem exists with
> /proc/scsi/sg/device_strs.  The following patch restores the behavior
> of 2.6.23.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> --- linux-2.6.24-rc8-git5/drivers/scsi/sg.c.orig	2008-01-22 15:08:46.000000000 -0500
> +++ linux-2.6.24-rc8-git5/drivers/scsi/sg.c	2008-01-22 15:09:05.000000000 -0500
> @@ -2521,7 +2521,7 @@ sg_idr_max_id(int id, void *p, void *dat
>  static int
>  sg_last_dev(void)
>  {
> -	int k = 0;
> +	int k = -1;
>  	unsigned long iflags;
>  
>  	read_lock_irqsave(&sg_index_lock, iflags);
> 
> 
> -

Tony,
Thanks.

Signed-off-by: Douglas Gilbert <dougg@torque.net>
