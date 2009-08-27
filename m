From: Chris Mason <chris.mason@oracle.com>
Subject: Re: DIF/DIX updates for 2.6.32
Date: Thu, 27 Aug 2009 16:05:01 -0400
Message-ID: <20090827200501.GA4940@think>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
 <4A95226E.8030504@panasas.com>
 <yq1my5l934u.fsf@sermon.lab.mkp.net>
 <4A9656B6.5060100@panasas.com>
 <1251380803.6426.16.camel@mulgrave.site>
 <4A969AD4.7070309@panasas.com>
 <1251384706.6426.29.camel@mulgrave.site>
 <yq1ws4p6n4u.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:62248 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZH0UGB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 16:06:01 -0400
Content-Disposition: inline
In-Reply-To: <yq1ws4p6n4u.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2009 at 04:02:41PM -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:
> 
> >> This is not an option on a mirror system, and the performance
> >> gain/lose is dependent on the round trip speed. If for every digest
> >> error I have an error recovery cycle, delays, and stalls. Then no it
> >> is not better. Not to mention some iscsi-targets that reset and the
> >> all session must be re-established.
> 
> James> Your suggestion of putting processes to sleep while I/O is
> James> pending will degrade performance for everyone; that's not really
> James> an acceptable tradeoff for improving one corner case.
> 
[ changing pages in flight ]

> 
> In my opinion ext[234] should simply be fixed.  If there's a significant
> performance hit on those filesystems we could make the wait conditional
> on a block_device flag.

I agree here.  It is pretty trivial in the filesystem to wait for pages
in flight, and it shouldn't be the job of the lower layers to double
buffer 100% of the time.

-chris

