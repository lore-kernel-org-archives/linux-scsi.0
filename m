From: Aaron Traas <atraas@syncsort.com>
Subject: st ioctl documentation error (MT_ST_SYSV)
Date: Sun, 13 Apr 2003 10:05:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E996E96.3040502@syncsort.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pool-141-153-194-157.mad.east.verizon.net ([141.153.194.157]:60290
	"EHLO claymore.tyrfing.org") by vger.kernel.org with ESMTP
	id S263517AbTDMN4x (for <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Apr 2003 09:56:53 -0400
Received: from rapier.tyrfing.org ([10.1.1.166] helo=syncsort.com)
	by claymore.tyrfing.org with esmtp (Exim 3.35 #1 (Debian))
	id 194i9o-0004Rm-00
	for <linux-scsi@vger.kernel.org>; Sun, 13 Apr 2003 10:08:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello. I'm trying to fix some bugs in a port of my company's proprietar=
y=20
tape backup software. Our software works flawlessly on most commercial=20
UNIX platforms. When handling tape reads, we use one of two different=20
subroutines for handling the positioning of the read-head after a read.=
=20
On BSD-flavored systems (such as *BSD), we do more-or-less nothing, as=20
after a read, the tape is spaced forward to the next filemark. On SysV=20
flavored systems (like Solaris 8), we advance the filemark manually.

We have a problem on Linux, as it states in the st(4) manpage:

MT_ST_SYSV (Default: false)
    When  this  option  is  enabled,  the  tape
    devices use the SystemV  semantics.  Other=AD
    wise  the  BSD semantics are used. The most
    important difference between the  semantics
    is  what  happens  when  a  device used for
    reading is closed: in  SYSV  semantics  the
    tape  is spaced forward past the next file=AD
    mark if this has not happened  while  using
    the device. In BSD semantics the tape posi=AD
    tion is not changed.

Which switches what we have defined as BSD and SYSV semantics. It state=
s=20
that Linux uses BSD semantics by default, and then says SYSV semantics=20
are what we know are BSD semantics, and that BSD semantics are what we=20
know as SYSV semantics. How do we know? BSD and Solaris' man pages on=20
the subject contradict Linux's, and our software properly works on thos=
e=20
  systems.

So, going by the description in the page on what the semantics are, we=20
have defined Linux in our build system as using non-BSD style tape read=
=20
semantics. This results in fsf errors.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
