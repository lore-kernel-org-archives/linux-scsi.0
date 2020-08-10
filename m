Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D013FC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 22:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B800820734
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 22:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgHJW71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 18:59:27 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:56836 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726634AbgHJW70 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 18:59:26 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id E4A2D4DBD;
        Mon, 10 Aug 2020 22:59:25 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: way77_1f01da226fde
X-Filterd-Recvd-Size: 1917
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Mon, 10 Aug 2020 22:59:24 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scsi: lpfc: Reduce logging object code size
Date:   Mon, 10 Aug 2020 15:59:18 -0700
Message-Id: <cover.1597100152.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The logging macros are pretty heavyweight and can be consolidated
to reduce overall object size.

Joe Perches (2):
  scsi: lpfc: Neaten logging macro #defines
  scsi: lpfc: Add logging functions to reduce object size

 drivers/scsi/lpfc/Makefile       |   2 +-
 drivers/scsi/lpfc/lpfc.h         |   5 ++
 drivers/scsi/lpfc/lpfc_attr.h    |   5 ++
 drivers/scsi/lpfc/lpfc_bsg.h     |   6 ++
 drivers/scsi/lpfc/lpfc_compat.h  |   5 ++
 drivers/scsi/lpfc/lpfc_crtn.h    |   5 ++
 drivers/scsi/lpfc/lpfc_disc.h    |   5 ++
 drivers/scsi/lpfc/lpfc_hw.h      |   5 ++
 drivers/scsi/lpfc/lpfc_hw4.h     |   5 ++
 drivers/scsi/lpfc/lpfc_ids.h     |   5 ++
 drivers/scsi/lpfc/lpfc_logmsg.c  | 112 +++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_logmsg.h  |  63 ++++++-----------
 drivers/scsi/lpfc/lpfc_nl.h      |   4 ++
 drivers/scsi/lpfc/lpfc_nvme.h    |   5 ++
 drivers/scsi/lpfc/lpfc_scsi.h    |   4 ++
 drivers/scsi/lpfc/lpfc_sli.h     |   5 ++
 drivers/scsi/lpfc/lpfc_sli4.h    |   5 ++
 drivers/scsi/lpfc/lpfc_version.h |   5 ++
 18 files changed, 208 insertions(+), 43 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_logmsg.c

-- 
2.26.0

