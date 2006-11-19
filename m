From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH RESEND 2/2] SCSI: add scsi_device->retries
Date: Mon, 20 Nov 2006 00:32:57 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0611200001230.4946@kai.makisara.local>
References: <20061119125115.GJ2184@htj.dyndns.org> <20061119125200.GK2184@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kolumbus.fi ([193.229.0.46]:12195 "EHLO mail.kolumbus.fi")
	by vger.kernel.org with ESMTP id S933493AbWKSWbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Nov 2006 17:31:50 -0500
In-Reply-To: <20061119125200.GK2184@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Sun, 19 Nov 2006, Tejun Heo wrote:

> Add scsi_device->retries to provide generic control over command
> retries, which is very similar to sdev->timeout.  The initial value is
> -1 and high level driver is free to override on attach if negative.
> Note that -1 has the same effect as 0 (no retry) and signifies that
> it's the default value.  As with sdev->timeout, sdev->retries is
> exported under the device sysfs node.
> 
> All high level drivers are converted to use it for retry value.
> However, there are exceptions.
> 
> * sd_sync_cache() and sr::get_sectorsize() loop three more times
>   around normal command execution on failure.
> 
> * st uses three retry limits - MAX_RETRIES, MAX_WRITE_RETRIES and
>   MAX_READY_RETRIES, which are all zero.  This patch only converts
>   MAX_RETRIES to sdev->retries.  Defining WRITE and READY retries in
>   terms of sdev->retries would make more sense.
> 
I am neither acking nor naking this now. The patch does not change st 
behavior but moves part of the retry strategy out of the driver. (Which is 
also good because it makes one of the retry limits user changeable.)

Combining all retry counts is something that may not be a good thing. 
Below is justification why st has three different retry limits.

For some devices one number of retries is not perfect for all functions.

The firmware of tape devices usually retries quite thoroughly before 
returning error. This is why the default zero applies to most cases.

MAX_WRITE_RETRIES is separate from MAX_RETRIES because a plausible 
strategy might be (maybe not any more) to allow no retries for write but 
allow retries for reading and repositioning. The writes should fail 
directly so that the minimum number of marginal errors will be written. 
The reads can be retried so that even marginal data can be recovered. 
(Note that this may lead to tape positioning errors and may not be a 
good strategy in all cases.)

MAX_READY_RETRIES is used for commands that don't move the tape. This is a 
situation where retrying is probably harmless.

-- 
Kai
