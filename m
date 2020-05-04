Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883B4C4725B
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 668622078E
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MWnLEWT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgEDN75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 09:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728075AbgEDN74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 09:59:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BA0C061A10;
        Mon,  4 May 2020 06:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=MnSj/BtVC/3qSedLLZfwZqKVQadRPd+EPOwX1mY338M=; b=MWnLEWT9fJzYdWK43e2CJCAzsC
        BP/Hn/IuDRVMLHw1tcPegdsNJTqwhKwQyZl+7M6mAAgnSDx6h6+x4ertLyCg95GKn5dWcuBV8P3sY
        STXHBe2DorjpYvX3HPrBDFLqW94q5uA2q4HNwzE5M4zoWZ1dTazGsEVsvWKFmdmHCJUAMDR23XaYC
        pwYayQb6X7VNwWy0FCiJ7zZy/T+2fbd40o6YBGhXwAoi+1et7VbWZm9vn6t5qp8BjDelhFAx6IyAn
        VL34vEZunPWKcglWzwHKCbljgWCE45BKq57bb8DBC+3qV1qso8R+OhojnxRn9aC0yaENrrcAXPzKY
        CqtExYTA==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jVbdA-0007Z5-75; Mon, 04 May 2020 13:59:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/8] ide-cd: rename cdrom_read_tocentry
Date:   Mon,  4 May 2020 15:59:21 +0200
Message-Id: <20200504135927.2835750-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504135927.2835750-1-hch@lst.de>
References: <20200504135927.2835750-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Give the cdrom_read_tocentry function and ide_ prefix to not conflict
with the soon to be added generic function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de
---
 drivers/ide/ide-cd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 40e124eb918aa..7f17f83039888 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1034,8 +1034,8 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	return 0;
 }
 
-static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
-				int format, char *buf, int buflen)
+static int ide_cdrom_read_tocentry(ide_drive_t *drive, int trackno,
+		int msf_flag, int format, char *buf, int buflen)
 {
 	unsigned char cmd[BLK_MAX_CDB];
 
@@ -1104,7 +1104,7 @@ int ide_cd_read_toc(ide_drive_t *drive)
 				     sectors_per_frame << SECTOR_SHIFT);
 
 	/* first read just the header, so we know how long the TOC is */
-	stat = cdrom_read_tocentry(drive, 0, 1, 0, (char *) &toc->hdr,
+	stat = ide_cdrom_read_tocentry(drive, 0, 1, 0, (char *) &toc->hdr,
 				    sizeof(struct atapi_toc_header));
 	if (stat)
 		return stat;
@@ -1121,7 +1121,7 @@ int ide_cd_read_toc(ide_drive_t *drive)
 		ntracks = MAX_TRACKS;
 
 	/* now read the whole schmeer */
-	stat = cdrom_read_tocentry(drive, toc->hdr.first_track, 1, 0,
+	stat = ide_cdrom_read_tocentry(drive, toc->hdr.first_track, 1, 0,
 				  (char *)&toc->hdr,
 				   sizeof(struct atapi_toc_header) +
 				   (ntracks + 1) *
@@ -1141,7 +1141,7 @@ int ide_cd_read_toc(ide_drive_t *drive)
 		 * Heiko Eißfeldt.
 		 */
 		ntracks = 0;
-		stat = cdrom_read_tocentry(drive, CDROM_LEADOUT, 1, 0,
+		stat = ide_cdrom_read_tocentry(drive, CDROM_LEADOUT, 1, 0,
 					   (char *)&toc->hdr,
 					   sizeof(struct atapi_toc_header) +
 					   (ntracks + 1) *
@@ -1181,7 +1181,7 @@ int ide_cd_read_toc(ide_drive_t *drive)
 
 	if (toc->hdr.first_track != CDROM_LEADOUT) {
 		/* read the multisession information */
-		stat = cdrom_read_tocentry(drive, 0, 0, 1, (char *)&ms_tmp,
+		stat = ide_cdrom_read_tocentry(drive, 0, 0, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp));
 		if (stat)
 			return stat;
@@ -1195,7 +1195,7 @@ int ide_cd_read_toc(ide_drive_t *drive)
 
 	if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
 		/* re-read multisession information using MSF format */
-		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
+		stat = ide_cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp));
 		if (stat)
 			return stat;
-- 
2.26.2

