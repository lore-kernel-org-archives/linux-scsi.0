From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: memory leak while reading /proc/scsi/gdth/1
Date: Thu, 29 Apr 2004 16:51:32 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040429195132.GC20141@logos.cnet>
References: <20040428111004.78451.qmail@web41208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:48345 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264940AbUD2TuW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Apr 2004 15:50:22 -0400
Content-Disposition: inline
In-Reply-To: <20040428111004.78451.qmail@web41208.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Pierre Berthier <berthierp@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 28, 2004 at 04:10:04AM -0700, Pierre Berthier wrote:
> 
> Dear Linux-SCSI people,
> 
> I noticed a bug in the driver for GDT controler.  It seems to me to be a kind
> of memory leak, but I am not an expert.  Here is my bug report. 
> 
> Pierre
> 
> 
> [1.] One line summary of the problem:    
> 
> 'cat /proc/scsi/gdth/1' prints two "__alloc_pages: 0-order allocation failed
> (gfp=0x21/0)" lines in the log.
> 
> [2.] Full description of the problem/report:
> 
> I am reading every two minutes the content of '/proc/scsi/gdth/1' to produce a
> 'status report' of my server.  After doing a 'cat /proc/scsi/gdth/1' ~3300
> times without problem, each subsequent call prints two lines "__alloc_pages:
> 0-order allocation failed (gfp=0x21/0)" in the log.  In this case, the result
> is only:
> 
> # cat /proc/scsi/gdth/1 
> Driver Parameters:
>  reserve_mode:  1               reserve_list:   --
>  max_ids:       127             hdr_channel:    0
> 
> Disk Array Controller Information:
>  Number:        0               Name:           GDT6513RS
>  Driver Ver.:   2.05            Firmware Ver.:  2.28.02-R044
>  Serial No.:    0x44C175F1      Cache RAM size: 131072 KB
> 
> Physical Devices:
> 
> without the list of disks, volumes, etc.
> 
> During this, the machine works as good as usually.  After the log message
> appears, if one goes on reading the proc file ~1000 times, the machine finally
> hangs.  The problem arises using kernel from 2.4.23 to 2.4.26.  No problems
> with kernel 2.4.21 (uptime up to 100+ days) -- at least no messages in the log,
> I think that I remember that the output was also disappearing after some time. 
> I did not try 2.4.22.

Hi Pierre, 

Very nice bug report, thanks.

Ill take a look at 2.4.23->2.4.26 changes. In the meantime can you 
turn VM debugging on

# echo 1 > /sys/vm/vm_gfp_debug

and run "cat /proc/scsi/gdth/1" ? 

There should be some backtraces in dmesg. Copy them (the full output), 
and run then through ksymoops (using the System.map for this kernel).

Thanks!
