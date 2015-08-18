From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: Fix NULL pointer dereference in runtime PM
Date: Tue, 18 Aug 2015 10:12:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1508181010490.1828-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1508171059320.1706-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52675 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751762AbbHROMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2015 10:12:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.1508171059320.1706-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ilan Cohen <ilanco@gmail.com>, Joe Lawrence <joe.lawrence@stratus.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 17 Aug 2015, Alan Stern wrote:

> The routines in scsi_rpm.c assume that if a runtime-PM callback is
> invoked for a SCSI device, it can only mean that the device's driver=20
> has asked the block layer to handle the runtime power management (by
> calling blk_pm_runtime_init(), which among other things sets q->dev).
>=20
> However, this assumption turns out to be wrong for things like the se=
s
> driver.  Normally ses devices are not allowed to do runtime PM, but
> userspace can override this setting.  If this happens, the kernel get=
s
> a NULL pointer dereference when blk_post_runtime_resume() tries to us=
e
> the uninitialized q->dev pointer.
>=20
> This patch fixes the problem by calling the block layer's runtime-PM
> routines only if the device's driver really does have a runtime-PM
> callback routine.  Since ses doesn't define any such callbacks, the
> crash won't occur.
>=20
> This fixes Bugzilla #101371.
>=20
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: Stanis=C5=82aw Pitucha <viraptor@gmail.com>
> Reported-by: Ilan Cohen <ilanco@gmail.com>
> Tested-by: Ilan Cohen <ilanco@gmail.com>

James:

I forgot to include a

CC: <stable@vger.kernel.org>

tag.  Can you add that in when you merge this patch?  Thanks.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
