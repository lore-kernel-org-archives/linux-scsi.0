From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: another SCSI sync
Date: Sat, 22 Feb 2003 12:34:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302221225500.7635-100000@home.transmeta.com>
References: <1045932775.1946.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1045932775.1946.18.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


This fails with 

	drivers/built-in.o(.init.text+0x88df): In function `init_scsi':
	: undefined reference to `scsi_exit_procfs'
	drivers/built-in.o(.init.text+0x88e4): In function `init_scsi':
	: undefined reference to `scsi_exit_queue'
	make: *** [.tmp_vmlinux1] Error 1

for me.

They are marked __exit, which means that they end up being marked unused
_and_ in a segment that doesn't ever get loaded for built-in stuff (since 
clearly the built-in kernel can never unload).

In general, it is just illegal to call an __exit function from something 
that isn't __exit itself. And these functions are called from __init 
function too.

Please fix. In the meantime, my fix is to remove the two bogus "__exit" 
notifiers, and wondering to myself how the hell this ever worked for any 
of you guys.

		Linus

