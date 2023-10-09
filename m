Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CC6E95A96
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 15:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376478AbjJIPXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 11:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376366AbjJIPXn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 11:23:43 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB3E9E
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 08:23:41 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c60778a3bfso38478425ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2023 08:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696865021; x=1697469821;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3/eCSJp1IWt+CyHzVPjWFCl13HvBGVBAfeRir3Nqqmc=;
        b=Ig0w6OGgp6MoB6MILV3ds0eFLi1C+fhJ2d08LbuTTdpOjCRV0UiAhufLzLnK1qtgbi
         CqXQQ1BHaU+F9QquZWQ+Xghk7YqGKai4c1EbxoTbJoOlQnwUiJKghPGxAFyJynUknNU0
         UtzMG0Qd9C4BF1C24wyFCzH9+nMpXAqvmD3aFlPgMnIHkZpfLk5C1rW4d2vzMNbjiUvb
         WoSYB1DyO+kxw1U4sAJINjBnm0OPtF/Gx0vNHUPlU8f63AYykLThM/nr7G1JBlvke5NS
         PyLEiDlIYa7YBcI4THgJApW+Km1O/6zxytIP2VCT6D7QnMhqRCw1hgRPWPI477BPwnMy
         TTNQ==
X-Gm-Message-State: AOJu0YzHnqumi/ZkTk6ILReScXF5yMKwJTNFg/BZ/uSDdNVk3waIvhhK
        CQ4I3cZaPDazRQskM2Iu9EGz5n7NxJqcnQ==
X-Google-Smtp-Source: AGHT+IFsQ4SSE2bUMPO11pyblV3g4gJaEHJwgkZDTqqRo0bRDmOsgkbNVewqsFa2mU2QcPTtvVTlFQ==
X-Received: by 2002:a17:902:e74d:b0:1c7:7c2c:f846 with SMTP id p13-20020a170902e74d00b001c77c2cf846mr19442257plf.67.1696865020882;
        Mon, 09 Oct 2023 08:23:40 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id b14-20020a170903228e00b001c61acd5bd2sm9746353plh.112.2023.10.09.08.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 08:23:40 -0700 (PDT)
Message-ID: <5cb8acb9-5731-45d8-b96e-d6ee701d78cb@acm.org>
Date:   Mon, 9 Oct 2023 08:23:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-2-hare@suse.de>
 <c7052e80-3602-469b-8095-ab0eb40e010a@acm.org>
 <18e61efc-bb5f-47f7-91ca-ddce3c9d077c@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <18e61efc-bb5f-47f7-91ca-ddce3c9d077c@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/9/23 07:05, Hannes Reinecke wrote:
> On 10/3/23 19:33, Bart Van Assche wrote:
>> On 10/2/23 08:59, Hannes Reinecke wrote:
>>> +    if ((hd = shost_priv(sh)) == NULL){
>>> +        printk(KERN_ERR MYNAM ": host reset: Can't locate host!\n");
>>>           return FAILED;
>>>       }
>>
>> In the above example and in multiple other cases formatting does not
>> follow the kernel coding style. Please consider to run git clang-format
>> HEAD^ on this patch. Otherwise this patch looks good to me.
>>
> That is correct, but I'm merely following the existing indentation
> within that driver.
> Reformatting the driver to align with current linux standards would be
> a different patch.

As you may know I'm against reformatting code that is not modified.

What I proposed is to reformat only the lines that have been changed.

Thanks,

Bart.

