Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FDCC33C9E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B99072067D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ybpc/mCM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgAIBDD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 20:03:03 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46906 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgAIBDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 20:03:03 -0500
Received: by mail-pg1-f194.google.com with SMTP id z124so2350645pgb.13
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2020 17:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EDU3Hjv77pqz0Fsbdl+b5/i0t6Ajk/hwTMoXvH+DRrE=;
        b=Ybpc/mCMp/A6RQMWuYSzttAVntKAOUsFqF/sHxme3YoInwCYqicXgpCR/Syp9mfIqF
         6TtQqmkufV4r42QAWefjLDHxkK/Mr6Y0kfcre/EfY2M0BeqR0MX3hvtlLFW906+VM+H5
         TZHRImNmEZyBwAV4UzL7CKvjP4rrCu+f6O3QE/z/ptmjXhDhD0hNW537X+hZMxdKAZ6e
         bUT2/dCoF6IukyDGBtYm4952BqNM1keZQ+OvVP8eM1aJSwFGti66TRNwDu/0FLddPOJH
         TfGhLWUo0JrXOSB1QbEZeUk5UyMKJlthy9vP5cJ6Mr9mto6MFs+wifuPrM3fFPrcIFE1
         HIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EDU3Hjv77pqz0Fsbdl+b5/i0t6Ajk/hwTMoXvH+DRrE=;
        b=F7zYUFSgcsiLbVG6no6jJ/F8QhiPX91+3ExlbJ2Qj/rbOC3JrBY7CRBvYfNhhGJbRa
         W43NUyUYlqU7EOOHEQicPnHKzkRY6CizVH04ClUFs/8Xp57+sk/jwEMkHa4MCUSSyiwd
         5W6/ARs4nPoKk/OVB4HavrS+lTolV9jijBAx344grKOhYY64EMz2BnWu3lLa46AvnEa1
         iSsFJp64Z9iT58cAPuApxK9NNVID/mIKBeM0YWNvHun7uqVywuX+vO++DilqfHlXi0s0
         bRxI+/H9/wKK+mFeH3jErkRvDLV4I9fMzD2gVLCOHRJM+aSJURh43tXk27GW5mJei86U
         /utw==
X-Gm-Message-State: APjAAAXzgrbtNH+UkSLpYKWkhG1TxG2JqH4GLXSHpDoNK0ZAcbLJ0Ozw
        HIXiHWnKFNG7OvFWYI4zd0A=
X-Google-Smtp-Source: APXvYqyGK/MwPBZuHMmB8SmXWaP8169Eb+byIfjESkPlI4ZoO7kim+VaxhKMmyTxt78Zp45OC4sy6Q==
X-Received: by 2002:a63:2ac2:: with SMTP id q185mr8378249pgq.417.1578531782402;
        Wed, 08 Jan 2020 17:03:02 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k5sm485905pju.5.2020.01.08.17.03.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 17:03:01 -0800 (PST)
Subject: Re: [PATCH v2 03/32] elx: libefc_sli: Data structures and defines for
 mbox commands
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-4-jsmart2021@gmail.com>
 <479ac7f4-80ac-babe-7aa6-aa91e257ec8f@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <bc042904-3a4c-ce96-3d14-cace98b1fa13@gmail.com>
Date:   Wed, 8 Jan 2020 17:03:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <479ac7f4-80ac-babe-7aa6-aa91e257ec8f@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/7/2020 11:32 PM, Hannes Reinecke wrote:
> On 12/20/19 11:36 PM, James Smart wrote:
>> @@ -1995,7 +1995,7 @@ struct sli4_fc_xri_aborted_cqe {
>>   #define SLI4_ELS_REQUEST64_DIR_READ		0x1
>>   
>>   #define SLI4_ELS_REQUEST64_OTHER		0x0
>> -#define SLI4_ELS_REQUEST64_LOGO		0x1
>> +#define SLI4_ELS_REQUEST64_LOGO			0x1
>>   #define SLI4_ELS_REQUEST64_FDISC		0x2
>>   #define SLI4_ELS_REQUEST64_FLOGIN		0x3
>>   #define SLI4_ELS_REQUEST64_PLOGI		0x4
> Shouldn't this rather be merged with the previous patch?

yes - will do so


> Make this two enums, one 'enum sli4_mbx_cmd' and one 'enum sli4_mbx_status'.
> 
...
> 
> Single enum should rather be converted into a #define ..
> 
...
> Why is this an enum, and the above SLI4_INIT_LINK_F_XXX value are defines?
> Please be consistent.
> 
> And this applies throughout the remainder of the patch.
> 
> Cheers,
> 
> Hannes
> 

We will convert to multiple enums.

Thanks

-- james
