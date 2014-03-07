From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 7 Mar 2014 11:01:39 +0000
Message-ID: <1394190098.14365.7.camel@dabdike>
References: <1392286032-85036-1-git-send-email-hare@suse.de>
		 <1392286032-85036-3-git-send-email-hare@suse.de>
		 <20140228170131.GA31510@infradead.org> <5316D459.6070107@suse.de>
		 <20140305194255.GA5607@infradead.org> <53183951.7080805@suse.de>
	 <1394188779.5225.40.camel@dabdike> <5319A494.6020308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:58729 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaCGLBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 06:01:41 -0500
In-Reply-To: <5319A494.6020308@suse.de>
Content-Language: en-US
Content-ID: <D094A7DA7435344E8E9C86A4836EB3F8@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jlinton@tributary.com" <jlinton@tributary.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "kay@vrfy.org" <kay@vrfy.org>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>

On Fri, 2014-03-07 at 11:51 +0100, Hannes Reinecke wrote:
> On 03/07/2014 11:39 AM, James Bottomley wrote:
> > On Thu, 2014-03-06 at 10:01 +0100, Hannes Reinecke wrote:
> >> So the only 'proper' solution would be to add a bitmap of supported
> >> pages; however, this would be 256 bits = 32 bytes of additional
> >> space required for struct sdev.
> >> Which I'm a bit reluctant do to, as it'll be a sparse array in most
> >> cases, adding to quite some wasted space.
> > 
> > Why per sdev?  Isn't it per target?  The supported EVPD page list
> > shouldn't really vary for luns of the same target unless something very
> > strange is happening in the array.
> > 
> Spec says it's per LUN:

Specs say a lot of "interesting" things.  The question is what's common
practise in the field.

> 7.8.16 Supported VPD Pages VPD page
> The Supported VDP Pages VPD page contains a list of the VPD page
> codes supported by the logical unit (see
> table 637).
> 
> so we shouldn't really make any assumptions about what might be
> sensible or strange.

The cardreader case is the one I think causes problems for this.  Going
completely the opposite direction, why do we need to cache this at
all? ... it's fairly simple to request each time and it avoids worrying
about the data changing because of a change in the array.

James

