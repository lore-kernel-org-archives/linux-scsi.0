From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: scsi timeout questions
Date: Mon, 23 Sep 2002 12:42:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3679966B84813344B908D418BA3F6A4AA83FD2@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, "Mukker, Atul" <atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

In the new error handling code(lk-2.4.x) the commands for which the timer have already fired are thrown away by the scsi mid layer.During the error recovery if the low level driver abort handler reports "SUCCESS" ie it aborted the command  then the command is retried by the mid layer
otherwise it elevates it to the next level ie it will come down to the low level driver with the device reset if the driver supports it.......

Note: In the new error handling the status that low level error routines(eh_abort,eh_device_reset,etc) reports back is either
SUCCESS or FAILURE.


Ravi
-----Original Message-----
From: Mike Anderson [mailto:andmike@us.ibm.com]
Sent: Monday, September 23, 2002 8:43 AM
To: Mukker, Atul
Cc: linux-scsi@vger.kernel.org
Subject: Re: scsi timeout questions


Mukker, Atul [atulm@lsil.com] wrote:
> new error handling?
> 
Unless I am looking at older versions of megaraid.[ch] in 2.4.20-pre5 this driver is
using the older error handler interfaces. The newer version of the error
handler (which is not that new anymore) is described at Eric Youngdale's
site http://www.andante.org/scsi_error.html. In 2.5 only the new version
of the error handler is supported.

-andmike
--
Michael Anderson
andmike@us.ibm.com

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
