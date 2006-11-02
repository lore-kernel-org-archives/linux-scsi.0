From: Douglas Gilbert <dougg@torque.net>
Subject: Re: non-zero result with NO_SENSE
Date: Thu, 02 Nov 2006 11:10:16 -0500
Message-ID: <454A1868.9080507@torque.net>
References: <20061102142859.93227.qmail@web31007.mail.mud.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61613 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751541AbWKBQKL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Nov 2006 11:10:11 -0500
In-Reply-To: <20061102142859.93227.qmail@web31007.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurie Costello <lmcostello@yahoo.com>
Cc: linux-scsi@vger.kernel.org

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
