From: Andries.Brouwer@cwi.nl
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Fri, 25 Apr 2003 02:43:25 +0200 (MEST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <UTC200304250043.h3P0hPH01942.aeb@smtp.cwi.nl>
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Andries.Brouwer@cwi.nl, stelian@popies.net
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, pwkpete@yahoo.com, stern@rowland.harvard.edu
List-Id: linux-scsi@vger.kernel.org

> The sd.c patch *is* needed to make it work.

Thanks for confirming.

Now that we know the facts, it is easy to answer my question

: But usb_stor_ufi_command() already contained code to
: make the length 8. How can it be that my sd.c change
: improved things?

The answer is that the length occurs twice - as part of
the SCSI command, and as bufflen. The usb-storage code
that fudges the command in the hope of producing something
more agreeable to the device forgets to adapt the bufflen.

This ends, I think, the discussion of what went wrong.
We understand perfectly - I hope.

Now about fixing the code. We must do something in usb-storage
or sd.c or both. I would prefer if sr_bufflen denotes the
actually available length, instead of the length that
will be transferred. If it has that meaning, then the
fudger in usb-storage knows for sure that there is space.
And sd_do_mode_sense6 and family can store the right number.

Are there any objections against viewing sr_bufflen
as the amount of actually available buffer space
(and thus potentially different from the transferred amount)?

Andries


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
