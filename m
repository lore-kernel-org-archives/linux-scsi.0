From: Antonio Larrosa =?iso-8859-1?q?Jim=E9nez?= <antlarr@tedial.com>
Subject: Re: iowait problems on 2.6, not on 2.4
Date: Mon, 31 May 2004 13:24:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200405311324.38424.antlarr@tedial.com>
References: <200405261743.28111.antlarr@tedial.com> <1085877991.18642.336.camel@compaq.xsintricity.com> <20040529215226.68605319.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 62-15-228-226.inversas.jazztel.es ([62.15.228.226]:46254 "EHLO
	servint.tedial.com") by vger.kernel.org with ESMTP id S263656AbUEaLbS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 07:31:18 -0400
In-Reply-To: <20040529215226.68605319.akpm@osdl.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sunday 30 May 2004 06:52, Andrew Morton wrote:
> Also there was breakage (recently fixed) in which /dev/sdaN's readahe=
ad
> setting was being inherited from the blockdev on which /dev resides. =
 But
> reading regular files is OK.
>

I don't think I have that fix applied here.

I couldn't find any read_ahead* nor *ra_* under /sys, but blockdev work=
s.

Btw, by default it was using a read ahead of 128 Kb (blockdev returned =
256)

I re-run the dd read tests on reiserfs on the qla device (the one that =
took=20
1m27s before). These are the results on 2.6.4 :

blockdev --setra 1024 /dev/sde : 28s
(but this is the dd test in a most probably unfragmented file, so it's =
not a=20
value that can be used in real life)
blockdev --setra 512 /dev/sde : 51s (approx. what 2.4.21 took by defaul=
t)
blockdev --setra 256 /dev/sde : 1m27s
blockdev --setra 128 /dev/sde : 2m9s
blockdev --setra 64 /dev/sde  : 2m55s
blockdev --setra 0 /dev/sde   : 13m33s

On 2.4.21:

By default, /proc/sys/vm/min-readahead is 3 and /proc/sys/vm/max-readah=
ead is=20
127. I suppose those are Kb, since it didn't allow me to set a read ahe=
ad=20
value over 255 when using blockdev.

blockdev --setra 1024 /dev/sde : n/a (BLKRASET: Invalid argument)
blockdev --setra 512 /dev/sde : n/a (BLKRASET: Invalid argument)
blockdev --setra 256 /dev/sde : n/a (BLKRASET: Invalid argument)
blockdev --setra 255 /dev/sde :  52s
blockdev --setra 0 /dev/sde   : 54s

As this was unexpected (it seems blockdev is a NOP on 2.4.21 ?), I trie=
d=20
modifying /proc/sys/vm/min-readahead and max.

I set both to 512 (which should match blockdev --setra 1024 on 2.6.4) a=
nd got
25s reading

Setting both to 128kb (blockdev --setra 256), it took 49s.

Setting both to 0 (disabling read-ahead), it took 3m29s (compare that t=
o =20
13m33s on 2.6.4, so definitely, there's some problem here).

Anything else I can do to help to find the problem?

--
Antonio Larrosa
Tecnologias Digitales Audiovisuales, S.L.
http://www.tedial.com
Parque Tecnologico de Andalucia . M=E1laga (Spain)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
