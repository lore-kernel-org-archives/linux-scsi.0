From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 07 Nov 2003 11:27:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068229639.3417.46.camel@patrh9>
References: <1068165515.28505.29.camel@patrh9>
	 <20031107095145.A3785@beaverton.ibm.com>  <1068228695.3417.34.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:25328 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264544AbTKGS1t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 13:27:49 -0500
In-Reply-To: <1068228695.3417.34.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

> > The command line plscsi could support both long and short names (-i or
> > --gcs-in).
> 
> Ouch, sorry, yes I left that part of the patch out, I find I have to
> sneaker net it here, please stay tuned.

As follows.  --yes, --in, --out, etc., very much like plscsi --help
says.  Perhaps the key fragment is the zero or one arg per option usage
and default values description:

"-b --beyond $length     // else 0\n"
"-c --compare\n"
"-e --each\n"
"-f --from $fn           // else stdin\n"
"-h --help\n"
"-i --in $length         // else 0.4096.0 = 0 aligned at 4 KiB\n"
"-l --late $seconds      // else 100800.000 = 28 hours\n"
"-n --no $hex\n"
"-o --out $length        // else 0.4096.0 = 0 aligned at 4 KiB\n"
"-p --please             // else audit cdb length, etc.\n"
"-q --quiet\n"
"-r --repeat $count      // else 1\n"
"-s --sense $length      // else 18.4.0 = x12 aligned at 4 bytes\n"
"-t --to $fn             // else stdout\n"
"-v --verbose\n"
"-w --with $hex          // else -w \"AE\"\n"
"-y --yes $hex           // else -i x24 -y \"12 00:00:00 24 00\"\n"
"\n" ...
"gsc $dev -v -i 0x24 -y \"12 00:00:00 24 00\" // Inquiry\n"
"gsc $dev -v -i 8 -y \"25 00 00:00:00:00 00 00:00 00\" // Read Max LBA\n"
"gsc $dev -v -y \"00 00:00:00 00 00\" // Test Unit Ready\n"
"gsc $dev -v -y \"1B 00:00:00 00 00\" // Stop Unit\n"
"gsc $dev -v -y \"1B 00:00:00 01 00\" // Start Unit\n"
"gsc $dev -v -y \"1B 00:00:00 02 00\" // Stop Then Eject\n"

Again I say I'm not happy with the treatment of misalignment.

Diff'ed against this version, striving to keep the gccscsi.c small, I
find maybe now I'm learning towards a deeply arcane multi-arg option
such as:

--align 0x1000 -1 0x234 0x345 0x456

By that I mean, with respect to what kind of interesting alignment
boundary (x1000), say where to position the sg_io_hdr_t (-1), the cdb
(0x234), the sense (x345), and the data (x456).

> > Do you have a tar ball ...
>
> Yes release early release often.

Tar ball to list is forbidden, no?  So I launched this thread with a
normal small patch, but then in this post I have included a version of
the command line parser as plain text inline.

Pat LaVarre

--- gsc.c

/* gsc.c
 *
 * Interpret a command line in terms of "gccscsi.h".
 */

/* Link with local C libraries. */

#include "gccscsi.h"
#include "version.h"

/* Step thru implicit and command line args. */

static char const * const * args;

/* Remember some command line args. */

static int interpret_dash = 1;

static int interpret_compare = 0;
static int interpret_please = 0;
static int interpret_repeat = 1;
static int interpret_yes = -1;

static char const * interpret_from = NULL;
static char const * interpret_to = NULL;

/* Summarise command line syntax. */

#define USAGE \
"gsc $dev... -e -yiowp -acfnlrst -bhqv $args... // $comment..."

/* Complain of command line syntax. */

static void confused_exit(void)
{
	fprintf(stderr, "Usage: %s\nMore details at: gss --help\n", USAGE);
	exit(-__LINE__);
}

/* Convert to CDB length from CDB[0]. */

static int to_cdb_length(int op, int guess)
{
	switch (op & 0xE0) { /* &xE0 = "group" */
		case 0x00: return 6; /* x00 .. x1F */
		case 0x20: return 10;/* x20 .. x3F */
		case 0x40: return 10; /* x40 .. x5F */
		case 0x60: break; /* x60 .. x7F reserved */
		case 0x80: break; /* x80 .. x9F reserved */
		case 0xA0: return 12; /* xA0 .. xBF */
		case 0xC0: break; /* xC0 .. xDF vendor-specific */
		case 0xE0: break; /* xE0 .. xFF vendor-specific */
	}
	return guess;
}

/* Complain of SCSI pass thru known to crash operating systems. */

static void displeased_exit(char const * st)
{
	fprintf(stderr, "Say --please to pass thru %s\n", st);
	exit(-__LINE__);
}

/* Exit without risking a crash. */

static void audit_gss(struct gss * gss)
{
	char const * cdb = gss_get_cdb(gss);
	int op = (cdb[0] & 0xFF);
	int enough = to_cdb_length(op, -1);
	if (gss_get_cdb_enough(gss) != enough) {
		displeased_exit("non-standard CDB length");
	}
	if (cdb[0] == 0x04) {
		displeased_exit("op x04 Format");
	}
	if ((cdb[0] == 0x12) && (gss_get_chars_length(gss) == 0)) {
		displeased_exit("op x12 Inquiry for zero");
	}
	if ((cdb[0] == 0x1A) && (gss_get_chars_length(gss) < 8)) {
		displeased_exit("op x1A Mode Sense 6 for less than 8");
	}
}

/* Open a file to read from. */

static FILE * open_from(char const * fn)
{
	if (*fn == '\0') {
		return stdin; /* FIXME: might be opened "rt" */
	} else {
		FILE * fi = fopen(fn, "rb");
		if (fi != NULL) {
			return fi;
		}
		perror("gss:from:fopen");
		exit(-__LINE__);
	}
}

/* Fill with copies of the beginning. */

static void fill(char * chars, int index, int length)
{
	char const * home = chars;
	int step = index;
	for (;;) {
		chars += step; length -= step;
		step = ((length < index) ? length : index);
		if (step <= 0) break;
		memmove(chars, home, step);
		index += step;
	}
}

/* Read once to fill with copies, else fill with '\0' nul. */

static void read_to_fill(FILE * fi)
{
	int length = gss_get_chars_length(gss_first);
	if (0 < length) {
		char * chars = gss_get_chars(gss_first);
		int io = fread(chars, 1, length, fi);
		if ((0 <= io) && (io <= length)) {
			chars[0] = '\0';
			if (io == 0) ++io;
			fill(chars, io, length);
		} else {
			if (ferror(fi)) {
				perror("gss:from:fread");
			} else {
				fprintf(stderr, "gss:from:feof\n");
			}
			exit(-__LINE__);
		}
	}
}

/* Copy the data before passing the data out. */

char const * new_copy(struct gss * gss)
{
	int length = gss_get_chars_length(gss);
	if (0 < length) {
		char * chars = gss_get_chars(gss);
		char * new_chars = calloc(1, length);
		if (new_chars != NULL) {
			memcpy(new_chars, chars, length);
			return new_chars;
		}
		perror("gss:compare:calloc");
		exit(-__LINE__);
	}
	return NULL;
}

/* Compare the data passed out to the data passed in. */

static int compare_copy(struct gss * gss, int rc, char const * was)
{
	int enough = gss_get_chars_enough(gss);
	if (0 < enough) {
		char * chars = gss_get_chars(gss);
		if (memcmp(was, chars, enough) != 0) {
			if (0 < rc) rc = SP_RESIDUE;
			rc |= SP_PASS_THRU;
			rc |= SP_COMPARE;
		}
	}
	return rc;
}

/* Open a file to write to. */

static FILE * open_to(char const * fn)
{
	if (*fn == '\0') {
		return stdout; /* FIXME: might be opened "wt" */
	} else {
		FILE * fi = fopen(fn, "wb");
		if (fi != NULL) {
			return fi;
		}
		perror("gss:to:fopen");
		exit(-__LINE__);
	}
}

/* Write once. */

static void write_to(FILE * fi)
{
	int length = gss_get_chars_length(gss_first);
	if (0 < length) {
		char * chars = gss_get_chars(gss_first);
		int io = fwrite(chars, 1, length, fi);
		if (io != length) {
			perror("gss:to:fwrite");
			exit(-__LINE__);
		}
	}
}

/* Interpret --yes or --no. */

static void run(char const * hex)
{
	struct gss * gss = gss_first;

	int please = interpret_please;
	int compare = interpret_compare;
	int repeat = interpret_repeat;
	int yes = interpret_yes;
	char const * from_fn = interpret_from;
	char const * to_fn = interpret_to;

	FILE * from_fi = NULL;
	FILE * to_fi = NULL;
	char const * was = NULL;
	int tolerable = 0;
	int rc = 0;

	/* Audit. */

	if (!please) {
		audit_gss(gss);
	}
	if (to_fn != NULL) {
		to_fi = open_to(to_fn);
	}

	/* Start up. */

	if (from_fn != NULL) {
		from_fi = open_from(from_fn);
	}
	if (from_fi != NULL) {
		read_to_fill(from_fi);
	}
	if (compare) {
		was = new_copy(gss);
	}

	/* Speak, maybe repeatedly. */

	while (0 < repeat--) {
		rc = gss_hex_try(gss, hex);
		if (compare) {
			rc = compare_copy(gss, rc, was);
		}
		if (tolerable == 0) {
			tolerable = ((0 < rc) ? rc : -1);
		}
		if ((0 < rc) && (rc == tolerable)) {
			rc = 0;
		}
		if (yes != (rc == 0)) {
			break;
		}
	}

	/* Shut down. */

	if (to_fi != NULL) {
		write_to(to_fi);
	}
	exit(rc);
}

static char const * arg_read(void)
{
	if (*args == NULL) {
		confused_exit();
	}
	return *args++;
}

static int to_int(char const * st)
{
	st = st;
	return 0;
}

static void helpful_exit(void)
{
	char const * st = /* one line per option, sorted by name */
"-b --beyond $length     // else 0\n"
"-c --compare\n"
"-e --each\n"
"-f --from $fn           // else stdin\n"
"-h --help\n"
"-i --in $length         // else 0.4096.0 = 0 aligned at 4 KiB\n"
"-l --late $seconds      // else 100800.000 = 28 hours\n"
"-n --no $hex\n"
"-o --out $length        // else 0.4096.0 = 0 aligned at 4 KiB\n"
"-p --please             // else audit cdb length, etc.\n"
"-q --quiet\n"
"-r --repeat $count      // else 1\n"
"-s --sense $length      // else 18.4.0 = x12 aligned at 4 bytes\n"
"-t --to $fn             // else stdout\n"
"-v --verbose\n"
"-w --with $hex          // else -w \"AE\"\n"
"-y --yes $hex           // else -i x24 -y \"12 00:00:00 24 00\"\n"
"\n" /*" 1234567 1234567 1234567 1234567 1234567 1234567 1234567 tab stops */
"gsc $dev -v -i 0x24 -y \"12 00:00:00 24 00\" // Inquiry\n"
"gsc $dev -v -i 8 -y \"25 00 00:00:00:00 00 00:00 00\" // Read Max LBA\n"
"gsc $dev -v -y \"00 00:00:00 00 00\" // Test Unit Ready\n"
"gsc $dev -v -y \"1B 00:00:00 00 00\" // Stop Unit\n"
"gsc $dev -v -y \"1B 00:00:00 01 00\" // Start Unit\n"
"gsc $dev -v -y \"1B 00:00:00 02 00\" // Stop Then Eject\n"
"...\n"
;
	printf("Usage: %s\n\n%s\n\n%s\n", USAGE, st, VERSION);
	exit(0);
}

static char const * abbreviate(char const * st)
{
	if (strcmp(st, "--align")) return "-a";
	if (strcmp(st, "--beyond")) return "-b";
	if (strcmp(st, "--compare")) return "-c";
	if (strcmp(st, "--each")) return "-e";
	if (strcmp(st, "--from")) return "-f";
	if (strcmp(st, "--help")) return "-h";
	if (strcmp(st, "--in")) return "-i";
	if (strcmp(st, "--late")) return "-l";
	if (strcmp(st, "--no")) return "-n";
	if (strcmp(st, "--out")) return "-o";
	if (strcmp(st, "--please")) return "-p";
	if (strcmp(st, "--quiet")) return "-q";
	if (strcmp(st, "--repeat")) return "-r";
	if (strcmp(st, "--sense")) return "-s";
	if (strcmp(st, "--to")) return "-t";
	if (strcmp(st, "--verbose")) return "-v";
	if (strcmp(st, "--with")) return "-w";
	if (strcmp(st, "--yes")) return "-y";
	return st;
}

static void step(char const * st)
{
	if (strcmp(st, "--")) {
		interpret_dash = 0;
	} else if (strcmp(st, "-a")) { /* align $page $offset */
		int l = to_int(arg_read());
		int o = to_int(arg_read());
		gss_align(gss_first, l, o);
	} else if (strcmp(st, "-b")) { /* beyond $length */
		int b = to_int(arg_read());
		gss_verbose_limit(gss_first, b);
	} else if (strcmp(st, "-c")) { /* compare */
		interpret_compare = 1;
	} else if (strcmp(st, "-e")) { /* each */
		gss_each(NULL);
	} else if (strcmp(st, "-f")) { /* from $fn */
		interpret_from = arg_read();
	} else if (strcmp(st, "-h")) { /* help */
		helpful_exit();
	} else if (strcmp(st, "-i")) { /* in $length */
		int i = to_int(arg_read());
		gss_in_limit(gss_first, i);
	} else if (strcmp(st, "-l")) { /* late $s $ns */
		int s = to_int(arg_read());
		int ns = to_int(arg_read());
		gss_define_late(gss_first, s, ns);
	} else if (strcmp(st, "-n")) { /* no $hex */
		interpret_yes = 0;
		run(arg_read());
	} else if (strcmp(st, "-o")) { /* out $length */
		int o = to_int(arg_read());
		gss_out_limit(gss_first, o);
	} else if (strcmp(st, "-p")) { /* please */
		interpret_please = 1;
	} else if (strcmp(st, "-q")) { /* quiet */
		int b = 0;
		gss_verbose_limit(gss_first, b);
	} else if (strcmp(st, "-r")) { /* repeat $count */
		interpret_repeat = to_int(arg_read());
	} else if (strcmp(st, "-s")) { /* sense $length $page $offset */
		int s = to_int(arg_read());
		int l = to_int(arg_read());
		int o = to_int(arg_read());
		gss_sense_stress(gss_first, s, l, o);
	} else if (strcmp(st, "-t")) { /* to $fn */
		interpret_to = arg_read();
	} else if (strcmp(st, "-v")) { /* verbose */
		int b = 1;
		gss_verbose_limit(gss_first, b);
	} else if (strcmp(st, "-w")) { /* with $hex */
		gss_hex_with(gss_first, arg_read());
	} else if (strcmp(st, "-y")) { /* yes $hex */
		interpret_yes = 1;
		run(arg_read());
	} else {
		char const * name = arg_read();
		if ((name[0] == '-') && interpret_dash) {
			confused_exit();
		}
		gss_also(gss_first, name);
	}
}

static void interpret(char const * const * argv)
{
	args = argv;
	while (*args != NULL) {
		step(abbreviate(arg_read()));
	}
}

int main(int argc, char const * const * argv)
{
	char const * const preface[] = {
		"--align", "4096", "0",
		"--beyond", "0",
		"--in", "0",
		"--late", "100800", "0", /* 100800 = 28 * 60 * 60 */
		"--out", "0",
		"--quiet",
		"--repeat", "1",
		"--sense", "12", "16", "0",
		"--with", "AE",
		NULL
	};
	char const * const inquiry[] = {
		"--in", "x24", "--yes", "12 00:00:00 24 00",
		NULL
	};
	interpret(preface);
	interpret(argv);
	if (interpret_yes < 0) {
		interpret(inquiry);
	}
	return 0;
}

/* end of file */


