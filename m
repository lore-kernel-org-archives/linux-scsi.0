Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794BFC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 09:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57902208FE
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 09:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="cqKXryyR";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="pqY4m9TD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgE3Jmf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 05:42:35 -0400
Received: from fourecks.uuid.uk ([147.135.211.183]:52632 "EHLO
        fourecks.uuid.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgE3Jme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 05:42:34 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 May 2020 05:42:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R+Mj1NapwFRkDC6Os7g4prlnOtUbWo7gfstXxip1zTs=; b=cqKXryyRarFHH+aA4FFILfD44s
        Om3KpL7gbIyWG03jQ/tPgb4NP2KF1f3KMtvqe4U2OBhxmADKMbveYQvSMeVaZopipNvjJqx3/D8ZX
        yAvlsTEWkwCS0A7cIcdt/bV+r4uJbQjnmOfmBqIGIJetsoU955r+RogqHWz155eAvM31emVXTfsyE
        GhthUf6e+060RcL9mj/C/lsf9+/QG5mw9I8M32mdTM3NwGZrThKMTi8vpvBUMPheFQpyGxg6kU/ds
        4mlLsL57zw+YhEvWDCUmBNkh5iYF0q85El+XBZ0PIFRxR5Vy8VXyP+pt63v5emNYyYEBMmsIxcf7S
        AF9rtmiQ==;
Received: by fourecks.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jexsG-000754-9y; Sat, 30 May 2020 10:33:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject;
        bh=R+Mj1NapwFRkDC6Os7g4prlnOtUbWo7gfstXxip1zTs=; b=pqY4m9TD9LoG00tLVe8vvNpzHe
        GuaEPVlTRCxaxsks50/EQ6xRXW9dm+FK+nWU1ya7Eg9IVU9k29KuOzQdPP6JSZAHHldn/6Rv8cMld
        e5wORrqg2ds5ocOV/irs8o7jS57/Rj+oLH83N6S3KW3Zlv16w7WuyWb2rOaFWHqQcssrW6ho7rTUi
        kyZ/BWNdFfhJD4dvSQ2rrvESD17OoWVk2jmCubItJUfja/lQ7Z4vDPwHOLvwB9v1KaBWe0VYSEn+o
        c1aFBcU1HMgshM/NXk8NtSeOnruV4Dv7a1hu7GFbaz5uuZKsp0LpZCrBbtDANO4aiiCTEiaPibnp6
        D0/nUTyw==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jexsE-0007HX-GJ; Sat, 30 May 2020 10:33:50 +0100
Subject: [PATCH 2/2] scsi: sr: Fix sr_probe() missing deallocate of device
 minor
From:   Simon Arlott <simon@octiron.net>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <0cb16d6f-098a-a8c3-09c3-273d02067ada@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Message-ID: <da1f6f28-cdd4-72da-703b-749aba3f27ef@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Sat, 30 May 2020 10:33:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0cb16d6f-098a-a8c3-09c3-273d02067ada@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the cdrom fails to be registered then the device minor should be
deallocated.

Signed-off-by: Simon Arlott <simon@octiron.net>
---
 drivers/scsi/sr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8d062d4f3ce0..1e13c6a0f0ca 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -797,7 +797,7 @@ static int sr_probe(struct device *dev)
 	cd->cdi.disk = disk;
 
 	if (register_cdrom(&cd->cdi))
-		goto fail_put;
+		goto fail_minor;
 
 	/*
 	 * Initialize block layer runtime PM stuffs before the
@@ -815,6 +815,10 @@ static int sr_probe(struct device *dev)
 
 	return 0;
 
+fail_minor:
+	spin_lock(&sr_index_lock);
+	clear_bit(minor, sr_index_bits);
+	spin_unlock(&sr_index_lock);
 fail_put:
 	put_disk(disk);
 	mutex_destroy(&cd->lock);
-- 
2.17.1

-- 
Simon Arlott
