Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1644AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F28EF6103C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhKCDqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 23:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229506AbhKCDqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 23:46:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635911024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=px09Mq8hurZCKugKSYoOdFg4hORTnaCBQzOYpg7lg30=;
        b=JHDmzTNLat0kpLj+/uurY4wmiEhMSqvDQPKEm8YVIVfsmjRauYmd10Rz8g8nuMGEZlclOO
        QFEFE0/rP1zEp7W4H515NfLHAbRIAmSNT/FK5zBy5QG3X1TTn1nml5AXZnNXYl2/l5NMBl
        D1GxT8DnMU1JL2pZLhtGMK18zhJomo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-GZOikcS0PCKtNshaKXE8AQ-1; Tue, 02 Nov 2021 23:43:41 -0400
X-MC-Unique: GZOikcS0PCKtNshaKXE8AQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 406E380EFBD;
        Wed,  3 Nov 2021 03:43:40 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA95D5D9D3;
        Wed,  3 Nov 2021 03:43:31 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/4] block: fix concurrent quiesce
Date:   Wed,  3 Nov 2021 11:43:01 +0800
Message-Id: <20211103034305.3691555-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

Convert SCSI into balanced quiesce and unquiesce by using atomic
variable as suggested by James, meantime fix previous nvme conversion by
adding one new API because we have to wait until the started quiesce is
done.


Ming Lei (4):
  blk-mq: add one API for waiting until quiesce is done
  scsi: avoid to quiesce sdev->request_queue two times
  scsi: make sure that request queue queiesce and unquiesce balanced
  nvme: wait until quiesce is done

 block/blk-mq.c             | 28 +++++++++++++------
 drivers/nvme/host/core.c   |  4 +++
 drivers/scsi/scsi_lib.c    | 55 +++++++++++++++++++++++---------------
 include/linux/blk-mq.h     |  1 +
 include/scsi/scsi_device.h |  1 +
 5 files changed, 59 insertions(+), 30 deletions(-)

-- 
2.31.1

