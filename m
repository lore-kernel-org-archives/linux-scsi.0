From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Sat, 6 Sep 2014 07:44:06 -0700
Message-ID: <20140906144406.GA25469@infradead.org>
References: <5403AB47.3040706@interlog.com>
 <20140905052402.GA27094@infradead.org>
 <5409C116.5060702@interlog.com>
 <5409D5D0.8060801@acm.org>
 <540B1CC6.8010800@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaIFOoH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Sep 2014 10:44:07 -0400
Content-Disposition: inline
In-Reply-To: <540B1CC6.8010800@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Milan Broz <gmazyland@gmail.com>

On Sat, Sep 06, 2014 at 10:40:06AM -0400, Douglas Gilbert wrote:
> And they do call scsi_remove_host(). But they do that toward
> the end of their clean-up. The problem that I observed has
> already happened before that.
> 
> IOW I think the QUEUE_FLAG_DYING state needs to be set and
> acknowledged as the first order of business by the code
> that implements 'rmmod LLD'.

That's how driver should implement their ->remove driver callback:

foo_remove()
{
	scsi_remove_host()
	< actual cleanup here>

	scsi_host_put();
}

if a driver doesn't do that, thats a bug in the driver which needs
fixing.
