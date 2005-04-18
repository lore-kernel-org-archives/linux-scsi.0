From: Douglas Gilbert <dougg@torque.net>
Subject: [ANNOUNCE] sdparm 0.90
Date: Mon, 18 Apr 2005 23:26:03 +1000
Message-ID: <4263B56B.2010905@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:64431 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262078AbVDRN3v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 09:29:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id 53ADE394988
	for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2005 23:29:49 +1000 (EST)
Received: from [192.168.48.80] (dsl-60.129.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.129.60])
	by borg.st.net.au (Postfix) with ESMTP id 4CD69394975
	for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2005 23:29:47 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

sdparm is a new command line utility designed to get and set
SCSI disk parameters (cf hdparm for ATA disks). More generally
it gets and sets mode page information on SCSI devices or devices
that use a SCSI command set (e.g. CD/DVD drives (any transport)
and SCSI tape drives).

The elements within mode pages are addressed via acronyms
(e.g. "WCE" for "write cache enable" in the caching mode
page). There is also numeric addressing of the form:
<start_byte>:<start_bit>:<num_bits>
This symbolic or numeric addressing should be more
convenient for changing parameters than the techniques used
by scsiinfo, sginfo and sg_wr_mode.

A GUI wrapping sdparm would be a useful extension.
It could show the mode page as found in the standard or
the vendor's product manual with attributes such as
"changeable" represented by colour or shading.

I hope to add VPD pages in the future. sdparm shares some
code with sg3_utils but is currently independent; they may
share a library (libsgutils) in the future.

A tarball, rpms and a "deb" can be found on
http://www.torque.net/sg .
Currently, the most complete documentation is in the
man page.


Examples (taken from the man page):
To list the common (mode) parameters of a disk:

     sdparm /dev/sda

To see all parameters for the caching control mode page:

     sdparm --page=3Dca /dev/sda

To get the WCE values (current changeable default and
saved) in hex:

     sdparm -g WCE -H /dev/sda
   0x01 0x00 0x01 0x01

To get the WCE current value in hex:

     sdparm -g WCE=3D1 -H /dev/sda
   0x01

To set the "write cache enable" bit in the current page:

     sdparm --set=3DWCE /dev/sda

To set the "write cache enable" bit in the current and
saved page:

     sdparm --set=3DWCE --save /dev/sda

To set the "write cache enable" and clear "read cache
disable":

     sdparm --set=3DWCE --clear=3DRCD --save /dev/sda

The previous example can also by written as:

     sdparm -s WCE=3D1,RCD=3D0 -S /dev/sda

To re-establish the manufacturer=92s defaults in the
current and saved caching control mode page:

     sdparm --page=3Dca --defaults -save /dev/sda

If an ATAPI cd/dvd player is at /dev/hdc then its common
(mode) parameters could be listed with:

           sdparm /dev/hdc


Comments, suggestions and patches welcome.


Doug Gilbert
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
