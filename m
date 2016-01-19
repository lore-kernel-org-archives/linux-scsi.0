From: Dmitry Katsubo <dma_k@mail.ru>
Subject: Re: How to set DPOFUA=0 ?
Date: Tue, 19 Jan 2016 23:10:37 +0100
Message-ID: <569EB45D.1020102@mail.ru>
References: <n5kqb4$k8n$1@ger.gmane.org> <569EA17B.7050601@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fallback7.mail.ru ([94.100.181.128]:60432 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbcASWOJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 17:14:09 -0500
In-Reply-To: <569EA17B.7050601@mail.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Cc: linux-scsi@vger.kernel.org

> Solved:
> 
> By installing a the latest kernel and headers from Debian backports solved the 
> problem:
> 
> apt-get -t jessie-backports install linux-image-amd64 linux-headers-amd64
> 
> Info about backports configuration:
> http://backports.debian.org/Instructions/
> 
> # uname -a
> Linux panther 4.2.0-0.bpo.1-amd64 #1 SMP Debian 4.2.6-3~bpo8+2 (2015-12-14) 
> x86_64 GNU/Linux
> 
> After this nigtmare-ish experience I would suggest the debian maintainers
> to trash the default jessie kernel 3.16 and replace it with the above
> 4.2 kernel; otherwise unexperienced users will wonder why their new SSD etc.
> isn't working in debian/ubuntu & co., as happened to me... :-(

I have missed that your message. Solved? Amazing, because the patch I had in
mind was not applied to 4.2.6. Also the device you are reporting has different
productId. I think that in newer kernels (4.x) another driver is used (UAS),
which has already given device logged as "special", see

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/usb/storage/unusual_uas.h#n145

/* Reported-by: Takeo Nakayama <javhera@gmx.com> */
UNUSUAL_DEV(0x357d, 0x7788, 0x0000, 0x9999,
		"JMicron",
		"JMS566",
		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
		US_FL_NO_REPORT_OPCODES),

However it does not have US_FL_BROKEN_FUA flag set. Mystery.

-- 
With best regards,
Dmitry
