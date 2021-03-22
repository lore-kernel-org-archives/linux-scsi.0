Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9DBC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B40FD619AD
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhCVQrY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231304AbhCVQrH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 12:47:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3093560249;
        Mon, 22 Mar 2021 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616431626;
        bh=7jkwwQTMKRF9ZixAWWyF6DidhPZvbea3WyoahROBIyw=;
        h=From:To:Cc:Subject:Date:From;
        b=G8gq65AfreIBay9epyWXjQoS6rNig65gO8hvNqXH5F/0d3XGyxdKqaAcinh12c5cI
         TshE9ie+EEOgjybdaKWMBV/mSQ+G4AiUtfN9ySg5OY8qITWuD71GZ2QVlCi2tDKczt
         ihGwHVpod9PEWv51NVFg5eNrVo+KCH9h+i2OyOwjTKFEgwRFNd5laj7A8r3SP5b75m
         jTZ9Q6eDSB5bh8DwdlfVu2FCj9FMGkj/8pEGIajWSNcdIY3QW9dQLEpKuaWMntywJ+
         AO2mE2Ee4uFqt7be4EZiKpe5JBvn3i7Gu1y95B/E8z35NsJxBjwJPTR6zcGv6QiAZ3
         9WzYB8LZXL9xg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Love <robert.w.love@intel.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vasu Dev <vasu.dev@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fcoe: fix mismatched fcoe_wwn_from_mac declaration
Date:   Mon, 22 Mar 2021 17:46:59 +0100
Message-Id: <20210322164702.957810-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

An old cleanup changed the array size from MAX_ADDR_LEN to
unspecified in the declaration, but now gcc-11 warns about this:

drivers/scsi/fcoe/fcoe_ctlr.c:1972:37: error: argument 1 of type ‘unsigned char[32]’ with mismatched bound [-Werror=array-parameter=]
 1972 | u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
      |                       ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
In file included from /git/arm-soc/drivers/scsi/fcoe/fcoe_ctlr.c:33:
include/scsi/libfcoe.h:252:37: note: previously declared as ‘unsigned char[]’
  252 | u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
      |                       ~~~~~~~~~~~~~~^~~~~

Change the type back to what the function definition uses.

Fixes: fdd78027fd47 ("[SCSI] fcoe: cleans up libfcoe.h and adds fcoe.h for fcoe module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/scsi/libfcoe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 2568cb0627ec..fac8e89aed81 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -249,7 +249,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 			 struct fc_frame *);
 
 /* libfcoe funcs */
-u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
+u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
 int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 		      const struct libfc_function_template *, int init_fcp);
 u32 fcoe_fc_crc(struct fc_frame *fp);
-- 
2.29.2

