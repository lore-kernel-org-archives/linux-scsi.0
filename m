From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [osd-dev] [RFC 0/9] osdfs
Date: Tue, 04 Nov 2008 10:04:35 +0200
Message-ID: <49100213.6040307@panasas.com>
References: <4909C41A.7000406@panasas.com> <490F6829.3020104@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <490F6829.3020104@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
Cc: open-osd development <osd-dev@open-osd.org>, Boaz Harrosh <bharrosh@panasas.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Nov. 03, 2008, 23:07 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Boaz Harrosh wrote:
>> Please review an OSD based file system. 
>>
>> Given that our OSD initiator library is accepted into Kernel, we would
>> like to also submit an osdfs. This is the first iteration of this file system.
>>
>> The next stage is to make it exportable by the pNFS-over-objects Server.
>> osdfs is one of the building blocks for a full, end-to-end open source
>> reference implementation of a Server/Client pNFS-over-objects we
>> want to have available in Linux. Other parts are the Generic pNFS
>> client project with the objects-layout-driver, and the generic pNFS
>> server plus osdfs once it is adapted to be exportable.
>> (See all about pNFS in Linux at:
>> http://wiki.linux-nfs.org/wiki/index.php/PNFS_prototype_design)
>>
>> osdfs was originally developed by Avishay Traeger <avishay@gmail.com>
>> from IBM. A very old version of it is hosted on sourceforge as the osdfs
>> project. It was originally developed for the 2.6.10 Kernel over the old
>> IBM's osd-initiator Linux driver.
>>
>> Since then it was picked by us, open-osd, and was both forward ported to
>> current Kernel, as well as converted to run over our osd Kernel Library.
>> The conversion effort, if anyone is interested, is also available as a
>> patchset here:
>>   git-clone git://git-open-osd.org/open-osd.git osdfs-devel
>> or on the web at:
>>   http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=refs/heads/osdfs-devel
>>
>> The Original code is based on ext2 code from the Kernel at the time.
>> Further reading is available at the last patch in the osdfs.txt file.
>>
>> I have mechanically divided the code in parts, each introducing a
>> group of vfs function vectors, all tied at the end into a full filesystem.
>> Each patch can be compiled but it will only run at the very end.
>> This was done for the hope of easier reviewing.
>>
>> Here is the list of patches
>> [RFC 1/9] osdfs: osd Swiss army knife
>> [RFC 2/9] osdfs: file and file_inode operations
>> [RFC 3/9] osdfs: symlink_inode and fast_symlink_inode operations
>> [RFC 4/9] osdfs: address_space_operations
>> [RFC 5/9] osdfs: dir_inode and directory operations
>> [RFC 6/9] osdfs: super_operations and file_system_type
>> [RFC 7/9] osdfs: mkosdfs
>> [RFC 8/9] osdfs: Documentation
> 
> Pretty cool stuff.
> 
> I've been wondering when we would start seeing OSD filesystems make 
> their appearance.
> 
> Random, unordered comments:
> 
> * This is important stuff.  Should have been posted to LKML.  Please CC 
> LKML in the future.
> 
> * As discussed at the filesystem summit, OSD use implies a need for an 
> MD-like layer for OSD objects.  Has anyone even started the design work 
> for this?

Yes.  I have.
I'm coding a prototype to be used by both this file system and by
the pnfs objects layout driver.
Initially it will do striping and mirroring, and RAID-5 parity as a
stretched goal for the initial release.

> 
> * I tend to think there is room for more than one OSD filesystem in the 
> Linux kernel.  Assuming all OSDs will use the same Linux filesystem 
> driver will lead to bloat, and you potentially "code yourself into a 
> corner."  Let's not rule out multiple filesystems.
> 
> As such, "osdfs" seems like too-generic a name. How about boazfs?  :)

I agree.  osdfs is the name given by Avishay and IBM and we just adopted it.
I think that obfs (Object-based File System) would better represent
what it is (although it's still generic compared to boazfs :-)

> 
> * Get this into the kernel ASAP!  OSD stuff languishes outside the 
> kernel for _far_ too long.  OSD is a key storage technology that needs 
> to be developed in the full light of the Linux community, not off in a 
> dark corner somewhere, where few see progress or discussions.

I completely agree.  We've missed the merge window for 2.6.28 but
if we can get it into 2.6.29 that would be great!

> 
> Object-based storage, and its SCSI incarnation OSD, is a MAJOR revision 
> of the block storage API, moving away from LBA-addressed linear APIs. 
> That's a big deal, and should be discussed on LKML, IMO...

Absolutely.
Thanks for your comments!

Benny

> 
> 	Jeff
> 
