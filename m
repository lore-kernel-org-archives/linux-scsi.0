From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Date: Thu, 17 Nov 2011 12:26:33 -0600
Message-ID: <1321554393.3041.77.camel@dabdike.int.hansenpartnership.com>
References: <1320776028-29568-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56442 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931Ab1KQS0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2011 13:26:37 -0500
In-Reply-To: <1320776028-29568-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, linux-scsi@vger.kernel.org, ohering@suse.com, hch@infradead.org

On Tue, 2011-11-08 at 10:13 -0800, K. Y. Srinivasan wrote:
> The storage driver (storvsc_drv.c) handles all block storage devices
> assigned to Linux guests hosted on Hyper-V. This driver has been in the
> staging tree for a while and this patch moves it out of the staging area.
> As per Greg's recommendation, this patch makes no changes to the staging/hv
> directory. Once the driver moves out of staging, we will cleanup the
> staging/hv directory.
> 
> This patch includes all the patches that I have sent against the staging/hv
> tree to address the comments I have gotten to date on this storage driver.

First comment is that it would have been easier to see the individual
patches for comment before you committed them.

The way you did mempool isn't entirely right: the problem is that to
prevent a memory to I/O deadlock we need to ensure forward progress on
the drain device.  Just having 64 commands available to the host doesn't
necessarily achieve this because LUN1 could consume them all and starve
LUN0 which is the drain device leading to the deadlock, so the mempool
really needs to be per device using slave_alloc.

+static int storvsc_device_alloc(struct scsi_device *sdevice)
+{
+	/*
+	 * This enables luns to be located sparsely. Otherwise, we may not
+	 * discovered them.
+	 */
+	sdevice->sdev_bflags |= BLIST_SPARSELUN | BLIST_LARGELUN;
+	return 0;
+}

Looks bogus ... this should happen automatically for SCSI-3 devices ...
unless your hypervisor has some strange (and wrong) identification?  I
really think you want to use SCSI-3 because it will do report LUN
scanning, which consumes far fewer resources.

I still think you need to disable clustering and junk the bvec merge
function.  Your object seems to be to accumulate in page size multiples
(and not aggregate over this) ... that's what clustering is designed to
do.

James


