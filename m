Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5BEC43464
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 23:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF219208DB
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 23:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600384730;
	bh=o6h0uQcYxT8hDqeNxh4o4wx37bxZ8o2tWkPFDlaL3Zg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=tpXGa3FTnbW+dwPZHAUY83EbzSEp65JRwJNISYmNMlzmtE051meGofOSF8jJ6EHMC
	 PaAPpdr8fv5gIpF2WA6RndbYF2cbFK/0oQ4Fsn32npio5uKIHwaW0syKs0erQxhBkm
	 OT3SZ81P8imPX+H+Gvlop/Liw3/IXjsUe2ywRzU8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgIQXSu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 19:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIQXSt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 19:18:49 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 525CE20838;
        Thu, 17 Sep 2020 23:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600384728;
        bh=o6h0uQcYxT8hDqeNxh4o4wx37bxZ8o2tWkPFDlaL3Zg=;
        h=From:To:Cc:Subject:Date:From;
        b=Uc7H8rbAxkFA478xseYdETekhlX/hB2v82QZ4iNoLiXGkRD11mrqAaabA2QiKquuY
         8VwmF3jiTF6zasq2aqtiK2ORXVhES/zwYqzg7b/ebE+E0TeKoaSiderK9l9+WVx5nk
         YYC6vVoWY9YnPfiXa2bLzF/W5nmmI4QgV64adKtk=
From:   Keith Busch <kbusch@kernel.org>
To:     linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 0/4] zoned block device specific errors
Date:   Thu, 17 Sep 2020 16:18:37 -0700
Message-Id: <20200917231841.4029747-1-kbusch@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Zone block devices may have some limits that require special handling.
This series provides a way for drivers to notify of these conditions.

v2->v3:

  Split status for max open vs max active errors (Christoph)

  Include scsi use for the new status (Damien)

  Update documentation for the new status inline with the request_queue
  properties they relate to

Damien Le Moal (2):
  scsi: update additional sense codes list
  scsi: handle zone resources errors

Keith Busch (2):
  block: add zone specific block statuses
  nvme: translate zone resource errors

 Documentation/block/queue-sysfs.rst |  8 +++++
 block/blk-core.c                    |  4 +++
 drivers/nvme/host/core.c            |  4 +++
 drivers/scsi/scsi_lib.c             |  9 +++++
 drivers/scsi/sense_codes.h          | 54 ++++++++++++++++++++++++++++-
 include/linux/blk_types.h           | 18 ++++++++++
 6 files changed, 96 insertions(+), 1 deletion(-)

-- 
2.24.1

