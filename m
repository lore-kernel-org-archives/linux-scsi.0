From: Mathieu Fluhr <mfluhr@nero.com>
Subject: Re: Inquiry data and emulated SG devices
Date: Thu, 18 Oct 2007 13:57:30 +0200
Message-ID: <1192708650.3266.38.camel@de-c-l-110.nero-de.internal>
References: <fa.PgEHbZ0E5ogcX8bZwvrUeZB+eJs@ifi.uio.no>
	 <4716B56A.1090501@shaw.ca>  <4716B786.80804@garzik.org>
	 <1192701555.3247.28.camel@de-c-l-110.nero-de.internal>
	 <4717302D.4050107@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4717302D.4050107@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>, James Bottomley <James.Bottomley@SteelEye.com>, LKML <linux-kernel@vger.kernel.org>, ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2007-10-18 at 06:06 -0400, Jeff Garzik wrote:

> The SCSI midlayer makes a lot of "if scsi version <= 2" choices.  In the 
> case of ATAPI, we do not want to force ATAPI down the path of ancient 
> SCSI devices, as this disables some MMC features that modern ATAPI 
> devices support.

If I fully understand your point, if this faking code wasn't present,
and if the inquiry data was left as it is, all modern ATAPI devices
would be considered as really old SCSI devices. Am I right?

And then why external (FireWire and USB) devices reports the inquiry
data correctly? After all they are also considered to be SCSI devices...
 -> But apparently, from what /proc/scsi/scsi outputs, the ANSI SCSI   
    revision is set to 0 (for both ieee1394 and USB devices). This 
    seems to be coherent with what the inquiry data buffer outputs.


Also another question, more from the developer point of view, you have
to know which real interface is behind a device. You might get
performance loss if the real type is not known.

For example, I send a BLANK cdb to fully blank a disc, with the 'immed'
flag not set, so that the requested operation is processed to completion
prior to returning status.
- for real SCSI devices, this is not harmfull, as the bus is not blocked
- for IDE devices, AFAIK, the bus will be blocked until the command
termination... so for a CD erased a 1x, the bus might be blocked for
74min.


Also the SCSI commands that are sent to the device depends from its
hardware bus type. Not only for the CDB length, but also for MODE
SENSE/MODE SELECT CDBs in which for example a MODE SENSE (6) would fail
on an IDE device... even if it is described in the SPC-3 standard.

As far as I saw in libata-scsi.c there a SCSI-to-ATAPI and ATAPI-to-SCSI
translator that automatically transform the command sent... Am I also
right on this point?
    
	Mathieu

