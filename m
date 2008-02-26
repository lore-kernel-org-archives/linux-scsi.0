From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: arcmsr & areca-1660 - strange behaviour under heavy load
Date: Tue, 26 Feb 2008 20:29:31 +0100 (CET)
Message-ID: <alpine.LRH.0.9999.0802262018230.14724@linuxbox.linuxbox.cz>
References: <alpine.LRH.0.9999.0802231201380.21313@linuxbox.linuxbox.cz> <20080224161034.f494fc7f.akpm@linux-foundation.org> <alpine.LRH.0.9999.0802261032440.31781@linuxbox.linuxbox.cz> <20080226094308.35db8f3f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:58820 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbYBZT3z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2008 14:29:55 -0500
In-Reply-To: <20080226094308.35db8f3f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Nick Cheng <nick.cheng@areca.com.tw>, Erich Chen <erich@areca.com.tw>, kopi@linuxbox.cz

Hi Andrew,
no, right now I have the machine in the weird state, swap is empty (3GB), 
and so is bigger part of RAM (~100MB free), and the gcc crashes even when 
trying to compile c program with empty main function. so it doesn't seem 
to be problem with memory exhaustion.
Hopefully the areca guys will be able to find out what is going on. But 
anyways, if You'll have any other idea what should I check/try, please let 
me know, as I have to admit that I'd really like to hunt it down myself 
(and yes, there is some vanity on my side here :))
thanks a lot once more
cheers
nik



  On Tue, 26 Feb 2008, 
Andrew Morton wrote:

> On Tue, 26 Feb 2008 10:35:31 +0100 (CET) Nikola Ciprich <extmaillist@linuxbox.cz> wrote:
>
>> Hi
>>
>> On Sun, 24 Feb 2008, Andrew Morton wrote:
>>
>> Hi Andrew,
>> thanks a lot for reply, I'm attaching requested information.
>> please let me know if You need more information/testing, whatever.
>> I'll be glad to help.
>> BR
>> nik
>>
>>>> Areca support doesn't seem to be very interested in the problem :-(
>>>
>>> (cc's added)
>>>
>>> Please get the machine into this state of memory exhaustion then take
>>> copies of the output of the following, and send them via reply-to-all to
>>> this email:
>>>
>>> - cat /proc/meminfo
>>>
>>> - cat /proc/slabinfo
>>>
>>> - dmesg -c > /dev/null ; echo m > /proc/sysrq-trigger ; dmesg -c
>>>
>>> Thanks.
>
> Alas, that all looks OK to me.
>
> You never get any out-of-memory messages, and no oom-killing messages?
>
> Possibly what is happening here is that in this low-memory condition, some
> of the driver's internal memory-allocation attempts are failing, and the
> driver isn't correctly handling this.  This is a rare situation which may
> well not have been hit in anyone else's testing.
>
> I expect that the Areca engineers will be able to reproduce this with a
> suitably small "mem=" kernel boot option.  If not, they could perhaps
> investigate the kernel's fault-injection framework, which permits
> simulation of page allocation failures.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

-- 

