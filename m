From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 30 Oct 2003 16:59:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067558384.14409.50.camel@patrh9>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
	 <1067531731.4250.11.camel@pathost1.iomegacorp.com>
	 <20031030091808.A6781@beaverton.ibm.com>
	 <1067535485.6411.42.camel@pathost1.iomegacorp.com>
	 <20031030100501.A7250@beaverton.ibm.com>
	 <1067541899.1141.4.camel@ronald.kuetemeier.com>
	 <20031030134850.A9076@beaverton.ibm.com>
	 <1067551081.1138.7.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:36740 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262973AbTJaAAO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 19:00:14 -0500
In-Reply-To: <1067551081.1138.7.camel@ronald.kuetemeier.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: ronald@kuetemeier.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> > Can you hack the base 2.6 so the len is 255, and configure or modify to
> > that it uses only page 3f so it closely matches what 2.4 sends, and see
> > what happens?
> > 
> Sorry has to wait until next week. 

Can we cycle more quickly thru compile-test-edit up in user land, rather
than patching the kernel?

For example, the kernel code:

drivers/scsi/sd.c
... sd_do_mode_sense(SRpnt, 0, 0x08, buffer, 0x1C, &data);
... sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
... sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
... sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);

becomes the bash script:

sudo ./plscsi /dev/sg1 -v -i x1C -x "5A 00 08:00:00:00 00 00:1C 00"
sudo ./plscsi /dev/sg1 -v -i 4   -x "5A 00 3F:00:00:00 00 00:04 00"
sudo ./plscsi /dev/sg1 -v -i 4   -x "5A 00 00:00:00:00 00 00:04 00"
sudo ./plscsi /dev/sg1 -v -i xFF -x "5A 00 3F:00:00:00 00 00:FF 00"

after the setup of the tty log below.

I trust this audience already knows we have to be wary of experimenting
near here: by definition this kind of root-privileged user code can
crash kernels (and thus smash hdd) almost as readily as kernel mods.

Also personally I find the source for that plscsi app impenetrably awful
to read.

Pat LaVarre

P.S. If you have sufficiently shy automounting daemon's, to duplicate
these results you may have to skip past such non-repeating errors as:

// x 6 29 sense
// x 6 28 sense

SK 6 = unit attention, ASC x29 = reset, ASC x28 = gone ready.  If you
eat an x28 in place of the automounting daemon, some of your system may
neglect to notice you have inserted/ swapped that disk.

//////////////////// tty log of setup

$ mkdir plscsi
$
$ cd plscsi
$
$ wget http://members.aol.com/plscsi/2002/09/22/plscsi.zip
...
16:34:21 (68.48 KB/s) - `plscsi.zip' saved [56729/56729]
 
$ unzip plscsi.zip
Archive:  plscsi.zip
  inflating: Makefile
...
  inflating: wnaspi32.h
$
$ mv -i Makefile Makefile~
$
$ sed 's/gcc/g++/' Makefile~ >Makefile
$
$ make
g++ -o plscsi -Wall *.c*
$
$ sudo ./plscsi -w
export PLSCSI=/dev/sg0        // @ LITE-ON  COMBO LTC-48161H KH0K
export PLSCSI=/dev/sg1        // B IOMEGA   ZIP 250          61.T
$

///////////////// tty log of a way for these tests to pass

$ sudo ./plscsi /dev/sg1 -v -i 4 -x "5A 00 08:00:00:00 00 00:04 00"
x 00000000 5A 00 08:00:00:00 00 00:04 00 .. .. .. .. .. .. "Z@H@@@@@D@"
x 00000000 00:12:00:00 .. .. .. .. .. .. .. .. .. .. .. .. "@R@@"
// 0 = plscsi.main exit int
$
$ sudo ./plscsi /dev/sg1 -v -i 4 -x "5A 00 3F:00:00:00 00 00:04 00"
x 00000000 5A 00 3F:00:00:00 00 00:04 00 .. .. .. .. .. .. "Z@?@@@@@D@"
x 00000000 00:40:00:00 .. .. .. .. .. .. .. .. .. .. .. .. "@@@@"
// 0 = plscsi.main exit int
$
$ sudo ./plscsi /dev/sg1 -v -i 4 -x "5A 00 00:00:00:00 00 00:04 00"
x 00000000 5A 00 00:00:00:00 00 00:04 00 .. .. .. .. .. .. "Z@@@@@@@D@"
x 00000000 00:06:00:00 .. .. .. .. .. .. .. .. .. .. .. .. "@F@@"
// 0 = plscsi.main exit int
$
$ sudo ./plscsi /dev/sg1 -v -i xFF -x "5A 00 3F:00:00:00 00 00:FF 00"
x 00000000 5A 00 3F:00:00:00 00 00:FF 00 .. .. .. .. .. .. "Z@?@@@@@?@"
x 00000000 00:40:00:00 00:00:00:00 01:06:C8:64 00:00:00:00 "@@@@@@@@AFHd@@@@"
x 00000010 05:1E:80:00 40:20:02:00 00:00:00:00 00:00:00:00 "E^@@@ B@@@@@@@@@"
x 00000020 00:00:00:00 00:00:00:00 00:00:00:00 0B:7D:00:00 "@@@@@@@@@@@@K}@@"
x 00000030 08:0A:04:00 FF:FF:00:00 FF:FF:FF:FF 2F:04:5C:01 "HJD@??@@????/D\A"
x 00000040 0F:0F:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "OO@@@@@@@@@@@@@@"
x 00000050 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
...
x 000000E0 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
x 000000F0 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00 .. "@@@@@@@@@@@@@@@"
// 0 = plscsi.main exit int
$


