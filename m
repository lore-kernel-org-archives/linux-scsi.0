From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Solution for "Unexpected busfree in Message-out phase" while using
 a scsi tape streamer
Date: Sat, 01 Feb 2003 01:49:11 +0100
Sender: linux-tape-owner@vger.kernel.org
Message-ID: <3E3B1987.5020803@fl.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-tape-owner@vger.kernel.org>
To: linux-tape@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi!

I keep getting questions about how I fixed the problem to my orginal
posting to this list. A reference to my posting is here:
   http://groups.google.com/groups?q=3Dauthor:fl%40fl.priv.at&hl=3Den&l=
r=3D&ie=3DUTF-8&client=3Dgooglet&selm=3Dlinux.scsi.3CF1F492.6060300%40f=
l.priv.at&rnum=3D6

The solution is to use a fixed blocksize. LTO tape streamers need a fix=
ed blocksize
of 1K and DLT ones runs best with 8 to 64k. BUT there's somehow a barri=
er at 8k, see:
   http://groups.google.com/groups?hl=3Den&lr=3D&ie=3DUTF-8&client=3Dgo=
oglet&selm=3D3D77B216.8070205%40fl.priv.at

=46or AIT I don't know, but you might want to experiment with the block=
size to
find out which is best for AIT.

BUT I can only speak about using LTO or DLT with ARKEIA Version 4.x
(http://www.arkeia.com/). Someone with the same LTO problem kindly
forwarded me the mail you can find below. Later I applied it to DLT
and it worked too.

So this mostly applies to ARKEIA, but it might work with your backup so=
lution
too.

Greetings
=46riedrich Lobenstock

-------- Original Message --------
Subject: Antwort: Re: Linux Problem SCSI Laufwerk HP Ultrium
Date: Mon, 24 Jun 2002 12:17:02 +0200
=46rom: <...email deleted for anonymity...>
To: Friedrich Lobenstock <fl@fl.priv.at>


Hallo Friedrich,

bei uns l=E4uft's jetzt nachdem wir die unten stehende Antwort vom Arke=
ia
Support erhalten hatten.....


Thomas,

The HP Ultrium LTO (particularly your model 215) works better when
configured with a 1024 tape block size (the default is variable
block size). Arkeia provides a way to force the tape block size:

In /usr/knox/arkeia/arkeia.prf file create the preference:

         ARK_SET_BLKSIZE "1"

and in the file /usr/knox/arkeia/dbase/f3drv/drvtypes.lst add the
SET_BLKSIZE property
into the LTO drive type as following:

         ITEM    {
                 "NAME"  "LTO"
                 "FORM_FACTOR"   "LTO"
                 "TIME_BEFORE_CLEAN"     "40"
                 "SET_BLKSIZE"    "1024"
         }

You have to restart Arkeia (both the graphic interface and NLSERVD) to =
be
sure the new configuration is take in count. Please note that after thi=
s
change Arkeia will not read the tape created previously with the variab=
le
block size.

How To Migrate The Existing Tapes:

After setting the 1024 tape block size, Arkeia cannot restore from tape=
s
made by using the default variable tape block size. So we need a proced=
ure
to migrate...
After changing the Arkeia configuration, delete all free tape definitio=
ns.
Re-create the tapes with a new basename and re-label them to be sure Ar=
keia
can work with these tapes.
If the Arkeia restoration asks for an old tape (just check the name), c=
ome
back to the old configuration, stop and restart the Arkeia GUI and perf=
orm
the restoration.

Let me know if this help you.

Michel Tugaye



-
To unsubscribe from this list: send the line "unsubscribe linux-tape" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
