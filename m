From: Pat LaVarre <p.lavarre@ieee.org>
Subject: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 06 Nov 2003 17:38:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068165515.28505.29.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:27333 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261262AbTKGAjF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 19:39:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: linux-scsi@vger.kernel.org

Patrick M:

Hi!

> http://marc.theaimsgroup.com/?l=linux-scsi&m=106762441112762
> List:     linux-scsi
> Subject:  Re: [PATCH/RFT] mode sense madness always use page 8
> From:     Patrick Mansfield <patmans () us ! ibm ! com>
> Date:     2003-10-31 18:16:46
> ...
> > sudo ./plscsi /dev/sg1 -v -i x1C -x "5A 00 08:00:00:00 00 00:1C 00"
> > sudo ./plscsi /dev/sg1 -v -i 4   -x "5A 00 3F:00:00:00 00 00:04 00"
> > sudo ./plscsi /dev/sg1 -v -i 4   -x "5A 00 00:00:00:00 00 00:04 00"
> > sudo ./plscsi /dev/sg1 -v -i xFF -x "5A 00 3F:00:00:00 00 00:FF 00"
>
> Nice ...
>
> > Also personally I find the source for that
> > plscsi app impenetrably awful to read.
>
> Maybe you can rewrite it in c and get it into
> sg_utils.

I notice the equivalent C is smaller than any one edition of my plain
text inline cdrom.ko CDC_MMC_WR patches.  So now this email ends with a
copy of what I have working so far.

$ mkdir gccscsi
$ cd gccscsi
$ wget ...
...
$ patch -p1 <...
patching file inq.c
patching file spinq.c
patching file Makefile
patching file gccscsi.h
patching file lscsi.c
$
$ make
gcc -Wall -o spinq spinq.c lscsi.c
$
$ sudo ./spinq /dev/cdrom
LITE-ON COMBO LTC-48161HKH0K
$
$ sudo ./spinq /dev/scd0
IOMEGA  DVDRW4216INP-A  1.A0
$
$ gcc -c -Wall inq.c
$ # no worries

I'm trying to get to where we can easily write the many fun variations
on the concise inq.c rather than the verbose spinq.c that reads like an
SG_IO example from the web ... except without losing the freedom to
misalign stuff.

Mostly I'm now stuck wrestling with how to ask concisely to misalign the
struct sg_io_hdr_t, the cdb, the data, and/or the sense.  I've coded a
few schemes that work, none yet concise.  I want to be able to say
things like try the sg_io_hdr_t at N * x1000 - 1, then the cdb at +
x200, then the sense at + x206, then the data at + x21F.  We could solve
this differently for scripts like inq.c and spinq.c that we interpret
entirely by gcc: for those to arrange mis/alignment we could declare a
__packed struct.  But when interpreting a command line we don't have
that luxury unless we resort to printing the command line into a .c file
and then calling gcc.

I'm also not delighted to expose all the members of the struct sp in the
header, but as yet that's how I export its sizeof for the caller to
allocate.

Pat LaVarre

diff -Nur plscsi/inq.c gccscsi/inq.c
--- plscsi/inq.c	1969-12-31 17:00:00.000000000 -0700
+++ gccscsi/inq.c	2003-11-06 17:18:17.672894912 -0700
@@ -0,0 +1,13 @@
+#include "gccscsi.h"
+int main(int argc, char * argv[])
+{
+	--argc; ++argv;
+	while (0 < argc--) {
+		char const * dev = *argv++;
+		ALSO(dev);
+	}
+	I(0x24); Y("12 00:00:00 24 00");
+	DATA[8 + 0x10 + 8 + 4] = '\0';
+	printf("%s\n", &DATA[8]);
+	return 0;
+}
diff -Nur plscsi/spinq.c gccscsi/spinq.c
--- plscsi/spinq.c	1969-12-31 17:00:00.000000000 -0700
+++ gccscsi/spinq.c	2003-11-06 17:18:28.843196768 -0700
@@ -0,0 +1,35 @@
+#include "gccscsi.h"
+int main(int argc, char * argv[])
+{
+	int i = -1;
+
+	struct sp * sp = (struct sp *) calloc(1, sizeof *sp);
+	int max = 0x24;
+	char * data = (char *) calloc(1, max);
+
+	assert(sp != NULL);
+	assert(data != NULL);
+	assert((char *) sp < data);
+
+	--argc; ++argv;
+	assert(0 < argc);
+
+	if (sp_open(sp, argv[0]) < 0) {
+		sp_perror("sp_open");
+	} else {
+		sp_cdb(sp, "\x12\x00\x00\x00\x24\x00", 6);
+		i = sp_read(sp, &data[0], max);
+		if (i != 0) {
+			if (i == SP_THRU) {
+				sp_perror("sp_read");
+			} else {
+				fprintf(stderr, "sp_read: x%X\n", i);
+			}
+		} else {
+			data[8 + 0x10 + 8 + 4] = '\0';
+			printf("%s\n", &data[8]);
+		}
+	}
+
+	return i;
+}
diff -Nur plscsi/Makefile gccscsi/Makefile
--- plscsi/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ gccscsi/Makefile	2003-11-06 17:15:14.615723832 -0700
@@ -0,0 +1,5 @@
+spinq: gccscsi.h spinq.c lscsi.c
+	gcc -Wall -o spinq spinq.c lscsi.c
+
+inq: gccscsi.h inq.c gccscsi.c lscsi.c
+	gcc -Wall -o inq inq.c gccscsi.c lscsi.c
diff -Nur plscsi/gccscsi.h gccscsi/gccscsi.h
--- plscsi/gccscsi.h	1969-12-31 17:00:00.000000000 -0700
+++ gccscsi/gccscsi.h	2003-11-05 15:07:46.000000000 -0700
@@ -0,0 +1,187 @@
+/* gccscsi.h
+ *
+ * Speak SCSI concisely wherever.
+ */
+
+/* Link with standard C libraries. */
+
+#include <assert.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+/* Link with local C libraries. */
+
+#ifndef _WIN32
+#define sp_perror perror
+#include <endian.h>
+#include <scsi/sg.h>
+#else
+#include <windows.h>
+#include <ddk/ntddscsi.h>
+#endif
+
+/* Link with C++ clients. */
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* Work with kebi-, mebi-, and gibi- bytes. */
+
+#define Ki (1 << 10) /* (1 << 10) = 1024 */
+#define Mi (Ki * Ki)
+#define Gi (Ki * Ki * Ki)
+
+/* Work with the bytes of integers. */
+
+#if __BYTE_ORDER == __BIG_ENDIAN /* if byte 0 = most significant */
+#define BIG(I, N) (((unsigned char *)&(I))[N])
+#define LIL(I, N) BIG(I, sizeof (I) - (N))
+#else /* else if byte 0 = least significant */
+#define LIL(I, N) (((unsigned char *)&(I))[N])
+#define BIG(I, N) LIL(I, sizeof (I) - (N))
+#endif
+
+/* Into a 32-bit exit int, compress zero else positive residue else: */
+
+#define SP_THRU		0x80000000 /* negative if trouble */
+#define SP_DATA_THRU	0x40000000 /* data not counted */
+#define SP_SENSE_THRU	0x20000000 /* sense not counted */
+//..... SP_LATE_THRU    0x10000000 /* timeout */
+
+#define SP_COMPARE	0x02000000 /* copied wrong data */
+#define SP_RESIDUE	0x01000000 /* copied too much or too little data */
+
+#define SP_SENSE	0x00800000 /* credible sense copied in */
+#define SP_DEFERRED	0x00400000 /* success wrongly predicted before now */
+#define SP_SK		0x000F0000 /* sk = sense key */
+#define SP_ASC		0x0000FF00 /* asc = additional sense code */
+#define SP_ASCQ		0x000000FF /* ascq = asc qualifier */
+
+#define SP_SK_ASC	0x000FFF00 /* sk plus asc */ 
+#define SP_SK_ASC_ASCQ	0x000FFFFF /* sk plus asc plus ascq */
+
+/* Link with lscsi.c or substitute. */
+
+#ifndef _WIN32
+struct sp
+{
+	sg_io_hdr_t	sih;
+	int		sense_align_hint;
+	char		sense[0xFF];
+	int		fd;
+};
+#else
+struct sp
+{
+	SCSI_PASS_THROUGH spt;
+	UCHAR		cdb_tail[0xFF]; /* 16 unnecessary bytes */
+	int		sense_align_hint;
+	UCHAR		sense[0xFF];
+	HANDLE		h;
+};
+#endif
+
+extern int sp_open(struct sp * sp, char const * name);
+extern void sp_align(struct sp * sp, int page, int offset);
+extern void sp_close(struct sp * sp);
+
+extern void sp_zero(struct sp * sp);
+extern char * sp_cdb(struct sp * sp, char * cdb, int max);
+extern char * sp_data(struct sp * sp, char * chars, int max);
+extern char * sp_sense(struct sp * sp, char * sense, int max);
+extern int sp_late(struct sp * sp, int s, int ns);
+
+extern int sp_say(struct sp * sp);
+extern int sp_read(struct sp * sp, char * to, int max);
+extern int sp_write(struct sp * sp, char const * from, int max);
+extern int sp_data_enough(struct sp * sp);
+extern int sp_sense_enough(struct sp * sp);
+
+extern void sp_perror(char const * st);
+
+/* Link with gccscsi.c */
+
+struct gcs;
+
+extern char * gcs_header(struct gcs * gcs);
+extern char * gcs_cdb(struct gcs * gcs);
+extern int gcs_cdb_enough(struct gcs * gcs);
+extern char * gcs_data(struct gcs * gcs);
+extern int gcs_allotted(struct gcs * gcs);
+extern int gcs_enough(struct gcs * gcs);
+extern char * gcs_sense(struct gcs * gcs);
+extern int gcs_sense_enough(struct gcs * gcs);
+extern void gcs_cdb_out(struct gcs * gcs, int max, int page, int offset);
+extern void gcs_sense_in(struct gcs * gcs, int max, int page, int offset);
+extern void gcs_in(struct gcs * gcs, int max, int page, int offset);
+extern void gcs_out(struct gcs * gcs, int max, int page, int offset);
+extern void gcs_beyond(struct gcs * gcs, int beyond);
+extern void gcs_quiet(struct gcs * gcs);
+extern void gcs_verbose(struct gcs * gcs);
+extern void gcs_late(struct gcs * gcs, int s, int ns);
+extern void gcs_cdb_with(struct gcs * gcs, char const * st);
+extern void gcs_with(struct gcs * gcs, char const * st);
+extern int gcs_yes_no(struct gcs * gcs);
+extern void gcs_yes(struct gcs * gcs, char const * cdb);
+extern void gcs_no(struct gcs * gcs, char const * cdb);
+extern void gcs_also(struct gcs * gcs, char const * name);
+extern void gcs_each(struct gcs * gcs);
+extern void gcs_exit(struct gcs * gcs, char const * file, int line);
+extern struct gcs * gcs(void);;
+
+/* Speak SCSI concisely from a single thread. */
+
+#define ALSO(N) gcs_also(gcs(), (N))
+#define EXIT() gcs_exit(gcs(), __FILE__, __LINE__)
+#define YN(ST) gcs_yes_no(gcs(), (ST))
+
+#undef  A
+#define B(B) gcs_beyond(gcs(), (B))
+#undef  C /* gcs --compare */
+#undef  D
+#define E() gcs_each(gcs())
+#undef  F /* gcs --from */
+#undef  G
+#undef  H /* gcs --help */
+#define I(I) gcs_in(gcs(), (I), 4096, 0)
+#undef  J
+#undef  K
+#define L(S, NS) gcs_late(gcs(), (S), (NS))
+#undef  M
+#define N(ST) gcs_no(gcs(), (ST))
+#define O(O) gcs_out(gcs(), (O), 4096, 0)
+#undef  P /* gcs --please */
+#define Q() gcs_quiet(gcs())
+#undef  R /* gcs --repeat */
+#define S(S) gcs_sense_in(gcs(), (S), 4, 0)
+#undef  T /* gcs --to */
+#undef  U
+#define V() gcs_verbose(gcs())
+#define W(ST) gcs_with(gcs(), (ST))
+#define Y(ST) gcs_yes(gcs(), (ST))
+#undef  Z
+
+#define CDB (gcs_cdb(gcs()))
+#define CDB_ENOUGH (gcs_cdb_enough(gcs()))
+
+#define DATA (gcs_data(gcs()))
+#define ALLOTTED (gcs_allotted(gcs()))
+#define ENOUGH (gcs_enough(gcs()))
+
+#define SENSE (gcs_sense(gcs()))
+#define SENSE_ENOUGH (gcs_sense_enough(gcs()))
+
+/* Trace execution without a debugger. */
+
+#define T() fprintf(stderr, "file %s line %d\n", __FILE__, __LINE__)
+
+/* Yes link with C++ clients. */
+
+#ifdef __cplusplus
+}
+#endif
+
+/* end of file */
diff -Nur plscsi/lscsi.c gccscsi/lscsi.c
--- plscsi/lscsi.c	1969-12-31 17:00:00.000000000 -0700
+++ gccscsi/lscsi.c	2003-11-05 15:59:42.000000000 -0700
@@ -0,0 +1,316 @@
+/* lscsi.c
+ *
+ * Interpret the arbitrary sp_ SCSI pass thru of "gccscsi.h"
+ * via SG_IO since <scsi/sg.h> version 3 i.e. since Linux kernel 2.4.
+ *
+ * Bugs include:
+ *
+ *	Suppose auto sense occurred if ioctl SG_IO returns nonnegative.
+ *	Do not distinguish ioctl failed from auto sense unintelligible.
+ *	Pass thru the data per cdb limit of one contiguous virtual allocation.
+ *	Pass thru the xFF limits on CDB length and sense length.
+ *	Trust caller to avoid null pointers and negative lengths.
+ *
+ * Simplifications include:
+ *
+ *	Require caller to mis/align struct, cdb, sense, and data.
+ *	Never pass thru -1 SG_DXFER_NONE with nonnull dxferp.
+ *	Never pass thru -4 SG_DXFER_TO_FROM_DEV.
+ *	Never pass thru -5 SG_DXFER_UNKNOWN.
+ *
+ * See also: http://lxr.linux.no/source/Documentation/CodingStyle
+ */
+
+/* Link with standard C libraries. */
+
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+/* Link with local C libraries. */
+
+#include <fcntl.h>
+#include <scsi/sg.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+/* Link with ../gccscsi/. */
+
+#include "gccscsi.h"
+
+#define USUAL_SENSE 0x12 /* x12 Win XP/2K, x0E Win ME/9X */
+#define USUAL_SECONDS (28 * 60 * 60) /* 28 hours = more than a day */
+
+/* Exit after printing why. */
+
+static void exits(char const * st, char const * file, int line)
+{
+	if (*st != '\0') {
+		fprintf(stderr, "%s: ", st);
+	}
+	fprintf(stderr, "file %s line %d\n", file, line);
+	exit(-line);
+}
+
+/* Exit after printing errno. */
+
+static void exite(char const * st, char const * file, int line)
+{
+	int en = errno;
+	perror(st);
+	fprintf(stderr, "errno %d at file %s line %d\n", en, file, line);
+	exit(-line);
+}
+
+/* Disconnect. */
+
+void sp_close(struct sp * sp)
+{
+	int i = close(sp->fd);
+	if (i != 0) exite("close", __FILE__, __LINE__);
+	sp->fd = -1;
+}
+
+/* Begin a new command, but stay connected. */
+
+void sp_zero(struct sp * sp)
+{
+	sg_io_hdr_t * sih = &sp->sih;
+	memset(sih, '\0', sizeof *sih);
+	sih->interface_id = 'S';
+	sih->dxfer_direction = SG_DXFER_NONE; /* often -1 */
+	sp_sense(sp, &sp->sense[0], USUAL_SENSE);
+	sp_late(sp, USUAL_SECONDS, 0);
+}
+
+/* Connect and return nonnegative, else decide errno. */
+
+int sp_open(struct sp * sp, char const * name)
+{
+	int mode = (O_RDONLY | O_NONBLOCK);
+	int fd = open(name, mode);
+	sp_zero(sp);
+	sp->fd = fd;
+	if (0 <= fd) {
+		int version = 0;
+		int i = ioctl(fd, SG_GET_VERSION_NUM, &version);
+		if (0 <= i) {
+			if (30000 <= version) {
+//				fprintf(stderr, "%d\n", fd);
+				return fd;
+			}
+		}
+		sp_close(sp);
+		errno = EINVAL;
+	}
+	return -1;
+}
+
+/* Hint from where and how much CDB to copy out, return where. */
+
+char * sp_cdb(struct sp * sp, char * cdb, int max)
+{
+	sg_io_hdr_t * sih = &sp->sih;
+	unsigned char uch = ((unsigned char) max);
+	if (uch != max) exits("large", __FILE__, __LINE__);
+	sih->cmd_len = uch;
+	sih->cmdp = cdb;
+	return sih->cmdp;
+}
+
+/* Hint where and how much data to copy in or out, return where. */
+
+char * sp_data(struct sp * sp, char * data, int max)
+{
+	sg_io_hdr_t * sih = &sp->sih;
+	sih->dxfer_len = max;
+	sih->dxferp = data;
+	return sih->dxferp;
+}
+
+/* Hint to where and how much sense to copy in, return where. */
+
+char * sp_sense(struct sp * sp, char * sense, int max)
+{
+	sg_io_hdr_t * sih = &sp->sih;
+	unsigned char uch = ((unsigned char) max);
+	if (uch != max) exits("large", __FILE__, __LINE__);
+	sih->mx_sb_len = uch;
+	sih->sbp = sense;
+	return sih->sbp;
+}
+
+/* Hint when to time out and reset, return ns. */
+
+int sp_late(struct sp * sp, int s, int ns)
+{
+	sg_io_hdr_t * sih = &sp->sih;
+	int ms = ((s * 1000) + ((ns + 999999) / 1000 / 1000));
+	if ((ms / 1000) != s) exits("large", __FILE__, __LINE__);
+	sih->timeout = ms;
+	return ((sih->timeout % 1000) * 1000 * 1000);
+}
+
+/* Zero all but the least significant set bit of a mask. */
+
+static int lsb(int mask)
+{
+	return (mask & -mask);
+}
+
+/* Construct an sp_read/ sp_write exit int from bits of auto sense. */
+
+static int int_from_sense(char const * chars, int length)
+{
+	int exit_int = SP_THRU; /* unintelligible sense */
+
+	/* Require minimal sense. */
+
+	if (2 < length) {
+		int sk = (chars[2] & 0x0F);
+		int response_code = (chars[0] & 0x7F);
+		if ((response_code == 0x70) || (response_code == 0x71)) {
+			exit_int |= SP_SENSE; /* intelligible sense */
+
+			/* Distinguish x70 Current vs. other sense. */
+
+			if (response_code != 0x70) {
+				exit_int |= SP_DEFERRED;
+			}
+
+			/* Pass back SK. */
+
+			exit_int |= (sk * lsb(SP_SK));
+
+			/* Interpret additional length, not quite like t10. */
+
+			if (7 < length) {
+				int al = (chars[7] & 0xFF);
+				if (al != 0x00) {
+					int max = (7 + 1 + al);
+					if (max < length) {
+						length = max;
+					}
+				}
+			}
+
+			/* Pass back ASC and ASCQ. */
+
+			if (0xC < length) {
+				int asc = (chars[0xC] & 0xFF);
+				exit_int |= (asc * lsb(SP_ASC));
+			}
+			if (0xD < length) {
+				int ascq = (chars[0xD] & 0xFF);
+				exit_int |= (ascq * lsb(SP_ASCQ));
+			}
+		}
+	}
+	return exit_int;
+}
+
+/* Pass thru.  Return zero else positive residue else negative trouble. */
+
+int sp_say(struct sp * sp)
+{
+	int fd = sp->fd;
+	sg_io_hdr_t * sih = &sp->sih;
+	int max = sih->dxfer_len;
+	char const * sense_chars = sih->sbp;
+	int sense_max = sih->mx_sb_len;
+	int i;
+	int residue;
+	int sense_enough;
+	int exit_int;
+
+	/* Trust caller to have decided much. */
+
+	; /* sih->interface_id */
+	; /* sih->cmdp sih->cmd_len sih->sbp sih->mx_sb_len sih->timeout */
+	; /* sih->dxfer_direction sih->dxferp sih->dxfer_len */
+
+	/* Trust caller to have zeroed much. */
+
+	; /* sih->iovec_count sih->flags sih->pack_id sih->usr_ptr */
+	; /* sih->status sih->masked_status sih->msg_status */
+	; /* sih->sb_len_wr sih->host_status sih->drive_status */
+	; /* sih->resid sih->duration sih->info */
+
+	/* Trace. */
+
+#if 0
+	fprintf(stderr, "%d '%c' %d %dms\n",
+		fd, sih->interface_id, sih->dxfer_direction, sih->timeout);
+	fprintf(stderr, "x %X %X %X\n",
+		sih->cmd_len, sih->mx_sb_len, sih->dxfer_len);
+#endif
+
+	/* Speak. */
+
+	i = ioctl(fd, SG_IO, sih);
+	residue = sih->resid;
+	sense_enough = sih->sb_len_wr;
+
+	/* Compress much into the exit int. */
+
+	exit_int = residue; /* zero if ok else positive residue */
+
+	if (i < 0) {
+		exit_int = SP_THRU; /* ioctl failed */
+	} else if ((residue < 0) || (max < residue)) {
+		exit_int = SP_THRU;
+		exit_int |= SP_DATA_THRU; /* data not counted */
+	} else if ((sih->info & SG_INFO_OK_MASK) != SG_INFO_OK) {
+		if ((sense_enough < 0) || (sense_max < sense_enough)) {
+			exit_int = SP_THRU;
+			exit_int |= SP_SENSE_THRU; /* sense not counted */
+		} else {
+			exit_int = SP_THRU;
+			exit_int |= int_from_sense(sense_chars, sense_enough);
+			if (0 != residue) {
+				exit_int |= SP_RESIDUE;
+			}
+		}
+	}
+
+	return exit_int;
+}
+
+/* Pass thru and copy zero or more bytes of data in. */
+
+int sp_read(struct sp * sp, char * to, int max)
+{
+	sg_io_hdr_t * sih = &sp->sih;
+	sp_data(sp, to, max);
+	sih->dxfer_direction = SG_DXFER_FROM_DEV; /* often -3 */
+	return sp_say(sp);
+}
+
+/* Pass thru and copy zero or more bytes of data out. */
+
+int sp_write(struct sp * sp, char const * from, int max)
+{
+	sg_io_hdr_t * sih = &sp->sih;
+	sp_data(sp, (char *) from, max);
+	sih->dxfer_direction = SG_DXFER_TO_DEV; /* often -2 */
+	return sp_say(sp);
+}
+
+/* Get the last length of data copied in. */
+
+int sp_data_enough(struct sp * sp)
+{
+	sg_io_hdr_t * sih = &sp->sih;
+	return (sih->dxfer_len - sih->resid);
+}
+
+/* Get the last length of sense copied in. */
+
+int sp_sense_enough(struct sp * sp)
+{
+	sg_io_hdr_t * sih = &sp->sih;
+	return sih->sb_len_wr;
+}
+
+/* end of file */


