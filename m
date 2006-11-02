From: Douglas Gilbert <dougg@torque.net>
Subject: Re: non-zero result with NO_SENSE
Date: Thu, 02 Nov 2006 14:06:01 -0500
Message-ID: <454A4199.4070705@torque.net>
References: <20061102165825.28759.qmail@web31005.mail.mud.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42666 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1752264AbWKBTF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Nov 2006 14:05:57 -0500
In-Reply-To: <20061102165825.28759.qmail@web31005.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurie Costello <lmcostello@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Laurie Costello wrote:
> I understand this for the case of RECOVERED_ERROR.  But for the
> case of NO_SENSE the driver didn't supply any extra information with 
> the failure.  Why does this code assume the request completed okay?

Laurie,
By my reading of that logic, if the response code is
0x70, 0x71, 0x72 or 0x73 then the sense buffer will
be printed to the log in the case when the sense_key
is RECOVERED_ERROR or NO_SENSE.

The sort of sense messages that come through with
a valid response code and a sense_key of NO_SENSE
are informational exceptions (when MRIE=5 or 6) **.
The block layer isn't interested (but the user might
be). A properly set up smartd (from smartmontools)
should be sending automatically generated emails
to system administrators in such cases.


** REQUEST SENSE is the command that receives
a sense_key of NO_SENSE in its data in buffer.
The interesting cases are when the asc/ascq codes
are non-zero. I'm not sure the sd driver ever issues
a REQUEST SENSE command.

BTW There is another (lower) level of sense data
checking in scsi_decide_disposition() found in
the scsi_error.c file and belonging to the SCSI
mid level code.

> good_bytes is set to 0 based on the non-zero result in the scsi_cmnd
> result field. Then its reset based on NO_SENSE.   Not returning more 
> sense information would be poor driver behavior but changing result to 0 
> seems dangerous.

As far as I can tell the SG_IO ioctl applied to a
scsi disk device node (e.g. /dev/sda) does _not_
take the code path that you showed. That leaves
mounted file systems and commands like dd using
that code via the block layer.

Do you have a suggestion of what you would prefer
to happen?

Doug Gilbert

> ----- Original Message ----
> From: Douglas Gilbert <dougg@torque.net>
> To: Laurie Costello <lmcostello@yahoo.com>
> Cc: linux-scsi@vger.kernel.org
> Sent: Thursday, November 2, 2006 10:10:16 AM
> Subject: Re: non-zero result with NO_SENSE
> 
> Laurie Costello wrote:
>> I'm researching a problem with data corruption on linux 2.6.9.
>>
>> I'm seeing results of scsi_print_sense() in the system log, which brought me
>>
>> to this chunk of code.  Is it correct to process a non-zero result with
>>
>> NO_SENSE as if an error didn't occur or was recovered?
> 
> Laurie,
> Well it isn't ideal obviously. The problem is that sd
> sits between a SCSI direct access device and the SCSI
> block subsystem. SCSI devices try and be helpful and
> tell the application client things like: the data was
> read but required 3 retries and ECC. The block layer
> is only interested in errors that impact the current
> IO, so sd has no slot to file these warnings in, apart
> from the system log. There was some proposal about
> logging such errors and warning (but where to store
> the log :-) ) and disks already do a fair amount of
> logging themselves.
> 
> Even more worrying are deferred errors. Something like
> a cached write that at some later time gets an IO error
> when the disk tries to write its cache to the media.
> This should become a more interesting area as disks get
> larger non-volatile caches.
> 
> There are tools such as smartmontools that can monitor
> the health of disks.
> 
> Doug Gilbert
> 
> 
> 
> 
> 
> 

