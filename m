From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 07/10] aacraid: Fix AIF triggered IOP_RESET
Date: Thu, 03 Dec 2015 09:03:32 +0100
Message-ID: <1449129812.3311.3.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1449050432.3103.52.camel@suse.de>
	 <198D06D448A18D4E93F08FB849C4E39D7D1EE83A@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675AbbLCIDe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 03:03:34 -0500
In-Reply-To: <198D06D448A18D4E93F08FB849C4E39D7D1EE83A@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Santosh Akula <Santosh.Akula@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Rich Bono <Rich.Bono@pmcs.com>

Hi Raghava,

On Wed, 2015-12-02 at 22:29 +0000, Raghava Aditya Renukunta wrote:
> Hello Johannes,
>=20
> > -----Original Message-----

[...]

> Originally the problem was that dev->adapter_shutdown was set after t=
he
> Shutdown command was sent to the controller, leading to a race
> condition=C2=A0=C2=A0If after the controller was shut down and before
> =C2=A0dev->adapter_shutdown=C2=A0=C2=A0was set , the driver received=C2=
=A0=C2=A0a AIF
> =C2=A0command from management tool , it=C2=A0=C2=A0would still be sen=
t to the=20
> controller in aac_cfg_ioctl() leading to a=C2=A0=C2=A0IOP_RESET.
>=20
> A fix would=C2=A0=C2=A0be to set dev->adapter_shutdown at the very=20
> beginning of aac_send_shutdown().


That's what I though as well

	Johannes


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
