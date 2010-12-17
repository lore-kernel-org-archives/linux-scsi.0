From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Fri, 17 Dec 2010 19:01:57 +0300
Message-ID: <4D0B8975.1040206@vlnb.net>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org> <1292599364.2820.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292599364.2820.21.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley, on 12/17/2010 06:22 PM wrote:
> On Thu, 2010-12-16 at 19:47 -0800, Nicholas A. Bellinger wrote:
>> Greetings all,
>>
>> It is my pleasure to announce TCM/LIO v4.0.0-rc6 for v2.6.37-rc6 has
>> been tagged and pushed into lio-core-2.6.git/lio-4.0 and master
>> branches.  It has been almost two months since the last -rc5 for .36-rc8
>> was released, and since that time a number of refactoring and cleanup
>> patch series from Christoph Hellwig have been merged to reduced the
>> target core logic and backend drivers by nearly ~4200 LOC!
>>
>> A big thanks to Christoph for jumping on a number of areas that have
>> needed attention in target_core_transport.c for some time, and for being
>> the very first 'third party' kernel developer to pull ahead in the
>> TCM/LIO patch ranking for a single TCM/LIO release.   It was a good
>> race, and hch did very much earn his victory for this round (41 vs. 36)
>> in the final rankings attached below.
>>
>> Also, I am proud to announce this is the first release of Target Core
>> code running with a publically available HW target fabric module.  The
>> tcm_qla2xxx and qla2xxx LLD code is now available from the
>> lio-core-2.6.git/tcm_qla2xxx branch, and more information about the
>> recent Alpha -> BETA release and the ongoing developers are available
>> here:
>>
>> http://www.linux-iscsi.org/index.php/Qlogic
>>
>> And the initial RFC patches here:
>>
>> http://marc.info/?l=linux-scsi&m=129244523223528&w=2
>>
>> There have also been a number of important bugfixes that have gone into
>> this release, so for folks running on earlier v4.0 code please consider
>> upgrading now..  Here is a brief list of the critical fixes from below:
>>
>> *) tcm/iblock: Fix bio-set leak during bio exception handling (nab)
>>
>> *) tcm/pscsi: Fix incorrect usage of head_of_queue with
>>     blk_execute_rq_nowait() (boaz)
>>
>> *) tcm/pscsi: Fix failure case for __pscsi_map_task_SG() (nab)
>>
>> *) tcm: Fix OOPs w/ task->task_sg_bidi[] for non BIDI operation (kiran)
>>
>> *) target: Fix tfo->write_pending() fabric callback ordering (nab,
>> kiran, and others)
>>
>> There has also been work in a number of branches where work is ongoing,
>> and not mentioned in the final stats below.  This includes Tomo-san's
>> work with the ibmvscsis module for IBM POWER VSCSI in branch
>> tcm_ibmvstgt, and Kiran Patil for his recent work in the
>> tcm_fc_ddp_offload branch for adding offload support for 10 Gb/sec Intel
>> NICs with TCM_FC/OpenFCOE target code that will be merged into TCM/LIO
>> upstream in a future release.
>>
>> Kiran also found and fixed his first bug in upstream Target code, and
>> helped squash another long standing (since v2.x day) issue wrt to
>> interrupt context usage required for HW target mode within the
>> transport_generic_write_pending() callback.  He will be continuing to
>> test and improve the TCM_FC/OpenFCoE code on Intel 10 Gb/sec hardware,
>> and maintaining the DDP offload pieces for FCoE within
>> lio-core-2.6.git/tcm_fc_ddp_offload branch on kernel.org.  Thank you and
>> great work Kiran!
>>
>> At this point v4.0 development will be slowing down, as I will only be
>> accepting critical fixes at this point for v4.0.0-rc7 as we move into
>> the testing and validation phase for .38 mainline code.  So please
>> folks, if anyone has immediate issues for v4.0 that need to be
>> considered, please make myself and other core target devels aware and we
>> will do our best to get them addressed.
> 
> OK, I think this has reached the stage where it's been polished enough
> outside mainline to the point where we can complete any remaining todo
> items in-tree.
> 
> So lets begin merging with the minimal target core and the TCM_Loop as
> two separate commits. I think the target core may just fit under the
> reflector mail length limits, but if not, you can send it as multiple
> patches and I'll recombine them.

Well, could somebody eventually explain what are advantages of LIO over
SCST so you are choosing it?

LIO is obviously worse all technically (see
http://scst.sourceforge.net/comparison.html) as well as in the number of
users and size of the community. Current in-rush attempts to make LIO
_look_ not worse than SCST changed nothing in this area.

In the resent threads how many people voted for LIO? Nobody. How many
for SCST? Many. Moreover, has any real user of LIO participated in those
threads? None?

Doesn't that matter for you? Which code is the best doesn't matter for
Linux anymore?

Undercover games are going on?

Vlad
