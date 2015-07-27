From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/8] qla2xxx: delay plogi/prli ack until existing sessions
 are deleted
Date: Mon, 27 Jul 2015 10:14:04 +0200
Message-ID: <55B5E84C.4070102@suse.de>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com> <1436904049-27707-4-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436904049-27707-4-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/14/2015 10:00 PM, Himanshu Madhani wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
>=20
> - keep qla_tgt_sess object on the session list until it's freed
>=20
> - modify use of sess->deleted flag to differentiate delayed
>   session deletion that can be cancelled from irreversible one:
>   QLA_SESS_DELETION_PENDING vs QLA_SESS_DELETION_IN_PROGRESS
>=20
> - during IN_PROGRESS deletion all newly arrived commands and TMRs wil=
l
>   be rejected, existing commands and TMRs will be terminated when
>   given by the core to the fabric or simply dropped if session logout
>   has already happened (logout terminates all existing exchanges)
>=20
> - new PLOGI will initiate deletion of the following sessions
>   (unless deletion is already IN_PROGRESS):
>   - with the same port_name (with logout)
>   - different port_name, different loop_id but the same port_id
>     (with logout)
>   - different port_name, different port_id, but the same loop_id
>     (without logout)
>=20
> - additionally each new PLOGI will store imm notify iocb in the
>   same port_name session being deleted. When deletion process
>   completes this iocb will be acked. Only the most recent PLOGI
>   iocb is stored. The older ones will be terminated when replaced.
>=20
> - new PRLI will initiate deletion of the following sessions
>   (unless deletion is already IN_PROGRESS):
>   - different port_name, different port_id, but the same loop_id
>    (without logout)
>=20
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
> Acked-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
