From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Wed, 2 Oct 2002 23:53:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002235303.B12192@bitwizard.nl>
References: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Scott Merritt <Scsi@PragmaSoft.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

On Wed, Oct 02, 2002 at 11:10:20AM -0700, Bryan Henderson wrote:
> imagine bringing up a disk in 3 stages: 1) initialize the SCSI low level
> driver and identify the device at that level; 2) attach the device as a
> SCSI disk; 3) create the partition devices (read the partition table).

I fully agree! The Unix philosophy is that you can easily make a 
"script" or something that "does the one extra thing". But if 
something automatically does something for you, then you can't
make a script that omits that step that shouldn't have happened
in the first place. 

This is the power of Unix: as a user you get to make unexpected
combinations that the designers didn't think of. 

In this case, we have some history to take along. For example,
if we'd require a userlevel program to initiate partition table
reading, we'd make a whole lot of systems that do "root=/dev/sda3"
non-bootable. That is not an option. 

Personally, I think lowlevel drivers should NOT bother with 
partitions. We should have a "partition driver", which will
pass the requests it gets on to a lowlevel driver with an 
offset. This is the conceptual level. For performance reasons, 
we'll end up doing something in ll_rw_block that does:

	if (major == partition_major) {
		block += partitions[minor].block_offset;
		major = partitions[minor].major;
		minor = partitions[minor].minor;
	}	

just 3 instructions extra, but it relieves ALL lower level drivers
of having to deal with partitions. 

Then we'd have a "ide disk driver" which sanely supports 256 
IDE drives on one major. We also get a driver which supports a 
total of 256 partitions, in a dense way. Currently we are having
trouble because SOME people have 16 partitions, and SOME people 
have more than 16 disks. We currently then have to allocate 
16 disks * 16 partitions = 256 partitions which are seldomly
used, but individual users hit one or the other limitation
quite easily. 

This is what I think SHOULD eventually be implemented. We'll 
need to solve some compatiblity issues for the intervening period. 

One way to ensure compatiblity would be to make all "currently 
partitioned" devices one of those magic partitioner devices, 
and reroute to the NEW real, dense driver by a compatibility 
module which only has to do some initializations. 

				Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
* The Worlds Ecosystem is a stable system. Stable systems may experience *
* excursions from the stable situation. We are currenly in such an       * 
* excursion: The stable situation does not include humans. ***************
