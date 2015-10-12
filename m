From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Mon, 12 Oct 2015 21:36:14 +0200
Message-ID: <20151012193614.GA32464@lst.de>
References: <20150930215303.GI2627@mtj.duckdns.org> <1443652494.2185.57.camel@HansenPartnership.com> <20151002125608.GB14899@lst.de> <1443792301.2209.4.camel@HansenPartnership.com> <20151002133423.GA15867@lst.de> <1443793497.2209.10.camel@HansenPartnership.com> <20151004074556.GA13932@lst.de> <561BAB72.1070205@suse.de> <20151012143927.GA24770@lst.de> <CAMM=eLdLh4VGapGH2WcEUY2Biwx-ZojQ0HELCFYvQwW9zzpQ1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54500 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbbJLTgR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 15:36:17 -0400
Content-Disposition: inline
In-Reply-To: <CAMM=eLdLh4VGapGH2WcEUY2Biwx-ZojQ0HELCFYvQwW9zzpQ1A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Oct 12, 2015 at 03:29:45PM -0400, Mike Snitzer wrote:
> What may be getting lost during this discussion is that historically
> it has been important to be able to attach the scsi_dh during the SCSI
> scan.  As the scsi_dh alters the SCSI midlayer's sense code processing
> (via callout to the attached scsi_dh).  And this altered SCSI sense
> code handling amounts to the difference between a successful/quick
> boot versus hugely delayed and ultimately error-prone boot on systems
> with many LUNs that have multiple paths.
> 
> So that is why either of these solutions were deployed:
> 1) in RHEL6 we'd require dracut to preload the scsi_dh modules early
> in loading the initramfs
> 2) in RHEL7 all scsi_dh modules _are_ builtin
> 
> Both achieve the goal of having all required scsi_dh available during SCSI scan.

Yes, and both are workarounds.  I tried to implement this properly,
but due to async probing it doesn't actually work.  Given the statement
from Tejun I don't really see how to ever get it to work as long as
we use async probing and the module loading code isn't safe to call
from the async probe path unfortunately.
