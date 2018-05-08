From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v6 00/13] firmware_loader changes for v4.18
Date: Tue,  8 May 2018 11:12:34 -0700
Message-ID: <20180508181247.19431-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org, david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl, davem@davemloft.
List-Id: linux-scsi@vger.kernel.org

Greg,

Here is what I have queued up for the firmware_loader for v4.18. It
includes a slew of cleanup work, and the new firmware_request_nowarn()
which is quiet but enables the sysfs fallback mechanism. I've gone ahead
and also queued up a few minor fixes for the firmware loader documentation
which have come up recently. These changes are available on my git tree
both based on linux-next [0] and Linus' latest tree [1]. Folks working
on new developments for the firmware loader can use my linux-next
branch 20180508-firmware_loader_for-v4.18-try2 for now.

0-day sends its blessings.

The patches from Mimi's series still require a bit more discussion and
review. The discussion over the EFI firmware fallback mechanism is still
ongoing.

As for the rename that you wanted, perhaps we can do this late in the
merge window considering we're at rc4 now. I can prep something up for
that later.

Question, and specially rants are warmly welcomed.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20180508-firmware_loader_for-v4.18-try2
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20180508-firmware_loader_for-v4.18-try2

Andres Rodriguez (6):
  firmware: wrap FW_OPT_* into an enum
  firmware: use () to terminate kernel-doc function names
  firmware: rename fw_sysfs_fallback to firmware_fallback_sysfs()
  firmware: add firmware_request_nowarn() - load firmware without
    warnings
  ath10k: use firmware_request_nowarn() to load firmware
  ath10k: re-enable the firmware fallback mechanism for testmode

Luis R. Rodriguez (7):
  firmware_loader: document firmware_sysfs_fallback()
  firmware_loader: enhance Kconfig documentation over FW_LOADER
  firmware_loader: move kconfig FW_LOADER entries to its own file
  firmware_loader: make firmware_fallback_sysfs() print more useful
  Documentation: fix few typos and clarifications for the firmware
    loader
  Documentation: remove stale firmware API reference
  Documentation: clarify firmware_class provenance and why we can't
    rename the module

 Documentation/dell_rbu.txt                    |   3 -
 .../firmware/fallback-mechanisms.rst          |  14 +-
 .../driver-api/firmware/firmware_cache.rst    |   4 +-
 .../driver-api/firmware/request_firmware.rst  |   5 +
 drivers/base/Kconfig                          |  90 ++--------
 drivers/base/firmware_loader/Kconfig          | 154 ++++++++++++++++++
 drivers/base/firmware_loader/fallback.c       |  53 ++++--
 drivers/base/firmware_loader/fallback.h       |  18 +-
 drivers/base/firmware_loader/firmware.h       |  37 ++++-
 drivers/base/firmware_loader/main.c           |  57 +++++--
 drivers/net/wireless/ath/ath10k/core.c        |   2 +-
 drivers/net/wireless/ath/ath10k/testmode.c    |   2 +-
 include/linux/firmware.h                      |  10 ++
 13 files changed, 319 insertions(+), 130 deletions(-)
 create mode 100644 drivers/base/firmware_loader/Kconfig

-- 
2.17.0
