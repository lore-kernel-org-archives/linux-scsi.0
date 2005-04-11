From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Fw: [Bugme-new] [Bug 4473] New: QLogic 2100: SCSI timeouts, device resets, and crashes kernel
Date: Mon, 11 Apr 2005 15:15:08 -0700
Message-ID: <20050411221508.GH4449@plap.qlogic.org>
References: <20050411135132.13b258dd.akpm@osdl.org> <20050411211829.GA822@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:45392 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261960AbVDKWPR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 18:15:17 -0400
Content-Disposition: inline
In-Reply-To: <20050411211829.GA822@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregsurbey@hotmail.com
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>

On Mon, 11 Apr 2005, Mike Anderson wrote:

> I will add the same comment to the bug.
> 
> Did this work on a previous version of the kernel? Just checking to
> understand if your connectivity to the storage unit or the unit itself
> could be an issue.
> 
> If appears we are receiving timeouts, but on abort the qla is indicating
> that the IO has already been completed. We could have IOs that are taking
> near max timeout and then the error handler races with the completion of
> the IO.
> 
> A debug step you could try is to raise the default timeout from 30 to
> something like 60 seconds to see if this effects the error. To do this
> just echo "60" > /sys/block/sd${N}/device/timeout. Also you can run iostat
> during your testing to see what you IO times / queue depths look like.
> 
> Andrew Vasquez may be able to add more info.
> 

Greg,

The logs seem to indicate some (additional) problems with the ISP
after the device-reset completes:

	qla2100 0000:00:06.0: scsi(0:0:1:0): DEVICE RESET ISSUED.
	qla2100 0000:00:06.0: scsi(0:0:1:0): DEVICE RESET SUCCEEDED.
	qla2100 0000:00:06.0: ISP System Error - mbx1=7737h mbx2=dc5h mbx3=0h.
	qla2100 0000:00:06.0: Firmware dump saved to temp buffer (0/dcec0000).

there is a small tool availble (qla_dmp.sh):

ftp://ftp.qlogic.com/outgoing/linux/beta/8.x/test/qla_dmp.sh

which I'd like you to use if the machine is still in a somewhat usable
state and you see a message similar to the following:

	qla2100 0000:00:06.0: ISP System Error - mbx1=7737h mbx2=dc5h mbx3=0h.
	qla2100 0000:00:06.0: Firmware dump saved to temp buffer (0/dcec0000).

Execute the following command:

	# ./qla_dmp.sh 0

The value passed to qla_dmp.sh should be the same as the first integer
in the 'saved to temp buffer' string (in this example, 0).  If the
operation was successful, a message like to following should be logged
in the messages file.

        Firmware dumped to file fw_dump_20041217_023222.txt

compress the file (in this example):

        # bzip2 fw_dump_20041217_023222.txt

and forward over the compressed file in addition to the
var/log/messages file.

--
av
