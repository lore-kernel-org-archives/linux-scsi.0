Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A891DC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 07:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87D3D2088E
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 07:32:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mGd0jlJE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgE1HcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 03:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgE1HcH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 03:32:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEB0C05BD1E;
        Thu, 28 May 2020 00:32:06 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id nu7so2712712pjb.0;
        Thu, 28 May 2020 00:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5yZQIGMYiVPY5h18FvZodR8RDlk59u/8VE8/pzlbR3w=;
        b=mGd0jlJENSJp8gOh04gBoYQd/gn3/3FX18LV1iXU+RjRDJa1jIgdtzY7EsbdIKbq1K
         9KrEoXlYbCBRhOeub1L0OKhgB1BeJfw9hX8R1WE0nwcTxhDrcoxJwU4ecGlUvewfgnzJ
         qKNb25o7R9FUO5PAV9EA5blEKT7NhOaTt1OAAhPHDvgL5fdnqS4Lk00rHmdIeMD9iHjX
         C+i6XvD9cD7/0NSS+KqBS6N9znJWNtSRC1sBszNKAPCQCrdwpK/PEYiGu7WT38UK46gk
         7xH3jFHYad7gRF5LnWonJEq8TYy8dw1sm7JDiEDv2WYkkTFG3wjY9zooVPVHj8jkhdSz
         4kXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5yZQIGMYiVPY5h18FvZodR8RDlk59u/8VE8/pzlbR3w=;
        b=XZwMWhIXGN7fZpPJisEGk7g0hEAxMSo7KUAepTdlZxbDcDxlO4zUmFqM5AJBFRnJlK
         X0Iu1OWJLXOuSNJYuBxxn6jaWwlIZuIRjJy/HXK6Sp98Dhm95+Z5VG4g+QOnRPcnCmte
         YnB9swD/DgAkqnN7Fmr/6T2aO30Ko8d1NxHgip7CbiT8jKPTgR1z5/c8BFrOqL72wR7H
         JD0uqS9rXmQekG9CdxI+ae7GPWBOC7a9167yzCsR32RFSsyxdTlFxyYTkz3I4tYPj9Ls
         9wM/PxkmXg7RDL/mkCV2pN6kpiC1OFY7SH4ZlcBHfSY4790tuYye0yKn/+xdS+ctw8hl
         oUsg==
X-Gm-Message-State: AOAM533zIZvAlVE4Tu9GU8SutGMescIKpZxb5j1IHLX/O6UAv+br4T6U
        0tqfGX7YIMsDcxknVB8mKQ==
X-Google-Smtp-Source: ABdhPJxcHAiGb3cR67Py3+uLUxchrLMIS5xTg8PaCiR/WIh3MXNqxcixXVmIONgmWv6QMVtBOnCjQQ==
X-Received: by 2002:a17:90a:a613:: with SMTP id c19mr2350193pjq.155.1590651126100;
        Thu, 28 May 2020 00:32:06 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 10sm3980395pfx.138.2020.05.28.00.32.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 00:32:05 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: newtongao@tencent.com
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoming Gao <newtongao@tencent.com>
Subject: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused by JBOD
Date:   Thu, 28 May 2020 15:31:55 +0800
Message-Id: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiaoming Gao <newtongao@tencent.com>

when kernel crash, and kexec into kdump kernel, megaraid_sas will hung and
print follow error logs

24.1485901 sd 0:0:G:0: [sda 1 tag809 BRCfl Debug mfi stat 0x2(1, data len requested/conpleted 0X100
0/0x0)]
24.1867171 sd 0:0:G :9: [sda I tag861 BRCfl Debug mfft stat 0x2d, data len reques ted/conp1e Led 0X100
0/0x0]
24.2054191 sd 0:O:6:O: [sda 1 tag861 FAILED Result: hustbyte=DIDGK drioerbyte-DRIUCR SENSE]
24.2549711 bik_update_ request ! 1/0 error , dev sda, sector 937782912 op 0x0:(READ) flags 0x0 phys_seg 1 prio class
21.2752791 buffer_io_error 2 callbacks suppressed
21.2752731 Duffer IO error an dev sda, logical block 117212064, async page read

this bug is caused by commit '59db5a931bbe73f ("scsi: megaraid_sas: Handle sequence JBOD map failure at
 driver level
")'
and can be fixed by not set JOB when reset_devices on

Signed-off-by: Xiaoming Gao <newtongao@tencent.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b2ad965..24e7f1b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3127,7 +3127,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 		<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
 
 	/* If FW supports PD sequence number */
-	if (instance->support_seqnum_jbod_fp) {
+	if (!reset_devices && instance->support_seqnum_jbod_fp) {
 		if (instance->use_seqnum_jbod_fp &&
 			instance->pd_list[pd_index].driveType == TYPE_DISK) {
 
-- 
1.8.3.1

