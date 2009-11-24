From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Tue, 24 Nov 2009 19:47:12 +0200
Message-ID: <4B0C1C20.2080901@panasas.com>
References: <Pine.LNX.4.44L0.0911241111410.2881-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:13489 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933543AbZKXRrK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 12:47:10 -0500
In-Reply-To: <Pine.LNX.4.44L0.0911241111410.2881-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: tmhikaru@gmail.com, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org

On 11/24/2009 07:16 PM, Alan Stern wrote:
> On Mon, 23 Nov 2009 tmhikaru@gmail.com wrote:
> 
>> Thank you. I've gotten output of it screwing up, but it's a 62MB file. I
>> don't think I'm allowed to send attachments here, nor do I know what I'm
>> supposed to be looking for in this output. So, instead I'm putting the
>> (compressed) file up on my home computer. If you've got suggestions for what
>> I should use instead, let me know.
>>
>> http://hikaru.no-ip.info:3000/1.mon.out.xz
>>
>> Although I don't think you'll need it, I've included the dmesg output of
>> what happened when I ran my backup script, just in case it helps at all.
> 
> Here's an annotated example of one of those hiccups:
> 
> f1aa1f00 2416018820 S Bo:1:003:1 -115 31 = 55534243 07050100 00100000 80000a28 000000ae ef000008 00000000 000000
> f1aa1f00 2416018929 C Bo:1:003:1 0 31 >
> 
> The computer issued a READ command for 8 blocks (4096 bytes) starting
> at block number 0x0000aeef = 44783.
> 
> d2588b00 2416019342 S Bi:1:003:2 -115 4096 <
> d2588b00 2416019428 C Bi:1:003:2 -32 0
> f1aa1f00 2416019435 S Co:1:003:0 s 02 01 0000 0082 0000 0
> f1aa1f00 2416019554 C Co:1:003:0 0 0
> 
> The drive returned 0 bytes of data.
> 
> f1aa1f00 2416019560 S Bi:1:003:2 -115 13 <
> f1aa1f00 2416019678 C Bi:1:003:2 0 13 = 55534253 07050100 00100000 00
> 
> And then it returned a status indicating no error but 4096 bytes
> residue (i.e., incorrect or undelivered data).  This caused the
> usb-storage driver to send the SCSI layer a result code of DID_ERROR
> with no sense data.
> 
>> sd 0:0:0:0: [sda] Unhandled error code
>> sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>> end_request: I/O error, dev sda, sector 44783
> 
> The DID_ERROR code caused the SCSI layer to display this error message.  
> 
>> sd 0:0:0:0: [sda] Unhandled error code
>> sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>> end_request: I/O error, dev sda, sector 51823
> 
> I would have expected the READ to be retried, but in these two cases 
> it wasn't.  The usbmon log contained five instances of this error 
> sequence; the other three were retried successfully.  I don't know what 
> the difference was.
> 

Perhaps the time it took to complete.

I have a very old IDE disk connected to a USB box here, and some bad sectors take ages
to return. One thing I wanted to investigate is why the complete Linux system is frozen
for minutes when I "cp" one of these bad-sectors and then every thing is back to normal.
It's just an inserted external box. Swap system and everything is on an another healthy HD.
As if the USB controller actually locks the PCI bus, or the interrupts are off for a long
while. (Or is it the BKL?)

Do you have time stamps on these?

> Alan Stern
> 

Boaz
