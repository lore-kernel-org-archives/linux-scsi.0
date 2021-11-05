Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B987C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 09:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3D9A61283
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 09:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhKEJJA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 05:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232847AbhKEJIz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 5 Nov 2021 05:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 301FF6125F;
        Fri,  5 Nov 2021 09:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636103172;
        bh=R8qodyw2m475khfL+DRSSu/VNh2gpTvr5DpjCjqYQa0=;
        h=Date:From:To:Cc:Subject:From;
        b=f6kE8T85zKSfS7aUEEKjJ80DjPCdn4cei3ieyxjDTaqJ2BtDeb41pYIRFZKmDFSO9
         b4j8WTItqnuGFEk9YG4n7JnDPkam1Uq9Qn8HeKERIPzIEu3AJlkouV33FZydrz6nFZ
         S3U36WmNLTfiTln3O8BpKqS7tBG8i3j/ZRbdAQ6ja6UwsXAvn7SPoL2p4UcMevpG7B
         x/KKIk9WSAbH7rXIkxUYdOU5Lgt7VldmstATmVPuAqyk/kLzyQSeo1f5triAa/g6iQ
         dFkwMGTKMg0yZWC69sbo84VxQdMZuki3UbFXRdGgB5clNxnaxbN0oTN7e9DBaw7QCv
         SQ3JyfMmuMmKA==
Date:   Fri, 5 Nov 2021 04:11:02 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH][next] scsi: Replace one-element arrays with flexible-array
 members
Message-ID: <20211105091102.GA126301@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use flexible-array members in struct fc_fdmi_attr_entry and
fs_fdmi_attrs instead of one-element arrays, and refactor the
code accordingly.

Also, turn the one-element array _port_ in struct fc_fdmi_rpl
into a simple object of type struct fc_fdmi_port_name, as it
seems there is no more than just one port expected:

$ git grep -nw numport drivers/scsi/
drivers/scsi/csiostor/csio_lnode.c:447: reg_pl->numport = htonl(1);
drivers/scsi/libfc/fc_encode.h:232:             put_unaligned_be32(1, &ct->payload.rhba.port.numport);

Also, this helps with the ongoing efforts to globally enable
-Warray-bounds and get us closer to being able to tighten the
FORTIFY_SOURCE routines on memcpy().

https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/csiostor/csio_lnode.c | 2 +-
 drivers/scsi/libfc/fc_encode.h     | 4 ++--
 include/scsi/fc/fc_ms.h            | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index d5ac93897023..cf9dd79ee488 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -445,7 +445,7 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	/* Register one port per hba */
 	reg_pl = (struct fc_fdmi_rpl *)pld;
 	reg_pl->numport = htonl(1);
-	memcpy(&reg_pl->port[0].portname, csio_ln_wwpn(ln), 8);
+	memcpy(&reg_pl->port.portname, csio_ln_wwpn(ln), 8);
 	pld += sizeof(*reg_pl);
 
 	/* Start appending HBA attributes hba */
diff --git a/drivers/scsi/libfc/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
index 74ae7fd15d8d..5806f99e4061 100644
--- a/drivers/scsi/libfc/fc_encode.h
+++ b/drivers/scsi/libfc/fc_encode.h
@@ -232,7 +232,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be32(1, &ct->payload.rhba.port.numport);
 		/* Port Name */
 		put_unaligned_be64(lport->wwpn,
-				   &ct->payload.rhba.port.port[0].portname);
+				   &ct->payload.rhba.port.port.portname);
 
 		/* HBA Attributes */
 		put_unaligned_be32(numattrs,
@@ -246,7 +246,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
 		put_unaligned_be64(lport->wwnn,
-				   (__be64 *)&entry->value[0]);
+				   (__be64 *)&entry->value);
 
 		/* Manufacturer */
 		entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
index 00191695233a..44fbe84fa664 100644
--- a/include/scsi/fc/fc_ms.h
+++ b/include/scsi/fc/fc_ms.h
@@ -158,7 +158,7 @@ struct fc_fdmi_port_name {
 struct fc_fdmi_attr_entry {
 	__be16		type;
 	__be16		len;
-	__u8		value[1];
+	__u8		value[];
 } __attribute__((__packed__));
 
 /*
@@ -166,7 +166,7 @@ struct fc_fdmi_attr_entry {
  */
 struct fs_fdmi_attrs {
 	__be32				numattrs;
-	struct fc_fdmi_attr_entry	attr[1];
+	struct fc_fdmi_attr_entry	attr[];
 } __attribute__((__packed__));
 
 /*
@@ -174,7 +174,7 @@ struct fs_fdmi_attrs {
  */
 struct fc_fdmi_rpl {
 	__be32				numport;
-	struct fc_fdmi_port_name	port[1];
+	struct fc_fdmi_port_name	port;
 } __attribute__((__packed__));
 
 /*
-- 
2.27.0

