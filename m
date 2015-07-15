From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] dm-mpath: always return reservation conflict
Date: Wed, 15 Jul 2015 13:56:09 +0200
Message-ID: <20150715115609.GA22391@lst.de>
References: <1436959404-14035-1-git-send-email-hare@suse.de> <1436960108.31121.41.camel@HansenPartnership.com> <55A64980.3070304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47059 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbbGOL4L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2015 07:56:11 -0400
Content-Disposition: inline
In-Reply-To: <55A64980.3070304@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

An array can't issue a reservation, the initiator needs to register
it.  Right now the only way to do it is through SG_IO passthrough,
which is a best luck effort it I/O isn't also using SG_IO and can't
be properly supported because of that.

However I will submit an in-kernel reservation API soon which will
allow us to have that sort of control.  My current prototyp only allows
for all-path reservations as I couldn't come up with a use case for
per-path reservations, but if such a need should arise we can add it
and take that into account in the multipathing code.
