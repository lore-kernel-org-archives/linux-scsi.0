From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 31 Oct 2003 16:11:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067641884.11436.47.camel@patrh9>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
	 <1067531731.4250.11.camel@pathost1.iomegacorp.com>
	 <20031030091808.A6781@beaverton.ibm.com>
	 <1067535485.6411.42.camel@pathost1.iomegacorp.com>
	 <20031030100501.A7250@beaverton.ibm.com>
	 <1067541899.1141.4.camel@ronald.kuetemeier.com>
	 <20031030134850.A9076@beaverton.ibm.com>
	 <1067551081.1138.7.camel@ronald.kuetemeier.com>
	 <1067558384.14409.50.camel@patrh9>
	 <20031031101645.A14729@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:10656 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263669AbTJaXLs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 18:11:48 -0500
In-Reply-To: <20031031101645.A14729@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: ronald@kuetemeier.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> You can use /dev/sdN with 2.6.

Seemingly I am required to substitute open O_NONBLOCK | O_RDONLY for
what was open O_RDWR e.g. per the patch below.

> > Also personally I find the source for that plscsi app impenetrably
> > awful to read.
> 
> Maybe you can rewrite it in c and get it into sg_utils.

Work in progress.

I feel I've thought thru SG_IO from the command line in depth, I think I
can do, I'm happy to detail my incomplete work here if people want to
see it, else I'll [ANNOUNCE] when next I have something running.

> > Can we cycle more quickly thru compile-test-edit up in user land, rather
> > than patching the kernel?
> 
> Good idea.
> 
> > sudo ./plscsi /dev/sg1 -v -i x1C -x "5A 00 08:00:00:00 00 00:1C 00"
> > sudo ./plscsi /dev/sg1 -v -i 4   -x "5A 00 3F:00:00:00 00 00:04 00"
> > sudo ./plscsi /dev/sg1 -v -i 4   -x "5A 00 00:00:00:00 00 00:04 00"
> > sudo ./plscsi /dev/sg1 -v -i xFF -x "5A 00 3F:00:00:00 00 00:FF 00"
> 
> Nice.

Thanks for saying.

> Does sg_utils have an equivalent tool?

I believe not yet.  I'm pushing forward at:

http://members.aol.com/plscsi/tools/gccscsi/

For example, there the bash-script command line:

sudo ./gss /dev/sg1 -i x1C -y "5A 00 08:00:00:00 00 00:1C 00"

can instead appear in .c as:

i(0x1C); y("5A 00 08:00:00:00 00 00:1C 00");

> ...

EOL = CR LF vs. EOL = LF, trailing blanks, etc. may make the following
patch difficult to apply.  But a tty log showing the change to
(O_NONBLOCK | O_RDONLY) from O_RDWR is:

$ uname -msr
Linux 2.6.0-test9 i686
$
$ cp o/sgio.cpp sgio.cpp
$ make
g++ -o plscsi -Wall *.c*
$ sudo ./plscsi /dev/cdrom
// sgioOpen.open: Read-only file system
// plscsi.sclOpenNext: "/dev/cdrom" not opened
// -x0001 = -1 = plscsi.main exit int
$ sudo ./plscsi /dev/sda
// sgioOpen.open: No medium found
// plscsi.sclOpenNext: "/dev/sda" not opened
// -x0001 = -1 = plscsi.main exit int
$
$ cp n/sgio.cpp sgio.cpp
$ make
g++ -o plscsi -Wall *.c*
$ sudo ./plscsi /dev/cdrom
export PLSCSI=/dev/cdrom      // @ LITE-ON  COMBO LTC-48161H KH0K
$ sudo ./plscsi /dev/sda
export PLSCSI=/dev/sda        // B IOMEGA   ZIP 250          61.T
$

Pat LaVarre

P.S. The plscsi patch is:

--- o/sgio.cpp	2002-09-21 12:25:18.000000000 -0600
+++ n/sgio.cpp	2003-10-31 15:38:43.000000000 -0700
@@ -116,6 +116,7 @@
     sgio->theErrFile = stderr;
 
     sgio->theOpenMode = O_RDWR; /* O_RDONLY often works */
+sgio->theOpenMode = (O_NONBLOCK | O_RDONLY);
     sgio->theFileDescriptor = -1;
     sgio->theSgVersionNum = 0; /* 0 = unknown */
 




