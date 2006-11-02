From: Laurie Costello <lmcostello@yahoo.com>
Subject: Re: non-zero result with NO_SENSE
Date: Thu, 2 Nov 2006 08:58:25 -0800 (PST)
Message-ID: <20061102165825.28759.qmail@web31005.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31005.mail.mud.yahoo.com ([68.142.200.168]:33921 "HELO
	web31005.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750704AbWKBQ60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2006 11:58:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

I understand this for the case of RECOVERED_ERROR.  But for the
case of NO_SENSE the driver didn't supply any extra information with 
the failure.  Why does this code assume the request completed okay?
good_bytes is set to 0 based on the non-zero result in the scsi_cmnd
result field. Then its reset based on NO_SENSE.   Not returning more 
sense information would be poor driver behavior but changing result to 0 
seems dangerous. 
Laurie

----- Original Message ----
From: Douglas Gilbert <dougg@torque.net>
To: Laurie Costello <lmcostello@yahoo.com>
Cc: linux-scsi@vger.kernel.org
Sent: Thursday, November 2, 2006 10:10:16 AM
Subject: Re: non-zero result with NO_SENSE

Laurie Costello wrote:
> I'm researching a problem with data corruption on linux 2.6.9.
> 
> I'm seeing results of scsi_print_sense() in the system log, which brought me
> 
> to this chunk of code.  Is it correct to process a non-zero result with
> 
> NO_SENSE as if an error didn't occur or was recovered?

Laurie,
Well it isn't ideal obviously. The problem is that sd
sits between a SCSI direct access device and the SCSI
block subsystem. SCSI devices try and be helpful and
tell the application client things like: the data was
read but required 3 retries and ECC. The block layer
is only interested in errors that impact the current
IO, so sd has no slot to file these warnings in, apart
from the system log. There was some proposal about
logging such errors and warning (but where to store
the log :-) ) and disks already do a fair amount of
logging themselves.

Even more worrying are deferred errors. Something like
a cached write that at some later time gets an IO error
when the disk tries to write its cache to the media.
This should become a more interesting area as disks get
larger non-volatile caches.

There are tools such as smartmontools that can monitor
the health of disks.

Doug Gilbert





