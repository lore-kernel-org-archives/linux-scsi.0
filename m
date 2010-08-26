From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 16539] end_request: I/O error, dev sr1, sector 0;
 quiet_error: 40 callbacks suppressed
Date: Thu, 26 Aug 2010 18:03:42 -0500
Message-ID: <1282863822.8133.56.camel@mulgrave.site>
References: <bug-16539-11613@https.bugzilla.kernel.org/>
	 <201008262156.o7QLutdE017280@demeter1.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57032 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0HZXDu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2010 19:03:50 -0400
In-Reply-To: <201008262156.o7QLutdE017280@demeter1.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-08-26 at 21:56 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> --- Comment #3 from Andrew Morton <akpm@linux-foundation.org>  2010-08-26 21:56:51 ---
> (recategorised as scsi)
> 
> [    3.468174] sr1: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda
> tray
> [    3.468305] sr 4:0:0:0: Attached scsi CD-ROM sr1
> [    3.468381] sr 4:0:0:0: Attached scsi generic sg2 type 5
> [    8.126108] EXT4-fs (sda5): mounted filesystem with ordered data mode
> [   15.752273] udev: starting version 151
> [   15.770035] Adding 3574424k swap on /dev/sda7.  Priority:-1 extents:1
> across:3574424k 
> [   16.055126] sony-laptop: Sony Notebook Control Driver v0.6.
> [   16.090212] sr 4:0:0:0: [sr1] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [   16.090217] sr 4:0:0:0: [sr1] Sense Key : Illegal Request [current] 
> [   16.090222] sr 4:0:0:0: [sr1] Add. Sense: Illegal mode for this track
> [   16.090229] sr 4:0:0:0: [sr1] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
> [   16.090239] end_request: I/O error, dev sr1, sector 0
> [   16.090245] Buffer I/O error on device sr1, logical block 0
> 
> hm, who maintains drivers/scsi/sr.c?

Well, technically, that's Jens.

However, what's the actual bug here ... as in what's going on?

The kernel trace implies that some user land process tried to read block
0 and got told it's not readable, giving an I/O error.

MMC says this usually happens when you try to read a sector with the
wrong mode ... what is the program doing the read?

James



