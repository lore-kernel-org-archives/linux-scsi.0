From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Sun, 6 Nov 2005 15:52:13 -0800
Message-ID: <20051106235213.GA479@us.ibm.com>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave> <20051105235522.GA21733@one-eyed-alien.net> <1131238146.9430.7.camel@mulgrave> <20051106215856.GA28452@one-eyed-alien.net> <436E8394.2010600@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <436E8394.2010600@gmx.de>
Sender: linux-ide-owner@vger.kernel.org
To: thomas schorpp <t.schorpp@gmx.de>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 06, 2005 at 11:28:36PM +0100, thomas schorpp wrote:
> > 
> > 
> > Was it really removed that long ago?  
> 
> yes

Hmmm yeh, here is the original email with patch:

http://marc.theaimsgroup.com/?l=linux-scsi&m=103470224812028&w=2

Black listing would cover more cases than adding back the SG_IO flag.

Black listing USB devices is somewhat bad/tricky, since they often don't
show up with registered vendor + model names, and use somewhat generic
names, for example I have an xd reader that has vendor "Generic", model
"STORAGE DEVICE". 

So either the hardware is stupid, or usb-storage generates those names and
maybe everything is OK (simple search finds nothing in usb storage code).
We do have some of those name in the current scsi devinfo table ... I haven't
looked for details on them or tried to figure out if they hurt any
devices.

Other potential methods besides black list based on vendor + model:

1) If (big if, i.e. unlikely) USB devices in general don't need
the LUN in the cdb, we could black list all USB to skip the storing of it. 

The majority of the (single LUN) USB devices probably never look
at the field, so perhaps we could refine the above to: 

2) Black list all usb devices that don't have multiple LUNs, assuming the
never check the cdb for a LUN value.

I don't know if you can tell (in usb code) if usb mass storage is
multi-lun or not without scanning for the other LUNs (normal SCSI devices
would have to be scanned or sent a REPORT LUNS, and even then, they could
show up with more LUNs in the future).

3) black list via usb storage based on usb id's, kind of like the handling
in usb slave_configure for USB_VENDOR_ID_GENESYS, though a more general
method would be better.

All of the above methods still should have defines in linux scsi devinfo
table and a corresponding new scsi_device->no_cdb_lun_setting field, and
setting of it in scsi_scan.c:scsi_add_lun (calls slave_configure near
the end, so then slave_configure can set no_cdb_lun_setting as required).

The slave_configure can then set sdev specific values, such as those that
might be set in linux scsi core black list, see current driver/usb/storage
scsiglue.c:slave_configure().

-- Patrick Mansfield
