From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: puzzling scsi return code 20000
Date: Tue, 6 Jul 2004 11:46:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040706184626.GA30970@praka.san.rr.com>
References: <40E9448F.1090700@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:41980 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S264266AbUGFS5E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2004 14:57:04 -0400
Content-Disposition: inline
In-Reply-To: <40E9448F.1090700@univ-nantes.fr>
List-Id: linux-scsi@vger.kernel.org
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: linux-scsi@vger.kernel.org

On Mon, 05 Jul 2004, Yann Dupont wrote:

> hello. I have some problems with a SAN here. Don't know if the problems 
> lies in scsi code/driver or other thing...
> 
> The setup is :
> a QLA2300 (Fibre channel) with 6.0.64 driver from qlogic site,
>

I'm not familiar with that version number (are you sure it's 6.0.64,
perhaps 6.06.64?).  I believe the latest driver submitted to DVT has
been posted to the website (7.00.03).

> 2.4.26 kernel, device mapper 1.0.17 applied,
> and xfs or reiserfs on top of lvm volumes (using evms)
> 
> This setup seemed fine since some months now, with giga of data moved 
> every day, but I noticed this on the log:
> 
> Jun 22 16:45:15 talisker kernel: SCSI disk error : host 3 channel 0 id 2 
> lun 1 return code = 20000
> Jun 22 16:45:15 talisker kernel:  I/O error: dev 08:10, sector 145423312
> 
> I have two of these errors in the last month. What's the meaning of this 
> return code ? I made
> badblock on the /dev/evms volume, and all is OK.
>

20000 == DID_BUS_BUSY -- one possibility, the QLogic driver returned a
command with the status, mid-layer ran out of retries, subsequently
returning the status to the upper-layer driver.  But that doesn't
help in finding out what went wrong.

> I also performed a disk scan on the raid array, (an IFT 7250F) and there 
> are no errors.
> 
> The machine can be quite heavily loaded. May I suspect the qla driver ? 
> May I suspect the underlying LVM. The LVM has been resized by the 
> past... Can an error happens here too ?
> I'm very puzzled...
> 
> This is just a summary . I can furnish more information if needed.
> 

I'd suggest you try a more recent driver (noted above), if the I/O
errors persist, then report the problem to tech-support at:

	http://connection.qlogic.com/support/report/index.asp?id=csg

with a complete description.

Regards,
Andrew Vasquez
QLogic Corporation
