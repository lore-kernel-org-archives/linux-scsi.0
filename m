From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] [SCSI] sym53c8xx: increase sg_tablesize for	larger	data
 transfers
Date: Thu, 15 Nov 2007 14:57:09 -0500
Message-ID: <473CA495.20408@cybernetics.com>
References: <473C6084.2040700@cybernetics.com>	 <1195143006.3407.20.camel@localhost.localdomain>	 <473C7606.7050608@cybernetics.com> <1195145875.3407.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:4870 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbXKOT5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 14:57:06 -0500
In-Reply-To: <1195145875.3407.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2007-11-15 at 11:38 -0500, Tony Battersby wrote:
>   
>> James Bottomley wrote:
>>     
>>> On Thu, 2007-11-15 at 10:06 -0500, Tony Battersby wrote:
>>>   
>>>       
>>>> This patch increases the sg_tablesize for sym53c8xx from 96 to 128,
>>>> which enables commands to transfer larger amounts of data (e.g. 512 KB
>>>> instead of 384 KB, assuming 4 KB non-adjacent pages).
>>>>
>>>> In the current design of sym53c8xx, SYM_CONF_MAX_SG must be set low
>>>> enough so that (sym_fw1.a_size <= PAGE_SIZE) && (sym_fw2.a_size <=
>>>> PAGE_SIZE).  With SYM_CONF_MAX_SG == 128, sym_fw1.a_size == 3940 and
>>>> sym_fw2.a_size == 3576 (plus or minus a few bytes depending on other
>>>> configuration options).  The a_size values increase by 16 for every
>>>> additional sg vector, so SYM_CONF_MAX_SG cannot be set much higher than
>>>> 128 without making more intrusive changes.
>>>>     
>>>>         
>>> This has been suggested before.  I thought the problem was there were
>>> some cards of the 875 ilk that choke on a sg table larger than 96?  If I
>>> recall the conversation correctly, the claim was made, but no-one
>>> managed to turn up the errata that showed it.
>>>
>>> James
>>>
>>>
>>>   
>>>       
>> I will try to get ahold of some 875's to test.
>>     
>
> Thanks ... even if there's a problem, we can take your hard coded update
> and dynamically (probably via PCI ID) lower the host->sg_tablesize for
> the problem cards at probe time, so they'll never see the longer list.
>
> James
>
>
>
>   
I tested three 53c875 HBAs and didn't find any problems.  However, I
don't have every chip variation ever manufactured to test, so I suppose
there still might be a chip that doesn't work.  These are the chips I
was able to test (in addition to the 53c1010-66):

HBA: 53c875 single-port HVD 40 MB/s
PCI ID: PCI_VENDOR_ID_LSI_LOGIC (0x1000) PCI_DEVICE_ID_NCR_53C875
(0x000f) revision 04

HBA: 53c876 dual-port HVD 40 MB/s
PCI ID: PCI_VENDOR_ID_LSI_LOGIC (0x1000) PCI_DEVICE_ID_NCR_53C875
(0x000f) revision 14

Test:
write/read/compare with constantly-changing random data
512 KB (128 scatter-gather vectors) per CDB
(128 sg vectors / CDB verified by printk("%u\n", cmd->use_sg) from
sym53c8xx_queue_command())
test length: 10 GB

How do you want to handle this?  Increase sg_tablesize for all chips
(tested or not), or just those chips that have been verified to work? 
Add a module parameter to use a smaller sg_tablesize if someone
encounters a problem?  Personally, I would be content with increasing it
just on the modern Ultra2 and Ultra3 HBAs (895 and later).

Incidentally, it should also be possible to make fw->a_size independent
of SYM_CONF_MAX_SG by having SCRIPTS perform a loop with a counter
register instead of having a separate SCR_CHMOV_TBL command for every sg
vector.  This would make sg_tablesize > 128 possible.  I know that this
technique works on 875, 876, 895, 896, and 1010 because I wrote a
target-mode driver that does it.  However, making that change is a bit
more complicated than I had in mind.

Tony

