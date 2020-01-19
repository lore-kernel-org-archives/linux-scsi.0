Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29B5C33CB1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F102073A
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:14:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XgrZw3G7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgASHO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 02:14:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23993 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726396AbgASHO4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 02:14:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579418095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SkLv9GpBnorVKrQ47OoiNoTgmTgTfdJV990vGs9ooys=;
        b=XgrZw3G77/bL6KMTouNLW9wHbwOWfobkKX07yAdW4hN0XZNmnutLEkgi8XJDyXDzkMHoa7
        ChMw26ELf8sI2xehOq/Q6lto2sMxNOGKsqFVk8R6Xu1CwDF+36zbK0LuG131GQXmubFmOw
        b1cASwX4nohbVYjWGNgV5Zwc2vROfZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-l6-29xjfNHiSHkx3dOzN3g-1; Sun, 19 Jan 2020 02:14:51 -0500
X-MC-Unique: l6-29xjfNHiSHkx3dOzN3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CBDE800D4E;
        Sun, 19 Jan 2020 07:14:49 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDD545C1D4;
        Sun, 19 Jan 2020 07:14:45 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/6] scsi: support bypass device busy check for some high end HBA with SSD
Date:   Sun, 19 Jan 2020 15:14:26 +0800
Message-Id: <20200119071432.18558-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

SCSI's per-LUN queue depth is usually for improving IO merge and
balancing IO load among LUNs. blk-mq has provides fair driver tag
allocation and managed IRQ balances interrupt load among queues,
meantime IO merge doesn't play a big role for SSD, and NVMe doesn't
apply per-namespace queue depth.

This patchset tries to don't apply per-LUN queue depth for some high end
HBA in case of SSD, then we can avoid the expensive atomic operation on
sdev->device_busy. We do understand that this shared counter affects IOPS
a lot.

Thanks,
Ming

Ming Lei (6):
  scsi: mpt3sas: don't use .device_busy in device reset routine
  scsi: remove .for_blk_mq
  scsi: sd: register request queue after sd_revalidate_disk is done
  block: freeze queue for updating QUEUE_FLAG_NONROT
  scsi: core: don't limit per-LUN queue depth for SSD when HBA needs
  scsi: megaraid: set flag of no_device_queue_for_ssd

 block/blk-sysfs.c                         | 14 +++++++++-
 drivers/scsi/megaraid/megaraid_sas_base.c |  1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 32 ++++++++++++++++++++-
 drivers/scsi/scsi_lib.c                   | 34 +++++++++++++++++++----
 drivers/scsi/sd.c                         |  7 ++++-
 drivers/scsi/virtio_scsi.c                |  1 -
 include/scsi/scsi_host.h                  |  4 +--
 7 files changed, 81 insertions(+), 12 deletions(-)

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
--=20
2.20.1

