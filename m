From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/17] Add ida and idr helper routines.
Date: Tue, 15 Sep 2015 11:20:23 -0700
Message-ID: <1442341223.2177.8.camel@HansenPartnership.com>
References: <cover.1442263512.git.lduncan@suse.com>
	 <915ec9ff5e9cc1fae0b36bf7d4c4cb115439e15d.1442263512.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55577 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbbIOSUZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Sep 2015 14:20:25 -0400
In-Reply-To: <915ec9ff5e9cc1fae0b36bf7d4c4cb115439e15d.1442263512.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Tejun Heo <htejun@gmail.com>

On Tue, 2015-09-15 at 09:46 -0700, Lee Duncan wrote:
> Clients of the ida and idr index-management routines
> tend to use the same calling sequences much of the time,
> so this change adds helper functions for allocating and
> releasing indexes of either flavor, i.e. with or
> without pointer management.
> 
> Inline functions added for idr:
>   idr_get_index_in_range
>   idr_get_index (in range 0,0)
>   idr_put_index
> And for ida:
>   ida_get_index
>   ida_put_index

Every consumer of this I've seen seems to have the pattern of allocating
the ida and the protecting spinlock together.  If that's the case, why
not move the spinlock into struct ida so it doesn't have to be
separately allocated and passed in to all the helpers?

Also, you need a cc of Tejun (added on this one) because he's the one
who last did significant work in ida/idr.

James


