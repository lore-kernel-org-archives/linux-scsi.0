Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBB2C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 09:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C22207DF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 09:42:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="eT2uzsAJ";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="u12J+quM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgE3Jmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 05:42:37 -0400
Received: from fourecks.uuid.uk ([147.135.211.183]:52632 "EHLO
        fourecks.uuid.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgE3Jmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 05:42:36 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 May 2020 05:42:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:To:From:Cc:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l6l0gdQNHqrc/k4DoUqAApGgeHuzpVjcBY3jV1WKBQk=; b=eT2uzsAJPCT8cPPAb1U3MMXRHG
        3YrvhUvaMJuKJ28OOiMPLRPXUnlQJwiY8lbqKieb8RmUSoiv3C30DTKH9rYv8Dxt0CqxaHkK+IQj8
        NrenobWMjXJWsI07y9ZnHuEx/QFVXRggbVuqGBceTFarfgu26wuAlY3jITrwJeovN4fkh9VXvHf6j
        Q7bRLh6tRdR9ka9Uya5DevUgm5gQNaR2v888egLRRMswJzK8LF8ku35A41cFvzmun5mN7hSp17drt
        CVd0i1+WYCzT94QlMG0GFCQpGRq4xjwMyrzDksRhxWh+IWM57Z3lHk83RZvQ3zv55fKbfgnJvZGxf
        hqpAylRQ==;
Received: by fourecks.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jexrS-00073n-Hm; Sat, 30 May 2020 10:33:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:To:From:Cc;
        bh=l6l0gdQNHqrc/k4DoUqAApGgeHuzpVjcBY3jV1WKBQk=; b=u12J+quM+mso+wgsKqmm1U0opE
        POzNz+VSrpn8cq3iEfPJG8lNnvj2oT1fb6otQ1dQcB+6v5UKsM+pRjwYKkdw2ro2uwny/Cf3WQOlN
        A91SE//y87iLQuPqqlwUHU4c5eB60LsxTN1+dHOb0DV0aI0pa9f9f+J1vzLJVFR4WBFP0moY1wsBX
        qM4oxfh4AeQZc59dx+4qW4j3YJSDZOf94cRPNuJO4O0yaCVclP9GHlV9+pG9hDIm8Y0G/1mVFcmQu
        TbjCe6mLsosp6rXs4zrF0kOsb3VdntpMYwCAkkvAeSrhdXLBPu6KKQ8ggCInRwpVk7ERxsR9jIHYd
        6y1PzwVg==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jexrJ-0007Gg-NH; Sat, 30 May 2020 10:33:00 +0100
Cc:     linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From:   Simon Arlott <simon@octiron.net>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] scsi: sr: Fix sr_probe() missing mutex_destroy
Message-ID: <0cb16d6f-098a-a8c3-09c3-273d02067ada@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Sat, 30 May 2020 10:32:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the device minor cannot be allocated or the cdrom fails to be
registered then the mutex should be destroyed.

Signed-off-by: Simon Arlott <simon@octiron.net>
---
 drivers/scsi/sr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d2fe3fa470f9..8d062d4f3ce0 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -817,6 +817,7 @@ static int sr_probe(struct device *dev)
 
 fail_put:
 	put_disk(disk);
+	mutex_destroy(&cd->lock);
 fail_free:
 	kfree(cd);
 fail:
-- 
2.17.1

-- 
Simon Arlott
