From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Mon, 3 Aug 2015 11:55:13 -0400
Message-ID: <20150803155513.GI32599@mtj.duckdns.org>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
 <1438347728-106434-2-git-send-email-hare@suse.de>
 <20150802154415.GA31100@mtj.duckdns.org>
 <55BF18ED.3000002@suse.de>
 <20150803150428.GE32599@mtj.duckdns.org>
 <20150803151826.GG32599@mtj.duckdns.org>
 <1438616563.2173.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438616563.2173.16.camel@HansenPartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, James.

On Mon, Aug 03, 2015 at 08:42:43AM -0700, James Bottomley wrote:
> I'd think it would be the same reason as all modern transports: it's
> faster and allows processing of sense data in-band.  Under the old
> regime, the device is effectively frozen until you collect the data.
> Under autosense, the data is collected as part of the in-band command
> processing, so it doesn't stall the device.
> 
> Modern drives (and protocols) are moving towards being somewhat more
> chatty with sense data.  It doesn't just signal an error, mostly it's
> just reporting about drive characteristics or other advisory stuff.
> This means that if you handle it the old way, you'll get more drive
> stalls and a corresponding reduction in throughput.

The problem is not the "auto" part but the "sense" part, I guess.  ATA
devices (the harddisks) never reported sense data and instead had a
more rudimentary error bits and for newer devices NCQ log pages, so
libata EH decodes those error information and takes appropriate
actions for the indicated error condition.

Hannes's patchset makes ATA devices mostly bypass libata EH when sense
data is present.  For, say, unrecoverable read errors, it'd be
possible to make this scheme work (broken currently tho); however,
libata and SCSI aren't that closely tied and there currently is no way
for SCSI to tell libata that, e.g., link error was detected on the
device side, so libata will fail to take link recovery actions on
those cases.

This *can* be made to work in a couple different ways but what's
implemented now is pretty broken and making it work properly in any
other way than integrating sense decoding into libata EH would require
major restructuring of the whole thing which I'm not sure would be
worthwhile at this point.

Thanks.

-- 
tejun
