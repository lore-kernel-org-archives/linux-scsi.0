From: Tejun Heo <htejun@gmail.com>
Subject: Re: Disk spindown on rmmod sd_mod
Date: Fri, 26 Oct 2007 19:25:42 +0900
Message-ID: <4721C0A6.4000200@gmail.com>
References: <Pine.LNX.4.64.0710022050200.28124@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:1120 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXJZKZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2007 06:25:54 -0400
Received: by rv-out-0910.google.com with SMTP id k20so748964rvb
        for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 03:25:53 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0710022050200.28124@fbirervta.pbzchgretzou.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: James.Bottomley@steeleye.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Jan Engelhardt wrote:
> I am using 2.6.23-rc9 with pata_sis. `modprobe -r sd_mod`, which I ran 
> from initramfs, caused all my disks to spindown - sd even told me so.
> 
> I recall there has been talk a while back about whether to spin down 
> disks on shutdown or not, but I do not think it touched the removal of 
> sd_mod, did it? So either way, can someone fill me in why the spindown 
> is done?

The problem is that it's difficult to tell why a disk is going down from
sd_shutdown(), so it issues STOP unless system state is SYSTEM_RESTART.
 Maybe we need to issue STOP only for SYSTEM_HALT, SYSTEM_POWER_OFF and
SYSTEM_SUSPEND_DISK.

Thanks.

-- 
tejun
