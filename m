From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/10] megaraid_sas: Updates for scsi-misc
Date: Wed, 12 Oct 2011 09:31:37 +0200
Message-ID: <4E954259.1030909@suse.de>
References: <CAHtARFGh5i6M8SMqjeUnpUP=dWNdwdmDhGo+z4h4qE8r18xhWA@mail.gmail.com>	 <4E91A813.1070003@interlog.com> <1318169420.2998.6.camel@dabdike.int.hansenpartnership.com> <4E9242DB.7040401@interlog.com> <4E92987F.8030507@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1JLHbs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2011 03:31:48 -0400
In-Reply-To: <4E92987F.8030507@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On 10/10/2011 09:02 AM, Hannes Reinecke wrote:
> On 10/10/2011 02:56 AM, Douglas Gilbert wrote:
>> On 11-10-09 10:10 AM, James Bottomley wrote:
>>> On Sun, 2011-10-09 at 09:56 -0400, Douglas Gilbert wrote:
>>>> On 11-10-08 09:14 PM, adam radford wrote:
>>>>> James/Linux-scsi,
>>>>>
>>>>> The following patch series for megaraid_sas brings the driver up
>>>>> to v6.12-rc1:
>>>>>
>>>>> 1. Continue booting immediately if FW in FAULT at driver load
>>>>> time.
>>>>> 2. Increase default cmds per lun to 256.
>>>>> 3. Fix mismatch in megasas_reset_fusion() mutex lock-unlock.
>>>>> 4. Remove some un-necessary code.
>>>>> 5. Clear state change interrupts for Fusion/Invader.
>>>>> 6. Clear FUSION_IN_RESET before enabling interrupts.
>>>>> 7. Add support for MegaRAID 9360/9380 12GB/s controllers.
>>>>> 8. Add multiple MSI-X vector/multiple reply queue support.
>>>>> 9. Add driver workaround for PERC5/1068 kdump kernel panic.
>>>>> 10. Version and Changelog update.
>>>>
>>>> I haven't checked all SAS HBAs in Linux but of those that I
>>>> have checked only one doesn't support the SMP pass-through
>>>> in the bsg driver. And that HBA driver is megaraid_sas **.
>>>
>>> Technically the megaraid_sas isn't really a SAS HBA, it's a RAID on=
e
>>> that just happens to have SAS/SATA disk attachments. None of the
>>> RAID
>>> HBA's (including the IBM power raid) expose a BSG interface or even
>>> attach properly to the in-kernel SAS interfaces.
>>
>> In JBOD mode MegaRaid SAS controllers are SAS HBAs
>> (marketing BS aside). Their firmware has the same
>> SMP pass-through as LSI's MPT SAS Fusion controllers.
>>
>> There is no reason why a MegaRaid controller user
>> couldn't place a SAS-2 expander in front of an array
>> of disks and make some disks available to a MegaRaid
>> volume. Other array disks could be used by other
>> machines and the different sets could be isolated
>> from each other with SAS-2 zoning. The problem then
>> would be that via a MegaRaid SAS controller a user
>> could not monitor or control that zoning. Seems a
>> bit wasteful to add a "real" SAS HBA just to get
>> that capability.
>>
> Yes, true. But that's the megaraid SAS design.
> It's actually the same with every other RAID controller.
> Everyone (well, every reasonably recent one) supports SAS, but
> virtually no-one exposes them as such.
>
> Problem here is that the RAID controller have invented
> their own command set to talk to the RAID firmware.
> Most RAID firmware have support for SCSI passthrough
> commands (that's how we managed to get rid of cciss :-)
> but virtually none of those have support for transport-specific
> passthrough commands.
>
Correction: megaraid_sas has.

It's got two command definitions:

#define MFI_CMD_SMP 0x7
#define MFI_CMD_STP 0x8

Which indeed look like they could've been used to implement the=20
respective bsg interface.

Hmm.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
