From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: How does a SCSI device gets a target ID?
Date: Wed, 9 Mar 2005 11:54:57 -0500
Message-ID: <200503091655.j29Gt2517120@www.watkins-home.com>
References: <267988DEACEC5A4D86D5FCD780313FBB0575F03B@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:12450 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S261658AbVCIQzE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 11:55:04 -0500
In-Reply-To: <267988DEACEC5A4D86D5FCD780313FBB0575F03B@exch-03.noida.hcltech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Rajat  Jain, Noida'" <rajatj@noida.hcltech.com>, linux-scsi@vger.kernel.org

A narrow SCSI bus will support 8 devices.
A wide SCSI bus will support 16 devices.
A narrow bus uses 50 pins.
A wide bus uses 68 pins.

The SCSI card is a device, normally ID 7.

The SCSI ID is configured on the device.  You will need to look at the
manual, some devices may have cryptic notes on the device.  Each device must
have a unique ID.

There is a standard for auto selecting the SCSI ID.  I have never used this.
SCAM (SCSI Configures Auto Magically).

The below speeds assume wide, divide by 2 is narrow.
There are many electrical standards.
SE - Single ended (20M/s)
DF (HVD) High voltage differential (20M/s)
U Ultra (40M/s)
U2 (LVD, U-80, Ultra 2) Low voltage differential (80M/s)
U-160 Ultra 160 (160M/s)
U-320 Ultra 320 (320M/s)
U-640 Ultra 640 (640M/s) Not sure this is a standard yet.

Mixing devices with different electrical standards can be tricky.  Some
can't be mixed.  HVD is not compatible with any other.

Both ends of the SCSI bus must be terminated.  Some devices have an internal
terminator that can be enabled or disabled.  The SCSI card normally is a
terminator.  1 device must supply terminator power.  I believe it is ok if
more than 1 device supplies terminator power, but not sure.  Normally the
SCSI card supplies terminator power.

I hope this answers your questions! :)

This link may help, but it is very out of date.  It stops at Ultra!!!!

http://www.adaptec.com/worldwide/support/supporteditorial.jsp?sess=no&langua
ge=English+US&prodkey=SCSI_glossary

Guy

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Rajat Jain, Noida
Sent: Wednesday, March 09, 2005 11:04 AM
To: linux-scsi@vger.kernel.org
Subject: How does a SCSI device gets a target ID?

Hi,
 
I'm new to SCSI. I would appreciate if some one can solve my query:

When a new SCSI device is added to a SCSI channel, how can we find out what
is the target ID of that device? 

1) If a channel supports 8 SCSI devices, then each of the 8 ports will have
a specific Target ID. And any device attached to that port will have that
Target ID.

2) Is it done one the fly? I mean (starting from zero), the SCSI device is
given a target ID that is 1 greater that the last SCSI device's ID. Who
assigns this ID?

TIA,

Rajat
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

