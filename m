Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D763C4361A
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 18:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1FE22838
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 18:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgLESTc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Dec 2020 13:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbgLERqn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2020 12:46:43 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499F8C02B8F5;
        Sat,  5 Dec 2020 09:30:33 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id CA3331280881;
        Sat,  5 Dec 2020 09:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1607189430;
        bh=ju+gwqxSbw4wAV2Be4ASi/eauxUvVwvTJ6wdfezRikM=;
        h=Message-ID:Subject:From:To:Date:From;
        b=sw4ZNyO+g5ST4XpJmRf6c8a8GvRnAqCt3Q2+OcRWiOG9GQQLtA9lF9mR+LYauTs8T
         +yzkLelUaNGUTBpSAr60r7/ECQs/rp12i7fQCX36noFErYQDdAfOwHEuPIMKSsMJxJ
         hlEFvLlpSSga3oooaIGg5ghLQ2arb5A7bZ5Os8Go=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id btD5y0INxwPt; Sat,  5 Dec 2020 09:30:30 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6C0D01280857;
        Sat,  5 Dec 2020 09:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1607189430;
        bh=ju+gwqxSbw4wAV2Be4ASi/eauxUvVwvTJ6wdfezRikM=;
        h=Message-ID:Subject:From:To:Date:From;
        b=sw4ZNyO+g5ST4XpJmRf6c8a8GvRnAqCt3Q2+OcRWiOG9GQQLtA9lF9mR+LYauTs8T
         +yzkLelUaNGUTBpSAr60r7/ECQs/rp12i7fQCX36noFErYQDdAfOwHEuPIMKSsMJxJ
         hlEFvLlpSSga3oooaIGg5ghLQ2arb5A7bZ5Os8Go=
Message-ID: <6241da59ba45eeb525203201095d1f5ee76fbceb.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.10-rc6
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 05 Dec 2020 09:30:29 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Four small fixes in two drivers.  The mpt3sas fixes are all timeout
under unusual conditions problems and the storvsc is a missed incoming
packet validation and a missed error return.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Andrea Parri (Microsoft) (1):
      scsi: storvsc: Validate length of incoming packet in storvsc_on_channel_callback()

Jing Xiangfeng (1):
      scsi: storvsc: Fix error return in storvsc_probe()

Sreekanth Reddy (1):
      scsi: mpt3sas: Increase IOCInit request timeout to 30s

Suganath Prabu S (1):
      scsi: mpt3sas: Fix ioctl timeout

And the diffstat:

 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 2 +-
 drivers/scsi/storvsc_drv.c          | 9 ++++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index e4cc92bc4d94..bb940cbcbb5d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6459,7 +6459,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 
 	r = _base_handshake_req_reply_wait(ioc,
 	    sizeof(Mpi2IOCInitRequest_t), (u32 *)&mpi_request,
-	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 10);
+	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 30);
 
 	if (r != 0) {
 		ioc_err(ioc, "%s: handshake failed (r=%d)\n", __func__, r);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 0f2b681449e6..edd26a2570fa 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -664,7 +664,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	Mpi26NVMeEncapsulatedRequest_t *nvme_encap_request = NULL;
 	struct _pcie_device *pcie_device = NULL;
 	u16 smid;
-	u8 timeout;
+	unsigned long timeout;
 	u8 issue_reset;
 	u32 sz, sz_arg;
 	void *psge;
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 0c65fbd41035..99c8ff81de74 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1246,6 +1246,11 @@ static void storvsc_on_channel_callback(void *context)
 		request = (struct storvsc_cmd_request *)
 			((unsigned long)desc->trans_id);
 
+		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) - vmscsi_size_delta) {
+			dev_err(&device->device, "Invalid packet len\n");
+			continue;
+		}
+
 		if (request == &stor_device->init_request ||
 		    request == &stor_device->reset_request) {
 			memcpy(&request->vstor_packet, packet,
@@ -1994,8 +1999,10 @@ static int storvsc_probe(struct hv_device *device,
 			alloc_ordered_workqueue("storvsc_error_wq_%d",
 						WQ_MEM_RECLAIM,
 						host->host_no);
-	if (!host_dev->handle_error_wq)
+	if (!host_dev->handle_error_wq) {
+		ret = -ENOMEM;
 		goto err_out2;
+	}
 	INIT_WORK(&host_dev->host_scan_work, storvsc_host_scan);
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);

