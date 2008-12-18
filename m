From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: READ CAPACITY 16
Date: Thu, 18 Dec 2008 16:59:11 +0200
Message-ID: <494A653F.2000403@panasas.com>
References: <20081217164210.GC19967@parisc-linux.org>	 <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com>	 <20081217180640.GE19967@parisc-linux.org> <494A1272.8040008@panasas.com>	 <20081218140851.GI19967@parisc-linux.org>  <494A6064.70601@panasas.com> <1229611966.4963.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:1403 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751257AbYLRO7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 09:59:14 -0500
In-Reply-To: <1229611966.4963.41.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-12-18 at 16:38 +0200, Boaz Harrosh wrote:
>> OK Then I say D, go to T10, while white list the (0) devices that currently
>> report !SCSI_3 but do support UNMAP. These are only USB right?
>>
>> Your tested devices report SCSI_3? Do all devices that are scsi_level > SCSI_2
>> suppose to support RC16?
> 
> The problem isn't whether they support it or not.  A proper standards
> compliant SCSI device can be sent READ CAPACITY(16) and just return
> ILLEGAL REQUEST sense quite normally.  If those were all the devices in
> the world, we'd send 16 first and fall back to 10.
> 
> The problem is that there are devices (USB devices) that go haywire when
> sent a READ CAPACITY 16 command (or, indeed, any other SCSI command not
> in their vocabulary).  It's for these devices that we do the 10->16
> dance the way we do in sd.c
> 
> Our problem is to identify devices that could reliably receive (and this
> doesn't mean process it just means return a standards compliant response
> without crashing or going out to lunch) READ CAPACITY 16 because the
> current Thin Provisioning draft requires this to indicate thin
> provisioning support.
> 
> My take is still that TP devices have to be SCSI-3 SBC-3 or higher, so
> we just check this and for them do READ CAPACITY 16 with fallback to 10
> on ILLEGAL REQUEST return.  USB has to whitelist the TP compliant
> devices and not mangle the inquiry version field down to SCSI_2 for them
> and the world will just work.
> 
>> My point is make the standard, which is still a draft, crystal clear
>> in a backward compatible way. All new, supporting, devices can be easily
>> identified, and the very few devices that do support the new fixture but
>> were released prior to the finalization of the draft be white-listed.
>> And in any event don't let the standard be broken like that.
> 
> James
> 
> 

OK Jams Mathew thanks that makes sense.

All these emulation layers being in HW, USB, or SW, libata will have to attempt
an higher-then-SCSI_2 if they want RC16 stuff, full stop. That sounds safe to
me, and the market will win.

Boaz
