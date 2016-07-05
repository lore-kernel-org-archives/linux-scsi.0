From: Markus Mayer <mmayer@broadcom.com>
Subject: [PATCH v2 0/7] lib: string: add functions to case-convert strings
Date: Tue,  5 Jul 2016 13:47:04 -0700
Message-ID: <1467751631-22878-1-git-send-email-mmayer@broadcom.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>
Cc: Markus Mayer <mmayer@broadcom.com>, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-acpi@vger.kernel.org, speakup@linux-speakup.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series introduces a family of generic string case conversion
functions. This kind of functionality is needed in several places in
the kernel. Right now, everybody seems to be implementing their own
copy of this functionality.

Based on the discussion of the previous version of this series[1] and
the use cases found in the kernel, it does look like having several
flavours of case conversion functions is beneficial. The use cases fall
into three categories:
    - copying a string and converting the case while specifying a
      maximum length to mimic strncpy()
    - copying a string and converting the case without specifying a
      length to mimic strcpy()
    - converting the case of a string in-place (i.e. modifying the
      string that was passed in)

Consequently, I am proposing these new functions:
    char *strncpytoupper(char *dst, const char *src, size_t len);
    char *strncpytolower(char *dst, const char *src, size_t len);
    char *strcpytoupper(char *dst, const char *src);
    char *strcpytolower(char *dst, const char *src);
    char *strtoupper(char *s);
    char *strtolower(char *s);
They all return a pointer to the terminating '\0' in the destination
string (for strtoupper() and strtolower() that is "s").

Several drivers are being modified to make use of the functions above.
Another driver that also makes use of this functionality will be
submitted upstream shortly, which prompted this whole exercise.

The changes made here have been compile-tested, but not tried out, due
to lack of required hardware.

Changes since v1:
  - expanded strtolower() into a family of functions that cover use
    cases when a length argument is or isn't required and that support
    copying the string into a new buffer or changing it in-place 
  - changed the function semantics to return a pointer to the
    terminating '\0' character of the modified string
  - added strtoupper() functionality mirroring the above
  - dropped the ACPICA patch, since that code is OS independent and
    can't rely on a Linux library function (see [2])
  - Added two new patches replacing strtoupper() implementations

[1] https://lkml.org/lkml/2016/6/30/727
[2] https://lkml.org/lkml/2016/7/1/9

Markus Mayer (7):
  lib: string: add functions str[n]cpytolower()/str[n]cpytoupper()
  drm/nouveau/core: make use of new strncpytolower() function
  ACPI / device_sysfs: make use of new strtolower() function
  staging: speakup: replace spk_strlwr() with strncpytolower()
  iscsi-target: replace iscsi_initiatorname_tolower() with
    strcpytolower()
  drm/nouveau/fifo/gk104: make use of new strcpytoupper() function
  power_supply: make use of new strcpytoupper() function

 drivers/acpi/device_sysfs.c                      |  4 +-
 drivers/gpu/drm/nouveau/nvkm/core/firmware.c     |  9 +----
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c |  5 +--
 drivers/power/power_supply_sysfs.c               | 13 +++----
 drivers/staging/speakup/kobjects.c               |  3 +-
 drivers/staging/speakup/main.c                   |  3 +-
 drivers/staging/speakup/speakup.h                |  1 -
 drivers/staging/speakup/varhandlers.c            | 12 ------
 drivers/target/iscsi/iscsi_target_nego.c         | 17 +--------
 include/linux/string.h                           | 48 ++++++++++++++++++++++++
 lib/string.c                                     | 40 ++++++++++++++++++++
 11 files changed, 100 insertions(+), 55 deletions(-)

-- 
2.7.4

