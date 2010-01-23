From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 1/8] PM: Add parent information to timing messages
Date: Sun, 24 Jan 2010 00:34:36 +0100
Message-ID: <201001240034.36423.rjw@sisk.pl>
References: <201001240033.34253.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
In-Reply-To: <201001240033.34253.rjw@sisk.pl>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/linux-pm>
List-Post: <mailto:linux-pm@lists.linux-foundation.org>
List-Help: <mailto:linux-pm-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=subscribe>
Sender: linux-pm-bounces@lists.linux-foundation.org
Errors-To: linux-pm-bounces@lists.linux-foundation.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nigel Cunningham <ncunningham@crca.org.au>, Greg KH <gregkh@suse.de>, Linux SCSI <linux-scsi@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>, linux-usb@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, pm list <linux-pm@lists.linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add parent information to the messages printed by the suspend/resume
core when initcall_debug is set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -271,8 +271,9 @@ static int pm_noirq_op(struct device *de
 	ktime_t calltime, delta, rettime;
 
 	if (initcall_debug) {
-		pr_info("calling  %s_i+ @ %i\n",
-				dev_name(dev), task_pid_nr(current));
+		pr_info("calling  %s+ @ %i, parent: %s\n",
+				dev_name(dev), task_pid_nr(current),
+				dev->parent ? dev_name(dev->parent) : "none");
 		calltime = ktime_get();
 	}
 
