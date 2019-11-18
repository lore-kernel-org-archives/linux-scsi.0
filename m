Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B90CC432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 631FA2084D
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XvUOOY0u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfKRKbj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 05:31:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48083 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726460AbfKRKbj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 05:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574073097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6+XuT2s+8ONXm984yF2dSVF/0LMAYYfqf7aPk7Dpo7I=;
        b=XvUOOY0ukyitHfaG790vglkiMjHNYUdAjrDPclds1EUrgtYdT54eJXoBU+lW8i7+jrVDzZ
        FyLvRVhMn95ruOsWwY4zNd/TCck90Zo+rnXxnvGaH+BEsBNZOoKvdkTTNqoynJ/LDEtBSy
        AwUkJAPqP7hVL4eZ4juAd4/088ZNKZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-nTwsMY_NO3auYAzJdvHtNw-1; Mon, 18 Nov 2019 05:31:32 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 597F51005510;
        Mon, 18 Nov 2019 10:31:30 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17753627D7;
        Mon, 18 Nov 2019 10:31:26 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/4] scis: don't apply per-LUN queue depth for SSD
Date:   Mon, 18 Nov 2019 18:31:13 +0800
Message-Id: <20191118103117.978-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: nTwsMY_NO3auYAzJdvHtNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
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

This patchset tries to don't apply per-LUN queue depth for SSD, then
we can avoid the expensive atomic operation on sdev->device_busy.
We do understand that this shared counter affects IOPS a lot.

The 1st two patches replaces .device_busy with two private counter for
megaraid_sas and mpt3sas to track inflight per-LUN commands since the
two drivers need the counter for balancing load, even though it is
probably no much use.

The last two patches avoid to operate on sdev->device_busy in IO path
for SSD.


Ming Lei (4):
  scsi: megaraid_sas: use private counter for tracking inflight per-LUN
    commands
  scsi: mpt3sas: use private counter for tracking inflight per-LUN
    commands
  scsi: sd: register request queue after sd_revalidate_disk is done
  scsi: core: don't limit per-LUN queue depth for SSD

 block/blk-sysfs.c                           | 14 +++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h        |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c   | 15 +++++++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 13 +++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  3 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 15 +++++++++++--
 drivers/scsi/scsi_lib.c                     | 24 +++++++++++++++------
 drivers/scsi/sd.c                           |  8 ++++++-
 9 files changed, 77 insertions(+), 17 deletions(-)

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
--=20
2.20.1

