From: Axel Theilmann <theilmann@pre-sense.de>
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
Date: Tue, 27 Dec 2011 11:21:48 +0100
Message-ID: <4EF99C3C.8030602@pre-sense.de>
References: <4EE8E419.8010000@pre-sense.de> <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com> <20111225215804.03ef9402@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.pre-sense.de ([213.238.39.107]:55489 "EHLO
	mail.pre-sense.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1L0KVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Dec 2011 05:21:52 -0500
In-Reply-To: <20111225215804.03ef9402@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>, jbottomley@parallels.com, linux-kernel@vger.kernel.org

On 12/25/2011 09:58 PM, Stefan Richter wrote:

moin,

> as far as I remember, all Linux releases in 2011 have been broken WRT=
 hot
> removal of block devices; some more severely, some less.  Various pat=
ches
> for this went in over the year, but if they fixed anything, they alwa=
ys
> uncovered the next lingering unplug related bug.  The presumed first =
Linux

so now there are 2 known NULL-pointer problems in the cd-rom code and o=
ne in
the scsi-disk code.

Would a complete fix for this issue be a question of locating all the
possible NULL-pointers and fixing them or do you think that the hotplug
problem has to be fixed on a more "fundamental" level?

Even if there is a more fundamental problem below that has to be fixed,=
 it
would still be nice to get in fixes for the dereferences that are curre=
ntly
known to keep peoples systems from crashing.

We built a kernel with Huajun's patch included and will do some tests t=
o see
if the problem goes away (and no others show up).


> With a little bit of bad luck, udisks-daemon or in older distros hald
> should hit the bug too.  Under kernel 3.1 I typically just got proces=
ses
> hanging in unkillable sleep.  With kernel 3.2-rc7 I get an instant ke=
rnel
> panic.

Yes, udisks is what probably triggers the bug for us. People removing U=
SB
media before udisks is finished initializing the medium. With kernel 3.=
1.4
we get instant kernel panics as well.


tty, axel



--=20
Dipl.-Inform. Axel Theilmann             theilmann@pre-sense.de
                               Tel.  (+49) 040  / 244 2407 - 13
                               Fax   (+49) 040  / 244 2407 - 24
                               Mobil (+49) 0151 / 116 18 664
PRESENSE Technologies GmbH         Sachsenstr. 5, 20097 Hamburg
                                         USt-IdNr.: DE263765024
Gesch=E4ftsf=FChrer/Managing Directors       AG Hamburg, HRB 107844
Till D=F6rges           J=FCrgen Sander              Axel Theilmann
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
