Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D5CECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 06:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiIIGyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 02:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIIGyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 02:54:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB79371AA
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 23:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BDBCB82353
        for <linux-scsi@vger.kernel.org>; Fri,  9 Sep 2022 06:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4D2C433D6;
        Fri,  9 Sep 2022 06:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662706489;
        bh=s9MEfc6GOGidupMiWFStH5ZcnhpSIX4d5GFBEFZkmzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=igHQXyCmY1BzGLSXMwZaVlogmBu/UqwaC7k9VMliFB/RqRzOqo7ESgF1AbIIgRRwZ
         BoC21X34IZJHyazo35XHsQKhkL7+oOiW4obMz6QYDL0rQDqUzBA09b6sN70CqWHDqc
         lHfadbnGgIQ6aBuMq833OXSWXZODaFc5dfTIHzK8=
Date:   Fri, 9 Sep 2022 08:54:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi@vger.kernel.org, hdthky <hdthky0@gmail.com>,
        stable <stable@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2] scsi: stex: properly zero out the passthrough command
 structure
Message-ID: <YxrjN3OOw2HHl9tx@kroah.com>
References: <20220908145154.2284098-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908145154.2284098-1-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

The passthrough structure is declared off of the stack, so it needs to
be set to zero before copied back to userspace to prevent any
unintentional data leakage.  Switch things to be statically allocated
which will fill the unused fields with 0 automatically.

Reported-by: hdthky <hdthky0@gmail.com>
Cc: stable <stable@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 v2: Linus's updated version that moves the initialization to be
     statically defined and changes the function prototype and structure
     to be const.

 drivers/scsi/stex.c      | 17 +++++++++--------
 include/scsi/scsi_cmnd.h |  2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index e6420f2127ce..8def242675ef 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -665,16 +665,17 @@ static int stex_queuecommand_lck(struct scsi_cmnd *cmd)
 		return 0;
 	case PASSTHRU_CMD:
 		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
-			struct st_drvver ver;
+			const struct st_drvver ver = {
+				.major = ST_VER_MAJOR,
+				.minor = ST_VER_MINOR,
+				.oem = ST_OEM,
+				.build = ST_BUILD_VER,
+				.signature[0] = PASSTHRU_SIGNATURE,
+				.console_id = host->max_id - 1,
+				.host_no = hba->host->host_no,
+			};
 			size_t cp_len = sizeof(ver);
 
-			ver.major = ST_VER_MAJOR;
-			ver.minor = ST_VER_MINOR;
-			ver.oem = ST_OEM;
-			ver.build = ST_BUILD_VER;
-			ver.signature[0] = PASSTHRU_SIGNATURE;
-			ver.console_id = host->max_id - 1;
-			ver.host_no = hba->host->host_no;
 			cp_len = scsi_sg_copy_from_buffer(cmd, &ver, cp_len);
 			if (sizeof(ver) == cp_len)
 				cmd->result = DID_OK << 16;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bac55decf900..7d3622db38ed 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -201,7 +201,7 @@ static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)
 	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
 
 static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
-					   void *buf, int buflen)
+					   const void *buf, int buflen)
 {
 	return sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
 				   buf, buflen);
-- 
2.37.3

