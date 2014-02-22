From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Sat, 22 Feb 2014 09:48:55 -0500
Message-ID: <5308B8D7.3040309@hurleysoftware.com>
References: <20140221021341.GG6897@htj.dyndns.org> <5306E06C.5020805@hurleysoftware.com> <20140221100301.GA14653@mtj.dyndns.org> <53074BE4.1020307@hurleysoftware.com> <20140221130614.GH6897@htj.dyndns.org> <5307849A.9050209@hurleysoftware.com> <20140221165730.GA10929@htj.dyndns.org> <5307DAC9.2020103@hurleysoftware.com> <20140221231833.GC12830@htj.dyndns.org> <5307E550.4040004@hurleysoftware.com> <20140222143859.GD12830@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140222143859.GD12830@htj.dyndns.org>
Sender: target-devel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/22/2014 09:38 AM, Tejun Heo wrote:
> Hey,
>
> On Fri, Feb 21, 2014 at 06:46:24PM -0500, Peter Hurley wrote:
>> It's a long story but the short version is that
>> Documentation/memory-barriers.txt recently was overhauled to reflect
>> what cpus actually do and what the different archs actually
>> deliver.
>>
>> Turns out that unlock + lock is not guaranteed by all archs to be
>> a full barrier. Thus the smb_mb__after_unlock_lock().
>>
>> This is now all spelled out in memory-barriers.txt under the
>> sub-heading "IMPLICIT KERNEL MEMORY BARRIERS".
>
> So, that one is for unlock/lock sequence, not smp_mb__after_unlock().
> Urgh... kinda dislike adding smp_rmb() there as it's one of the
> barriers which translate to something weighty on most, if not all,
> archs.

The ticket lock, which is used on x86 to implement spinlocks, has no
fence at all for the fast path (only the compiler barrier), so even on
x86 there has to be a real barrier.

IOW, there really isn't an arch that can get away without doing this
barrier because it follows an unlock.

Regards,
Peter Hurley
