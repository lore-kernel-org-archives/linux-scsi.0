Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409C2C4346E
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 01:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EF9C20874
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 01:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgIYB4B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 21:56:01 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55694 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgIYBz5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Sep 2020 21:55:57 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2020 21:55:56 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 8B9AE20418F;
        Fri, 25 Sep 2020 03:46:10 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Hf1Ab6sUrTjO; Fri, 25 Sep 2020 03:46:08 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id E20F7204165;
        Fri, 25 Sep 2020 03:46:07 +0200 (CEST)
Reply-To: dgilbert@interlog.com
To:     SCSI development list <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@ORACLE.COM>,
        USB list <linux-usb@vger.kernel.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: lib/scatterlist.c : sgl_alloc_order promises more than it delivers
Message-ID: <b9f5c065-7662-30e0-8cbd-27a77d28611e@interlog.com>
Date:   Thu, 24 Sep 2020 21:46:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The signature of this exported function is:

struct scatterlist *sgl_alloc_order(unsigned long long length,
                                     unsigned int order, bool chainable,
                                     gfp_t gfp, unsigned int *nent_p)

That first argument would be better named num_bytes (rather than length).
Its type (unsigned long long) seems to promise large allocations (is that
64 or 128 bits?). Due to the implementation it doesn't matter due to this
check in that function's definition:

         /* Check for integer overflow */
         if (length > (nent << (PAGE_SHIFT + order)))
                 return NULL;

Well _integers_ don't wrap, but that pedantic point aside, 'nent' is an
unsigned int which means the rhs expression cannot represent 2^32 or
higher. So if length >= 2^32 the function fails (i.e. returns NULL).

On 8 GiB and 16 GiB machines I can easily build 6 or 12 GiB sgl_s (with
scsi_debug) but only if no single allocation is >= 4 GiB due to the
above check.

So is the above check intended to do that or is it a bug?


Any progress with the "[PATCH] sgl_alloc_order: memory leak" bug fix
posted on 20200920 ?
sgl_free() is badly named as it leaks for order > 0 .

Doug Gilbert


PS1  vmalloc() which I would like to replace with sgl_alloc_order() in the
      scsi_debug driver, does not have a 4 GB limit.

PS2  Here are the users of sgl_free() under the drivers directory:

find . -name '*.c' -exec grep "sgl_free(" {} \; -print
	sgl_free(cmd->req.sg);
		sgl_free(cmd->req.sg);
	sgl_free(cmd->req.sg);
	sgl_free(cmd->req.sg);
./nvme/target/tcp.c
	sgl_free(req->sg);
		sgl_free(req->sg);
			sgl_free(req->metadata_sg);
./nvme/target/core.c
	sgl_free(fod->data_sg);
./nvme/target/fc.c
	sgl_free(sgl);
./usb/usbip/stub_rx.c
			sgl_free(urb->sg);
		sgl_free(priv->sgl);
./usb/usbip/stub_main.c

