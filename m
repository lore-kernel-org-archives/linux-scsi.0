From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/20] qla2xxx: Delete session if initiator is gone from
 FW
Date: Tue, 8 Dec 2015 16:58:01 +0100
Message-ID: <5666FE09.5010000@suse.de>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-7-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665AbbLHP6E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 10:58:04 -0500
In-Reply-To: <1449535747-2850-7-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 12/08/2015 01:48 AM, Himanshu Madhani wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
>=20
> 1. Initiator A is logged in with fc_id(1)/loop_id(1)
> 2. Initiator A re-logs in with fc_id(2)/loop_id(2)
> 3. Part of old session deletion async logoout for 1/1 is queued
> 4. Initiator B logs in with fc_id(1)/loop_id(1), starts
>    passing data and creates session.
> 5. Async logo from 3 is processed by DPC and sent to FW
>=20
> Now initiator B has the session but is logged out from FW.
>=20
> This condition is detected first with CTIO error 29 at which
> point we should delete current session. During session
> deletion we will send LOGO to initiator to force re-login.
>=20
> Under rare circumstances initiator might be logged out of FW,
> not have driver session, but still think it's logged in.
> E.g. the above sequence plus session deletion due to re-config.
> Incoming commands will fail to create local session because
> initiator is not found in FW. In this case we also issue LOGO
> to initiator to force him re-login.
>=20
> Finally this patch fixes exchange leak when commands where
> received in logged out state. In this case loop_id must be
> set to FFFF when corresponding exchange is terminated. The
> patch modifies exchange termination to always use FFFF,
> since in certain scenarios it's impossible to tell whether
> command was received in logged in or logged out state.
>=20
> Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
> Acked-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
