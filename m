From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
	reference to `request_firmware'
Date: Sat, 17 May 2008 11:04:31 +0100
Message-ID: <1211018673.3603.7.camel@localhost.localdomain>
References: <200805161906.19321.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60111 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbYEQKEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2008 06:04:44 -0400
In-Reply-To: <200805161906.19321.toralf.foerster@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2008-05-16 at 19:06 +0200, Toralf F=C3=B6rster wrote:
> Hello,
>=20
> the build (.config attached) failed, make ends with :
> ...
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33bab): undefined reference to `request_firmware'
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33c3f): undefined reference to `release_firmware'
> make: *** [vmlinux] Error 1

There's a slight fault in the stub logic.  It fails for FW_LOADER=3Dm a=
nd
the user =3Dy.

This should fix it.

James

---

diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 4d10c73..6c7eff2 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -13,7 +13,7 @@ struct firmware {
=20
 struct device;
=20
-#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && =
defined(MODULE))
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
