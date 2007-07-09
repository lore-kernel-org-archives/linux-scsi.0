From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 2/2] blk request timeout handler:
Date: Mon, 9 Jul 2007 10:18:05 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01B8E0CC@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7C233.F7DFB118"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:51325 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbXGIOSI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 10:18:08 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org
Cc: axboe@suse.de

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7C233.F7DFB118
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

What ever happened to the following (admittedly snipped up) patch from a
year ago, was there a reason this initiative was dropped? If so, please
state what I missed?

The attached aacraid specific portion of the following patch is against
current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org=20
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Mike Christie
> Sent: Tuesday, July 25, 2006 5:40 AM
> To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;=20
> axboe@suse.de
> Subject: [PATCH 2/2] blk request timeout handler:
>=20
> Convert scsi to the block layer request timer code. The block layer
> functions are exactly the ones that used to live in scsi, so the
> conversion is mostly renames and removal of code from scsi.
>=20
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>=20
> diff -aurp linux-2.6.18-rc2/drivers/scsi/aacraid/aachba.c=20
> linux-2.6.18-rc2.blkeh/drivers/scsi/aacraid/aachba.c
> --- linux-2.6.18-rc2/drivers/scsi/aacraid/aachba.c=09
> 2006-07-15 17:53:08.000000000 -0400
> +++ linux-2.6.18-rc2.blkeh/drivers/scsi/aacraid/aachba.c=09
> 2006-07-25 05:13:04.000000000 -0400
> @@ -2113,7 +2113,7 @@ static int aac_send_srb_fib(struct scsi_
>  	srbcmd->id   =3D cpu_to_le32(scmd_id(scsicmd));
>  	srbcmd->lun      =3D cpu_to_le32(scsicmd->device->lun);
>  	srbcmd->flags    =3D cpu_to_le32(flag);
> -	timeout =3D scsicmd->timeout_per_command/HZ;
> +	timeout =3D scsicmd->request->timeout/HZ;
>  	if(timeout =3D=3D 0){
>  		timeout =3D 1;
>  	}
. . .
> diff -aurp linux-2.6.18-rc2/drivers/scsi/ips.c=20
> linux-2.6.18-rc2.blkeh/drivers/scsi/ips.c
> --- linux-2.6.18-rc2/drivers/scsi/ips.c	2006-07-15=20
> 17:53:08.000000000 -0400
> +++ linux-2.6.18-rc2.blkeh/drivers/scsi/ips.c	2006-07-25=20
> 04:47:04.000000000 -0400
> @@ -4030,7 +4030,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t *=20
>  		scb->cmd.dcdb.segment_4G =3D 0;
>  		scb->cmd.dcdb.enhanced_sg =3D 0;
> =20
> -		TimeOut =3D scb->scsi_cmd->timeout_per_command;
> +		TimeOut =3D scb->scsi_cmd->request->timeout;
> =20
>  		if (ha->subsys->param[4] & 0x00100000) {=09
> /* If NEW Tape DCDB is Supported */
>  			if (!scb->sg_len) {
. . .
> diff -aurp linux-2.6.18-rc2/include/scsi/scsi_cmnd.h=20
> linux-2.6.18-rc2.blkeh/include/scsi/scsi_cmnd.h
> --- linux-2.6.18-rc2/include/scsi/scsi_cmnd.h	2006-07-15=20
> 17:53:08.000000000 -0400
> +++ linux-2.6.18-rc2.blkeh/include/scsi/scsi_cmnd.h=09
> 2006-07-25 03:30:46.000000000 -0400
> @@ -55,7 +55,6 @@ struct scsi_cmnd {
> =20
>  	int retries;
>  	int allowed;
> -	int timeout_per_command;
> =20
>  	unsigned char cmd_len;
>  	unsigned char old_cmd_len;
> @@ -67,7 +66,6 @@ struct scsi_cmnd {
>  	unsigned char cmnd[MAX_COMMAND_SIZE];
>  	unsigned request_bufflen;	/* Actual request size */
> =20
> -	struct timer_list eh_timeout;	/* Used to time out the=20
> command. */
>  	void *request_buffer;		/* Actual requested buffer */
> =20
>  	/* These elements define the operation we ultimately=20
> want to perform */
> @@ -145,7 +143,6 @@ extern struct scsi_cmnd *scsi_get_comman
>  extern void scsi_put_command(struct scsi_cmnd *);
>  extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
>  extern void scsi_finish_command(struct scsi_cmnd *cmd);
> -extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
> =20
>  extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int=20
> sg_count,
>  				 size_t *offset, size_t *len);
> diff -aurp linux-2.6.18-rc2/include/scsi/scsi_device.h=20
> linux-2.6.18-rc2.blkeh/include/scsi/scsi_device.h
> --- linux-2.6.18-rc2/include/scsi/scsi_device.h=09
> 2006-07-15 17:53:08.000000000 -0400
> +++ linux-2.6.18-rc2.blkeh/include/scsi/scsi_device.h=09
> 2006-07-25 03:30:46.000000000 -0400
> @@ -203,7 +203,6 @@ extern struct scsi_device *__scsi_add_de
>  extern int scsi_add_device(struct Scsi_Host *host, uint channel,
>  			   uint target, uint lun);
>  extern void scsi_remove_device(struct scsi_device *);
> -extern int scsi_device_cancel(struct scsi_device *, int);
> =20
>  extern int scsi_device_get(struct scsi_device *);
>  extern void scsi_device_put(struct scsi_device *);
> diff -aurp linux-2.6.18-rc2/include/scsi/scsi_host.h=20
> linux-2.6.18-rc2.blkeh/include/scsi/scsi_host.h
> --- linux-2.6.18-rc2/include/scsi/scsi_host.h	2006-07-15=20
> 17:53:08.000000000 -0400
> +++ linux-2.6.18-rc2.blkeh/include/scsi/scsi_host.h=09
> 2006-07-25 03:30:46.000000000 -0400
> @@ -34,13 +34,6 @@ struct scsi_transport_template;
>  #define DISABLE_CLUSTERING 0
>  #define ENABLE_CLUSTERING 1
> =20
> -enum scsi_eh_timer_return {
> -	EH_NOT_HANDLED,
> -	EH_HANDLED,
> -	EH_RESET_TIMER,
> -};
> -
> -
>  struct scsi_host_template {
>  	struct module *module;
>  	const char *name;
> diff -aurp linux-2.6.18-rc2/include/scsi/scsi_transport.h=20
> linux-2.6.18-rc2.blkeh/include/scsi/scsi_transport.h
> --- linux-2.6.18-rc2/include/scsi/scsi_transport.h=09
> 2006-07-15 17:53:08.000000000 -0400
> +++ linux-2.6.18-rc2.blkeh/include/scsi/scsi_transport.h=09
> 2006-07-25 03:30:46.000000000 -0400
> @@ -21,6 +21,7 @@
>  #define SCSI_TRANSPORT_H
> =20
>  #include <linux/transport_class.h>
> +#include <linux/blkdev.h>
>  #include <scsi/scsi_host.h>
> =20
>  struct scsi_transport_template {
> @@ -63,7 +64,7 @@ struct scsi_transport_template {
>  	 *			begin counting again
>  	 * EH_NOT_HANDLED	Begin normal error recovery
>  	 */
> -	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
> +	enum blk_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
>  };
> =20
>  #define transport_class_to_shost(tc) \

------_=_NextPart_001_01C7C233.F7DFB118
Content-Type: application/octet-stream;
	name="aacraid_blktimeout.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_blktimeout.patch
Content-Disposition: attachment;
	filename="aacraid_blktimeout.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDctMDkgMTA6MDE6MDEuNzk5Mjk4OTk5IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDctMDkgMTA6MTE6MDYuMjgyNzIyNjU3IC0wNDAwCkBAIC0xMDMyLDYg
KzEwMzIsNiBAQAogCXNyYmNtZC0+aWQgICAgICAgPSBjcHVfdG9fbGUzMihzY21kX2lkKGNtZCkp
OwogCXNyYmNtZC0+bHVuICAgICAgPSBjcHVfdG9fbGUzMihjbWQtPmRldmljZS0+bHVuKTsKIAlz
cmJjbWQtPmZsYWdzICAgID0gY3B1X3RvX2xlMzIoZmxhZyk7Ci0JdGltZW91dCA9IGNtZC0+dGlt
ZW91dF9wZXJfY29tbWFuZC9IWjsKKwl0aW1lb3V0ID0gY21kLT5yZXF1ZXN0LT50aW1lb3V0L0ha
OwogCWlmICh0aW1lb3V0ID09IDApCiAJCXRpbWVvdXQgPSAxOwo=

------_=_NextPart_001_01C7C233.F7DFB118--
