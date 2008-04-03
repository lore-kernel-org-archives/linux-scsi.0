From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mptsas and ioc0: ERRORs
Date: Thu, 03 Apr 2008 09:01:48 -0500
Message-ID: <1207231308.3048.14.camel@localhost.localdomain>
References: <20080331150434.a3fb336b.taeuber@bbaw.de>
	 <20080403123107.71d82746.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51303 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587AbYDCOBw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 10:01:52 -0400
In-Reply-To: <20080403123107.71d82746.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars =?ISO-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>


On Thu, 2008-04-03 at 12:31 +0200, Lars T=C3=A4uber wrote:
> OK, I understand. Being ignored means having asked at the wrong place=
=2E
> Can someone give me a hint where to ask instead?

Actually, LSI support might be better.  This:

> Mar 28 21:45:37 monosan kernel: mptscsih: ioc0: attempting task abort=
! (sc=3Dffff8100395bd1c0)
> Mar 28 21:45:48 monosan kernel: mptbase: Initiating ioc0 recovery
> Mar 28 21:45:48 monosan kernel: mptbase: ioc0: WARNING - IOC is in FA=
ULT state!!!
> Mar 28 21:45:51 monosan kernel: mptbase: ioc0: Recovered from IOC FAU=
LT

Indicates some type of firmware problem on the card (ioc fault means
fault in the firmware engine).

This:

> Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received a mf=
 that was already freed
> Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=3D838=
0 req_idx_MR=3D8380 mf=3Dffff81007db02900 mr=3D0000000000000000 sc=3D00=
00000000000000

Indicates a rendezvous failure between the ioc firmware and the driver.
The firmware is sending a response to a task that the driver thinks it
previously sent.

The problem for us is that while the driver is open source, it's really
just a translator for the on board firmware engine.  If the firmware
engine is truly the cause of these faults, there's not much anyone
except LSI can do to help.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
