From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH] [SCSI] ufs: Assign UTRLBAU = upper_32_ bits(UTRLD base address)
Date: Tue, 24 Apr 2012 15:38:16 +0530
Message-ID: <CALMYJDu+cGb4NCoZRnvdXMQOhNDsJxE38yY_FVqxcqTvZzCd6w@mail.gmail.com>
References: <1335187331-2672-1-git-send-email-santoshsy@gmail.com> <CAKYAXd-aLSBvAGGRYmVDSBunBd8diAhzJ_PHmg7j+XbVbtde0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab2DXKIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2012 06:08:37 -0400
Received: by iadi9 with SMTP id i9so778041iad.19
        for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2012 03:08:37 -0700 (PDT)
In-Reply-To: <CAKYAXd-aLSBvAGGRYmVDSBunBd8diAhzJ_PHmg7j+XbVbtde0g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, rene.dejong@arm.com, vinholikatti@gmail.com

On Tue, Apr 24, 2012 at 10:26 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> 2012/4/23 Santosh Y <santoshsy@gmail.com>:
>> From: Santosh Yaraganavi <santoshsy@gmail.com>
>>
>> UTP Transfer request list base registers UTRLBA and UTRLBAU
>> must be assigned, lower-32 and upper-32 bits of UTRLD list
>> physical base addresses respectively.
>>
>> Currently UTRLBAU is being assigned lower-32 bits of UTRLD
>> physical base address. This will cause an issue with
>> controllers that can support 64-bit addressing.
>>
>> This patch correctly assigns upper-32 bits of UTRLD physical
>> base address to UTRLBAU.
> Hi. Santosh.
> 0 : 9 bits are reserved in UTRLBA of specification. is it considered also ?
> Thanks.
>

Hi Namjae,

During memory allocation for UTRDL, it is made sure that the UTRDL
physical base address is aligned to 1K by checking if the address is
aligned to PAGE_SIZE. If the address is PAGE_SIZE aligned, then it is
aligned to 1K. So we don't have to worry about the first 10 bits while
assigning the base address to UTRLBA.

-- 
~Santosh
