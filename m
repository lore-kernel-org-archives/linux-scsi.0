From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] serialize bus scanning
Date: Mon, 15 Sep 2003 17:13:05 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030915071305.GA820@krispykreme>
References: <20030825122416.GE15506@lst.de> <20030827202908.GB7852@krispykreme> <20030827203544.GA27020@lst.de> <20030910075741.GC1532@krispykreme> <20030911133419.A10316@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:57064 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262461AbTIOHRI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 03:17:08 -0400
Content-Disposition: inline
In-Reply-To: <20030911133419.A10316@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org


Hi Pat,

> The patch looks fine to me, I hope James will apply it.

Good to see someone else does parallel scan :)

> I think we might still have to allow only a scan or delete (per host), and
> not both in parallel - it looks like we could have some races otherwise,
> I'm not sure though (mainly where the driver model points to the parent
> device). Maybe a get of the host device during scanning is enough.

Speaking of races... Ive been tripping one when parallel probing.
I hit a poisoned list pointer in scsi_run_host_queues, which is being
called out of the error handler thread. (Ive got a few scsi buses in this
machine full of bad disks)

I havent had a chance to look into it but Im guessing we are racing with
someone calling scsi_free_sdev. Im not sure how we should be protecting
->siblings but it looks like we have to do something.

Anton
