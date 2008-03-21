From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 21:57:20 +0100
Message-ID: <1206133040.24338.30.camel@lov.site>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>
	 <47E3EC67.4050404@garzik.org> <1206124426.24338.20.camel@lov.site>
	 <47E41DD3.2040602@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.179]:50627 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702AbYCUU5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Mar 2008 16:57:35 -0400
In-Reply-To: <47E41DD3.2040602@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Fri, 2008-03-21 at 16:42 -0400, Jeff Garzik wrote:
> Kay Sievers wrote:
> > On Fri, 2008-03-21 at 13:12 -0400, Jeff Garzik wrote:
> >> Linux Kernel Mailing List wrote:


> >> When 285e9670 was updated for the scsi_evt_* interface, it should =
have=20
> >> initialized the supported_events mask.
> >>
> >> And that is the fix -- initialize supported_events according to sr=
/sd's=20
> >> needs, and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3=
a01d0)=20
> >> as obviously broken.
> >=20
> > You mean adding a new flag? As every device will "support" these ev=
ents.
>=20
> Does every device attached to every controller wish to fire these eve=
nts?
>=20
> If so, then that wants new flag, yes.

Yes, =EF=BB=BFa new flag sounds good. Every device that detects a media=
 change
should send such event, so userspace can possibly update it's
representation of the volume.
That way, userspace can switch to a single generic event, regardless if
the device is periodically polled, or supports AN.

Thanks,
Kay

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
