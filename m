From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sym53c8xx2: incredible sloth after parity error / SCSI bus
 reset
Date: Thu, 6 Dec 2007 14:31:30 -0800
Message-ID: <20071206143130.08ad8915.akpm@linux-foundation.org>
References: <878x4egdgi.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbXLFWbo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2007 17:31:44 -0500
In-Reply-To: <878x4egdgi.fsf@hades.wkstn.nix>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 02 Dec 2007 00:14:21 +0000
Nix <nix@esperi.org.uk> wrote:

> About once a year I get a SCSI parity error on one of my systems (the
> only one with SCSI). I presume the cabling is substandard, but given my
> coordination deficits and the rarity of the errors I'd do far more
> damage replacing it than leaving it be.
> 
> I had one of these today.
> 
> The system (2.6.23.9) spotted the error, and seemingly recovered:
> 
> Dec  1 12:53:40 loki warning: kernel: sym0: SCSI parity error detected: SCR1=132 DBC=50000000 SBCL=0
> Dec  1 12:53:40 loki warning: kernel: sym0:0: ERROR (81:0) (8-0-0) (10/9d/0) @ (mem c2800048:ffffffff).
> Dec  1 12:53:40 loki warning: kernel: sym0: regdump: da 00 00 9d 47 10 00 0e 00 08 80 00 80 00 0f 0a d0 58 3c 01 02 ff ff ff.
> Dec  1 12:53:40 loki warning: kernel: sym0: SCSI BUS reset detected.
> Dec  1 12:53:40 loki notice: kernel: sym0: SCSI BUS has been reset.
> 
> However, after that reset I/O to any device on that controller is
> *incredibly* slow.
> 
> A monthly RAID check kicked off shortly afterwards and provided my first
> clue. Load average >15, and:
> 
> md1 : active raid5 sda6[0] hdc5[3] sdb6[1]
>       76807296 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>       [========>............]  check = 42.8% (16450780/38403648) finish=253.3min speed=1442K/sec
> 
> 1442Kb/s is a bit less than I'd expect from a three-drive array with
> disks capable of 40Mb/s easily.
> 
> /dev/sda:
>  Timing buffered disk reads:    8 MB in  3.50 seconds =   2.29 MB/sec
> 
> A somewhat slower ATAPI disk on the same machine:
> 
> /dev/hdc:
>  Timing buffered disk reads:  110 MB in  3.05 seconds =  36.08 MB/sec
> 
> So, um, what could cause this? Can I speed it up again other than by
> rebooting (which I'm just about to do, but it is annoying).
> 

cc linux-scsi.

Nothing is likely to happen.  Please raise a report at bugzilla.kernel.org.
