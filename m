From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: why store the search type in the ieee name field?
Date: 11 Feb 2003 10:43:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044981839.1774.10.camel@mulgrave>
References: <3E482B9E.40803@mvista.com>
	<1044918776.1776.257.camel@mulgrave>
	<20030211082039.A27630@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA26949
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 08:44:03 -0800
In-Reply-To: <20030211082039.A27630@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Steven Dake <sdake@mvista.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-02-11 at 10:20, Patrick Mansfield wrote:
> On Mon, Feb 10, 2003 at 05:12:54PM -0600, James Bottomley wrote:
> > Erm, it's appending the type to the beginning of the name string
> > (although it does seem to be relying on the sysfs name field being zero
> > filled).  I don't see any corruption since the inquiry fields and unique
> > name name follows this byte.
> 
> It should fill in the rest of the 'name' and append a '\0', or return a
> failure.

No, look at the code.  After doing name[0] = hex_str[...
it then does a strcat.  If name is full of junk, strcat will append
after the first \0 it finds (which may be off the end of the name
field).  It only works because name[1] is zero but nothing seems to
clear it.  I'm hoping it's being cleared in a piece of code I haven't
found yet...

James



