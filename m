Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC28C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 10:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A16D206C3
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 10:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="OeT1os0w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgFIKAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 06:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgFIKAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 06:00:17 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800EDC05BD1E;
        Tue,  9 Jun 2020 03:00:17 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49h5G15PmVz9sT6;
        Tue,  9 Jun 2020 20:00:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1591696810;
        bh=rmK8hLTxcRQ8uaBcN/fGTaE+wcTgRw/Xhbx5UZND1rs=;
        h=From:To:Subject:Date:From;
        b=OeT1os0wLS5mryDhKd3XYld/5OKC9ESr1u/4L0fbJqZvp+LZVKaK3VaHNlNQy5/c4
         WOkTrRKLeShGHuvk0767eykpGXwkSnzV3IaESW6DP1xKyK3vvNMTizaodQtalUOQqg
         tLAthkI5toqMdqWapKp+HlZFE7oAqzjCiYeknPpvsFBt9cWLIUpZv5YbXZpaqTRGHV
         8slIxNXLu+YqWNQCvVdw7rKo3+23tltyZr0rT8S3zS+RR5QF3s0yLFre4YuBArUElQ
         fzy0D8C6DmL42CFKat56uADJrXO2/FhVGz4JnGCiRw2nVkgPJzLSffK9UnLPoFuW6o
         czqWml5L4v2eg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     brking@us.ibm.com, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: ipr crashes due to NULL dma_need_drain since cc97923a5bcc ("block: move dma drain handling to scsi")
Date:   Tue, 09 Jun 2020 20:00:35 +1000
Message-ID: <87zh9cftj0.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I'm seeing crashes on powerpc with the ipr driver, which I'm fairly sure
are due to dma_need_drain being NULL.

The backtrace is:

  scsi_init_io+0x1d8/0x350
  scsi_queue_rq+0x7a4/0xc30
  blk_mq_dispatch_rq_list+0x1b0/0x910
  blk_mq_sched_dispatch_requests+0x154/0x270
  __blk_mq_run_hw_queue+0xa0/0x160
  __blk_mq_delay_run_hw_queue+0x244/0x250
  blk_mq_sched_insert_request+0x13c/0x250
  blk_execute_rq_nowait+0x88/0xb0
  blk_execute_rq+0x5c/0xf0
  __scsi_execute+0x10c/0x270
  scsi_mode_sense+0x144/0x440
  sr_probe+0x2e8/0x810
  really_probe+0x12c/0x580
  driver_probe_device+0x88/0x170
  device_driver_attach+0x11c/0x130
  __driver_attach+0xac/0x190
  bus_for_each_dev+0xa8/0x130
  driver_attach+0x34/0x50
  bus_add_driver+0x170/0x2b0
  driver_register+0xb4/0x1c0
  scsi_register_driver+0x2c/0x40
  init_sr+0x4c/0x80
  do_one_initcall+0x60/0x2b0
  kernel_init_freeable+0x2e0/0x3a0
  kernel_init+0x2c/0x148
  ret_from_kernel_thread+0x5c/0x74

And looking at the disassembly I think it's coming from:

static inline bool scsi_cmd_needs_dma_drain(struct scsi_device *sdev,
		struct request *rq)
{
	return sdev->dma_drain_len && blk_rq_is_passthrough(rq) &&
	       !op_is_write(req_op(rq)) &&
	       sdev->host->hostt->dma_need_drain(rq);
                                  ^^^^^^^^^^^^^^
}

Bisect agrees:

# first bad commit: [cc97923a5bccc776851c242b61015faf288d5c22] block: move dma drain handling to scsi


And looking at ipr.c, it constructs its scsi_host_template manually,
without using any of the macros that end up calling __ATA_BASE_SHT,
which populates dma_need_drain.

The obvious fix below works, the system boots and seems to be operating
normally, but I don't know enough (anything) about SCSI to say if it's
actually the correct fix.

cheers


diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 7d77997d26d4..7d86f4ca266c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6731,6 +6731,7 @@ static struct scsi_host_template driver_template = {
 	.compat_ioctl = ipr_ioctl,
 #endif
 	.queuecommand = ipr_queuecommand,
+	.dma_need_drain = ata_scsi_dma_need_drain,
 	.eh_abort_handler = ipr_eh_abort,
 	.eh_device_reset_handler = ipr_eh_dev_reset,
 	.eh_host_reset_handler = ipr_eh_host_reset,

