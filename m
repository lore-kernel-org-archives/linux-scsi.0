From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Fri, 27 May 2005 12:01:38 +1000
Message-ID: <1117159298.9076.178.camel@gaston>
References: <20050523201535.GA24298@havoc.gtf.org>
	 <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org>
	 <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de>
	 <4292CF5D.90809@pobox.com> <20050524075953.GY9855@suse.de>
	 <4292E3EE.10006@pobox.com> <20050524085133.GZ9855@suse.de>
	 <42935852.2020300@pobox.com>  <20050525092952.GA7005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:44165 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S261424AbVE0CC0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 22:02:26 -0400
In-Reply-To: <20050525092952.GA7005@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Wed, 2005-05-25 at 11:29 +0200, Jens Axboe wrote:
> On Tue, May 24 2005, Jeff Garzik wrote:
> > Jens Axboe wrote:
> > >I agree, it's a cleaner approach, with the rq being a container for
> > >generel messages as well not just SCSI commands. The one missing piece
> > >for that was the rq->end_io() callback so everything doesn't have to go
> > >down sync, but that is in now as well.
> > >
> > >I'll try and cook something up.
> > 
> > Very cool ;)
> 
> This is the base for it. It splits request->flags into two variables:
> 
> - cmd_type. this is not a bitmask, but a value indicating what type of
>   request this is.
> 
> - cmd_flags. various command modified flags.

I like it too. It's a long overdue cleanup :)

Another thing is we should/could probably move some of the other fields
in the struct request into a union of structs. Some of them are never
present simultaneously ...

Ben.


