From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Mon, 3 Nov 2003 09:14:51 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031103091451.A25391@infradead.org>
References: <20031031114616.A16435@infradead.org> <Pine.LNX.4.44.0311021933100.4615-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:30990 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261797AbTKCJOx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2003 04:14:53 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311021933100.4615-100000@poirot.grange>; from g.liakhovetski@gmx.de on Sun, Nov 02, 2003 at 08:22:23PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, garloff@suse.de, gl@dsa-ac.de

On Sun, Nov 02, 2003 at 08:22:23PM +0100, Guennadi Liakhovetski wrote:
> Ok, started looking at the tmscsim. A couple of questions:
> 
> 1) After the "next" element has disappeared from the struct scsi_cmnd,
> what is the "correct" / preferred way to queue scsi commands in drivers?
> I saw aic7xxx (new) casting a part of struct scsi_pointer SCp in
> scsi_cmnd, starting from Status to a list_head (or an anology thereof),
> which doesn't seem very nice. Anyway, I didn't find any "standard" way for
> doing this. Should host_scribble be used?

Just overlay your own structure over the scsi_pointer - you can easily
embedd a list_head in there.  But in 2.6 a driver really schouldn't need
to keep it's own list anyway :)

> 2) Actually, which scsi driver (or, better, several drivers) can be
> considered well-written and can be taken as examples? I tried looking at
> aic7xxx, as it is a pretty new one, but I am not sure if it is really a
> good example to follow and it is pretty big too.

aic7xxx is a very bad example.  It's a BSDish driver glued into Linux.
I'd suggest looking into qla1280 or the 53c700 driver and it's glue
drivers instead. In qla1280 you can also see an example for the above
embedding, looks for struct srb.

> P.S. Should this thread be taken to linux-scsi or is it better to continue
> it on lkml?

I think linux-scsi is the right list, and dropped the lkml Cc.

-- 
Christoph Hellwig <hch@lst.de>		-	Freelance Hacker
Contact me for driver hacking and kernel development consulting
