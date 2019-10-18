Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54201CA9EAB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 23:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F5D4222BD
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 23:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbfJRXRJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 19:17:09 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:36200 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbfJRXRJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 19:17:09 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 2FEE129F43;
        Fri, 18 Oct 2019 19:17:06 -0400 (EDT)
Date:   Sat, 19 Oct 2019 10:17:09 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Hannes Reinecke <hare@suse.de>, zhengbin <zhengbin13@huawei.com>,
        bvanassche@acm.org, jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        yi.zhang@huawei.com, yanaijie@huawei.com,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [RFC] scsi: Avoid sign extension when setting command result bytes,
 was Re: [PATCH v5 00/13] scsi: core: fix uninit-value access of variable
 sshdr
In-Reply-To: <yq1lftii2yi.fsf@oracle.com>
Message-ID: <alpine.LNX.2.21.1910191007480.12@nippy.intranet>
References: <1571387071-28853-1-git-send-email-zhengbin13@huawei.com>        <f9c663fe-6359-fc7b-e9f5-cf173f6fafbe@suse.de> <yq1lftii2yi.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Fri, 18 Oct 2019, Martin K. Petersen wrote:

>
> (Sorry, zhengbin, you opened a can of worms. This is some of our oldest
> and most arcane code in SCSI)
>

A call to set_host_byte(cmd, x) or set_msg_byte(cmd, x) when x & 0x80 is 
set clobbers the most significant bytes in cmd->result.

Avoid this implicit sign extension when shifting bits by using an
unsigned formal parameter.

This is a theoretical bug, found by inspection, so I'm sending an untested 
RFC patch.

I didn't try to find possible callers that might pass a negative parameter
and neither did I check whether the clobber might be intentional...

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 76ed5e4acd38..ae814fa68bb8 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -306,17 +306,17 @@ static inline struct scsi_data_buffer *scsi_prot(struct scsi_cmnd *cmd)
 #define scsi_for_each_prot_sg(cmd, sg, nseg, __i)		\
 	for_each_sg(scsi_prot_sglist(cmd), sg, nseg, __i)
 
-static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
+static inline void set_msg_byte(struct scsi_cmnd *cmd, unsigned char status)
 {
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
-static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
+static inline void set_host_byte(struct scsi_cmnd *cmd, unsigned char status)
 {
 	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
 }
 
-static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
+static inline void set_driver_byte(struct scsi_cmnd *cmd, unsigned char status)
 {
 	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
 }
