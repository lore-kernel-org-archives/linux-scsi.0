From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Tue, 26 Oct 2004 10:43:01 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410261040410.1300-100000@ida.rowland.org>
References: <417D7617.3030005@micro.ee.nthu.edu.tw>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1796 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262286AbUJZOnP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 10:43:15 -0400
In-Reply-To: <417D7617.3030005@micro.ee.nthu.edu.tw>
List-Id: linux-scsi@vger.kernel.org
To: Darsen <darsen@micro.ee.nthu.edu.tw>
Cc: Adriaan Penning <a.penning@luon.net>, Eero Volotinen <eero@ping-viini.org>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 26 Oct 2004, Darsen wrote:

> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command READ_CAPACITY (10 bytes)
> usb-storage:  25 00 00 00 00 00 00 00 00 00
> usb-storage: Bulk Command S 0x43425355 T 0x3 L 8 F 128 Trg 0 LUN 0 CL 10
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
> usb-storage: Status code 0; transferred 8/8
> usb-storage: -- transfer complete
> usb-storage: Bulk data transfer result 0x0
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result = 0
> usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
> usb-storage: scsi cmd done, result=0x0
> usb-storage: *** thread sleeping.

The original READ CAPACITY command worked okay.

> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command READ_CAPACITY (10 bytes)
> usb-storage:  25 00 00 03 d7 ff 00 00 01 00
> usb-storage: Bulk Command S 0x43425355 T 0x4 L 8 F 128 Trg 0 LUN 0 CL 10
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
> usb-storage: command_abort called
> usb-storage: usb_stor_stop_transport called
> usb-storage: -- cancelling URB
> usb-storage: Status code -104; transferred 0/8
> usb-storage: -- transfer cancelled
> usb-storage: Bulk data transfer result 0x4
> usb-storage: -- command was aborted
> usb-storage: usb_stor_Bulk_reset called
> usb-storage: usb_stor_control_msg: rq=ff rqtype=21 value=0000 index=00 len=0
> usb-storage: Timeout -- cancelling URB
> usb-storage: Soft reset failed: -104
> usb-storage: scsi command aborted
> usb-storage: *** thread sleeping.

The version with PMI set crashed the device.  Not even a bus reset cleared 
the error condition (not shown above but it's in the original log).  So 
this approach is unacceptable.

Alan Stern

