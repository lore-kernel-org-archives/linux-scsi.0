From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.6.1: media change check fails for busy unplugged device
Date: Mon, 19 Jan 2004 15:36:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119233641.GA1859@beaverton.ibm.com>
References: <200401182141.12468.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:14750 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S264974AbUASXcr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 18:32:47 -0500
Content-Disposition: inline
In-Reply-To: <200401182141.12468.arvidjaar@mail.ru>
List-Id: linux-scsi@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Andrey Borzenkov [arvidjaar@mail.ru] wrote:
> If we unplug busy device (consider mounted USB stick) media change check 
> always returns true (no media change happened). It happens because
> 
> - device state is set to SDEV_DEL and scsi_prep_fn silently kills any request 
> including TEST_UNIT_READY sent by sd_media_changed without propagating any 
> information back to caller
> 

The silently kill would appear to be the issue. The addition of any
number of additional checks prior to calling scsi_ioctl would not ensure
that as soon as the last check is done the device state has not changed.

We need a change in scsi_wait_req to differentiate that we where not woken
up from scsi_wait_done, but from end_that_request_last.

One way would be to check if rq_status == RQ_SCSI_DONE. I did not see
anything on the request to indicate it was BLKPREP_KILL'd.

James has worked more on the scsi_prep_fn so maybe he has another
suggestion.

-andmike
--
Michael Anderson
andmike@us.ibm.com

