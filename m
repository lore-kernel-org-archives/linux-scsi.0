From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Thu, 26 Jul 2007 16:46:44 -0400
Message-ID: <1185482804.3501.87.camel@localhost.localdomain>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
	 <1185329683.3488.46.camel@localhost.localdomain>
	 <1185461780.14419.17.camel@fea.ornl.gov>
	 <1185462341.3501.62.camel@localhost.localdomain>
	 <1185480022.14419.58.camel@fea.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38784 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933588AbXGZUqr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 16:46:47 -0400
In-Reply-To: <1185480022.14419.58.camel@fea.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: freelsjd@ornl.gov
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2007-07-26 at 16:00 -0400, Freels, James D. wrote:
> 9) the output from the commands you asked for are shown below for the
> 2.6.22.1 kernel.  They indicate parity errors on the changer at scsi
> id=3.  Also, when booting up under 2.6.18.8, the linux media changer
> scsi device works and initializes; when booting up under 2.6.22.1, it
> does not; probably because of the same parity errors ?
> 
>  target0:0:3: Beginning Domain Validation
>  target0:0:3: asynchronous
>  target0:0:3: FAST-20 WIDE SCSI 40.0
                        ^^^^
This is the problem.

Something in the transport class is causing WIDE to be set regardless of
the max_width setting ... this looks to be a bug in the aic7xxx
transport class implementation

>  MB/s ST (50 ns, offset 32)
> (scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a6)
> SCSIRATE(0x95)

Once it goes wide on a narrow device, you get immediate parity errors
half the time, because you're missing the upper 8 bits for the parity
calculation.

I'll see if I can trace this inside the driver ... naturally, I have no
aic7xxx setup where I only have a narrow device.

James


