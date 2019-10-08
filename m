Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD60C4360C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 10:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 322B02070B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 10:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbfJHKJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 06:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730106AbfJHKJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 06:09:55 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 853F43060617;
        Tue,  8 Oct 2019 10:09:55 +0000 (UTC)
Received: from localhost (ovpn-8-31.pek2.redhat.com [10.72.8.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C76560BE2;
        Tue,  8 Oct 2019 10:09:51 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH V3 0/2] scsi: avoid atomic operations in IO path
Date:   Tue,  8 Oct 2019 18:09:43 +0800
Message-Id: <20191008100945.24951-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 08 Oct 2019 10:09:55 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

The 1st patch kills the atomic host-wide counter of host_busy.

The 2nd patch bypass the atomic LUN-wide connter of device_busy
for fast SSD device.

V3:
	- use non-atomic set/clear bit operations as suggested by Bart
	- kill single field struct for storing count of in-flight requests
	- add patch to bypass the atomic LUN-wide counter of device_busy
	for fast SSD device

V2:
	- introduce SCMD_STATE_INFLIGHT for getting accurate host busy
	via blk_mq_tagset_busy_iter()
	- verified that original Jens's report[1] is fixed
	- verified that SCSI timeout/abort works fine


Ming Lei (2):
  scsi: core: avoid host-wide host_busy counter for scsi_mq
  scsi: core: don't limit per-LUN queue depth for SSD

 drivers/scsi/hosts.c     | 19 +++++++++++++-
 drivers/scsi/scsi.c      |  2 +-
 drivers/scsi/scsi_lib.c  | 57 +++++++++++++++++++++++-----------------
 drivers/scsi/scsi_priv.h |  2 +-
 include/scsi/scsi_cmnd.h |  1 +
 include/scsi/scsi_host.h |  1 -
 6 files changed, 54 insertions(+), 28 deletions(-)

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Omar Sandoval <osandov@fb.com>,
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>

-- 
2.20.1

