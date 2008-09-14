From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/4] 24-bit types: typedef and functions for accessing
 3-byte arrays as integers
Date: Sun, 14 Sep 2008 13:32:04 +0300
Message-ID: <48CCE824.7040903@panasas.com>
References: <20080911021448.23621.42553.stgit@localhost.localdomain>	 <48C8D0E0.5060908@panasas.com> <41b516cb0809110712t45baa383y10650d8c6e4961c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:8850 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752836AbYINKra (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Sep 2008 06:47:30 -0400
In-Reply-To: <41b516cb0809110712t45baa383y10650d8c6e4961c4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chris.leech@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jfs-discussion@lists.sourceforge.net, Harvey Harrison <harvey.harrison@gmail.com>

Chris Leech wrote:
> On Thu, Sep 11, 2008 at 1:03 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>> diff --git a/fs/jfs/endian24.h b/fs/jfs/endian24.h
>>> index fa92f7f..45b6397 100644
>>> --- a/fs/jfs/endian24.h
>>> +++ b/fs/jfs/endian24.h
>>> @@ -33,6 +33,9 @@
>>>               ((__x & (__u32)0x00ff0000UL) >> 16) )); \
>>>  })
>>>
>>> +#undef __cpu_to_le24
>>> +#undef __le24_to_cpu
>>> +
>> Does #undef also work on inline functions? I didn't know that
> 
> No, it doesn't and those two lines don't do anything.  The two below
> do, so this file gets touched anyway, and the JFS patch deletes the
> entire file.  I'll fix this is there's some other reason to redo the
> patchset again.
> 
Sorry my bad, yes they get removed one patch later. No need to resubmit
just for that I think

>>>  #if (defined(__KERNEL__) && defined(__LITTLE_ENDIAN)) || (defined(__BYTE_ORDER) && (__BYTE_ORDER == __LITTLE_ENDIAN))
>>>       #define __cpu_to_le24(x) ((__u32)(x))
>>>       #define __le24_to_cpu(x) ((__u32)(x))
>>> @@ -42,6 +45,8 @@
>>>  #endif
>>>
>>>  #ifdef __KERNEL__
>>> +     #undef cpu_to_le24
>>> +     #undef le24_to_cpu
>>>       #define cpu_to_le24 __cpu_to_le24
>>>       #define le24_to_cpu __le24_to_cpu
>>>  #endif

Thanks again for doing this

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

on all patches
