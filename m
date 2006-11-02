From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bugme-new] [Bug 7444] New: BUG on drive removal with
	pata_cmd64x
Date: Thu, 02 Nov 2006 11:38:17 +0000
Message-ID: <1162467497.11965.163.camel@localhost.localdomain>
References: <200611011240.kA1Ceaj7025489@fire-2.osdl.org>
	 <20061101120258.e7462f9f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:10390 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1752862AbWKBLeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Nov 2006 06:34:23 -0500
In-Reply-To: <20061101120258.e7462f9f.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, jpw@wszib.edu.pl

Ar Mer, 2006-11-01 am 12:02 -0800, ysgrifennodd Andrew Morton:
> Dunno if this is a scsi thing or an Alan thing.  But it is certainly a
> thing!
> > and driver hangs in a non-functional state (neither removed nor active)
> > HOWEVER,
> > going to /sys/bus/scsi/devices/X:0:0:0/ and echo'ing 1 to delete triggers the
> > same BUG; the drive disappears from the system correctly(!) and pata_cmd64x can
> > be removed from system without further problems.

It actually looks like a refcounting problem - could be in the SCSI code
or in the libata code or in the AHCI code. I don't think it's in the
driver however as the drivers don't carry custom code in that area

> > On a subsequent docking, the drive affected by the above bug appears to be
> > confused and kernel complains about not being able to identify the drive,
> > however, after a few attempts it manages to reset the drive.
> > 

That I think I understand assuming the first time you booted with the
drive plugged in ?

Alan
