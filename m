From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2 10/16] scsi: change FC drivers to use
	'struct bsg_job'
Date: Thu, 13 Oct 2016 13:44:16 +0200
Message-ID: <9272451a-f559-d6ea-56c4-f97cdf2210ca@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <b83569be0885a6cd79b24d6f8fb6dd25531e9384.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <b83569be0885a6cd79b24d6f8fb6dd25531e9384.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "open list:S390 ZFCP DRIVER" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dick Kennedy <dick.kennedy-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Sudarsana Kalluru <sudarsana.kalluru-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Anil Gurumurthy <anil.gurumurthy-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:FCOE SUBSYSTEM (libfc, libfcoe, fcoe)" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, James Smart <james.smart-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmKsTnJN9+BGXg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> Change FC drivers to use 'struct bsg_job' from bsg-lib.h instead of 'stru=
ct
> fc_bsg_job' from scsi_transport_fc.h and remove 'struct fc_bsg_job'.
> =

> Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> ---
>  drivers/s390/scsi/zfcp_ext.h     |  4 +--
>  drivers/s390/scsi/zfcp_fc.c      | 15 ++++----
>  drivers/scsi/bfa/bfad_bsg.c      | 10 +++---
>  drivers/scsi/bfa/bfad_im.h       |  4 +--
>  drivers/scsi/ibmvscsi/ibmvfc.c   |  9 ++---
>  drivers/scsi/libfc/fc_lport.c    | 10 +++---
>  drivers/scsi/lpfc/lpfc_bsg.c     | 74 ++++++++++++++++++++--------------=
------
>  drivers/scsi/lpfc/lpfc_crtn.h    |  4 +--
>  drivers/scsi/qla2xxx/qla_bsg.c   | 61 +++++++++++++++++----------------
>  drivers/scsi/qla2xxx/qla_def.h   |  2 +-
>  drivers/scsi/qla2xxx/qla_gbl.h   |  4 +--
>  drivers/scsi/qla2xxx/qla_iocb.c  |  8 ++---
>  drivers/scsi/qla2xxx/qla_isr.c   |  6 ++--
>  drivers/scsi/qla2xxx/qla_mr.c    |  5 +--
>  drivers/scsi/scsi_transport_fc.c | 20 +++++------
>  include/scsi/libfc.h             |  2 +-
>  include/scsi/scsi_transport_fc.h | 63 ++++++++++------------------------
>  17 files changed, 138 insertions(+), 163 deletions(-)
> =

Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare-l3A5Bk7waGM@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
