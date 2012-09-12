From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/3] block: add queue-private command filter, editable via sysfs
Date: Wed, 12 Sep 2012 13:25:30 +0200
Message-ID: <1347449133-26476-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[sorry for the resend, I used a wrong mailing list address]

The set of use cases for SG_IO is quite variable that no single filter can
accomodate all of them.  The current filter is tailored very much to
CD burning, and includes many MMC-specific commands that may have
other meanings in different standards.  Someone may want to remove
those commands; at the same time, people that trust their users may
want to add persistent reservations, trim/discard, or even access to
vendor-specific commands.

Filters used to be mutable via sysfs, but the implementation was
never enabled.  Add it back, and let the admin set this up per device.
The ideal is that we would be much more restrictive by default and
give root the ability to override this both globally and per-device.
But this piece of the policy should probably be implemented in userspace
for better backwards compatibility.

In the meanwhile, this patch series provides the sysfs knob.  It is a
tweaked revert of commit 018e044 (block: get rid of queue-private command
filter, 2009-06-26).

Paolo Bonzini (3):
  block: add back queue-private command filter
  scsi: create an all-zero filter for scanners
  block: add back command filter modification via sysfs

 Documentation/block/queue-sysfs.txt |   16 +++++
 block/Kconfig                       |   10 +++
 block/blk-sysfs.c                   |   43 +++++++++++++
 block/bsg.c                         |    2 +-
 block/scsi_ioctl.c                  |  117 +++++++++++++++++++++++++++++++----
 drivers/scsi/scsi_scan.c            |    6 ++-
 drivers/scsi/sg.c                   |    7 +-
 include/linux/blkdev.h              |   31 +++++++++-
 8 files changed, 213 insertions(+), 19 deletions(-)
