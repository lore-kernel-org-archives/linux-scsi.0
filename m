From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 07 Nov 2003 10:09:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068224969.2286.142.camel@patrh9>
References: <1068165515.28505.29.camel@patrh9>
	 <1068222286.2286.50.camel@patrh9>  <1068224213.2286.115.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:59108 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264488AbTKGRJ6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 12:09:58 -0500
In-Reply-To: <1068224213.2286.115.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: patmans@us.ibm.com, linux-scsi@vger.kernel.org

> > Perhaps we should be looking at 
> > implementing camcontrol in Linux.
> 
> Implementing, yes.  Copying, no.
> I have a series of arguments, ...
>
> > Unix Man Page For 8 camcontrol
> > http://www.svbug.com/cgi-bin/man.cgi?comd=8+camcontrol

I think arg parsing is an issue.

I see the camcontrol man page includes such off-putting apologetic
fragments as:

"The sense information from the test unit ready command would not get
printed out, since the first getopt(3) call in camcontrol bails out when
it sees the second argument to -c (0x00), above.

"If the CDB specified causes data to be transfered to or from the SCSI
device in question, you MUST specify either
 ... -i len fmt ... -o len fmt [args] ..."

I particular want the common things to remain concise.

I choke over the idea of having to specify fmt in addition to len of -i
or -o.

Part of why I find plscsi/ unreadable, even though I wrote plscsi/
myself, is that in plscsi/ I resorted to rewriting getopts to fix this
kind of thing.

Since then I think I have by now found my way to a (more?) fully
getopt-compatible parsing of args.  That gccscsi.h I posted #define's A
thru Z macros that correspond to proposed sg_io args -a thru -z.

1) That -d is unused appears as, e.g.:

#undef D

2) That some options exist only for the command line appears as, e.g.:

#undef  P /* gcs --please */

The -p or --please option is an interlock.  You have to add it to pass
thru such things as non-standard CDB lengths, the op x04 Format that
smashes disks, and the -y "12 00:00:00 00" Inquiry for Zero that crashes
many version of Linux 2.4.

3) Seeing that the args are single can be difficult, e.g.:

#define L(S, NS) gcs_late(gcs(), (S), (NS))

I figure at the command line we parse $s.fraction and convert to the
standard posix int pair (seconds, nanoseconds).

4) Seeing that the args are omitted or single can be easy, e.g.:

#define Q() gcs_quiet(gcs())
#define S(S) gcs_sense_in(gcs(), (S), 4, 0)

Pat LaVarre


