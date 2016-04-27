From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH 04/10] aacraid: Relinquish CPU during timeout wait
Date: Wed, 27 Apr 2016 11:31:09 +0200
Message-ID: <20160427093109.GH2820@c203.arch.suse.de>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
 <20160426063126.28402.85984.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbcD0JbM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 05:31:12 -0400
Content-Disposition: inline
In-Reply-To: <20160426063126.28402.85984.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com

On Mon, Apr 25, 2016 at 11:31:26PM -0700, Raghava Aditya Renukunta wrot=
e:
> aac_fib_send has a special function case for initial commands during
> driver initialization using wait < 0(pseudo sync mode). In this case,
> the command does not sleep but rather spins checking for timeout.This
> loop is calls cpu_relax() in an attempt to allow other processes/thre=
ads
> to use the CPU, but this function does not relinquish the CPU and so =
the
> command will hog the processor. This was observed in a KDUMP
> "crashkernel" and that prevented the "command thread" (which is
> responsible for completing the command from being timed out) from
> starting because it could not get the CPU.
>=20
> Fixed by replacing "cpu_relax()" call with "schedule()"
> Cc: stable@vger.kernel.org
>=20
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@micr=
osemi.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
