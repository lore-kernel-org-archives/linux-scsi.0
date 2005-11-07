From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 09:24:21 -0800
Message-ID: <20051107172421.GA15710@us.ibm.com>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave> <20051105235522.GA21733@one-eyed-alien.net> <1131238146.9430.7.camel@mulgrave> <20051106215856.GA28452@one-eyed-alien.net> <436E8394.2010600@gmx.de> <20051106235213.GA479@us.ibm.com> <20051107170525.GB26509@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051107170525.GB26509@one-eyed-alien.net>
Sender: linux-ide-owner@vger.kernel.org
To: thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 07, 2005 at 09:05:25AM -0800, Matthew Dharm wrote:

> Okay, what am I missing?
> 
> Looking at that patch, it looks to me like if sg.c set a flag in the SCSI
> command block then scsi_core.c could use that flag in the test to determine
> if the LUN should be masked-in.
> 
> HOWEVER, I keep hearing that the changes will be extensive.  What am I
> missing?

Not extensive AFAICT ... 

The scmd/cdb is not available until we call scsi_get_command() in the
request function. So you would have to add a field into scsi_request, set
it in sg (in both sg.c block/scsi_ioctl.c, test via sd and sg when you are
done), and add the field in scsi_cmnd, and set scmd one in
scsi_init_cmd_from_req().

But as far as black listing, it does seem like a better solution in that
user apps do not need special code.

Do the devices that require it (well so far) have useable vendor + model
strings or usb id's?

-- Patrick Mansfield
