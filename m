From: Rameshwar Prasad Sahu <rsahu@apm.com>
Subject: [PATCH] ata: fixes kernel crash while tracing ata_eh_link_autopsy
 event
Date: Wed, 25 Oct 2017 15:52:56 +0530
Message-ID: <1508926976-11467-1-git-send-email-rsahu@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: devicetree@vger.kernel.org, mlangsdo@redhat.com, linux-scsi@vger.kernel.org, jcm@redhat.com, Rameshwar Prasad Sahu <rsahu@apm.com>, patches@apm.com, linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

When tracing ata link error event, the kernel crashes when the disk is
removed due to NULL pointer access by trace_ata_eh_link_autopsy API.
This occurs as the dev is NULL when the disk disappeared. Given that
the trace routine requires only the link info, pass the link info instead
of passing dev pointer to fix this kernel crash.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
---
 drivers/ata/libata-eh.c       |    2 +-
 include/trace/events/libata.h |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index e4effef..ab50e7d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2265,7 +2265,7 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 			eflags |= ATA_EFLAG_DUBIOUS_XFER;
 		ehc->i.action |= ata_eh_speed_down(dev, eflags, all_err_mask);
 	}
-	trace_ata_eh_link_autopsy(dev, ehc->i.action, all_err_mask);
+	trace_ata_eh_link_autopsy(link, ehc->i.action, all_err_mask);
 	DPRINTK("EXIT\n");
 }

diff --git a/include/trace/events/libata.h b/include/trace/events/libata.h
index 2fbbf99..eff035e 100644
--- a/include/trace/events/libata.h
+++ b/include/trace/events/libata.h
@@ -276,9 +276,10 @@

 TRACE_EVENT(ata_eh_link_autopsy,

-	TP_PROTO(struct ata_device *dev, unsigned int eh_action, unsigned int eh_err_mask),
+	TP_PROTO(struct ata_link *link, unsigned int eh_action,
+		 unsigned int eh_err_mask),

-	TP_ARGS(dev, eh_action, eh_err_mask),
+	TP_ARGS(link, eh_action, eh_err_mask),

 	TP_STRUCT__entry(
 		__field( unsigned int,	ata_port )
@@ -288,8 +289,8 @@
 	),

 	TP_fast_assign(
-		__entry->ata_port	= dev->link->ap->print_id;
-		__entry->ata_dev	= dev->link->pmp + dev->devno;
+		__entry->ata_port	= link->ap->print_id;
+		__entry->ata_dev	= link->pmp + link->device->devno;
 		__entry->eh_action	= eh_action;
 		__entry->eh_err_mask	= eh_err_mask;
 	),
--
1.7.1
