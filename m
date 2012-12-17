From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 05/10] fnic: fnic driver may hit BUG_ON on device reset
Date: Mon, 17 Dec 2012 11:24:54 +0000
Message-ID: <1355743494.2352.11.camel@dabdike.int.hansenpartnership.com>
References: <1355131299-3313-1-git-send-email-hiralpat@cisco.com>
	 <1355131299-3313-5-git-send-email-hiralpat@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51429 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab2LQLY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2012 06:24:58 -0500
In-Reply-To: <1355131299-3313-5-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>
Cc: linux-scsi@vger.kernel.org, Narsimhulu Musini <nmusini@cisco.com>

On Mon, 2012-12-10 at 01:21 -0800, Hiral Patel wrote:
> The issue was observed when LUN Reset is issued through IOCTL or sg_r=
eset
> utility.
>=20
> fnic driver issues LUN RESET to firmware. On successful completion of=
 device
> reset, driver cleans up all the pending IOs that were issued prior to=
 device
> reset. These pending IOs are expected to be in ABTS_PENDING state. Th=
is works
> fine, when the device reset operation resulted from midlayer, but not=
 when
> device reset was triggered from IOCTL path as the pending IOs were no=
t in
> ABTS_PENDING state. execution path hits panic if the pending IO is no=
t in
> ABTS_PENDING state.
>=20
> Changes:
> The fix replaces BUG_ON check in fnic_clean_pending_aborts() with mar=
king
> pending IOs as ABTS_PENDING if they were not in ABTS_PENDING state an=
d skips
> if they were already in ABTS_PENDING state. An extra check is added t=
o validate
> the abort status of the commands after a delay of 2 * E_D_TOV using a
> helper function. The helper function returns 1 if it finds any pendin=
g IO in
> ABTS_PENDING state, belong to the LUN on which device reset was issue=
d else 0.
> With this, device reset operation returns success only if the helper =
funciton
> returns 0, otherwise it returns failure.
>=20
> Other changes:
> - Removed code in fnic_clean_pending_aborts() that returns failure if=
 it finds
>   io_req NULL, instead of returning failure added code to continue wi=
th next io
> - Added device reset flags for debugging in fnic_terminate_rport_io,
>   fnic_rport_exch_reset, and fnic_clean_pending_aborts
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Hiral Patel <hiralpat@cisco.com>

This one doesn't compile:

drivers/scsi/fnic/fnic_scsi.c: In function =E2=80=98fnic_clean_pending_=
aborts=E2=80=99:
drivers/scsi/fnic/fnic_scsi.c:1654:23: error: =E2=80=98FNIC_DEV_RST_ISS=
UED=E2=80=99 undeclared (first use in this function)
drivers/scsi/fnic/fnic_scsi.c:1654:23: note: each undeclared identifier=
 is reported only once for each function it appears in
make[3]: *** [drivers/scsi/fnic/fnic_scsi.o] Error 1

And that's because FNIC_DEV_RST_ISSUED isn't #defined until PATCH 06/10

Please redo 05-10 this time making sure they compile in sequence in
order to maintain bisectability

Thanks,

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
