From: Erez Zilber <erezz@Voltaire.COM>
Subject: Re: usage of max_sectors in scsi_host_template
Date: Wed, 07 Nov 2007 16:46:57 +0200
Message-ID: <4731CFE1.1070904@Voltaire.COM>
References: <47304E70.9090005@Voltaire.COM> <4730B359.8020806@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:19868 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753376AbXKGOq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Nov 2007 09:46:59 -0500
In-Reply-To: <4730B359.8020806@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

Stefan Richter wrote:
>
> Erez Zilber wrote:
> > I'm not sure that I understand the meaning of max_sectors in
> > scsi_host_template.
>
> Did you have a look at scsi_mid_low_api.txt?
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/scsi/scsi_mid_low_api.txt;h=6f70f2b9327e1f0db7bc05bdbf2d6ce3b2fcbdcf#l1232
>

I will go over it. Thanks for the link.

> > Is it the maximum data length of a single SCSI command?
>
> Yes.
>
> > Is it in bytes?
>
> No, it is in units of 512 bytes.
>
> > What's the size of a sector?
>
> "Usually" 512 bytes according to above doc.  Always 512 bytes from the
> point of view of block/ll_rw_blk.c::blk_queue_max_sectors().
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=block/ll_rw_blk.c;h=75c98d58f4ddf7252e2717e0924b9d6a8925b4e5#l590
>

So, ll_rw_blk actually uses the max_sectors value to chop requests 
larger than max_sectors. Am I right? If yes, I have a problem:

I'm running sgp_dd (on RHAS 4 up4 - kernel version is 2.6.9), so it 
calls scsi-ml directly (without going through ll_rw_blk). I ran it with 
the following parameters:

sgp_dd bs=512 of=/dev/null if=/dev/sg1 bpt=2048 thr=4 time=1 count=100k 
deb=9

I see that a single 1MB command is generated. Here's the debug info from 
sgp_dd:

sgp_dd: if=/dev/sg1 skip=0 of=/dev/null seek=0 count=102400
Start of loop, count=102400, in_num_sect=0, out_num_sect=0
Starting worker thread k=0
sg_start_io: SCSI READ, blk=0 num_blks=2048
Read (10) [28 00 00 00 00 00 00 08 00 00 ]
dir=-3, len=1048576, dxfrp=0x2a9558a000, cmd_len=10

Now, the low-level driver below scsi-ml is open-iscsi over iSER. 
max_sectors is set to 1024 (i.e. 512 kB). Still, the iSER driver 
receives a 1MB command. I guess that the max_sectors value is never 
used. Am I right?

Thanks,
Erez
