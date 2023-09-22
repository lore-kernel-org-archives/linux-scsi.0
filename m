Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E8DCE7A81
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 21:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjIVVcl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 17:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjIVVch (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 17:32:37 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F93198;
        Fri, 22 Sep 2023 14:32:19 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-690bfd4f3ebso2494109b3a.3;
        Fri, 22 Sep 2023 14:32:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695418339; x=1696023139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5J6YExrFCJDMoWcxoNn02wSEAXi/AuqJGzHniqoK5f4=;
        b=pNvIwitDQRb28cR8orgrJW22uDZZQYuhyxT4Lu8vouhljMzBnHwpDJ0vajOuasBM7K
         7JIVPjvJRdVGZIXgghDMk03BJBMn4eRn789VJM70olL28m25clStyht4i865ZpwHQ2Rw
         HeQar6zGZb6MQlvI4HGiVyzid1uelxXtimsj9VWA0hS5tcrKgc+DX0Z9NTtZrI6f8zZV
         cxB2+5LW42eznkhSaQHHTtmQupwuQyB679qUhJXlp1J7MAgwib+iNJVVqYIuzCg1ucq/
         vbU5CPIQ+uA0fUEwvyz3Y/Jr+pdW7OT2BsAp7D5heNPi0HpxsLnsIQcfregl8juD5r71
         uQgA==
X-Gm-Message-State: AOJu0YwWdkAU9/fZeTs+fbxlAIy6MECmMnE5CoDMWay/lZq29V07K/6b
        4RdJaWIcaj7aHLg3tjiAR2I=
X-Google-Smtp-Source: AGHT+IG5fP2Jd2ZDvBNmNDAgAXFyRoHIZQs8Rt6Memrqlqm6ezU+O2cPdDLdFtR4j0nZviLgTHcNYg==
X-Received: by 2002:a05:6a20:4424:b0:154:c959:f157 with SMTP id ce36-20020a056a20442400b00154c959f157mr937700pzb.30.1695418339047;
        Fri, 22 Sep 2023 14:32:19 -0700 (PDT)
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id k9-20020aa78209000000b00690c926d73bsm3645933pfi.79.2023.09.22.14.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 14:32:18 -0700 (PDT)
Message-ID: <e638233c-60dc-4da7-9ff2-a3adcca18f7b@acm.org>
Date:   Fri, 22 Sep 2023 14:32:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230921180758.955317-1-dlemoal@kernel.org>
 <20230921180758.955317-10-dlemoal@kernel.org>
 <49f609ca-f862-4dce-95d8-616acbbc3e0e@acm.org>
 <1166d617-529f-a85b-eb51-427e8c2e8e45@kernel.org>
 <a745a2a7-e740-4bf3-a775-e22bc55dbe58@acm.org>
 <881dd17e-cc23-0cdc-f3bf-99bd571dbdf0@kernel.org>
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <881dd17e-cc23-0cdc-f3bf-99bd571dbdf0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 13:36, Damien Le Moal wrote:
> On 2023/09/22 13:08, Bart Van Assche wrote:
>> Does that comment perhaps refer to the SDEV_BLOCK / SDEV_CREATED_BLOCK
>> states? Anyway, I'm wondering whether there are better ways to prevent
>> that it is attempted to queue SCSI commands if a SCSI device is
>> suspended, e.g. by checking the suspended state from inside
>> scsi_device_state_check() or scsi_dispatch_cmd().
> 
> Using information in the device ->power structure is not reliable without
> holding the device lock(), so we should not do that. But we can add a
> "suspended" scsi_device flag that we maintain on execution of
> sd_suspend_system() and sd_resume_system(). Many drivers do that...
> Thoughts ?

That sounds good to me.

Thanks,

Bart.

