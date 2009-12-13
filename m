From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Fusion MPT Ultra320 disks  detected as Ultra2
Date: Sun, 13 Dec 2009 12:50:42 +0100
Message-ID: <1260705043.2709.285.camel@mulgrave.site>
References: <26761757.post@talk.nabble.com>
	 <20091213102925.4i5z7z3tw08swocc@imap.suse.de>
	 <200912131258.27052.uprooter@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57601 "HELO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752624AbZLMLu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Dec 2009 06:50:59 -0500
In-Reply-To: <200912131258.27052.uprooter@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uprooter <uprooter@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2009-12-13 at 12:58 +0200, Uprooter wrote:
> Hello James and thanks for trying to help.
> 
> Unfortunately changing min_period  didn't solve anything.
> # pwd
> /sys/class/spi_transport/target2:0:1
> 
> localhost target2:0:1 # echo 25 > min_period
> localhost target2:0:1 # echo 1 > revalidate
> I did it for both disks.
> #dmesg | tail -10
> target2:0:0: Beginning Domain Validation
>  target2:0:0: Domain Validation skipping write tests
>  target2:0:0: Ending Domain Validation
>  target2:0:0: Beginning Domain Validation
>  target2:0:0: Domain Validation skipping write tests
>  target2:0:0: Ending Domain Validation
>  target2:0:1: Beginning Domain Validation
>  target2:0:1: Domain Validation skipping write tests
>  target2:0:1: Ending Domain Validation
>  target2:0:1: Beginning Domain Validation
>  target2:0:1: Domain Validation skipping write tests
>  target2:0:1: Ending Domain Validation
> 
> # cat min_period
> 25
> # cat period
> 50

OK, so I'd suspect a cabling problem.  50ns is the minimum period for a
single ended bus.  You have to move to LVD to get anything beyond.  I'd
say something in your SCSI cable chain is keeping the bus SE.

James


