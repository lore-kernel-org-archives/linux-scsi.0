From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] Coccinelle: doubletest: reduce side effect false positives
Date: Fri,  3 Aug 2018 18:32:11 +0200
Message-ID: <1533313931-3639-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>, Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <michal.lkml@markovi.net>, cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>, Finn Thain <fthain@telegraphics.com.au>, zhong jiang <zhongjiang@huawei.com>, Michael Schmitz <schmitzmic@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, John Garry <john.garry@huawei.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Ensure that the cited expression is not a function call or an
assignment to reduce the chance of false positives.

Slightly modify the warning message to indicate another source
of false positves.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/tests/doubletest.cocci |   34 ++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/scripts/coccinelle/tests/doubletest.cocci b/scripts/coccinelle/tests/doubletest.cocci
index 78d74c2..7af2ce7 100644
--- a/scripts/coccinelle/tests/doubletest.cocci
+++ b/scripts/coccinelle/tests/doubletest.cocci
@@ -1,6 +1,7 @@
 /// Find &&/|| operations that include the same argument more than once
-//# A common source of false positives is when the argument performs a side
-//# effect.
+//# A common source of false positives is when the expression, or
+//# another expresssion in the same && or || operation, performs a
+//# side effect.
 ///
 // Confidence: Moderate
 // Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
@@ -20,20 +21,37 @@ position p;
 @@
 
 (
-* E@p
-  || ... || E
+ E@p || ... || E
 |
-* E@p
-  && ... && E
+ E@p && ... && E
 )
 
-@script:python depends on org@
+@bad@
+expression r.E,e1,e2,fn;
+position r.p;
+assignment operator op;
+@@
+
+(
+E@p
+&
+ <+... \(fn(...)\|e1 op e2\|e1++\|e1--\|++e1\|--e1\) ...+>
+)
+
+@depends on context && !bad@
+expression r.E;
+position r.p;
+@@
+
+*E@p
+
+@script:python depends on org && !bad@
 p << r.p;
 @@
 
 cocci.print_main("duplicated argument to && or ||",p)
 
-@script:python depends on report@
+@script:python depends on report && !bad@
 p << r.p;
 @@
 
