From: Markus Mayer <mmayer@broadcom.com>
Subject: [PATCH 0/6] lib: string: add function strtolower()
Date: Thu, 30 Jun 2016 16:50:06 -0700
Message-ID: <1467330612-26242-1-git-send-email-mmayer@broadcom.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>
Cc: Markus Mayer <mmayer@broadcom.com>, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-acpi@vger.kernel.org, devel@acpica.org, speakup@linux-speakup.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series introduces a new generic function strtolower(), which
converts strings to lowercase in-place, overwriting the original
string. This kind of functionality is needed in several places in the
kernel. Right now, everybody seems to be implementing their own copy of
this function. So, we replace several custom "strtolower"
implementations with this new library function.

Another driver that also makes use of this function will be submitted
upstream shortly, which prompted this whole exercise.

The changes made here have been compile-tested, but not tried out, due
to lack of required hardware.

This series is based on v4.7-rc5.

Markus Mayer (6):
  lib: string: add function strtolower()
  drm/nouveau/core: make use of new strtolower() function
  ACPICA: make use of new strtolower() function
  ACPI / device_sysfs: make use of new strtolower() function
  staging: speakup: replace spk_strlwr() with strtolower()
  iscsi-target: replace iscsi_initiatorname_tolower() with strtolower()

 drivers/acpi/acpica/utnonansi.c              | 13 +------------
 drivers/acpi/device_sysfs.c                  |  4 +---
 drivers/gpu/drm/nouveau/nvkm/core/firmware.c |  7 +------
 drivers/staging/speakup/kobjects.c           |  2 +-
 drivers/staging/speakup/main.c               |  2 +-
 drivers/staging/speakup/speakup.h            |  1 -
 drivers/staging/speakup/varhandlers.c        | 12 ------------
 drivers/target/iscsi/iscsi_target_nego.c     | 17 +----------------
 include/linux/string.h                       |  1 +
 lib/string.c                                 | 14 ++++++++++++++
 10 files changed, 21 insertions(+), 52 deletions(-)

-- 
2.7.4
