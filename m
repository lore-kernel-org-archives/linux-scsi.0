From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: SCSI driver error messages - 2.4.18 kernel
Date: Wed, 18 Sep 2002 07:23:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D1CD@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmsmsxvs043.fm.intel.com (fmsmsxvs043.fm.intel.com [132.233.42.129])
	by petasus.ch.intel.com (8.11.6/8.11.6/d: solo.mc,v 1.43 2002/08/30 20:06:11 dmccart Exp $) with SMTP id g8IEOkI23505
	for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2002 14:24:46 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Heiko Nardmann' <h.nardmann@secunet.de>, linux-scsi@vger.kernel.org

Heiko,

You are starting to get some bad spots reported on your disk.  This isn't a
protocol error, but an issue with the disk media.  It will get some grown
defects over time as it ages.

One way to resolve this is to backup the data, do a scsi format, and
restore.  The scsi format will reassign bad blocks.  You can do a scsi
format from the SCSI adapter BIOS, or via some SCSI tools.

Another option is to set your disk mode pages to do auto-reallocations if
possible.  An application to set this in Linux is sgmode (from
http://scsirastools.sourceforge.net), and what you want to set is page 1,
byte 2 to 0xC4, so the line in the mdf file should look like this:
01 0a c4 ....

Andy Cress

-----Original Message-----
From: Heiko Nardmann [mailto:h.nardmann@secunet.de] 
Sent: Wednesday, September 18, 2002 3:28 AM
To: linux-scsi@vger.kernel.org
Subject: Q: SCSI driver error messages - 2.4.18 kernel

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

Maybe I am a bit off topic but I sometimes get error messages like the 
following in my /var/adm/messages file. Since I do not really know how to 
interpret them I wonder what to do. Does this mean that my drive dies slowly

or is it possible that is due to some termination problem?

Sep 18 09:10:57 snsrv053 kernel: scsi0: ERROR on channel 0, id 0, lun 0,
CDB: 
Read (10) 00 00 1b e7 a6 00 00 d0 00
Sep 18 09:10:57 snsrv053 kernel: Info fld=0x1be83a, Current sd08:06: sense
key 
Medium Error
Sep 18 09:10:57 snsrv053 kernel: Additional sense indicates Unrecovered read

error - recommend reassignment
Sep 18 09:10:57 snsrv053 kernel:  I/O error: dev 08:06, sector 432154
Sep 18 09:10:58 snsrv053 kernel: scsi0: ERROR on channel 0, id 0, lun 0,
CDB: 
Read (10) 00 00 1b e8 3a 00 00 02 00
Sep 18 09:10:58 snsrv053 kernel: Info fld=0x1be83a, Current sd08:06: sense
key 
Medium Error
Sep 18 09:10:58 snsrv053 kernel: Additional sense indicates Unrecovered read

error - recommend reassignment
Sep 18 09:10:58 snsrv053 kernel:  I/O error: dev 08:06, sector 432154

Any idea?

- -- 
Heiko Nardmann (Dipl.-Ing.), h.nardmann@secunet.de, Software Development
secunet Security Networks AG - Sicherheit in Netzwerken (www.secunet.de),
Weidenauer Str. 223-225, D-57076 Siegen
Tel. : +49 271 48950-13, Fax  : +49 271 48950-50
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iEYEARECAAYFAj2IKwAACgkQpm53PRScYyienQCePmJ9NQDsj4AP6A9ElLIDxyr4
K5wAoM/Y2xJgHZokYytVpOs5EUU0lJUe
=Kxtt
-----END PGP SIGNATURE-----

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
