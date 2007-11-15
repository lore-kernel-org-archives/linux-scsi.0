From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] [SCSI] sym53c8xx: increase sg_tablesize for larger	data
 transfers
Date: Thu, 15 Nov 2007 11:38:30 -0500
Message-ID: <473C7606.7050608@cybernetics.com>
References: <473C6084.2040700@cybernetics.com> <1195143006.3407.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:4328 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757953AbXKOQi1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 11:38:27 -0500
In-Reply-To: <1195143006.3407.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2007-11-15 at 10:06 -0500, Tony Battersby wrote:
>   
>> This patch increases the sg_tablesize for sym53c8xx from 96 to 128,
>> which enables commands to transfer larger amounts of data (e.g. 512 KB
>> instead of 384 KB, assuming 4 KB non-adjacent pages).
>>
>> In the current design of sym53c8xx, SYM_CONF_MAX_SG must be set low
>> enough so that (sym_fw1.a_size <= PAGE_SIZE) && (sym_fw2.a_size <=
>> PAGE_SIZE).  With SYM_CONF_MAX_SG == 128, sym_fw1.a_size == 3940 and
>> sym_fw2.a_size == 3576 (plus or minus a few bytes depending on other
>> configuration options).  The a_size values increase by 16 for every
>> additional sg vector, so SYM_CONF_MAX_SG cannot be set much higher than
>> 128 without making more intrusive changes.
>>     
>
> This has been suggested before.  I thought the problem was there were
> some cards of the 875 ilk that choke on a sg table larger than 96?  If I
> recall the conversation correctly, the claim was made, but no-one
> managed to turn up the errata that showed it.
>
> James
>
>
>   
I will try to get ahold of some 875's to test.

Tony

