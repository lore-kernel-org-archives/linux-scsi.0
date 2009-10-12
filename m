From: Grant Grundler <grundler@google.com>
Subject: Re: Should I be Worried: sda: p1 size .... limited to end of disk
Date: Mon, 12 Oct 2009 12:04:50 -0700
Message-ID: <da824cf30910121204l4edd75e7pa05386732ccb7556@mail.gmail.com>
References: <4AD0E466.2070904@attglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:8421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909AbZJLTGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2009 15:06:01 -0400
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id n9CJ4rkq028711
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2009 12:04:53 -0700
Received: from pzk10 (pzk10.prod.google.com [10.243.19.138])
	by spaceape9.eur.corp.google.com with ESMTP id n9CJ4bMN022403
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2009 12:04:50 -0700
Received: by pzk10 with SMTP id 10so3453622pzk.19
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2009 12:04:50 -0700 (PDT)
In-Reply-To: <4AD0E466.2070904@attglobal.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stunnel@attglobal.net
Cc: linux-scsi@vger.kernel.org

On Sat, Oct 10, 2009 at 12:45 PM, Eddie <stunnel@attglobal.net> wrote:
> After the fun and games with my other LSI MegaRAID card, I'm a glutto=
n for
> punishment.
>
> I'm building another system, which this time, has an LSI MegaRAID SAT=
A
> 300-8X controller in it. =C2=A0This appears to be working perfectly, =
and a lot
> faster than my other card, with the exception of this warning message=
 during
> boot:
>
> sda: p1 size 2930304132 limited to end of disk

sda only has 2929686528 blocks - "p1" is somehow defined to go past
the end of the RAID "device".

I've no clue where the "2930304132" is coming from. I'd want to see
the "raw" values the partition table.
Seems like the partition table was written with the wrong size,

> Is this something I should be worried about, and how does it come abo=
ut. =C2=A0I
> built a new RAID 5, Logical device, on the card, which the LSI utilit=
y says
> is 1430511MB in size.

1430511*1024*2
2929686528

>
> Here's the relevant output from DMESG:
>
> scsi 4:1:0:0: Direct-Access =C2=A0 =C2=A0 MegaRAID LD 0 RAID5 1430G 8=
15C PQ: 0 ANSI: 2
> sd 4:1:0:0: [sda] 2929686528 512-byte hardware sectors: (1.49 TB/1.36=
 TiB)
> sd 4:1:0:0: [sda] Write Protect is off
> sd 4:1:0:0: [sda] Mode Sense: 00 00 00 00
> sd 4:1:0:0: [sda] Asking for cache data failed
> sd 4:1:0:0: [sda] Assuming drive cache: write through
> sd 4:1:0:0: [sda] 2929686528 512-byte hardware sectors: (1.49 TB/1.36=
 TiB)
> sd 4:1:0:0: [sda] Write Protect is off
> sd 4:1:0:0: [sda] Mode Sense: 00 00 00 00
> sd 4:1:0:0: [sda] Asking for cache data failed
> sd 4:1:0:0: [sda] Assuming drive cache: write through
> sda: sda1
> sda: p1 size 2930304132 limited to end of disk
> sd 4:1:0:0: [sda] Attached SCSI disk
> sd 4:1:0:0: Attached scsi generic sg1 type 0
>
> And /proc/partions:
>
> major minor =C2=A0#blocks =C2=A0name
>
> =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 20044080 hda
> =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A09727326 hda1
> =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A09727357 hda2
> =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 586372 hda4
> =C2=A08 =C2=A0 =C2=A0 =C2=A0 =C2=A00 1464843264 sda
> =C2=A08 =C2=A0 =C2=A0 =C2=A0 =C2=A01 1464843232 sda1
> 253 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0314572800 dm-0
> 253 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0157286400 dm-1
> 253 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0209715200 dm-2
> 253 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0104857600 dm-3
> 253 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0104857600 dm-4
> 253 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0262144000 dm-5
>
>
> And fdisk:
>
> Disk /dev/sda: 1499.9 GB, 1499999502336 bytes
> 255 heads, 63 sectors/track, 182364 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0x0003d809
>
> =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/sda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=
=A0 =C2=A0182403 =C2=A01465152066 =C2=A0 8e =C2=A0Linux LVM
>
> So, where is the discrepancy creeping in.

Can you print this using "Units of Blocks" instead of "Cyclinders"?
Use "-u" parameter.

hth,
grant

>
> Also, I see this in DMESG:
>
> sd 4:1:0:0: [sda] Assuming drive cache: write through
>
> But, as this card has a battery backup, I have it set to "Write Back"=
 in the
> configuration. =C2=A0So, what mode is it really operating in.
>
> Cheers,
> Eddie
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
