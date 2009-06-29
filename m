From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux doesn't support bigger than 2TB IEEE-1394 disk
Date: Mon, 29 Jun 2009 20:32:36 +0200
Message-ID: <4A4908C4.1070705@s5r6.in-berlin.de>
References: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw>	 <49FEFF7A.3090603@s5r6.in-berlin.de> <1241448686.3315.27.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55991 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZF2SdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 14:33:00 -0400
In-Reply-To: <1241448686.3315.27.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ronald <Ronald@ioi.com.tw>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

James Bottomley wrote on 2009-05-04:
> On Mon, 2009-05-04 at 16:45 +0200, Stefan Richter wrote:
>> Ronald wrote at linux1394-user:
>>> Linux doesn't support bigger than 2TB IEEE-1394 disk.
>>>
>>> Will Linux have new driver for this issue?
>> (Adding Cc: linux-scsi)
>>
>> As far as I can tell, Linux does support IEEE 1394 disks of any size. 
>> However, if I'm not mistaken, disks larger than 2 TB require that the 
>> READ CAPACITY (16) command is used to check the disk's capacity, rather 
>> than the usual READ CAPACITY (10) command.  Somebody correct me if I'm 
>> wrong.
>>
>> By far most firmwares of IEEE 1394/ SBP-2 chipsets implement only the 
>> RBC (Reduced Block Commands) command set specification, or at least 
>> claim so in their INQUIRY response.  If I understood correctly, the 
>> Linux SCSI stack will never send READ CAPACITY (16) to them since this 
>> command is not included in RBC.
> 
> That's true ... but not quite the way we work.  There's a standard
> defined return for READ CAPACITY(10) which means ... I have more
> sectors, please use READ CAPACITY (16).  If we get that return, we'll
> try again with READ CAPACITY (16) regardless of whether the device says
> it's only RBC or not.

I obviously missed one other fact:

Initiator drivers need to tell the Linux SCSI core what the maximum 
length of commands is that the driver is able to send to targets.  Alas 
our SBP-2 drivers do not specifiy a value for this (struct 
Scsi_Host.max_cmd_len) and hence the core will send at most 12 bytes 
long command blocks.  But for disks > 2TB, we need 16 bytes long command 
blocks.

I need to fix the SBP-2 drivers to set the limit correctly.  This will 
be a little more than one-liners though, I guess, because we need to 
check a target capability datum before we set the length limit.

Stay tuned.
-- 
Stefan Richter
-=====-==--= -==- ===-=
http://arcgraph.de/sr/
