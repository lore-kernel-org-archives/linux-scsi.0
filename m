From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Mon, 03 Aug 2015 08:42:43 -0700
Message-ID: <1438616563.2173.16.camel@HansenPartnership.com>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
	 <1438347728-106434-2-git-send-email-hare@suse.de>
	 <20150802154415.GA31100@mtj.duckdns.org> <55BF18ED.3000002@suse.de>
	 <20150803150428.GE32599@mtj.duckdns.org>
	 <20150803151826.GG32599@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20150803151826.GG32599@mtj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-08-03 at 11:18 -0400, Tejun Heo wrote:
> Adding a bit.
> 
> On Mon, Aug 03, 2015 at 11:04:28AM -0400, Tejun Heo wrote:
> > Ugh... so this is from NCQ autosense thing.  Now ATA devices reports
> > sense data too which trumps AC_ERR_DEV so libata EH decides to retry
> > even when the device indicates unrecoverable error.  Urgh... we
> > shouldn't be taking completely different error handling paths because
> > a device chooses to report error conditions slightly differently.
> > Please map them so that they behave in a consistent manner.  I'm gonna
> > plug autosense for now.
> 
> Also, is there anything substantial we gain from NCQ autosense?  Why
> do we want this in the first place?  ATA error reporting is
> rudimentary but it more or less works and I'm not sure whether we'd
> want to overhaul its basic behaviors at this stage.

I'd think it would be the same reason as all modern transports: it's
faster and allows processing of sense data in-band.  Under the old
regime, the device is effectively frozen until you collect the data.
Under autosense, the data is collected as part of the in-band command
processing, so it doesn't stall the device.

Modern drives (and protocols) are moving towards being somewhat more
chatty with sense data.  It doesn't just signal an error, mostly it's
just reporting about drive characteristics or other advisory stuff.
This means that if you handle it the old way, you'll get more drive
stalls and a corresponding reduction in throughput.

James



