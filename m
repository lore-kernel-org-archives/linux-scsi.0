From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Need help with libata error handling in libsas
Date: Mon, 25 Feb 2008 12:45:21 -0500
Message-ID: <47C2FEB1.7020303@garzik.org>
References: <1203886936.3135.75.camel@localhost.localdomain>	 <47C2EE15.3060105@linux.vnet.ibm.com> <1203958631.3254.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1203958631.3254.48.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-02-25 at 10:34 -0600, Brian King wrote:
>> The new libata-eh is used for more than just EH. It is used for device
>> probing, device revalidation, and power management. It is also woken for
>> all command failures and is where the request sense for ATAPI devices is
>> issued. Device revalidation following reset is also critical for ATA and
>> ATAPI devices. One example of this is some SATA/PATA converter chips
>> lose their DMA xfer settings following a reset and default to PIO mode
>> only. Any DMA transfer that is attempted simply hangs.

Strongly seconded.  Doing your own ATA EH would be foolish, as that 
would imply duplicating all that carefully-time-tested logic handling 
devices which follow the ATA specs... about 98% of the time :)

Just the set-transfer-mode logic took years to get right for the 
majority of ATA devices.


> OK ... I'm grepping around in the source trying to figure out all of
> this.  Is it documented anywhere?  That would really help me out at the
> moment.

Unfortunately, not really.  The simplistic version is...  freeze, set 
some flags, call a function to schedule EH as needed -- most notably 
when your HBA signals an ATA device error or some other error in the ATA 
domain.


Regardless of all this...   libsas IMO will cause some libata-EH growing 
pains.  libsas needs libata-EH for probing, revalidation, 
initialization, etc.  But libsas probably does NOT need libata-EH for 
certain duties like SATA PHY diagnosis and link handling.

libsas needs libata-EH.  Unfortunately for libsas, libata-EH was written 
from the "libata controls the world" point of view, and probably needs 
some modifications to play well in the new SATA/SAS shared worldview.

Brian's recommendation is quite sane...  your ->error_handler() probably 
just needs hard reset (aka COMRESET) capability.

	Jeff



