From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: sym53c8xx_2 funkiness...
Date: Mon, 26 Jul 2004 10:54:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3zn5nxi6j.fsf@merlin.emma.line.org>
References: <20040718030514.GJ1105@eriador.mirkwood.net>
	<20040724165625.GA1105@eriador.mirkwood.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:63388 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S265060AbUGZIyP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2004 04:54:15 -0400
In-Reply-To: <20040724165625.GA1105@eriador.mirkwood.net>
	(pf-linux-scsi-20040717@mirkwood.net's message of "Sat, 24 Jul 2004
	12:56:25 -0400")
List-Id: linux-scsi@vger.kernel.org
To: PinkFreud <pf-linux-scsi-20040717@mirkwood.net>
Cc: linux-scsi@vger.kernel.org

PinkFreud <pf-linux-scsi-20040717@mirkwood.net> writes:

> Any ideas on why this is happening?  This system has become quite
> unstable...
>> I have a box with an old NCR 53c810 scsi card.  It was running fine
>> with Slackware and a vanilla 2.4.19 kernel for the past year or so.
>> I recently decided to install Debian on it, and started out with the
>> Debian 2.4.26 package.  It wasn't long before I started noticing
>> messages like
>> sym0: SCSI BUS reset detected.
>> sym0: SCSI BUS has been reset.
>> in dmesg.  This also seems to hose the box more often than not...

Try booting with ACPI switched off
and also check if you have devices on the bus that misbehave.

I've found it necessary to prohibit SCSI disconnect by module option for
an elderly Tandberg TDC3800 tape drive after switching from 2.4's
ncr53c8xx driver to the only official 2.6 driver, sym53c8xx_2; the
controller in question was a Tekram DC-310U (SYM53C860) that was
accompanied by a Plextor PX-40TSi (that also provides the active
termination).

I haven't bothered to check if there's a driver bug or a bug of the
drive, a TDC4222 and an SLR6 work fine with a both a Tekram DC-390U and
a Tekram DC-390F (both SYM53C875).

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
