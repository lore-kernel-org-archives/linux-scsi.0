From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical address >16Mb used for aha1542" at boot time
Date: Fri, 20 Feb 2004 19:49:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040220184945.GD27190@suse.de>
References: <20040218171212.0eb6618a.akpm@osdl.org> <1077243517.2164.61.camel@mulgrave> <1077265837.1297.9.camel@felicia> <20040220083808.GA11822@suse.de> <1077300620.1937.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:4264 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261249AbUBTStz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 13:49:55 -0500
Content-Disposition: inline
In-Reply-To: <1077300620.1937.11.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Dr. Ernst Molitor" <molitor@uni-bonn.de>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 20 2004, James Bottomley wrote:
> On Fri, 2004-02-20 at 00:38, Jens Axboe wrote:
> > Hmm... James, sr_do_ioctl() used to do bouncing for private commands,
> > any reason it doesn't do that anymore?
> 
> OK, I've looked through the file history, I can't find anywhere that it
> used to do this.
> 
> However, the true solution is to see if we can get scsi_wait_req to go
> through the sg_io code path...that way the block layer will bounce for
> us and we can kill the use_sg == 0 code path in all the drivers.

Yep that'd be my preferred solution as well. Requires bio backing
everything though. I'll hack this up over the weekend.

-- 
Jens Axboe

