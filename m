From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 17 Jul 2003 11:43:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058456628.2647.52.camel@mulgrave>
References: <20030716132036.GB833@suse.de>
	<1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de>
	<20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de>
	<3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de>
	<3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de>
	<3F1683F5.4030107@cyberone.com.au> <20030717111059.GI833@suse.de>
	<3F168846.90902@cyberone.com.au>
	<1058453043.4638.2.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:10501 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S271497AbTGQP3L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 11:29:11 -0400
In-Reply-To: <1058453043.4638.2.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Nick Piggin <piggin@cyberone.com.au>, Jens Axboe <axboe@suse.de>, Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2003-07-17 at 10:44, Mark Haverkamp wrote:
> I added Jens' and your patch and got this when I did a mkfs on an
> aacraid disk:

I don't get the crash, but it still hangs for me.

Just as a matter of interest, you should be able to simulate the problem
with almost any SCSI driver by adding artificial HOST/DEVICE busy
returns in queuecommand.

This is what I did in 53c700.c:

	static int host_busy_cnt = 0;
	static int device_busy_cnt = 0;

	if((host_busy_cnt++)%1000 == 434) {
		printk("53c700 RETURNING HOST BUSY, depth %d\n",
		       NCR_700_get_depth(SCp->device));
		return SCSI_MLQUEUE_HOST_BUSY;
	}

	if((device_busy_cnt++) % 544 == 232) {
		printk("53c700 RETURNING DEVICE BUSY, depth %d\n",
		       NCR_700_get_depth(SCp->device));
		return SCSI_MLQUEUE_DEVICE_BUSY;
	}

This is my usual method of testing our requeuing code (the depth is
important, because we take different actions depending on whether the
depth is zero or not---exercises the starvation code).

I believe this should work with scsi_debug even if you don't actually
have a SCSI setup.

James


