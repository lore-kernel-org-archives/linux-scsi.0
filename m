From: Luben Tuikov <luben@splentec.com>
Subject: Re: Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 14:10:31 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3E318FA7.9050701@splentec.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Oliver Neukum <oliver@neukum.name>, Doug Ledford <dledford@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Dharm wrote:
> 
> It would be nice if the SCSI mid-layer kept track of what commands were in
> what stages in who's queues.

My mini-scsi-core does exactly that.  Moving commands between queues is atomic.
The whole thing is completely reentrant and multithreaded capable, etc, etc.
It has a simple interface of send_command() and cancel_command(); doesn't have
device discovery though.

I tried to sell those features/ideas to SCSI Core, but we're not there yet.

Oh, I forgot to mention in my previous by date letter:
The entity which calls scsi_register_host() should by good design call
scsi_unregister_host().  It may be the case that when there are no
more devices associated with a particular host, then SCSI Core can
call scsi_unregister_host(), reminicent of SCSI Core early initialization.

-- 
Luben





-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
