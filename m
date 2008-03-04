From: akpm@linux-foundation.org
Subject: [patch (for 2.6.25?) 1/2] mpt fusion: don't oops if NumPhys==0
Date: Tue, 04 Mar 2008 14:56:23 -0800
Message-ID: <200803042256.m24MuO5G001341@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbYCDW4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 17:56:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, olel@ans.pl, Eric.Moore@lsi.com, fujita.tomonori@lab.ntt.co.jp, ole@ans.pl, sathya.prakash@lsi.com

From: Krzysztof Oledzki <olel@ans.pl>

Don't oops if NumPhys==0, instead return -ENODEV.
This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=9909

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: Sathya Prakash <sathya.prakash@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptsas.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys==0 drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys==0
+++ a/drivers/message/fusion/mptsas.c
@@ -1701,6 +1701,11 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc
 	if (error)
 		goto out_free_consistent;
 
+	if (!buffer->NumPhys) {
+		error = -ENODEV;
+		goto out_free_consistent;
+	}
+
 	/* save config data */
 	port_info->num_phys = buffer->NumPhys;
 	port_info->phy_info = kcalloc(port_info->num_phys,
_
