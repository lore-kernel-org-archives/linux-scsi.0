From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg_io_hrd_t - host_status error (0x05)
Date: Sat, 24 Apr 2004 13:47:52 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4089E368.5040002@torque.net>
References: <20040423031108.68982.qmail@web40001.mail.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:17669 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261891AbUDXDrn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Apr 2004 23:47:43 -0400
In-Reply-To: <20040423031108.68982.qmail@web40001.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Liong Hoong <liongshliongsh@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Liong Hoong wrote:
> Hi all,
> 
> I have set up the main control structure for the
> version 3 SCSI generic driver. I am trying to send
> down some opcodes (vendor specific) to a usb mass
> storage device. Found that I encountered host_status
> error, SG_ERR_DID_ABORT whenever I send opcodes from
> 0x80 to 0x9f, but encountered no errors with other
> opcodes. 
> 
> The errors occured even without the device plugged in,
> which seem the sg driver has exclusively blocked the
> opcodes from 0x80 to 0x9f. Is it true?? Is there any
> work around for this??
> 
> Is it because of Group 4 (0x80 to 0x9f) need 16 bytes
> of cdb length? But even I prepare the cdb of 16 bytes,
> it also failed. 
> 
> I am using red hat 8.0, 2.4.18. 

The scsi subsystem mid level allowed 16 byte cdbs through
from and including lk 2.4.15 . The sg driver allows them
through. That leaves the usb-storage driver (and drivers
further down the USB stack) and the device itself as the
cause of your problem.

Doug Gilbert

