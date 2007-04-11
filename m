From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/5] Do an agent reset on error recovery.
Date: Wed, 11 Apr 2007 02:18:58 +0200
Message-ID: <461C2972.9060505@s5r6.in-berlin.de>
References: <1176243080579-git-send-email-krh@redhat.com> <11762430853030-git-send-email-krh@redhat.com> <11762430863671-git-send-email-krh@redhat.com> <11762430863077-git-send-email-krh@redhat.com> <461C1D11.7070003@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42971 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030632AbXDKATK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2007 20:19:10 -0400
In-Reply-To: <461C1D11.7070003@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

I wrote:
> Kristian H=F8gsberg wrote:
>> Also, implement the .eh_host_reset_handler callback instead of
>> .eh_abort_handler since that's what we're actually doing.
>=20
> You reset the target port (or specifically, the fetch agent acting on
> that target port).  But the .eh_host_reset_handler is to "ask [the] h=
ost
> adapter to reset itself".
=2E..
> But theoretic semantics aside:  Check drivers/scsi/scsi_error.c for w=
hat
> comes after one or another hostt->eh_ handler was called.  Do you wan=
t
> the subsequent call to scsi_report_bus_reset()?  Probably not.  But
> perhaps you want what comes after hostt->eh_device_reset_handler was =
called.

BTW, as you probably know there are different ways to (try to) bring an
SBP-2 target back to reason.  A while ago someone posted an extended
abort/reset scheme but I still haven't looked into it in detail and
tested it for its practical effects.
http://me.in-berlin.de/~s5r6/linux1394/work-in-progress/sbp2-scsi-abort=
-and-reset-of-non-responding-devices.patch
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D-- -=3D-=3D=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
