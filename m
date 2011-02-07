From: Jon Bendtsen <jonbendtsen@jbit.dk>
Subject: understanding the sg_ses --raw output? so I can turn on the faulty
 light
Date: Mon, 07 Feb 2011 16:25:48 +0100
Message-ID: <4D500EFC.1040801@jbit.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:34582 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1BGPZx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2011 10:25:53 -0500
Received: from localhost (localhost [127.0.0.1])
	by mgw2.diku.dk (Postfix) with ESMTP id D7AF919BC3F
	for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2011 16:25:51 +0100 (CET)
Received: from mgw2.diku.dk ([127.0.0.1])
 by localhost (mgw2.diku.dk [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 04049-20 for <linux-scsi@vger.kernel.org>;
 Mon,  7 Feb 2011 16:25:48 +0100 (CET)
Received: from nhugin.diku.dk (nhugin.diku.dk [130.225.96.140])
	by mgw2.diku.dk (Postfix) with ESMTP id 9972719BBC0
	for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2011 16:25:48 +0100 (CET)
Received: from imap.diku.dk (imap.diku.dk [130.225.96.139])
	by nhugin.diku.dk (Postfix) with ESMTP id B731A6DF823
	for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2011 16:19:54 +0100 (CET)
Received: from dkjonb.laerdal.global (212-60-115-150.ip.cust.zensystems.net [212.60.115.150])
	by imap.diku.dk (Postfix) with ESMTP id 5B31361DCD
	for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2011 16:25:48 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

There has earlier been 2 threads on sg_ses 21 may 2007 and 10 june 2010,
but unfortunately neither seemed to include information about how to
understand the --raw output from sg_ses.

When I run this command
	sg_ses --page=2 /dev/sg30 --raw

I get output that looks like:
        00 00 00 00 00 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  00 00 01 00 01 00 01 00
        00 00 00 40 06 00 00 47  06 00 00 47 06 00 00 47
        00 00 00 00 01 00 2c 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00

There are 26 segments starting with 01 00 00 00, and 27 with 06. I think
i have to use the 01 segments, but the number 26 does not fit with my
number of disks unless they count like this: controller, backplane + 24
disks or enclosure port A + port B + 24 disks.

At first i figured i had to set 20 in the last field, but that did not
work. So i tried modifying a 01 00 00 00 to 01 00 02 20 based on this
webpage:
http://storagesecrets.org/2008/12/scsi-enclosure-services-ses-ses-2-management/

I also tried with 06 00 00 00 to 06 00 02 20, still nothing.

I set the data using
	sg_ses --control --page=2 -d - /dev/sg30 < raw.test


Here are the output of lsscsi
[0:0:0:0]    disk    ATA      INTEL SSDSA2M040 2CV1  /dev/sda
[1:0:0:0]    disk    ATA      INTEL SSDSA2M040 2CV1  /dev/sdb
[2:0:0:0]    disk    ATA      Corsair CSSD-F24 2.0   /dev/sdc
[3:0:0:0]    disk    ATA      Corsair CSSD-F24 2.0   /dev/sdd
[5:0:0:0]    disk    ATA      Corsair CSSD-F24 2.0   /dev/sde
[5:0:1:0]    disk    ATA      Corsair CSSD-F24 2.0   /dev/sdf
[6:0:0:0]    disk    ATA      SAMSUNG HE103UJ  1113  /dev/sdg
[6:0:1:0]    disk    ATA      SAMSUNG HE103UJ  1113  /dev/sdh
[6:0:2:0]    disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdi
[6:0:3:0]    disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdj
[6:0:4:0]    disk    ATA      SAMSUNG HE103UJ  1113  /dev/sdk
[6:0:5:0]    disk    ATA      SAMSUNG HE103UJ  1113  /dev/sdl
[6:0:6:0]    disk    ATA      WDC WD10EADS-00L 1A01  /dev/sdm
[6:0:7:0]    disk    ATA      SAMSUNG HE103UJ  1113  /dev/sdn
[6:0:8:0]    disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdo
[6:0:9:0]    disk    ATA      SAMSUNG HE103UJ  1113  /dev/sdp
[6:0:10:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdq
[6:0:11:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdr
[6:0:12:0]   disk    ATA      Hitachi HDS72101 A39C  /dev/sds
[6:0:13:0]   disk    ATA      SAMSUNG HD103UJ  1118  /dev/sdt
[6:0:14:0]   disk    ATA      SAMSUNG HD103UJ  1118  /dev/sdu
[6:0:15:0]   disk    ATA      Hitachi HDS72101 A39C  /dev/sdv
[6:0:16:0]   disk    ATA      Hitachi HUA72201 A3EA  /dev/sdw
[6:0:17:0]   disk    ATA      Hitachi HUA72201 A3EA  /dev/sdx
[6:0:18:0]   disk    ATA      WDC WD1002FBYS-0 0C06  /dev/sdy
[6:0:19:0]   disk    ATA      WDC WD1002FBYS-0 0C06  /dev/sdz
[6:0:20:0]   disk    ATA      WDC WD2002FYPS-0 1G01  /dev/sdaa
[6:0:21:0]   disk    ATA      Hitachi HUA72202 A3EA  /dev/sdab
[6:0:22:0]   disk    ATA      WDC WD2003FYYS-0 1D01  /dev/sdac
[6:0:23:0]   disk    ATA      WDC WD2001FASS-0 0101  /dev/sdad
[6:0:24:0]   enclosu LSILOGIC SASX36 A.0          9  -


The first 6 /dev/sd devices are attached using sata to a 00:11.0 SATA
controller: ATI Technologies Inc SB700/SB800 SATA Controller [IDE mode]
where as the last 24 disks is connected using a 06:00.0 SCSI storage
controller: LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT
SAS (rev 08) found onboard on my SuperMicro H8DI3+-F in a supermicro
SC846E2 chasis. Only 1 SAS cable is attached between the controller and
enclosure backplane even though both support 2 cables.


The same enclosure and disks used to work with a 3ware 9690sa-8i which
had a webpage system to turn on and off those bits. But after a brand
new disk crashed and pulled all the other 23 disks offline from the
controller, then i do not like to continue to use the 3ware 9690sa-8i
controller.


JonB

