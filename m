From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] sd: Refactor sd_read_capacity()
Date: Fri, 13 Mar 2009 17:45:23 -0400
Message-ID: <yq14oxxksgc.fsf@sermon.lab.mkp.net>
References: <1236882030-27964-1-git-send-email-willy@linux.intel.com>
	<1236882030-27964-2-git-send-email-willy@linux.intel.com>
	<1236979776.31764.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:65056 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZCMVpe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2009 17:45:34 -0400
In-Reply-To: <1236979776.31764.2.camel@localhost.localdomain> (James Bottomley's message of "Fri\, 13 Mar 2009 16\:29\:36 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> On Thu, 2009-03-12 at 14:20 -0400, Matthew Wilcox wrote:
>> +#define RC16_LEN 13

James> Shouldn't this be 32, the defined length of a READ CAPACITY 16
James> return?

James> In theory asking for less is fine, since the spec allows it, but
James> it's setting a trap for expanded users of READ_CAPACITY 16 since
James> they might blindly use a buffer[13] or beyond, not realising we
James> didn't actually ask for data beyond buffer[12].

I have this bumped to 16 in my tree (after being bitten by what you
describe).  I'm open to upping it further even if none of the remaining
16 bytes have been defined yet.

-- 
Martin K. Petersen	Oracle Linux Engineering

