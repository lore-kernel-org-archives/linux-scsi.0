From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH] ips: fix data buffer accessors conversion bug
Date: Tue, 19 Feb 2008 04:29:44 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F439A58D04@ADPE2K703.adaptec.com>
References: <20080219170154J.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:48796 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYBSM3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2008 07:29:47 -0500
In-Reply-To: <20080219170154J.tomof@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "lnxninja@linux.vnet.ibm.com" <lnxninja@linux.vnet.ibm.com>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>

ACK

Wonderful work Tom and Fujita-san!

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: FUJITA Tomonori [mailto:tomof@acm.org]
> Sent: Tuesday, February 19, 2008 3:02 AM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@HansenPartnership.com; Salyzyn, Mark;
> lnxninja@linux.vnet.ibm.com; fujita.tomonori@lab.ntt.co.jp
> Subject: [PATCH] ips: fix data buffer accessors conversion bug
>
> There is one more bug in ips. I think that this needs to go to
> scsi-rc-fixes, 2.6.24-stable, and 2.6.23-stable though we might rarely
> hit this bug.
>
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Tue, 19 Feb 2008 16:03:47 +0900
> Subject: [PATCH] ips: fix data buffer accessors conversion bug
>
> This fixes a bug that can't handle a passthru command with more than
> two sg entries.
>
> Big thanks to Tim Pepper for debugging the problem.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> Cc: Salyzyn, Mark <Mark_Salyzyn@adaptec.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/ips.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index bb152fb..7ed568f 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -1576,7 +1576,7 @@ ips_make_passthru(ips_ha_t *ha, struct
> scsi_cmnd *SC, ips_scb_t *scb, int intr)
>         METHOD_TRACE("ips_make_passthru", 1);
>
>          scsi_for_each_sg(SC, sg, scsi_sg_count(SC), i)
> -                length += sg[i].length;
> +               length += sg->length;
>
>         if (length < sizeof (ips_passthru_t)) {
>                 /* wrong size */
> --
> 1.5.3.7
>
>
