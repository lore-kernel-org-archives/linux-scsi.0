From: christophe.varoqui@free.fr
Subject: Re: [sg3_utils] report target group
Date: Tue, 28 Dec 2004 13:55:41 +0100
Message-ID: <1104238541.41d157cd020c1@imp5-q.free.fr>
References: <1104233396.41d143b44e073@imp5-q.free.fr> <1104233551.41d1444f8d9ea@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:18380 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S261211AbUL1Mzm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Dec 2004 07:55:42 -0500
In-Reply-To: <1104233551.41d1444f8d9ea@imp5-q.free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: linux-scsi@vger.kernel.org

I forget the -N diff flag,
so here it is again :

diff -urN sg3_utils-1.11/lib_no_lib/Makefile.lib
sg3_utils-1.11cva/lib_no_lib/Mak
efile.lib
--- sg3_utils-1.11/lib_no_lib/Makefile.lib      2004-11-26 12:15:45.000000000
+01
00
+++ sg3_utils-1.11cva/lib_no_lib/Makefile.lib   2004-12-28 13:41:38.000000000
+01
00
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

diff -urN sg3_utils-1.11/Makefile sg3_utils-1.11cva/Makefile
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

diff -urN sg3_utils-1.11/sg_cmds.c sg3_utils-1.11cva/sg_cmds.c
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
+    unsigned char rlCmdBlk[REPORT_TGT_GRP_CMDLEN] =
+                         {REPORT_TGT_GRP_CMD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+    unsigned char sense_b[SENSE_BUFF_LEN];
+    struct sg_io_hdr io_hdr;
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
diff -urN sg3_utils-1.11/sg_cmds.h sg3_utils-1.11cva/sg_cmds.h
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
diff -urN sg3_utils-1.11/sg_rtg.c sg3_utils-1.11cva/sg_rtg.c
--- sg3_utils-1.11/sg_rtg.c     1970-01-01 01:00:00.000000000 +0100
+++ sg3_utils-1.11cva/sg_rtg.c  2004-12-28 15:26:19.000000000 +0100
@@ -0,0 +1,293 @@
+/*
+ * Copyright (c) 2004 Douglas Gilbert.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ *
+ */
+
+#include <unistd.h>
+#include <signal.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <getopt.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/time.h>
+#include "sg_include.h"
+#include "sg_lib.h"
+#include "sg_cmds.h"
+
+/* A utility program for the Linux OS SCSI subsystem.
+ *
+ *
+ * This program issues the SCSI command REPORT TARGET GROUP
+ * to the given SCSI device.
+ */
+
+static char * version_str = "1.00 20041227";
+
+#define REPORT_TGT_GRP_BUFF_LEN 1024
+
+#define ME "sg_rtg: "
+
+#define ALUA_STATE_OPTIMIZED 0x0
+#define ALUA_STATE_NONOPTIMIZED 0x1
+#define ALUA_STATE_STANDBY 0x2
+#define ALUA_STATE_UNAVAILABLE 0x3
+#define ALUA_STATE_TRANSITIONING 0xf
+
+#define STATUS_CODE_NOSTATUS 0x0
+#define STATUS_CODE_CHANGED_BY_SET 0x1
+#define STATUS_CODE_CHANGED_BY_IMPLICIT 0x2
+
+static struct option long_options[] = {
+        {"decode", 0, 0, 'd'},
+        {"help", 0, 0, 'h'},
+        {"select", 1, 0, 's'},
+        {"verbose", 0, 0, 'v'},
+        {"version", 0, 0, 'V'},
+        {0, 0, 0, 0},
+};
+
+static void usage()
+{
+    fprintf(stderr, "Usage: "
+          "sg_rtg    [--decode] [--help] [--select=<n>] [--verbose] "
+          "[--version]\n"
+          "                   <scsi_device>\n"
+          "  where: --decode|-d        decode all luns into parts\n"
+          "         --help|-h          print out usage message\n"
+          "         --select=<n>|-s <n>  select report <n> (def: 0)\n"
+          "                               0 -> luns apart from 'well "
+          "known' lus\n"
+          "                               1 -> only 'well known' "
+          "logical unit numbers\n"
+          "                               2 -> all luns\n"
+          "         --verbose|-v       increase verbosity\n"
+          "         --version|-V       print version string and exit\n"
+          );
+
+}
+
+static void decode_status(const int st)
+{
+    switch (st) {
+    case STATUS_CODE_NOSTATUS:
+        printf(" (no status available)");
+        break;
+    case STATUS_CODE_CHANGED_BY_SET:
+        printf(" (status changed by SET TARGET GROUP)");
+        break;
+    case STATUS_CODE_CHANGED_BY_IMPLICIT:
+        printf(" (status changed by implicit ALUA behaviour)");
+        break;
+    default:
+        printf(" (unknown status code)");
+        break;
+    }
+}
+
+static void decode_alua_state(const int st)
+{
+    switch (st) {
+    case ALUA_STATE_OPTIMIZED:
+        printf(" (active/optimized)");
+        break;
+    case ALUA_STATE_NONOPTIMIZED:
+        printf(" (active/non optimized)");
+        break;
+    case ALUA_STATE_STANDBY:
+        printf(" (standby)");
+        break;
+    case ALUA_STATE_UNAVAILABLE:
+        printf(" (unavailable)");
+        break;
+    case ALUA_STATE_TRANSITIONING:
+        printf(" (transitioning between states)");
+        break;
+    default:
+        printf(" (unknown)");
+        break;
+    }
+}
+
+int main(int argc, char * argv[])
+{
+    int sg_fd, k, l, m, off, res, c, report_len, tgt_port_count, trunc;
+    unsigned char reportTgtGrpBuff[REPORT_TGT_GRP_BUFF_LEN];
+    int decode = 0;
+    int select_rep = 0;
+    int verbose = 0;
+    char device_name[256];
+    int ret = 1;
+
+    memset(device_name, 0, sizeof device_name);
+    while (1) {
+        int option_index = 0;
+
+        c = getopt_long(argc, argv, "dhs:vV", long_options,
+                        &option_index);
+        if (c == -1)
+            break;
+
+        switch (c) {
+        case 'd':
+            decode = 1;
+            break;
+        case 'h':
+        case '?':
+            usage();
+            return 0;
+        case 's':
+           if ((1 != sscanf(optarg, "%d", &select_rep)) ||
+               (select_rep < 0) || (select_rep > 255)) {
+                fprintf(stderr, "bad argument to '--select'\n");
+                return 1;
+            }
+            break;
+        case 'v':
+            ++verbose;
+            break;
+        case 'V':
+            fprintf(stderr, ME "version: %s\n", version_str);
+            return 0;
+        default:
+            fprintf(stderr, "unrecognised switch code 0x%x ??\n", c);
+            usage();
+            return 1;
+        }
+    }
+    if (optind < argc) {
+        if ('\0' == device_name[0]) {
+            strncpy(device_name, argv[optind], sizeof(device_name) - 1);
+            device_name[sizeof(device_name) - 1] = '\0';
+            ++optind;
+        }
+        if (optind < argc) {
+            for (; optind < argc; ++optind)
+                fprintf(stderr, "Unexpected extra argument: %s\n",
+                        argv[optind]);
+            usage();
+            return 1;
+        }
+    }
+
+    if (0 == device_name[0]) {
+        fprintf(stderr, "missing device name!\n");
+        usage();
+        return 1;
+    }
+    sg_fd = open(device_name, O_RDWR | O_NONBLOCK);
+    if (sg_fd < 0) {
+        perror(ME "open error");
+        return 1;
+    }
+
+    memset(reportTgtGrpBuff, 0x0, sizeof(reportTgtGrpBuff));
+    trunc = 0;
+
+    res = sg_ll_report_tgt_grp(sg_fd, reportTgtGrpBuff,
+                            sizeof(reportTgtGrpBuff), 1, verbose);
+    if (0 == res) {
+        report_len = (reportTgtGrpBuff[0] << 24) + (reportTgtGrpBuff[1] << 16)
+
+                   (reportTgtGrpBuff[2] << 8) + reportTgtGrpBuff[3];
+        printf("Report list length = %d\n", report_len);
+        if ((report_len + 6) > (int)sizeof(reportTgtGrpBuff)) {
+            trunc = 1;
+            printf("  <<report too long for internal buffer,"
+                  " output truncated\n");
+        }
+        if (verbose) {
+            fprintf(stderr, "\nOutput response in hex\n");
+            dStrHex((const char *)reportTgtGrpBuff,
+                    (trunc ? (int)sizeof(reportTgtGrpBuff) : report_len + 6),
1)
;
+        }
+        for (k = 0, off = 4; k < report_len / 8; ++k) {
+            if (0 == k)
+                printf("Report target group:\n");
+
+            printf("    target port group assymetric access state : ");
+            printf("%02x", reportTgtGrpBuff[off++] & 0x0f);
+            if (decode)
+                decode_alua_state(reportTgtGrpBuff[off - 1] & 0x0f);
+            printf("\n");
+
+            printf("AO_SUP : %x\n", reportTgtGrpBuff[off] & 0x01);
+            printf("AN_SUP : %x\n", reportTgtGrpBuff[off] & 0x02);
+            printf("S_SUP  : %x\n", reportTgtGrpBuff[off] & 0x04);
+            printf("U_SUP  : %x\n", reportTgtGrpBuff[off] & 0x08);
+            off++;
+
+            printf("    target port group id : ");
+            for (m = 0; m < 2; ++m, ++off)
+                printf("%02x", reportTgtGrpBuff[off]);
+            printf("\n");
+
+            /* reserved */
+            off++;
+
+            printf("    status code : ");
+            printf("%02x", reportTgtGrpBuff[off++]);
+            if (decode)
+                decode_status(reportTgtGrpBuff[off - 1]);
+            printf("\n");
+
+            printf("    vendor unique status : ");
+            printf("%02x", reportTgtGrpBuff[off++]);
+            printf("\n");
+
+            printf("    target port count : ");
+            tgt_port_count = reportTgtGrpBuff[off++];
+            printf("%02x", tgt_port_count);
+            printf("\n");
+
+            for (l = 0; l < tgt_port_count; l++) {
+                if (0 == l)
+                    printf("Relative target port ids:\n");
+
+                /* obsoleted */
+                off += 2;
+
+                for (m = 0; m < 2; ++m, ++off)
+                    printf("%02x", reportTgtGrpBuff[off]);
+            }
+        }
+        ret = 0;
+    } else if (SG_LIB_CAT_INVALID_OP == res)
+        fprintf(stderr, "Report Luns command not supported (support "
+                "mandatory in SPC-3)\n");
+
+    res = close(sg_fd);
+    if (res < 0) {
+        perror(ME "close error");
+        return 1;
+    }
+    return ret;
+}

Selon christophe.varoqui@free.fr:

> The spec used for implementation is
> ftp://ftp.t10.org/t10/drafts/spc3/spc3r21b.pdf
>
--
