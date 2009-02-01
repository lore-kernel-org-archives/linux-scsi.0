From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] block,scsi,libata: implement alt_size
Date: Sun,  1 Feb 2009 11:55:48 +0900
Message-ID: <1233456951-992-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@redhat.c
List-Id: linux-scsi@vger.kernel.org


Hello,

This patchset implements alt_size, which is a size hint to the users
of a block device.  It's primarily to communicate the BIOS (HPA) size
on ATA devices to userland, so that dmraid can consider it when trying
to figure out BIOS raid layout.  This is critical as dmraid can be
tricked into assemblying the wrong raid when fed with the unlocked
size and if the disk content is right (or, rather, wrong) and good
number of distros are shipping with ignore_hpa=1 as default.

This patch contains the following three patches.

  0001-block-add-alt_size.patch
  0002-scsi-add-scsi_device-alt_capacity.patch
  0003-libata-export-HPA-size-as-alt_size.patch

Without the above three patches, I get the following on my nv RAID-0
if HPA unlocking is turned on.

  # ~/work/dmraid/tools/dmraid -a y
  RAID set "nvidia_djgdjigi" was activated
  # mount /dev/dm-0 /mnt/tmp
  mount: wrong fs type, bad option, bad superblock on /dev/dm-0,
	 missing codepage or helper program, or other error
	 In some cases useful info is found in syslog - try
	 dmesg | tail  or so

With the above three patches and modified dmraid,

  ck804:~/os/work/build # ~/work/dmraid/tools/dmraid -a y -v -v -v
  ...
  NOTICE: /dev/sdb: using BIOS sectors 234439535
  RAID set "nvidia_djgdjigi" was activated
  ...
  ck804:~/os/work/build # mount /dev/dm-0 /mnt/tmp
  ck804:~/os/work/build # umount /dev/dm-0

Any ideas on through which tree this should be pushed?  I'll post
dmraid patches as a reply to this thread for reference.

Thanks.

This patchset is against the current linus#master[1] and contains the
following changes.

 block/genhd.c              |   26 ++++++++++++++++++++++++++
 drivers/ata/libata-core.c  |    2 ++
 drivers/ata/libata-scsi.c  |    2 ++
 drivers/scsi/sd.c          |    1 +
 include/linux/genhd.h      |   13 ++++++++++++-
 include/linux/libata.h     |    1 +
 include/scsi/scsi_device.h |    1 +
 7 files changed, 45 insertions(+), 1 deletion(-)

--
tejun

[1] 45c82b5a770be66845687a7d027c8b52946d59af
