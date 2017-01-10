From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Tue, 10 Jan 2017 15:02:09 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1701101457390.2462-100000@iolanthe.rowland.org>
References: <201701102031.42361@pali>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201701102031.42361@pali>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dainius =?utf-8?q?Masili=C5=ABnas?= <pastas4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 10 Jan 2017, Pali Rohár wrote:

> Per Tom Yan suggestion I'm forwarding bug from bugzilla to this ML: 
> https://bugzilla.kernel.org/show_bug.cgi?id=102271

This really should be sent to the linux-scsi mailing list (CC'ed) as 
well as to linux-usb.

> === Dainius Masiliūnas wrote: ===
> 
> When using an Advanced Format drive connected through a SCSI-to-ATA Translation device, the physical 
> block size reported by the kernel (in /sys/class/block/sdc/queue/physical_block_size) is 512 bytes. 
> Whereas hdparm -I and smartctl -a do correctly show the physical block size as 4096 bytes.
> 
> In my case, the drive in question is a HGST HTS541075A9E680 hard drive, connected to my PC through a 
> USB3 HDD enclosure (USB ID 05e3:0731).
> 
> While trying to find more information about this issue, I came across someone else's blog post about 
> the same issue I'm having, which includes some in-depth analysis:
> http://nunix.fr/index.php/linux/7-astuces/65-too-hard-to-be-above-2tb
> 
> It seems that the kernel uses less reliable means to get details about such devices than hdparm 
> does.

Quick summary: READ CAPACITY(10) does not include physical sector size 
information whereas READ CAPACITY(16) does.  But the kernel uses READ 
CAPACITY(10) by default for USB drives, because quite a few of them die 
when given a READ CAPACITY(16) command.

If you can suggest a way to fix this, we'll be glad to hear it.

Alan Stern

> I'm using the kernel that's shipped in openSUSE 13.2.
> 
> === Tom Yan replied: ===
> 
> It is probably because of this:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/usb/storage/scsiglue.c?h=v4.4#n217
> 
> SCSI READ CAPACITY (10) will not return "Logical blocks per physical block exponent" like READ 
> CAPACITY (16) does:
> 
> [tom@localhost ~]$ sudo sg_readcap /dev/sdc
> Read Capacity results:
>    Last logical block address=468862127 (0x1bf244af), Number of blocks=468862128
>    Logical block length=512 bytes
> Hence:
>    Device size: 240057409536 bytes, 228936.6 MiB, 240.06 GB
> 
> [tom@localhost ~]$ sudo sg_readcap -16 /dev/sdc
> Read Capacity results:
>    Protection: prot_en=0, p_type=0, p_i_exponent=0
>    Logical block provisioning: lbpme=0, lbprz=0
>    Last logical block address=468862127 (0x1bf244af), Number of logical blocks=468862128
>    Logical block length=512 bytes
>    Logical blocks per physical block exponent=3 [so physical block length=4096 bytes]
>    Lowest aligned logical block address=0
> Hence:
>    Device size: 240057409536 bytes, 228936.6 MiB, 240.06 GB

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
