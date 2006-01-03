From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Tue, 03 Jan 2006 14:20:10 -0500
Message-ID: <yq1hd8l2k5x.fsf@wilson.lab.mkp.net>
References: <1135801791.9541.12.camel@gateway.markschaefer.org>
	<1136168563.3768.3.camel@localhost.localdomain>
	<yq1oe2u2z6i.fsf@wilson.lab.mkp.net>
	<200601030851.30624@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:21397 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1751465AbWACTUO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 14:20:14 -0500
In-Reply-To: <200601030851.30624@bilbo.math.uni-mannheim.de> (Rolf Eike Beer's message of "Tue, 3 Jan 2006 08:51:30 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org

>>>>> "Eike" == Rolf Eike Beer <eike-kernel@sf-tec.de> writes:

Eike> Ok, can you collect such a list of the "other" cards that your
Eike> driver does not support? And a list of PCI ids that match both
Eike> lists?

Tachyon chips are all over the place on cards from a multitude of
vendors.  The list I provided represents the pile of HP cards I have
in my lab.


Eike> These are the devices supported by the original cpqfc driver:

Eike> #define PCI_DEVICE_ID_COMPAQ_TACHYON 0xa0fc 
Eike> #define PCI_DEVICE_ID_HP_TACHYON 0x1028 
Eike> #define PCI_DEVICE_ID_HP_TACHLITE 0x1029

Only the Compaq board is really supported.

The HP TL board happens to work if you don't care about using a valid
WWN on your SAN.  The XL2 board doesn't actually work at all.

Technically it's not correct to refer to 0x1028 and 0x1029 as TACHYON
and TACHLITE.  Both of them are TachLite.  To my knowledge Tachyon
proper doesn't have a PCI interface, so there's probably a glue chip
on the HPFC-5000 boards out there.

These are the right identifiers:

#define PCI_DEVICE_ID_HP_TACH_TL	0x1028
#define PCI_DEVICE_ID_HP_TACH_XL2	0x1029
#define PCI_DEVICE_ID_HP_TACH_TS	0x102a
#define PCI_DEVICE_ID_COMPAQ_TACHYON	0xa0fc

pciids.sf.net has them right.  It's just the kernel pci_ids.h that's a
bit out of whack.

Some day I'll insert my cards one by one and get all the subsystem ids
right.

Unlike most cards the subsystem id matters in this case as each vendor
may wrap their boards differently in terms of Flash/ROM interface,
onboard RAM, SERDES, GBIC interface, etc.

HP TL/XL2 HBA:

       I'm currently mucking with extracting WWNs from the HP boards.

Compaq FC HBA: 

       Supporting this board shouldn't be a problem as the I2C NVRAM
       interface is documented in cpqfcTS.

InterPhase 55x6:

       These boards are documented in the ancient iphase driver.

Agilent:

       My hope is that Agilent's own boards are using the reference
       designs and consequently should be easy to support.

Adaptec:

       I think Adaptec's boards were OEM'ed from Agilent.  Probably
       just a different ROM.

These are the board vendors I know off the top of my head.  There may
well be more.


(I'm going to put all this on a webpage later today)

-- 
Martin K. Petersen      http://mkp.net/
