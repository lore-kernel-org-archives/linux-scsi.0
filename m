From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt handler
Date: Tue, 9 Jun 2009 15:30:48 -0700
Message-ID: <1B844BFF-3BA7-4146-9863-93D9D4E0D22C@qlogic.com>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local> <1244575944.12321.58.camel@mulgrave.site> <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com> <1244580029.12321.138.camel@mulgrave.site> <alpine.OSX.1.00.0906091436120.4405@ac-mac.local> <20090609214342.GQ3274@parisc-linux.org> <6FEBF8A9-AA4F-496A-B549-AE5D4275A8A4@qlogic.com> <20090609214759.GR3274@parisc-linux.org>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52362 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZFIWaq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 18:30:46 -0400
In-Reply-To: <20090609214759.GR3274@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "douglas.w.styner@intel.com" <douglas.w.styner@intel.com>


On Jun 9, 2009, at 2:47 PM, Matthew Wilcox wrote:

> On Tue, Jun 09, 2009 at 02:46:12PM -0700, Anirban Chakraborty wrote:
>>
>> On Jun 9, 2009, at 2:43 PM, Matthew Wilcox wrote:
>>> While I don't think Doug has MSI-X adapters, a complete patch would
>>> change
>>> all request_irq() calls to use IRQF_DISABLED, right?
>>
>> The above patch takes care of replacing all the IRQF_SHARED flags  
>> in irq
>> registrations with IRQF_DISABLED.
>
> Yes ... but even for the MSI-X case, you want the handler to be run  
> with
> interrupts disabled, don't you?  If not, why not?

Yeah you're right. For some reason, request_irq for MSI-X passes 0 as  
the irq flag. We need to take care of that.
Thanks,
Anirban

