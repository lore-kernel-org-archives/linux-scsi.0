From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT] isci: towards the v3.0 merge candidate
Date: Tue, 07 Jun 2011 09:54:56 -0700
Message-ID: <4DEE57E0.5060805@intel.com>
References: <1307408765.11482.40.camel@dwillia2-linux> <20110607085315.GA3794@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:14976 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab1FGQy7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2011 12:54:59 -0400
In-Reply-To: <20110607085315.GA3794@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, Jeff Garzik <jeff@garzik.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, David Milburn <dmilburn@redhat.com>, "hare@suse.de" <hare@suse.de>

On 06/07/2011 01:53 AM, Christoph Hellwig wrote:
> On Mon, Jun 06, 2011 at 06:06:05PM -0700, Dan Williams wrote:
>> The libsas-pending, x86-pending, and subsequently upstream-pending
>> branches are now closed with the inclusion of v3.0-rc2 into 'master'.
>
> Can you generate a tree without the merge commits?

Sure...

git log --pretty=oneline bcd0d38e^..devel --reverse drivers/scsi/isci/ | 
awk '{ print $1 }' | while read p; do stg pick $p; done

...but can you clarify why?  I've been deliberately conservative on the 
merges (3 out of ~300 commits) after having taken notes from Linus about 
avoiding rebasing and valuing stable commit ids for published trees. 
This very last merge with rc2 was done to pull in the pci_map_biosrom 
enabling and libsas fixes because I assumed we would only have one shot 
at 3.0, and feared that straggling post merge fixups might get deferred. 
  Also wanted to get test exposure on 3.0 since that is the upstream 
kernel users will first encounter.

>> Conspicuously missing is significant progress toward the request to
>> merge the isci_ and scic_sds_ level of data structures.  This is mainly
>> due to taking a break on the cleanups to knock down bugs and missing
>> features, but it also comes back to biting the bullet on more rename
>> thrash.  Patches like "isci: remove 'min memory' infrastructure" give me
>> pause because they indicate we still have work to do on clarifying the
>> data structures and shrinking the number of members (the meat / hard
>> work of the cleanup).  A rename is icing (still necessary) at this
>> point, but working on closing out bugs before going down that road.
>>
>> Questions / suggestions on how to proceed on the cleanup versus bug
>> fixing for the 3.0 merge are welcome.
>
> I think we really need to get the main data structures and the naming sorted
> out.  Also the development process really would benefit from more frequent
> posting of updates.

So let's do the rename after finalizing some bug fixes...  after the 
marathon effort to try to hit .39 I'm ready for some functional patches 
for a change.

>> Adam Gruchala (1):
>>        isci: Added support for C0 to SCU Driver
>
> Please make the silicon revision per-pdev.  Even if you only happen to
> one in any given system now this is plain ugly.

Agreed that's why the changelog said:

> Support for previous silicon revisions is
> deprecated (it's also broken for the theoretical case of multiple
> controllers at different silicon revisions, all the more reason to get
> it removed as soon as possible)

>> Dan Williams (3):
>>        Revert "isci: Add missing PCI IDs"
>>        isci: remove 'min memory' infrastructure
>>        isci: use pci_map_biosrom
>>
>> Dave Jiang (3):
>>        isci: removing the kmalloc in smp request construct
>>        isci: Retrieve the EFI variable for OEM parameter
>>        isci: Removing unused variables compiler warnings
>>
>> Edmund Nadolski (10):
>>        isci: replace isci_timer list with proper embedded timers
>
> Please don't add those sci_timer wrappers.  del_timer already makes
> sure it is cancelled, it just doesn't wait for the execution of
> previous timers, so your additional cancel flag doesn't buy anything.

It makes the implementation functionally equivalent with what we had 
before for the following scenario:

CPUa			CPUb
			timer fires
acquires scic_lock
			spins on scic_lock
cancels timer
releases scic_lock
			acquires scic_lock
			observes cancellation
			releases scic_lock

I looked into checking timer_pending() instead of an explicit cancel 
flag but for this race timer_pending() has already cleared.  Now, 
whether the code actually cares about timer callbacks running post 
cancellation is another consideration, but I was not prepared to 
prioritize time investigating that given we had a 90% solution and the 
pending backlog of other work.

> Btw, what bugfixes have you been looking into?  There's basically none
> in this update, and given the time it took to get this one out there's
> not a whole lot of things in it at all.

Let's see:
1/ libsas does not consider the full time needed for sata devices to 
recover from resets.  So we see devices drop off prematurely especially 
in software raid configurations.  Other libsas drivers have various hard 
coded delays, none of which seem to consider the maximum time needed for 
a signature fis to arrive.  We are working on an lldd local fix for this 
situation (to filter bcns and poll for the fis) since we don't have an 
opportunity to introduce any more libsas functionality for 3.0.  The 
patches need some updating for upstreaming, or we can post them in their 
current form as an RFC.  Ultimately this functionality likely needs a 
libsas-level solution, not lldd.

2/ lldd_execute_task versus lldd_dev_gone race.  I've had this one on my 
plate for a while, but the interrupt rate on cleanups, patch review, 
debug etc has been prohibitive.  In any event as I dig in I'm noticing 
other cleanups along the path like the min memory patch.  This fix 
involves expanding lock coverage to enable atomic device stopping.  I'd 
rather not promote all allocation to GFP_ATOMIC so I'm going to switch 
to preallocated requests.  This change also allows io_request_table to 
be removed.  The next complication is the device "stopping" state, the 
fact that there might be some post notification cleanup is irrelevant to 
the submission path and libsas, so I want to arrange for devices to 
atomically disappear.  The blocker for this is the per device 
reqs_in_process list that require us to hold on to our isci_device 
longer than necessary.  Moving that list to a per host list (like all 
other libsas drivers) allows the task and device cleanup to proceed 
asynchronously but appear atomic to the submission path.

3/ dracut has been seen to assemble software raid arrays too early.  Dig 
some initial digging, but right now the problem is not reproducing.  But 
I'm wondering if the async scanning is not getting flushed correctly, or 
dracut is making a mistake.

4/ Took a few days to investigate and fix a distro backport regression

5/ Investigating test failures relative to the new libsas usage of 
libata-eh.  The fact that we now run error recovery for every single 
sata device in the domain is initially alarming, but maybe we are 
overlooking some level of filtering that prevents this from becoming a 
"reset the entire domain" event.

6/ Starting to get a handle on performance profiling to make sure there 
are no low hanging fruit to pick before the merge.

>>      Revert "isci: Add missing PCI IDs"
>>
>>      This reverts commit c2af8ba9.  These ids are reserved for 3rd party
>>      vendors to deploy their own drivers.
>
> This sounds wrong.  It's probably the same crap we had with all kinds of
> Intel and other vendor cards where some OEM adds value by providing fake
> raid and a driver of it's own.  Care to explain how not supporting them
> benefits the user?

If the user chose the closed solution then two things have happened, we 
(the Linux community) have failed to provide a compelling open 
alternative, and the user's data is potentially at risk when the wrong 
driver is loaded.  If it is anything like ahci then switching drivers 
could just be a matter of a bios switch, but I have not seen how this is 
implemented.

