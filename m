From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: 31 Oct 2003 17:55:52 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067644902.1782.20.camel@mulgrave>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>	
	<1067447490.1829.30.camel@mulgrave>	
	<20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>	
	<1067450547.3112.363.camel@compaq.xsintricity.com>	
	<20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk>
	<1067453148.3112.369.camel@compaq.xsintricity.com>
	<4159000000.1067644546@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:62725 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261235AbTKAACZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 19:02:25 -0500
In-Reply-To: <4159000000.1067644546@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Fri, 2003-10-31 at 17:55, Justin T. Gibbs wrote:
> BTW, slave_destroy() doesn't seem to be called after a probe
> for a target fails due to a selection timeout.  Is this the
> expected behavior?  I only keep persistent allocations after
> slave_configure() is called, so this doesn't affect my drivers,
> but the behavior isn't what I expected.  This is 2.6.0-test9.

Yes.

slave_configure is only called if the mid-layer decides there's
something worth attaching to there (i.e. if the initial inquiry
succeeds); otherwise it just calls slave_destroy to signal loss of
interest in the target.

The idea is that slave_alloc informs the driver that a probe will be
tried;  slave_configure tells the driver we like what we found, we've
initialised the inquiry variables in the target, now negotiate with it.

James


