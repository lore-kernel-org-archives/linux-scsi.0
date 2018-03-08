From: Stephen Kitt <steve@sk2.org>
Subject: [PATCH] aic7xxx/aic79xx: remove VLAs
Date: Thu,  8 Mar 2018 14:22:25 +0100
Message-ID: <20180308132225.13229-1-steve@sk2.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.com
Cc: linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Stephen Kitt <steve@sk2.org>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wvla, remove VLAs and replace them with
fixed-length arrays instead.

The arrays fixed here, using the number of constant sections, aren't
really VLAs, but they appear so to the compiler. Since we know at
build-time how many critical sections there are, we might as well use
a pre-processor-level constant instead.

This was prompted by https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 drivers/scsi/aic7xxx/aic79xx_core.c        | 8 ++++----
 drivers/scsi/aic7xxx/aic79xx_seq.h_shipped | 3 +--
 drivers/scsi/aic7xxx/aic7xxx_core.c        | 8 ++++----
 drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped | 3 +--
 drivers/scsi/aic7xxx/aicasm/aicasm.c       | 6 ++++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index b560f396ee99..034f4eebb160 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -9338,9 +9338,9 @@ ahd_dumpseq(struct ahd_softc* ahd)
 static void
 ahd_loadseq(struct ahd_softc *ahd)
 {
-	struct	cs cs_table[num_critical_sections];
-	u_int	begin_set[num_critical_sections];
-	u_int	end_set[num_critical_sections];
+	struct	cs cs_table[NUM_CRITICAL_SECTIONS];
+	u_int	begin_set[NUM_CRITICAL_SECTIONS];
+	u_int	end_set[NUM_CRITICAL_SECTIONS];
 	const struct patch *cur_patch;
 	u_int	cs_count;
 	u_int	cur_cs;
@@ -9456,7 +9456,7 @@ ahd_loadseq(struct ahd_softc *ahd)
 		 * Move through the CS table until we find a CS
 		 * that might apply to this instruction.
 		 */
-		for (; cur_cs < num_critical_sections; cur_cs++) {
+		for (; cur_cs < NUM_CRITICAL_SECTIONS; cur_cs++) {
 			if (critical_sections[cur_cs].end <= i) {
 				if (begin_set[cs_count] == TRUE
 				 && end_set[cs_count] == FALSE) {
diff --git a/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped b/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
index 4b51e232392f..20fb9ca9e271 100644
--- a/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
+++ b/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
@@ -1186,5 +1186,4 @@ static const struct cs {
 	{ 759, 763 }
 };
 
-static const int num_critical_sections = sizeof(critical_sections)
-				       / sizeof(*critical_sections);
+#define NUM_CRITICAL_SECTIONS 14
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 6612ff3b2e83..e97eceacf522 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6848,9 +6848,9 @@ ahc_dumpseq(struct ahc_softc* ahc)
 static int
 ahc_loadseq(struct ahc_softc *ahc)
 {
-	struct	cs cs_table[num_critical_sections];
-	u_int	begin_set[num_critical_sections];
-	u_int	end_set[num_critical_sections];
+	struct	cs cs_table[NUM_CRITICAL_SECTIONS];
+	u_int	begin_set[NUM_CRITICAL_SECTIONS];
+	u_int	end_set[NUM_CRITICAL_SECTIONS];
 	const struct patch *cur_patch;
 	u_int	cs_count;
 	u_int	cur_cs;
@@ -6915,7 +6915,7 @@ ahc_loadseq(struct ahc_softc *ahc)
 		 * Move through the CS table until we find a CS
 		 * that might apply to this instruction.
 		 */
-		for (; cur_cs < num_critical_sections; cur_cs++) {
+		for (; cur_cs < NUM_CRITICAL_SECTIONS; cur_cs++) {
 			if (critical_sections[cur_cs].end <= i) {
 				if (begin_set[cs_count] == TRUE
 				 && end_set[cs_count] == FALSE) {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped b/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
index 07e93fbae706..d814f1d6b820 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
+++ b/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
@@ -1304,5 +1304,4 @@ static const struct cs {
 	{ 875, 877 }
 };
 
-static const int num_critical_sections = sizeof(critical_sections)
-				       / sizeof(*critical_sections);
+#define NUM_CRITICAL_SECTIONS 7
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.c b/drivers/scsi/aic7xxx/aicasm/aicasm.c
index 21ac265280bf..bdffe84221ce 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm.c
@@ -353,6 +353,7 @@ output_code()
 	critical_section_t *cs;
 	symbol_node_t *cur_node;
 	int instrcount;
+	int num_critical_sections;
 
 	instrcount = 0;
 	fprintf(ofile,
@@ -440,19 +441,20 @@ output_code()
 "	uint16_t	end;\n"
 "} critical_sections[] = {\n");
 
+	num_critical_sections = 0;
 	for (cs = TAILQ_FIRST(&cs_tailq);
 	     cs != NULL;
 	     cs = TAILQ_NEXT(cs, links)) {
 		fprintf(ofile, "%s\t{ %d, %d }",
 			cs == TAILQ_FIRST(&cs_tailq) ? "" : ",\n",
 			cs->begin_addr, cs->end_addr);
+		num_critical_sections++;
 	}
 
 	fprintf(ofile, "\n};\n\n");
 
 	fprintf(ofile,
-"static const int num_critical_sections = sizeof(critical_sections)\n"
-"				       / sizeof(*critical_sections);\n");
+		"#define NUM_CRITICAL_SECTIONS %d\n", num_critical_sections);
 
 	fprintf(stderr, "%s: %d instructions used\n", appname, instrcount);
 }
-- 
2.11.0
