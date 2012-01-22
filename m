From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] arm: prevent inlining in arxescsi.c causing build failures
Date: Sun, 22 Jan 2012 14:16:55 -0500
Message-ID: <1327259815-3880-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux@arm.linux.org.uk, JBottomley@parallels.com
Cc: linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>, Arnd Bergmann <arnd@arndb.de>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
List-Id: linux-scsi@vger.kernel.org

The following failure is seen in routine coverage builds:

  CC [M]  drivers/scsi/arm/arxescsi.o
/tmp/cccEyiO7.s: Assembler messages:
/tmp/cccEyiO7.s:334: Error: symbol `.loop_1' is already defined
/tmp/cccEyiO7.s:337: Error: symbol `.loop_2' is already defined
/tmp/cccEyiO7.s:343: Error: symbol `.loop_3' is already defined
/tmp/cccEyiO7.s:365: Error: symbol `.loop_1' is already defined
/tmp/cccEyiO7.s:368: Error: symbol `.loop_2' is already defined
/tmp/cccEyiO7.s:374: Error: symbol `.loop_3' is already defined
make[4]: *** [drivers/scsi/arm/arxescsi.o] Error 1

It is caused by multiple inline of arxescsi_pseudo_dma_write()
which is responsible for the above labels.  Marking the fcn
as non-inline fixes the issue.

Arnd Bergmann considered un-inlinling vs fixing the loop[1] to
use local labels and came to the following conclusion:

  The problem is mostly in the code: The symbols are defined in an
  inline assembly that is not meant to be instantiated multiple times.
  gcc may decide to unroll the loop in which this is done, which causes
  the error above. Unrolling the loop is a rather silly thing to do
  here, because the code is rather large and does not at all benefit
  from unrolling. You can use the patch below to fix the code to still
  work if the loop is unrolled, but I also think that marking the
  function as uninline is a good idea, in particular because I don't
  trust the old assembly to still do the right thing otherwise:
  It manually saves and restores the registers on the stack, where
  you nowadays would specify specific clobbers for the registers
  it uses, and let the compiler take care of it. It also doesn't
  contain a memory clobber for the buffer, so keeping the function
  out-of-line is probably the safe choice.

[1] https://lkml.org/lkml/2011/12/1/189

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>

---
v2: add desc. from Arnd indicating why un-inlining is the best choice

diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index a750aa7..2608a9e 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -72,7 +72,8 @@ arxescsi_dma_setup(struct Scsi_Host *host, struct scs=
i_pointer *SCp,
 	return fasdma_pseudo;
 }
=20
-static void arxescsi_pseudo_dma_write(unsigned char *addr, void __iome=
m *base)
+static noinline void
+arxescsi_pseudo_dma_write(unsigned char *addr, void __iomem *base)
 {
        __asm__ __volatile__(
        "               stmdb   sp!, {r0-r12}\n"
--=20
1.7.7.2
