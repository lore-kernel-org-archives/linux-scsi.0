From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 20 Jan 2004 07:53:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120155320.GA1478@beaverton.ibm.com>
References: <20040120132052.GA6740@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:58557 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S265578AbUATPu1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 10:50:27 -0500
Content-Disposition: inline
In-Reply-To: <20040120132052.GA6740@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, gibbs@scsiguy.com, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> to get control first after a command timeout.  Justin, does this look
> okay for you?  BTW, your drivers are the last ones using scsi_add_timer
> from outside the midlayer, if we could get rid of that we'd be able to
> keep the interface private.
> 

If a LLDD uses this interface how does the scsi_cmnd get returned back
to the mid-layer? If one uses scsi_done without a timer set it will
believe that the error handler is running and not pass it on to
scsi_softirq. It would seem a hack to add a timer just to let scsi_done
pass the cmd back as this appears to be one thing we are trying to avoid
( scsi_errror used at hack like this in the past :-( ). Having everything
always come through scsi_done even under error recovery (timeouts, aborts)
has been discussed on the list in the past.

-andmike
--
Michael Anderson
andmike@us.ibm.com

