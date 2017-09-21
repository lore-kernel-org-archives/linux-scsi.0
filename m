From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Thu, 21 Sep 2017 16:19:59 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5B8CD1FA@avsrvexchmbx2.microsemi.net>
References: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0071.outbound.protection.outlook.com ([104.47.42.71]:62605
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751636AbdIUQUe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Sep 2017 12:20:34 -0400
In-Reply-To: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "dougmill@linux.vnet.ibm.com" <dougmill@linux.vnet.ibm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>

> From: Guilherme G. Piccoli [mailto:gpiccoli@linux.vnet.ibm.com]
> Sent: Tuesday, September 19, 2017 9:12 AM
> To: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>; linux-
> scsi@vger.kernel.org
> Cc: gpiccoli@linux.vnet.ibm.com; Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; Dave Carroll
> <david.carroll@microsemi.com>; brking@linux.vnet.ibm.com;
> dougmill@linux.vnet.ibm.com; stable@vger.kernel.org
> Subject: [PATCH] scsi: aacraid: Add a small delay after IOP reset
>=20
> Commit 0e9973ed3382 ("scsi: aacraid: Add periodic checks to see IOP reset
> status") changed the way driver checks if a reset succeeded. Now, after a=
n IOP
> reset, aacraid immediately start polling a register to verify the reset i=
s complete.
>=20
> This behavior cause regressions on the reset path in PowerPC (at least).
> Since the delay after the IOP reset was removed by the aforementioned pat=
ch,
> the fact driver just starts to read a register instantly after the reset =
was issued
> (by writing in another register) "corrupts" the reset procedure, which en=
ds up
> failing all the time.
>=20
> The issue highly impacted kdump on PowerPC, since on kdump path we
> proactively issue a reset in adapter (through the reset_devices kernel
> parameter).
>=20
> This patch (re-)adds a delay right after IOP reset is issued. Empirically=
 we
> measured that 3 seconds is enough, but for safety reasons we delay for 5s=
 (and
> since it was 30s before, 5s is still a small amount).
>=20
> For reference, without this patch we observe the following messages on kd=
ump
> kernel boot process:
>=20
>   [ 76.294] aacraid 0003:01:00.0: IOP reset failed
>   [ 76.294] aacraid 0003:01:00.0: ARC Reset attempt failed
>   [ 86.524] aacraid 0003:01:00.0: adapter kernel panic'd ff.
>   [ 86.524] aacraid 0003:01:00.0: Controller reset type is 3
>   [ 86.524] aacraid 0003:01:00.0: Issuing IOP reset
>   [146.534] aacraid 0003:01:00.0: IOP reset failed
>   [146.534] aacraid 0003:01:00.0: ARC Reset attempt failed
>=20
> Fixes: 0e9973ed3382 ("scsi: aacraid: Add periodic checks to see IOP reset
> status")
> Cc: stable@vger.kernel.org # v4.13+
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> ---
Acked-by: Dave Carroll <david.carroll@microsemi.com>
