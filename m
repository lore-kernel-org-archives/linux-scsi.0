From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 01] kmalloc + memset conversion co kzalloc
Date: Tue, 31 Jul 2007 18:50:12 +0200
Message-ID: <200707311850.13184.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kars de Jong <jongk@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/a4000t.c | 3534 -> 3457 (-77 bytes)

 drivers/scsi/a4000t.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/a4000t.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/a4000t.c	2007-07-31 14:00:37.000000000 +0200
@@ -37,7 +37,7 @@ static struct platform_device *a4000t_sc

 static int __devinit a4000t_probe(struct device *dev)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;

 	if (!(MACH_IS_AMIGA && AMIGAHW_PRESENT(A4000_SCSI)))
@@ -47,12 +47,11 @@ static int __devinit a4000t_probe(struct
 				"A4000T builtin SCSI"))
 		goto out;

-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (!hostdata) {
 		printk(KERN_ERR "a4000t-scsi: Failed to allocate host data\n");
 		goto out_release;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));

 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)ZTWO_VADDR(A4000T_SCSI_ADDR);
