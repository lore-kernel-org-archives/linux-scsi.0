From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Wed, 12 Nov 2003 16:44:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031112164405.A21268@beaverton.ibm.com>
References: <20031112155029.A20986@beaverton.ibm.com> <20031112160921.A10818@one-eyed-alien.net> <20031112161310.A21175@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:34797 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261784AbTKMAo5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2003 19:44:57 -0500
Content-Disposition: inline
In-Reply-To: <20031112161310.A21175@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Nov 12, 2003 at 04:13:10PM -0800
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

On Wed, Nov 12, 2003 at 04:13:10PM -0800, Patrick Mansfield wrote:
> On Wed, Nov 12, 2003 at 04:09:21PM -0800, Matthew Dharm wrote:
> > On Wed, Nov 12, 2003 at 03:50:29PM -0800, Patrick Mansfield wrote:
> > > James - can you please apply? This should not affect other devices since
> > > we are not changing the requested length, just the size of the receive
> > > buffer.
> > 
> > This is a terrible idea.
> > 
> > There is a large number of devices which choke if those two values do not
> > match.
> 
> This is what we do in 2.4 - does USB fix it up for 2.4?
> 
> Oh well.

I think see the 2.4 fixups - it looks like it sets the buffer cmd_len to
12, but is (for usb_stor_ufi_command?) setting MODE SENSE 10 to a 8 byte
length (cmd[8] = 8).

Can we use a minium buffer length of 12 for any requests of less than 13
bytes?

Else, I give up on any other methods, and we should add them to the static
black list as BLIST_MS_SKIP_PAGE_3F (skip_ms_page_3f) and probably
BLIST_MS_SKIP_PAGE_08 just to be safe.

-- Patrick Mansfield
