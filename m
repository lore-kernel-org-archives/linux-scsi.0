From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/4] drivers/scsi/arcmsr: introduce missing kfree
Date: Tue, 1 Jun 2010 16:34:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1006011634390.12546@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index ffa5479..a94fb9d 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1526,6 +1526,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 		if (!acb->fw_state) {
 			pcmdmessagefld->cmdmessage.ReturnCode =
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			kfree(ver_addr);
 			goto message_out;
 		}
 
@@ -1578,6 +1579,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 		if (!acb->fw_state) {
 			pcmdmessagefld->cmdmessage.ReturnCode =
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			kfree(ver_addr);
 			goto message_out;
 		}
 
