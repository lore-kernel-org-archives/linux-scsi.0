From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-storage and Sony Handycam
Date: Mon, 10 Nov 2003 13:46:44 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0311101335310.6288-100000@ida.rowland.org>
References: <20031110095914.B22518@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20031110095914.B22518@beaverton.ibm.com>
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

> On Sat, Nov 08, 2003 at 10:47:26PM -0500, Alan Stern wrote:
> > 
> > For CB and CBI devices, babble causes a DID_ERROR return.  For Bulk-only 
> > it causes a Check-Condition status to be returned along with Invalid 
> > Command sense data.  Like I said earlier, we haven't yet figured out the 
> > best way to handle these errors.
> 
> The DID_ERROR should be changed to DID_ABORT for the babble case so scsi
> core won't retry the command generating the babble.  
> 
> I don't know why scsi core retries on DID_ERROR, as code comments say
> DID_ERROR is an internal error. DID_SOFT_ERROR is the same as DID_ERROR
> (as far as scsi core cares), execept for a check for reservation conflict.

I'll pass that on to Matt Dharm.  It's not always clear to me which
DID_XXX code is best to use in a given situation for an emulated SCSI bus
like USB.

> Has anyone looked at why the reset failed? I assume that would clear the
> sense.

How could anyone attempt to find out why the reset failed?  The only 
externally visible state is the device's response to incoming USB 
requests.  IIRC, it simply didn't respond to the reset request.  (I'm not 
sure about that; I may be confusing this with other devices that failed in 
similar ways.)

> We still have the missed check in scsi_status_is_good.
> 
> And, the sense coming back for a previous command returning babble is still
> an issue.

Agreed.  I tend to ascribe things like that to buggy SCSI implementations 
in the device firmware.  These things are produced quickly and often 
without thorough testing.  On the other hand, even if it's true it doesn't 
suggest any good avenues of approach.

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
