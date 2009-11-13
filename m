From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: Bug 14579 -  Devices disappear... and Bug 14577 - Data
	corruption with Adaptec
Date: Fri, 13 Nov 2009 17:29:43 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C04462@inbmail01.lsi.com>
References: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
 <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:34893 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755456AbZKML7u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Nov 2009 06:59:50 -0500
In-Reply-To: <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Support@techfak.uni-bielefeld.de" <Support@techfak.uni-bielefeld.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>

Subject line is related to *Adaptec* and there are some places LSI related issue is pointed out. Little confusing to me. Is it possible to rewrite what is an issue related to LSI card?

>From dmesg log I can figure out 3.04.07 is mpt fusion driver version.
Please update LSI driver using latest upstream driver version 3.04.13. And see what a result is.

- Kashyap

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Sascha Frey
Sent: Friday, November 13, 2009 4:28 AM
To: linux-scsi@vger.kernel.org
Cc: Lukas Kolbe
Subject: Re: Bug 14579 - Devices disappear... and Bug 14577 - Data corruption with Adaptec

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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
