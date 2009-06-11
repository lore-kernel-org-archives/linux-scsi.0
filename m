From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: Re: ipr boot failure caused by MSI (2.6.30-rc1+)
Date: Wed, 10 Jun 2009 20:23:19 -0700
Message-ID: <4A3078A7.20406@linux.vnet.ibm.com>
References: <1242926159.3007.5.camel@localhost.localdomain> <4A15A1B2.8060609@linux.vnet.ibm.com> <1242935515.3007.10.camel@localhost.localdomain> <1243009395.2873.18.camel@localhost.localdomain> <4A205B40.30306@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45660 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670AbZFKDXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 23:23:20 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5B3BHeU004436
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 23:11:17 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5B3NMFs246952
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 23:23:22 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5B3NL5Y032155
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 23:23:21 -0400
In-Reply-To: <4A205B40.30306@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, ppc-dev <linuxppc-dev@ozlabs.org>, linux-scsi <linux-scsi@vger.kernel.org>



Brian King wrote:
> James Bottomley wrote:
>> On Thu, 2009-05-21 at 14:51 -0500, James Bottomley wrote:
>> I saw the quirk fix for this go by:
>>
>> http://ozlabs.org/pipermail/linuxppc-dev/2009-May/072436.html
>>
>> Is there an easy way to trigger an interrupt on this device?  Preferably
>> in ipr_probe_ioa() so we can at least print out if the interrupts are
>> misrouted and fall back from MSI to normal using the PCI infrastructure?
> 
> I just talked with one of the adapter firmware developers and it sounds like
> this might be possible. I'll work with Wayne on coding something up to try.
> 
> -Brian
> 

I've put together some code to trigger the test MSI and either fall back to
LSI if it isn't detected, or continue on using MSI.  In the routine that
does the setup and test I have this call to request_irq:

rc = request_irq(pdev->irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);

Note that the flags value is '0'.  The question came up as to whether or
not this value should really be IRQF_SHARED.  Given that this is for an MSI
interrupt and MSI interrupts are not shared by definition, IRQF_SHARED did
not seem correct.

What should the flags value be in this case?


-- 
Wayne Boyer
IBM - Beaverton, Oregon
LTC S/W Development - eServerIO
(503) 578-5236, T/L 775-5236
