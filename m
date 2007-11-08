From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] [SCSI] sym53c8xx: fix setflag user command to control
 disconnects
Date: Thu, 08 Nov 2007 13:11:01 -0500
Message-ID: <47335135.6010103@cybernetics.com>
References: <4732221B.1000104@cybernetics.com> <1194544034.4018.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:2933 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761176AbXKHSK6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 13:10:58 -0500
In-Reply-To: <1194544034.4018.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2007-11-07 at 15:37 -0500, Tony Battersby wrote: 
>   
>> This patch fixes the sym53c8xx "setflag" user command to control
>> disconnect privilege, which has been broken for a long time.
>>     
>
> The first observation is that the sym specific setflags interface is
> being replaced by the parallel transport specific sysfs interface.
> However, as you've probably noticed, the SPI transport has no flag for
> disconnect permission, so how important actually is this?  If it's
> important, then we can put it in scsi_transport_spi ... if not, then we
> should probably just eliminate it from sym2.
>
> James
Most people would probably just use the HBA's BIOS utility to configure
the NVRAM to disallow disconnects if needed.  However, in my case, the
HBA is inside an embedded device sold by my company, and customers can
attach their own SCSI devices to it.  There is one type of SCSI device
that we support which doesn't work with disconnect privilege enabled, so
my code running in the embedded device needs to be able to
enable/disable disconnect privilege dynamically based on whether or not
the customer has attached this specific broken device.

It would be nice to have a generic way to control it.  That would save
me the bother of sending my patch to control disconnect privilege for
LSI MPT Fusion Ultra320 HBAs via mptctl.  ;-)

Tony

