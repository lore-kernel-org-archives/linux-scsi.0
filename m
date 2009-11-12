From: Sascha Frey <sfrey@techfak.uni-bielefeld.de>
Subject: Re: Bug 14579 -  Devices disappear... and Bug 14577 - Data
	corruption with Adaptec
Date: Thu, 12 Nov 2009 23:58:25 +0100
Message-ID: <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
References: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
Reply-To: Support@TechFak.Uni-Bielefeld.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:51851 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032AbZKLXFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Nov 2009 18:05:54 -0500
Content-Disposition: inline
In-Reply-To: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Lukas Kolbe <lkolbe@TechFak.Uni-Bielefeld.DE>

Hi,

Lukas Kolbe wrote:
>we'd really appreciate any hints and help we can get for the following
>bugs:
>http://bugzilla.kernel.org/show_bug.cgi?id=14579

We've done some further testing:
it's very hard to trigger this bug. Sometimes the machine freezes after
a few minutes into tape access and sometimes it works days - or even
weeks - without any problem.

The bug only appears during tape I/O (regardless of which tape program is
used: btape, dd or tar).
In most cases the tape write ends with an input/output error. After this
error occurred, any access to the tape library robot (connected through
the SAS interface of the first drive) fails:

# mtx unload 1 1
Unloading drive 1 into Storage Element 1...mtx: Request Sense: Long Report=yes
mtx: Request Sense: Valid Residual=no
mtx: Request Sense: Error Code=70 (Current)
mtx: Request Sense: Sense Key=Illegal Request
mtx: Request Sense: FileMark=no
mtx: Request Sense: EOM=no
mtx: Request Sense: ILI=no
mtx: Request Sense: Additional Sense Code = 53
mtx: Request Sense: Additional Sense Qualifier = 01
mtx: Request Sense: BPV=no
mtx: Request Sense: Error in CDB=no
mtx: Request Sense: SKSV=no
MOVE MEDIUM from Element Address 257 to 4096 Failed

After resetting the scsi bus (echo "- - -" >
/sys/class/scsi_host/host5/scan) the tape drives are revitalized, but
the changer device disappears. Even after a cold restart of the whole
library the device keeps missing.

Yet another problem: restting the SCSI bus of the LSI SAS HBA sometimes
results in a hardy freeze (console stuck; no log messages).

> [...]
>
>I do not believe it's a hardware fault at the moment as the machine
>ran OK under Solaris for a few weeks (including successful btape runs).
>

The very same piece of hardware worked fine using Solaris 10 with heavy
disk and tape I/O at the same time for two months.

We really prefer using Linux instead, but we're in pressure of time.


We appreciate any help resolving this bug!




Regards,
Sascha Frey

