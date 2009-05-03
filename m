From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] set CONFIG_SCSI_MULTI_LUN by default and update help
Date: Sun, 03 May 2009 10:17:39 -0500
Message-ID: <1241363859.5596.51.camel@mulgrave.int.hansenpartnership.com>
References: <49FDA2CA.4040601@tremplin-utc.net>
	 <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com>
	 <49FDB36E.7010402@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49243 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952AbZECPRk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 11:17:40 -0400
In-Reply-To: <49FDB36E.7010402@tremplin-utc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On Sun, 2009-05-03 at 17:08 +0200, =C3=89ric Piel wrote:
> James Bottomley schreef:
> > On Sun, 2009-05-03 at 15:57 +0200, =C3=89ric Piel wrote:
> :
> >=20
> > Actually, I'd really rather not alter the default value of this set=
ting.
> > Multi-lun is rapidly becoming obsolete: any modern devices conformi=
ng to
> > SCSI-3 use REPORT LUNS instead of doing LUN scanning, which gets us=
 out
> > of the issue.  Conversely, the ancient devices which rely on correc=
tly
> > setting this are more likely to get upset about any change in the
> > balance.
> Yes, I understand. Would like me to resend the patch without the chan=
ge
> on the default value. IMHO, it provides a better wording.

I'm not opposed in principle to the update ... however it might perhaps
need to point out that modern devices (conforming to SCSI-3 and up) wil=
l
ignore this setting.

This also brings up (again) the problem of USB lying about the SCSI
conformance level.  Your changer could well have reported SCSI-3 or
higher and be quite capable of doing a report lun scan, but the
scsiglue.c:216 fix to the scsi compliance level pushed it back down to
scsi-2 again.

> > In your case, just add the changer's inquiry strings with a
> > BLIST_FORCELUN.
> Where, into the usb-storage driver? I guess there is no usb device wh=
ich
> can get confused by this, so it should work fine as well :-)

It's not in the usb driver, it's in the inquiry string blacklist table
in scsi_devinfo.c

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
