From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 30 Oct 2003 12:39:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067542789.5356.4.camel@pathost1.iomegacorp.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
	 <1067531731.4250.11.camel@pathost1.iomegacorp.com>
	 <20031030091808.A6781@beaverton.ibm.com>
	 <1067535485.6411.42.camel@pathost1.iomegacorp.com>
	 <20031030100501.A7250@beaverton.ibm.com>
	 <1067541899.1141.4.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:64470 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262777AbTJ3TkH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 14:40:07 -0500
In-Reply-To: <1067541899.1141.4.camel@ronald.kuetemeier.com>
List-Id: linux-scsi@vger.kernel.org
To: ronald@kuetemeier.com
Cc: patmans@us.ibm.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> didn't work.
> 
> Applied patch (compile ...)
> reboot no 3f
> mount camera.
> file: err-pat-scsi-1.patch_messages.txt

Ouch.

> Oct 30 12:11:00 ronald kernel: usb-storage: Transport: Control/Bulk
> Oct 30 12:11:00 ronald kernel: usb-storage: Protocol: Transparent SCSI

Ouch, I came late to this thread, I hadn't seen this part before.  Here
I think we helpfully trace bInterfaceProtocol as "Transport".

Could/should usb-storage blacklist mode page x3F in bInterfaceProtocol
!= x50 BBB?

> Oct 30 12:11:00 ronald kernel: usb-storage: Command INQUIRY (6 bytes)
> Oct 30 12:11:00 ronald kernel: usb-storage:  12 00 00 00 24 00
> Oct 30 12:11:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6

Is this Talk Like Windows?

I thought Talk Like Windows rounded up to cdb length = 12 for
bInterfaceProtocol != x50 BBB?

> Oct 30 12:11:01 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
> Oct 30 12:11:01 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
> Oct 30 12:11:01 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10

Same issue, bus traces don't match, right?

Anybody got a bus trace of Windows successfully persuading this device to communicate?

Pat LaVarre


