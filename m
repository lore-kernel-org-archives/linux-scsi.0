From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16539] end_request: I/O error, dev sr1, sector 0; quiet_error:
 40 callbacks suppressed
Date: Thu, 26 Aug 2010 23:38:17 GMT
Message-ID: <201008262338.o7QNcHah004319@demeter1.kernel.org>
References: <bug-16539-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54191 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab0HZXiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Aug 2010 19:38:19 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7QNcHZ0004322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Aug 2010 23:38:17 GMT
In-Reply-To: <bug-16539-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16539





--- Comment #4 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-08-26 23:38:10 ---
Reply-To: James.Bottomley@suse.de

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

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
