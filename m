From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Re: inquiry in scsi_scan.c
Date: Tue, 7 Jan 2003 10:15:50 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0301071004270.695-100000@ida.rowland.org>
References: <20030107034231.GB9898@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20030107034231.GB9898@redhat.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Doug Ledford <dledford@redhat.com>
Cc: Andries.Brouwer@cwi.nl, luben@splentec.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Mon, 6 Jan 2003, Doug Ledford wrote:

> On Mon, Jan 06, 2003 at 04:46:47PM -0800, Matthew Dharm wrote:
> > On Mon, Jan 06, 2003 at 05:23:22PM -0500, Doug Ledford wrote:
> > > Except that if a device *does* transfer 36 bytes and then lies and says it 
> > > only transferred 5 then we are missing information that might actually be 
> > > usefull, hence the reason to set the transfer length up to the real amount 
> > > transferred (and BTW, I would only do this for INQUIRY responses, for 
> > > anything else the device is simply too buggy to live if it lies about the 
> > > transfer length).
> > 
> > First, I think this is a bogus situation.  If we reqest 36, get X, and
> > indicate a total of 5, then we should look at the X we got.  And that has
> > to be indicated by resid.
> 
> I disagree.  For a compliant SCSI device, it's legal for it to return all
> 36 bytes of data, but only have the first 5 contain anything and the rest
> all be NULL pad bytes and to put 0 into the extra data field.  We are
> *suppossed* to be able to rely upon that extra data field being reliable.  
> Just because sbp2 and usb scsi device manufacturers are such half-wit
> shops that they hire entry level java programmers that couldn't write to a
> standard to save their mother's lives doesn't mean that we should be
> wrecking the scsi standards at the core level to compensate.

Hmm.  Sounds like Doug is trying to have it both ways.  He wants to be
able to handle the case of a device that transfers 36 bytes but only
indicates 5, where the remaining 31 bytes are valid and contain useful
information (a broken device).  He also wants to handle the case of a
device that transfers 36 bytes and only indicates 5, where the remaining
31 bytes only contain padding (legal according to the SCSI spec).  It
seems clear that the driver doesn't have enough information to distinguish
these cases by itself.

How about this as a compromise?  Have the fix_inquiry_data() routine in
storage/protocol.c adjust the additional-length byte if it indicates less
data than actually got transferred (and maybe also < 36 bytes), _unless_
an unusual_devs.h flag bit is set (something like
US_FL_DONT_FIX_INQUIRY_LENGTH).  This flag would only be needed for
devices that transmit useless padding, and presumably these are much rarer
than the brain-dead devices that have an invalid additional-length byte.
In fact, maybe there aren't any examples of any such USB storage devices, 
in which case the flag would be unnecessary.

Alan Stern



-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
