From: Karl Hammar <karl@kalle.csb.ki.se>
Subject: Re: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 13:41:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205201141.g4KBfeI3022515@opal.aspo.lcl>
References: <3CE8CDC9.7070200@galileo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from opal.aspo.lcl (localhost [127.0.0.1])
	by opal.aspo.lcl (8.12.3/8.12.3/Debian -4) with ESMTP id g4KBfeI3022515
	for <linux-scsi@vger.kernel.org>; Mon, 20 May 2002 13:41:40 +0200
In-Reply-To: Message from Rabeeh Khoury <rabeeh@galileo.co.il>
   of "Mon, 20 May 2002 13:19:53 +0300." <3CE8CDC9.7070200@galileo.co.il>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


  I use this script:

# cat `which sdon`
#!/bin/sh

dev=3D/dev/sdc
num=3D4

case $0 in
*off)
        umount ${dev}1
        scsi-spin --down $dev
        echo "scsi remove-single-device 0 0 $num 0" > /proc/scsi/scsi
        ;;
*on)
        echo scsi add-single-device 0 0 $num 0 > /proc/scsi/scsi
        mount ${dev}1
        ;;
esac

  for a disk which happens to have scsi-id 4 and shows up as /dev/sdc.
Used like, sdoff, remove disk; insert disk, let it spin up, sdon.

Regards,
/Karl

-----------------------------------------------------------------------
Karl Hammar                    Asp=F6 Data           karl@kalle.csb.ki.=
se
Lilla Asp=F6 2340             +46  173 140 57                    Networ=
ks
S-742 94 =D6sthammar         +46  10 270 26 67                  Compute=
rs
Sweden                                                       Consulting
-----------------------------------------------------------------------


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
