Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9BCC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 05:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9776F207D4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 05:31:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbBIltC6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgGBFbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 01:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgGBFbE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 01:31:04 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EE4C08C5C1
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2020 22:31:03 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w3so13838423wmi.4
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jul 2020 22:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8yxECCqkQ3sk7NpAS8JszFCk7FDBvRCz1Y3L+znJIyQ=;
        b=QbBIltC6R+nrmX9WHUGEbWPcd4zj6AiO52YDDYp66DXulawC7nsSXWXcAewLSrtiZk
         XOU/N8EWFmUsIBLuSbnBOApNKl+i6umD2+GrucWvLAlAc1Zzz/cRaMd1kXrnXrpxJrf4
         jk6Tw4qNwpj3DJ7g+55+45ImNnI5CTzuyO5HpBnVusUxPpo645kJXAgqnoUpSY5wjFNi
         m1dzDxBxzph6hTfSMz8QUsRsNJ8xb5baDtJVfFEurYKBXLKybnWirpXdF9nLn96t1Oi7
         iXFrFY1xBecpU6p4WvxdymFNwAFWCH88Kzz0zJySAsT0uCcvWJonLrS7Lo3bw40ky9Mb
         Brvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8yxECCqkQ3sk7NpAS8JszFCk7FDBvRCz1Y3L+znJIyQ=;
        b=QG6DlHirVMIo6gIDEy5JRJotAk5v+jJwPxXNxnp1qH6DD5q5+4gQ/Pl70ZmHvoRjQQ
         6RO5P22IjflOxvwAGqhShwYp5OmE+e3JOrpNvQlN77xiMAJId7CKf4qdUDlnjgbd1zu5
         yPEuiBv4IMlo4rz3uVGqBOU5ay+8GbioYddUg+Tcm6oBdM8FEKNBxlNV/krzR6Fc/oSH
         /LH+HLAvo7q80EC9Swq6eQBi5nds2CR5FZG1llMW2sNXXXG58zQb2G3YJdaf6K4WwhCU
         tbLlP2xhFvirCRMMP9UNV90fauLoutZHVzC0A0+EYkzUgbOUN8i6KfffkbXmhBqepSVI
         UQOg==
X-Gm-Message-State: AOAM531qrpinkEbgh8v3tyI87qY8z6q7yh1U4g1JH8YTDEQD9K0mrVSo
        nB1Z35bu4ditywVZk+0a5mmWy8/e
X-Google-Smtp-Source: ABdhPJxZjDmdHjae3QiGFvQWxShJ7huwctQNnGV1jr0UAv9VeyofOSSwKQIJ0SrBnWR86HzO/LKlfg==
X-Received: by 2002:a7b:c210:: with SMTP id x16mr5967994wmi.178.1593667862514;
        Wed, 01 Jul 2020 22:31:02 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j4sm4998202wrp.51.2020.07.01.22.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 22:31:01 -0700 (PDT)
Subject: Re: [PATCH 03/14] lpfc: Fix first-burst driver implementation.
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
 <20200630215001.70793-4-jsmart2021@gmail.com>
 <yq1o8oyaaeh.fsf@ca-mkp.ca.oracle.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <a8d5e44a-df9c-ed98-2020-a4ec2f75791c@gmail.com>
Date:   Wed, 1 Jul 2020 22:30:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <yq1o8oyaaeh.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/1/2020 8:05 PM, Martin K. Petersen wrote:
> 
> James,
> 
>> - Upon PRLI completion, if first-burst is enabled and the target supports
>>    first burst, the driver will issue a modesense6 scsi command to obtain
>>    the disconnect-reconnect page that has transport specific limits. This
>>    page reports the max first-burst size supported on the target. The size
>>    supported is saved in the target node structure.
> 
> I didn't make it beyond this patch :(
> 
> Why do this in the driver? If you need the Disconnect-Reconnect page,
> then let's ask for it in the core code. Maybe in the fc transport so we
> don't risk upsetting USB devices, etc. See sas_read_port_mode_page().
> 

Because it was rather awkward to coordinate, snoop, sample at the right 
time, and a lot more work when implemented in the midlayer.  I really 
don't like that scsi put transport controls in a scsi mode page.

I will take another look at it. It should be queried about the same time 
as when luns are first probed - lun 0 or report luns, or on the first 
lun probed as it's an I_T set of parameters. Not sure if it should be 
saved in the starget (fields are defined generically) or in the transport.

Please review the rest and I can repost for any comments on the other 
patches and I'll remove this patch.

-- james
