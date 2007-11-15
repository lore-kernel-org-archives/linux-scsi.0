From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] sym53c8xx: increase sg_tablesize for larger
	data transfers
Date: Thu, 15 Nov 2007 10:10:06 -0600
Message-ID: <1195143006.3407.20.camel@localhost.localdomain>
References: <473C6084.2040700@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:37362 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757303AbXKOQKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Nov 2007 11:10:15 -0500
In-Reply-To: <473C6084.2040700@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Thu, 2007-11-15 at 10:06 -0500, Tony Battersby wrote:
> This patch increases the sg_tablesize for sym53c8xx from 96 to 128,
> which enables commands to transfer larger amounts of data (e.g. 512 KB
> instead of 384 KB, assuming 4 KB non-adjacent pages).
> 
> In the current design of sym53c8xx, SYM_CONF_MAX_SG must be set low
> enough so that (sym_fw1.a_size <= PAGE_SIZE) && (sym_fw2.a_size <=
> PAGE_SIZE).  With SYM_CONF_MAX_SG == 128, sym_fw1.a_size == 3940 and
> sym_fw2.a_size == 3576 (plus or minus a few bytes depending on other
> configuration options).  The a_size values increase by 16 for every
> additional sg vector, so SYM_CONF_MAX_SG cannot be set much higher than
> 128 without making more intrusive changes.

This has been suggested before.  I thought the problem was there were
some cards of the 875 ilk that choke on a sg table larger than 96?  If I
recall the conversation correctly, the claim was made, but no-one
managed to turn up the errata that showed it.

James


