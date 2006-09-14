From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v3] libsas: move ATA bits into a separate module
Date: Thu, 14 Sep 2006 18:49:51 -0400
Message-ID: <4509DC8F.6030900@garzik.org>
References: <4508A0A2.2080605@us.ibm.com> <450971D3.2040405@garzik.org> <4509DA77.7000508@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60116 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932091AbWINWty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Sep 2006 18:49:54 -0400
In-Reply-To: <4509DA77.7000508@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>

Darrick J. Wong wrote:
> Jeff Garzik wrote:
> 
>> I disagree completely with this approach.
>>
>> You don't need a table of hooks for the case where libata is disabled in
>> .config.  Thus, it's only useful for the case where libsas is loaded as
>> a module, but libata is not.
> 
> Indeed, I misunderstood what James Bottomley wanted, so I reworked the
> patch.  It has the same functionality as before, but this module uses
> the module loader/symbol resolver for all the functions in libata, and
> allows libsas to (optionally) call into sas_ata with weak references by
> pushing a table of the necessary function pointers into libsas at
> sas_ata load time.  Thus, libsas doesn't need to load libata/sas_ata
> unless it actually finds a SATA device.
> 
>> The libsas code should directly call libata functions.  If ATA support
>> in libsas is disabled in .config, then those functions will never be
>> called, thus never loaded the libata module.
> 
> I certainly can (and now do) call libata functions from sas_ata.
> However, there are a few cases where libsas needs to call libata (ex.
> sas_ioctl); for those cases, I think the function pointers are still
> necessary because I don't want to make libsas require libata.  In any
> case, if ATA support is disabled in .config, sata_is_dev always returns
> 0, so the dead-code eliminator should zap that out of libsas entirely.

Looks MUCH better to me, and eliminates my objection to the 
libata-related hooks.

There remains the issue that I poke James about on IRC, namely that 
there is no need to emulate the SATA phy registers.  libata permits a 
driver high level access to the ATA engine without needing SATA SCRs. 
Witness all the PATA drivers, which obviously do not have SCRs at all.

	Jeff



