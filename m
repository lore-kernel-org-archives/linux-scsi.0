Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76636C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 17:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiI3RaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 13:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiI3R3s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 13:29:48 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AC75595
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 10:29:35 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id l12so4690543pjh.2
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 10:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tn9sPQBOfapCrDR0qpefAdWhRDg0rs6ZB+tDSMM2Kq8=;
        b=nQUchIRcnuH3atDykuf6O0tsaLLC2juwrHAaQISo+nTcqjN13jbN+sxRTv9RmHlsHb
         iaGwglSOTIJzoX+AfWd3KTrZht4voNUbK3/+5RMzVHdtdVAx4e1LYStcLcAs4I/nj49p
         duiBojnCuvo0ArhFo08XBWPlbvxExkxM+4PyrctEamHSEuOMLx7Pr2q7rUIQBJ65U5L1
         +ns3gRVVdMkPFeYIuAfT/DiQOXKf0YaeKPAhIwB3k4FFE/sYssGDs/WG5O62Xrj4zQUt
         cmWj0zWIzwNLBsCqJgW+W8jt2km3jN4qUbnez/KTKEbD5JcV+O2BBprhZ3R+Dk06UUCU
         UMaQ==
X-Gm-Message-State: ACrzQf3o2EMn7gOy47WujOznVP3fkfl3wQA/L1K37ymm8H9mNTl14+Rf
        gpwT88tn4ezgjDgJt1LLsWCIsq4WJJI=
X-Google-Smtp-Source: AMsMyM6Ynfzl2hTkD/JVMFeajvm0kCRrfjISQmndlLaTi6EooMP8HdOq6yDyaGwDMWae31arrr0dcg==
X-Received: by 2002:a17:902:cf4c:b0:179:ecff:ea5b with SMTP id e12-20020a170902cf4c00b00179ecffea5bmr10186500plg.117.1664558973797;
        Fri, 30 Sep 2022 10:29:33 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:56f2:482f:20c2:1d35? ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902eb8c00b0016bf5557690sm2170533plg.4.2022.09.30.10.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 10:29:32 -0700 (PDT)
Message-ID: <b4153196-23b6-8687-f56b-c875dc5fbd62@acm.org>
Date:   Fri, 30 Sep 2022 10:29:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220929025407.119804-1-michael.christie@oracle.com>
 <20220929025407.119804-4-michael.christie@oracle.com>
 <046b3307-7a7a-80e0-e34a-9fb11171e241@acm.org>
 <9f501492-415e-f7fc-137a-bd5b96a806ed@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9f501492-415e-f7fc-137a-bd5b96a806ed@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 19:43, Mike Christie wrote:
> On 9/29/22 7:12 PM, Bart Van Assche wrote:
>> On 9/28/22 19:53, Mike Christie wrote:
>>> +int __scsi_exec_req(struct scsi_exec_args *args)
>>
>> Has it been considered to change the argument list into "const struct
>> scsi_exec_args *args"?
> 
> Yeah I meant to ask you about this. We do end up updating resid, sense
> buf, and sshdr, but because those are pointers I can make it
> "const struct scsi_exec_args *args" and it's fine since we are not
> updating fields like buf_len.
> 
> I was thinking you wanted fields like cmd const though. So do you want
> 
> 1. "const struct scsi_exec_args *args"
> 
> plus
> 
> 2. pointers on that struct that we don't modify like cmd and sdev also
> const.
> 
> ?
  Hi Mike,

I care more about (1) than about (2). The following code:

__scsi_exec_req(&((struct scsi_exec_args){...}));

creates a temporary struct on the stack and passes the address of that 
temporary to __scsi_exec_req(). Changing the argument type of 
__scsi_exec_req() from struct scsi_exec_args *args into const struct 
scsi_exec_args *args ensures that __scsi_exec_req() cannot modify *args 
if 'args' points at a temporary data structure on the stack.

Thanks,

Bart.
