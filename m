Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BA0C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 16:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95AF66144A
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 16:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbhDUQMn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 12:12:43 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:44879 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbhDUQMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 12:12:40 -0400
Received: by mail-pg1-f171.google.com with SMTP id y32so30322169pga.11
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 09:12:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wOKtU6VR7w2e04uSkw3UiOMHtSsJy/vLyjXfZOCfYgg=;
        b=YjPmFTlhSHwn5kay8bcJRDo/sq7aMrL70CcvVqu0+kBSTQBL+hUtZtygiLAV3v95om
         a893HbdVRukHbDeRXWfiUrKdm1c8RJ9zy1UvU/mKU9H2Ehj4mLryO0NyHTLfNkMlHOGJ
         u1KqYmgYZxY1krsslxsTEyzp1bKm6+o4h0ynVWkCr1YYJ1RMFgtcTte1J8kI4V15eXl1
         CGZdeg0mqZlB1HdTxn4JvQB0zmNcHXeIJOOxSvBld4GhT7JjB9qWl7E1zcewz59PfAWJ
         Ud5Iw0sooXk6KaP2kzRaSdJ0qWJVCOztNwpcnzlGmPmqas9+7bzxzae88jHXRoD+i9Jp
         tu7w==
X-Gm-Message-State: AOAM532DeZ2iMFIGXMe/4DktpXUuVt9PHgmsdtrJVLFSHRxy6Xu0QdtT
        Ah3HgcxU+elqpMMyE6zUl0NVWbtsTVQZHg==
X-Google-Smtp-Source: ABdhPJy7HP11gHq9ANbxufmWvK+SgYhDIUPXX1AG9dX47HQ0eOFMLrpD8g/f64Shi5NoJZ8goYBsWw==
X-Received: by 2002:a63:150c:: with SMTP id v12mr22633859pgl.344.1619021526464;
        Wed, 21 Apr 2021 09:12:06 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v10sm2141298pgi.6.2021.04.21.09.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 09:12:05 -0700 (PDT)
Subject: Re: [PATCH 075/117] nfsd: Convert to the scsi_status union
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bruce Fields <bfields@fieldses.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-76-bvanassche@acm.org>
 <67BD8DEF-7C29-458A-9135-6602192594D4@oracle.com>
 <8775e8c9-49cf-c3eb-0933-8029494f2ff8@acm.org>
 <5F9582A8-3E5A-4810-9579-51D2BD3A8B83@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ff1f2108-3743-ba0d-9d35-65e360cc144a@acm.org>
Date:   Wed, 21 Apr 2021 09:12:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <5F9582A8-3E5A-4810-9579-51D2BD3A8B83@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 7:22 AM, Chuck Lever III wrote:
> 
> 
>> On Apr 20, 2021, at 12:44 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 4/20/21 7:36 AM, Chuck Lever III wrote:
>>>> On Apr 19, 2021, at 8:08 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>>>> An explanation of the purpose of this patch is available in the patch
>>>> "scsi: Introduce the scsi_status union".
>>>>
>>>> Cc: "J. Bruce Fields" <bfields@fieldses.org>
>>>> Cc: Chuck Lever <chuck.lever@oracle.com>
>>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>>
>>> Hi Bart, I assume this is going into v5.13 via the SCSI tree?
>>> Do you need an Acked-by: from the NFSD maintainers?
>>
>> Hi Chuck,
>>
>> Thanks for having taken a look. In case you would not yet have found the
>> "scsi: Introduce the scsi_status union" patch, it is available here:
>> https://lore.kernel.org/linux-scsi/20210420000845.25873-12-bvanassche@acm.org/T/#u
>>
>> An Acked-by or Reviewed-by from an NFS expert would be great.
> 
> The NFSD patch looks OK to me, but I'm hesitating on sending
> an Acked-by.
> 
> I went back and looked at the scsi_status union patch, and
> that looks dodgy to me.
> 
> AFAIK, "enum" doesn't cause the compiler to reserve any
> particular size of storage, it just makes a guess. What
> keeps those enum fields from being 16- or 32-bits wide?
> Shouldn't those be u8 to enforce the correct field size?
> 
> I'm not sure where to look for further discussion on that
> part of the series.

Hi Chuck,

Although the C standard requires that enums have the same size as an 
int, gcc and clang support the attribute "packed" for enums. From the 
gcc documentation about the packed attribute: "When attached to an enum 
definition, it indicates that the smallest integral type should be used."

Additionally, the following BUILD_BUG_ON() statements verify the size 
and endianness of the members of the scsi_status union (see also 
https://www.spinics.net/lists/linux-scsi/msg157796.html):

+#define TEST_STATUS ((union scsi_status){.combined = 0x01020308})
+
  static int __init init_scsi(void)
  {
  	int error;

+	BUILD_BUG_ON(sizeof(union scsi_status) != 4);
+	BUILD_BUG_ON(TEST_STATUS.combined != 0x01020308);
+	BUILD_BUG_ON(driver_byte(TEST_STATUS) != 1);
+	BUILD_BUG_ON(host_byte(TEST_STATUS) != 2);
+	BUILD_BUG_ON(msg_byte(TEST_STATUS) != 3);
+	BUILD_BUG_ON(status_byte(TEST_STATUS) != 4);

Does this address your concern?

Bart.
