From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Thu, 13 Dec 2012 11:49:12 -0500
Message-ID: <20121213164912.GA28496@infradead.org>
References: <20121211000013.GI23107@beardog.cce.hp.com>
 <50C9F2B9.4050500@acm.org>
 <20121213172513.GH20898@beardog.cce.hp.com>
 <50CA0692.2010903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35179
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690Ab2LMQtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2012 11:49:19 -0500
Content-Disposition: inline
In-Reply-To: <50CA0692.2010903@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: scameron@beardog.cce.hp.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On Thu, Dec 13, 2012 at 05:47:14PM +0100, Bart Van Assche wrote:
> From my experience with block and SCSI drivers option (1) doesn't
> look attractive from a performance point of view. From what I have
> seen performance with QD=1 is several times lower than performance
> with QD > 1. But maybe I overlooked something ?

What you might be missing is that at least on Linux no one who cares
about performance uses the Posix AIO inferface anyway, as the
implementation in glibc always has been horrible.  The Linux-native
aio interface or the various thread pool implementations don't imply
useless ordering and thus can be used to fill up large queues.

