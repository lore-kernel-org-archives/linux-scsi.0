From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 0/4] Decouple X86_32 dependency from the ISA Kconfig option
Date: Mon, 11 Apr 2016 09:25:50 -0400
Message-ID: <cover.1460379702.git.vilhelm.gray@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, William Breathitt Gray <vilhelm.gray@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patchset is based on top of commit 3a3a5fece6f2 ("fs: kernfs: Replace
CURRENT_TIME by current_fs_time()") of the driver-core-testing branch of
the driver-core repository.

The introduction of the ISA_BUS option in commit b3c1be1b789c
("base: isa: Remove X86_32 dependency") blocks the compilation of ISA
drivers on non-x86 platforms. The ISA_BUS configuration option should not
be necessary if the X86_32 dependency can be decoupled from the ISA
configuration option. This patchset both removes the ISA_BUS configuration
option entirely and decouples the X86_32 dependency from the ISA
configuration option.

The PNPBIOS driver requires preprocessor defines (located in
include/asm/segment.h) only declared if the architecture is set to X86_32.
If the architecture is set to X86_64, the PNPBIOS driver will not build
properly. The X86 dependecy for the PNPBIOS configuration option is changed
to an explicit X86_32 dependency in order to prevent an attempt to build
for an unsupported architecture.

Changes to the ISA SSCAPE and SCSI ULTRASTOR drivers are also included. The
relevant patches simply fix format string identifier mismatches exposed
during an attempted X86_64 compilation after the decoupling of the X86_32
dependency from the ISA configuration option. These patches fix compilation
warnings rather than errors, but the solutions were so trivial that I
decided to include them in this patchset. If it would be inappropriate to
include them in this patchset, let me know and I will rebase to remove the
relevant patches.

William Breathitt Gray (4):
  pnp: pnpbios: Add explicit X86_32 dependency to PNPBIOS
  sound: isa: sscape: Use correct format identifier for size_t
  scsi: ultrastor: Use correct format identifier for kernel pointer
  isa: Remove the ISA_BUS Kconfig option

 arch/x86/Kconfig            | 10 ++--------
 drivers/base/Makefile       |  2 +-
 drivers/pnp/pnpbios/Kconfig |  2 +-
 drivers/scsi/ultrastor.c    |  8 ++++----
 include/linux/isa.h         |  2 +-
 sound/isa/sscape.c          |  2 +-
 6 files changed, 10 insertions(+), 16 deletions(-)

-- 
2.7.3
