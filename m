Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5E3C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 16:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158B561285
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 16:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhENQHf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 12:07:35 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:40955 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhENQHf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 12:07:35 -0400
Received: by mail-pg1-f175.google.com with SMTP id j12so18354227pgh.7
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 09:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ubFPKNbop7zriE7BdJvO98Zru0aUMitCBR0JTUNMp/k=;
        b=b1u1+JgpbYWj/h9TZo0P0/Hr1zsZEJlitBbYtMKPaaehBlIA6Guz85gcNa1czKN2JL
         muEJePLo5DNRaHYzSIztF4/J+YnoQNhWYRf7drgrsFdj2Wek3+qbyHFSGTrM/kremFBN
         R2cywO2QVEBW0wD/E31osC1lHDpmTFVpHGOAE/gRLErN4lwRgKElFz5xD9ix60gnGwwA
         7Bc0Msul48QKSyx8B1NAOuNVlOkG5DLXKve628GTv0HrIC3y5xqKzpSDQsRXEdS3dX7A
         k6X9tEZdau0MKBtIaBx3hAaovL80CPmx4Na21IOjLJw1fKB+5gUfqXcpnDRwHybbu0w2
         XZzg==
X-Gm-Message-State: AOAM531Ljc7LW3rYxxqyMr8mejJK/HJrYQZ7Zx4nDC3BA/eaQIUz7jC7
        SSTlH3yiHqV2HXY+KzJ58Hc=
X-Google-Smtp-Source: ABdhPJx8U7z8t55Ia/mfuaTVfekJPGgOJLCXG0oYpdM1MKkuWJvFzuilELChC3Pro+nwYK48/vS3fg==
X-Received: by 2002:aa7:8010:0:b029:254:f083:66fa with SMTP id j16-20020aa780100000b0290254f08366famr46480013pfi.17.1621008382747;
        Fri, 14 May 2021 09:06:22 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:e40c:c579:7cd8:c046? ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id s16sm4641187pga.5.2021.05.14.09.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 09:06:21 -0700 (PDT)
Subject: Re: [PATCH v3 1/8] core: Introduce scsi_get_sector()
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-2-bvanassche@acm.org> <20210514062007.GA5901@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <255c55c7-fbaf-9443-7d0d-16ebe0e37004@acm.org>
Date:   Fri, 14 May 2021 09:06:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210514062007.GA5901@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 11:20 PM, Christoph Hellwig wrote:
> On Thu, May 13, 2021 at 03:37:50PM -0700, Bart Van Assche wrote:
>> Since scsi_get_lba() returns a sector_t value instead of the LBA, the name
>> of that function is confusing. Introduce an identical function
>> scsi_get_sector(). A later patch will remove scsi_get_lba().
> 
> Why not just do a quick rename in a single patch instead of the hard to
> review series?

Hi Christoph,

Something I noticed in the past is that driver maintainers refuse to add
their Reviewed-by: or Acked-by: if a patch modifies code outside the
driver they maintain. Another reason I split this patch series is that I
really want driver maintainers to take a look. My understanding of
section "4.19 Protection Information" in SBC-4 is that the LOGICAL BLOCK
REFERENCE TAG field should contain the least significant four bytes of
the LBA. However, in multiple SCSI LLDs I found code similar to the
following:

	ref_tag = cpu_to_le32(lower_32_bits(scsi_get_lba(cmd)))

or in other words, the starting offset divided by 512 is assigned to the
reference tag instead of the starting offset divided by the logical
block size. I think that's a bug.

Thanks,

Bart.
