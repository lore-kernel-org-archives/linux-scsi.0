From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Mon, 05 May 2003 17:58:28 +1000
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3EB619A4.5090407@torque.net>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

Andries.Brouwer@cwi.nl wrote:
>>Remove the scsi EVPD code.
> 
> 
> Good! That simplifies many things.

Good?? Just because there are millions of brain damaged
devices that can't implement rule 0 of a protocol,
Patrick removes one of the best features added to
the scsi subsystem in the 2.5 development series.

Patrick's patch is now in lk 2.5.69 .

So we are back to all the fun games of opening/
querying/closing likely looking device nodes in
the /dev space (and I speak from experience).
What a joy.

Surely there is a better way. Why not do the VPD=0x83
query on devices that claim to be SCSI-3 compliant
or better. The scsi mid level driver (and/or the
usb-storage + sbp2 LLDs) could have a sysfs parameter
such as "simple_scan". The filters discussion
showed more promise than this blunt approach.

I have contemplated putting the VPD=0x83 code in
lsscsi but it won't be pretty (e.g. requiring root
privilege, side effects including locking up
certain USB storage devices :-) ).

Doug Gilbert





-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
