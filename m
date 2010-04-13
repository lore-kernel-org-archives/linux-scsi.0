From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/VM TOPIC] Handling of invalid requests in virtual HBAs
Date: Tue, 13 Apr 2010 10:56:40 +0200
Message-ID: <4BC431C8.9020800@suse.de>
References: <4BB45632.5020700@suse.de> <4BC099C5.9090704@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55703 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab0DMI4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2010 04:56:44 -0400
In-Reply-To: <4BC099C5.9090704@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: lsf10-pc@lists.linuxfoundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Vladislav Bolkhovitin wrote:
> Hello Hannes,
>=20
> Hannes Reinecke, on 04/01/2010 12:15 PM wrote:
>> Hi all,
>>
>> [Topic]
>> Handling of invalid requests in virtual HBAs
>>
>> [Abstract]
>> This discussion will focus on the problem of correct request handlin=
g
>> with virtual HBAs.
>> For KVM I have implemented a 'megasas' HBA emulation which serves as=
 a
>> backend for the
>> megaraid_sas linux driver.
>> It is now possible to connect several disks from different (physical=
)
>> HBAs to that
>> HBA emulation, each having different logical capabilities wrt
>> transfersize,
>> sgl size, sgl length etc.
>>
>> The goal of this discussion is how to determine the 'best' capabilit=
y
>> setting for the
>> virtual HBA and how to handle hotplug scenarios, where a disk might =
be
>> plugged in
>> which has incompatible settings from the one the virtual HBA is usin=
g
>> currently.
>=20
> If I understand correctly, you need to allow several KVM guests to sh=
are
> the same physical disks?
>=20
No, the other way round: A KVM guest is using several physical disks,
each of which coming via a different HBA (eg sda from libata, sdb from =
lpfc
and the like).
So each request queue for the physical disks could be having different
capabilities, while being routed through the same virtual HBA in the
KVM guest.

The general idea for the virtual HBA is that scatter-gather lists
could be passed directly from the guest to the host (as opposed to
abstract single I/O blocks only like virtio).
But the size and shape of the sg lists is different for devices
coming from different HBAs, so we have two options here (this is
all done on the host side; the guest will only see one HBA):

a) Adjust the sg list to match the underlying capabilities of
   the device. Has the drawback that we defeat the elevator
   mechanism in the guest side as the announced capabilities
   there do _not_ match the capabilities on the host :-(
b) Adjust the HBA capabilities to the lowest common denominator
   of all physical devices presented to the guest.
   While this would save us from adjusting the sg lists,
   it still has the drawback the disk hotplugging won't
   work, as we can't readjust the HBA parameters in the
   guest after it's been created.

Neither of which is really appealing.

My idea here would be to move all required capabilities
to the device/request queue.
That would neatly solve this issue once and for all.
And even TGT, LIO-target, and SCST would benefit from this
methinks.

But this is exactly the discussion I'd like to have at LSF,
to see which approach is best or favoured.

And yes, I am perfectly aware that for a 'production'
system one would be using a proper target emulator
like LIO-target or SCST for this kind of setup.
But first I have to convince the KVM/Qemu folks to
actually include the megasas emulation.
Which they won't until the above problem is solved.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
