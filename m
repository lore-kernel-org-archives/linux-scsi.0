From: Douglas Gilbert <dougg@torque.net>
Subject: Re: convert 520 byte sector disk to 512 byte sector?
Date: Tue, 10 Jun 2003 11:53:56 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE53A34.7070503@torque.net>
References: <20030609174647.GB29808@cup.hp.com> <20030609122907.A16169@beaverton.ibm.com> <20030609223905.GH29808@cup.hp.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:11538 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262456AbTFJBlI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 21:41:08 -0400
In-Reply-To: <20030609223905.GH29808@cup.hp.com>
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <iod00d@hp.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Grant Grundler wrote:
> On Mon, Jun 09, 2003 at 12:29:07PM -0700, Patrick Mansfield wrote:
> 
>>I did this for some Seagate FC drives (don't have the exact model numbers
>>handly), but don't have my hacks, and can't find details of my results. I
>>used the same thing you have in your code - set the "direct access device
>>mode paramter block descriptor"'s block length (versus the more obvious
>>data bytes per physical page), and then formatted the drive.
> 
> 
> thanks - that's good to know that at least I'm banging my head
> bloody against the right wall. I suspect the data isn't going
> out to the device like it's supposed too. But I'm not seeing
> the problem with the code.
> 
> 
>>Did you try setting the data bytes per physical page?
> 
> 
> I think so. But I recall checking the "Mask" data for the format mode
> page and it shows nothing on the page can be modified.
> Here's the blk512-linux output for that device:
> 
> iota:/home/grundler/Src# ./blk512-linux -MS -c 71132960  /dev/sg15
> 
> Mode Sense Mask:
> 
> 0x0000:   23 00 10 08 04 2c 1d 80  00 00 02 08 83 16 00 00
> 0x0010:   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> 0x0020:   00 00 00 00
> 
> Mode Sense Saved:
> 
> 0x0000:   23 00 10 08 04 2c 1d 80  00 00 02 08 83 16 24 54
> 0x0010:   00 00 00 14 00 00 02 31  02 08 00 01 00 88 00 60
> 0x0020:   40 00 00 00
> 
> Mode Sense Current:
> 
> 0x0000:   23 00 10 08 04 2c 1d 80  00 00 02 08 83 16 24 54
> 0x0010:   00 00 00 14 00 00 02 31  02 08 00 01 00 88 00 60
> 0x0020:   40 00 00 00
> 
> Mode Sense Default:
> 
> 0x0000:   23 00 10 08 04 2c 1d 80  00 00 02 08 83 16 24 54
> 0x0010:   00 00 00 14 00 00 02 3d  02 00 00 01 00 88 00 60
> 0x0020:   40 00 00 00
> 
> Mode Select Data:
> 
> 0x0000:   00 00 00 08 04 3d 67 20  00 00 02 00
>         mlen 0xc  resid 0x0 duration 0  info 0x0
> Done setting /dev/sg15 to 71132960 blocks/512 bytes_per_block
> iota:/home/grundler/Src# 
> 
> 
> 
>>So the MODE SENSE format device page (0x3) "data bytes per physical
>>sector" does _not_ show 512 bytes after you send the MODE SELECT format
>>device page? That is what I (eventually) saw.
> 
> 
> correct. I was expecting it show "02 00" in the "current" page if I run
> the command a second time or run "scsiinfo -f".
> 
> 
> 
>>Did you format the drive after changing the block size?
> 
> 
> No. I will When the MODE SENSE for page 3 shows 512 bytes/block.
> 
> 
> 
>>Are you sure the mode select is really working in your code?
> 
> 
> I have no way of knowing other then device/driver return codes.
> And since I don't have a FC protocol analyzer, i need help
> to figure out if it's just something silly I'm doing wrong.
> 
> It's quite possible the qlogic driver is mangling the command
> and/or return values. I'm using qla2300 v6.04.00 with qla2312 chip.
> 
> I think the current code is sending "default" page data
> for the MODE SELECT. I might try updating the MODE SELECT data
> and verify no extra bits are set in the "descriptor" header.
> 
> 
>>I suppose there are no other format page values you can change.
> 
> 
> The device claims there are none.
> 
> 
> 
>>I can't remember when the MODE SENSE format page showed the modified block
>>size for me - I believe it was after the MODE SELECT format page, rather
>>than after the FORMAT command itself.
> 
> 
> yes - that's what I'm expecting. The format command should use the
> settings in the "current" page. ergo one should be able to read/write the
> contents of the page before issuing format command.

Grant,
www.seagate.com have a tool called "seatool" that may
do the trick for you.

Doug Gilbert


