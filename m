From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 06 Aug 2008 09:35:43 -0700
Message-ID: <1218040543.7493.10.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
	 <20080806142521.GK2055@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57192 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478AbYHFQhA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 12:37:00 -0400
In-Reply-To: <20080806142521.GK2055@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Hugh Dickins <hugh@veritas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 08:25 -0600, Matthew Wilcox wrote:
> On Wed, Aug 06, 2008 at 03:06:21PM +0100, Hugh Dickins wrote:
> > Commit e0597d70012c82e16ee152270a55d89d8bf66693 (sd: Identify DIF protection
> > type and application tag ownership) says that if a disk is formatted with
> > Inquiry bit PROTECT=1, it is required to support Read Capacity(16).  But my
> > SD cards, accessed by builtin cardreader and generic USB storage, disagree.
> > 
> > Therefore fall back to the familiar Read Capacity if Read Capacity(16) fails:
> > without even showing the "failed" message since I expect this will be common.
> 
> How about we flip it around?  Unconditionally try READ CAPACITY 16 first,
> then if that fails, try READ CAPACITY?  I suppose there's always the
> possibility that a drive will go tits-up if it receives the RC16
> command, so maybe we'll need a blacklist.

I don't think so ... the read capacity logic looks the way it does
because we had a bit of trouble with USB devices simply going out to
lunch on READ_CAPACITY(16) ... otherwise we'd have done the 16 then
fallback to 10 ages ago.

The best way is probably a blacklist for protect ... I assume there's no
plans in the near future for USB to support it, so we could just turn it
off globally in USB slave configure.

James


