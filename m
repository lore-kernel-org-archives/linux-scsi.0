From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 08/13] scsi: move request preps in other
	places into prep_fn()
Date: Thu, 31 Mar 2005 12:07:44 -0600
Message-ID: <1112292464.5619.30.camel@mulgrave>
References: <20050331090647.FEDC3964@htj.dyndns.org>
	 <20050331090647.94FFEC1E@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:13727 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261607AbVCaSIF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 13:08:05 -0500
In-Reply-To: <20050331090647.94FFEC1E@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Thu, 2005-03-31 at 18:08 +0900, Tejun Heo wrote:
> 	Move request preparations scattered in scsi_request_fn() and
> 	scsi_dispatch_cmd() into scsi_prep_fn().
> 
> 	* CDB_SIZE check in scsi_dispatch_cmd()
> 	* SCSI-2 LUN preparation in scsi_dispatch_cmd()
> 	* scsi_init_cmd_errh() in scsi_request_fn()
> 
> 	No invalid request reaches scsi_request_fn() anymore.

This one, I like, there's just one small problem:

You can't move scsi_init_cmd_errh() out of the request function path:
It's where we set up the sense buffer handling, so it has to be done
every time the command is prepared for execution (the prep function is
only called once)---think what happens if we turn a command around for
retry based on a sense indication.

So redo the patch and I'll put it in.

James


