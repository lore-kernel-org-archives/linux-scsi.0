From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_allocate_request() reference
Date: Mon, 21 Mar 2005 09:09:58 -0600
Message-ID: <1111417798.5504.8.camel@mulgrave>
References: <20050321132604.GA25452@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:38855 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261339AbVCUPKF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 10:10:05 -0500
In-Reply-To: <20050321132604.GA25452@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-03-21 at 14:26 +0100, Jens Axboe wrote:
> scsi_allocate_request() doesn't hold a reference to the device that it
> points to, that is not good. This patch fixes that up.

Actually, I don't think this is correct.  The reference is taken when
the command is attached to a request in the scsi_request_fn function
after first checking that the entity is in a condition to have this
happen.

The problem is that the device could have been torn down (surprise
ejection etc) when some of the routines that call scsi_allocate_request
run.  What's the actual problem this is trying to solve?

James


