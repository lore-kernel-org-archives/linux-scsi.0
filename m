Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE817C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 17:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380773AbiAaRNY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:13:24 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:50908 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380766AbiAaRNX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 12:13:23 -0500
Received: by mail-pj1-f50.google.com with SMTP id o11so14636282pjf.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2022 09:13:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mh9nehP5l9CaTR1mM+8NfN5rVG/KoU5SaMjQGnZRFgc=;
        b=PqFk4wzi8fP477/1Dzjgv55t/LDXO3C/GV2ST6ToHSLuS7p73bMvAeIUefSKNy23hM
         h5j1jFD/fRVwx8D2toP0oDNf1pcmBdsO1Ni1037669I0cDmvFo3RNVg4eQfmLTrjOMVJ
         ZzhmVyaQrWZm2dewW8/XvgKixXjMlYaRisnWZVK0hTs0ZmdyCRk9xm4xwnBzTorYxjzm
         OMzW2ZuIZK8SSurfLs6GG+fBrTijNDQ2KQoR7+/wvMElrDssMeubdWNt4HPdPB/R0pGC
         walXDMSZA/E8cFFn94nMIlXqZ1v19NL8BoKQlV2qbJxfs0jT8GqG11qgM7g+/aqYqcmi
         sgPg==
X-Gm-Message-State: AOAM530Vb9btx6bRNGx80v3M9qvT8cBrj5NGTb4CCmCT5dPnzVquKk+I
        7Po7NZQPP8t+ZwRLvkmvtT8=
X-Google-Smtp-Source: ABdhPJyJO3p/RA2wpbzkfbqE0nLxotDkMd28S93bf43utvUbE8l06/IsJPjhAAjhEG5hv1UQVMAENA==
X-Received: by 2002:a17:90a:f682:: with SMTP id cl2mr35174982pjb.59.1643649202395;
        Mon, 31 Jan 2022 09:13:22 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id d2sm12038617pju.2.2022.01.31.09.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:13:21 -0800 (PST)
Message-ID: <dfe21b37-101b-4b20-c039-1b9861429f5d@acm.org>
Date:   Mon, 31 Jan 2022 09:13:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 11/44] aha1542: Remove a set-but-not-used array
Content-Language: en-US
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-12-bvanassche@acm.org>
 <bf7e5fb43e80ec74fe88014bba6c3ebbdcac3a19.camel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bf7e5fb43e80ec74fe88014bba6c3ebbdcac3a19.camel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/31/22 02:25, Johannes Thumshirn wrote:
> On Fri, 2022-01-28 at 14:18 -0800, Bart Van Assche wrote:
>> @@ -240,7 +239,7 @@ static int aha1542_test_port(struct Scsi_Host
>> *sh)
>>          for (i = 0; i < 4; i++) {
>>                  if (!wait_mask(STATUS(sh->io_port), DF, DF, 0, 0))
>>                          return 0;
>> -               inquiry_result[i] = inb(DATA(sh->io_port));
>> +               inb(DATA(sh->io_port));
>>          }
> 
> 
> Maybe:
> 		(void)inb(DATA(sh->ip_port));
> 
> so it's obvious we don't care about the read data.

I will make that change. Thanks for all the reviews!

Bart.
