From: akpm@linux-foundation.org
Subject: [patch for 2.6.29? 2/3] mpt: fix enable lsi sas to use msi as default
Date: Wed, 11 Feb 2009 13:13:40 -0800
Message-ID: <200902112113.n1BLDfAa012208@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756581AbZBKVOW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 16:14:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, yinghai@kernel.org, kadesai@lsi.com

From: Yinghai Lu <yinghai@kernel.org>

The third arg in module_param(,,) is perm instead of default value.  we
still need to assign default at first.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kashyap Desai <kadesai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~mpt-fix-enable-lsi-sas-to-use-msi-as-default drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mpt-fix-enable-lsi-sas-to-use-msi-as-default
+++ a/drivers/message/fusion/mptbase.c
@@ -90,8 +90,8 @@ module_param(mpt_msi_enable_fc, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
 		controllers (default=0)");
 
-static int mpt_msi_enable_sas;
-module_param(mpt_msi_enable_sas, int, 1);
+static int mpt_msi_enable_sas = 1;
+module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
 		controllers (default=1)");
 
_
