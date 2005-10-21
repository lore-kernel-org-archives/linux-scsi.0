From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached
 PHYs)
Date: Fri, 21 Oct 2005 17:12:30 -0400
Message-ID: <435959BE.5040101@pobox.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>	 <20051020170330.GA16458@lst.de>  <4357F7DE.7050004@adaptec.com> <1129852879.30258.137.camel@bluto.andrew> <43583A53.2090904@pobox.com> <435929FD.4070304@adaptec.com> <43593100.5040708@pobox.com> <43593884.7000800@adaptec.com> <4359395B.9030402@pobox.com> <43593FE1.7020506@adaptec.com> <4359440E.2050702@pobox.com> <43595275.1000308@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965168AbVJUVMy@vger.kernel.org>
In-Reply-To: <43595275.1000308@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> On 10/21/05 15:39, Jeff Garzik wrote:
> 
>>The technical stuff got covered long ago.  Here are the basic basics:
>>
>>* aic94xx needs to have the scsi-host-template in the LLDD, to fix 
>>improper layering.
>>* SAS generic code needs to use SAS transport class, which calls 
>>scsi_scan_target(), to avoid code duplication.
>>* other stuff I listed in my "analysis" email, including updating libata 
>>to support SAS+SATA hardware.
> 
> 
> All this bastardizes the code and the layering infrastructure.
> 
> If you're saying that there is "improper layering" you must be
> smoking something really strong.

I already described why.  Examples are DMA boundary and s/g limit, among 
others.  When confronted with this, you proposed an additional hardware 
information struct which duplicates Scsi_Host_Template.

Solution?  Just use Scsi_Host_Template.  Take a look at how each libata 
driver is implemented.  The host template is in the low level driver, 
while most of the code is common code, implemented elsewhere.



>>If you were willing to do this stuff, _working with others_, then I 
>>would be off in happy happy SATA land right now, and you would have been 
>>nominated to be the Linux SAS maintainer.
> 
> 
> You seem to be traveling a path which I've already traveled.
> 
> Jeff, if you want an Adaptec SAS driver which has the host template
> _in_ the driver, you can use "adp94xx" submitted earlier this year
> by Adaptec to "the community".
> 
> "The community" rejected it. Why?  Because "common SAS tasks should
> be in a common layer".  Well there you have the Linux SAS Stack and
> aic94xx at the link below (my sig), which does separate common SAS
> tasks and the interconnect _as per architecture and spec_.  Apparently
> this still isn't good enough for "the community".
> 
> You see how this going around in circles just never seems to end.
> 
> One day one thing, another day the opposite, etc.

Your current code is much closer to the desired end result, as it 
separates out SAS common code.  That's why its being used as a base.

	Jeff
