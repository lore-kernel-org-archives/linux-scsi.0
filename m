From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Tue, 3 Apr 2012 10:28:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204031017110.1537-100000@iolanthe.rowland.org>
References: <664580.50344.qm@web100011.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39247 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753789Ab2DCO2h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Apr 2012 10:28:37 -0400
In-Reply-To: <664580.50344.qm@web100011.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 3 Apr 2012, Norman Diamond wrote:

> >> Wrong.=A0 We CAN try to read the last block that the bridge says e=
xists, to see if it really exists or not.=A0 (Well, only partly wrong.=A0=
 Maybe there really are some bridges that crash in that situation, but =
mine doesn't, and a broken driver still needs fixing.)
> >=20
> > Yes, there really are such bridges.=A0 You can find reports from pe=
ople complaining about them in the email archives.
>=20
> Wait.  Is there a bridge which overreports the last sector number by =
1, and which ALSO crashes when the host PC tries to read that supposed =
last sector number?

Yes.  Like I said before, you can find complaints about these things in=
=20
the mailing list archives.  However it's not clear whether the crashing=
=20
is the fault of the bridge itself or the drive it is attached to.

>  If so then we need a quirk for that doubly broken bridge.

That's what the existing quirk entries are there for.

> But otherwise, we can try to read the supposedly last sector number a=
nd figure out whether we have to subtract 1.

True enough, but we don't have any way to know which bridges do crash
and which don't other than trying it.  And you'll probably agree that
trial and error is not such a good idea in the cases where the bridge
does crash.

In the end, this gives us very little choice but to rely on the static=20
quirk entries.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
