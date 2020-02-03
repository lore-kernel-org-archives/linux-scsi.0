Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D5AC35247
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 22:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B0920721
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 22:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBCWal (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 17:30:41 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39402 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgBCWal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 17:30:41 -0500
Received: by mail-pj1-f65.google.com with SMTP id e9so415037pjr.4;
        Mon, 03 Feb 2020 14:30:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ObtV4GuxT1aWcwvfp7nnODJ0y/i5a5qjCP9/aJC070U=;
        b=hW4EiNO0em8pz5wgUw2B4xuZDZ3mT6E50lFB5EAtc8czq4jqrEqrqbOUcklIal5A63
         guM0pZZguacTFTTsoP/RFVDKrmcNfMnvDkJOSrsWrRJHYdO6fK5p3RaA/ljtgW+u59lx
         7QSpuMOi75f0khTuXluY8gA/Q/TWd9ivfI/sZhcLjncuzJ2KgZ+X6CZMtu7Z8QN8AfVA
         uVeMrzfIeyz9f5LrwOJEl6lw4ew+l3qPy6ebnClD6FuNNeMO86d2BKz6o4F2fJoVXcG1
         doA9Sko04QXswsFVUFQ+wCwVMKmSA4J1yKqBE3glWUc3uN1x+7+2O2HNCqam0bkZmchh
         XDCA==
X-Gm-Message-State: APjAAAXEndnBKLBNN3cBaLZEeXowGySWodoQNOD4yz+oTglYFx2DKTcW
        e6bpD/HeIE1LvfUABYcibt6pXQKG
X-Google-Smtp-Source: APXvYqzhao+tOtQQIRX2TXCk3BtyfpXuzqsBketmSKbHOGUSM+cHFPzLANvHmbrGE6KUdsXAh9V19g==
X-Received: by 2002:a17:90a:d783:: with SMTP id z3mr1567408pju.3.1580769040238;
        Mon, 03 Feb 2020 14:30:40 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id s206sm3569842pfs.100.2020.02.03.14.30.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 14:30:39 -0800 (PST)
Subject: Re: [PATCH v4 6/8] scsi: ufs: Add dev ref clock gating wait time
 support
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-7-git-send-email-cang@codeaurora.org>
 <d51c7c51-482a-01c3-fae0-1e83f9df45ac@acm.org>
 <bcbd7e82b1ea6f653d5136e89e70c9f0@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4fee5a64-8ae3-4d90-617f-699b8d27a699@acm.org>
Date:   Mon, 3 Feb 2020 14:30:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <bcbd7e82b1ea6f653d5136e89e70c9f0@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/2/20 11:16 PM, Can Guo wrote:
> On 2020-01-26 11:34, Bart Van Assche wrote:
>> On 2020-01-22 23:25, Can Guo wrote:
>>> +    /* getting Specification Version in big endian format */
>>> +    hba->dev_info.spec_version = 
>>> desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
>>> +                      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
>>
>> Please use get_unaligned_be16() instead of open-coding it.
> 
> I am just keeping symmetry with the other device descriptors,
> for example w_manufacturer_id.

Hi Can,

How about adding an additional patch that refactors the existing code?

Please use get_unaligned_be16() in new code. That makes code easier to 
read compared to open-coding get_unaligned_be16().

Thanks,

Bart.
