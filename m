From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [-next] ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!
Date: Fri, 7 Jan 2011 11:57:45 +0100
Message-ID: <AANLkTinhrj38rbEt7ds971D9g-UF+xS0jmzO7X15ZaLn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:56424 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1AGK5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 05:57:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Bellinger <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>
Cc: scsi <linux-scsi@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org

Since a few days, linux-next shows:

| ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!

in m68k allmodconfig builds
(http://kisskb.ellerman.id.au/kisskb/buildresult/3754323/).

I guess this is caused by the following 3 calls to strstr():

drivers/target/target_core_configfs.c:
+       ptr =3D strstr(page, "1");

+       str =3D strstr(buf, "_");

+       str2 =3D strstr(str+1, "_");

Some versions of gcc replace calls to strstr() with single-character
"needle" string parameters by calls to strchr() behind our back.
This causes linking errors if strchr() is defined as an inline function
in <asm/string.h> (e.g. on m68k).

You can prevent this by explicitly calling strchr() instead.

Cfr. commit 59d309f9c8ef0bd01bf93cc0e758f1d810417bdb
("kgdb: Replace strstr() by strchr() for single-character needles).

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
