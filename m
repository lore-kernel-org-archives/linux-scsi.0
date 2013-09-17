From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] scsi: delete decade+ obsolete aic7xxx_old driver
Date: Mon, 16 Sep 2013 21:51:23 -0400
Message-ID: <1379382683-27862-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:38285 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3IQBwl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Sep 2013 21:52:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>, Hannes Reinecke <hare@suse.de>, Doug Ledford <dledford@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

After getting warnings in an allyesconfig build[1] from this
driver, I decided to remind myself just how old it was, and
whether it warranted fixing.  In the Kconfig help text, I found:

  "This driver will eventually be phased out entirely"

Going back to the history archive, I see the line was added[2]
in Feb 2002, when we moved from v2.4.2.1 ---> v2.4.2.2

So, with over a decade of notification, and multiple major releases
since then, I think we can justify removing this.  Currently we have
people wasting time building it during routine testing, and then
wasting more time re-researching the known reported warnings, only to
find that nobody really is willing to integrate the fixes[3] for it.

A quick search didn't seem to indicate any active user base for it.
If someone happens to have a quirky _old_ card that the eleven year
old "new" driver doesn't work with, then it is entirely reasonable
that they stick with a kernel version that predates this removal.

[1] drivers/scsi/aic7xxx_old.c: In function =E2=80=98aic7xxx_register=E2=
=80=99:
    drivers/scsi/aic7xxx_old.c:7901:5: warning: case value =E2=80=98257=
=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitch]
    drivers/scsi/aic7xxx_old.c:7898:5: warning: case value =E2=80=98513=
=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitch]
    drivers/scsi/aic7xxx_old.c: In function =E2=80=98aic7xxx_load_seepr=
om=E2=80=99:
    drivers/scsi/aic7xxx_old.c:8517:5: warning: case value =E2=80=98257=
=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitch]
    drivers/scsi/aic7xxx_old.c:8510:5: warning: case value =E2=80=98513=
=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitch]

[2] http://git.kernel.org/cgit/linux/kernel/git/tglx/history.git commit=
 44e8778c

[3] https://lkml.org/lkml/2012/10/29/215

Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Ledford <dledford@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This is an "--irreversible-delete" pseudo-patch which doesn't show all
the file content that was deleted wholesale.  The full commit is at:
git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git aic7xxx-d=
elete ]

 Documentation/scsi/00-INDEX             |     2 -
 Documentation/scsi/aic7xxx_old.txt      |   511 --
 MAINTAINERS                             |     1 -
 drivers/scsi/Kconfig                    |    41 -
 drivers/scsi/Makefile                   |     1 -
 drivers/scsi/aic7xxx_old.c              | 11149 ----------------------=
--------
 drivers/scsi/aic7xxx_old/aic7xxx.h      |    28 -
 drivers/scsi/aic7xxx_old/aic7xxx.reg    |  1401 ----
 drivers/scsi/aic7xxx_old/aic7xxx.seq    |  1539 -----
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |   270 -
 drivers/scsi/aic7xxx_old/aic7xxx_reg.h  |   629 --
 drivers/scsi/aic7xxx_old/aic7xxx_seq.c  |   817 ---
 drivers/scsi/aic7xxx_old/scsi_message.h |    49 -
 drivers/scsi/aic7xxx_old/sequencer.h    |   135 -
 14 files changed, 16573 deletions(-)
 delete mode 100644 Documentation/scsi/aic7xxx_old.txt
 delete mode 100644 drivers/scsi/aic7xxx_old.c
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.h
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.reg
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.seq
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_proc.c
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_reg.h
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_seq.c
 delete mode 100644 drivers/scsi/aic7xxx_old/scsi_message.h
 delete mode 100644 drivers/scsi/aic7xxx_old/sequencer.h

diff --git a/Documentation/scsi/00-INDEX b/Documentation/scsi/00-INDEX
index 9b0787f..2044be5 100644
--- a/Documentation/scsi/00-INDEX
+++ b/Documentation/scsi/00-INDEX
@@ -42,8 +42,6 @@ aic79xx.txt
 	- Adaptec Ultra320 SCSI host adapters
 aic7xxx.txt
 	- info on driver for Adaptec controllers
-aic7xxx_old.txt
-	- info on driver for Adaptec controllers, old generation
 arcmsr_spec.txt
 	- ARECA FIRMWARE SPEC (for IOP331 adapter)
 dc395x.txt
diff --git a/Documentation/scsi/aic7xxx_old.txt b/Documentation/scsi/ai=
c7xxx_old.txt
deleted file mode 100644
index ecfc474..0000000
diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..c79be42 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -470,7 +470,6 @@ M:	Hannes Reinecke <hare@suse.de>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aic7xxx/
-F:	drivers/scsi/aic7xxx_old/
=20
 AIMSLAB FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index fe25677..1f02003 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -499,47 +499,6 @@ config SCSI_AACRAID
=20
=20
 source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
-
-config SCSI_AIC7XXX_OLD
-	tristate "Adaptec AIC7xxx support (old driver)"
-	depends on (ISA || EISA || PCI ) && SCSI
-	help
-	  WARNING This driver is an older aic7xxx driver and is no longer
-	  under active development.  Adaptec, Inc. is writing a new driver to
-	  take the place of this one, and it is recommended that whenever
-	  possible, people should use the new Adaptec written driver instead
-	  of this one.  This driver will eventually be phased out entirely.
-
-	  This is support for the various aic7xxx based Adaptec SCSI
-	  controllers. These include the 274x EISA cards; 284x VLB cards;
-	  2902, 2910, 293x, 294x, 394x, 3985 and several other PCI and
-	  motherboard based SCSI controllers from Adaptec. It does not suppor=
t
-	  the AAA-13x RAID controllers from Adaptec, nor will it likely ever
-	  support them. It does not support the 2920 cards from Adaptec that
-	  use the Future Domain SCSI controller chip. For those cards, you
-	  need the "Future Domain 16xx SCSI support" driver.
-
-	  In general, if the controller is based on an Adaptec SCSI controlle=
r
-	  chip from the aic777x series or the aic78xx series, this driver
-	  should work. The only exception is the 7810 which is specifically
-	  not supported (that's the RAID controller chip on the AAA-13x
-	  cards).
-
-	  Note that the AHA2920 SCSI host adapter is *not* supported by this
-	  driver; choose "Future Domain 16xx SCSI support" instead if you hav=
e
-	  one of those.
-
-	  Information on the configuration options for this controller can be
-	  found by checking the help file for each of the available
-	  configuration options. You should read
-	  <file:Documentation/scsi/aic7xxx_old.txt> at a minimum before
-	  contacting the maintainer with any questions.  The SCSI-HOWTO,
-	  available from <http://www.tldp.org/docs.html#howto>, can also
-	  be of great help.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called aic7xxx_old.
-
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
 source "drivers/scsi/mvsas/Kconfig"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 149bb6b..e172d4f 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -70,7 +70,6 @@ obj-$(CONFIG_SCSI_AHA1740)	+=3D aha1740.o
 obj-$(CONFIG_SCSI_AIC7XXX)	+=3D aic7xxx/
 obj-$(CONFIG_SCSI_AIC79XX)	+=3D aic7xxx/
 obj-$(CONFIG_SCSI_AACRAID)	+=3D aacraid/
-obj-$(CONFIG_SCSI_AIC7XXX_OLD)	+=3D aic7xxx_old.o
 obj-$(CONFIG_SCSI_AIC94XX)	+=3D aic94xx/
 obj-$(CONFIG_SCSI_PM8001)	+=3D pm8001/
 obj-$(CONFIG_SCSI_ISCI)		+=3D isci/
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
deleted file mode 100644
index 33ec9c6..0000000
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx.h b/drivers/scsi/aic7xxx_=
old/aic7xxx.h
deleted file mode 100644
index 0116c81..0000000
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx.reg b/drivers/scsi/aic7xx=
x_old/aic7xxx.reg
deleted file mode 100644
index f67b4bc..0000000
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx.seq b/drivers/scsi/aic7xx=
x_old/aic7xxx.seq
deleted file mode 100644
index dc3bb81..0000000
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c b/drivers/scsi/aic=
7xxx_old/aic7xxx_proc.c
deleted file mode 100644
index 976f45c..0000000
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx_reg.h b/drivers/scsi/aic7=
xxx_old/aic7xxx_reg.h
deleted file mode 100644
index 27f2334..0000000
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx_seq.c b/drivers/scsi/aic7=
xxx_old/aic7xxx_seq.c
deleted file mode 100644
index e1bc140..0000000
diff --git a/drivers/scsi/aic7xxx_old/scsi_message.h b/drivers/scsi/aic=
7xxx_old/scsi_message.h
deleted file mode 100644
index a79f89c..0000000
diff --git a/drivers/scsi/aic7xxx_old/sequencer.h b/drivers/scsi/aic7xx=
x_old/sequencer.h
deleted file mode 100644
index ee66855..0000000
--=20
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
