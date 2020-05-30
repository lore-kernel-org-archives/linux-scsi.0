Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1724C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 17:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9223820721
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 17:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="R3gdukll";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="mpdsT09h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgE3R6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 13:58:48 -0400
Received: from fourecks.uuid.uk ([147.135.211.183]:53188 "EHLO
        fourecks.uuid.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgE3R6s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 13:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XQQ8+zcRJDT/XDN1huHV6gokNYNTsW08knhUgG2sq6I=; b=R3gdukll2N2MNAe7B8EpznfcZk
        zCRv0Ijz+tCnYhZsYc8p/ypYFfJfTclEGfwysMvlZAhkM/JRmMrhPM7wiAFDptI4Za3wq1xpEersm
        YH2hbDaIdE+3QhjhNHC5bSodhNuCQ2aO7fAQOrUF3Br1uijRpqTu1h0WuTgYJj9tHBjR0SPXI1U1d
        SvcoIJ1+OLmVT4y7V7N2vCd13ZwdzjyTH1wXgY5T+2gPfipogjlawvkaYSfmDsjNVDcEd74Mb2eXz
        2fBcDyaDM7y3Md5RaCo0poCheh2B3sTy6R9dAQROFkvEJCu6Wn5ZCPugw690varWx7CqKvQEaFaul
        lPzafEFA==;
Received: by fourecks.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jf5kj-0008Cp-Vv; Sat, 30 May 2020 18:58:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From;
        bh=XQQ8+zcRJDT/XDN1huHV6gokNYNTsW08knhUgG2sq6I=; b=mpdsT09hWoOABaBSp5gBUEhBmC
        eJUxlCve3+xep+Lxb5k68j/N74o1HPeRdmoO4HmeFmOf5gB1jIgahZorZ1J5I7JKsvrMEFkqVWCt7
        bX/3X49WAV55V32jOtrov+5tIuNjMEhqoo2pgDOQ5nHkVqNS1vUob3ztCiSEypwleQs3Dr191dIWC
        xgYdppQPysI6dJ2/fnNR34izQaaic0dbvxvr2feNMDzEWQZHV3K+fIPl/cAjLQ8NnPVOLBOVlLQXG
        3ispsrdsVWw3yRqUoYg2prVJBZgLd0bfLw9QtwY9uz3hANaEL6sEXJZpQ1WP/FMqxAJPUqaMrDAyr
        dQWsPh4g==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jf5kY-0006Ut-6s; Sat, 30 May 2020 18:58:33 +0100
From:   Simon Arlott <simon@octiron.net>
Subject: [PATCH v2 1/2] scsi: sr: Fix sr_probe() missing mutex_destroy
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <06e9de38-eeed-1cab-5e08-e889288935b3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Sat, 30 May 2020 18:58:25 +0100
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
Fixes: 51a858817dcd ("scsi: sr: get rid of sr global mutex")
Cc: stable@vger.kernel.org
---
On 30/05/2020 17:41, James Bottomley wrote:
> On Sat, 2020-05-30 at 09:24 -0700, Bart Van Assche wrote:
>> Please add Fixes: and Cc: stable tags.

I've added a Fixes: tag and Cc:'d stable.

> This isn't really a bug, is it?  mutex_destroy is a nop unless lock
> debugging is enabled in which case it checks the lock is unlocked and
> marks it as unusable to detect a use after destroy.  Since the
> structure containing the mutex is kfree'd in the next statement, kasan
> would also detect any use after free.  That's not to say we shouldn't
> do this to be fully correct ... just that it has no potential ever to
> have user visible impact so there doesn't seem to be much point
> cluttering up the stable process with it.

If the current lock debugging implementation in stable will be ok with
it then I'd agree there's no reason to put it in stable kernels, except
that the commit this fixes was added to stable with this bug and one in
sr_block_release (72655c0ebd1d).

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
