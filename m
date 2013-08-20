From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/9] target: Add support for COMPARE_AND_WRITE (VAAI)
 emulation
Date: Tue, 20 Aug 2013 15:19:06 -0700
Message-ID: <1377037146.32763.10.camel@haakon3.risingtidesystems.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
	 <20130820212912.GA9483@lst.de>
	 <1377035588.32763.7.camel@haakon3.risingtidesystems.com>
	 <5213E72F.6070309@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5213E72F.6070309@interlog.com>
Sender: target-devel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Eric Seppanen <eric@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-08-20 at 18:01 -0400, Douglas Gilbert wrote:
> On 13-08-20 05:53 PM, Nicholas A. Bellinger wrote:
> > On Tue, 2013-08-20 at 23:29 +0200, Christoph Hellwig wrote:

<SNIP>

> >> Also for a complex command like this with all it's race potential I would
> >> really like to see some test cases to go along with it.
> >>
> >
> > Yes, Eric @ PureStorage has a sg_compare_write that I'm using to test
> > this.  It's probably about time that this be included in upstream
> > sg3-utils too..
> 
> Changelog for sg3_utils-1.35 [20130117] [svn: r476]
>    - sg_compare_and_write: new utility
> ...
> 
> So it has been released for 6 months. Also version 1.36
> has been released since then so you might check more
> often. Does Eric's version have any improvements over the
> version already in sg3_utils? [Apart from a shorter name ...]
> 

Mmm, that I'm not sure about..  Eric's version (CC'ed) is inline below.

--nab

Index: src/sg_compare_and_write.c
===================================================================
--- src/sg_compare_and_write.c	(revision 0)
+++ src/sg_compare_and_write.c	(revision 10195)
@@ -0,0 +1,560 @@
+/*
+ * Copyright (c) 2009-2010 Douglas Gilbert.
+ * Copyright (c) 2011 Pure Storage, Inc.
+ * All rights reserved.
+ * Use of this source code is governed by a BSD-style
+ * license that can be found in the BSD_LICENSE file.
+ */
+
+#include <unistd.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <limits.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <getopt.h>
+#define __STDC_FORMAT_MACROS 1
+#include <inttypes.h>
+
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+#include "sg_lib.h"
+#include "sg_pt.h"
+#include "sg_cmds_basic.h"
+#include "sg_cmds_extra.h"
+
+static char * version_str = "0.01 20110803";
+
+
+#define ME "sg_compare_and_write: "
+
+#define COMPARE_AND_WRITE_OP 0x89
+#define COMPARE_AND_WRITE_LEN 16
+#define RCAP10_RESP_LEN 8
+#define RCAP16_RESP_LEN 32
+#define SENSE_BUFF_LEN 32       /* Arbitrary, could be larger */
+#define DEF_TIMEOUT_SECS 60
+#define DEF_WS_NUMBLOCKS 1
+#define MAX_XFER_LEN (64 * 1024)
+#define EBUFF_SZ 256
+
+static struct option long_options[] = {
+    {"fua", no_argument, 0, 'f'},
+    {"grpnum", required_argument, 0, 'g'},
+    {"help", no_argument, 0, 'h'},
+    {"inc", required_argument, 0, 'C'},
+    {"inw", required_argument, 0, 'W'},
+    {"lba", required_argument, 0, 'l'},
+    {"num", required_argument, 0, 'n'},
+    {"timeout", required_argument, 0, 'r'},
+    {"verbose", no_argument, 0, 'v'},
+    {"version", no_argument, 0, 'V'},
+    {"wrprotect", required_argument, 0, 'w'},
+    {"xferlen", required_argument, 0, 'x'},
+    {0, 0, 0, 0},
+};
+
+struct opts_t {
+    int fua;
+    int grpnum;
+    char ifilenamec[256];
+    char ifilenamew[256];
+    uint64_t lba;
+    int numblocks;
+    int timeout;
+    int verbose;
+    int wrprotect;
+    int xfer_len;
+    int xfer_len_override;
+};
+
+
+
+static void
+usage()
+{
+  fprintf(stderr, "Usage: "
+          "sg_compare_and_write [--fua] [--grpnum=GN] [--help]\n"
+          "                     [--inc=IF] [--inw=IF] [--lba=LBA] [--lbdata] [--num=NUM] [--pbdata]\n"
+          "                     [--timeout=TO] [--unmap] [--verbose] [--version]\n"
+          "                     [--wrprotect=WRP] [xferlen=LEN] DEVICE\n"
+          "  where:\n"
+          "    --fua                Set FUA bit\n"
+          "    --grpnum=GN|-g GN    GN is group number field (def: 0)\n"
+          "    --help|-h            print out usage message\n"
+          "    --compare=FILE|-C FILE  FILE is file to fetch compare data from (use LEN\n"
+          "                            bytes or whole file).\n"
+          "    --write=FILE|-W FILE    FILE is file to fetch write data from (use LEN\n"
+          "                            bytes or whole file).\n"
+          "    --lba=LBA|-l LBA     LBA is the logical block address to start (def: 0)\n"
+          "    --num=NUM|-n NUM     NUM is number of logical blocks to write (def: 1)\n"
+          "    --timeout=TO|-t TO   command timeout (unit: seconds) (def: 60)\n"
+          "    --verbose|-v         increase verbosity\n"
+          "    --version|-V         print version string then exit\n"
+          "    --wrprotect=WPR|-w WPR    WPR is the WRPROTECT field value (def: 0)\n"
+          "    --xferlen=LEN|-x LEN    LEN is number of bytes from input to send to\n"
+          "                            DEVICE (def: IF file length)\n\n"
+          "Performs a SCSI COMPARE AND WRITE command\n"
+          );
+}
+
+static int
+do_compare_and_write(int sg_fd, const struct opts_t * optsp, const void * dataoutp)
+{
+    int k, ret, res, sense_cat, cdb_len;
+    uint64_t llba;
+    uint32_t unum;
+    unsigned char wsCmdBlk[COMPARE_AND_WRITE_LEN];
+    unsigned char sense_b[SENSE_BUFF_LEN];
+    struct sg_pt_base * ptvp;
+
+    cdb_len = 16;
+
+    memset(wsCmdBlk, 0, sizeof(wsCmdBlk));
+
+    wsCmdBlk[0] = COMPARE_AND_WRITE_OP;
+    wsCmdBlk[1] = ((optsp->wrprotect & 0x7) << 5);
+    if (optsp->fua)
+        wsCmdBlk[1] |= 0x08;
+    llba = optsp->lba;
+    
+    // logical block address
+    for (k = 7; k >= 0; --k) {
+        wsCmdBlk[2 + k] = (llba & 0xff);
+        llba >>= 8;
+    }
+    
+    // number of logical blocks
+    unum = optsp->numblocks;
+    wsCmdBlk[13] = (unum & 0xff);
+    
+    // Group number
+    wsCmdBlk[14] = (optsp->grpnum & 0x1f);
+
+    if (optsp->verbose > 1) {
+        fprintf(stderr, "    Compare and write cmd: ");
+        for (k = 0; k < cdb_len; ++k)
+            fprintf(stderr, "%02x ", wsCmdBlk[k]);
+        fprintf(stderr, "\n    Data-out buffer length=%d\n",
+                optsp->xfer_len);
+    }
+    if ((optsp->verbose > 3) && (optsp->xfer_len > 0)) {
+        fprintf(stderr, "    Data-out buffer contents:\n");
+        dStrHex((const char *)dataoutp, optsp->xfer_len, 1);
+    }
+    ptvp = construct_scsi_pt_obj();
+    if (NULL == ptvp) {
+        fprintf(sg_warnings_strm, "Compare_and_write: out of memory\n");
+        return -1;
+    }
+    set_scsi_pt_cdb(ptvp, wsCmdBlk, cdb_len);
+    set_scsi_pt_sense(ptvp, sense_b, sizeof(sense_b));
+    set_scsi_pt_data_out(ptvp, (unsigned char *)dataoutp, optsp->xfer_len);
+    res = do_scsi_pt(ptvp, sg_fd, optsp->timeout, optsp->verbose);
+    if (0) {
+        int ii;
+        fprintf(stderr, "Raw sense data:\n");
+        for (ii = 0; ii < SENSE_BUFF_LEN; ii++) {
+            fprintf(stderr, "%02X ", sense_b[ii]);
+            if ((ii % 16) == 15)
+                fprintf(stderr, "\n");
+        }
+    }
+    ret = sg_cmds_process_resp(ptvp, "Compare and write", res, 0, sense_b,
+                               1 /*noisy */, optsp->verbose, &sense_cat);
+    if (-1 == ret)
+        ;
+    else if (-2 == ret) {
+        switch (sense_cat) {
+        case SG_LIB_CAT_NOT_READY:
+        case SG_LIB_CAT_UNIT_ATTENTION:
+        case SG_LIB_CAT_INVALID_OP:
+        case SG_LIB_CAT_ILLEGAL_REQ:
+        case SG_LIB_CAT_ABORTED_COMMAND:
+            ret = sense_cat;
+            break;
+        case SG_LIB_CAT_RECOVERED:
+        case SG_LIB_CAT_NO_SENSE:
+            ret = 0;
+            break;
+        case SG_LIB_CAT_MEDIUM_HARD:
+            ret = sense_cat;
+            break;
+        default:
+            {
+                unsigned char sense_key;
+                int valid, slen;
+                uint64_t info_fld = 0;
+
+                sense_key = (sense_b[1] & 0xf);
+                if (sense_key != SPC_SK_MISCOMPARE)
+                    break;
+
+                slen = get_scsi_pt_sense_len(ptvp);
+                valid = sg_get_sense_info_fld(sense_b, slen, &info_fld);
+                if (valid)
+                    fprintf(stderr, "Miscompare at byte offset "
+                            "lba=%"PRIu64" [0x%"PRIx64"]\n", info_fld, info_fld);
+            }
+            ret = -1;
+            break;
+        }
+    } else
+        ret = 0;
+
+    destruct_scsi_pt_obj(ptvp);
+    return ret;
+}
+
+/*
+ * Returns 0 on success, SG_LIB_FILE_ERROR on error.
+ */
+int read_file_data(char* filename, unsigned char* buf, int nbytes)
+{
+    int got_stdin, fd, res;
+    char ebuff[EBUFF_SZ];
+    
+    got_stdin = (0 == strcmp(filename, "-")) ? 1 : 0;
+
+    if (got_stdin) {
+        fd = STDIN_FILENO;
+        if (sg_set_binary_mode(STDIN_FILENO) < 0)
+            perror("sg_set_binary_mode");
+    } else {
+        if ((fd = open(filename, O_RDONLY)) < 0) {
+            snprintf(ebuff, EBUFF_SZ,
+                     ME "could not open %s for reading", filename);
+            perror(ebuff);
+            return SG_LIB_FILE_ERROR;
+        } else if (sg_set_binary_mode(fd) < 0)
+            perror("sg_set_binary_mode");
+    }
+    res = read(fd, buf, nbytes);
+    if (res < 0) {
+        snprintf(ebuff, EBUFF_SZ, ME "couldn't read from %s",
+                 filename);
+        perror(ebuff);
+        if (! got_stdin)
+            close(fd);
+        return SG_LIB_FILE_ERROR;
+    }
+    if (res < nbytes) {
+        fprintf(stderr, "tried to read %d bytes from %s, got %d "
+                "bytes\n", nbytes, filename, res);
+        fprintf(stderr, "  so pad with 0x0 bytes and continue\n");
+    }
+    if (! got_stdin)
+        close(fd);
+
+    if (0) { /* enable to dump buffers to stderr */
+        int ii=0;
+        while(1) {
+            if (ii && (!(ii % 32))) fprintf(stderr, "\n");
+            if (ii >= nbytes) break;
+            fprintf(stderr, "%02x", buf[ii]);
+            ii++;
+        }
+    }
+
+    return 0;
+}
+
+
+int
+main(int argc, char * argv[])
+{
+    int sg_fd, res, c, prot_en, vb;
+    int num_given = 0;
+    int lba_given = 0;
+    int if_given = 0;
+    int got_stdin = 0;
+    int64_t ll;
+    uint32_t block_size;
+    const char * device_name = NULL;
+    unsigned char resp_buff[RCAP16_RESP_LEN];
+    unsigned char * wBuff = NULL;
+    int ret = -1;
+    struct opts_t opts;
+    struct stat a_stat;
+
+    memset(&opts, 0, sizeof(opts));
+    opts.numblocks = DEF_WS_NUMBLOCKS;
+    opts.timeout = DEF_TIMEOUT_SECS;
+    vb = 0;
+    while (1) {
+        int option_index = 0;
+
+        c = getopt_long(argc, argv, "ag:hi:l:Ln:PRSt:TUvVw:x:", long_options,
+                        &option_index);
+        if (c == -1)
+            break;
+
+        switch (c) {
+        case 'f':
+            ++opts.fua;
+            break;
+        case 'g':
+            opts.grpnum = sg_get_num(optarg);
+            if ((opts.grpnum < 0) || (opts.grpnum > 31))  {
+                fprintf(stderr, "bad argument to '--grpnum'\n");
+                return SG_LIB_SYNTAX_ERROR;
+            }
+            break;
+        case 'h':
+        case '?':
+            usage();
+            return 0;
+        case 'C':
+            strncpy(opts.ifilenamec, optarg, sizeof(opts.ifilenamec));
+            if_given = 1;
+            break;
+        case 'W':
+            strncpy(opts.ifilenamew, optarg, sizeof(opts.ifilenamew));
+            if_given = 1;
+            break;
+        case 'l':
+            ll = sg_get_llnum(optarg);
+            if (-1 == ll) {
+                fprintf(stderr, "bad argument to '--lba'\n");
+                return SG_LIB_SYNTAX_ERROR;
+            }
+            opts.lba = (uint64_t)ll;
+            lba_given = 1;
+            break;
+        case 'n':
+            opts.numblocks = sg_get_num(optarg);
+            if (opts.numblocks < 0)  {
+                fprintf(stderr, "bad argument to '--num'\n");
+                return SG_LIB_SYNTAX_ERROR;
+            }
+            num_given = 1;
+            break;
+        case 't':
+            opts.timeout = sg_get_num(optarg);
+            if (opts.timeout < 0)  {
+                fprintf(stderr, "bad argument to '--timeout'\n");
+                return SG_LIB_SYNTAX_ERROR;
+            }
+            break;
+        case 'v':
+            ++opts.verbose;
+            break;
+        case 'V':
+            fprintf(stderr, ME "version: %s\n", version_str);
+            return 0;
+        case 'w':
+            opts.wrprotect = sg_get_num(optarg);
+            if ((opts.wrprotect < 0) || (opts.wrprotect > 7))  {
+                fprintf(stderr, "bad argument to '--wrprotect'\n");
+                return SG_LIB_SYNTAX_ERROR;
+            }
+            break;
+        case 'x':
+            opts.xfer_len_override=1;
+            opts.xfer_len = sg_get_num(optarg);
+            if (opts.xfer_len < 0) {
+                fprintf(stderr, "bad argument to '--xferlen'\n");
+                return SG_LIB_SYNTAX_ERROR;
+            }
+            break;
+        default:
+            fprintf(stderr, "unrecognised option code 0x%x ??\n", c);
+            usage();
+            return SG_LIB_SYNTAX_ERROR;
+        }
+    }
+    if (optind < argc) {
+        if (NULL == device_name) {
+            device_name = argv[optind];
+            ++optind;
+        }
+        if (optind < argc) {
+            for (; optind < argc; ++optind)
+                fprintf(stderr, "Unexpected extra argument: %s\n",
+                        argv[optind]);
+            usage();
+            return SG_LIB_SYNTAX_ERROR;
+        }
+    }
+    if (NULL == device_name) {
+        fprintf(stderr, "missing device name!\n");
+        usage();
+        return SG_LIB_SYNTAX_ERROR;
+    }
+    vb = opts.verbose;
+
+    if ((! if_given) && (! lba_given) && (! num_given)) {
+        fprintf(stderr, "As a precaution require one of '--in=', '--lba=' "
+                "or '--num=' to be given\n");
+        return SG_LIB_SYNTAX_ERROR;
+    }
+
+    memset(&a_stat, 0, sizeof(a_stat));
+    if (opts.ifilenamec[0]) {
+        got_stdin = (0 == strcmp(opts.ifilenamec, "-")) ? 1 : 0;
+        if (! got_stdin) {
+            if (stat(opts.ifilenamec, &a_stat) < 0) {
+                if (vb)
+                    fprintf(stderr, "unable to stat(%s): %s\n",
+                            opts.ifilenamec, safe_strerror(errno));
+                return SG_LIB_FILE_ERROR;
+            }
+            if (!opts.xfer_len_override)
+                opts.xfer_len = (int)a_stat.st_size;
+        }
+    }
+    if (opts.ifilenamew[0]) {
+        got_stdin = (0 == strcmp(opts.ifilenamew, "-")) ? 1 : 0;
+        if (! got_stdin) {
+            if (stat(opts.ifilenamew, &a_stat) < 0) {
+                if (vb)
+                    fprintf(stderr, "unable to stat(%s): %s\n",
+                            opts.ifilenamew, safe_strerror(errno));
+                return SG_LIB_FILE_ERROR;
+            }
+            if (!opts.xfer_len_override) {
+                if (a_stat.st_size != opts.xfer_len) {
+                    fprintf(stderr, "compare and write buffers are different sizes\n");
+                    return SG_LIB_FILE_ERROR;
+                }
+                opts.xfer_len += (int)a_stat.st_size;
+            }
+        }
+    }
+    
+    sg_fd = sg_cmds_open_device(device_name, 0 /* rw */, vb);
+    if (sg_fd < 0) {
+        fprintf(stderr, ME "open error: %s: %s\n", device_name,
+                safe_strerror(-sg_fd));
+        return SG_LIB_FILE_ERROR;
+    }
+
+    prot_en = 0;
+    if (0 == opts.xfer_len) {
+        res = sg_ll_readcap_16(sg_fd, 0 /* pmi */, 0 /* llba */, resp_buff,
+                               RCAP16_RESP_LEN, 0, (vb ? (vb - 1): 0));
+        if (0 == res) {
+            block_size = ((resp_buff[8] << 24) |
+                          (resp_buff[9] << 16) |
+                          (resp_buff[10] << 8) |
+                          resp_buff[11]);
+            prot_en = !!(resp_buff[12] & 0x1);
+            opts.xfer_len = 2 * opts.numblocks * (block_size + (prot_en ? 8 : 0));
+        } else if ((SG_LIB_CAT_INVALID_OP == res) ||
+                   (SG_LIB_CAT_ILLEGAL_REQ == res)) {
+            if (vb)
+                fprintf(stderr, "Read capacity(16) not supported, try Read "
+                        "capacity(10)\n");
+            res = sg_ll_readcap_10(sg_fd, 0 /* pmi */, 0 /* lba */, resp_buff,
+                                   RCAP10_RESP_LEN, 0, (vb ? (vb - 1): 0));
+            if (0 == res) {
+                block_size = ((resp_buff[4] << 24) |
+                              (resp_buff[5] << 16) |
+                              (resp_buff[6] << 8) |
+                              resp_buff[7]);
+                opts.xfer_len = 2 * opts.numblocks * block_size;
+            }
+        } else if (vb)
+            fprintf(stderr, "Read capacity(16) failed. Unable to calculate "
+                    "block size\n");
+        if (res)
+            fprintf(stderr, "Read capacity(10) failed. Unable to calculate "
+                    "block size\n");
+    }
+    if (opts.xfer_len < 1) {
+        fprintf(stderr, "unable to deduce block size, please give "
+                "'--xferlen=' argument\n");
+        ret = SG_LIB_SYNTAX_ERROR;
+        goto err_out;
+    }
+    if (opts.xfer_len > MAX_XFER_LEN) {
+        fprintf(stderr, "'--xferlen=%d is out of range ( want <= %d)\n",
+                opts.xfer_len, MAX_XFER_LEN);
+        ret = SG_LIB_SYNTAX_ERROR;
+        goto err_out;
+    }
+    // note double-size buffer because we send compare data and write data
+    wBuff = (unsigned char*)calloc(2 * opts.xfer_len, 1);
+    if (NULL == wBuff) {
+        fprintf(stderr, "unable to allocate %d bytes of memory with "
+                "calloc()\n", opts.xfer_len);
+        ret = SG_LIB_SYNTAX_ERROR;
+        goto err_out;
+    }
+    if (opts.ifilenamec[0]) {
+        ret = read_file_data(opts.ifilenamec, wBuff, opts.xfer_len / 2);
+        if (ret)
+            goto err_out;
+    } else {
+        if (vb)
+            fprintf(stderr, "Default compare buffer set to %d zeros\n",
+                    opts.xfer_len / 2);
+        /* disabled for now until I sort out buffer offsets. */
+        /*if (prot_en) { // default for protection is 0xff, rest get 0x0
+            memset(wBuff + opts.xfer_len - 8, 0xff, 8);
+            if (vb)
+                fprintf(stderr, " ... apart from last 8 bytes which are set "
+                        "to 0xff\n");
+        }*/
+    }
+    if (opts.ifilenamew[0]) {
+        ret = read_file_data(opts.ifilenamew, wBuff + opts.xfer_len / 2, opts.xfer_len / 2);
+        if (ret)
+            goto err_out;
+    } else {
+        if (vb)
+            fprintf(stderr, "Default write buffer set to %d zeros\n",
+                    opts.xfer_len / 2);
+        /* disabled for now until I sort out buffer offsets. */
+        /*if (prot_en) { // default for protection is 0xff, rest get 0x0
+            memset(wBuff + opts.xfer_len - 8, 0xff, 8);
+            if (vb)
+                fprintf(stderr, " ... apart from last 8 bytes which are set "
+                        "to 0xff\n");
+        }*/
+    }
+
+    ret = do_compare_and_write(sg_fd, &opts, wBuff);
+    if (ret) {
+        switch (ret) {
+        case SG_LIB_CAT_NOT_READY:
+            fprintf(stderr, "Compare_and_write failed, device not ready\n");
+            break;
+        case SG_LIB_CAT_UNIT_ATTENTION:
+            fprintf(stderr, "Compare_and_write, unit attention\n");
+            break;
+        case SG_LIB_CAT_ABORTED_COMMAND:
+            fprintf(stderr, "Compare_and_write, aborted command\n");
+            break;
+        case SG_LIB_CAT_INVALID_OP:
+            fprintf(stderr, "Compare_and_write command not supported\n");
+            break;
+        case SG_LIB_CAT_ILLEGAL_REQ:
+            fprintf(stderr, "bad field in Compare_and_write cdb, option "
+                    "probably not supported\n");
+            break;
+        case SG_LIB_CAT_MEDIUM_HARD:
+            fprintf(stderr, "Compare_and_write command reported medium or "
+                    "hardware error\n");
+            break;
+        default:
+            fprintf(stderr, "Compare_and_write command failed\n");
+            break;
+        }
+    }
+
+err_out:
+    if (wBuff)
+        free(wBuff);
+    res = sg_cmds_close_device(sg_fd);
+    if (res < 0) {
+        fprintf(stderr, "close error: %s\n", safe_strerror(-res));
+        if (0 == ret)
+            return SG_LIB_FILE_ERROR;
+    }
+    return (ret >= 0) ? ret : SG_LIB_CAT_OTHER;
+}
Index: src/Makefile.in
===================================================================
--- src/Makefile.in	(revision 9997)
+++ src/Makefile.in	(working copy)
@@ -252,7 +252,8 @@
 @OS_FREEBSD_FALSE@@OS_LINUX_TRUE@	sg_write_buffer$(EXEEXT) \
 @OS_FREEBSD_FALSE@@OS_LINUX_TRUE@	sg_write_long$(EXEEXT) \
 @OS_FREEBSD_FALSE@@OS_LINUX_TRUE@	sg_write_same$(EXEEXT) \
-@OS_FREEBSD_FALSE@@OS_LINUX_TRUE@	sg_wr_mode$(EXEEXT)
+@OS_FREEBSD_FALSE@@OS_LINUX_TRUE@	sg_wr_mode$(EXEEXT) \
+@OS_FREEBSD_FALSE@@OS_LINUX_TRUE@	sg_compare_and_write$(EXEEXT)
 @OS_FREEBSD_TRUE@bin_PROGRAMS = sg_decode_sense$(EXEEXT) \
 @OS_FREEBSD_TRUE@	sg_format$(EXEEXT) sg_get_config$(EXEEXT) \
 @OS_FREEBSD_TRUE@	sg_get_lba_status$(EXEEXT) sg_ident$(EXEEXT) \
@@ -288,6 +289,9 @@
 CONFIG_CLEAN_VPATH_FILES =
 am__installdirs = "$(DESTDIR)$(bindir)"
 PROGRAMS = $(bin_PROGRAMS)
+am_sg_compare_and_write_OBJECTS = sg_compare_and_write.$(OBJEXT)
+sg_compare_and_write_OBJECTS = $(am_sg_compare_and_write_OBJECTS)
+sg_compare_and_write_DEPENDENCIES = ../lib/libsgutils2.la
 am_sg_dd_OBJECTS = sg_dd.$(OBJEXT)
 sg_dd_OBJECTS = $(am_sg_dd_OBJECTS)
 sg_dd_DEPENDENCIES = ../lib/libsgutils2.la
@@ -460,14 +464,15 @@
 LINK = $(LIBTOOL) --tag=CC $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) \
 	--mode=link $(CCLD) $(AM_CFLAGS) $(CFLAGS) $(AM_LDFLAGS) \
 	$(LDFLAGS) -o $@
-SOURCES = $(sg_dd_SOURCES) $(sg_decode_sense_SOURCES) \
-	$(sg_emc_trespass_SOURCES) $(sg_format_SOURCES) \
-	$(sg_get_config_SOURCES) $(sg_get_lba_status_SOURCES) \
-	$(sg_ident_SOURCES) $(sg_inq_SOURCES) $(sg_logs_SOURCES) \
-	$(sg_luns_SOURCES) $(sg_map_SOURCES) $(sg_map26_SOURCES) \
-	$(sg_modes_SOURCES) $(sg_opcodes_SOURCES) \
-	$(sg_persist_SOURCES) $(sg_prevent_SOURCES) $(sg_raw_SOURCES) \
-	$(sg_rbuf_SOURCES) $(sg_rdac_SOURCES) $(sg_read_SOURCES) \
+SOURCES = $(sg_compare_and_write_SOURCES) $(sg_dd_SOURCES) \
+	$(sg_decode_sense_SOURCES) $(sg_emc_trespass_SOURCES) \
+	$(sg_format_SOURCES) $(sg_get_config_SOURCES) \
+	$(sg_get_lba_status_SOURCES) $(sg_ident_SOURCES) \
+	$(sg_inq_SOURCES) $(sg_logs_SOURCES) $(sg_luns_SOURCES) \
+	$(sg_map_SOURCES) $(sg_map26_SOURCES) $(sg_modes_SOURCES) \
+	$(sg_opcodes_SOURCES) $(sg_persist_SOURCES) \
+	$(sg_prevent_SOURCES) $(sg_raw_SOURCES) $(sg_rbuf_SOURCES) \
+	$(sg_rdac_SOURCES) $(sg_read_SOURCES) \
 	$(sg_read_block_limits_SOURCES) $(sg_read_buffer_SOURCES) \
 	$(sg_read_long_SOURCES) $(sg_readcap_SOURCES) \
 	$(sg_reassign_SOURCES) $(sg_referrals_SOURCES) \
@@ -482,14 +487,15 @@
 	$(sg_write_buffer_SOURCES) $(sg_write_long_SOURCES) \
 	$(sg_write_same_SOURCES) $(sginfo_SOURCES) $(sgm_dd_SOURCES) \
 	$(sgp_dd_SOURCES)
-DIST_SOURCES = $(sg_dd_SOURCES) $(sg_decode_sense_SOURCES) \
-	$(sg_emc_trespass_SOURCES) $(sg_format_SOURCES) \
-	$(sg_get_config_SOURCES) $(sg_get_lba_status_SOURCES) \
-	$(sg_ident_SOURCES) $(sg_inq_SOURCES) $(sg_logs_SOURCES) \
-	$(sg_luns_SOURCES) $(sg_map_SOURCES) $(sg_map26_SOURCES) \
-	$(sg_modes_SOURCES) $(sg_opcodes_SOURCES) \
-	$(sg_persist_SOURCES) $(sg_prevent_SOURCES) $(sg_raw_SOURCES) \
-	$(sg_rbuf_SOURCES) $(sg_rdac_SOURCES) $(sg_read_SOURCES) \
+DIST_SOURCES = $(sg_compare_and_write_SOURCES) $(sg_dd_SOURCES) \
+	$(sg_decode_sense_SOURCES) $(sg_emc_trespass_SOURCES) \
+	$(sg_format_SOURCES) $(sg_get_config_SOURCES) \
+	$(sg_get_lba_status_SOURCES) $(sg_ident_SOURCES) \
+	$(sg_inq_SOURCES) $(sg_logs_SOURCES) $(sg_luns_SOURCES) \
+	$(sg_map_SOURCES) $(sg_map26_SOURCES) $(sg_modes_SOURCES) \
+	$(sg_opcodes_SOURCES) $(sg_persist_SOURCES) \
+	$(sg_prevent_SOURCES) $(sg_raw_SOURCES) $(sg_rbuf_SOURCES) \
+	$(sg_rdac_SOURCES) $(sg_read_SOURCES) \
 	$(sg_read_block_limits_SOURCES) $(sg_read_buffer_SOURCES) \
 	$(sg_read_long_SOURCES) $(sg_readcap_SOURCES) \
 	$(sg_reassign_SOURCES) $(sg_referrals_SOURCES) \
@@ -727,6 +733,8 @@
 sg_write_long_LDADD = ../lib/libsgutils2.la @os_libs@
 sg_write_same_SOURCES = sg_write_same.c
 sg_write_same_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_compare_and_write_SOURCES = sg_compare_and_write.c
+sg_compare_and_write_LDADD = ../lib/libsgutils2.la @os_libs@
 sg_wr_mode_SOURCES = sg_wr_mode.c
 sg_wr_mode_LDADD = ../lib/libsgutils2.la @os_libs@
 all: all-am
@@ -806,6 +814,9 @@
 	list=`for p in $$list; do echo "$$p"; done | sed 's/$(EXEEXT)$$//'`; \
 	echo " rm -f" $$list; \
 	rm -f $$list
+sg_compare_and_write$(EXEEXT): $(sg_compare_and_write_OBJECTS) $(sg_compare_and_write_DEPENDENCIES) 
+	@rm -f sg_compare_and_write$(EXEEXT)
+	$(LINK) $(sg_compare_and_write_OBJECTS) $(sg_compare_and_write_LDADD) $(LIBS)
 sg_dd$(EXEEXT): $(sg_dd_OBJECTS) $(sg_dd_DEPENDENCIES) 
 	@rm -f sg_dd$(EXEEXT)
 	$(LINK) $(sg_dd_OBJECTS) $(sg_dd_LDADD) $(LIBS)
@@ -972,6 +983,7 @@
 distclean-compile:
 	-rm -f *.tab.c
 
+@AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/sg_compare_and_write.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/sg_dd.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/sg_decode_sense.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/sg_emc_trespass.Po@am__quote@
Index: src/sg_luns.c
===================================================================
--- src/sg_luns.c	(revision 9997)
+++ src/sg_luns.c	(working copy)
@@ -28,7 +28,7 @@
 
 static char * version_str = "1.15 20100312";
 
-#define MAX_RLUNS_BUFF_LEN (1024 * 64)
+#define MAX_RLUNS_BUFF_LEN ( 1LL << 32 )
 #define DEF_RLUNS_BUFF_LEN (1024 * 8)
 
 static unsigned char reportLunsBuff[MAX_RLUNS_BUFF_LEN];
Index: src/Makefile.am
===================================================================
--- src/Makefile.am	(revision 9997)
+++ src/Makefile.am	(working copy)
@@ -17,7 +17,7 @@
 	sg_sat_identify sg_sat_phy_event sg_sat_set_features sg_scan \
 	sg_senddiag sg_ses sg_start sg_stpg sg_sync sg_test_rwbuf sg_turs \
 	sg_unmap sg_verify sg_vpd sg_write_buffer sg_write_long \
-	sg_write_same sg_wr_mode
+	sg_write_same sg_wr_mode sg_compare_and_write
 
 distclean-local:
 	rm -f sg_scan.c
@@ -274,6 +274,9 @@
 sg_write_same_SOURCES = sg_write_same.c
 sg_write_same_LDADD = ../lib/libsgutils2.la @os_libs@
 
+sg_compare_and_write_SOURCES = sg_compare_and_write.c
+sg_compare_and_write_LDADD = ../lib/libsgutils2.la @os_libs@
+
 sg_wr_mode_SOURCES = sg_wr_mode.c
 sg_wr_mode_LDADD = ../lib/libsgutils2.la @os_libs@
 
Index: lib/sg_cmds_basic.c
===================================================================
--- lib/sg_cmds_basic.c	(revision 9997)
+++ lib/sg_cmds_basic.c	(working copy)
@@ -173,6 +173,12 @@
             fprintf(sg_warnings_strm, "%s: scsi status: %s\n", leadin, b);
         }
         return -1;
+    case SCSI_PT_RESULT_TRANSPORT_ERR:
+        if (verbose || noisy) {
+            get_scsi_pt_transport_err_str(ptvp, sizeof(b), b);
+            fprintf(sg_warnings_strm, "%s: transport: %s\n", leadin, b);
+        }
+        /* Note fall-through to pick up sense data */
     case SCSI_PT_RESULT_SENSE:
         scat = sg_err_category_sense(sbp, slen);
         switch (scat) {
@@ -205,12 +211,6 @@
         if (o_sense_cat)
             *o_sense_cat = scat;
         return -2;
-    case SCSI_PT_RESULT_TRANSPORT_ERR:
-        if (verbose || noisy) {
-            get_scsi_pt_transport_err_str(ptvp, sizeof(b), b);
-            fprintf(sg_warnings_strm, "%s: transport: %s\n", leadin, b);
-        }
-        return -1;
     case SCSI_PT_RESULT_OS_ERR:
         if (verbose || noisy) {
             get_scsi_pt_os_err_str(ptvp, sizeof(b), b);
Index: lib/sg_pt_linux.c
===================================================================
--- lib/sg_pt_linux.c	(revision 9997)
+++ lib/sg_pt_linux.c	(working copy)
@@ -33,7 +33,8 @@
     "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT",
     "DID_BAD_TARGET", "DID_ABORT", "DID_PARITY", "DID_ERROR",
     "DID_RESET", "DID_BAD_INTR", "DID_PASSTHROUGH", "DID_SOFT_ERROR",
-    "DID_IMM_RETRY", "DID_REQUEUE"
+    "DID_IMM_RETRY", "DID_REQUEUE", "DID_TRANSPORT_DISRUPTED",
+    "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE", "DID_NEXUS_FAILURE"
 };
 
 #define LINUX_HOST_BYTES_SZ \
