From: Brian King <brking@us.ibm.com>
Subject: Re: [patch 03/15] libata: Remove dependence on host_set->dev for
 SAS
Date: Thu, 09 Feb 2006 16:21:22 -0600
Message-ID: <43EBC062.3040304@us.ibm.com>
References: <200602061542.k16FgSYn009049@d01av02.pok.ibm.com> <43EAECD3.30505@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43EAECD3.30505@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> brking@us.ibm.com wrote:
>> Remove some of the dependence on the host_set struct
>> in preparation for supporting SAS HBAs. Adds a struct device
>> pointer to the ata_port struct.
>>
>> Signed-off-by: Brian King <brking@us.ibm.com>
> 
> Seems like a good idea independent of SAS.  My only "objection" is 
> wondering about struct device reference counts, and wondering if we need 
> to worry about that.  Did you look over the object lifetimes, to make 
> sure nothing overlaps?

I don't see any object lifetime problems being introduced as a result of
this patchset. I did spend some time looking through object lifetimes for
SAS users (existing users should be unaffected by these changes)
and I did have some problems in this regard in previous iterations
of this patchset. (I did some SATA device hotplug testing with this
patchset)

The two rules that need to be followed by any new users of this patchset
in order to not run into object lifetime problems are:

1. Prior to calling ata_sas_port_destroy, caller must guarantee that
   there are no outstanding references to the scsi_device. I accomplished
   this by calling ata_sas_port_destroy in target_destroy.
2. Before the pci_dev struct goes away (e.g. pci hotplug remove), all
   oustanding commands must be returned to libata and any new requests
   that come in through qc_issue should fail. This solves any lifetime
   issues that could have resulted from having the dev pointer for the
   PCI device in ata_port.

I was thinking at one point that I would need to add reference counting
to the ata_port, but was able to avoid that complexity with the solution
above.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

