From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 07 Feb 2012 12:56:04 +0100
Message-ID: <4F311154.9080407@de.ibm.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F30F4EE.4080607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Hoff <christian.hoff@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>> +                cmd->req.cmd = (struct virtio_scsi_cmd_req){
>> +                                .lun[0] = 1,
>> +                                .lun[1] = sc->device->id,
>> +                                .lun[2] = (sc->device->lun>>  8) | 0x40,
>> +                                .lun[3] = sc->device->lun&  0xff,
>> +                               [...]
>> +                };
>>
>> Can't we have seperate fields for the SCSI target ID and the LUN number
>> here? Putting all this into a single field seems confusing. The following
>> line of code (sc->device->lun>>  8) | 0x40 essentially means that LUN
>> numbers will be limited to 8+6 Bits=14 Bits for no obvious reason that I
>> can see. Maybe we could just split the LUN field up into two uint32 fields
>> for target ID and LUN number?
> 
> The 14-bit limitation can be lifted.  SAM defines a 24-bit LUN format too, 
> but I've never seen it used in practice.

Why not lift that limitation before the first version is committed upstream?

As far as I see we have to allocate multiple target ids if we want
to provide multipath (e.g. 8 target ids if there are 8 pathes, thus limiting
ourselves to 64 targets, no?)

As a compromise between space/flexibility, cant we just split the 4 bytes
in a similar fashion as our major/minor numbers (12/20bit)?

In the mainframe area I have seen real-life problems hitting the 64k 
device limit for disks (mostly due to multipathing), it was extended
afterwards, but every extension tends to make an interface less
appealing. (look at some virtio drivers and you will find places
were feature bits made the code "less pretty")
> 
>> Also, lun[1] = sc->device->id means that only 255 SCSI target IDs will be
>> supported. Think about bigger usage scenarios, such as FCP networks with
>> several hundred HBAs in the net. If you want to have the target ID<->HBA
>> mapping the same as on the guest as on the host, then 255 virtual target
>> IDs could be a limit.
> 
> I think you would hit other scalability limitations well before that.

Performance might be fixed later, but the interface is then settled.
[..]

> But in any case, we could still use the fixed "1" byte to go beyond 255 targets.

Again, why not now? Any extension would require a feature bit, no?
Is there a technical reason why a fixed 1 here is better than just using that space
as scsi id? (e.g. hash table sizes, lookup etc)

Regards

Christian

PS: what puzzles me as well, is the fact that struct virtio_scsi_cmd_req has lun[8]
in the structure. That would sum up as 5 bytes wasted of those 8, no?
