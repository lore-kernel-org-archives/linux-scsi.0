From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Fri, 27 Feb 2004 21:40:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403FFF86.90302@pobox.com>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63697 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263029AbUB1CkU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 21:40:20 -0500
In-Reply-To: <3462370000.1077909838@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Justin T. Gibbs wrote:
> 1) The mid-layer doesn't correctly handle this situation.  The mid-layer
>    uses blk_plug_device() to implement this behavior rather than
>    blk_stop_queue().  The leaves the implementation vulnerable to
>    any code that does a manual unplug (e.g. the SCSI scan code) or a
>    blk_run_queues() (e.g. MD) which can alter the duration of the delay.


hum.

Long term we definitely want to use blk_{start,stop}_queue().  I had to 
work on Jens for a little while before he was kind enough to add it :) 
so let's put it to use.

	Jeff



