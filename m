From: Alfredo Dal Ava Junior <alfredo.junior-peCLlicIkyA3OWu3QmcX+g@public.gmane.org>
Subject: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 20:14:20 +0000
Message-ID: <5afd9bda607a48d3b0a1f7b362c666c5@serv030.corp.eldorado.org.br>
References: <40601ab081d3451baf6267807659c80e@serv030.corp.eldorado.org.br>
 <Pine.LNX.4.44L0.1408251526390.1385-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1408251526390.1385-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Content-Language: pt-BR
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


On Mon, 25 Aug 2014 Alan Stern wrote:
> 
> On Mon, 25 Aug 2014, Alfredo Dal Ava Junior wrote:
> 
> That's right.  I don't know why Windows behaves that way.

Please look this output from diskpart (Windows):

DISKPART> list partition

  Partition ###  Type              Size     Offset
  -------------  ----------------  -------  -------
  Partition 1    Primary           3726 GB    17 KB

DISKPART> list disk

  Disk ###  Status         Size     Free     Dyn  Gpt
  --------  -------------  -------  -------  ---  ---
  Disk 0    Online          298 GB      0 B
* Disk 1    Online         1678 GB      0 B        *

DISKPART> select disk 1

Disk 1 is now the selected disk.

DISKPART> list partition

  Partition ###  Type              Size     Offset
  -------------  ----------------  -------  -------
  Partition 1    Primary           3726 GB    17 KB

> > Could we do the same? Would be possible to signalize to upper layers
> > that capacity is not accurate (or return zero) on this device, and
> > tell GPT handlers to bypass it's partition_size vs disk size
> > consistency check?
> 
> There is no way to do this, as far as I know.  But I'm not an expert in this area.
> Maybe you can figure out a way to add this capability.
> 
> (But then what happens if the size stored in the partition table really is larger
> than the disk's capacity?)

It's the first time I touch this code, but I will learn from the code and try to find it out... but still in hope to find a clean solution...
If size stored on partition table is really larger than disk, my guess it will cause I/O errors, and that some disks may get crazy like you pointed. 
Do you think disk could cause kernel instability? I think it is acceptable if no consequences to kernel stability, since it is a "specific-device" workaround. 

[]'s
Alfredo
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
