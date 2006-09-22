From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: scsi_scan_host will hang up my system!
Date: Fri, 22 Sep 2006 13:11:04 +0200
Message-ID: <4513C4C8.2070606@s5r6.in-berlin.de>
References: <20060920050630.4431.qmail@web18302.mail.tpe.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:6296 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S932296AbWIVLPf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 07:15:35 -0400
In-Reply-To: <20060920050630.4431.qmail@web18302.mail.tpe.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: crazyrushstar@yahoo.com.tw
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Karen Shaeffer <shaeffer@neuralscape.com>

crazyrushstar@yahoo.com.tw wrote:
> --- Karen Shaeffer <shaeffer@neuralscape.com> =E8=AA=AA=EF=BC=9A
>> On Tue, Sep 19, 2006 at 09:48:46PM -0600, Matthew
>> Wilcox wrote:
>>> Documentation/scsi/scsi_mid_low_api.txt was of
>>> immense help to me.

This document is indeed essential for low-level driver development.
However it doesn't (can't) tell you how to avoid some types of deadlock=
s.

Crazyrushstar, I can't give specific advise about scsi_scan_host() sinc=
e
the code I'm maintaining (sbp2) doesn't use it. However I have some
basic suggestions:

 - Consider your driver a layer between Linux' SCSI core (higher level)
and the interconnect software/firmware/hardware, e.g. PCI layer (lower
level). Make sure that you first bring up the lower level, then the
higher level. Vice versa, bring down the higher level before the lower
level on driver shutdown.

 - AFAIU your driver and everything below it has to be fully able to
transfer commands, data and status before it calls scsi_scan_host().

 - Also keep the layer paradigm in mind when you design the locking in
your driver. Watch out for the host lock which the SCSI core will use o=
n
several occasions and which your driver may have to use on some
occasions. (The low-level driver I'm maintaining doesn't touch the host
lock.) A clearly layered design helps to avoid deadlocks.

 - Don't use the scsi_block_requests()/ scsi_unblock_requests() API.
(The code I'm maintaining is using these, and it is a nightmare because
it easily leads into deadlocks. I will rework that driver to not use
these calls anymore.) The scsi_block_requests()/ scsi_unblock_requests(=
)
API manipulates host state on a low level, subverting the SCSI core's
assumptions about host/ target/ LU states. This and similar
manipulations of host/ target/ LU state are better _not_ done in a SCSI
low-level driver.

=2E..
>> I also would purchase the applicable scsi standards.
>>=20
>> http://www.t10.org/

The drafts at http://www.t10.org/ftp/t10/drafts/ may suffice too, at
least to get started.

=2E..
> I have google out a link=20
> "http://www.mjmwired.net/kernel/Documentation/scsi/scsi_mid_low_api.t=
xt"
=2E..

"Documentation/" is a subdirectory of the Linux kernel source distribut=
ion.

Another essential resource are of course the sources themselves. Good
tools to browse the code are Cscope or KScope or LXR:
http://free-electrons.com/community/kernel/lxr

You certainly already read the sources in include/scsi/.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D- =3D--=3D =3D--=3D=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
