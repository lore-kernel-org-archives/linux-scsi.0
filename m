From: Mark Hounschell <markh@compro.net>
Subject: Re: New 2.6.24.2 SG_IO SCSI problems
Date: Thu, 21 Feb 2008 11:21:40 -0500
Message-ID: <47BDA514.5050800@compro.net>
References: <47BD9588.9080803@compro.net> <1203608474.3208.10.camel@localhost.localdomain>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.compro.net ([216.54.166.4]:58766 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759603AbYBUQYi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2008 11:24:38 -0500
In-Reply-To: <1203608474.3208.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-02-21 at 10:15 -0500, Mark Hounschell wrote:
>> I seem to have run into some sort of regression in the SG_IO interface of 2.6.24.2. 
>> I have an application that up until 2.6.24 worked fine. The 2.6.23.16 kernel works fine.
>>
>> During reads I get these kernel messages. Writes and other functions _seem_ OK. Actually basic
>> reads  are working. Its with large BC reads using an io_vec list that the problem shows up.
>>
>> Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
>> Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
>> Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256
> 
> Help me a little here.  What was the io_vec and command you sent in to
> produce this?  The aic debugging information implies a single element sg
> list for a 256 byte read.
> 
> James
> 
> 
> 

Well, I did no 256 byte xfer at all.  My failing io_vec list has 6 elements.
The first 5 are for byte counts of 0xfffc and the last 0x6114. See below.

This is some debug info from within my app of the commands leading up the failure:
If you need actual values of the io_vec lists I will need to add some additional debug
info into the app. I will do if needed.

The disk BTW is formated at 768 byte sector size.
 
The first read has a 2 element io_vec list and reports no error:
ScsiDev_thread_7e00: Read CBD = 0x08 0x00 0x00 0x00 0x01 0x00
ScsiDev_thread_7e00: Read1(1) bc = 0x0078 addr = 0x000000 Skip 0
ScsiDev_thread_7e00: Read(2) bc = 0x0288 addr = 0xb6cea368 Skip 1
ScsiDev_thread_7e00: SRead  DC ops = 2 short_bc = 288

The second read has a 4 element io_vec list and reports no error:
ScsiDev_thread_7e00: Read CBD = 0x08 0x00 0x00 0x00 0x05 0x00
ScsiDev_thread_7e00: Read1(1) bc = 0x0780 addr = 0x000000 Skip 0
ScsiDev_thread_7e00: Read1(2) bc = 0x0670 addr = 0x000000 Skip 1
ScsiDev_thread_7e00: Read1(3) bc = 0x003c addr = 0x000200 Skip 0
ScsiDev_thread_7e00: SRead(4) bc = 0x022c addr = 0xb6cea368 Skip 1
ScsiDev_thread_7e00: Read  DC ops = 4 short_bc = 22c

There is a seek here that reports no error:
ScsiDev_thread_7e00: Seek address 2752 BPS 768


This read has a 6 element io_vec list and reports  the error to the app:
ScsiDev_thread_7e00: ReadX CBD = 0x28 0x00 0x00 0x00 0x27 0x52 0x00 0x01 0xcb 0x00
ScsiDev_thread_7e00: Read1(1) bc = 0xfffc addr = 0x000784 Skip 0
ScsiDev_thread_7e00: Read1(2) bc = 0xfffc addr = 0x010780 Skip 0
ScsiDev_thread_7e00: Read1(3) bc = 0xfffc addr = 0x02077c Skip 0
ScsiDev_thread_7e00: Read1(4) bc = 0xfffc addr = 0x030778 Skip 0
ScsiDev_thread_7e00: Read1(5) bc = 0xfffc addr = 0x040774 Skip 0
ScsiDev_thread_7e00: Read1(6) bc = 0x6114 addr = 0x050770 Skip 0
ScsiDev_thread_7e00: Read  DC ops = 6 short_bc = 0

ScsiDev_thread_7e00: scsi = 0x0 msg 0x0 host = 0x00000007 driver = 0x00000000
ScsiDev_thread_7e00: Read error: sns = 0x00 residual = 0x0000
ScsiDev_thread_7e00: Posting IPL status 0x00000090 0x000e0000 for Suba 0000 to loc 0x000000
ScsiDev_thread_7e00: Sleeping!!


Below is the complete dump of kernel messages for the above. I assume they are
a result of the last failing read but there is an awfull lot there just for that 6 element
io_vec list. Sorry to put all this in there but wanted to you to get the idea.


Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:03 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:03 harley kernel: sg[0] - Addr 0x03252e100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 10:51:49 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 10:51:49 harley kernel: sg[0] - Addr 0x0f156100 : Length 256

Again, sorry for all that.

regards
Mark
