From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 07 Feb 2012 13:31:28 +0100
Message-ID: <4F3119A0.7080005@redhat.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F311154.9080407@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christian Hoff <christian.hoff@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/07/2012 12:56 PM, Christian Borntraeger wrote:
>> The 14-bit limitation can be lifted.  SAM defines a 24-bit LUN format too,
>> but I've never seen it used in practice.
>
> Why not lift that limitation before the first version is committed upstream?

Because nobody supports >14-bit LUNs.  The in-kernel LIO target doesn't, 
I don't know anything that does.

> As far as I see we have to allocate multiple target ids if we want
> to provide multipath (e.g. 8 target ids if there are 8 pathes, thus limiting
> ourselves to 64 targets, no?)

Well, 256/8 is actually 32, but yes. :)  But it's more likely that you 
would do multipathing and ALUA on the host, and present a single path to 
the guest using the QEMU SCSI target.  The guest would see a single disk 
that just works.

> As a compromise between space/flexibility, cant we just split the 4 bytes
> in a similar fashion as our major/minor numbers (12/20bit)?

The structure of the LUN is defined by SAM, not by me.  I specified a 
mandatory subset for two reason: 1) simplicity of implementation; 2) 
nobody supports the full hierarchical LUNs spec (SCSI has a lot of 
fringe features), so you need to standardize on something to start with.

Also, you can always have more than one HBA.  You do not even have to 
hotplug the HBAs, you can start a guest with 8 HBAs on a single 
multifunction PCI device, and add disks to them as you see fit.

> Again, why not now? Any extension would require a feature bit, no?

No, because the guest would simply scan a wider LUN space, and it would 
not find anything on older hosts.  It could also look at the 
max_channel/max_target/max_lun fields in the configuration and print a 
warning to the user that some targets may not be accessible.

Paolo
