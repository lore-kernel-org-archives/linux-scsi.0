From: Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: Linux 2.6.37-rc1 (scsi_debug: list corruption)
Date: Thu, 4 Nov 2010 10:25:09 +0800
Message-ID: <AANLkTin5PphTtZaesEU3U0PA8NJv=Jmis8yQF6b=KbeG@mail.gmail.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
	<20101103162015.99475a0b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39492 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0KDCZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2010 22:25:10 -0400
In-Reply-To: <20101103162015.99475a0b.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Nov 4, 2010 at 7:20 AM, Randy Dunlap <randy.dunlap@oracle.com> =
wrote:
>
>
> [ =C2=A0102.555847] calling =C2=A0scsi_debug_init+0x0/0x704 [scsi_deb=
ug] @ 3337
> Nov =C2=A03 16:06:12 control kernel: [ =C2=A0102.555847] calling =C2=A0=
scsi_deb[ =C2=A0102.622974] scsi_debug: host protection
> [ =C2=A0102.627513] scsi4 : scsi_debug, version 1.82 [20100324], dev_=
size_mb=3D8, opts=3D0x0
> Nov =C2=A03 16:06:13 control kernel: [ =C2=A0102.639095] initcall scs=
i_debug_init+0x0/0x704 [scsi_debug] returned 0 after 75039 usecs
> Nov =C2=A03 16:06:13 [ =C2=A0102.651072] ------------[ cut here ]----=
--------
> [ =C2=A0102.657373] WARNING: at /local/linsrc/lnx-2637-rc1/lib/list_d=
ebug.c:26 __list_add+0x4d/0xa5()
> [ =C2=A0102.666012] Hardware name: OptiPlex GX620
> [ =C2=A0102.671396] list_add corruption. next->prev should be prev (f=
fffffff81ae5e50), but was 6b6b6b6b6b6b6b6b. (next=3Dffff88006c880590).

This might be related with net rds percpu_counter corruption. Does
following patch fix your issue?
http://patchwork.ozlabs.org/patch/69939/

>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your c=
ode ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
