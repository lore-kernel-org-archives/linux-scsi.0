From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Mon, 15 Mar 2004 11:09:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4055D54F.8010908@pobox.com>
References: <20040314082444.GA3416@linux.local.home>	<1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de>	<1079276396.2022.8.camel@mulgrave>  <20040314203649.GA1463@havoc.gtf.org> <1079303516.2108.73.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10985 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262641AbUCOQKJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Mar 2004 11:10:09 -0500
In-Reply-To: <1079303516.2108.73.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2004-03-14 at 15:36, Jeff Garzik wrote:
> 
>>On Sun, Mar 14, 2004 at 09:59:55AM -0500, James Bottomley wrote:
>>
>>>The Qla chips are rather weird in that they have a single issue queue
>>>(whose size you can vary) but whose entry formats are fixed.  If I
>>>remember correctly, an initial command can have 4 SG elements, but a
>>>follow on entry can have 7 (not sure of the figures).  But anyway, large
>>>SG commands end up having to find multiple entries in this queue (and
>>>being a single issue queue for the entire card, it has to be mutexed
>>>while you search).  The more resources you need, the more difficult the
>>>search and the more contention you generate on the resource mutex.
>>
>>The block layer can handle this type of hardware just fine ;-)
>>
>>In my SATA hacking I am finding several devices that one must constrain
>>based on hardware-global resources, rather than just TCQ (or lack
>>thereof).
> 
> 
> I'm sorry, I must have missed the multiple queues down to a single HBA
> queue API in the block layer, which one is it again?

Not saying the block layer provides this capability, simply that it is 
possible in any block driver.  It required < 20 LOC in carmel.c to do 
this in a hardware-specific fashion, so it seemed unnecessary to invent 
a new API...  I would like to see something similar in cciss.c, in fact...

	Jeff



