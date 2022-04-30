Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45719C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Apr 2022 09:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241105AbiD3JKX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Apr 2022 05:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239130AbiD3JKW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Apr 2022 05:10:22 -0400
Received: from smtp.smtpout.orange.fr (smtp04.smtpout.orange.fr [80.12.242.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368BE888CA
        for <linux-scsi@vger.kernel.org>; Sat, 30 Apr 2022 02:07:00 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id kj42nAiNWPp5ukj42nS5Lg; Sat, 30 Apr 2022 11:06:57 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 30 Apr 2022 11:06:57 +0200
X-ME-IP: 86.243.180.246
Message-ID: <c920e37a-b690-e614-c052-634177bbeb46@wanadoo.fr>
Date:   Sat, 30 Apr 2022 11:06:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] scsi: elx: efct: remove unnecessary memset in efct_io
Content-Language: en-US
To:     Finn Thain <fthain@linux-m68k.org>,
        Wan Jiabing <wanjiabing@vivo.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        cocci@inria.fr
References: <20220318145230.1031-1-wanjiabing@vivo.com>
 <794191df-e745-c591-bf1d-37945f96e73a@wanadoo.fr>
 <eab847fe-8d17-1a38-b55e-e68a2f6a1829@linux-m68k.org>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <eab847fe-8d17-1a38-b55e-e68a2f6a1829@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Le 30/04/2022 à 09:48, Finn Thain a écrit :
> On Sat, 30 Apr 2022, Christophe JAILLET wrote:
> 
>> Le 18/03/2022 à 15:52, Wan Jiabing a écrit :
>>> io->sgl is allocated by kzalloc(). The memory is set to zero.
>>> It is unnecessary to call memset again.
>>>
>>
>> Hi,
>>
>> Nitpick: this kzalloc() should be a kcalloc() to avoid an open-coded
>> multiplication when computing the size to allocate.
>>
> 
> Seems like kcalloc() conversion could be a separate patch. Perhaps it
> could be done everywhere using a coccinelle script.

Sure it can and I guess that many coccinelle script already exist for it.

I only replied here because of a comment from Joe Perches on the same 
patch a few month ago (see [1] and [2])

So Wan Jiabing or anyone else, if you want to go one step further, just 
feel free to propose it.

CJ


[1]: 
https://lore.kernel.org/all/4208b3d08a677601c73889f78dd25e5c9f056a86.camel@perches.com/

[2]: 
https://lore.kernel.org/all/9be7d5beb437583f8d975d168ac5c3e32fb6e465.1639158677.git.christophe.jaillet@wanadoo.fr/
