From: christophe.varoqui@free.fr
Subject: [sg3_utils] report target group
Date: Tue, 28 Dec 2004 12:29:56 +0100
Message-ID: <1104233396.41d143b44e073@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-2.free.fr ([213.228.0.176]:23757 "EHLO
	postfix4-2.free.fr") by vger.kernel.org with ESMTP id S261195AbUL1L35
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Dec 2004 06:29:57 -0500
Received: from imp5-q.free.fr (imp5-q.free.fr [212.27.42.5])
	by postfix4-2.free.fr (Postfix) with ESMTP id 6FC0F296744
	for <linux-scsi@vger.kernel.org>; Tue, 28 Dec 2004 12:29:56 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

can someone with the appropriate hardware (SCCS == 1 in sg_inq) can audit the
following sg_rtg command.

This command is proposed for inclusion in sg3_utils.

regards,
cvaroqui

diff -u sg3_utils-1.11/Makefile sg3_utils-1.11cva/Makefile
--- sg3_utils-1.11/Makefile     2004-11-26 12:15:45.000000000 +0100
+++ sg3_utils-1.11cva/Makefile  2004-12-28 13:41:38.000000000 +0100
@@ -14,7 +14,7 @@
        sg_start sg_reset sg_modes sg_logs sg_senddiag sg_opcodes \
        sg_persist sg_write_long sg_read_long sg_requests sg_ses \
        sg_verify sg_emc_trespass sg_luns sg_sync sg_prevent \
-       sg_get_config
+       sg_get_config sg_rtg

 MAN_PGS = sg_dd.8 sgp_dd.8 sgm_dd.8 sg_read.8 sg_map.8 sg_scan.8 sg_rbuf.8 \
        sginfo.8 sg_readcap.8 sg_turs.8 sg_inq.8 sg_test_rwbuf.8 \
@@ -136,6 +136,9 @@
 sg_luns: sg_luns.o libsgutils.la
        libtool --mode=link $(LD) -o $@ $(LDFLAGS) $^

+sg_rtg: sg_rtg.o libsgutils.la
+       libtool --mode=link $(LD) -o $@ $(LDFLAGS) $^
+
 sg_sync: sg_sync.o libsgutils.la
        libtool --mode=link $(LD) -o $@ $(LDFLAGS) $^

diff -u sg3_utils-1.11/sg_cmds.c sg3_utils-1.11cva/sg_cmds.c
--- sg3_utils-1.11/sg_cmds.c    2004-11-26 00:23:45.000000000 +0100
+++ sg3_utils-1.11cva/sg_cmds.c 2004-12-28 14:50:35.000000000 +0100
@@ -82,6 +82,9 @@
 #define REQUEST_SENSE_CMDLEN 6
 #define REPORT_LUNS_CMD 0xa0
 #define REPORT_LUNS_CMDLEN 12
+#define REPORT_TGT_GRP_CMD 0xa3
+#define REPORT_TGT_GRP_SA 0x0a
+#define REPORT_TGT_GRP_CMDLEN 12
 #define LOG_SENSE_CMD     0x4d
 #define LOG_SENSE_CMDLEN  10
 #define LOG_SELECT_CMD     0x4c
@@ -1080,3 +1083,64 @@
         return -1;
     }
 }
+
+/* Invokes a SCSI REPORT TARGET GROUP command */
+/* Return of 0 -> success, SG_LIB_CAT_INVALID_OP -> Report Target Group not
+ * supported, -1 -> other failure */
+int sg_ll_report_tgt_grp(int sg_fd, void * resp,
+                      int mx_resp_len, int noisy, int verbose)
+{
+    int k, res;
+
+    rlCmdBlk[1] = REPORT_TGT_GRP_SA & 0x1f;
+    rlCmdBlk[6] = (mx_resp_len >> 24) & 0xff;
+    rlCmdBlk[7] = (mx_resp_len >> 16) & 0xff;
+    rlCmdBlk[8] = (mx_resp_len >> 8) & 0xff;
+    rlCmdBlk[9] = mx_resp_len & 0xff;
+    if (NULL == sg_warnings_str)
+        sg_warnings_str = stderr;
+    if (verbose) {
+        fprintf(sg_warnings_str, "        report target group cdb: ");
+        for (k = 0; k < REPORT_TGT_GRP_CMDLEN; ++k)
+            fprintf(sg_warnings_str, "%02x ", rlCmdBlk[k]);
+        fprintf(sg_warnings_str, "\n");
+    }
+    }
+    }
+    }
+    }
+    memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
+    memset(sense_b, 0, sizeof(sense_b));
+    io_hdr.interface_id = 'S';
+    io_hdr.cmd_len = sizeof(rlCmdBlk);
+    io_hdr.mx_sb_len = sizeof(sense_b);
+    io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+    io_hdr.dxfer_len = mx_resp_len;
+    io_hdr.dxferp = resp;
+    io_hdr.cmdp = rlCmdBlk;
+    io_hdr.sbp = sense_b;
+    io_hdr.timeout = DEF_TIMEOUT;
+
+    if (ioctl(sg_fd, SG_IO, &io_hdr) < 0) {
+        fprintf(sg_warnings_str, "report_tgt_grp (SG_IO) error: %s\n",
+                safe_strerror(errno));
+        return -1;
+    }
+    res = sg_err_category3(&io_hdr);
+    switch (res) {
+    case SG_LIB_CAT_CLEAN:
+    case SG_LIB_CAT_RECOVERED:
+        if (verbose && io_hdr.resid)
+            fprintf(sg_warnings_str, "    report_tgt_grp: resid=%d\n",
+                    io_hdr.resid);
+        return 0;
+    case SG_LIB_CAT_INVALID_OP:
+        return res;
+    case SG_LIB_CAT_MEDIA_CHANGED:
+        return 2;
+    default:
+        if (noisy || verbose)
+            sg_chk_n_print3("REPORT TARGET GROUP command error", &io_hdr);
+        return -1;
+    }
+}
diff -u sg3_utils-1.11/sg_cmds.h sg3_utils-1.11cva/sg_cmds.h
--- sg3_utils-1.11/sg_cmds.h    2004-11-02 08:55:53.000000000 +0100
+++ sg3_utils-1.11cva/sg_cmds.h 2004-12-28 13:46:28.000000000 +0100
@@ -41,6 +41,9 @@
 extern int sg_ll_report_luns(int sg_fd, int select_report, void * resp,
                              int mx_resp_len, int noisy, int verbose);

+extern int sg_ll_report_tgt_grp(int sg_fd, void * resp,
+                             int mx_resp_len, int noisy, int verbose);
+
 extern int sg_ll_log_sense(int sg_fd, int ppc, int sp, int pc, int pg_code,
                            int paramp, unsigned char * resp, int mx_resp_len,
                            int noisy, int verbose);

--
