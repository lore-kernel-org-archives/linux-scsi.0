From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/22] scsi: do not decode sense extras
Date: Sun, 31 Aug 2014 15:06:22 -0700
Message-ID: <20140831220622.GC16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaHaWG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:06:26 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Kai.Makisara@kolumbus.fi, Willem Riede <osst@riede.org>

On Thu, Aug 28, 2014 at 07:33:21PM +0200, Hannes Reinecke wrote:
> Currently we're only decoding sense extras for tape devices.
> And even there only for fixed format sense formats.
> As this is of rather limited use in the general case we should
> be stop trying to decode things here and rather dump the entire
> sense code.

I don't like this one at all.  Not that I'm attached to decoding the
extra sense buffer, but:

  - __scsi_print_sense now prints both decoded sense data as well as a
    full dump, which is rather ugly
  - __scsi_print_sense prints that buffer unconditionally

I'd say let's sit down and work with the tape driver maintainers on
finding a better way to deal with their sense printing needs.  And part
of that should probably be to get rid of __scsi_print_sense entirely
and make the tape drivers use pre-decoded and normalized sense buffers.

