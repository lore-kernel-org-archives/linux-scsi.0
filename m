Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6BFFC6195
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 19:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74C46222CB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 19:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391299AbfKHTGg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 14:06:36 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41481 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731267AbfKHTGf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 14:06:35 -0500
Received: by mail-pl1-f196.google.com with SMTP id d29so4490342plj.8;
        Fri, 08 Nov 2019 11:06:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KUO65dsRHtTENunurXMA0yCDuIh5HnQm2qnH0n9rKZk=;
        b=o9dz5Qe4M6sM7FUyCfmWKW6PtMw70ob8dVxhyfKKr8WfAVsb2UdIs+ohwTKAOsgOT/
         Dx1kot1lxaKT/JhxcJonAXzP+7Y0zwT2D3NPEHIYzycxNC0sYO7p23d0wBUoiylKmDdt
         1+dklEw2jO9yd+qGvzEPbXyOVtJacYrOVd8VDQ7KhEe0zto8m6A+UMUdu+iVKKOPFHTh
         MWqbccoL4nvgkgecbZBNJSycctqJgyFMHkPH2na3Z38+g9UdmmTVbInhzh0iuf1Zy5nW
         ET29e0M/p0l9uu7ZAXlQNlDn2WJ19VKVXkWfZyzuz3XspIIYC9PlF+XKE+4hcLy0Weww
         G6LA==
X-Gm-Message-State: APjAAAUJ+HZYjrnprm3SwMNbx6w/e5sDAAxY6/xAJdhzicaicZ4ljXe3
        xq3H715X0mn7iHU82E5tq2A=
X-Google-Smtp-Source: APXvYqyIA6IZIhFAL8yKUMxwryNfWoTyBGgHonMtuaTj6pITXvKw5p2xICH26JJvC0HNVp5O2BuxpQ==
X-Received: by 2002:a17:902:d217:: with SMTP id t23mr12191406ply.287.1573239994227;
        Fri, 08 Nov 2019 11:06:34 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a16sm7196444pfc.56.2019.11.08.11.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 11:06:33 -0800 (PST)
Subject: Re: [dm-devel] [PATCH 8/9] scsi: sd_zbc: Cleanup
 sd_zbc_alloc_report_buffer()
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-9-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6a1e0a08-d65c-b075-9bac-23519e9e91c3@acm.org>
Date:   Fri, 8 Nov 2019 11:06:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108015702.233102-9-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/7/19 5:57 PM, Damien Le Moal wrote:
> -	buf = vzalloc(bufsize);
> -	if (buf)
> -		*buflen = bufsize;
> +	while (bufsize >= SECTOR_SIZE) {
> +		buf = vzalloc(bufsize);
> +		if (buf) {
> +			*buflen = bufsize;
> +			return buf;
> +		}
> +		bufsize >>= 1;
> +	}

Hi Damien,

Has it been considered to pass the __GFP_NORETRY flag to this vzalloc() 
call?

Thanks,

Bart.
