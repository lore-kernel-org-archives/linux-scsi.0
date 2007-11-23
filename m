From: Hannes Reinecke <hare@suse.de>
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
Date: Fri, 23 Nov 2007 08:51:07 +0100
Message-ID: <4746866B.5070207@suse.de>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	<4744A6F2.4030302@free.fr> <20071121144116.c932727b.akpm@linux-foundation.org> <4746814F.80502@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:42387 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbXKWHvJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Nov 2007 02:51:09 -0500
In-Reply-To: <4746814F.80502@free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Laurent Riffard wrote:
> Le 21.11.2007 23:41, Andrew Morton a =E9crit :
>> On Wed, 21 Nov 2007 22:45:22 +0100
>> Laurent Riffard <laurent.riffard@free.fr> wrote:
>>
>>> Le 21.11.2007 05:45, Andrew Morton a =E9crit :
>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.=
24-rc3/2.6.24-rc3-mm1/
>>> Hello,=20
>>>
>>> My system hangs shortly after I logged in Gnome desktop. SysRq-W sh=
ows
>>> that a bunch of task are blocked in "D" state, they seem to wait fo=
r
>>> some I/O completion. I can try to hand-copy some data if requested.
>>>
>>> I found these messages in dmesg:
>>>
>>> ~$ grep -C2 end_request dmesg-2.6.24-rc3-mm1=20
>>> EXT3-fs: mounted filesystem with ordered data mode.
>>> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDR=
IVER_OK,SUGGEST_OK
>>> end_request: I/O error, dev sda, sector 16460
>>> ReiserFS: sda7: found reiserfs format "3.6" with standard journal
>>> ReiserFS: sda7: using ordered data mode
>>> --
>>> ReiserFS: sda7: Using r5 hash to sort names
>>> sd 0:0:1:0: [sdb] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDR=
IVER_OK,SUGGEST_OK
>>> end_request: I/O error, dev sdb, sector 19632
>>> sd 0:0:1:0: [sdb] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDR=
IVER_OK,SUGGEST_OK
>>> end_request: I/O error, dev sdb, sector 40037363
>>> Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priority:-1 e=
xtents:1 across:1048568k
>>> lp0: using parport0 (interrupt-driven).
>>>
>>> These errors occur *only* with 2.6.24-rc3-mm1, they are 100% reprod=
ucible.
>>> 2.6.24-rc3 and 2.6.24-rc2-mm1 are fine.
>>>
>>> Maybe something is broken in pata_via driver ?
>>>
>> Could be - libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm=
_xfermask.patch
>> and pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-ti=
mings.patch
>> touch pata_via.c.
>=20
> None of the above...
>=20
> I did a bisection, it spotted git-scsi-misc.patch.=20
> I just run 2.6.24-rc3-mm1 + revert-git-scsi-misc.patch, and it works =
fine.
>=20
> I guess commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0 "[SCSI] Do no=
t=20
> requeue requests if REQ_FAILFAST is set" is the real culprit. The oth=
er=20
> commits are touching documentation or drivers I don't use. I'll try=20
> to revert only this one this evening.
>=20
Hmm. Weird. I'll have a look into it. Apparently I'll be returning an e=
rror where
I shouldn't. Checking ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
