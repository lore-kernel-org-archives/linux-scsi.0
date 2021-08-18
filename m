Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBDFC4320A
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 01:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B066103A
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 01:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhHRBN0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 21:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232294AbhHRBNZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 21:13:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BFEA6101A;
        Wed, 18 Aug 2021 01:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629249171;
        bh=S8IVosKYq3uGM5PpqT7ajdvdqx5XHpErpy3tG/+l8vQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=J91kq0uaiNCX8Hx1ZJO1LFAEVV7KbzmTaEL+XrAGb3+CnD1BF4Hm2k6iPKCVfKtHH
         ri9GhE75cTx0d6r4BOB0EQM37kJc/z7nVmLCAz8OBZ2743716+IjJJN4OhiTUMRsF5
         Z+rzQyaiQH2PBfC5R3AsLM5iVTBtszj1uHRJunpCp0hKFnggkBul7mOJKnk4A6YWZu
         7IXhb0itDe17Lts8QUUu9TY8VA6e06ptyQXTiyiVrJgmTaWHqnJ47vsyYeIyScVCb8
         qzjtxz3UOX/zvdNQ4y7CEZeZ6e4ZZP5yNBt8wIujxV8bBN2JN7qYnZ18IINSJvBSvR
         M0/wAsHWs54CQ==
Subject: Re: [PATCH] scsi: st: Add missing break in switch statement in
 st_ioctl()
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20210817235531.172995-1-nathan@kernel.org>
 <7843ce6b-92ae-7b6c-1fc-acb0ffe2bbc0@linux-m68k.org>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <a3499a19-d9ed-b8e5-341e-0aa02774b645@kernel.org>
Date:   Tue, 17 Aug 2021 18:12:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7843ce6b-92ae-7b6c-1fc-acb0ffe2bbc0@linux-m68k.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2021 5:54 PM, Finn Thain wrote:
> On Tue, 17 Aug 2021, Nathan Chancellor wrote:
> 
>> Clang + -Wimplicit-fallthrough warns:
>>
>> drivers/scsi/st.c:3831:2: warning: unannotated fall-through between
>> switch labels [-Wimplicit-fallthrough]
>>          default:
>>          ^
>> drivers/scsi/st.c:3831:2: note: insert 'break;' to avoid fall-through
>>          default:
>>          ^
>>          break;
>> 1 warning generated.
>>
>> Clang's -Wimplicit-fallthrough is a little bit more pedantic than GCC's,
>> requiring every case block to end in break, return, or fallthrough,
>> rather than allowing implicit fallthroughs to cases that just contain
>> break or return. Add a break so that there is no more warning, as has
>> been done all over the tree already.
>>
>> Fixes: 2e27f576abc6 ("scsi: scsi_ioctl: Call scsi_cmd_ioctl() from scsi_ioctl()")
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>> ---
>>   drivers/scsi/st.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
>> index 2d1b0594af69..0e36a36ed24d 100644
>> --- a/drivers/scsi/st.c
>> +++ b/drivers/scsi/st.c
>> @@ -3828,6 +3828,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>>   	case CDROM_SEND_PACKET:
>>   		if (!capable(CAP_SYS_RAWIO))
>>   			return -EPERM;
>> +		break;
>>   	default:
>>   		break;
>>   	}
>>
>> base-commit: 58dd8f6e1cf8c47e81fbec9f47099772ab75278b
>>
> 
> Well, that sure is ugly.
> 
> Do you think the following change would cause any static checkers to spit
> their dummys and throw their toys out of the pram?
> 
> @@ -3828,6 +3828,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   	case CDROM_SEND_PACKET:
>   		if (!capable(CAP_SYS_RAWIO))
>   			return -EPERM;
> +		break;
> -	default:
> -		break;
>   	}
>   	

I cannot speak for other static checkers but clang does not complain in 
this instance. cmd_in is the switch value, which is unsigned int; as far 
as I am aware, clang will only complain about a switch not handling all 
values when switching on an enumerated type.

Gustavo, if you are already handling all of the other warnings in -next, 
do you want to take this one too?

Cheers,
Nathan
