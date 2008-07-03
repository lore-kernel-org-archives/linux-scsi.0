From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 2.6.26-rc8] block: implement extended devt
Date: Thu,  3 Jul 2008 17:33:00 +0900
Message-ID: <1215073986-4709-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

Hello, all.

This patchset implements extended devt for block devices.  This is
mainly to work around sd limitations (16 minors per device) but can
easily be used to allow more partitions or more devices.

With it turned on, a libata disk w/ 60 partitions looks like the
following.

  # cat /proc/partitions 
  major   minor   #blocks  name

     3        0   78184008 hda
     3        1   26218048 hda1
     3        2    1052257 hda2
     8        0  156290904 sda
     8        1       8001 sda1
     8        2       8032 sda2
     8        3       8032 sda3
     8        4          1 sda4
   ...
     8       15       8001 sda15
   259        0       8001 sda16
   259        1       8001 sda17
   259        2       8001 sda18
   ...
   259       43       8001 sda59
   259       44       8001 sda60

As you can see, partitions over the genhd->minors limit gets assigned
under major 259 which breaks the predetermined contiguous minors
assumption.  I've tested a number of things on it and everything seems
to work just fine including mounting as root.

A debug option CONFIG_DEBUG_BLOCK_EXT_DEVT is also implemented, when
enabled, the /proc/partitions looks like the following.

  # cat /proc/partitions
  major   minor   #blocks  name

     3        0   78184008 hda
   259        0   26218048 hda1
   259   524288    1052257 hda2
     8        0  156290904 sda
   259   262144       8001 sda1
   259   786432       8032 sda2
   259   131072       8032 sda3
   259   655360          1 sda4
   259   393216       8001 sda5
   259   917504       8001 sda6
   259    65536       8001 sda7
   ...
   259   114688       8001 sda55
   259   638976       8001 sda56
   259   376832       8001 sda57
   259   901120       8001 sda58
   259   245760       8001 sda59
   259   770048       8001 sda60

The option forces all partitions to be allocated from the extended
region and spreads the minors as apart as possible to achieve two
goals.

* Detect kernel or userland code which assumes pre-determined
  consecutive block devts.

* Prevent such code from accessing the wrong partition and corrupting
  it by making devts far apart from each other.

I thought about making the spread allocation default for the extended
area while keeping the conventional minors as they are but that seemed
like an overkill.  Especially because the only interface which reveals
how many consecutive minors are allocated is sysfs attribute "range"
which doesn't change after this patchset.  A new attribute "ext_range"
which indicates the total limit of minors includnig the extended ones
is added instead.

I chose major 259 at my own whim.  Is it okay to use this value?  As
extended devts don't care what MAJ:MIN is used, we can also create a
pool of MAJ:MINs which any driver can allocate MAJ:MIN from.
Switching to such mechanism shouldn't be too difficult (some kobj_map
adjustments will be necessary tho) so no need to worry about it now.

This patchset is also available in the following git tree.

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=block-extended-devt
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-extended-devt

Thanks.

 block/genhd.c          |  268 ++++++++++++++++++++++++++++++++++++++++---------
 block/ioctl.c          |    6 -
 drivers/ide/ide-disk.c |   17 ++-
 drivers/scsi/sd.c      |   15 ++
 fs/block_dev.c         |    2 
 fs/partitions/check.c  |   44 ++++++--
 include/linux/fs.h     |    1 
 include/linux/genhd.h  |   36 ++++++
 include/linux/major.h  |    2 
 lib/Kconfig.debug      |   16 ++
 10 files changed, 340 insertions(+), 67 deletions(-)

 --
 tejun
