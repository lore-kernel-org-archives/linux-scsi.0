From: Joerg Schilling <schilling@fokus.fraunhofer.de>
Subject: RE: FW: USB 2.0 external hard drive problem
Date: Fri, 13 Feb 2004 13:19:19 +0100 (CET)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200402131219.i1DCJJjI023364@burner.fokus.fraunhofer.de>
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James.Bottomley@steeleye.com, stern@rowland.harvard.edu, tonyb@cybernetics.com
Cc: appro@fy.chalmers.se, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, magliery@csb.yale.edu, mdharm-scsi@one-eyed-alien.net, schilling@fokus.fraunhofer.de
List-Id: linux-scsi@vger.kernel.org

>From tonyb@cybernetics.com  Mon Feb  9 23:12:23 2004

>> Especially if the sense code is NO SENSE.  Logically that should
>> indicate the driver needed to find out whether or not there was error,
>> and it learned that there wasn't.

>For tape drives, sense key == NO SENSE is not equivalent to no error to
>report.  Often a tape drive returns a sense key of NO SENSE but with one
>of the other bits (EOM, FILEMARK, ILI) set in the same byte as the sense
>key.  There are also some ASC/ASCQ combinations that go with a sense key
>of NO SENSE but without any of the EOM, FILEMARK, or ILI bits set.

>On the other hand, some tape drives set the EOM bit in unsolicited
>request sense data just to report the position of the tape, so the EOM
>bit being set isn't necessarily an indicator that there was an error.
>However, ASC/ASCQ should be nonzero when the EOM bit is set because of
>an error.

>I recommend defining "no error" to be:

>(sense_data[2] & 0xaf) == 0x00 && /* Filemark 0, ignore EOM, ILI 0, NO
>SENSE */
>sense_data[12]  == 0x00 && /* ASC */
>sense_data[13] == 0x00 /* ASCQ */

>This should work for most devices that I have encountered.

Sounds OK.

It would be sufficient to clear Byte 0 of the sense data in this case,
as a correctly written program like libscg first checks whether
the SCSI sense data is in the expected extended sense format.
Note: As libscg is now 18 years old, it also supports the non-extended
sense format. This is why byte 0 in the sense data needs to be cleared 
completely.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de		(uni)  If you don't have iso-8859-1
       schilling@fokus.fraunhofer.de	(work) chars I am J"org Schilling
 URL:  http://www.fokus.fraunhofer.de/usr/schilling ftp://ftp.berlios.de/pub/schily


-------------------------------------------------------
SF.Net is sponsored by: Speed Start Your Linux Apps Now.
Build and deploy apps & Web services for Linux with
a free DVD software kit from IBM. Click Now!
http://ads.osdn.com/?ad_id=1356&alloc_id=3438&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
