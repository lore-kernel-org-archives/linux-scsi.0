From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-storage and Sony Handycam
Date: Mon, 10 Nov 2003 14:57:53 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0311101453390.709-100000@ida.rowland.org>
References: <20031110110455.A23256@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20031110110455.A23256@beaverton.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Dmitri Katchalov <dmitrik@users.sourceforge.net>, Idan Sofer <idan@idanso.dyndns.org>, ronald@kuetemeier.com, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 10 Nov 2003, Patrick Mansfield wrote:

> On Mon, Nov 10, 2003 at 01:46:44PM -0500, Alan Stern wrote:
> > On Mon, 10 Nov 2003, Patrick Mansfield wrote:
> 
> > How could anyone attempt to find out why the reset failed?  The only 
> > externally visible state is the device's response to incoming USB 
> > requests.  IIRC, it simply didn't respond to the reset request.  (I'm not 
> > sure about that; I may be confusing this with other devices that failed in 
> > similar ways.)
> 
> I don't know, the bug report (and other logs) show:
> 
> Nov  7 00:12:19 [kernel] usb-storage: Command MODE_SENSE_10 (10 bytes)
> Nov  7 00:12:19 [kernel] usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
> Nov  7 00:12:19 [kernel] usb-storage: Status code 0; transferred 10/10
> Nov  7 00:12:19 [kernel] usb-storage: -- transfer complete
> Nov  7 00:12:19 [kernel] usb-storage: Call to usb_stor_ctrl_transfer() returned 0
> Nov  7 00:12:19 [kernel] usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
> Nov  7 00:12:19 [kernel] usb-storage: Status code -75; transferred 8/8
> Nov  7 00:12:19 [kernel] usb-storage: -- babble
> Nov  7 00:12:19 [kernel] usb-storage: CB data stage result is 0x3
> Nov  7 00:12:19 [kernel] usb-storage: -- transport indicates error, resetting
> Nov  7 00:12:19 [kernel] usb-storage: usb_stor_CB_reset called
> Nov  7 00:12:19 [kernel] usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
> Nov  7 00:12:19 [kernel] usb-storage: Soft reset failed: -32
> Nov  7 00:12:19 [kernel] usb-storage: scsi cmd done, result=0x70000

The -32 (-EPIPE) error code indicates a "protocol stall" -- the device is
saying that for some reason it can't accept or can't carry out the reset
command.  Maybe because it's busy still trying to finish up its broken
response to the MODE-SENSE command.

You would think that a reset would take precedence over a regular 
command-in-progress, but apparently not here.

Alan Stern




-------------------------------------------------------
This SF.Net email sponsored by: ApacheCon 2003,
16-19 November in Las Vegas. Learn firsthand the latest
developments in Apache, PHP, Perl, XML, Java, MySQL,
WebDAV, and more! http://www.apachecon.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
