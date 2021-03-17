Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB853C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C1064F21
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhCQDbW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 23:31:22 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:41729 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhCQDbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 23:31:10 -0400
Received: by mail-pj1-f53.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so604922pjb.0;
        Tue, 16 Mar 2021 20:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cJf8KvpeHv6ocq6Q0cAtLJT+80wqWLYnr9EgNxEm+tg=;
        b=KQL6cXCXEYNjgnkG1xQ8QCUQNtMH+LeecWNvisj8ApncPSRDgAE0VdHg9euJLfRgcS
         xqMqJhT0ykdk3LFwGNSoqRmV3+n7bk7i3Vy2oQQdqo7xyYjOyb6zWCS2RdRUpZORNgSU
         i5lrVMCYF8aET/ySTdUT8q8z8LaWCE/x2UG/y6A9PMXwweBO/01VnB45GeMX2hNma137
         U797o3elEK6TT+bTw/+/jVdTzBZarUTFayHOXFLNaKgWLJv/0G0S53sqKd8Pk6gefaau
         NRhz2gB1wMvQzp2P6b/mcxHYpHWRuEi9RBmp5xBC+VHFOyZWlDqtXzdq5vKP+mPo2dCM
         wFJg==
X-Gm-Message-State: AOAM532S0MzmhyUx8nzO7ohNIdgY5MYuPsL21toRAZoCTFLDupIwKjOX
        LtOPaLvPl+H79Mnnqm8FcgA=
X-Google-Smtp-Source: ABdhPJwaE0w+Nt3EM8QHlS0df329a7hy5E9FZI1i6W5GJskW/VANDSdKlKApt7ldoIpGEcUfN5SrQA==
X-Received: by 2002:a17:902:9b84:b029:e5:ee87:6840 with SMTP id y4-20020a1709029b84b02900e5ee876840mr2440684plp.82.1615951869994;
        Tue, 16 Mar 2021 20:31:09 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:1af6:7b8b:eb3:97d0? ([2601:647:4000:d7:1af6:7b8b:eb3:97d0])
        by smtp.gmail.com with ESMTPSA id 8sm18684630pfp.171.2021.03.16.20.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 20:31:09 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: ufs: sysfs: Print string descriptors as raw data
To:     Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, Bean Huo <beanhuo@micron.com>
References: <1613410846-16883-1-git-send-email-Arthur.Simchaev@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9ade874b-b69e-615d-b101-2ecc664ba64d@acm.org>
Date:   Tue, 16 Mar 2021 20:31:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1613410846-16883-1-git-send-email-Arthur.Simchaev@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/21 9:40 AM, Arthur Simchaev wrote:
> -#define UFS_STRING_DESCRIPTOR(_name, _pname)				\
> +#define UFS_STRING_DESCRIPTOR(_name, _pname, _is_ascii)		\
>  static ssize_t _name##_show(struct device *dev,				\
>  	struct device_attribute *attr, char *buf)			\
>  {									\
> @@ -690,10 +690,18 @@ static ssize_t _name##_show(struct device *dev,				\
>  	kfree(desc_buf);						\
>  	desc_buf = NULL;						\
>  	ret = ufshcd_read_string_desc(hba, index, &desc_buf,		\
> -				      SD_ASCII_STD);			\
> +				      _is_ascii);			\
>  	if (ret < 0)							\
>  		goto out;						\
> -	ret = sysfs_emit(buf, "%s\n", desc_buf);			\
> +	if (_is_ascii) {						\
> +		ret = sysfs_emit(buf, "%s\n", desc_buf);		\
> +	} else {							\
> +		int i;							\
> +									\
> +		for (i = 0; i < desc_buf[0]; i++)			\
> +			hex_byte_pack(buf + i * 2, desc_buf[i]);	\
> +		ret = sysfs_emit(buf, "%s\n", buf);			\
> +	}			\
>  out:									\
>  	pm_runtime_put_sync(hba->dev);					\
>  	kfree(desc_buf);						\

Hex data needs to be parsed before it can be used by any software. Has
it been considered to make the "raw" attributes binary attributes
instead of hex-encoded binary? See also sysfs_create_bin_file().

Thanks,

Bart.
