From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/2] scsi_scan: Send TEST UNIT READY to the LUN before
 scanning
Date: Wed, 11 Jun 2014 14:46:40 +0000
Message-ID: <1402498000.2523.11.camel@dabdike.int.hansenpartnership.com>
References: <1401953203-103015-1-git-send-email-hare@suse.de>
		 <1401953203-103015-2-git-send-email-hare@suse.de>
	 <1402496658.2523.7.camel@dabdike.int.hansenpartnership.com>
	 <539868C2.50406@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:36053 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaFKOqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 10:46:42 -0400
In-Reply-To: <539868C2.50406@suse.de>
Content-Language: en-US
Content-ID: <DA09ACE77E9AC84385D5601E565F00BE@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "elliot@hp.com" <elliot@hp.com>

On Wed, 2014-06-11 at 16:33 +0200, Hannes Reinecke wrote:
> On 06/11/2014 04:24 PM, James Bottomley wrote:
> > On Thu, 2014-06-05 at 09:26 +0200, Hannes Reinecke wrote:
> >> REPORT_LUN_SCAN does not report any outstanding unit attention
> >> condition as per SAM. However, the target might not be fully
> >> initialized at that time, so we might end up getting a
> >> default entry (or even a partially filled one).
> >> But as we're not able to process the REPORT LUN DATA HAS CHANGED
> >> unit attention correctly we'll be missing out some LUNs during
> >> startup.
> >> So it's better to send a TEST UNIT READY for modern implementations
> >> and wait until the unit attention condition goes away.
> >
> > Are you sure this is a good idea: we just spent ages tuning SCSI init so
> > we don't slow systems down.  This patch, in the event the array is
> > having a power on problem, takes us right back to waiting for init
> > again ... basically the busy wait in scsi_test_lun.
> >
> > Since the array should send us a UA anyway when it's got itself sorted
> > out, what's wrong with just processing the report luns data has changed
> > condition?
> >
> Because we can't.
> 
> _If_ we were attempting this we'd run into several issues:
> a) Boot will fail, as REPORT LUNs will return 0 LUNs (or just LUN 0).
>     So the scanning code will assume everything's fine. Booting will
>     continue, only to figure out that no LUNs are present.
>     As there is _no_ indication that REPORT LUNs should indeed have
>     returned an error (only it can't due to SAM) we wouldn't even
>     now that there _is_ an issue.
>     (In fact, that's what triggered the patchset in the first place.)
> b) Even _if_ we're able so somehow recover from that we will have
>     to rescan the host and any attached devices.
>     The only way to do this currently is to _remove_ all devices
>     from that host and then do a full rescan.
>     Trying this with any devices which are already part of some
>     complex setup will become ... interesting.

OK, go back to first principles and tell us what the actual problem is,
with traces and details.  Is this some weird SCSI-3 device with a single
LUN that's screwing up report luns ... in which case we can just
blacklist it.  Or is it boot from an array?

> So the easy way out here is indeed just to send a TEST UNIT READY.
> And as we're checking for a reasonably SCSI compliance we should
> be catching most of the oddballs.

I don't object hugely to TUR ... except it binds us to spin up because
most devices will respond not ready.  I do object to busy waiting in the
init thread until we get the right answer.

James

