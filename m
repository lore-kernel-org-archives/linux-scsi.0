From: Heikki Orsila <shdl@zakalwe.fi>
Subject: [PATCH] scsi: eata.c potential namespace collision and optimisation
Date: Sat, 24 Feb 2007 16:08:46 +0200
Message-ID: <20070224140846.GB7939@zakalwe.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932845AbXBXOIx@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: ballabio_dario@emc.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

This fixes a potential namespace collision and does an optimisation for 
2.6.20 drivers/scsi/eata.c:

	* sort() is renamed to eata_sort() to avoid conflict with kernel 
	  proper sort(). It does _not_ conflict currently in 2.6.20 so 
	  this is a pre-emptive change.

	* in eata_sort(), one if-condition per loop iteration is avoided
	  by moving the comparison out of the loop

Warning: The patch compiles but is not tested with real hardware since I 
don't have the card.

diffstat:
 eata.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="2.6.20-eata-namespace.diff"

diff -upr linux-2.6.20-org/drivers/scsi/eata.c linux-2.6.20/drivers/scsi/eata.c
--- linux-2.6.20-org/drivers/scsi/eata.c	2007-02-04 20:44:54.000000000 +0200
+++ linux-2.6.20/drivers/scsi/eata.c	2007-02-24 15:43:08.000000000 +0200
@@ -2089,8 +2089,8 @@ int eata2x_bios_param(struct scsi_device
 	return 0;
 }
 
-static void sort(unsigned long sk[], unsigned int da[], unsigned int n,
-		 unsigned int rev)
+static void eata_sort(unsigned long sk[], unsigned int da[], unsigned int n,
+		      unsigned int rev)
 {
 	unsigned int i, j, k, y;
 	unsigned long x;
@@ -2098,14 +2098,17 @@ static void sort(unsigned long sk[], uns
 	for (i = 0; i < n - 1; i++) {
 		k = i;
 
-		for (j = k + 1; j < n; j++)
-			if (rev) {
+		if (rev) {
+			for (j = k + 1; j < n; j++) {
 				if (sk[j] > sk[k])
 					k = j;
-			} else {
+			}
+		} else {
+			for (j = k + 1; j < n; j++) {
 				if (sk[j] < sk[k])
 					k = j;
 			}
+		}
 
 		if (k != i) {
 			x = sk[k];
@@ -2116,8 +2119,6 @@ static void sort(unsigned long sk[], uns
 			da[i] = y;
 		}
 	}
-
-	return;
 }
 
 static int reorder(struct hostdata *ha, unsigned long cursec,
@@ -2194,7 +2195,7 @@ static int reorder(struct hostdata *ha, 
 		rev = 0;
 
 	if (!((rev && r) || (!rev && s)))
-		sort(sl, il, n_ready, rev);
+		eata_sort(sl, il, n_ready, rev);
 
 	if (!input_only)
 		for (n = 0; n < n_ready; n++) {
@@ -2214,7 +2215,7 @@ static int reorder(struct hostdata *ha, 
 		}
 
 	if (overlap)
-		sort(pl, il, n_ready, 0);
+		eata_sort(pl, il, n_ready, 0);
 
 	if (link_statistics) {
 		if (cursec > sl[0])

--Q68bSM7Ycu6FN28Q--
