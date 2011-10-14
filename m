From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 21/37] iscsi-target: use native hex2bin for chap_string_to_hex
Date: Fri, 14 Oct 2011 11:46:07 +0300
Message-ID: <CAHp75VcEo_TnAZXFYhmtD7n9HajV_GtShcyBGHiq8O76udwnqA@mail.gmail.com>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
	<1318552929-13341-22-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39151 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1JNIqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2011 04:46:08 -0400
In-Reply-To: <1318552929-13341-22-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>

On Fri, Oct 14, 2011 at 3:41 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:

> (nab: Fix up minor compile breakage)
Am I late for comment?

> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c

> =C2=A0static int chap_string_to_hex(unsigned char *dst, unsigned char=
 *src, int len)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 int i, j =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 int j =3D DIV_ROUND_UP(len, 2);
>
> - =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < len; i +=3D 2) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dst[j++] =3D (unsi=
gned char) chap_asciihex_to_binaryhex(&src[i]);
> - =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 hex2bin(dst, src, len);
len in this case should be j. That's why in broken version it called
length. hex2bin accepts length in bytes to convert.

--=20
With Best Regards,
Andy Shevchenko
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
