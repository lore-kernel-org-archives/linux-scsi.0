From: =?windows-1252?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] scsi: int overflow in st_ioctl()
Date: Tue, 17 Dec 2013 19:53:52 +0200
Message-ID: <F1B567DD-C322-4BA7-BFEA-E7C4B1F82697@kolumbus.fi>
References: <1387291383-25126-1-git-send-email-xuyongjiande@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:58845 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3LQRx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 12:53:59 -0500
In-Reply-To: <1387291383-25126-1-git-send-email-xuyongjiande@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xuyongjiande@gmail.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 17.12.2013, at 16.43, Yongjian Xu xuyongjiande@gmail.com wrote:

> From: Yongjian Xu <xuyongjiande@gmail.com>
>=20
> mtc.mt_count comes from user-space.
> int overflow may occur:
> mtc.mt_count++;
> mtc.mt_count=97;

I agree that this is a problem. However, it seems that there is also an=
other problem: the SPACE command uses a 24-bit count field and this ove=
rflows far below INT_MAX. Should the count in MTFSF etc. be limited to =
(2<<24-2)? This would make the checks you suggest unnecessary. (-2 so t=
hat the behavior does not depend on whether we are at file mark or not.=
)

I am a bit hesitant with this suggestion because someone may use count =
INT_MAX to space to the end of the tape. This probably succeeds now but=
 after the fix it would return an error.

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
