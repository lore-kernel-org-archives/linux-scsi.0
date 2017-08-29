From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: remove memset before memcpy
Date: Tue, 29 Aug 2017 12:29:35 -0700
Message-ID: <1504034975.2040.43.camel@perches.com>
References: <1504032559-24969-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504032559-24969-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>, jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, kashyap.desai@broadcom.com, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, sumit.saxena@broadcom.com, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, megaraidlinux.pdl@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-08-30 at 00:19 +0530, Himanshu Jha wrote:
> drivers/scsi/megaraid/megaraid_sas_fusion.c

I don't know if you did this with coccinelle.

If so, it would be good to show the tool and script
in the commit message.

If not, the input script is pretty simple.

$ cat memset_before_memcpy.cocci
@@
expression e1;
expression e2;
expression e3;
@@

-	memset(e1, 0, e3);
	memcpy(e1, e2, e3);
$

Adding a test to make sure e1 or e3 isn't
modified before any other code uses them
by doing

$ cat memset_before_memcpy_2.cocci
@@
expression e1;
expression e2;
expressi
on e3;
@@

-	memset(e1, 0, e3);
	... when != \( e1 \| e3 \)
	memcpy(e1, e2, e3);
$

finds more cases but there may be a
false positive if e1 is a passed
function argument and if the operation
isn't effectively atomic like below:

----------------------------------------------------------------
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2556,7 +2556,6 @@ void br_multicast_get_stats(const struct
 	struct br_mcast_stats tdst;
 	int i;
 
-	memset(dest, 0, sizeof(*dest));
 	if (p)
 		stats = p->mcast_stats;
 	else

----------------------------------------------------------------

where the memcpy is the last line of the function.
