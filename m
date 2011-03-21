From: Ingo Molnar <mingo@elte.hu>
Subject: [build failure] Re: [GIT PULL] First round of SCSI updates for
 2.6.38 merge window
Date: Mon, 21 Mar 2011 13:21:11 +0100
Message-ID: <20110321122111.GA17237@elte.hu>
References: <1300392635.17266.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1300392635.17266.5.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


* James Bottomley <James.Bottomley@suse.de> wrote:

> This represents the usual round of driver updates (fcoe, lpfc, qla2xx=
x,
> zfcp, bnx2i, mpt2sas, megaraid_sas, iscsi, cxgbi and hpsa) plus one n=
ew
> driver (bnx2fc) and as a bonus we move libsas from the old libata eh =
to
> the new one paving the way for junking the old one (once we can get i=
pr
> converted).

The new bnx2fc driver does not build with module support disabled:

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:17: error: dereferencing pointe=
r to incomplete type
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:28: error: =E2=80=98MODULE_STAT=
E_LIVE=E2=80=99 undeclared (first use in this function)
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:17: error: dereferencing pointe=
r to incomplete type
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:28: error: =E2=80=98MODULE_STAT=
E_LIVE=E2=80=99 undeclared (first use in this function)

and this build breakage has been reported to you two weeks ago:

 http://lkml.org/lkml/2011/3/2/468

In the future please do not push broken code upstream or put it into=20
drivers/staging/scsi/ if it has outstanding problems. I'm using the hac=
k below=20
for the time being.

Thanks,

	Ingo

-------------------->
=46rom dd6fd5ea95cba76a625e13910f35cd967ace7fe4 Mon Sep 17 00:00:00 200=
1
=46rom: Ingo Molnar <mingo@elte.hu>
Date: Mon, 21 Mar 2011 13:15:51 +0100
Subject: [PATCH] <not for upstream> scsi: Disable the bnx2fc driver for=
 the time being

Does not build with CONFIG_MODULES disabled.
---
 drivers/scsi/bnx2fc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/Kconfig b/drivers/scsi/bnx2fc/Kconfig
index 6a38080..6a111f0 100644
--- a/drivers/scsi/bnx2fc/Kconfig
+++ b/drivers/scsi/bnx2fc/Kconfig
@@ -1,6 +1,7 @@
 config SCSI_BNX2X_FCOE
 	tristate "Broadcom NetXtreme II FCoE support"
 	depends on PCI
+	depends on BROKEN
 	select NETDEVICES
 	select NETDEV_1000
 	select LIBFC
