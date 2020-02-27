Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF72EC4BA2D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 13:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C6462469C
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 13:15:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ITAna7uo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgB0NPL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 08:15:11 -0500
Received: from forward101o.mail.yandex.net ([37.140.190.181]:57582 "EHLO
        forward101o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729080AbgB0NPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 08:15:10 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2020 08:15:09 EST
Received: from mxback16g.mail.yandex.net (mxback16g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:316])
        by forward101o.mail.yandex.net (Yandex) with ESMTP id A629C3C01109;
        Thu, 27 Feb 2020 16:07:48 +0300 (MSK)
Received: from sas2-ee0cb368bd51.qloud-c.yandex.net (sas2-ee0cb368bd51.qloud-c.yandex.net [2a02:6b8:c08:b7a3:0:640:ee0c:b368])
        by mxback16g.mail.yandex.net (mxback/Yandex) with ESMTP id bCElxBkT7g-7mHSgXbW;
        Thu, 27 Feb 2020 16:07:48 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1582808868;
        bh=qBHL0qr+x8cdyhYGWsEgpPInMSxdDw1AjYPV/7CcSpo=;
        h=Subject:From:To:Cc:Date:Message-ID;
        b=ITAna7uoz9djAiL7YZLVNqkyawbWdKFNWkq+Nr8tKQ2ZfAcpevLneELZIjdtGME8i
         VBq3WkxhOtYk70UMByWuWZWbmGyggqlk30+MlDb7Jnll3bgRYOYYYKArT8eTsNuJw1
         dtO9R1ML5KLphYu9ZBYk8hHthQaY5dzoWc8iYRyQ=
Authentication-Results: mxback16g.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas2-ee0cb368bd51.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id HMTffoU91p-7lYCTmLm;
        Thu, 27 Feb 2020 16:07:47 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
To:     MPT-FusionLinux.pdl@broadcom.com
Cc:     linux-scsi@vger.kernel.org
From:   Dmitry Antipov <dmantipov@yandex.ru>
Subject: Linux / mpt3sas support for PCI 1000:0014 (weird device?)
Message-ID: <49751508-48b0-eab4-a371-1b9eded12a19@yandex.ru>
Date:   Thu, 27 Feb 2020 16:07:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

my Debian 9.12 system with 4.9-based kernel reports the following device:

# lspci | grep -i sas
04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID Tri-Mode SAS3516 (rev 01)

# lspci -n | grep '04:00.0'
04:00.0 0104: 1000:0014 (rev 01)

but 0014 is not listed in drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h among the supported device ids.

Any ideas on who 1000:0014 is really are, and should it be supported by mpt3sas?

Dmitry
