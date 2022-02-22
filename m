Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2818DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbiBVOFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiBVOFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:05:12 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4824B15E6E1;
        Tue, 22 Feb 2022 06:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=zaFnzi56l+DVH/tvMxpA/BjkwjsaqH/prQTf/hPo21s=; b=QEcR5noF6Byk3dF4tP5/WDsCIr
        9rnp3ePh171ejdDc198mQ6aP9UGUR16vlRsxmf2ORuuCMMygtf9T5bzWKIoymlw+UCO5LWfJmqUey
        zrdLxmaKcnnLAGqDZUYhLI7nYTs7eT2TZSskVBJz+reZpCGN2JUT6y8snPOvlnQE7KnD0jmfFxUWE
        vISntbBmfVNSs+93owjq9PoMBzMPCgegCjtnY6pLuyuJlmuQC7sGk6UcfPIvZI3ThPkQR4nwlWF6J
        8HMPmY/FtChGrSMg+jubOFkbyACDAyFeUHc/PrHBi1+mdxKfUszYSUWD4J/BuR/glEpu9XHzR4qhq
        cnmvfl9g==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVmX-009nOW-F1; Tue, 22 Feb 2022 14:04:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: remove struct scsi_request
Date:   Tue, 22 Feb 2022 15:04:35 +0100
Message-Id: <20220222140443.589882-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

with the recent removal of the REQ_OP_SCSI_{IN,OUT} based passthrough
from non-scsi drivers, the need for the scsi_request structure went
away as well.  As all submitters of SCSI passthrough requests are using
the SCSI midlayer now they can just fill out the scsi_cmnd directly.

Diffstat:
 b/drivers/ata/libata-scsi.c           |    4 -
 b/drivers/block/pktcdvd.c             |    8 +-
 b/drivers/cdrom/cdrom.c               |    1 
 b/drivers/scsi/scsi_bsg.c             |   42 +++++-------
 b/drivers/scsi/scsi_debugfs.c         |    6 -
 b/drivers/scsi/scsi_error.c           |   38 +++++-----
 b/drivers/scsi/scsi_ioctl.c           |   75 +++++++++------------
 b/drivers/scsi/scsi_lib.c             |  119 ++++++++++++++--------------------
 b/drivers/scsi/scsi_logging.c         |    5 -
 b/drivers/scsi/scsi_transport_sas.c   |    1 
 b/drivers/scsi/sd.c                   |   28 --------
 b/drivers/scsi/sg.c                   |   44 ++++--------
 b/drivers/scsi/sr.c                   |   30 ++++----
 b/drivers/scsi/st.c                   |   30 ++++----
 b/drivers/scsi/ufs/ufshpb.c           |   22 ++----
 b/drivers/target/target_core_pscsi.c  |   67 +++++++------------
 b/drivers/target/target_core_pscsi.h  |    4 -
 b/drivers/usb/storage/cypress_atacb.c |    1 
 b/drivers/usb/storage/isd200.c        |    4 -
 b/include/linux/bsg-lib.h             |    1 
 b/include/scsi/scsi_cmnd.h            |   16 +---
 b/include/scsi/scsi_eh.h              |    4 -
 include/scsi/scsi_request.h           |   31 --------
 23 files changed, 225 insertions(+), 356 deletions(-)
