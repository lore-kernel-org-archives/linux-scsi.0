From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Adaptec SAS integration notes
Date: Tue, 18 Oct 2005 22:36:17 +0200
Message-ID: <43555CC1.8040200@s5r6.in-berlin.de>
References: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com> <43552650.2090104@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43552650.2090104@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, ltuikov@yahoo.com, Mike Anderson <andmike@us.ibm.com>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Luben Tuikov wrote:
[Jeff Garzik wrote:]
>>> * Put HCIL mapping into top-level helper code, for sharing between FC
>>> and SAS (hopefully!)
>>
>> One step further: eliminate the ugly legacy SPI-centric HCIL from
>> SCSI Core.  Minimise and streamline SCSI Core.
> 
> How many times must we repeat:  that's the long term goal.
> 
> Rome wasn't built in a day.

All transports implement HCIL mappings. (SPI drivers enjoy the easiest 
mapping, hcil<->HCIL.) They are all faced with the necessity of mapping 
and solve it in different ways, for different reasons. Why stop at FC + 
SAS and try to find a unified solution for just those two? Also, when 
you are working out how FC and SAS could interface to a common HCIL 
mapping library (or HCIL mapping layer?), you are effectively designing 
aspects of how an interface between FC|SAS and SCSI core should look 
like. Or, why not provide the HCIL mapping helpers in the core and 
subsequently make users of this new interface completely unaware of the 
existence of HCIL...?

Moreover, HCIL mapping is but one aspect of a common problem. As an 
example, I think yet another aspect of the same problem is that device 
properties like target names and LUNs get lost below the 
transport<->core interface. We want to present these device properties 
to userspace in a unified manner. Here it becomes even more clear: 
Neither is it a problem for FC and SAS alone, nor are transport-level 
helpers a good solution to the problem.

I freely admit that I don't have a picture of where the real 
difficulties lie; I am far too unfamiliar with the innards of scsi core. 
But time spent on transport-level helpers which are meant to ease 
symptoms of the transport<->core difficulties seems to be spent rather 
ineffectively to me. More concrete, what is the ratio of benefit to cost 
of HCIL mapping code sharing between SAS and FC? Especially since that 
mapping is deemed obsolete already (in the long term or perhaps even mid 
term). And to completely go back to the subject: Will attempts on code 
sharing between FC layer and SAS layer bring things forward in the 
short-term goal of SAS integration?
-- 
Stefan Richter
-=====-=-=-= =-=- =--=-
http://arcgraph.de/sr/
