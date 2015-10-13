From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Tue, 13 Oct 2015 13:52:53 +0200
Message-ID: <20151013115253.GA17139@lst.de>
References: <20151002125608.GB14899@lst.de> <1443792301.2209.4.camel@HansenPartnership.com> <20151002133423.GA15867@lst.de> <1443793497.2209.10.camel@HansenPartnership.com> <20151004074556.GA13932@lst.de> <561BAB72.1070205@suse.de> <20151012143927.GA24770@lst.de> <CAMM=eLdLh4VGapGH2WcEUY2Biwx-ZojQ0HELCFYvQwW9zzpQ1A@mail.gmail.com> <20151012193614.GA32464@lst.de> <561C9E0B.6070500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57252 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbbJMLwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2015 07:52:55 -0400
Content-Disposition: inline
In-Reply-To: <561C9E0B.6070500@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Oct 13, 2015 at 08:00:43AM +0200, Hannes Reinecke wrote:
> In the light of the discussion I think it would be better to
> upgrade the device handler to become their own transport class,
> to be hooked in between scsi_target and scsi_device.
> That way we would have a way of exposing the topology (target port
> groups etc) and would get rid of the probing problem.

I don't think a transport class makes sense here.  A struct device
or a class_interface as suggested by James sound much better.

But even then unless we solve the request_module from async context
problem we can't reliably load them as soon as we encounter the first
ALUA/RDAC/EMC/HP device, so distribution would probably still need to
pre-load them.
