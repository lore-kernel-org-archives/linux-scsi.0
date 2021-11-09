Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B511C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 07:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84CDD61165
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 07:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243528AbhKIHPY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 02:15:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232967AbhKIHPX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 02:15:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636441957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P6uvsw2qEEoPf+gh+bzaIzonmWnOB7YX0hJHz6V9IKE=;
        b=U3D/XG2UpYUSxEwX1XukcoDjsxJ0kz/IVzSh2WOvBiCZw7Dz5sqFdGredr3OoM2viTS8du
        TsQrdBh9LHYtkNGUqE9mrp4Zzam8EBFp1EABkbczPC52WvqbR2lo/iGvgSwFbT6uKMTs+y
        N48MNhZh9JzTHQYU/ptlvm4dAZEU5MY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-WQ5yB0iQMH2nb3nu46EsPg-1; Tue, 09 Nov 2021 02:12:04 -0500
X-MC-Unique: WQ5yB0iQMH2nb3nu46EsPg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF8BD802C8F;
        Tue,  9 Nov 2021 07:12:02 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03B9377E26;
        Tue,  9 Nov 2021 07:11:49 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/4] block: fix concurrent quiesce
Date:   Tue,  9 Nov 2021 15:11:40 +0800
Message-Id: <20211109071144.181581-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

Convert SCSI into balanced quiesce and unquiesce by using atomic
variable as suggested by James, meantime fix previous nvme conversion by
adding one new API because we have to wait until the started quiesce is
done.

V2:
	- add comment on scsi's change, as suggested by James, 3/4
	- add reviewed-by tag, 4/4

Ming Lei (4):
  blk-mq: add one API for waiting until quiesce is done
  scsi: avoid to quiesce sdev->request_queue two times
  scsi: make sure that request queue queiesce and unquiesce balanced
  nvme: wait until quiesce is done

 block/blk-mq.c             | 28 ++++++++++++-----
 drivers/nvme/host/core.c   |  4 +++
 drivers/scsi/scsi_lib.c    | 62 ++++++++++++++++++++++++--------------
 include/linux/blk-mq.h     |  1 +
 include/scsi/scsi_device.h |  1 +
 5 files changed, 66 insertions(+), 30 deletions(-)

-- 
2.31.1

