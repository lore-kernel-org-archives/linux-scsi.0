From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD reentrancy
Date: Mon, 26 Aug 2002 14:15:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020826211553.GA9917@beaverton.ibm.com>
References: <20020826172746.GA1301@beaverton.ibm.com> <200208261900.g7QJ0r501788@localhost.localdomain> <20020826205720.GE1301@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020826205720.GE1301@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Sorry for replying to myself, but a mistake on the previous mail in that
I meant to reference the scsi_device sdev_driverfs_dev member and
associated sdev_driverfs_dev.parent pointer.

-Mike
Mike Anderson [andmike@us.ibm.com] wrote:
> James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > andmike@us.ibm.com said:
> > > James I do not follow the usage of LUNs linked by pointers, can you
> > > explain further? 
> > 
> > Yes:  the mid-layer could function only with Scsi_Devices and Scsi_Hosts.  
> > LUNs are currently only used explicitly for scanning.  However, I'd like to 
> > make the error handler handle the consequences of its action, thus it will 
> > need to know LUN relationships to handle a BDR correctly.  However, the mid 
> > layer doesn't need an arbitrary number associated with LUN or PUN.  Since the 
> > number, string or whatever is only really useful to the lld.  So, simply put, 
> > we'd probably have an entry in the Scsi_Device for lun_list.  This would be 
> > the usual doubly linked list so starting with any Scsi_Device we could always 
> > find the associated LUNs.
> > 
> 
> Ok, so we are looking for a sibling check. We should alter our driverfs
> registration so that we pick this up for free by comparing the
> de->parent of our scsi_device. Example tree shown below. Our scsi_device
> devfs_entry would be pointing the lun leaf node. TBD on where all the
> devfs_entrys get stored an who creates / destroys them.
> 
> Example tree
> devices/root/pci0/00:09.0/name "PCI device 1014:002e"
> devices/root/pci0/00:09.0/0/name "scsi0"
> devices/root/pci0/00:09.0/0/0/name "chan0"
> devices/root/pci0/00:09.0/0/0/1/name "tgt1"
> devices/root/pci0/00:09.0/0/0/1/1/name "lun1"
> devices/root/pci0/00:09.0/0/0/1/0/name "lun0"
> devices/root/pci0/00:09.0/0/0/0/name "tgt0"
> devices/root/pci0/00:09.0/0/0/0/1/name "lun1"
> devices/root/pci0/00:09.0/0/0/0/0/name "lun0"
> 
> 
> -Mike
> -- 
> Michael Anderson
> andmike@us.ibm.com
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michael Anderson
andmike@us.ibm.com

