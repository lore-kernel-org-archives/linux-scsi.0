From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: why store the search type in the ieee name field?
Date: Tue, 11 Feb 2003 08:20:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211082039.A27630@beaverton.ibm.com>
References: <3E482B9E.40803@mvista.com> <1044918776.1776.257.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1044918776.1776.257.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, Feb 10, 2003 at 05:12:54PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Steven Dake <sdake@mvista.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Feb 10, 2003 at 05:12:54PM -0600, James Bottomley wrote:
> On Mon, 2003-02-10 at 16:45, Steven Dake wrote:
> > Folks,
> > 
> > I was wondering the reasoning behind the code
> > 
> > scsi_scan:734
> >         /*
> >          * All OK - store ID
> >          */
> >       name[0] = hex_str[id_search->id_type];
> > 
> > This corrupts a perfectly good IEEE unique identifier (WWN for FC 
> > drives).  Is there some usage for this in user space?
> 
> Erm, it's appending the type to the beginning of the name string
> (although it does seem to be relying on the sysfs name field being zero
> filled).  I don't see any corruption since the inquiry fields and unique
> name name follows this byte.

It should fill in the rest of the 'name' and append a '\0', or return a
failure.

> You get the identifier it found from the sysfs name file for the
> device.  The first byte tells you what type of unique name you're
> dealing with.
> 
> James

And the identifiers are not unique across different identifier types, so
it has to store the id_type in order to have unique identifiers (at least
for scsi) across all types: for example, a vendor specific id could be the
same as a NAA (IEEE) id.

-- Patrick Mansfield
