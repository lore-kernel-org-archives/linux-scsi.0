From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 06/12] scsi_debug: re-order file scope declarations
Date: Mon, 25 Apr 2016 12:16:33 -0400
Message-ID: <1461600999-28893-7-git-send-email-dgilbert@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36990 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933003AbcDYQRH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:17:07 -0400
In-Reply-To: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

Group most defines together first; followed by struct definitions
and then table and variable definitions. Normalize all function
headers.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 314 ++++++++++++++++++++++------------------------
 1 file changed, 151 insertions(+), 163 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8ee9df6..349eaeb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -95,7 +95,6 @@ static const char *sdebug_version_date = "20160422";
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
 
-
 /* Default values for driver parameters */
 #define DEF_NUM_HOST   1
 #define DEF_NUM_TGTS   1
@@ -161,14 +160,14 @@ static const char *sdebug_version_date = "20160422";
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR | \
 				  SDEBUG_OPT_SHORT_TRANSFER)
 /* When "every_nth" > 0 then modulo "every_nth" commands:
- *   - a no response is simulated if SDEBUG_OPT_TIMEOUT is set
+ *   - a missing response is simulated if SDEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
  *     commands if SDEBUG_OPT_RECOVERED_ERR is set.
  *   - a TRANSPORT_ERROR is simulated on successful read and write
  *     commands if SDEBUG_OPT_TRANSPORT_ERR is set.
  *
  * When "every_nth" < 0 then after "- every_nth" commands:
- *   - a no response is simulated if SDEBUG_OPT_TIMEOUT is set
+ *   - a missing response is simulated if SDEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
  *     commands if SDEBUG_OPT_RECOVERED_ERR is set.
  *   - a TRANSPORT_ERROR is simulated on successful read and write
@@ -178,7 +177,7 @@ static const char *sdebug_version_date = "20160422";
  * every_nth via sysfs).
  */
 
-/* As indicated in SAM-5 and SPC-4 Unit Attentions (UAs)are returned in
+/* As indicated in SAM-5 and SPC-4 Unit Attentions (UAs) are returned in
  * priority order. In the subset implemented here lower numbers have higher
  * priority. The UA numbers should be a sequence starting from 0 with
  * SDEBUG_NUM_UAS being 1 higher than the highest numbered UA. */
@@ -218,7 +217,83 @@ static const char *sdebug_version_date = "20160422";
 #warning "Expect DEF_CMD_PER_LUN <= SCSI_DEBUG_CANQUEUE"
 #endif
 
-/* SCSI opcodes (first byte of cdb) mapped onto these indexes */
+#define F_D_IN			1
+#define F_D_OUT			2
+#define F_D_OUT_MAYBE		4	/* WRITE SAME, NDOB bit */
+#define F_D_UNKN		8
+#define F_RL_WLUN_OK		0x10
+#define F_SKIP_UA		0x20
+#define F_DELAY_OVERR		0x40
+#define F_SA_LOW		0x80	/* cdb byte 1, bits 4 to 0 */
+#define F_SA_HIGH		0x100	/* as used by variable length cdbs */
+#define F_INV_OP		0x200
+#define F_FAKE_RW		0x400
+#define F_M_ACCESS		0x800	/* media access */
+
+#define FF_RESPOND (F_RL_WLUN_OK | F_SKIP_UA | F_DELAY_OVERR)
+#define FF_DIRECT_IO (F_M_ACCESS | F_FAKE_RW)
+#define FF_SA (F_SA_HIGH | F_SA_LOW)
+
+#define SDEBUG_MAX_PARTS 4
+
+#define SCSI_DEBUG_MAX_CMD_LEN 32
+
+
+struct sdebug_dev_info {
+	struct list_head dev_list;
+	unsigned int channel;
+	unsigned int target;
+	u64 lun;
+	struct sdebug_host_info *sdbg_host;
+	unsigned long uas_bm[1];
+	atomic_t num_in_q;
+	char stopped;		/* TODO: should be atomic */
+	bool used;
+};
+
+struct sdebug_host_info {
+	struct list_head host_list;
+	struct Scsi_Host *shost;
+	struct device dev;
+	struct list_head dev_info_list;
+};
+
+#define to_sdebug_host(d)	\
+	container_of(d, struct sdebug_host_info, dev)
+
+struct sdebug_defer {
+	struct hrtimer hrt;
+	struct execute_work ew;
+	int qa_indx;
+};
+
+struct sdebug_queued_cmd {
+	/* in_use flagged by a bit in queued_in_use_bm[] */
+	struct sdebug_defer *sd_dp;
+	struct scsi_cmnd *a_cmnd;
+};
+
+struct sdebug_scmd_extra_t {
+	bool inj_recovered;
+	bool inj_transport;
+	bool inj_dif;
+	bool inj_dix;
+	bool inj_short;
+};
+
+struct opcode_info_t {
+	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff
+				 * for terminating element */
+	u8 opcode;		/* if num_attached > 0, preferred */
+	u16 sa;			/* service action */
+	u32 flags;		/* OR-ed set of SDEB_F_* */
+	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
+	const struct opcode_info_t *arrp;  /* num_attached elements or NULL */
+	u8 len_mask[16];	/* len=len_mask[0], then mask for cdb[1]... */
+				/* ignore cdb bytes after position 15 */
+};
+
+/* SCSI opcodes (first byte of cdb) of interest mapped onto these indexes */
 enum sdeb_opcode_index {
 	SDEB_I_INVALID_OPCODE =	0,
 	SDEB_I_INQUIRY = 1,
@@ -273,7 +348,7 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, SDEB_I_XDWRITEREAD, 0, SDEB_I_MODE_SELECT, SDEB_I_RESERVE,
 	    SDEB_I_RELEASE,
 	0, 0, SDEB_I_MODE_SENSE, 0, 0, 0, 0, 0,
-/* 0x60; 0x60->0x7d are reserved */
+/* 0x60; 0x60->0x7d are reserved, 0x7e is "extended cdb" */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	0, SDEB_I_VARIABLE_LEN,
@@ -296,24 +371,6 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 };
 
-#define F_D_IN			1
-#define F_D_OUT			2
-#define F_D_OUT_MAYBE		4	/* WRITE SAME, NDOB bit */
-#define F_D_UNKN		8
-#define F_RL_WLUN_OK		0x10
-#define F_SKIP_UA		0x20
-#define F_DELAY_OVERR		0x40
-#define F_SA_LOW		0x80	/* cdb byte 1, bits 4 to 0 */
-#define F_SA_HIGH		0x100	/* as used by variable length cdbs */
-#define F_INV_OP		0x200
-#define F_FAKE_RW		0x400
-#define F_M_ACCESS		0x800	/* media access */
-
-#define FF_RESPOND (F_RL_WLUN_OK | F_SKIP_UA | F_DELAY_OVERR)
-#define FF_DIRECT_IO (F_M_ACCESS | F_FAKE_RW)
-#define FF_SA (F_SA_HIGH | F_SA_LOW)
-
-struct sdebug_dev_info;
 static int resp_inquiry(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_report_luns(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_requests(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -336,18 +393,6 @@ static int resp_xdwriteread_10(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 
-struct opcode_info_t {
-	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff
-				 * for terminating element */
-	u8 opcode;		/* if num_attached > 0, preferred */
-	u16 sa;			/* service action */
-	u32 flags;		/* OR-ed set of SDEB_F_* */
-	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
-	const struct opcode_info_t *arrp;  /* num_attached elements or NULL */
-	u8 len_mask[16];	/* len=len_mask[0], then mask for cdb[1]... */
-				/* ignore cdb bytes after position 15 */
-};
-
 static const struct opcode_info_t msense_iarr[1] = {
 	{0, 0x1a, 0, F_D_IN, NULL, NULL,
 	    {6,  0xe8, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
@@ -508,14 +553,6 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
 
-struct sdebug_scmd_extra_t {
-	bool inj_recovered;
-	bool inj_transport;
-	bool inj_dif;
-	bool inj_dix;
-	bool inj_short;
-};
-
 static int sdebug_add_host = DEF_NUM_HOST;
 static int sdebug_ato = DEF_ATO;
 static int sdebug_jdelay = DEF_JDELAY;	/* if > 0 then unit is jiffies */
@@ -563,8 +600,6 @@ static atomic_t sdebug_cmnd_count;
 static atomic_t sdebug_completions;
 static atomic_t sdebug_a_tsf;		/* counter of 'almost' TSFs */
 
-#define DEV_READONLY(TGT)      (0)
-
 static unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
 
@@ -574,58 +609,10 @@ static int sdebug_heads;		/* heads per disk */
 static int sdebug_cylinders_per;	/* cylinders per surface */
 static int sdebug_sectors_per;		/* sectors per cylinder */
 
-#define SDEBUG_MAX_PARTS 4
-
-#define SCSI_DEBUG_MAX_CMD_LEN 32
-
-static unsigned int scsi_debug_lbp(void)
-{
-	return ((0 == sdebug_fake_rw) &&
-		(sdebug_lbpu | sdebug_lbpws | sdebug_lbpws10));
-}
-
-struct sdebug_dev_info {
-	struct list_head dev_list;
-	unsigned int channel;
-	unsigned int target;
-	u64 lun;
-	struct sdebug_host_info *sdbg_host;
-	unsigned long uas_bm[1];
-	atomic_t num_in_q;
-	char stopped;		/* TODO: should be atomic */
-	bool used;
-};
-
-struct sdebug_host_info {
-	struct list_head host_list;
-	struct Scsi_Host *shost;
-	struct device dev;
-	struct list_head dev_info_list;
-};
-
-#define to_sdebug_host(d)	\
-	container_of(d, struct sdebug_host_info, dev)
-
 static LIST_HEAD(sdebug_host_list);
 static DEFINE_SPINLOCK(sdebug_host_list_lock);
 
-
-struct sdebug_defer {
-	struct hrtimer hrt;
-	struct execute_work ew;
-	int qa_indx;
-};
-
-struct sdebug_queued_cmd {
-	/* in_use flagged by a bit in queued_in_use_bm[] */
-	struct sdebug_defer *sd_dp;
-	struct scsi_cmnd * a_cmnd;
-};
-static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
-static unsigned long queued_in_use_bm[SCSI_DEBUG_CANQUEUE_WORDS];
-
-
-static unsigned char * fake_storep;	/* ramdisk storage */
+static unsigned char *fake_storep;	/* ramdisk storage */
 static struct sd_dif_tuple *dif_storep;	/* protection info */
 static void *map_storep;		/* provisioning map */
 
@@ -639,6 +626,9 @@ static int dix_writes;
 static int dix_reads;
 static int dif_errors;
 
+static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
+static unsigned long queued_in_use_bm[SCSI_DEBUG_CANQUEUE_WORDS];
+
 static DEFINE_SPINLOCK(queued_arr_lock);
 static DEFINE_RWLOCK(atomic_rw);
 
@@ -661,13 +651,12 @@ static const int illegal_condition_result =
 static const int device_qfull_result =
 	(DID_OK << 16) | (COMMAND_COMPLETE << 8) | SAM_STAT_TASK_SET_FULL;
 
-static unsigned char caching_pg[] = {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
-				     0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0,
-				     0, 0, 0, 0};
-static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
-				    0, 0, 0x2, 0x4b};
-static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
-			           0, 0, 0x0, 0x0};
+
+static unsigned int scsi_debug_lbp(void)
+{
+	return ((0 == sdebug_fake_rw) &&
+		(sdebug_lbpu | sdebug_lbpws | sdebug_lbpws10));
+}
 
 static void *fake_store(unsigned long long lba)
 {
@@ -683,9 +672,6 @@ static struct sd_dif_tuple *dif_store(sector_t sector)
 	return dif_storep + sector;
 }
 
-static int sdebug_add_adapter(void);
-static void sdebug_remove_adapter(void);
-
 static void sdebug_max_tgts_luns(void)
 {
 	struct sdebug_host_info *sdbg_host;
@@ -708,9 +694,9 @@ static void sdebug_max_tgts_luns(void)
 enum sdeb_cmd_data {SDEB_IN_DATA = 0, SDEB_IN_CDB = 1};
 
 /* Set in_bit to -1 to indicate no bit position of invalid field */
-static void
-mk_sense_invalid_fld(struct scsi_cmnd *scp, enum sdeb_cmd_data c_d,
-		     int in_byte, int in_bit)
+static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
+				 enum sdeb_cmd_data c_d,
+				 int in_byte, int in_bit)
 {
 	unsigned char *sbuff;
 	u8 sks[4];
@@ -768,8 +754,7 @@ static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
 			    my_name, key, asc, asq);
 }
 
-static void
-mk_sense_invalid_opcode(struct scsi_cmnd *scp)
+static void mk_sense_invalid_opcode(struct scsi_cmnd *scp)
 {
 	mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
 }
@@ -1385,6 +1370,9 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return ret;
 }
 
+static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
+				   0, 0, 0x0, 0x0};
+
 static int resp_requests(struct scsi_cmnd * scp,
 			 struct sdebug_dev_info * devip)
 {
@@ -1605,8 +1593,8 @@ static int resp_report_tgtpgs(struct scsi_cmnd * scp,
 	return ret;
 }
 
-static int
-resp_rsup_opcodes(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_rsup_opcodes(struct scsi_cmnd *scp,
+			     struct sdebug_dev_info *devip)
 {
 	bool rctd;
 	u8 reporting_opts, req_opcode, sdeb_i, supp;
@@ -1756,8 +1744,8 @@ resp_rsup_opcodes(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return errsts;
 }
 
-static int
-resp_rsup_tmfs(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_rsup_tmfs(struct scsi_cmnd *scp,
+			  struct sdebug_dev_info *devip)
 {
 	bool repd;
 	u32 alloc_len, len;
@@ -1823,6 +1811,10 @@ static int resp_format_pg(unsigned char * p, int pcontrol, int target)
 	return sizeof(format_pg);
 }
 
+static unsigned char caching_pg[] = {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
+				     0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0,
+				     0, 0, 0, 0};
+
 static int resp_caching_pg(unsigned char * p, int pcontrol, int target)
 { 	/* Caching page for mode_sense */
 	unsigned char ch_caching_pg[] = {/* 0x8, 18, */ 0x4, 0, 0, 0, 0, 0,
@@ -1840,6 +1832,9 @@ static int resp_caching_pg(unsigned char * p, int pcontrol, int target)
 	return sizeof(caching_pg);
 }
 
+static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
+				    0, 0, 0x2, 0x4b};
+
 static int resp_ctrl_m_pg(unsigned char * p, int pcontrol, int target)
 { 	/* Control mode page for mode_sense */
 	unsigned char ch_ctrl_m_pg[] = {/* 0xa, 10, */ 0x6, 0, 0, 0, 0, 0,
@@ -1938,8 +1933,8 @@ static int resp_sas_sha_m_spg(unsigned char * p, int pcontrol)
 
 #define SDEBUG_MAX_MSENSE_SZ 256
 
-static int
-resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_mode_sense(struct scsi_cmnd *scp,
+			   struct sdebug_dev_info *devip)
 {
 	unsigned char dbd, llbaa;
 	int pcontrol, pcode, subpcode, bd_len;
@@ -1970,7 +1965,7 @@ resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			(devip->target * 1000) - 3;
 	/* set DPOFUA bit for disks */
 	if (0 == sdebug_ptype)
-		dev_spec = (DEV_READONLY(target) ? 0x80 : 0x0) | 0x10;
+		dev_spec = 0x10;	/* would be 0x81 if read-only */
 	else
 		dev_spec = 0x0;
 	if (msense_6) {
@@ -2081,8 +2076,8 @@ resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 #define SDEBUG_MAX_MSELECT_SZ 512
 
-static int
-resp_mode_select(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_mode_select(struct scsi_cmnd *scp,
+			    struct sdebug_dev_info *devip)
 {
 	int pf, sp, ps, md_len, bd_len, off, spf, pg_len;
 	int param_len, res, mpage;
@@ -2280,8 +2275,8 @@ static int check_device_access_params(struct scsi_cmnd *scp,
 }
 
 /* Returns number of bytes copied or -1 if error. */
-static int
-do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num, bool do_write)
+static int do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num,
+			    bool do_write)
 {
 	int ret;
 	u64 block, rest = 0;
@@ -2323,8 +2318,7 @@ do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num, bool do_write)
 /* If fake_store(lba,num) compares equal to arr(num), then copy top half of
  * arr into fake_store(lba,num) and return true. If comparison fails then
  * return false. */
-static bool
-comp_write_worker(u64 lba, u32 num, const u8 *arr)
+static bool comp_write_worker(u64 lba, u32 num, const u8 *arr)
 {
 	bool res;
 	u64 block, rest = 0;
@@ -2463,8 +2457,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	return 0;
 }
 
-static int
-resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
 	u64 lba;
@@ -2775,8 +2768,7 @@ static void unmap_region(sector_t lba, unsigned int len)
 	}
 }
 
-static int
-resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
 	u64 lba;
@@ -2893,9 +2885,8 @@ resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return 0;
 }
 
-static int
-resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num, u32 ei_lba,
-		bool unmap, bool ndob)
+static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
+			   u32 ei_lba, bool unmap, bool ndob)
 {
 	unsigned long iflags;
 	unsigned long long i;
@@ -2945,8 +2936,8 @@ out:
 	return 0;
 }
 
-static int
-resp_write_same_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_write_same_10(struct scsi_cmnd *scp,
+			      struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
 	u32 lba;
@@ -2970,8 +2961,8 @@ resp_write_same_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return resp_write_same(scp, lba, num, ei_lba, unmap, false);
 }
 
-static int
-resp_write_same_16(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_write_same_16(struct scsi_cmnd *scp,
+			      struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
 	u64 lba;
@@ -3001,8 +2992,8 @@ resp_write_same_16(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 /* Note the mode field is in the same position as the (lower) service action
  * field. For the Report supported operation codes command, SPC-4 suggests
  * each mode of this command should be reported separately; for future. */
-static int
-resp_write_buffer(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_write_buffer(struct scsi_cmnd *scp,
+			     struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
 	struct scsi_device *sdp = scp->device;
@@ -3047,8 +3038,8 @@ resp_write_buffer(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return 0;
 }
 
-static int
-resp_comp_write(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_comp_write(struct scsi_cmnd *scp,
+			   struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
 	u8 *arr;
@@ -3129,8 +3120,7 @@ struct unmap_block_desc {
 	__be32	__reserved;
 };
 
-static int
-resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	unsigned char *buf;
 	struct unmap_block_desc *desc;
@@ -3188,8 +3178,8 @@ out:
 
 #define SDEBUG_GET_LBA_STATUS_LEN 32
 
-static int
-resp_get_lba_status(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_get_lba_status(struct scsi_cmnd *scp,
+			       struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
 	u64 lba;
@@ -3323,8 +3313,8 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	return 0;
 }
 
-static int
-resp_xdwriteread_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+static int resp_xdwriteread_10(struct scsi_cmnd *scp,
+			       struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
 	u64 lba;
@@ -3350,8 +3340,7 @@ resp_xdwriteread_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 }
 
 /* Queued command completions converge here. */
-static void
-sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
+static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 {
 	int qa_indx;
 	int retiring = 0;
@@ -3409,8 +3398,7 @@ sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 }
 
 /* When high resolution timer goes off this function is called. */
-static enum hrtimer_restart
-sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
+static enum hrtimer_restart sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
 {
 	struct sdebug_defer *sd_dp = container_of(timer, struct sdebug_defer,
 						  hrt);
@@ -3419,16 +3407,15 @@ sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
 }
 
 /* When work queue schedules work, it calls this function. */
-static void
-sdebug_q_cmd_wq_complete(struct work_struct *work)
+static void sdebug_q_cmd_wq_complete(struct work_struct *work)
 {
 	struct sdebug_defer *sd_dp = container_of(work, struct sdebug_defer,
 						  ew.work);
 	sdebug_q_cmd_complete(sd_dp);
 }
 
-static struct sdebug_dev_info *
-sdebug_device_create(struct sdebug_host_info *sdbg_host, gfp_t flags)
+static struct sdebug_dev_info *sdebug_device_create(
+			struct sdebug_host_info *sdbg_host, gfp_t flags)
 {
 	struct sdebug_dev_info *devip;
 
@@ -3794,9 +3781,8 @@ static void __init sdebug_build_parts(unsigned char *ramp,
 	}
 }
 
-static int
-schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
-	      int scsi_result, int delta_jiff)
+static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
+			 int scsi_result, int delta_jiff)
 {
 	unsigned long iflags;
 	int k, num_in_q, qdepth, inject;
@@ -4020,7 +4006,8 @@ static const char * scsi_debug_info(struct Scsi_Host * shp)
 }
 
 /* 'echo <val> > /proc/scsi/scsi_debug/<host_id>' writes to opts */
-static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer, int length)
+static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer,
+				 int length)
 {
 	char arr[16];
 	int opts;
@@ -4124,7 +4111,7 @@ static ssize_t ndelay_show(struct device_driver *ddp, char *buf)
 /* Returns -EBUSY if ndelay is being changed and commands are queued */
 /* If > 0 and accepted then sdebug_jdelay is set to JDELAY_OVERRIDDEN */
 static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
-			   size_t count)
+			    size_t count)
 {
 	unsigned long iflags;
 	int ndelay, res, k;
@@ -4433,6 +4420,9 @@ static ssize_t add_host_show(struct device_driver *ddp, char *buf)
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_add_host);
 }
 
+static int sdebug_add_adapter(void);
+static void sdebug_remove_adapter(void);
+
 static ssize_t add_host_store(struct device_driver *ddp, const char *buf,
 			      size_t count)
 {
@@ -4902,8 +4892,7 @@ static void sdebug_remove_adapter(void)
 	--sdebug_add_host;
 }
 
-static int
-sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
+static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 {
 	int num_in_q = 0;
 	unsigned long iflags;
@@ -4933,8 +4922,7 @@ sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 	return sdev->queue_depth;
 }
 
-static int
-check_inject(struct scsi_cmnd *scp)
+static int check_inject(struct scsi_cmnd *scp)
 {
 	struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
 
@@ -4965,8 +4953,8 @@ check_inject(struct scsi_cmnd *scp)
 	return 0;
 }
 
-static int
-scsi_debug_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scp)
+static int scsi_debug_queuecommand(struct Scsi_Host *shost,
+				   struct scsi_cmnd *scp)
 {
 	u8 sdeb_i;
 	struct scsi_device *sdp = scp->device;
-- 
2.7.4

