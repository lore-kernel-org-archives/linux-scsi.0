From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 14:30:56 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D4F6@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: 'Matthew Dharm' <mdharm-scsi@one-eyed-alien.net>, Luben Tuikov <luben@splentec.com>
Cc: Andries.Brouwer@cwi.nl, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org


I think SCSI-Core should care about offsets 36-48, since that is where the
serial number usually is returned.  Special error handling for emulated
devices would be better than limiting the inquiry up front I think.

Andy

-----Original Message-----
From: Matthew Dharm [mailto:mdharm-scsi@one-eyed-alien.net] 
Sent: Monday, January 06, 2003 4:06 PM
To: Luben Tuikov
Cc: Andries.Brouwer@cwi.nl; stern@rowland.harvard.edu;
linux-scsi@vger.kernel.org; linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c


I'm told this is a bad idea because there are some HBA which snoop the
INQUIRY data.  Since I don't know how that snooping works, I can't comment
further.

Matt

On Mon, Jan 06, 2003 at 03:49:08PM -0500, Luben Tuikov wrote:
> Matthew Dharm wrote:
> > 
> > Perhaps the "best" fix here is to simply make scsi_scan.c only send 36
byte
> > inquiry requests if the bus is 'emulated'.  That would solve a world of
> > problems....
> 
> When scsi_scan.c does it's own scanning for SCSI Core, maybe it's best to
> ignore 36 < INQUIRY_DATA_LEN < 57, since this is just vendor specific
> data and SCSI Core is not interested in it.
> 
> In descriptive-C this looks like this:
> 
> </issue a 36 byte buffer INQUIRY/>
> </now dissect:/>
> 
> int bytes_got = max(bytes_requested - cmd->resid, 0);
> 
> if (31 < buffer[4] && buffer[4] < 52) {
> 	/* we don't care, do not issue another INQUIRY */	
> else if (buffer[4] >= 52) {
> 	bytes_requested = 5+buffer[4];
> 	/* issue another INQUIRY to get the additional flags, */
> 	/* plus any version descriptors if available */
> 	</insert code here/>
> 	bytes_got = max(bytes_requested - cmd->resid, 0);
> }
> 
> if (bytes_got != buffer[4]+5) {
> 	/* let's rely on the transport to have correctly set */
> 	/* cmd->resid and report a broken device server */
> 	</insert code here/>
> }
> 
> /* Now we rely on bytes_got */
> 
> </rest of scanning code/>
> 
> -- 
> Luben
> 

-- 
Matthew Dharm                              Home:
mdharm-usb@one-eyed-alien.net 
Maintainer, Linux USB Mass Storage Driver

Would you mind not using our Web server? We're trying to have a game of 
Quake here.
					-- Greg
User Friendly, 5/11/1998


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
