Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A026C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 22:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiHBWae (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 18:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237394AbiHBWaM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 18:30:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABAE558C2
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 15:30:02 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso125341pjq.4
        for <linux-scsi@vger.kernel.org>; Tue, 02 Aug 2022 15:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sbLn5/BbsVzDXmiDM5gruvFji+gGb0oB3jAMVbh1DeU=;
        b=P7Ppf6JcVdyZKg/IgEVUbCpOrcKPzY0UZbdf+rzycVt5jiZ+x0lNxevwLlN05HBex6
         nhtNSZ7OEo0qZS/o9orLPdw0/p3TbK6ZQPmUAUp9bohiKYGEKvHpym7YM4C1sgcjULZi
         CuLYqYBTqIN8HTFxAqux+2Du2ZFW0x2+98UpY80c6QdC0uM4OIL0uxyD4pQtP2G8yidq
         5fi6Br2H5iGfyyUsuaJyU+sC8tvUeHv8bFyfXXsEQvDkFrVFWgZqVkbTLv0Cwa3wtPqn
         Lw4geJWDyMU+1u7mlniFwjzXcZzZVlbYKzk9luNtIg6zoLUEUgzfH45IjF6R+svnrrPX
         dUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sbLn5/BbsVzDXmiDM5gruvFji+gGb0oB3jAMVbh1DeU=;
        b=35j342OBalsqyzmNuiTVwVjdqjfb6fES474QLXP83OnCac+mjd66RzsvjAk9OpmQZ4
         yo15JS0VyC111jAOpVnz0EzwjqyiogiprP2SAUz77JJ7MUgBPzbJvu8SQgJ6Wm0KNC6Z
         m2jcF+rPfpwGJnecyzN4n0U9bbbYCSMzasMA65QhKxNpHMWfYWb/6H8FhN/EyWUg5BVN
         mgkcULoE4o54yZ1f98UVzoHt70uyfyp05ULS8vF0CwNPLA9ROi5CQH1l6aDDZL2vAuzB
         oesj4J6PCPjN6Oi7K/9Uulo0iLPre9v+9gBreAWT8dzfGXwCS3ISgjB9OIgo1XBujLdy
         nlQg==
X-Gm-Message-State: ACgBeo0EWAERmnG+NNH8tvkrABzyq6mQFdfpqTcxGoIR+6TGKFPJAQdQ
        sYjLX2Jf8x/MJjndADJJPAcBXXnkN/8=
X-Google-Smtp-Source: AA6agR7VaMu5z4pqjUTB2j+4Otk0PCD5hZjM5IQim1UTQCZjEwU4du/8nNZMFmbv5QzXajYQI3dKmA==
X-Received: by 2002:a17:90b:4f91:b0:1cd:3a73:3a5d with SMTP id qe17-20020a17090b4f9100b001cd3a733a5dmr1706311pjb.98.1659479401786;
        Tue, 02 Aug 2022 15:30:01 -0700 (PDT)
Received: from [192.168.50.208] (ip98-164-252-174.oc.oc.cox.net. [98.164.252.174])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090340c500b0016be4d78792sm186946pld.257.2022.08.02.15.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 15:30:01 -0700 (PDT)
Message-ID: <5575255f-91f1-54d5-709c-4f1d35f8ecfd@gmail.com>
Date:   Tue, 2 Aug 2022 15:29:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH] lpfc: Decouple port_template and vport_template
Content-Language: en-US
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     "Dwip N. Banerjee" <dnbanerg@us.ibm.com>
References: <20220705094203.50154-1-dwagner@suse.de>
 <20220721094939.jhsf2636536ao4yc@carbon>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20220721094939.jhsf2636536ao4yc@carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/21/2022 2:49 AM, Daniel Wagner wrote:
> On Tue, Jul 05, 2022 at 11:42:03AM +0200, Daniel Wagner wrote:
>> From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>
>>
>> The problem here is that the lpfc_hba structure has been freed but the
>> Scsi_Host's hostt pointer is still pointing to the (v) port template
>> area inside the freed hba structure - through which the module is
>> accessed.
>>
>> Basically we need to ensure that the access to the module structure
>> (via the host template or otherwise) stays valid even after the HBA
>> structure is freed (or delay that free).
>>
>> Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
>> Signed-off-by: Daniel Wagner <dwagner@suse.de>
>> ---
>> Hi,
>>
>> This patch is in our downstream kernels for a while. I've forward
>> ported so we also fix the upstream driver for everyone.
>>
>> @Dwip, I took the liberty to add your SoB, hope this is okay.
>>
>> Daniel

We are reproducing this issue now, but think the fix should be slightly 
different. We're putting it together for testing.

-- james


