From: Stelian Pop <stelian@popies.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 11:15:52 +0200
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030424091552.GB1342@deep-space-9.dsnet>
References: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
Reply-To: Stelian Pop <stelian@popies.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, torvalds@transmeta.com
List-Id: linux-scsi@vger.kernel.org

[I'm not subscribed to usb-devel so I may have missed some comments 
on my kernel bugzilla bug report - the one with the 'crusoe'
laptop traces...]

On Thu, Apr 24, 2003 at 12:39:28AM +0200, Andries.Brouwer@cwi.nl wrote:
> Yesterday or so we discussed three people's problems with USB devices.
> Today a fourth very similar complaint was reported.
> 
> I asked
> 
> > Could you try this patch of drivers/scsi/sd.c?
> >
> > --- sd.c~       Sun Apr 20 12:59:32 2003
> > +++ sd.c        Wed Apr 23 21:45:10 2003
> > @@ -1079,6 +1079,9 @@
> >                   int dbd, int modepage, unsigned char *buffer, int len) {
> >         unsigned char cmd[8];
> >
> > +       if (len < 8)
> > +               len = 8;
> > +
> >         memset((void *) &cmd[0], 0, 8);
> >         cmd[0] = MODE_SENSE;
> >         cmd[1] = dbd;
> 
> and got the reply
> 
> #
> # Wohoo! Patch worked like a charm. Thanks Andries!
> #
> 
> So, for the time being I assume we know what is causing
> these problems. It would be nice if the other three
> (afafc@rnl.ist.utl.pt, mike@hingston.demon.co.uk, stelian@popies.net)
> could report on their experiences with the above patch.

I confirm that this patch makes both my memory stick reader
*and* my USB floppy drive work perfectly again.
> 
> The next question is whether this is a bug in these devices
> or a bug in the usb-storage code.

In both devices ? Hard to believe...

> As Alan remarked, drivers/usb/storage/protocol.c contains
> the fragment
> 
>         case MODE_SENSE:
>                 srb->cmnd[8] = 8;
> 
> But that is in usb_stor_ufi_command(), and
> usb_stor_transparent_scsi_command() doesn't do this.
> Nevertheless, MODE_SENSE has minimum length 4, and
> MODE_SENSE_10 has minum length 8 for its reply.
> So, possibly the latter routine should do something
> similar. For example
> 
> --- protocol.c~ Fri Nov 22 22:40:13 2002
> +++ protocol.c  Thu Apr 24 00:38:31 2003
> @@ -366,6 +366,8 @@
>                         srb->cmnd[2] = srb->cmnd[2];
>                         srb->cmnd[1] = srb->cmnd[1];
>                         srb->cmnd[0] = srb->cmnd[0] | 0x40;
> +                       if (srb->cmnd[8] < 8)
> +                               srb->cmnd[8] = 8;
>                         break;
>                 } /* switch (srb->cmnd[0]) */
>         } /* if (us->flags & US_FL_MODE_XLATE) */
> 
> (yes, ugly, no guarantee that the buffer is large enough).
> 
> Comments?

This patch (applied without the first one) does not make any
difference: memory stick initialisation still takes several
minutes to complete, floppy drive initialisation takes about
10 minutes before the block layer aborts the requests with
a read error.

Stelian.
-- 
Stelian Pop <stelian@popies.net>


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
