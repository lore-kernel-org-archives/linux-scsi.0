Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BBFC43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 12:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3378A2078D
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 12:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIRMPm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 08:15:42 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55367 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRMPm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 08:15:42 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MhlCa-1kwiqN2nei-00dnUh; Fri, 18 Sep 2020 14:15:27 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, anand.lodnoor@broadcom.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 2/3] scsi: megaraid_sas: check user-provided offsets
Date:   Fri, 18 Sep 2020 14:15:22 +0200
Message-Id: <20200918121522.1466028-1-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918120955.1465510-1-arnd@arndb.de>
References: <20200918120955.1465510-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6kJPcwuHge9uT864Zf5TyvhQnlmxeK+RpOYT34mVoK7SAncOfq9
 1wvhRh03/TO74JK8VdAlLNISWQ5JFsbrhhGN08krYQ5ip4disf1Dbd4f2biDPp+wGScYwrk
 2eqIMN9aKY5vKPnBcr335Ny6XSIVuPsdE2ZYCeV/dH1z1t5zLmiLylvjF/EJwebLxJi7oyz
 c/wyKFRfXQ+XgvvduDU/Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y1hX+C4mHMY=:43H+a/hVFrzVJMDnWPMiay
 cx6NyNF/BlpGaJN2VMbhXKnFAUoAFIUL2o8vLIOvto/MOW22o0yxc6vbZrP+4pJ5ClXK0Jo5X
 pnr1oDmCnyoQr9dx7fzVXeiKj4sGLooEq5wEWP2c5e5zrTV5Sz/dtQU0vV4HsAPmVSeHIDqDv
 gEjwD7vIHAfesxccLMSReiW+X8cfXePqT5a8dfo6BYewocqUo/vhF+egLvLYZiUghSNzpefRj
 mWUdAu6vSbciUZaN8RgYVr9F4M1VC0mNRmvzehRL2oxJfgnTkueU0Gp+Ta5U6CbfVPAu+aPFq
 TxIbLHDZuMy0zd+P2n1ExQccEOoZiBZeZzYFasN6ToW0+01m//yuoNwnc5AsKdI6bDSJqecOx
 hqdkMmwYfDIkWiEDsi7QsPxbLraN59XYrbDKDO5aijgx/PBqCm2NCuyivOdy03b/X3DG0d/Td
 aYAhvgCm/KdBURelCzjc9ekESE4IrnNT8ORrcx7vIkSx95SupuvFT033NQ5hd3PkqW9sCSOZb
 ZkU1n1KGSztPAJj94sTngbby1LrqAM/VowTSXc57ml8oO1HhQoK/rXYXIZgJpSgxOuqmead/N
 Ssnw5VG1KbXAKySEc53MCZ6c5UQrfmu27A6z3Dt9ZjFq8AJEY+tij/Z0heNxrURLPBAWaAD24
 qq0ALub2s/SCZxpnf3kfQjYRv/pSioLhmkpWZd6+xZ7rdXVoR577B1aCazF+XXTnIJrDUTU9r
 iNzuzGiESeQFdIZd732y8c9SLlL26hd1lRDAPgdLIWTV3lob8LDc+HJp7m0TtC6Obl7uRa65f
 LP0PFw5RPoZFz4asTLDC4Qh9hBlFaMfn/h04eahR7OexB9VNaLfuq+SHRO88FAoTqjRYArz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It sounds unwise to let user space pass an unchecked 32-bit
offset into a kernel structure in an ioctl. This is an unsigned
variable, so checking the upper bound for the size of the structure
it points into is sufficient to avoid data corruption, but as
the pointer might also be unaligned, it has to be written carefully
as well.

While I stumbled over this problem by reading the code, I did not
continue checking the function for further problems like it.

Cc: <stable@vger.kernel.org> # v2.6.15+
Fixes: c4a3e0a529ab ("[SCSI] MegaRAID SAS RAID: new driver")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 861f7140f52e..c3de69f3bee8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8095,7 +8095,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	int error = 0, i;
 	void *sense = NULL;
 	dma_addr_t sense_handle;
-	unsigned long *sense_ptr;
+	void *sense_ptr;
 	u32 opcode = 0;
 	int ret = DCMD_SUCCESS;
 
@@ -8218,6 +8218,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	}
 
 	if (ioc->sense_len) {
+		/* make sure the pointer is part of the frame */
+		if (ioc->sense_off > (sizeof(union megasas_frame) - sizeof(__le64))) {
+			error = -EINVAL;
+			goto out;
+		}
+
 		sense = dma_alloc_coherent(&instance->pdev->dev, ioc->sense_len,
 					     &sense_handle, GFP_KERNEL);
 		if (!sense) {
@@ -8225,12 +8231,11 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 			goto out;
 		}
 
-		sense_ptr =
-		(unsigned long *) ((unsigned long)cmd->frame + ioc->sense_off);
+		sense_ptr = (void *)cmd->frame + ioc->sense_off;
 		if (instance->consistent_mask_64bit)
-			*sense_ptr = cpu_to_le64(sense_handle);
+			put_unaligned_le64(sense_handle, sense_ptr);
 		else
-			*sense_ptr = cpu_to_le32(sense_handle);
+			put_unaligned_le32(sense_handle, sense_ptr);
 	}
 
 	/*
-- 
2.27.0

