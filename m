From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [GIT PATCH] SCSI merge for 2.6.13
Date: Wed, 7 Sep 2005 10:47:44 -0700
Message-ID: <20050907174744.GA13172@us.ibm.com>
References: <1126053452.5012.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:34004 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S932072AbVIGR4k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 13:56:40 -0400
Content-Disposition: inline
In-Reply-To: <1126053452.5012.28.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Tue, Sep 06, 2005 at 07:37:32PM -0500, James Bottomley wrote:
> This should be the entire contents of the SCSI tree I've been saving.
> It also includes Jens' send SCSI requests via bios tree that he, Mike
> Christie and I have been working on.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/linux/kernel/scm/jejb/scsi-for-linus-2.6.git
> 

>   o convert ch to use scsi_execute_req
>   o convert sr to scsi_execute_req
>   o convert sd to scsi_execute_req (and update the scsi_execute_req API)
>   o convert SPI transport class to scsi_execute
>   o convert the remaining mid-layer pieces to scsi_execute_req

The scsi_execute() retries argument is still not used.

How is this going to work?

For example, multiple unit attentions (power on / reset) during scanning.
We send REPORT LUN, READ CAPACITY, etc., and would not retry if we got a
unit attention.

-- Patrick Mansfield
