From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Fri, 21 Feb 2014 18:46:24 -0500
Message-ID: <5307E550.4040004@hurleysoftware.com>
References: <20140221015935.GF6897@htj.dyndns.org> <5306B4DF.4000901@hurleysoftware.com> <20140221021341.GG6897@htj.dyndns.org> <5306E06C.5020805@hurleysoftware.com> <20140221100301.GA14653@mtj.dyndns.org> <53074BE4.1020307@hurleysoftware.com> <20140221130614.GH6897@htj.dyndns.org> <5307849A.9050209@hurleysoftware.com> <20140221165730.GA10929@htj.dyndns.org> <5307DAC9.2020103@hurleysoftware.com> <20140221231833.GC12830@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140221231833.GC12830@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/21/2014 06:18 PM, Tejun Heo wrote:
> On Fri, Feb 21, 2014 at 06:01:29PM -0500, Peter Hurley wrote:
>> smp_mb__after_unlock_lock() is only for ordering memory operations
>> between two spin-locked sections on either the same lock or by
>> the same task/cpu. Like:
>>
>>     i = 1
>>     spin_unlock(lock1)
>>     spin_lock(lock2)
>>     smp_mb__after_unlock_lock()
>>     j = 1
>>
>> This guarantees that the store to j happens after the store to i.
>> Without it, a cpu can
>>
>>     spin_lock(lock2)
>>     j = 1
>>     i = 1
>>     spin_unlock(lock1)
> ;
> Hmmm?  I'm pretty sure that's a full barrier.  Local processor is
> always in order (w.r.t. the compiler).

It's a long story but the short version is that
Documentation/memory-barriers.txt recently was overhauled to reflect
what cpus actually do and what the different archs actually
deliver.

Turns out that unlock + lock is not guaranteed by all archs to be
a full barrier. Thus the smb_mb__after_unlock_lock().

This is now all spelled out in memory-barriers.txt under the
sub-heading "IMPLICIT KERNEL MEMORY BARRIERS".

Regards,
Peter Hurley
