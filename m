From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 1/2] scsi core: alloc_cmnd
Date: Tue, 23 Oct 2007 18:49:17 +0200
Message-ID: <471E260D.6030605@panasas.com>
References: <20071019183331.GC30807@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:25047 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752403AbXJWQtY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 12:49:24 -0400
In-Reply-To: <20071019183331.GC30807@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 19 2007 at 20:33 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> This fairly naive patch introduces alloc_cmnd and destroy_cmnd.  I'm not
> exactly happy about passing down the gfp_mask -- I'd prefer to be able
> to allocate scsi_cmnds before we grab the queue_lock (and hence get
> rid of the possibility we might need to GFP_ATOMIC), but I don't see
> anywhere to do that.  Maybe there's a simple change we can make to the
> block layer to allow it.
> 
> Merely-an-RFC-by: Matthew Wilcox <willy@linux.intel.com>

You know Matthew when you first talked about this, I envisioned
something else.

My idea was to have a new variable in scsi_host_template that states
the host_cmnd_extra_bytes. The mid-layer allocates a mempool with
sizeof(struct scsi_cmnd) + host_cmnd_extra_bytes.
A utility function will return that space for drivers given
a cmnd like:
void *host_cmnd_priv(struct scsi_cmnd *cmd)
{
	return cmd + 1;
}

This serves the drivers well because all they need to do is set
host_cmnd_extra_bytes = size_of(my_cmnd_stuff) and start using
it. much more simple than setting up cache pools. It also keeps
the Q per host vs Q per driver.

This also solves your problem with locks and allocation flags
since nothing changes, and it is all private to the mid-layer.

And it serves me, because when bidi comes I just do:
sizeof(struct scsi_cmnd) + host_cmnd_extra_bytes + sizeof(bidi_stuff)
for hosts that support bidi. And the rest of the work was done by you.

Do you need that I scribble some tryout patch for above + example driver

Thanks for doing this
Boaz

