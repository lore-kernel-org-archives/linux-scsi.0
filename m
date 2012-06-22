From: Dan Williams <dan.j.williams@intel.com>
Subject: [set4 PATCH 1/4] libata: reset once
Date: Thu, 21 Jun 2012 23:41:41 -0700
Message-ID: <20120622064141.21452.71091.stgit@dwillia2-linux.jf.intel.com>
References: <20120622064135.21452.82833.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120622064135.21452.82833.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hotplug testing with libsas currently encounters a 55 second wait for
link recovery to give up.  In the case where the user trusts the
response time of their devices permit the recovery attempts to be
limited to one.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 drivers/ata/libata-core.c           |    1 +
 drivers/ata/libata-eh.c             |    2 ++
 include/linux/libata.h              |    1 +
 4 files changed, 7 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a92c5eb..a896b25 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1351,6 +1351,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			* nohrst, nosrst, norst: suppress hard, soft
                           and both resets.
 
+			* rstonce: only attempt one reset during
+			  hot-unplug link recovery
+
 			* dump_id: dump IDENTIFY data.
 
 			If there are multiple matching configurations changing
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3fe1202..efd2c72 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6388,6 +6388,7 @@ static int __init ata_parse_force_one(char **cur,
 		{ "nohrst",	.lflags		= ATA_LFLAG_NO_HRST },
 		{ "nosrst",	.lflags		= ATA_LFLAG_NO_SRST },
 		{ "norst",	.lflags		= ATA_LFLAG_NO_HRST | ATA_LFLAG_NO_SRST },
+		{ "rstonce",	.lflags		= ATA_LFLAG_RST_ONCE },
 	};
 	char *start = *cur, *p = *cur;
 	char *id, *val, *endp;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 77fc806..a5d2aba 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2623,6 +2623,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	 */
 	while (ata_eh_reset_timeouts[max_tries] != ULONG_MAX)
 		max_tries++;
+	if (link->flags & ATA_LFLAG_RST_ONCE)
+		max_tries = 1;
 	if (link->flags & ATA_LFLAG_NO_HRST)
 		hardreset = NULL;
 	if (link->flags & ATA_LFLAG_NO_SRST)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 53da442..f777d30 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -182,6 +182,7 @@ enum {
 	ATA_LFLAG_DISABLED	= (1 << 6), /* link is disabled */
 	ATA_LFLAG_SW_ACTIVITY	= (1 << 7), /* keep activity stats */
 	ATA_LFLAG_NO_LPM	= (1 << 8), /* disable LPM on this link */
+	ATA_LFLAG_RST_ONCE	= (1 << 9), /* limit recovery to one reset */
 
 	/* struct ata_port flags */
 	ATA_FLAG_SLAVE_POSS	= (1 << 0), /* host supports slave dev */

