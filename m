From: Ted.Wen@ite.com.tw
Subject: What should I return MODE_SENSE command in kernel 2.6 sd.c?
Date: Fri, 12 Mar 2004 10:25:59 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <884B07FD576C3F49938D233F0E0A2B00B92D30@itemail1.internal.ite.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bsd.ite.com.tw ([210.208.198.222]:32011 "EHLO bsd.ite.com.tw")
	by vger.kernel.org with ESMTP id S261907AbUCLC0O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 21:26:14 -0500
Received: from pms ([172.16.1.4])
	by bsd.ite.com.tw (8.8.8/8.8.8) with ESMTP id KAA16846
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2004 10:35:31 +0800 (CST)
	(envelope-from Ted.Wen@ite.com.tw)
Received: (from root@localhost)
	by pms (8.11.6/8.11.6) id i2C2MMw18707
	for linux-scsi@vger.kernel.org; Fri, 12 Mar 2004 10:22:22 +0800
Received: from itemail1.internal.ite.com.tw ([192.168.35.13])
	by pms (8.11.6/8.11.6) with ESMTP id i2C2MLu18635
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2004 10:22:22 +0800
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>   I don't know what to do while kernel 2.6 sd.c issues MODE_SENSE with modpage = 0x08.
> My driver is a card disk and  the card is removable (not  usb), and I want to work without cache.
> I can work well in kernel 2.4 but not in 2.6.
> dmesg in kernel 2.6 :
> 
>   sda: Write Protect is off
>   sda: Mode Sense : 03 10 00 00
>   sda: unknown partition table
>   Attached scsi removable disk at scsi1 channel0 id0 lun0
>   Attached scsi generic sg0 at scsi1 channel0 id0 lun0 type0
>   blk_quesu_max_hw_segments: set to minimum 1
> 
> switch (SCpnt ->cmnd)
> {
>       unsigned char *buf = SCpnt->buffer;
>       unsigned char *cmd = SCpnt->cmnd;
> ...
> ...
>       case MODE_SENSE:
> 	modpage = (cmd & 0x3F);
> 	if (modpage == 0x08)  // add in kernel 2.6 for modpage = 0x08..
> 	{
> 		I don't know what to do.....
>  	}
> 
> 	else
> 	{
> 		buf[0] = 0x03; // Mode Data Length
> 		buf[1] = 0x10; 
> 		if (!CardIsWriteProtected)
> 		{
> 			buf[2] = 0x00;
> 		}
> 			else
> 		{
> 			buf[2] = 0x80;
> 		}
> 		SCpnt->result = (DID_OK << 16);
> 	}
> }
> 
