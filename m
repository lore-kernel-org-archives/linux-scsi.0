From: David Rientjes <rientjes@google.com>
Subject: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
Date: Tue, 24 May 2011 16:53:50 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:55634 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab1EXXxz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2011 19:53:55 -0400
Received: from hpaq3.eem.corp.google.com (hpaq3.eem.corp.google.com [172.25.149.3])
	by smtp-out.google.com with ESMTP id p4ONrrt9013647
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2011 16:53:53 -0700
Received: from pzk37 (pzk37.prod.google.com [10.243.19.165])
	by hpaq3.eem.corp.google.com with ESMTP id p4ONrCqh005763
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2011 16:53:52 -0700
Received: by pzk37 with SMTP id 37so3637550pzk.29
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2011 16:53:51 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The Cisco FNIC driver requires creating a SLAB_CACHE_DMA cache, which is
not possible if CONFIG_ZONE_DMA is disasbled.  Avoid compiling it without
DMA support.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -688,7 +688,7 @@ config FCOE
 
 config FCOE_FNIC
 	tristate "Cisco FNIC Driver"
-	depends on PCI && X86
+	depends on PCI && X86 && ZONE_DMA
 	select LIBFCOE
 	help
 	  This is support for the Cisco PCI-Express FCoE HBA.
