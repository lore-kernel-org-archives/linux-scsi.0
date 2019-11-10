Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93718C17443
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FCF7214E0
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:37:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LFmVckvr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfKJChB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 21:37:01 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37319 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfKJChB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2019 21:37:01 -0500
Received: by mail-pg1-f193.google.com with SMTP id z24so6719188pgu.4;
        Sat, 09 Nov 2019 18:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=cHvG71r+ATK+8FVmIxnDq7j4iOJozOQj9/O6EgDMguk=;
        b=LFmVckvrpiNq6cM0CvA72XicsvPselruKZ1RF2yAa2Nu0uzKUzwHUSZz8O5A2POxx1
         ySpQQrT79N97VBuO2IByaS3ysFaHpnTlcuUprHkFcf0FXe5lnjUdzmuEt2iFNgr5J2+X
         ZG5p/ltam/0J9cfCkWJ5kExdSqcG9qoOPqRQ2AnjzdgRCvszflQ9Wt1CEelbZpSy8DfP
         k+rApJ2cBkhkvllYwCDkx7Ing1zndZON9n1sGfmDpRwDnxAsXRGAkeFjgkWcJJofkafs
         BwqK+4pBw8Ci2LsmU8Sx0jny1hBW8ETwasAxPI5m+LdWLfFKVvPTMZYFDdq6c74Ssqsv
         30bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=cHvG71r+ATK+8FVmIxnDq7j4iOJozOQj9/O6EgDMguk=;
        b=qajo7ZDOL7uPKDdrHThFxT+u44t18NrhVlTV8fbcoPSz+wbVK1HbDR4tCaQHE6kAvZ
         oAHEyOqYZUbRXwn1t2BMQGBOCy7T5TdqbXYv79quLF21ljfAclheStK88bbtlhr02pet
         8Vc1Wk2tySp4xNsnZmNbp9DXDV9QveYfpanTnVv0AwP27zDRZOyc9O7R2MregGTTpqdS
         VRViRe9vNCvafeAyvfcLwXeege/UnKz69lVOOxeEVq8BE1VPTtjfJRM32CBoJMUS9Z0q
         55ggOE48fwbjrlxfv9lXZSHKpbennCirt4BSMIxmxltSg4mwZ7J5VNJq07Z/BCLfzlXX
         yzYw==
X-Gm-Message-State: APjAAAXNFASw/VWL+pG1khyrS+aEDen/TtWNdTbI58Kk63rpuTI/lYfZ
        3fSd9YbtGYAff7AkkgEKT/N49Qxq
X-Google-Smtp-Source: APXvYqznM2MyaTlGH0B2utG3Bwl65R0tvNsRXs+DiVDzU+Z/9hG5sDtTEpSE3dEU5z7xI9Y65mxkDg==
X-Received: by 2002:a63:3f04:: with SMTP id m4mr21106860pga.234.1573353420600;
        Sat, 09 Nov 2019 18:37:00 -0800 (PST)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id 3sm10017030pfh.45.2019.11.09.18.36.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 18:36:59 -0800 (PST)
Subject: Re: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
To:     James Bottomley <jejb@linux.ibm.com>,
        Kars de Jong <jongk@linux-m68k.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
 <20191109191400.8999-1-jongk@linux-m68k.org>
 <1573330351.3650.4.camel@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <6b914b12-cbc7-6fe6-7cba-3e89b2f6f19b@gmail.com>
Date:   Sun, 10 Nov 2019 15:36:54 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <1573330351.3650.4.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

James,

Am 10.11.2019 um 09:12 schrieb James Bottomley:
> On Sat, 2019-11-09 at 20:14 +0100, Kars de Jong wrote:
>> When using this driver on a Blizzard 1260, there were failures
>> whenever DMA transfers from the SCSI bus to memory of 65535 bytes
>> were followed by a DMA transfer of 1 byte. This caused the byte at
>> offset 65535 to be overwritten with 0xff. The Blizzard hardware can't
>> handle single byte DMA transfers.
>>
>> Besides this issue, limiting the DMA length to something that is not
>> a multiple of the page size is very inefficient on most file systems.
>>
>> It seems this limit was chosen because the DMA transfer counter of
>> the ESP by default is 16 bits wide, thus limiting the length to 65535
>> bytes. However, the value 0 means 65536 bytes, which is handled by
>> the ESP and the Blizzard just fine. It is also the default maximum
>> used by esp_scsi when drivers don't provide their own
>> dma_length_limit() function.
>
> Have you tested this on any other hardware?  the reason most legacy
> hardware would have a setting like this is because they have a two byte
> transfer length register and zero doesn't mean 65536.  If this is the

The data book for the NCR53FC94/NCR53FC96 (the 'fast' SCSI controller 
used on the board Kars tried) states that with the features enable bit 
clear (no 24 bit DMA counts used), zero does mean 64k indeed. The 
features enable bit is never set by esp_scsi.c. I chose the incorrect 
length limit without realizing this special case for the transfer count. 
and before we found out that 1-byte DMA just won't work.

I need to confirm this from a data book of the older (pre-fast) 
revisions of this chip family. but since as Kars also states, the core 
driver default for the 16 bit transfer size is 64k as well, I very much 
suspect the same behaviour for the older revisions.

All of the old board-specific drivers used a max transfer length of 
0x1000000, only the fastlane driver used 0xfffc. That lower limit might 
be due to a DMA limitation on the fastlane board. We could accommodate 
the different limit for this board by using a board-specific 
dma_length_limit() callback...

> case for any of the cards the zorro_esp drives, it might be better to
> lower the max length to 61440 (64k-4k) so the residual is a page.

For the benefit of keeping the code simple, and avoid retesting the 
fastlane board, that might indeed be the better solution.

Cheers,

	Michael

>
> James
>
