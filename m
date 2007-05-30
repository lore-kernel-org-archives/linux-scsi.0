From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kexec and aacraid broken
Date: Tue, 29 May 2007 19:13:47 -0700
Message-ID: <20070529191347.9b1edd8b.akpm@linux-foundation.org>
References: <86802c440705291859y39a4ca27uf5ddb84810f33510@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbXE3CN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 May 2007 22:13:57 -0400
In-Reply-To: <86802c440705291859y39a4ca27uf5ddb84810f33510@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, aacraid@adaptec.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

On Tue, 29 May 2007 18:59:32 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> latest tree, can not use kexec to load 2.6.22-rc3 at least.
> 
> got:
> 
> AAC0: adapter kernel panic'd fffffffd
> AAC0: adapter kernel failed to start, init status=0

One of the two diffs below, I guess.  Please do a `patch -R -p1' of this
email and retest?

> 
> but can load 2.6.21.3
> 

Michal, can you please add this to the regression list?




commit 9e4d4a5d71d673901d9c1df5146ce545c2cc0cc0
Author: Salyzyn, Mark <mark_salyzyn@adaptec.com>
Date:   Tue May 1 11:43:06 2007 -0400

    [SCSI] aacraid: superfluous adapter reset for IBM 8 series ServeRAID controllers
    
    The kexec patch introduced a superfluous (and otherwise inert) reset of
    some adapters. The register can have a hardware default value that has
    zeros for the undefined interrupts. This patch refines the test of the
    interrupt enable register to focus on only the interrupts that affect
    the driver in order to detect if an incomplete shutdown of the Adapter
    had occurred (kdump).
    
    Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index b6ee3c0..291cd14 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -542,7 +542,7 @@ int _aac_rx_init(struct aac_dev *dev)
 	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
 	dev->a_ops.adapter_enable_int = aac_rx_disable_interrupt;
 	dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
-	if ((((status & 0xff) != 0xff) || reset_devices) &&
+	if ((((status & 0x0c) != 0x0c) || reset_devices) &&
 	  !aac_rx_restart_adapter(dev, 0))
 		++restart;
 	/*
commit a5694ec545a880f9d23463fddc894f5096cc68fa
Author: Salyzyn, Mark <mark_salyzyn@adaptec.com>
Date:   Mon Apr 30 13:22:24 2007 -0400

    [SCSI] aacraid: kexec fix (reset interrupt handler)
    
    Another layer on this onion also discovered by Duane, the
    interrupt enable handler also needed to be set ... The interrupt enable
    was called from within the synchronous command handler.
    
    Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 0c71315..b6ee3c0 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -539,6 +539,8 @@ int _aac_rx_init(struct aac_dev *dev)
 	}
 
 	/* Failure to reset here is an option ... */
+	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
+	dev->a_ops.adapter_enable_int = aac_rx_disable_interrupt;
 	dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
 	if ((((status & 0xff) != 0xff) || reset_devices) &&
 	  !aac_rx_restart_adapter(dev, 0))

