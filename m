From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: linux-next: Tree for Aug 1
Date: Wed, 1 Aug 2018 18:19:00 -0700
Message-ID: <83936bed-e783-191f-c308-8f8470a0dbf3@roeck-us.net>
References: <20180801175852.36549130@canb.auug.org.au>
 <20180801224813.GA13074@roeck-us.net>
 <1533163965.3158.1.camel@HansenPartnership.com>
 <1533164454.3158.3.camel@HansenPartnership.com>
 <20180802100505.56e663cb@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802100505.56e663cb@canb.auug.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/01/2018 05:05 PM, Stephen Rothwell wrote:
> Hi all,
> 
> On Wed, 01 Aug 2018 16:00:54 -0700 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>
>> So what seems to be happening to cause this is that there's a patch
>> somewhere between the merge base of my scsi-next series and the next
>> tree and the patch just before scsi-next was actually merged that
>> actually causes a boot failure with blk-mq enabled.  Could you try to
>> find this patch?  I think the way to do it is to try to bisect this
>> range of linux-next using the command line
>>
>> scsi_mod.use_blk_mq=1
>>
>> Which forces block mq to be the default and seeing where the first boot
>> failure is (you don't need my scsi-next tree merged to do this because
>> all the offending patch does is flip the default state of the above
>> flag).
> 
> So this means using v4.8-rc1 as the first good commit and 453f1d821165
> ("Merge remote-tracking branch 'cgroup/for-next'") as the first bad
> (assuming that this latter fails to boot with "scsi_mod.use_blk_mq=1").
> 

Puzzled. Same results. 453f1d821165 works with both scsi_mod.use_blk_mq=0
and scsi_mod.use_blk_mq=1. next-20180801 works with scsi_mod.use_blk_mq=0
and fails with scsi_mod.use_blk_mq=1. Bisect still points to the same commit
(which just changes the default) as culprit. I know that doesn't make sense.
I'll need to think about it.

Guenter
