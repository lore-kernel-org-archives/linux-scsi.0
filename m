From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 5378] New: aic7xxx deadlock/freeze on Adaptec
 AIC-7899P
Date: Mon, 10 Oct 2005 18:41:44 -0700
Message-ID: <20051010184144.4dfe2241.akpm@osdl.org>
References: <200510061626.j96GQxFD025499@fire-1.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:43157 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751342AbVJKBmQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Oct 2005 21:42:16 -0400
In-Reply-To: <200510061626.j96GQxFD025499@fire-1.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>
Cc: linux-scsi@vger.kernel.org

bugme-daemon@kernel-bugs.osdl.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=5378
> 
>            Summary: aic7xxx deadlock/freeze on Adaptec AIC-7899P
>     Kernel Version: 2.6.13.3
>             Status: NEW
>           Severity: high
>              Owner: andmike@us.ibm.com
>          Submitter: szpajder@staszic.waw.pl
> 
> 
> The following messages appeared in dmesg:
> 
> scsi0:0:1:0: Attempting to queue an ABORT message
> CDB: 0x28 0x0 0x0 0xab 0x8b 0x99 0x0 0x0 0x8 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State while idle, at SEQADDR 0x9
> Card was paused
> [...] (entire dump attached)
> 
> At the time of these errors, load average exceeded 30. After issuing SCSI RESET,
> the system went back to normal. The problem reappeared several hours later -
> load average reached 140 and all the tasks hung waiting for I/O. I was waiting
> for SCSI RESET, which did not occur this time - after about 3 minutes I had to
> reboot with sysrq.
> 
> The problem ocurred about a day after upgrading from 2.6.12.4 (which was running
> fine for over 50 days) to 2.6.13.3. Hardware: Intel SDS2 mainboard with Adaptec
> AIC-7899P SCSI onboard, 4 x Seagate ST336753LW, software RAID-5, configs, lspci,
> etc - attached. The main difference between startup dmesgs is that all hard
> drives were set up as asynchronous during bootup - this didn't occur under
> 2.6.12.4. So I went back to 2.6.12.4 for now, it seems to be ok.

ISTR that there have been several reports of this regression.

What could have caused this?
