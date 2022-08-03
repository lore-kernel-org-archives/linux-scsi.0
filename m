Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEEDC19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbiHCQXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiHCQXQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:23:16 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F042A276
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 09:23:15 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id b133so16913377pfb.6
        for <linux-scsi@vger.kernel.org>; Wed, 03 Aug 2022 09:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=r0unPhPuXNJ1wqrqxB2TgOzgVgBP0i+oiaIfosbs9BA=;
        b=XF3wqavoA6miYJhsiEddRjmABwxfYYR6T3VCp50R+fNIQc7VZRuMOB/5KY9O8krmtV
         Rv5jga+Jiz00UwS7ka7075LShdlnlpPjsv/6f0DIhPxoIvv60AMHwl75p7TnndI84/QR
         EVdOvewg9Go5bZ3ru6f5iIBFuAzE5MR26CDV5gP7tjtK1HBgtdb31o7D35mLVU5xY8m6
         d1mFcPksgfjPB4mA9dvN+mJRfwtE3NuorGdJ5axn+94JVNAQf4EHR4YX0natLr+s7KKx
         3uWZ9+vFhkUSLbKoZhrw40JddsLtko6GhlplTxgfTY0eEdk99SvcaRBQ5YEzB4QRPFKA
         St6w==
X-Gm-Message-State: AJIora9iCnr9FSlWePxkCIzqAVrHVpovE/3+UTezmeajULtE0y92sCC1
        9+o8c2p3bv3vYhLlq85xNCg=
X-Google-Smtp-Source: AGRyM1tXFaervkM8CHwbvIkSvaSQ5rYZgPBJrAgs2sKfl1Cq2EXCKpbJSzY60lrQyDbjgGdO7/2x5A==
X-Received: by 2002:a63:4503:0:b0:419:7b8c:cb11 with SMTP id s3-20020a634503000000b004197b8ccb11mr21381950pga.446.1659543794879;
        Wed, 03 Aug 2022 09:23:14 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:db71:edb7:462a:44af? ([2620:15c:211:201:db71:edb7:462a:44af])
        by smtp.gmail.com with ESMTPSA id z1-20020a17090ab10100b001f4d4a1b494sm1812401pjq.7.2022.08.03.09.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 09:23:13 -0700 (PDT)
Message-ID: <6263c2a5-e7b6-c9e5-69e8-b6d93604d82d@acm.org>
Date:   Wed, 3 Aug 2022 09:23:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
Content-Language: en-US
To:     "yohan.joung@sk.com" <yohan.joung@sk.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20220726225232.1362251-1-bvanassche@acm.org>
 <55fce3baaabf4e33aeaccbe5b4e1f145@sk.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <55fce3baaabf4e33aeaccbe5b4e1f145@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/2/22 16:40, yohan.joung@sk.com wrote:
> Is it possible by adding only max_sector to increase the data buffer size?

Yes.

> I think the data buffer will split to 512 KiB, because the sg_table size is SG_ALL

I don't think so. With this patch applied, the limits supported by the 
UFS driver are as follows:

	.sg_tablesize		= SG_ALL,                   /* 128 */
  	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX, /* 256 KiB*/
	.max_sectors		= (1 << 20) / SECTOR_SIZE,  /* 1 MiB */

So the maximum data buffer size is min(max_sectors * 512, sg_tablesize * 
max_segment_size) = min(1 MiB, 128 * 256 KiB) = 1 MiB. On a system with 
4 KiB pages, the data buffer size will be 128 * 4 KiB = 512 MiB if none 
of the pages involved in the I/O are contiguous.

Bart.
