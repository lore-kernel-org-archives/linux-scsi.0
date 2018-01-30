From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [LSF/MM TOPIC] block, dm: restack queue_limits
Date: Tue, 30 Jan 2018 16:07:30 +0100
Message-ID: <cb9f601d-4848-1255-f00b-6b3079ab8c40@suse.de>
References: <20180129210836.GA5744@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47319 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751665AbeA3PHc (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Tue, 30 Jan 2018 10:07:32 -0500
In-Reply-To: <20180129210836.GA5744@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On 01/29/2018 10:08 PM, Mike Snitzer wrote:
> We currently don't restack the queue_limits if the lowest, or
> intermediate, layer of an IO stack changes.
> 
> This is particularly unfortunate in the case of FLUSH/FUA which may
> change if/when a HW controller's BBU fails; whereby requiring the device
> advertise that it has a volatile write cache (WCE=1).
> 
Uh-oh. Device rescan.
Would be a valid topic on its own...

> But in the context of DM, really it'd be best if the entire stack of
> devices had their limits restacked if any underlying layer's limits
> change.
> 
> In the past, Martin and I discussed that we should "just do it" but
> never did.  Not sure we need a lengthy discussion but figured I'd put it
> out there.
> 
> Maybe I'll find time, between now and April, to try implementing it.
> 
For SCSI the device capabilities are pretty much set in stone after the
initial scan; there are hooks for rescanning, but they will only work
half of the time.
Plus we can't really change the device type on the fly (eg if the SCSI
device type changes; if it moves away from '0' we would need to unbind
the sd driver, and if it moves to '0' we'll need to rescan the sd
device. None of this is happening right now.)

So I'd be glad to have a discussion around this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
