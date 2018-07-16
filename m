From: Martijn Coenen <maco@android.com>
Subject: [PATCH 0/6] Symbol namespaces
Date: Mon, 16 Jul 2018 14:21:19 +0200
Message-ID: <20180716122125.175792-1-maco@android.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Martijn Coenen <maco@android.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-scsi
List-Id: linux-scsi@vger.kernel.org

As of Linux 4.17, there are more than 30000 exported symbols
in the kernel. There seems to be some consensus amongst
kernel devs that the export surface is too large, and hard
to reason about.

Generally, these symbols fall in one of these categories:
1) Symbols actually meant for drivers
2) Symbols that are only exported because functionality is
   split over multiple modules, yet they really shouldn't
   be used by modules outside of their own subsystem
3) Symbols really only meant for in-tree use

When module developers try to upstream their code, it
regularly turns out that they are using exported symbols
that they really shouldn't be using. This problem is even
bigger for drivers that are currently out-of-tree, which
may be using many symbols that they shouldn't be using,
and that break when those symbols are removed or modified.

This patch allows subsystem maintainers to partition their
exported symbols into separate namespaces, and module
authors to import such namespaces only when needed.

This allows subsystem maintainers to more easily limit
availability of these namespaced symbols to other parts of
the kernel. It can also be used to partition the set of
exported symbols for documentation purposes; for example,
a set of symbols that is really only used for debugging
could be in a "SUBSYSTEM_DEBUG" namespace.

Martijn Coenen (6):
  export: explicitly align struct kernel_symbol.
  module: add support for symbol namespaces.
  modpost: add support for checking symbol namespaces.
  modpost: add support for generating namespace dependencies.
  scripts: Coccinelle script for namespace dependencies.
  RFC: USB: storage: move symbols into USB_STORAGE namespace.

 Makefile                            |  11 +++
 arch/m68k/include/asm/export.h      |   1 -
 arch/x86/include/asm/Kbuild         |   1 +
 arch/x86/include/asm/export.h       |   5 --
 drivers/usb/storage/alauda.c        |   1 +
 drivers/usb/storage/cypress_atacb.c |   1 +
 drivers/usb/storage/datafab.c       |   1 +
 drivers/usb/storage/ene_ub6250.c    |   1 +
 drivers/usb/storage/freecom.c       |   1 +
 drivers/usb/storage/isd200.c        |   1 +
 drivers/usb/storage/jumpshot.c      |   1 +
 drivers/usb/storage/karma.c         |   1 +
 drivers/usb/storage/onetouch.c      |   1 +
 drivers/usb/storage/realtek_cr.c    |   1 +
 drivers/usb/storage/sddr09.c        |   1 +
 drivers/usb/storage/sddr55.c        |   1 +
 drivers/usb/storage/shuttle_usbat.c |   1 +
 drivers/usb/storage/uas.c           |   1 +
 drivers/usb/storage/usb.c           |  20 ++---
 include/asm-generic/export.h        |   2 +-
 include/linux/export.h              |  84 ++++++++++++++-----
 include/linux/module.h              |  13 +++
 kernel/module.c                     |  79 ++++++++++++++++++
 scripts/Makefile.modpost            |   4 +-
 scripts/add_namespace.cocci         |  19 +++++
 scripts/mod/modpost.c               | 120 ++++++++++++++++++++++++++--
 scripts/mod/modpost.h               |   9 +++
 scripts/nsdeps                      |  41 ++++++++++
 28 files changed, 379 insertions(+), 44 deletions(-)
 delete mode 100644 arch/x86/include/asm/export.h
 create mode 100644 scripts/add_namespace.cocci
 create mode 100644 scripts/nsdeps

-- 
2.18.0.203.gfac676dfb9-goog
