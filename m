From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH 0/3] [RFC] Persistent device name using preferred name
Date: Wed, 15 Jun 2011 17:16:10 +0900
Message-ID: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, greg@kroah.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

Hi,

This patch series provides preferred name into kernel and procfs
messages. Preferred name is user's preferred name for a device.

The purpose of this feature is to solve the persistent device
naming issues which was discussed here:

 http://marc.info/?l=linux-scsi&m=130200794615884&w=2

There are four issues.
1. kernel messages doesn't show persistent device names
2. procfs messages doesn't show persistent device names
3. Some commands didn't support persistent device name in arguments
4. Some commands message didn't show persistent device names

Then I suggested the intermediate device naming which changes
the naming scheme, but it was rejected. I realized that we should
use udev to provide persistent device names instead of change the
naming scheme.

In LKML discussion, a new idea was suggested by James Bottomley.
This idea allows kernel messages show preferred names by adding a
new attribute to a device, kernel messages show this new attribute.
This idea's advantage is not to change the current naming scheme.

I tried implementation of preferred name, and then there are two
discussion points.

(a) Which devices need support?
Preferred name is stored in struct device. Therefore it is available
for all devices if we make preferred name support with other device
types.

This patch series only support scsi block device. Is there the device
which needs support? (e.g. Ntwork devices, generic SCSI devices, etc.)

(b) What kind of procfs form is good?
I implemented preferred name something like this,

(preferred name assigned foo to sda)
#cat /proc/partitions
major minor  #blocks  name

   8        0  488386584 foo
   8        1     194560 foo1
...

Do you needs device name filed?
Something like this,

(preferred name assigned foo to sda)
#cat /proc/partitions
major minor  #blocks  name preferred

   8        0  488386584 sda foo
   8        1     194560 sda1 foo1
...


Issue 3 and 4 is command releated issue. Commands have to be
modified to use preferred name. We need to create library for
preferred name.

Our goal is to solve those issues, and users can use and see
preferred name anywhere.

TODO:
- To change kernel messages
  I'm going to change a device name to a preferred name by
  dev_name() in mmc, blk-core, sg, sr, st, fs, etc.

I would welcome any thoughts, comments and suggestions.

Thanks,

---

Nao Nishijima (3):
      [RFC] fs: print preferred name in procfs messages
      [RFC] sd: print preferred name in kernel messages.
      [RFC] genhd: add a new attribute in device structure


 block/genhd.c              |   28 ++++++++++++++++++++++++++++
 drivers/scsi/sd.c          |    2 +-
 drivers/scsi/sd.h          |    2 +-
 fs/partitions/check.c      |    8 +++++---
 include/linux/device.h     |    9 +++++++++
 include/scsi/scsi_device.h |    2 +-
 6 files changed, 45 insertions(+), 6 deletions(-)

--
Nao Nishijima (nao.nishijima.xt@hitachi.com)
