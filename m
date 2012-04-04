From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Wed, 4 Apr 2012 11:28:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204041043580.1543-100000@iolanthe.rowland.org>
References: <850871.26108.qm@web100009.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <850871.26108.qm-303aDswoEIaO4BqzrDeqF0yFvBl6snHEEwWAM/ix52Y@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 4 Apr 2012, Norman Diamond wrote:

> The usbmon output quoted below comes from the sequence of two commands:
> sg_dd blk_sgio=1 bpt=1 bs=512 count=1 if=/dev/sdb of=/dev/null skip=551562
> dd bs=512 count=1 if=/dev/sdb of=/dev/null skip=551562
> 
> As expected by now, the sg_dd command properly reported an error for the unreadable block, and the USB-to-ATA bridge did not crash.  The dd command also reported an error, and then a driver caused a crash of the driver's self and/or the bridge.

This is good.  It shows just what happened.

And by the way, you shouldn't be so quick to assign blame.  Without
knowing the exact details, you're not in a position to say where the
fault really lies.

> f0da9c00 3237261077 S Bo:2:003:1 -115 31 = 55534243 d7000000 24000000 80000612 00000024 00000000 00000000 000000
> f0da9c00 3237261251 C Bo:2:003:1 0 31 >
> f2938d80 3237261539 S Bi:2:003:2 -115 36 <
> f2938d80 3237261706 C Bi:2:003:2 0 36 = 00000000 23000000 48495441 4348495f 444b3233 42412d32 30422020 20202020
> f0da9c00 3237261723 S Bi:2:003:2 -115 13 <
> f0da9c00 3237261793 C Bi:2:003:2 0 13 = 55534253 d7000000 00000000 00

The first command issued by sg_dd was an INQUIRY, and it succeeded.

> f0da9c00 3237261905 S Bo:2:003:1 -115 31 = 55534243 d8000000 00020000 80000a28 0000086a 8a000001 00000000 000000
> f0da9c00 3237262093 C Bo:2:003:1 0 31 >
> f2938d80 3237262250 S Bi:2:003:2 -115 512 <
> f2938d80 3239564885 C Bi:2:003:2 -32 0
> f0da9c00 3239564972 S Co:2:003:0 s 02 01 0000 0082 0000 0
> f0da9c00 3239565256 C Co:2:003:0 0 0
> f0da9c00 3239565287 S Bi:2:003:2 -115 13 <
> f0da9c00 3239565485 C Bi:2:003:2 0 13 = 55534253 d8000000 00020000 01

This is the second command, a READ(10) for one block starting at block
551562 (86a8a in hex).  The bridge transmitted no data and reported a 
failure status.

> f0da9c00 3239565521 S Bo:2:003:1 -115 31 = 55534243 d9000000 12000000 80000603 00000012 00000000 00000000 000000
> f0da9c00 3239565740 C Bo:2:003:1 0 31 >
> f2938d80 3239565896 S Bi:2:003:2 -115 18 <
> f2938d80 3239566129 C Bi:2:003:2 0 18 = 70000000 0000000a 00000000 00000000 0000
> f0da9c00 3239566160 S Bi:2:003:2 -115 13 <
> f0da9c00 3239566364 C Bi:2:003:2 0 13 = 55534253 d9000000 00000000 00

When asked for detailed status information (REQUEST SENSE), the bridge
sent an empty reply (No Sense).  This is a bug in the bridge; it should
have indicated what sort of failure occurred, such as: Hardware Error,
Unrecovered read error.

> f0da9c00 3239577155 S Bo:2:003:1 -115 31 = 55534243 da000000 00000000 00000600 00000000 00000000 00000000 000000
> f0da9c00 3239577291 C Bo:2:003:1 0 31 >
> f0da9c00 3239577492 S Bi:2:003:2 -115 13 <
> f0da9c00 3239577666 C Bi:2:003:2 0 13 = 55534253 da000000 00000000 00

This is a TEST UNIT READY command.  It shows that the drive is ready
to be used.  I can't tell if this command was sent by sg_dd or
something else.

> f0da9c00 3239579541 S Bo:2:003:1 -115 31 = 55534243 db000000 00100000 80000a28 00025428 80000008 00000000 000000
> f0da9c00 3239579702 C Bo:2:003:1 0 31 >
> f2938300 3239579845 S Bi:2:003:2 -115 4096 <
> f2938300 3239593701 C Bi:2:003:2 0 4096 = 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> f0da9c00 3239593720 S Bi:2:003:2 -115 13 <
> f0da9c00 3239593791 C Bi:2:003:2 0 13 = 55534253 db000000 00000000 00
...

There follows a rather lengthy series of reads, of which I have cut out
all but the first.  They look like the sort of thing udev does when a
new drive is registered, but I have no idea why udev should have been
triggered at this point.  Anyway, they all succeeded.

> f0da9c00 3239745783 S Bo:2:003:1 -115 31 = 55534243 37010000 00000000 00000600 00000000 00000000 00000000 000000
> f0da9c00 3239746063 C Bo:2:003:1 0 31 >
> f0da9c00 3239746250 S Bi:2:003:2 -115 13 <
> f0da9c00 3239746289 C Bi:2:003:2 0 13 = 55534253 37010000 00000000 00

Another successful TEST UNIT READY.

> f0da9c00 3239747439 S Bo:2:003:1 -115 31 = 55534243 38010000 00020000 80000ca1 082e0001 00000000 ec000000 000000
> f0da9c00 3239747584 C Bo:2:003:1 0 31 >
> f2938c80 3239747747 S Bi:2:003:2 -115 512 <
> f2938c80 3239747790 C Bi:2:003:2 -32 0
> f0da9c00 3239747827 S Co:2:003:0 s 02 01 0000 0082 0000 0
> f0da9c00 3239747935 C Co:2:003:0 0 0
> f0da9c00 3239747969 S Bi:2:003:2 -115 13 <
> f0da9c00 3239748065 C Bi:2:003:2 0 13 = 55534253 38010000 00020000 01

This is a 12-byte ATA pass-through command.  I don't know just what the
command is, but in any case the bridge rejected it with a failure 
status.

> f0da9c00 3239748146 S Bo:2:003:1 -115 31 = 55534243 39010000 12000000 80000603 00000012 00000000 00000000 000000
> f0da9c00 3239748307 C Bo:2:003:1 0 31 >
> f2938c80 3239748462 S Bi:2:003:2 -115 18 <
> f2938c80 3239748557 C Bi:2:003:2 0 18 = 70000500 0000000a 00000000 20000000 0000
> f0da9c00 3239748591 S Bi:2:003:2 -115 13 <
> f0da9c00 3239748686 C Bi:2:003:2 0 13 = 55534253 39010000 00000000 00

The corresponding sense information is: Illegal Request, Invalid
command operation code, which is appropriate for an unrecognized command.

> f0da9c00 3239748806 S Bo:2:003:1 -115 31 = 55534243 3a010000 00000000 00000600 00000000 00000000 00000000 000000
> f0da9c00 3239748949 C Bo:2:003:1 0 31 >
> f0da9c00 3239749103 S Bi:2:003:2 -115 13 <
> f0da9c00 3239749164 C Bi:2:003:2 0 13 = 55534253 3a010000 00000000 00

Yet another TEST UNIT READY.  Then about 15 seconds later we have:

> f0da9c00 3255121946 S Bo:2:003:1 -115 31 = 55534243 3b010000 00100000 80000a28 0000086a 88000008 00000000 000000
> f0da9c00 3255122051 C Bo:2:003:1 0 31 >
> f2938680 3255122332 S Bi:2:003:2 -115 4096 <
> f2938680 3257419391 C Bi:2:003:2 -121 1037 = 20284143 31290000 534d4152 5420436f 6d6d616e 64205472 616e7370 6f727420
> f0da9c00 3257419502 S Bi:2:003:2 -115 13 <
> f0da9c00 3285854403 C Bi:2:003:2 -104 0

This is a READ(10) command for 8 blocks starting at block 551560.
Obviously this originated from the dd program, which goes through the
block layer and therefore tries to read an entire page at a time.  The
bridge transmitted only 1037 bytes out of the 4096 that were requested
and then didn't send a status code.  After 30 seconds of waiting for
the status, the command was aborted.

Interestingly, 1037 = 1024 + 13.  The first two readable blocks amount
to 1024 bytes, and the status information is 13 bytes long.  However
the bridge neglected to separate the data from the status (it should
have sent a zero-length packet in between), so to the computer it
looked like 1037 bytes of data.  Evidently this is another bug in the
bridge.

> f44c7500 3285854464 S Co:2:002:0 s 23 03 0004 0003 0000 0
> f44c7500 3285854636 C Co:2:002:0 0 0
> f44c7500 3285865159 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> f44c7500 3285865408 C Ci:2:002:0 0 4 = 11050000
> f44c7500 3285876152 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> f44c7500 3285876399 C Ci:2:002:0 0 4 = 03051000
> f44c7500 3285927200 S Co:2:002:0 s 23 01 0014 0003 0000 0
> f44c7500 3285927347 C Co:2:002:0 0 0
> f44c7500 3285927420 S Ci:2:000:0 s 80 06 0100 0000 0040 64 <
> f44c7500 3285927734 C Ci:2:000:0 0 18 = 12010002 00000040 7b060725 00010102 0301
> f44c7500 3285927770 S Co:2:002:0 s 23 03 0004 0003 0000 0
> f44c7500 3285927824 C Co:2:002:0 0 0
> f29aad00 3285938200 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> f29aad00 3285938354 C Ci:2:002:0 0 4 = 11050000
> f29aad00 3285949217 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> f29aad00 3285949327 C Ci:2:002:0 0 4 = 03051000
> f3c27500 3285971663 C Ii:2:002:1 0:2048 2 = 0800
> f3c27500 3285971669 S Ii:2:002:1 -115:2048 2 <
> f29aad00 3286000218 S Co:2:002:0 s 23 01 0014 0003 0000 0
> f29aad00 3286000323 C Co:2:002:0 0 0
> f29aad00 3286000420 S Co:2:000:0 s 00 05 0003 0000 0000 0
> f29aad00 3286000642 C Co:2:000:0 0 0
> f29aad00 3286012218 S Ci:2:003:0 s 80 06 0100 0000 0012 18 <
> f29aad00 3286012661 C Ci:2:003:0 0 18 = 12010002 00000040 7b060725 00010102 0301
> f29aad00 3286012756 S Ci:2:003:0 s 80 06 0200 0000 0020 32 <
> f29aad00 3286013239 C Ci:2:003:0 0 32 = 09022000 010100c0 32090400 00020806 50000705 01020002 00070582 02000200
> f29aad00 3286013339 S Ci:2:003:0 s 80 06 0303 0409 00ff 255 <
> f29aad00 3286013609 C Ci:2:003:0 0 4 = 04033000
> f29aad00 3286013711 S Co:2:003:0 s 00 09 0001 0000 0000 0
> f29aad00 3286013984 C Co:2:003:0 0 0

I'll skip the details; the above sequence shows the device being reset
(including having its address re-assigned).

> f0da9c00 3286014115 S Bo:2:003:1 -115 31 = 55534243 3c010000 00000000 00000600 00000000 00000000 00000000 000000
> f0da9c00 3286014228 C Bo:2:003:1 0 31 >
> f0da9c00 3286014430 S Bi:2:003:2 -115 13 <
> f0da9c00 3286014598 C Bi:2:003:2 0 13 = 55534253 3c010000 00000000 00

This is another TEST UNIT READY command, sent to make sure the drive
is ready to resume normal operation after being reset.  It succeeds.

> f0da9c00 3286017121 S Bo:2:003:1 -115 31 = 55534243 3d010000 00100000 80000a28 0000086a 88000008 00000000 000000
> f0da9c00 3286017234 C Bo:2:003:1 0 31 >
> f29aad00 3286017446 S Bi:2:003:2 -115 4096 <
> f29aad00 3316830429 C Bi:2:003:2 -104 0

This is the same READ(10) command as before, retried.  This time the
bridge didn't send any data at all before it stopped responding. Again,
the command was aborted after 30 seconds of silence.

> f29aad00 3316830529 S Co:2:002:0 s 23 03 0004 0003 0000 0
> f29aad00 3316830658 C Co:2:002:0 0 0
> f29aad00 3316841216 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> f29aad00 3316841405 C Ci:2:002:0 0 4 = 11050000
> f29aad00 3316852213 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> f29aad00 3316852402 C Ci:2:002:0 0 4 = 03051000
> f29aad00 3316903213 S Co:2:002:0 s 23 01 0014 0003 0000 0
> f29aad00 3316903370 C Co:2:002:0 0 0
> f29aad00 3316903471 S Ci:2:000:0 s 80 06 0100 0000 0040 64 <
> f29aad00 3321903434 C Ci:2:000:0 -2 0
> f29aad00 3321903529 S Ci:2:000:0 s 80 06 0100 0000 0040 64 <
> f29aad00 3321908758 C Ci:2:000:0 -71 0
> f29aad00 3321908930 S Ci:2:000:0 s 80 06 0100 0000 0040 64 <
> f29aad00 3321912970 C Ci:2:000:0 -71 0

The remainder of the trace is just like this, repeated over and over.
It shows the device being reset but not responding at all.  Evidently
at this point the bridge has crashed completely.

Judging by this analysis, you tell me: Which component is at fault?  
The driver did exactly as it was told, and it reset the device each
time the bridge stopped responding.  The bridge, on the other hand,
displayed multiple bugs and eventually crashed completely.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
