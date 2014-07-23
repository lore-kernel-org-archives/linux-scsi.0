From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Wed, 23 Jul 2014 07:15:58 -0700
Message-ID: <20140723141558.GA9705@infradead.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723141028.GA22724@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaGWOQB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2014 10:16:01 -0400
Content-Disposition: inline
In-Reply-To: <20140723141028.GA22724@sucs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, apw@canonical.com, jasowang@redhat.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org

On Wed, Jul 23, 2014 at 03:10:28PM +0100, Sitsofe Wheeler wrote:
> I'm not sure this alone will work - won't sdev_bflags/bflags have
> already been built at this point?

They've been built up, but we can still or new values into it.  It looks
fine to me from review, but if you can test it on an actualy hypverv
setup that would be valueable feedback.

> If the setting of this has to stay in
> this function why don't you (also) set sdevice->try_vpd_pages in a
> similar way to no_write_same?

We could probably do that.  I don't actually like this whole split
between the blacklist flags, and the bitfields.  I'll see if we can
just get rid of those bitfields an always just use the blacklist
flags directly, now that we have precedence of setting them in drivers
and not just the table keyed by the inquiry data.  But that's a longer
term project, this late in the 3.17 cycle I'd just like to merge
something that gets discards on hyperv to work.
