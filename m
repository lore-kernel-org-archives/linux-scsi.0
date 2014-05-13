From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2] iscsi_ibft: Fix finding Broadcom specific ibft sign
Date: Tue, 13 May 2014 07:41:32 -0400
Message-ID: <1399981292-11054-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:15843 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbaEMMNY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2014 08:13:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu, pjones@redhat.com, konrad@kernel.org
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com, iscsi-driver@qlogic.com

=46rom: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Search for Broadcom specific ibft sign "BIFT"
along with other possible values on UEFI

This patch is fix for regression introduced in
=E2=80=9C935a9fee51c945b8942be2d7b4bae069167b4886=E2=80=9D.
https://lkml.org/lkml/2011/12/16/353

This impacts Broadcom CNA for iSCSI Boot on UEFI platform.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/firmware/iscsi_ibft.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibf=
t.c
index 3ee852c..071c2c9 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -756,6 +756,7 @@ static const struct {
 	 */
 	{ ACPI_SIG_IBFT },
 	{ "iBFT" },
+	{ "BIFT" },	/* Broadcom iSCSI Offload */
 };
=20
 static void __init acpi_find_ibft_region(void)
--=20
1.8.2.GIT

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
