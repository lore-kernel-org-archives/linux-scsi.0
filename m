From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Wed, 21 May 2003 13:28:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030521202809.GA1791@beaverton.ibm.com>
References: <3ECA9D46.7010301@rogers.com> <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org> <20030521180308.GD1116@beaverton.ibm.com> <3ECBD122.3090702@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:64679 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262108AbTEUUNB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 16:13:01 -0400
Content-Disposition: inline
In-Reply-To: <3ECBD122.3090702@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org

Luben Tuikov [tluben@rogers.com] wrote:
> >+static inline unsigned long scsi_get_next_serial(struct Scsi_Host *shost)
> >+{
> >+        return (++shost->serial_number) ? shost->serial_number : 1;
> >+}
> >+
> 

There is a bug in the above line it should be 
return (++shost->serial_number) ? shost->serial_number : ++shost->serial_number;

> scsi_get_next_serial()???  Do _you_ Mike like this name?
> 
No.

> scsi_get_cmdsn()  will be a lot more appropriate.  It doesn't
> reveal implementation (``next''), and tells that it's a serial
> number for a command, ``sn'' stands for serial number pretty
> universally in our society.
> 

This name is ok with me.

> How about something like this:
> 
> static inline unsigned long scsi_get_cmdsn(struct Scsi_Host, *shost)
> {
> 	static const typeof(shost->serial_number) MAX_SN = 
> 		~((typeof(shost->serial_number) 0);
> 	return  shost->serial_number++ == MAX_SN ?
> 		++shost->serial_number : shost->serial_number;
> }
> 

Why compare with MAX_SN and not just let the value role over and check
for false. 

> BTW, are you relying on memset(..., 0, sizeof(struct Scsi_Host),
> to set the serial number to 0?

Yes I was.

-andmike
--
Michael Anderson
andmike@us.ibm.com

