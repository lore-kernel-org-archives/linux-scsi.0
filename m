From: "Mukker, Atul" <atulm@lsil.com>
Subject: RE: scsi timeout questions
Date: Sat, 21 Sep 2002 13:04:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57A8B499@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mhbs.lsil.com (mhbs [147.145.31.100])
	by mail2.lsil.com (8.12.4/8.12.4) with ESMTP id g8LGq6KB007945
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2002 10:05:11 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Anderson' <andmike@us.ibm.com>, "Mukker, Atul" <Atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

new error handling?

Thanks
-Atul

-----Original Message-----
From: Mike Anderson [mailto:andmike@us.ibm.com]
Sent: Thursday, September 19, 2002 4:09 PM
To: Mukker, Atul
Cc: linux-scsi@vger.kernel.org
Subject: Re: scsi timeout questions


Mukker, Atul [atulm@lsil.com] wrote:
> Hi All,
> 
> How can the default timeout value changed for scsi commands, per command
> basis. Under certain circumstances ( e.g., rebuild and/or check
consistency
> on logical drives + heavy IO ), the megaraid F/W is not able to complete
the
> commands in default timeout period ( 60 seconds in 2.4.18-3) kernel.
> 

sd and sr do not allow there timeouts to be altered from there #define
values. st and sg allow there timeouts to be altered, but it applies to
all commands for that device. Altering the timeout on the fly somewhat
defeats a timeout value for the upper layers.

> Also, what is the expected behavior of the driver for aborted commands.
The
> commands which have been issued to f/w and are pending, the abort handler
> returns "cannot abort". If such commands are later completed by the
> firmware, the ISR completes the command with DID_ABORT. Is it ok?
> 

It appears from reading scsi_old_timesout that this stops furthur error
recovery and leaves the command in the host adapter with no timeout
running. The side effect of returning DID_ABORT in scsi_old_done appears
to be ok. I believe (if I followed the old error handler chain
correctly) you will not retry the command and it will be failed back to
the block layer.

-andmike
-- 
Michael Anderson
andmike@us.ibm.com
