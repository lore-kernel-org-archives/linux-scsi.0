From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [usb-storage] [Merging ATA passthru] on
	integratingSMART/ATA-Security in usb-storage driver
Date: Fri, 04 Nov 2005 14:40:09 -0600
Message-ID: <1131136809.3532.51.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF40@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CA45571DE57E1C45BF3552118BA92C9D69BF40@WDSCEXBECL03.sc.wdc.com>
Sender: linux-ide-owner@vger.kernel.org
To: Timothy Thelin <Timothy.Thelin@wdc.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-11-04 at 11:59 -0800, Timothy Thelin wrote:
> Irconically that was one of the solutions I was investigating
> first.  Here is the usb mailing list discussion on it:
> http://marc.theaimsgroup.com/?t=112672009700004&r=1&w=2

OK, I think the assertion that just passing through the level as scsi0
"won't work" is wrong.  Most of our checks for SCSI-2 are 

if (xxx->scsi_level <= SCSI_2)

which catches scsi0 as well as scsi2.  The length of commands is
actually separately settable in slave_configure, but by default we use
10 byte commands even for scsi2.

> In summary, the idea of making the scsi stack "level 0 aware" was
> suggested and rejected because usb devs want to keep promoting
> the devices to level 2 for various reaons.  At the end of it
> they suggested using SG_FLAG_LUN_INHIBIT so that the usb device
> could stay level 2 yet vendor specific commands could get passed
> through un-touched. Neither of us knew that flag didn't work
> anymore, and after I wasn't able to get it to work, that
> other conversation I posted previously occured to figure out
> what was going on with SG_FLAG_LUN_INHIBIT.

Well ... before embarking on a massive programme to put this flag back
(or implement a "I say SCSI2 but I'm really not" blacklist flag), I'd
like proof that just passing SCSI_UNKNOWN as the level really won't work
(and is unfixable).  I think it will turn out to be the simplest course
of action.

James


