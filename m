From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Fri, 15 Jul 2005 23:44:41 +0200
Message-ID: <42D82E49.7090907@s5r6.in-berlin.de>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:9905 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261708AbVGOVpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2005 17:45:10 -0400
In-Reply-To: <20050715205741.GN13229@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Ben Collins <bcollins@debian.org>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com

Ben Collins wrote:
> On Fri, Jul 15, 2005 at 03:50:34PM -0300, Rog=E9rio Brito wrote:
>>I already tried this and things stopped working. :-( I put the dmesg =
log on
>><http://www.ime.usp.br/~rbrito/bug/> anyway.
>=20
> No, there are changes in the current rev of the repo. Are sure you tr=
ied
> the latest rev?

(The latest rev from linux1394.org includes the changed TYPE_RBC handli=
ng,
i.e. has it moved out of sbp2 into the scsi drivers, plus some further
cleanups. I.e. it is close to the code which caused Rog=E9rio's first f=
ailure
report at linux-kernel about the -mm tree.)

>>Any other things that I should try? Any printk's that I can add to he=
lp
>>debug this thing?

Rog=E9rio, try "modprobe ieee1394 disable_irm=3D1" again, of course bef=
ore
ohci1394 is loaded. Make sure that sd_mod was loaded.

If this does not help, enable scsi_print_command(...) and scsi_print_se=
nse(...)
in sbp2scsi_complete_command(), i.e. #define CONFIG_IEEE1394_SBP2_DEBUG=
 1
or 2 near the beginning of sbp2.c. I assume there won't be too much res=
ulting
SCSI traffic logged, so you could post it directly here to the lists.

Thanks,
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D-=3D -=3D=3D=3D -=3D=3D=3D=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
