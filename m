From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] qla2xxx: Avoid that issuing a LIP triggers a kernel
 crash
Date: Mon, 30 Jan 2017 17:11:17 +0000
Message-ID: <1485796263.2669.1.camel@sandisk.com>
References: <1485389226-18009-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0051.outbound.protection.outlook.com ([104.47.41.51]:55776
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750786AbdA3RLZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 12:11:25 -0500
In-Reply-To: <1485389226-18009-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <1402CCB61F644549ABA176AA0C5C5245@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>

On Wed, 2017-01-25 at 22:07 -0200, Mauricio Faria de Oliveira wrote:
> Avoid that issuing a LIP as follows:
>=20
>   find /sys -name 'issue_lip'|while read f; do echo 1 > $f; done
>=20
> triggers the following:
>=20
> BUG: unable to handle kernel NULL pointer dereference at (null)
> Call Trace:
>  qla2x00_abort_all_cmds+0xed/0x140 [qla2xxx]
>  qla2x00_abort_isp_cleanup+0x1e3/0x280 [qla2xxx]
>  qla2x00_abort_isp+0xef/0x690 [qla2xxx]
>  qla2x00_do_dpc+0x36c/0x880 [qla2xxx]
>  kthread+0x10c/0x140

A smaller patch would have been sufficient, namely:

drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0a000ecf0881..40660461a4b5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1616,7 +1616,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 				/* Don't abort commands in adapter during EEH
 				 * recovery as it's not accessible/responding.
 				 */
-				if (!ha->flags.eeh_busy) {
+				if (!ha->flags.eeh_busy &&=A0GET_CMD_SP(sp)) {
 					/* Get a reference to the sp and drop the lock.
 					 * The reference ensures this sp->done() call
 					 * - and not the call in qla2xxx_eh_abort() -

Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
