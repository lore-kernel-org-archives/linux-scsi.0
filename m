From: John David Anglin <dave.anglin@bell.net>
Subject: Re: parisc late boot crash in 4.4-rc, scsi-related
Date: Mon, 16 May 2016 17:41:45 -0400
Message-ID: <9d1ae51e-69c3-c3f6-60aa-e5238dd18241@bell.net>
References: <alpine.LRH.2.20.1601082329270.23187@math.ut.ee>
 <56902D77.1020200@gmx.de> <alpine.LRH.2.20.1605162336050.12607@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1605162336050.12607@math.ut.ee>
Sender: linux-parisc-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2016-05-16 4:40 PM, Meelis Roos wrote:
>>> I noticed on RP3440 and A500 that recent 4.4-rc* crashes on boot.
>> >
>> >I've not seen it with 4.4-rc yet, but I've seen it on debian kernel 4.3.3:
> This is still present in 4.6, just tested. All my pariscs are broken
> - A500, RP3410, RP3440. 4.3 is the latest working release for me. If
> 4.3.3 is broken, it might be possible to bisect more easily.

I believe this is fixed in current gcc versions (4.9 and latter). It was 
exposed by a blk-merge
change.  It was fixed by this change:

2016-03-17  John David Anglin  <danglin@gcc.gnu.org>

         PR target/70188
         * config/pa/constraints.md: Revert 2015-02-13 change.  Use
         define_constraint for "Q" and "T" constraints.

However, this caused a different problem fixed here:

2016-04-05  John David Anglin  <danglin@gcc.gnu.org>

         * config/pa/predicates.md (integer_store_memory_operand): Accept
         REG+D operands with a large offset when reload_in_progress is true.
         (floating_point_store_memory_operand): Likewise.

Dave

-- 
John David Anglin  dave.anglin@bell.net

