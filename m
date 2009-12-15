From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: mvsas:Issues with write and erase of SATA DVD ROM
Date: Tue, 15 Dec 2009 07:08:08 -0700
Message-ID: <20091215140808.GN7812@parisc-linux.org>
References: <6B62480106F2B34D8404CF2FDAA4D9EF52C9F9B792@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN> <6B62480106F2B34D8404CF2FDAA4D9EF5C783A59A4@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36020 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760271AbZLOOIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2009 09:08:11 -0500
Content-Disposition: inline
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF5C783A59A4@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ayan@marvell.com" <ayan@marvell.com>, "kewei@marvell.com" <kewei@marvell.com>, "jack_wang@usish.com" <jack_wang@usish.com>, "tom_peng@usish.com" <tom_peng@usish.com>

On Tue, Dec 15, 2009 at 07:32:53PM +0530, Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech wrote:
> ANALYSIS for erase Issue:
> -------------------------
> Linux-sles11:~ # cdrecord --dev=x,x,x -blank all
> Timeout happened after issuing the above operation to target and LLD is initiating Abort-TMF.
> Here is my analysis and solution for the same.
> If we issue "blank command" to CDROM, the processing of that request will take some time to complete, mean while my timer has expired and issuing abort-task TMF.  So to avoid this situation set IMMED bit 1 in "blank command" then send to it target.

That's a terrible solution.  cdrecord should be setting the timeout
for the command to a high (or even infinite) value.  Maybe it is, in
which case, you need to find out why the timer is expiring too soon.
More investigation needed to find out why the timer expires so soon
rather than this horrible hack.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
