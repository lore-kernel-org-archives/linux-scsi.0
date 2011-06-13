From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/8] scsi/atari: Provide a dummy NCR5380_exit()
Date: Mon, 13 Jun 2011 20:39:15 +0200
Message-ID: <1307990362-22768-2-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Michael Schmitz <schmitz@debian.org>
List-Id: linux-scsi@vger.kernel.org

and call it from atari_scsi_release(), cfr. the other NCR5380 drivers.

This fixes:

drivers/scsi/NCR5380.h:303: warning: =E2=80=98NCR5380_exit=E2=80=99 dec=
lared =E2=80=98static=E2=80=99 but never defined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@debian.org>
---
 drivers/scsi/atari_NCR5380.c |    5 +++++
 drivers/scsi/atari_scsi.c    |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.=
c
index 24652f1..2db79b4 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -892,6 +892,11 @@ static int __init NCR5380_init(struct Scsi_Host *i=
nstance, int flags)
 	return 0;
 }
=20
+static void NCR5380_exit(struct Scsi_Host *instance)
+{
+	/* Empty, as we didn't schedule any delayed work */
+}
+
 /*
  * Function : int NCR5380_queue_command (Scsi_Cmnd *cmd,
  *	void (*done)(Scsi_Cmnd *))
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 3e8658e..04a154f 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -730,6 +730,7 @@ int atari_scsi_release(struct Scsi_Host *sh)
 		free_irq(IRQ_TT_MFP_SCSI, sh);
 	if (atari_dma_buffer)
 		atari_stram_free(atari_dma_buffer);
+	NCR5380_exit(sh);
 	return 1;
 }
=20
--=20
1.7.0.4
