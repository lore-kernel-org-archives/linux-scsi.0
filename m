Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F41CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 17:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6CE0214E0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 17:49:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ow+eVzPk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389993AbfJ1Rti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:49:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33009 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389823AbfJ1Rti (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 13:49:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id s1so10877133wro.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2019 10:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TJeF9SiCHbmuZdXgg1rLisYWI2EX+j8jft0lvIEphIA=;
        b=ow+eVzPktKTe3iG4pfn8XahBb2fkNOkBN67tQEK/SYDBdb6REEzQreomArHMIsMuqq
         WNNTyzSJ1wGzhe58RFfubu1ABNn531RY/WwCOlfuXVNW8LPc2fCoS9K6CvdhyQSrA7xO
         fipOTJODNqQQ5N9lBNMFdwnFB7Km1xN01IFyNlKAM4SFHMamEPyJQSywOxJ+HeDJY/Tf
         DiC2CayviF2guLRDEKMP0Sq4yvTGpdawovBBA+y2zX7/UHDEkK53M1/5hU8fi4FE7/r6
         /0uy6MAV8nbXGnvh4cvD059MxHnk38cep571Mb/EbBMhNkPJybwZSH2SMKCKP6Gngt11
         5gbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TJeF9SiCHbmuZdXgg1rLisYWI2EX+j8jft0lvIEphIA=;
        b=K0d3b34ZPSZID/MMfmQbRTRlMyyURrm8+eTXZTGkJi6qi9pz1DVv2M3uZEfju9W0oX
         uN/l95RUWRWO6l1riuQf/ZdSnZU5trWJdAYOZXDBNCt5awcDa5F8PIHstBkL9JluVx3R
         Z4UFuY93RSSFp0lUSM2mQXF3lJmNjABJrfSCrKnzmQqzV1V+vStUcKsIJlDT/ncVpEs9
         yBiaz6yu1hWfBZuqXwBB/HmLPWnpMGxN9ZCUlLwjYO5XdYNDNN2UTnxnQQRYgm/mPjwQ
         KNcrIiBCEMf8Jjq76nGCDH+1G1IAYo7k8o0ng8fi/D4kn1mwzXMbK7E5Q63yRjIXUEnV
         QRHw==
X-Gm-Message-State: APjAAAVV7Qg/0kkWKdapo+HrThgsXp3C5++jkYwngESmbEBvfYxiZi9K
        EteV+QAXWYNZayjdcLURoYk=
X-Google-Smtp-Source: APXvYqxZ66Eds/tzD5e/arUZ4j6GUAdLmy5Kx9IGfCDUHmd/nTRBx213+f8DEVWzb6Mi23xVB8k80w==
X-Received: by 2002:a5d:6a8b:: with SMTP id s11mr16342699wru.394.1572284975566;
        Mon, 28 Oct 2019 10:49:35 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i3sm12338882wrw.69.2019.10.28.10.49.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 10:49:34 -0700 (PDT)
Subject: Re: [PATCH 24/32] elx: efct: LIO backend interface routines
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-25-jsmart2021@gmail.com>
 <5eae53c2-daee-f1f3-8586-e92fd61a5544@acm.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <2120064f-cc31-e759-9b49-9acc73d7ef91@gmail.com>
Date:   Mon, 28 Oct 2019 10:49:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5eae53c2-daee-f1f3-8586-e92fd61a5544@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thank you Bart.  We've gone through your comments and mostly agree with 
them and will be making the corresponding changes.

For the few exceptions and where you had a couple of questios, see below.

-- james



On 10/24/2019 3:27 PM, Bart Van Assche wrote:
> Additionally, what is a "virtual target"?

The code meant virtual port (NPIV port). The comments will be updated.


>> +static ssize_t
>> +efct_lio_wwn_version_show(struct config_item *item, char *page)
>> +{
>> +    return sprintf(page, "Emulex EFCT fabric module version %s\n",
>> +               __stringify(EFCT_LIO_VERSION));
>> +}
> 
> Version numbers are not useful in upstream code. Please remove this 
> attribute and also the EFCT_LIO_VERSION constant.

 From my time with lpfc, I disagree.  It's true, if looking only at the 
upstream kernel, version doesn't mean much. But when it comes to the 
distros, who may cherry-pick a lot, it has certainly helped to have a 
version string to get a general understanding of what's there. Granted 
you must still look at the code for the actual content, but it's a good 
indicator.



>> +static const struct file_operations efct_debugfs_session_fops = {
>> +    .owner        = THIS_MODULE,
>> +    .open        = efct_debugfs_session_open,
>> +    .release    = efct_debugfs_session_close,
>> +    .read        = efct_debugfs_session_read,
>> +    .write        = efct_debugfs_session_write,
>> +    .llseek        = default_llseek,
>> +};
>> +
>> +static const struct file_operations efct_npiv_debugfs_session_fops = {
>> +    .owner        = THIS_MODULE,
>> +    .open        = efct_npiv_debugfs_session_open,
>> +    .release    = efct_debugfs_session_close,
>> +    .read        = efct_debugfs_session_read,
>> +    .write        = efct_debugfs_session_write,
>> +    .llseek        = default_llseek,
>> +};
> 
> Since the information that is exported through debugfs (logged in 
> initiators) is information that is also useful for other target drivers, 
> I think this functionality should be implemented in the target core 
> instead of in this target driver.

Can you expand further on what you'd like to see and the format of the 
data to be displayed ?

I'll see if it makes sense.

-- james
