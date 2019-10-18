Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1588CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A1C21897
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504694AbfJRHuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:50:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:36800 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504691AbfJRHuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 03:50:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 542E1B824;
        Fri, 18 Oct 2019 07:50:12 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 0/3] lpfc: nodelist pointer cleanup
Date:   Fri, 18 Oct 2019 09:50:07 +0200
Message-Id: <20191018075010.55653-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

trying to figure this annoying lpfc_set_rrq_active() bug
I've found the nodelist pointer handling in the lpfc io buffers
a bit strange; there's a 'ndlp' pointer, but for scsi the nodelist
is primarily accessed via the 'rdata' pointer (although not everywhere).
For NVMe it's primarily the 'ndlp' pointer, apparently, but the
usage is quite confusing.
So here's a patchset to straighten things up; it primarily moves
the anonymous protocol-specific structure in the io buffer to a named
one, and always accesses the nodelist through the protocol-specific
rport data structure.

It also has the nice side-effect that the protocol-specific areas are
aligned now, so clearing the 'rdata' pointer on the scsi side will
be equivalent to clearing the 'rport' pointer on the nvme side.
And it reduces the size of the io buffer.

Let me know what you think.

Hannes Reinecke (3):
  lpfc: use named structure for combined I/O buffer
  lpfc: access nodelist through scsi-specific rdata pointer
  lpfc: access nvme nodelist through nvme rport structure

 drivers/scsi/lpfc/lpfc_init.c |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c |  56 ++++++------
 drivers/scsi/lpfc/lpfc_scsi.c | 196 +++++++++++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_sli.c  |  26 +++---
 drivers/scsi/lpfc/lpfc_sli.h  |   6 +-
 5 files changed, 143 insertions(+), 143 deletions(-)

-- 
2.16.4

