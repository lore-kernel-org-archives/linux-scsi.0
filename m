From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] [Iscsitarget-devel] ISCSI-SCST	performance (with
 also IET and STGT data)
Date: Thu, 02 Apr 2009 19:36:26 +0400
Message-ID: <49D4DB7A.2030004@vlnb.net>
References: <49D10256.8030307@vlnb.net>	<e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>	<49D11096.3070804@vlnb.net>	<e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>	<49D254E4.8050806@vlnb.net>	<E2BB8074E5500C42984D980D4BD78EF9029E3D0B@MFG-NYC-EXCH2.mfg.prv>	<e2e108260903312329u118a54bfn3107fdca4b3e2b1d@mail.gmail.com>	<FA7F6940-CD5C-4460-9777-2F7AE3657B8E@gmail.com>	<1238617423.3318.82.camel@mulgrave.int.hansenpartnership.com>	<49D46B8B.5000708@vlnb.net> <49D47F28.3060409@vlnb.net> <E2BB8074E5500C42984D980D4BD78EF9029E3D14@MFG-NYC-EXCH2.mfg.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:63894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZDBPgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 11:36:35 -0400
In-Reply-To: <E2BB8074E5500C42984D980D4BD78EF9029E3D14@MFG-NYC-EXCH2.mfg.prv>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ross S. W. Walker" <RWalker@medallion.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, iSCSI Enterprise Target Developer List <iscsitarget-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Ross Walker <rswwalker@gmail.com>, stgt@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

Ross S. W. Walker, on 04/02/2009 06:06 PM wrote:
> Vladislav Bolkhovitin wrote:
>> Vladislav Bolkhovitin, on 04/02/2009 11:38 AM wrote:
>>> James Bottomley, on 04/02/2009 12:23 AM wrote:
>>>> SCST explicitly fiddles with the io context to get this to happen.  It
>>>> has a hack to block to export alloc_io_context:
>>>>
>>>> http://marc.info/?t=122893564800003
>>> Correct, although I wouldn't call it "fiddle", rather "grouping" ;)
> 
> Call it what you like,
> 
> Vladislav Bolkhovitin wrote:
>> Ross S. W. Walker, on 03/30/2009 10:33 PM wrote:
>>
>> I would be interested in knowing how your code defeats CFQ's extremely
>> high latency? Does your code reach into the io scheduler too? If not,
>> some code hints would be great.
> 
> Hmm, CFQ doesn't have any extra processing latency, especially 
> "extremely", hence there is nothing to defeat. If it had, how could it 
> been chosen as the default?
> 
> ----------
> List:       linux-scsi
> Subject:    [PATCH][RFC 13/23]: Export of alloc_io_context() function
> From:       Vladislav Bolkhovitin <vst () vlnb ! net>
> Date:       2008-12-10 18:49:19
> Message-ID: 49400F2F.4050603 () vlnb ! net
> 
> This patch exports alloc_io_context() function. For performance reasons 
> SCST queues commands using a pool of IO threads. It is considerably 
> better for performance (>30% increase on sequential reads) if threads in 
>   a pool have the same IO context. Since SCST can be built as a module, 
> it needs alloc_io_context() function exported.
> 
> <snip>
> ----------
> 
> I call that lying.
> 
>>> But that's not the only reason for good performance. Particularly, it 
>>> can't explain Bart's tmpfs results from the previous message, where the 
>>> majority of I/O done to/from RAM without any I/O scheduler involved. (Or 
>>> does I/O scheduler also involved with tmpfs?) Bart has 4GB RAM, if I 
>>> remember correctly, i.e. the test data set was 25% of RAM.
>> To remove any suspicions that I'm playing dirty games here I should note 
> <snip>
> 
> I don't know what games your playing at, but do me a favor, if your too
> stupid enough to realize when your caught in a lie and to just shut up
> then please do me the favor and leave me out of any further correspondence
> from you.

Think what you want and do what you want. You can even filter out all 
e-mails from me, that's your right. But:

1. As I wrote grouping threads into a single IO context doesn't explain 
all the performance difference and finding out reasons for other's 
performance problems isn't something I can afford at the moment.

2. CFQ doesn't have any processing latency and has never had. Learn to 
understand what are your writing about and how to correctly express 
yourself at first. You asked about that latency and I replied that there 
is nothing to defeat.

3. SCST doesn't have any hooks into CFQ and not going to have in the 
considerable future.

> Thank you,
> 
> -Ross

