From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/3] scsi_lib: Some love to scsi_lib
Date: Mon, 08 Nov 2010 17:02:18 +0200
Message-ID: <4CD810FA.902@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:37575 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754799Ab0KHPCZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 10:02:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Submitted a much needed cleanup to scsi_lib's command completion
path. The code after these patches should theoretically be
behaviour equivalent to current code. Only cleaner smaller, and
easier to understand. The motivation was to make things clearer
to understand. It was all inspired by Alan Stern and more things
added to that.

Theoretically, since I have only tested with the usual tests I have.
Boot an x86_64 machine, git clone, make, xfstests ...
I did not run any Error injection tests with scsi_debug, since I don't
have any set up. Though one should because the error handling might
have changed accidentally, though not intended.

Please someone, Alan Jeff ... I have tried to go through every possible
code path and prove that we do exactly as before. But I might have missed
something. Please check my Math.

I'm sitting on these patches since 2.6.34-rc4, but never followed
them through, and tested them. Sorry. They patched without any issues
on top of current scsi-misc meaning nothing changed in this area since a
long time.

The patches are:
[PATCH 1/3] scsi_lib: request_queue is only needed inside scsi_requeue_command
[PATCH 2/3] scsi_lib: Remove that __scsi_release_buffers contraption

	These two are pure and trivial

[PATCH 3/3] scsi_lib: Collapse scsi_end_request into only user

	This one should be reviewed, but should not change any
	behaviour.

Thanks
Boaz
