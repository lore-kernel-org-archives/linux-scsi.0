From: Andries.Brouwer@cwi.nl
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 19:22:11 +0200 (MEST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <UTC200304221722.h3MHMBL16595.aeb@smtp.cwi.nl>
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, mike@hingston.demon.co.uk, torvalds@transmeta.com, usb-storage@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

Then we get the second bugzilla report. Interesting.
It fails in precisely the same way as the first one:


Apr  9 17:34:55 lemon: SCSI device sda: 126848 512-byte hdwr sectors (65 MB)
Apr  9 17:34:55 lemon: usb-storage: queuecommand() called
Apr  9 17:34:55 lemon: usb-storage: *** thread awakened.
Apr  9 17:34:55 lemon: usb-storage: Command MODE_SENSE (6 bytes)
Apr  9 17:34:55 lemon: usb-storage:  1a 00 3f 00 04 00
Apr  9 17:34:55 lemon: usb-storage: Invoking Mode Translation
Apr  9 17:34:55 lemon: usb-storage: usb_stor_ctrl_transfer(): rq=00 rqtype=21 value=0000 index=00 len=12
Apr  9 17:34:55 lemon: usb-storage: Status code 0; transferred 12/12
Apr  9 17:34:55 lemon: usb-storage: -- transfer complete
Apr  9 17:34:55 lemon: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Apr  9 17:34:55 lemon: usb-storage: usb_stor_bulk_transfer_buf(): xfer 4 bytes
Apr  9 17:34:55 lemon: usb-storage: Status code -75; transferred 4/4
Apr  9 17:34:55 lemon: usb-storage: -- unknown error
Apr  9 17:34:55 lemon: usb-storage: CB data stage result is 0x3
Apr  9 17:34:55 lemon: usb-storage: -- transport indicates error, resetting
Apr  9 17:34:55 lemon: usb-storage: CB_reset() called
Apr  9 17:35:11 lemon modprobe: FATAL: Module /dev/tts/64 not found. 
Apr  9 17:35:15 lemon: drivers/usb/core/message.c: usb_control/bulk_msg: timeout
Apr  9 17:35:25 lemon: usb-storage: command_abort() called
Apr  9 17:35:25 lemon: usb-storage: usb_stor_abort_transport called


But here the additional information is:
It was working fine under 2.4.* but under 2.5.66/67 it hangs.

Is there a problem with MODE_SENSE? But 2.4 also does this MODE_SENSE.
A first step is perhaps finding out what the * is for.

Which 2.4 versions are known to work correctly?

Andries

[And is there a verbose usb-storage log on a successful 2.4?]


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
