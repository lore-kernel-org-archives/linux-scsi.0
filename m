From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Set max_sectors for tmscsim (take 2)
Date: Fri, 6 Oct 2006 00:11:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0610060007050.14466@poirot.grange>
References: <Pine.LNX.4.60.0610020028230.4088@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:48342 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932322AbWJEWLI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 18:11:08 -0400
In-Reply-To: <Pine.LNX.4.60.0610020028230.4088@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@steeleye.com>

On Mon, 2 Oct 2006, Guennadi Liakhovetski wrote:

> The patch below depends on the previous one "enable clustering". I hope my 
> calculations are correct, and 0x8000 is the correct value for tmscsim. 
> Please, correct me if I am wrong. 16MiB are configured by setting all 24 
> bits to 0. Don't know if this works though.

Following suggestion from Jeff Garzik limit max_sectors to the value I can 
actually test, i.e., 8MB. Therefore, version 2:

Thanks
Guennadi
---
Guennadi Liakhovetski

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

AM53C974A's Start Transfer Counter register has 24 bits, thus
maximum transfer length is 16MiB. But the maximum I can test
is 8MiB, so use that until somebody tests 16MiB.

diff -u a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	2006-10-02 00:21:56.000000000 +0200
+++ b/drivers/scsi/tmscsim.c	2006-10-02 00:21:46.000000000 +0200
@@ -2304,6 +2304,7 @@
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.max_sectors		= 0x4000, /* 8MiB = 16 * 1024 * 512 */
 };
 
 /***********************************************************************
