From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: QLA2200 causes kernel bug
Date: Fri, 7 Aug 2009 00:01:47 -0700
Message-ID: <20090807070147.GA13292@plap4-2.local>
References: <6e4c20e70908060828xd4a6a8fh801e1d456c39a5f@mail.gmail.com> <20090806164925.GO2453@plap4-2.local> <6e4c20e70908061012y3fa907aduca4f706cf5ccaa5a@mail.gmail.com> <6e4c20e70908062040x39d8d0b3p90e674ec5925c5ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:18294 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbZHGHBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 03:01:47 -0400
Content-Disposition: inline
In-Reply-To: <6e4c20e70908062040x39d8d0b3p90e674ec5925c5ac@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Georgiou <tageorgiou@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 06 Aug 2009, Thomas Georgiou wrote:

> Here is a new log with error logging enabled:
> http://www.tjhsst.edu/~2010tgeorgio/fclogs/dmesg4.log
> 
> The enclosures do not have conflicting scsi ids.
> 

Could you let me know what's going on at timestamp - 1840:

	[  883.659657] bonnie++ used greatest stack depth: 3472 bytes left
	[ 1840.109135] scsi(1): Asynchronous LIP RESET (f8f7).
	[ 1840.109141] qla2xxx 0000:0a:01.0: LIP reset occurred (f8f7).
	[ 1840.109477] scsi(1): qla2x00_reset_marker()
	[ 1840.150025] scsi(1): fcport-0 - port retry count: 0 remaining
	[ 1840.150030] scsi(1): fcport-1 - port retry count: 0 remaining
	[ 1840.150034] scsi(1): fcport-2 - port retry count: 0 remaining
	[ 1840.150037] scsi(1): fcport-3 - port retry count: 0 remaining
	...
	[ 1840.150113] scsi(1): fcport-26 - port retry count: 0 remaining
	[ 1840.150116] scsi(1): fcport-27 - port retry count: 0 remaining
	[ 1840.203564] scsi(1): LIP occurred (f7f7).
	[ 1840.203569] qla2xxx 0000:0a:01.0: LIP occurred (f7f7).
	[ 1840.234308] scsi(1): Asynchronous PORT UPDATE.
	[ 1840.234313] scsi(1): Port database changed b88f 0000 003f.
	[ 1841.100044]  rport-1:0-0: blocked FC remote port time out: removing target and saving binding
	[ 1841.100101] qla2x00_mailbox_command(1): **** FAILED. mbx0=4006, mbx1=12, mbx2=ffff, cmd=71 ****
	[ 1841.100107] qla2x00_fabric_logout(1): failed=102 mbx1=12.

there's seems to be a great deal of fabric disruptions occuring on the
fibre.  This seems to be occurring on both 22xx ports.  It also
appears that you've set port-down-timeout (dev-loss-tmo) to 0 seconds
(for faster failovers)?

Could you describe the topology?  Would it be possible to isolate the
faults, I take it the constant stream of RESETs are not expected?

-- av
