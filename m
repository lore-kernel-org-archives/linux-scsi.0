From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating
	SMART/ATA-Security in usb-storage driver
Date: Fri, 04 Nov 2005 14:49:55 -0600
Message-ID: <1131137395.3532.57.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com>
	 <1131130707.3532.45.camel@mulgrave>
	 <20051104203004.GF12384@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051104203004.GF12384@one-eyed-alien.net>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-11-04 at 12:30 -0800, Matthew Dharm wrote:
> > What happens if you prevent USB mangling the scsi_level?  I think, for
> > the most part, we would handle 0 in about the same way as we handle 2.
> > However, we could gate the if around the CDB[1] mangling as
> > 
> > if (scsi_level != SCSI_UNKNOWN && scsi_level <= SCSI_2)
> > 
> > which should fix your problem, I think.
> 
> A long time ago, usb-storage didn't mangle the scsi_level.  And almost
> nothing worked.  Without a SCSI level, 6-byte commands get sent; only
> 10-byte commands will do.

That area of the scsi subsystem has been changed significantly ...
mainly for usb storage.  I don't believe your assertion about
SCSI_UNKOWN only producing 6 byte CDBs to be correct, the behaviour is
now governed by two scsi_device flags: use_10_for_rw and use_10_for_ms
which you can control in slave configure.

Can you just try it with a modern kernel and see if anything still
breaks?

Thanks,

James


