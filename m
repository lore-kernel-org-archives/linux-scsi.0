Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=BIGNUM_EMAILS,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E052C3A59F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 16:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DB0A2080C
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 16:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9aCYfnE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbfHZQYh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 12:24:37 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43357 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbfHZQYh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2019 12:24:37 -0400
Received: by mail-pl1-f195.google.com with SMTP id 4so10266551pld.10
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2019 09:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JgVewQm+ns/GGjqBfpluBsGgLNW79/nbWfSc5zp8bxs=;
        b=I9aCYfnEJ3vICxtVISEv0ZM+/kHQz1YLR+MEk22s4qJ7PRORubJ9v/wS5Lo7M2Cw/W
         dkrQ5cnah779wWq7gGMz+uBuPnPftsf7sF+Zg+kn6Bux3oSCNduCzI7miLtL+KSQnfbL
         ZIFyIUYCI8uL+x2d/CZGvIjDmZrz8jqccOCcm+UK9iG1H/M/5PaGTb7zCPUrrlDS0iU5
         UnHpeW4nF8SIgmMcQH4YPwpnU6irxGcUWVLAsqOjzv1UbJnfFbi0J/rHaRPjWVSXQ2nW
         WyZhXiJzirlKkN8D7XLjT/5Bp7W0IzCPXpbVGo+CsOaY/s9p/Cl16icoLKDa42rmdQUN
         adWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JgVewQm+ns/GGjqBfpluBsGgLNW79/nbWfSc5zp8bxs=;
        b=IHTHeCf2wPm7Ew615OYxdaH1ASmwqtymRs0rCZu1kiZBSLFFau+XaX6gm4bh9e6w2M
         V2urHBsa03xGUZ8MRoE7XIDuyAB5XFBZM4ncGvNly2z/B0d77OEuRUOSo+t9xBW+WqRr
         N5rVC6ytM4FOdeS8MabfUYjCJar653z0lMtc26/DqHlJ6+ssBl0GdZI5TaS3werlZN/g
         wsjL9S06vQV9RqJlSELFdWMrwXiGZ6IQxgu+LyKmBFzj4+OpWvYS1uLhJqSqoDWelpWk
         kSQFZMEqdSQHDl3CIsdCheUfO8fBv+O9wG/eUAHiacpONMassJHoXpiY/dLRhkr6qvS0
         NBaw==
X-Gm-Message-State: APjAAAWaLMY1CTAt66D4ynmYI15h4p0xUKZGyRfjiEM8DaCgZpuIatfa
        Xl0yr21iOxv1d1Ijjcj7QPTkJ6rD
X-Google-Smtp-Source: APXvYqwvnfeetaC9rm1enaB004jaeGeb6Z/Ywr5e4Q3Om4TnWs2DapSZh8uz1wpHQDFaWyDoKSHLBQ==
X-Received: by 2002:a17:902:543:: with SMTP id 61mr19806041plf.20.1566836676552;
        Mon, 26 Aug 2019 09:24:36 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z16sm11388410pgi.8.2019.08.26.09.24.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 09:24:36 -0700 (PDT)
Subject: Re: [bug report] scsi: lpfc: Support dynamic unbounded SGL lists on
 G7 hardware.
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20190826134044.GA8726@mwanda>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <3cebc3d1-87e2-c8b4-1e2e-a80996b34d8a@gmail.com>
Date:   Mon, 26 Aug 2019 09:24:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826134044.GA8726@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/26/2019 6:40 AM, Dan Carpenter wrote:
> Hello James Smart,
> 
> The patch d79c9e9d4b3d: "scsi: lpfc: Support dynamic unbounded SGL
> lists on G7 hardware." from Aug 14, 2019, leads to the following
> static checker warning:
> 
> 	drivers/scsi/lpfc/lpfc_init.c:4107 lpfc_new_io_buf()
> 	error: not allocating enough data 784 vs 768
> 
> drivers/scsi/lpfc/lpfc_init.c
>    4071  /**
>    4072   * lpfc_new_io_buf - IO buffer allocator for HBA with SLI4 IF spec
>    4073   * @vport: The virtual port for which this call being executed.
>    4074   * @num_to_allocate: The requested number of buffers to allocate.
>    4075   *
>    4076   * This routine allocates nvme buffers for device with SLI-4 interface spec,
>    4077   * the nvme buffer contains all the necessary information needed to initiate
>    4078   * an I/O. After allocating up to @num_to_allocate IO buffers and put
>    4079   * them on a list, it post them to the port by using SGL block post.
>    4080   *
>    4081   * Return codes:
>    4082   *   int - number of IO buffers that were allocated and posted.
>    4083   *   0 = failure, less than num_to_alloc is a partial failure.
>    4084   **/
>    4085  int
>    4086  lpfc_new_io_buf(struct lpfc_hba *phba, int num_to_alloc)
>    4087  {
>    4088          struct lpfc_io_buf *lpfc_ncmd;
>    4089          struct lpfc_iocbq *pwqeq;
>    4090          uint16_t iotag, lxri = 0;
>    4091          int bcnt, num_posted;
>    4092          LIST_HEAD(prep_nblist);
>    4093          LIST_HEAD(post_nblist);
>    4094          LIST_HEAD(nvme_nblist);
>    4095
>    4096          /* Sanity check to ensure our sizing is right for both SCSI and NVME */
>    4097          if (sizeof(struct lpfc_io_buf) > LPFC_COMMON_IO_BUF_SZ) {
>                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> We made the lpfc_io_buf struct larger so now this check is more likely
> to trigger.  Why don't we make this condition a BUILD_BUG_ON()?
> 
>    4098                  lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
>    4099                                  "6426 Common buffer size %zd exceeds %d\n",
>    4100                                  sizeof(struct lpfc_io_buf),
>    4101                                  LPFC_COMMON_IO_BUF_SZ);
>    4102                  return 0;
> 
> Zero means we're returning failure on this path.
> 
>    4103          }
>    4104
>    4105          phba->sli4_hba.io_xri_cnt = 0;
>    4106          for (bcnt = 0; bcnt < num_to_alloc; bcnt++) {
>    4107                  lpfc_ncmd = kzalloc(LPFC_COMMON_IO_BUF_SZ, GFP_KERNEL);
>                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Smatch generates a warning here.  It's obviously not a problem, because
> of the earlier check.  I guess I don't really understand why
> LPFC_COMMON_IO_BUF_SZ is useful when it's so close to sizeof(*lpfc_ncmd).

Completely agree - I'll clean this up.

-- james


