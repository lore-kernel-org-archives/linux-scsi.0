From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 05 Apr 2003 13:45:43 -0600
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1049571946.2538.94.camel@mulgrave>
References: <20030322193705.C17056@one-eyed-alien.net>
	<Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
	<20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
	<1048519237.1982.16.camel@mulgrave>
	<20030324093028.A1066@one-eyed-alien.net>
	<1049556643.1762.16.camel@mulgrave>
	<20030405112759.B4320@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20030405112759.B4320@one-eyed-alien.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2003-04-05 at 13:27, Matthew Dharm wrote:
> I don't think this will work.  I see two problems:
> 
> (1) You can't filter TEST_UNIT_READY (opcode 0).  Not a big deal, but a
> theoretical problem.

Yes, TUR has been mandatory since SCSI-1, so I didn't think this would
be a problem.  Any end signal can be used, zero was the least line of
resistance.

> (2) We need to be able to filter at the originator.  For example,
> MODE_SENSE is perfectly fine to send to a CD-ROM, but not to a hard-disk.
> We can't make that distinction with your code, unless we put the filtering
> code not in queuecommand but in places like sd.c.... or we need to change
> the filter to also take a device type.

What's wrong with

-		if(scsi_filter_cmd(SCp, &filter)) {
+		if(SCp->device->type == TYPE_DISK && scsi_filter_cmd(SCp, &filter)) {

?

The whole idea is to provide a filter library that the emulated HBA
drivers can use to cope with standard commands they don't like rather
than add extra code to the mid-layer main code paths.

James




-------------------------------------------------------
This SF.net email is sponsored by: ValueWeb: 
Dedicated Hosting for just $79/mo with 500 GB of bandwidth! 
No other company gives more support or power for your dedicated server
http://click.atdmt.com/AFF/go/sdnxxaff00300020aff/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
