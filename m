From: Andries.Brouwer@cwi.nl
Subject: Re: Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 20:55:22 +0200 (MEST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <UTC200309221855.h8MItM216884.aeb@smtp.cwi.nl>
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: patmans@us.ibm.com, torvalds@osdl.org
Cc: Andries.Brouwer@cwi.nl, david-b@pacbell.net, greg@kroah.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu
List-Id: linux-scsi@vger.kernel.org

> Basically, Andries Brouwer's strategy of making sd.c more conservative has
> been a very successful one in the past. Why not continue on that?

% I would be interested in hearing what Andries has to say. ...
% The variety of ways in which these things fail is truly amazing.

Yes.

We have just seen this for keyboards: keypresses work, modifier key
releases work, and as soon as one assumes anything more there turn
out to be keyboards that fail.

Similarly, USB storage devices tend to fail whatever one tries,
and only systematically work if one does precisely what Windows
does. For SCSI disks things are not nearly as bad - there are
only a few manufacturers and they mostly produce quality stuff.

This means that carefully reading the SCSI standard is a useful
activity if one writes for SCSI disks. But for USB storage it
is more productive to trace the commands the various flavours
of Windows send.

(Yes, I am willing to collect whatever people send me, and put up
a web page describing the Windows way of addressing USB storage.)

So, I agree with Linus (and with myself :-)) - in the absence of
precise knowledge about the device and about its Windows drivers
all that is left is being as conservative as possible.
And I agree with Alan - even though being careful is a very good idea,
it does not help in all cases.

There are some general things we can do - for CF cards and the like
we probably do not want to read the cache type - USB is hot pluggable,
so it should not be necessary to send a flush cache command at shutdown.
Today I see

        if (sdkp->media_present) {
                sd_read_capacity(sdkp, disk->disk_name, sreq, buffer);
                if (sdp->removable)
                        sd_read_write_protect_flag(sdkp, disk->disk_name,
                                        sreq, buffer);
                sd_read_cache_type(sdkp, disk->disk_name, sreq, buffer);
        }

and I suppose we could skip sd_read_cache_type() in the
hot-pluggable case - a flag that USB storage could set.

Andries


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
