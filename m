From: Hannes Reinecke <hare@suse.de>
Subject: Re: Fwd: Re: scsi_scan_host will hang up my system!
Date: Wed, 04 Oct 2006 09:04:02 +0200
Message-ID: <45235CE2.5080604@suse.de>
References: <20060920105845.48447.qmail@web18301.mail.tpe.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34241 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932383AbWJDHEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2006 03:04:04 -0400
In-Reply-To: <20060920105845.48447.qmail@web18301.mail.tpe.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: crazyrushstar@yahoo.com.tw
Cc: linux-scsi@vger.kernel.org

crazyrushstar@yahoo.com.tw wrote:
> I am still reading scsi_mid_low_api.txt file.
>=20
> Report my newly discovery.
> Trace to kernel code,function call to
> "blk_execute_rq(req->q, NULL, req, 1);" at scsi_lib.c
> It's too deep to trace.
>=20
> This function not response to my driver so that insmod
> stuck.
>=20
It looks as if you trigger a recursion in the block layer.
We've stumbled across this, too; it can happen if a driver returns
SCSI_MLQUEUE_HOST_BUSY errorneously. This can cause a really deep or
even infinite stack depth (as is triggers blk_requeue_request over and
over again).
Check for such a condition and make sure that it is _temporary_.
Otherwise use proper SCSI error codes (ie DID_NO_CONNECT) which do not
have this problem.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=C3=9Fe 5				+49 911 74053 688
90409 N=C3=BCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
