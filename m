From: Grant Grundler <grundler@google.com>
Subject: Re: Should I be Worried: sda: p1 size .... limited to end of disk
Date: Wed, 14 Oct 2009 12:38:48 -0700
Message-ID: <da824cf30910141238v4780fbaasbcdeff33bc819f41@mail.gmail.com>
References: <4AD0E466.2070904@attglobal.net>
	 <da824cf30910121204l4edd75e7pa05386732ccb7556@mail.gmail.com>
	 <4AD38BEA.4090202@attglobal.net> <4AD51FF2.50900@attglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:33499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804AbZJNTkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2009 15:40:00 -0400
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id n9EJcp6n026367
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2009 12:38:51 -0700
Received: from pzk30 (pzk30.prod.google.com [10.243.19.158])
	by wpaz13.hot.corp.google.com with ESMTP id n9EJcSIp023645
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2009 12:38:48 -0700
Received: by pzk30 with SMTP id 30so105483pzk.24
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2009 12:38:48 -0700 (PDT)
In-Reply-To: <4AD51FF2.50900@attglobal.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stunnel@attglobal.net
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 13, 2009 at 5:48 PM, Eddie <stunnel@attglobal.net> wrote:
=2E...
> =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/sda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A063 =C2=A029=
29677659 =C2=A01464838798+ =C2=A08e =C2=A0Linux LVM
>
>
> OK, the total sectors seems to match the hardware scan -> sd 4:1:0:0:=
 [sda]
> 2929686528 512-byte hardware sectors: (1.49 TB/1.36 TiB)
>
> But 255 * 63 * 182364 =3D 2929677660. =C2=A0What's this discrepancy d=
ue to. =C2=A0Does
> the drive report ALL sectors, even the ones used to replace "bad" one=
s.

Definitely does not. SCSI disks report whatever number of sectors the
firmware is told to report. That's *always* less than the actual
number of physical sectors since drives need a reasonable supply of
"spare" sectors/tracks.


> However, 2929677660 does seem to tie up quite nicely with the "end se=
ctor",
> from the fdisk, so I'm assuming that everything is now correct.
>
> Well, apart from the fact that LVM reports a Total PE allocation of 3=
57627
> extents, which maps to 1464840192 Blocks, according to my maths anywa=
y,
> which happens to be bigger than the "available" sectors on the disk. =
=C2=A0I
> guess it's time to hit the LVM list, to see if there's any way I can =
safely
> correct this, before anything tries to use the "phantom" sectors.

I expect the LVM needs to be resized anytime the size of the
underlying partitions has changed. I'll bet there wiki/HOWTO someplace
that describes how to do that.

grant

>
> Cheers,
> Eddie
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
