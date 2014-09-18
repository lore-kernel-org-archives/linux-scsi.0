From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCHv3 0/8] target: Save memory on unused se_dev_entrys and
 se_luns
Date: Thu, 18 Sep 2014 15:54:19 -0700
Message-ID: <541B629B.6090406@redhat.com>
References: <1404171587-28845-1-git-send-email-agrover@redhat.com>	 <20140729131511.GA30232@lst.de> <20140913195557.GA32118@lst.de> <1411025936.13381.183.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411025936.13381.183.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On 09/18/2014 12:38 AM, Nicholas A. Bellinger wrote:
> On Sat, 2014-09-13 at 21:55 +0200, Christoph Hellwig wrote:
>> ping again.  We're getting closer to the end of the 3.18 merge window
>> and there still hasn't been a response.  Should Andy just send the patches
>> directly to Linus once 3.18 opens given that they have been out on the list
>> since Jun 23? (with a positive review from me and no negative one)

> Removing unused per WWPN endpoint LUN + per NodeACL MappedLUN memory is
> a nice optimization to have, but I'm not yet convinced that extending
> existing control path spinlocks to support an array of pointers is
> ultimately worth the complexity it adds here.

9 files changed, 250 insertions(+), 367 deletions(-).

This patchset removes 100+ lines of code. Furthermore, I wouldn't 
characterize it as extending locks, so much as putting locks where they 
should've always been. The fact that device_list[foo] is never null 
means we've avoided crashes but not potentially incorrect accesses.

> Another concern is how these changes effect active session + device I/O
> shutdown, which is an area of regressions I'd rather avoid

I assume this set would spend time in your tree, followed by Linus' tree 
before making it into a release. Also, any logic errors are likely to 
result in a fault, so they should not remain hidden for long.

> if the
> primary benefit of this series is only reducing memory footprint for
> unused LUNs + MappedLUNs.

Yes it does reduce wasted memory, that should be reason enough I'd say. 
But this patchset is also a building block for further improvements that 
are more significant. This set transitions all lun and mappedlun checks 
from checking a flag to checking for NULL. This is necessary before we 
can improve from a fixed-size array to more size-scalable data 
structures like a radix tree, or lockless, with RCU.

>  Lowering the TRANSPORT_MAX_LUNS_PER_TPG value
> at compile time today is the simple way for reducing overall memory
> footprint for folks who need to scale up the number of targets using
> smaller individual LUN mappings.

This is only an option for embedded. We should scale the amount of 
memory we use with the number of allocated LUNs and mapped LUNs.

> As for something smarter, given the mostly read-only nature of LUN +
> MappedLUN pointers to individual TPGT + NodeACLs context, I'd rather see
> something based on RCU arrays + percpu_ref counting to avoid this type
> of complexity to existing code, and move in the direction of dropping
> fast-path I_T ->device_list_lock access all together.

See above about pointers vs flags, this is a first step toward more 
performant *and* space-efficient data structures.

> Beyond these objections, there are some useful fixes + cleanups from
> this series that I'm OK with merging soon..

I've pushed this patchset to

git://git.kernel.org/pub/scm/linux/kernel/git/grover/linux.git

on two branches against your and Linus' repos:
against-linus
against-target-pending-for-next

(looked-over and compile-tested)

For your convenience.

Regards -- Andy
