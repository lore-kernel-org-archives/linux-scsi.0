From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH 0/2] fusion SAS support
Date: Wed, 24 Aug 2005 02:10:14 -0700
Message-ID: <20050824091014.GA569688@sgi.com>
References: <20050819162634.GA15401@lst.de> <20050824070840.GA568604@sgi.com> <20050824085756.GA11691@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:61828 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1750802AbVHXJK1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 05:10:27 -0400
Content-Disposition: inline
In-Reply-To: <20050824085756.GA11691@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On Wed, Aug 24, 2005 at 10:57:56AM +0200, Christoph Hellwig wrote:
> On Wed, Aug 24, 2005 at 12:08:40AM -0700, Jeremy Higdon wrote:
> > Hi Christoph,
> > 
> > I applied your four (sets of) patches, and they all seem to work
> > fine.  When connected through an expander, the data is a little light,
> > but direct connect works great.  Below, targets 0 and 1 are direct
> > connect to a 1064 chip, while targets 21-29 are through an expander.
> 
> The device_type = none for the target connected through the expander
> looks wrong.  I'll hopefully have an enclosure with an expander soon
> and will fix this.

I'm also having a couple of problems problem with discovery.

One is that devices connected to the expander are not discovered
at driver init time.  It requires a manual probe after driver init.

The other is that there's something that the firmware doesn't like
about the probe.  I got these sorts of errors.

mptscsih: ioc0: >> Attempting task abort! (sc=e000003014da9c80)
mptscsih: ioc0: >> Attempting task abort! (sc=e000003014da9c80)
mptbase: Initiating ioc0 recovery
mptscsih: ioc0: >> Attempting task abort! (sc=e000003014da9c80)
mptbase: Initiating ioc0 recovery
mptscsih: ioc0: >> Attempting target reset! (sc=e000003014da9c80)
mptscsih: ioc0: >> Attempting bus reset! (sc=e000003014da9c80)
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
           FAULT code = 1600h
mptbase: ioc0: Recovered from IOC FAULT

However, after updating firmware on the 1064, this latter problem
seems to be fixed (still doesn't discover devices on the expander
at driver init).

jeremy
