From: Oliver Neukum <oneukum@suse.de>
Subject: Re: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Mon, 16 Sep 2013 14:41:21 +0200
Message-ID: <1379335281.15916.38.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1309111010500.1352-100000@iolanthe.rowland.org>
	 <52315559.3080708@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3IPMlX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Sep 2013 08:41:23 -0400
In-Reply-To: <52315559.3080708@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org

On Thu, 2013-09-12 at 07:47 +0200, Hannes Reinecke wrote:
> On 09/11/2013 04:14 PM, Alan Stern wrote:
> > On Tue, 10 Sep 2013, Oliver Neukum wrote:

> >> I think we can be sure that no drive enclosure will crash
> >> with READ_CAPACITY_16.
> > 
> > I wouldn't count on it, but I don't know of any examples.
> > 
> Me neither. The whole issue just smells of some firmware coders
> messing up their stuff. So I would think that other firmwares
> might not have this problem.

Certainly. But does it matter? We would be happy to always use
READ_CAPACITY_16 first, if it weren't for other buggy firmware.

> (But as HS enclosures aren't that common chances are we've hit
>  the same firmware by chance on every test machine we've had.)
> 
> I think it would warrant a quirk approach. Yes, it might be slightly
> more coding, but at the same time it's more selective on where it
> should trigger.

Yes and we would for sure miss many cases.

> Also looking at scsiglue.c it would make things quite tricky if
> you'd want to _disable_ this feature for HS devices; other firmware

Just another quirk.

> from other vendors might not exhibit this issue after all.
> And scsiglue.c already has tons of quirks set, adding one more
> doesn't do any harm.

It doesn't do harm if the number of devices to be added is small.
The enclosure works under Windows. So we know that it uses
READ_CAPACITY_16 under some circumstances.
Unfortunately I haven't dug up a Windows box as yet.
However we can realistically hope that the firmwares become
fixed only if Windows _fails_ to use READ_CAPACITY_16 under
some circumstances.

	Regards
		Oliver


