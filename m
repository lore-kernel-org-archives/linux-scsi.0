From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] gdth: convert to PCI hotplug API
Date: Fri, 15 Feb 2008 10:44:52 -0500
Message-ID: <47B5B374.2080403@garzik.org>
References: <20080212234928.GA13892@havoc.gtf.org> <1203024822.3158.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50413 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYBOPoy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 10:44:54 -0500
In-Reply-To: <1203024822.3158.29.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Jiri Slaby <jirislaby@gmail.com>

James Bottomley wrote:
>> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
>> index c825239..1b53e92 100644
>> --- a/drivers/scsi/gdth.c
>> +++ b/drivers/scsi/gdth.c
>> @@ -595,85 +595,107 @@ static int __init gdth_search_isa(ulong32 bios_adr)
>>  #endif /* CONFIG_ISA */
>>  
>>  #ifdef CONFIG_PCI
>> -static void gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
>> -                            ushort vendor, ushort dev);
>> +static gdth_pci_str gdth_pcistr[MAXHA];
>> +static int gdth_pci_cnt;
>> +static bool gdth_pci_registered;
> 
> Could we get rid of these static arrays and MAXHA entirely?  It should
> be possible just to bung the parameters in pci_str into gdth_ha_str and
> dump the arrays.


I kept those array for one reason:  you need it to preserve the existing 
in-driver PCI device sort.

If we can eliminate the sorting, then the array can easily disappear.

I /think/ the sort can be eliminated now because we have pci=reverse, 
but I have not verified that guess.

	Jeff



