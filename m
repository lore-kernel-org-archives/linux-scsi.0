Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2379AC3404C
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 00:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F16982465D
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 00:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBSALB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 19:11:01 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55852 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgBSALB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 19:11:01 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so1773330pjz.5
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 16:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X86+WKwwZJ0Er/Fgvp7/5f171Hl/1DZsr4zBAjqp64c=;
        b=l3QiBgn2NBrXj60W8cfjekki+VxZDSFqX7mD1HQ+6R/a/l1C1EMVwq1eFjOuK4Y72E
         wCqbaOqTlCabVLiL7sPZzywgitmrOwmvmpYUaoPZEb1pR2wPcR/44fVNQWvUpjQNeH7b
         4FpPeKbDeYAN6yNnd9P2YZFKjcqRKn8mt0PeS3Th7d9gba+m9POMpIOf9BwBamQWSDwC
         2aLRcUt2e8HYtWRyTmbH2yKviJStldtZetSqM8i/ux0B3TOxIPSKOHBdaFF7r37CSvI0
         NFhzX9otJL7EMvy6iZdl7lDzjDp4/ptx74vun1UFIuxnRYoNW2CeBJ7ofCuq67EiyCst
         uohA==
X-Gm-Message-State: APjAAAWGcx6Vn0TNNDjB+3RgTbOEnd4fdzLrF3Dw1TE/qwGwVQj9h1mL
        yfDQYDfi3mgY3rucNmx+/+I=
X-Google-Smtp-Source: APXvYqzLEyP7zHMa5dpJ34vHBs2T+34V0AQpRvoLV7GfoVcFTqICFL7CaS7f53NE285JuarB3jkXOg==
X-Received: by 2002:a17:90b:4396:: with SMTP id in22mr5553863pjb.83.1582071060068;
        Tue, 18 Feb 2020 16:11:00 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:fb9c:664d:d2ad:c9b5? ([2620:15c:2c1:200:fb9c:664d:d2ad:c9b5])
        by smtp.gmail.com with ESMTPSA id y76sm144834pfc.87.2020.02.18.16.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 16:10:59 -0800 (PST)
Subject: Re: [PATCH 2/2] ufshcd: use an enum for quirks
To:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20200218234450.69412-1-hch@lst.de>
 <20200218234450.69412-3-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b4c75415-347a-48e6-ddc7-d419d7774f22@acm.org>
Date:   Tue, 18 Feb 2020 16:10:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218234450.69412-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/18/20 3:44 PM, Christoph Hellwig wrote:
> Use an enum to specify the various quirks instead of #defines inside
> the structure definition.

Hi Christoph,

Although this patch looks like a significant improvement to me: has it 
been considered to change 'quirks' from an unsigned int into a bitfield 
with one bit per quirk? I think that would allow to remove multiple 
explicit bit manipulations from the UFS driver.

Thanks,

Bart.
