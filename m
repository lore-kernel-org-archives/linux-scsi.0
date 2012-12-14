From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Fri, 14 Dec 2012 20:28:56 +0100
Message-ID: <50CB7DF8.5020002@acm.org>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C9F2B9.4050500@acm.org> <20121213172513.GH20898@beardog.cce.hp.com> <50CA0692.2010903@acm.org> <20121213164912.GA28496@infradead.org> <50CAF502.3070300@acm.org> <20121214164421.GQ20898@beardog.cce.hp.com> <50CB50A9.1050202@acm.org> <20121214195533.GS20898@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:36737 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab2LNT27 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2012 14:28:59 -0500
In-Reply-To: <20121214195533.GS20898@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On 12/14/12 20:55, scameron@beardog.cce.hp.com wrote:
> It's not so much that they are re-ordered as that there is no controlled
> ordering to begin with because multiple cpus are submitting to multiple
> hardware queues concurrently.  If you have 12 requests coming in on 12
> cpus to 12 hardware queues to the device, it's going to be racy as to
> which request is processed first by the device -- and this is fine, the
> hardware queues are independent of one another and do not need to worry
> about each other.  This is all to provide a means of getting enough commands
> on the device to actually keep it busy.  A single cpu can't do it, the
> device is too fast.  If you have ordering dependencies such that request
> A must complete before request B completes, then don't submit A and B
> concurrently, because if you do submit them concurrently, you cannot tell
> whether A or B will arrive into the device first because they may go into
> it via different hardware queues.

It depends on how these multiple queues are used. If each queue would 
e.g. be associated with a disjoint LBA range of the storage device then 
there wouldn't be a risk of request reordering due to using multiple 
hardware queues.

Bart.

