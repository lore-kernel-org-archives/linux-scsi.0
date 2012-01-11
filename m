From: adam radford <aradford@gmail.com>
Subject: Re: [patch 2/6] drivers/scsi/megaraid.c: fix sparse warnings
Date: Tue, 10 Jan 2012 17:18:45 -0800
Message-ID: <CAHtARFFWhGpFDZ51JsSHQsXs02i4Pu4x4YUfM37JxvYLucH5Dg@mail.gmail.com>
References: <20120110234230.58C9F20012E@hpza10.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53216 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab2AKBSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 20:18:47 -0500
Received: by werm1 with SMTP id m1so161238wer.19
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2012 17:18:45 -0800 (PST)
In-Reply-To: <20120110234230.58C9F20012E@hpza10.eem.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, rdunlap@xenotime.net, megaraidlinux@lsi.com, viro@zeniv.linux.org.uk

On Tue, Jan 10, 2012 at 3:42 PM,  <akpm@linux-foundation.org> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> Subject: drivers/scsi/megaraid.c: fix sparse warnings
>
> Fix sparse warnings of right shift bigger than source value size:
>
> drivers/scsi/megaraid.c:311:65: warning: right shift by bigger than s=
ource value
> drivers/scsi/megaraid.c:313:65: warning: right shift by bigger than s=
ource value
> drivers/scsi/megaraid.c:317:67: warning: right shift by bigger than s=
ource value
> drivers/scsi/megaraid.c:319:67: warning: right shift by bigger than s=
ource value
>
> Patch suggestion from email by Al Viro:
>
> "Since both are claimed to be strings, I really suspect that this >> =
8 is
> misspelled >> 4 and they have a character followed by pair of two-dig=
it
> packed decimals in there..."
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> =A0drivers/scsi/megaraid.c | =A0 =A08 ++++----
> =A01 file changed, 4 insertions(+), 4 deletions(-)
>
> diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-w=
arnings drivers/scsi/megaraid.c
> --- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warni=
ngs
> +++ a/drivers/scsi/megaraid.c
> @@ -310,15 +310,15 @@ mega_query_adapter(adapter_t *adapter)
> =A0 =A0 =A0 =A0if (adapter->product_info.subsysvid =3D=3D HP_SUBSYS_V=
ID) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sprintf (adapter->fw_version, "%c%d%d.=
%d%d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 adapter->product_info=
=2Efw_version[2],
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0adapter->product_inf=
o.fw_version[1] >> 8,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0adapter->product_inf=
o.fw_version[1] >> 4,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 adapter->product_info=
=2Efw_version[1] & 0x0f,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0adapter->product_inf=
o.fw_version[0] >> 8,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0adapter->product_inf=
o.fw_version[0] >> 4,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 adapter->product_info=
=2Efw_version[0] & 0x0f);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sprintf (adapter->bios_version, "%c%d%=
d.%d%d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 adapter->product_info=
=2Ebios_version[2],
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0adapter->product_inf=
o.bios_version[1] >> 8,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0adapter->product_inf=
o.bios_version[1] >> 4,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 adapter->product_info=
=2Ebios_version[1] & 0x0f,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0adapter->product_inf=
o.bios_version[0] >> 8,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0adapter->product_inf=
o.bios_version[0] >> 4,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 adapter->product_info=
=2Ebios_version[0] & 0x0f);
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(adapter->fw_version,

After a huge hunt, I was able to locate a single parallel scsi board
that this driver works with, however it has LSI firmware on it.  I am
unable to find the HP firmware for my board, which this code change
affects.  Additionally, checking hp.com for firmware for my controller
was unsuccessful.

Changing the driver version string for HP firmware on this board in
_any way_ other than what was intended will affect the following code
in the driver that does firmware string matching:

        if ((subsysvid =3D=3D HP_SUBSYS_VID) &&
            ((subsysid =3D=3D 0x60E7) || (subsysid =3D=3D 0x60E8))) {
                /*
                 * which firmware
                 */
                if (!strcmp(adapter->fw_version, "H01.07") ||
                    !strcmp(adapter->fw_version, "H01.08") ||
                    !strcmp(adapter->fw_version, "H01.09") ) {
                        printk(KERN_WARNING
                                "megaraid: Firmware H.01.07, "
                                "H.01.08, and H.01.09 on 1M/2M "
                                "controllers\n"
                                "megaraid: do not support 64 bit "
                                "addressing.\nmegaraid: DISABLING "
                                "64 bit support.\n");
                        adapter->flag &=3D ~BOARD_64BIT;
                }
        }

Since I have no HP firmware on one of these boards, and I can see that
altering the firmware string will alter the behvior of the above code
WRT setting/clearing BOARD_64BIT in the adapter->flag field, I have to
NACK this patch.  I hope we can live with the sparse warning since I
have no way to test this.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
