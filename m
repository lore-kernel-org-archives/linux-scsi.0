From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: 21 May 2003 17:19:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053551960.1805.8.camel@mulgrave>
References: <3ECA9D46.7010301@rogers.com>
	<Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org>
	<20030521180308.GD1116@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:2052 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262360AbTEUVG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 17:06:57 -0400
In-Reply-To: <20030521180308.GD1116@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Luben Tuikov <tluben@rogers.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-05-21 at 14:03, Mike Anderson wrote:
> This patch is against scsi-misc-2.5 but also applies against 2.5.69.
> 
> Move scsi command serial number to per scsi host serial number. We also
> only increment the serial number under a lock now so the race on the value
> is removed. A new serial number is also acquired in the scsi_error handler
> on new commands.

This patch looks OK to me, except that I don't see a good reason to go
to a per host serial number.  The SCSI commands are so short lived that
the current global serial number seems adequate (and saves us 4 bytes
per device).

On locking grounds, though it does look better to move it into the host
structure (probably make explicit by documenting that the host lock
needs to be held accessing the method).

This:

+static inline unsigned long scsi_get_next_serial(struct Scsi_Host
*shost)
+{
+        return (++shost->serial_number) ? shost->serial_number : 1;
+}
+

Will hand out two 1 serial numbers when we start at zero or wrap.

Shouldn't that be

static inline unsigned long scsi_get_next_serial(struct Scsi_Host
*shost)
{
	if(++shost->serial_number == 0)
		++shost->serial_number;

        return shost->serial_number;
}

?

James


