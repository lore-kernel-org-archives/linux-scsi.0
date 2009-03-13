From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] sd: Refactor sd_read_capacity()
Date: Fri, 13 Mar 2009 16:29:36 -0500
Message-ID: <1236979776.31764.2.camel@localhost.localdomain>
References: <1236882030-27964-1-git-send-email-willy@linux.intel.com>
	 <1236882030-27964-2-git-send-email-willy@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45794 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758721AbZCMV3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Mar 2009 17:29:40 -0400
In-Reply-To: <1236882030-27964-2-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Thu, 2009-03-12 at 14:20 -0400, Matthew Wilcox wrote:
> +#define RC16_LEN 13

Shouldn't this be 32, the defined length of a READ CAPACITY 16 return?

In theory asking for less is fine, since the spec allows it, but it's
setting a trap for expanded users of READ_CAPACITY 16 since they might
blindly use a buffer[13] or beyond, not realising we didn't actually ask
for data beyond buffer[12].

James


