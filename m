Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98763C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 18:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7934F20722
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 18:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="rTm8LIVk";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="rTm8LIVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgE3SH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 14:07:56 -0400
Received: from chalk.uuid.uk ([51.68.227.198]:53306 "EHLO chalk.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbgE3SHx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 May 2020 14:07:53 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 May 2020 14:07:52 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject;
        bh=hNcCFqnwYbw0e0UNc3qFaCOs8NSwY/Ut8L89DjCvirE=; b=rTm8LIVkgWSsHLXrrV/aotaYil
        BHNRtUGUosdoeeagjXKCwn3baGHk/6moE/PMUZi2kpIW5HcxCb/zUq/IiekkwlIwhxLohKJJkhFDp
        TxGkEQ7R5KP4uy6rrbgaSLi/uCf8PD7rNj4so1poYD47tGC8WHCRRvuAtu4u40l/U8WF8kpWUf95x
        4cCGeHo3JYtT5lwVelQ1ejUvIeZipYEUZ3/fO3JFKEiSBacyI9DTbQ1VbuVpbgDKuHFQWB4bBhcBn
        2YJ1Lbw+2w+tyEkVhgkfwtay5KWVzrSkJc+6McgymLMLzcu60bgNqUmLgSG56ohSOof9EQvSsFd4U
        BQZOkxUQ==;
Received: by chalk.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jf5lq-000072-FC; Sat, 30 May 2020 18:59:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject;
        bh=hNcCFqnwYbw0e0UNc3qFaCOs8NSwY/Ut8L89DjCvirE=; b=rTm8LIVkgWSsHLXrrV/aotaYil
        BHNRtUGUosdoeeagjXKCwn3baGHk/6moE/PMUZi2kpIW5HcxCb/zUq/IiekkwlIwhxLohKJJkhFDp
        TxGkEQ7R5KP4uy6rrbgaSLi/uCf8PD7rNj4so1poYD47tGC8WHCRRvuAtu4u40l/U8WF8kpWUf95x
        4cCGeHo3JYtT5lwVelQ1ejUvIeZipYEUZ3/fO3JFKEiSBacyI9DTbQ1VbuVpbgDKuHFQWB4bBhcBn
        2YJ1Lbw+2w+tyEkVhgkfwtay5KWVzrSkJc+6McgymLMLzcu60bgNqUmLgSG56ohSOof9EQvSsFd4U
        BQZOkxUQ==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jf5lo-0006Wc-Jc; Sat, 30 May 2020 18:59:45 +0100
Subject: [PATCH v2 2/2] scsi: sr: Fix sr_probe() missing deallocate of device
 minor
From:   Simon Arlott <simon@octiron.net>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <06e9de38-eeed-1cab-5e08-e889288935b3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Message-ID: <072dac4b-8402-4de8-36bd-47e7588969cd@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Sat, 30 May 2020 18:59:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <06e9de38-eeed-1cab-5e08-e889288935b3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
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
Cc: stable@vger.kernel.org
---
On 30/05/2020 17:24, Bart Van Assche wrote:
> On 2020-05-30 02:33, Simon Arlott wrote:
>> If the cdrom fails to be registered then the device minor should be
>> deallocated.
> 
> Also for this patch, please add Fixes: and Cc: stable tags.

I've Cc:'d stable.

There is no specific previous commit that this fixes. I was just
checking the rest of sr_probe when making a patch for the first issue.

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
