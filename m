From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/17] lpfc: Added throttle logging support.
Date: Thu, 17 Dec 2015 09:14:51 +0100
Message-ID: <56726EFB.5060707@suse.de>
References: <5671efba.8C/kxNA2eqfImskd%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbbLQIOw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:14:52 -0500
In-Reply-To: <5671efba.8C/kxNA2eqfImskd%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:11 AM, James Smart wrote:
>
> Implemented a throttle on error logging.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc.h         |  5 +++
>   drivers/scsi/lpfc/lpfc_attr.c    | 18 +++++++++++
>   drivers/scsi/lpfc/lpfc_crtn.h    |  1 +
>   drivers/scsi/lpfc/lpfc_disc.h    | 11 +++++++
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 23 +++++++++++++
>   drivers/scsi/lpfc/lpfc_init.c    | 70 +++++++++++++++++++++++++++++=
+++++++++++
>   drivers/scsi/lpfc/lpfc_logmsg.h  | 40 +++++++++++++++++++++++
>   drivers/scsi/lpfc/lpfc_scsi.c    | 41 ++++++++++++++++-------
>   drivers/scsi/lpfc/lpfc_sli.c     |  7 ++++
>   9 files changed, 205 insertions(+), 11 deletions(-)
>
Weeellll ... that stuff doesn't really belong into the driver.

_If_ that really is an issue it should be moved into a generic=20
helper, as other drivers will have the same problem.
There also have been quite some discussions at KS about how to=20
handle high-volume logging traffic; also systemd implements its own=20
handling, too.

So it really needs to be discussed separately, and not implemented=20
within a driver.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
