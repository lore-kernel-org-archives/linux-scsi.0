Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4301BC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCITbj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCITao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:44 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3E1FC7F7
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:54 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id n6so3120612plf.5
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xct695NTdKunJwZpBlsAMpxZPmRVUZn+AcEa7DsrRUQ=;
        b=YCgPRdxMA1AnrgFCi+IzajUolaBiqXrS3PUkgec16ruNTX6goGhKy0zyyQz/LanWGI
         JzS4Dh1bty25qsxTvA1GD8IF/g54LtsFfQjI0IaBxHNQ4DMhwKwIGH6j8uLsUCTA5RRF
         UQh796pJEsj1Bi/vX/+9/Zg8ayBYuq0Qz/lYM+NfZbIoq92HyP0Ber7MnqnvuzcgyXqH
         Km1wef+5agbH+cxzQtDIG6dRL1NFPDEf9dd+ETV354/hqR1TEkmyqxI4XYTnbTzsbI8X
         chdGxKQxMkEFDOT79wHj1JtaJG4fTrYvbncuK/vNxQkCnNhBGhoLTrjQZl4a84zrNU5C
         OcfA==
X-Gm-Message-State: AO0yUKVFRzSefZz7KrCdPjwZ1JFacBy3i6adMEORIzIbUib5PdF1MJEH
        5/z+bSTfOSWBUc2/6NLJ9yo=
X-Google-Smtp-Source: AK7set+sPR1u98txrByEUci1KeG7GLp+QSMAyVzJg0tTbyw6nHbC0SL/uNuYBDeMd/eXBSsmb0Mnuw==
X-Received: by 2002:a05:6a20:d49b:b0:c7:5cd8:f851 with SMTP id im27-20020a056a20d49b00b000c75cd8f851mr21948849pzb.51.1678390194328;
        Thu, 09 Mar 2023 11:29:54 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:53 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 67/82] scsi: qla1280: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:59 -0800
Message-Id: <20230309192614.2240602-68-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 1e7f4d138e06..6e5e89aaa283 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4115,7 +4115,7 @@ qla1280_get_token(char *str)
 }
 
 
-static struct scsi_host_template qla1280_driver_template = {
+static const struct scsi_host_template qla1280_driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "qla1280",
 	.name			= "Qlogic ISP 1280/12160",
