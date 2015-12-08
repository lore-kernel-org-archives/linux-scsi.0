From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/20] qla2xxx: Wait for all conflicts before ack'ing
 PLOGI
Date: Tue, 8 Dec 2015 17:00:25 +0100
Message-ID: <5666FE99.9020505@suse.de>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-8-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1449535747-2850-8-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/08/2015 01:48 AM, Himanshu Madhani wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
>=20
> Until now ack'ing of a new PLOGI has only been delayed if there
> was an existing session for the same WWN. Ack was released when
> the session deletion completed.
>=20
> If there was another WWN session with the same fc_id/loop_id pair
> (aka "conflicting session"), PLOGI was still ack'ed immediately.
> This potentially caused a problem when old session deletion logged
> fc_id/loop_id out of FW after new session has been established.
>=20
> Two work-arounds were attempted before:
> 1. Dropping PLOGIs until conflicting session goes away.
> 2. Detecting initiator being logged out of FW and issuing LOGO
> to force re-login.
>=20
> This patch introduces proper solution to the problem where PLOGI
> is held until either existing session with same WWN or any
> conflicting session goes away. Mechanism supports one session holding
> two PLOGI acks as well as one PLOGI ack being held by many sessions.
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
