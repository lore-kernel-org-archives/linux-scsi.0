From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 22:42:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030107034231.GB9898@redhat.com>
References: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl> <20030106112259.B13916@one-eyed-alien.net> <20030106222322.GC29126@redhat.com> <20030106164647.F13916@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030106164647.F13916@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, luben@splentec.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Mon, Jan 06, 2003 at 04:46:47PM -0800, Matthew Dharm wrote:
> On Mon, Jan 06, 2003 at 05:23:22PM -0500, Doug Ledford wrote:
> [ snipped my comments ]
>
> Okay, so what about sbp2, where this sort of thing is also common?  Why not
> just fix it at the SCSI layer?

How are you wanting to fix it?  The infrastructure for doing this does not
currently exist in the mid layer code.  It would have to be added.  And it
would have to be added in a way that was reliable.  Ideas?
 
> > Except that if a device *does* transfer 36 bytes and then lies and says it 
> > only transferred 5 then we are missing information that might actually be 
> > usefull, hence the reason to set the transfer length up to the real amount 
> > transferred (and BTW, I would only do this for INQUIRY responses, for 
> > anything else the device is simply too buggy to live if it lies about the 
> > transfer length).
> 
> First, I think this is a bogus situation.  If we reqest 36, get X, and
> indicate a total of 5, then we should look at the X we got.  And that has
> to be indicated by resid.

I disagree.  For a compliant SCSI device, it's legal for it to return all
36 bytes of data, but only have the first 5 contain anything and the rest
all be NULL pad bytes and to put 0 into the extra data field.  We are
*suppossed* to be able to rely upon that extra data field being reliable.  
Just because sbp2 and usb scsi device manufacturers are such half-wit
shops that they hire entry level java programmers that couldn't write to a
standard to save their mother's lives doesn't mean that we should be
wrecking the scsi standards at the core level to compensate.

The only way to fix this up (somewhat) reliably as far as I can tell, at
the mid layer, would involve pre-clearing the INQUIRY return area then
issuing the command.  Upon command completion, check to see if extra data
length byte + 5 == cmd->length - cmd->residual.  If not, then check if
there are non-0 bytes beyond the end of the indicated extra data area.  
If so, assume real data length is cmd->length - cmd->residual and if not
then assume extra data length was correct.  

HOWEVER!  This does require changing all the lldd to set cmd->residual.  
This is currently not done, as cmd->residual is optional.  Low level
device drivers are only required to return an error condition when the
actual transfer is < cmd->underflow, they aren't required to set
cmd->residual ever.

HOWEVER2!  This is also just a heuristic and it could be fooled.

> The argument that many HBAs don't set resid just doesn't hold water with
> me.  Just because other drivers are broken, we should break more things
> instead of fixing the problem?

First off, the other drivers aren't broken.  Cmd->residual was added 
about a year or two ago as an ad hoc change to improve CD burning.  It was 
never officially added to the SCSI core API as a requirement in any 
driver.

Besides, we *aren't* talking about fixing a problem.  We are talking about
ignoring data we are suppossed to be able to rely upon to be accurate.  
Ignoring return data should only be done if you have a reasonable
suspicion that the data is wrong.  In usb, that appears to be the case.  
In real scsi devices, that is not the case.  Hence, the location of the
proper fix is, IMHO, in the usb stack (share it with spb2 via a library
call if you wish, but I don't think the scsi core should be doing it).


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
