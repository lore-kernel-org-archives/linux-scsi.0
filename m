From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: bug report: sd:  off by one in sd_read_block_limits()
Date: Tue, 2 Mar 2010 06:31:24 -0700
Message-ID: <20100302133124.GF6567@parisc-linux.org>
References: <20100302082135.GA6218@bicker> <yq1tysy27ft.fsf@sermon.lab.mkp.net> <yq1k4tu2716.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58816 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0CBNbZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 08:31:25 -0500
Content-Disposition: inline
In-Reply-To: <yq1k4tu2716.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Carpenter <error27@gmail.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, Mar 02, 2010 at 08:21:41AM -0500, Martin K. Petersen wrote:
> >>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:
> 
> Actually, looking closer at the VPD mechanism in e3deec09 we need to fit
> the page header as well...

These aren't the only two bugs introduced either.  If a device has more VPD
pages than the length of the buffer that the caller has allocated, we will
now incorrectly report that the device doesn't support that page.

James, was any problem actually observed that led to e3deec09?  I really
think you should revert it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
