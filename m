From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] osst endianness annotations
Date: Fri, 09 Feb 2007 16:39:45 +0000
Message-ID: <E1HFYmn-0006qY-OE@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946660AbXBIQno@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/osst.c |    8 +++---
 drivers/scsi/osst.h |   68 +++++++++++++++++++++++++-------------------------
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 7d23110..bd6bbf6 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -521,10 +521,10 @@ static void osst_init_aux(struct osst_tape * STp, int frame_type, int frame_seq_
 		break;
 	  default: ; /* probably FILL */
 	}
-	aux->filemark_cnt = ntohl(STp->filemark_cnt);
-	aux->phys_fm = ntohl(0xffffffff);
-	aux->last_mark_ppos = ntohl(STp->last_mark_ppos);
-	aux->last_mark_lbn  = ntohl(STp->last_mark_lbn);
+	aux->filemark_cnt = htonl(STp->filemark_cnt);
+	aux->phys_fm = htonl(0xffffffff);
+	aux->last_mark_ppos = htonl(STp->last_mark_ppos);
+	aux->last_mark_lbn  = htonl(STp->last_mark_lbn);
 }
 
 /*
diff --git a/drivers/scsi/osst.h b/drivers/scsi/osst.h
index 1e426f5..2cc7b5a 100644
--- a/drivers/scsi/osst.h
+++ b/drivers/scsi/osst.h
@@ -288,11 +288,11 @@ typedef struct {
 #else
 #error "Please fix <asm/byteorder.h>"
 #endif
-        u16             max_speed;              /* Maximum speed supported in KBps */
+        __be16          max_speed;              /* Maximum speed supported in KBps */
         u8              reserved10, reserved11;
-        u16             ctl;                    /* Continuous Transfer Limit in blocks */
-        u16             speed;                  /* Current Speed, in KBps */
-        u16             buffer_size;            /* Buffer Size, in 512 bytes */
+        __be16          ctl;                    /* Continuous Transfer Limit in blocks */
+        __be16          speed;                  /* Current Speed, in KBps */
+        __be16          buffer_size;            /* Buffer Size, in 512 bytes */
         u8              reserved18, reserved19;
 } osst_capabilities_page_t;
 
@@ -352,8 +352,8 @@ typedef struct {
 	u8		reserved2;
 	u8		density;
 	u8		reserved3,reserved4;
-	u16		segtrk;
-	u16		trks;
+	__be16		segtrk;
+	__be16		trks;
 	u8		reserved5,reserved6,reserved7,reserved8,reserved9,reserved10;
 } osst_tape_paramtr_page_t;
 
@@ -369,18 +369,18 @@ typedef struct {
 typedef struct os_partition_s {
         __u8    partition_num;
         __u8    par_desc_ver;
-        __u16   wrt_pass_cntr;
-        __u32   first_frame_ppos;
-        __u32   last_frame_ppos;
-        __u32   eod_frame_ppos;
+        __be16  wrt_pass_cntr;
+        __be32  first_frame_ppos;
+        __be32  last_frame_ppos;
+        __be32  eod_frame_ppos;
 } os_partition_t;
 
 /*
  * DAT entry
  */
 typedef struct os_dat_entry_s {
-        __u32   blk_sz;
-        __u16   blk_cnt;
+        __be32  blk_sz;
+        __be16  blk_cnt;
         __u8    flags;
         __u8    reserved;
 } os_dat_entry_t;
@@ -412,23 +412,23 @@ typedef struct os_dat_s {
  * AUX
  */
 typedef struct os_aux_s {
-        __u32           format_id;              /* hardware compability AUX is based on */
+        __be32          format_id;              /* hardware compability AUX is based on */
         char            application_sig[4];     /* driver used to write this media */
-        __u32           hdwr;                   /* reserved */
-        __u32           update_frame_cntr;      /* for configuration frame */
+        __be32          hdwr;                   /* reserved */
+        __be32          update_frame_cntr;      /* for configuration frame */
         __u8            frame_type;
         __u8            frame_type_reserved;
         __u8            reserved_18_19[2];
         os_partition_t  partition;
         __u8            reserved_36_43[8];
-        __u32           frame_seq_num;
-        __u32           logical_blk_num_high;
-        __u32           logical_blk_num;
+        __be32          frame_seq_num;
+        __be32          logical_blk_num_high;
+        __be32          logical_blk_num;
         os_dat_t        dat;
         __u8            reserved188_191[4];
-        __u32           filemark_cnt;
-        __u32           phys_fm;
-        __u32           last_mark_ppos;
+        __be32          filemark_cnt;
+        __be32          phys_fm;
+        __be32          last_mark_ppos;
         __u8            reserved204_223[20];
 
         /*
@@ -436,8 +436,8 @@ typedef struct os_aux_s {
          *
          * Linux specific fields:
          */
-         __u32          next_mark_ppos;         /* when known, points to next marker */
-	 __u32		last_mark_lbn;		/* storing log_blk_num of last mark is extends ADR spec */
+         __be32         next_mark_ppos;         /* when known, points to next marker */
+	 __be32		last_mark_lbn;		/* storing log_blk_num of last mark is extends ADR spec */
          __u8           linux_specific[24];
 
         __u8            reserved_256_511[256];
@@ -450,19 +450,19 @@ typedef struct os_fm_tab_s {
 	__u8		reserved_1;
 	__u8		fm_tab_ent_sz;
 	__u8		reserved_3;
-	__u16		fm_tab_ent_cnt;
+	__be16		fm_tab_ent_cnt;
 	__u8		reserved6_15[10];
-	__u32		fm_tab_ent[OS_FM_TAB_MAX];
+	__be32		fm_tab_ent[OS_FM_TAB_MAX];
 } os_fm_tab_t;
 
 typedef struct os_ext_trk_ey_s {
 	__u8		et_part_num;
 	__u8		fmt;
-	__u16		fm_tab_off;
+	__be16		fm_tab_off;
 	__u8		reserved4_7[4];
-	__u32		last_hlb_hi;
-	__u32		last_hlb;
-	__u32		last_pp;
+	__be32		last_hlb_hi;
+	__be32		last_hlb;
+	__be32		last_pp;
 	__u8		reserved20_31[12];
 } os_ext_trk_ey_t;
 
@@ -479,17 +479,17 @@ typedef struct os_header_s {
         char            ident_str[8];
         __u8            major_rev;
         __u8            minor_rev;
-	__u16		ext_trk_tb_off;
+	__be16		ext_trk_tb_off;
         __u8            reserved12_15[4];
         __u8            pt_par_num;
         __u8            pt_reserved1_3[3];
         os_partition_t  partition[16];
-	__u32		cfg_col_width;
-	__u32		dat_col_width;
-	__u32		qfa_col_width;
+	__be32		cfg_col_width;
+	__be32		dat_col_width;
+	__be32		qfa_col_width;
 	__u8		cartridge[16];
 	__u8		reserved304_511[208];
-	__u32		old_filemark_list[16680/4];		/* in ADR 1.4 __u8 track_table[16680] */
+	__be32		old_filemark_list[16680/4];		/* in ADR 1.4 __u8 track_table[16680] */
 	os_ext_trk_tb_t	ext_track_tb;
 	__u8		reserved17272_17735[464];
 	os_fm_tab_t	dat_fm_tab;
-- 
1.5.0-rc2.GIT
