From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 08/13] scsi: move request preps in other places into prep_fn()
Date: Fri, 1 Apr 2005 14:25:42 +0900
Message-ID: <20050401052542.GG11318@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.94FFEC1E@htj.dyndns.org> <1112292464.5619.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.197]:43869 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262642AbVDAFZt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 00:25:49 -0500
Received: by wproxy.gmail.com with SMTP id 68so797596wra
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 21:25:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1112292464.5619.30.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

 Hello, James.

On Thu, Mar 31, 2005 at 12:07:44PM -0600, James Bottomley wrote:
> On Thu, 2005-03-31 at 18:08 +0900, Tejun Heo wrote:
> > 	Move request preparations scattered in scsi_request_fn() and
> > 	scsi_dispatch_cmd() into scsi_prep_fn().
> > 
> > 	* CDB_SIZE check in scsi_dispatch_cmd()
> > 	* SCSI-2 LUN preparation in scsi_dispatch_cmd()
> > 	* scsi_init_cmd_errh() in scsi_request_fn()
> > 
> > 	No invalid request reaches scsi_request_fn() anymore.
> 
> This one, I like, there's just one small problem:
> 
> You can't move scsi_init_cmd_errh() out of the request function path:
> It's where we set up the sense buffer handling, so it has to be done
> every time the command is prepared for execution (the prep function is
> only called once)---think what happens if we turn a command around for
> retry based on a sense indication.
> 
> So redo the patch and I'll put it in.

 Ah.. with later requeue path consolidation patches, all requests get
their sense buffer cleared during requeueing, which, IMHO, is more
logical.  Moving scsi_init_cmd_errh() should come after the patch.
Sorry. :-)

 I'll make another take of this patchset (maybe subset) after issues
are resolved.  I'll split and reorder relocation of scsi_init_cmd_errh
then.

 Thanks.

-- 
tejun

