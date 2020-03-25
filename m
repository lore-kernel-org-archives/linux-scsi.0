Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BEBC54FD0
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 15:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7504120740
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 15:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="1JyTDKPi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgCYPkt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 11:40:49 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51667 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbgCYPkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 11:40:49 -0400
Received: by mail-pj1-f66.google.com with SMTP id w9so1187717pjh.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2020 08:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VJQwrHc5KYK1Moq3YLhA+cPCCwDV01vQIttVxXnXwtc=;
        b=1JyTDKPiJO30x26Vu1Vfe2MkHut80Eu7Wdc4i8X+qy6dwmGmseVAFDQ6WszS+sKQ2G
         JGg7ozTNVg/8hbbXyrmJcMb34TSODC1+oR+UUqOhQNnDwVgsxbZM13xKBFAXwnURMDYh
         VedK/p7dYdTAin6MFLxB5cx80u2rLqPr8EJYYYnyIMtaWe4Ifxdsqq8qgR3BE78h6jsM
         bAM98SrCRGfZBjL5yHHGuhvvmLqXIHS9zxoC9cz11gN+PHCiyFUcxDuH0PzZozte/Sri
         CTONI7IyWiE6+Tvq3jj4sHaGO8jtye+9L1Mz8y6kR4ovsdNjyaSl5RDhXCUS0bpG5v8v
         4WVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VJQwrHc5KYK1Moq3YLhA+cPCCwDV01vQIttVxXnXwtc=;
        b=pSeBGbhN/jeSGa8YWRBfjV1KVmEhQMsMwUhVjziiRCnjV1AtZU+OtAm/uwWCF61hi6
         oipvN8sEkMhzCI2q07GgHxKj8y23l/cUmCVp78b0xOPreEzq1Dy4GAv5AjtmG8sk7oQt
         /V80YcEsn79We8R4PW1z0Q9Y+PM05UB+iJCTY0up4aJf9BJ090+k1cr3apI+2CbZeHmi
         bLwspWYxQo6oblAucaHxpcN56385mI9FVMIX4WCFeG4Ora762iZgsD8XkA1fQ+odL8P3
         wB8wqbO4fVXLcUJKR3LhS0uT10wAp5NzdtFWy9MD3n/4x7UOTuqlQso6jCzjOiTY0Lkx
         i9nQ==
X-Gm-Message-State: ANhLgQ1muHOJqwwdQRgACHBM1b5O3QqBJPztmpwNYv4pTFnFUC0BnsKC
        LjMXLol95kE3fZj3f1qP4Y5Pug==
X-Google-Smtp-Source: ADFU+vt11pwSKIyZE73gAeB7bBFUnxt1iyuPeAwqagoBJzJF0qoXWAvo44C06Qoa0vIxZF23n5jzXw==
X-Received: by 2002:a17:902:9a46:: with SMTP id x6mr3879020plv.80.1585150847821;
        Wed, 25 Mar 2020 08:40:47 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g2sm11445369pfh.193.2020.03.25.08.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:40:46 -0700 (PDT)
Subject: Re: [PATCH v2 01/11] block: factor out requeue handling from dispatch
 code
To:     Christoph Hellwig <hch@infradead.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200324152454.4954-1-johannes.thumshirn@wdc.com>
 <20200324152454.4954-2-johannes.thumshirn@wdc.com>
 <20200325084030.GB11943@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <defdc64c-a83b-509d-c7d6-c8aae0cbd4a7@kernel.dk>
Date:   Wed, 25 Mar 2020 09:40:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200325084030.GB11943@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/25/20 2:40 AM, Christoph Hellwig wrote:
> On Wed, Mar 25, 2020 at 12:24:44AM +0900, Johannes Thumshirn wrote:
>> Factor out the requeue handling from the dispatch code, this will make
>> subsequent addition of different requeueing schemes easier.
>>
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Jens, can you pick this up?  I think it already is a nice improvement
> even without the rest of the series.

Sure, applied for 5.7.

-- 
Jens Axboe

