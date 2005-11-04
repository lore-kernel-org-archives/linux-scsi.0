From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating
	SMART/ATA-Security in usb-storage driver
Date: Thu, 03 Nov 2005 23:08:07 -0500
Message-ID: <1131077287.3117.22.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3A@WDSCEXBECL03.sc.wdc.com>
	 <20051102234532.GC26148@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051102234532.GC26148@one-eyed-alien.net>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2005-11-02 at 15:45 -0800, Matthew Dharm wrote:
> On Wed, Nov 02, 2005 at 02:18:52PM -0800, Timothy Thelin wrote:
> > 
> > If you had time to spare, instead of touching usb-storage,
> > it might be better spent resurecting SG_FLAG_LUN_INHIBIT to
> > stop the above behavior so that SG_IO cdbs can be passed
> > through untouched.
> > (SG_FLAG_FUN_INHIBIT was a flag SG_IO used to support a long
> > time ago, and I have no idea why it was dropped, but it was)
> 
> I didn't realize that had been removed.  Anyone that sends a
> vendor-specific command to a device needs this flag to make sure it goes
> through unmangled.
> 
> Perhaps someone on linux-scsi can comment on why this was removed and how
> we might get it back?

I've no distinct recollection of someone removing this, but if I
remember correctly what it used to do, it was a hack to stop us from
mangling SCSI-3 CDB's.  We fixed the mid-layer not to require the hack
by only setting the CDB[1] lun field for SCSI-1 and SCSI-2 devices (as
the standards mandate).  What's the actual problem?  No SCSI-1 or SCSI-2
device should have any vendor specific CDBs that uses these bits in
CDB[1].

James


