From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC 1/2] scsi: Provide mechanism for SCSI layer to poll for
 LLDD.
Date: Thu, 16 Mar 2017 22:27:24 +0000
Message-ID: <1489703231.2574.20.camel@sandisk.com>
References: <20170316214048.20481-1-himanshu.madhani@cavium.com>
         <20170316214048.20481-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:27585 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754537AbdCPWj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2017 18:39:58 -0400
In-Reply-To: <20170316214048.20481-2-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <BF7CEF2EA030174C86508000B48B1898@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "darren.trapp@cavium.com" <darren.trapp@cavium.com>

On Thu, 2017-03-16 at 14:40 -0700, Himanshu Madhani wrote:
> +static int
> +scsi_poll(struct blk_mq_hw_ctx *hctx, unsigned int tag)
> +
> +{
> +        struct Scsi_Host *shost =3D hctx->driver_data;
> +        struct request *req;
> +        struct scsi_cmnd *cmd;
> +
> +        req =3D blk_mq_tag_to_rq(shost->tag_set.tags[hctx->queue_num], t=
ag);
> +        if (!req)
> +                return 0;
> +
> +        cmd =3D blk_mq_rq_to_pdu(req);
> +	if (!cmd)
> +		return 0;
> +
> +	if (shost->hostt->poll_queue)
> +		return(shost->hostt->poll_queue(shost, cmd));
> +	else return 0;
> +}

What will happen if the request with tag 'tag' is completed after the block
layer decided to call this function and before this function had the chance
to call blk_mq_tag_to_rq()? Will this trigger a kernel crash? Also, please
format patches properly. This is what checkpatch reports for this patch:

ERROR: code indent should use tabs where possible
#244: FILE: drivers/scsi/scsi_lib.c:2161:
+=A0=A0=A0=A0=A0=A0=A0=A0struct Scsi_Host *shost =3D hctx->driver_data;$

WARNING: please, no spaces at the start of a line
#244: FILE: drivers/scsi/scsi_lib.c:2161:
+=A0=A0=A0=A0=A0=A0=A0=A0struct Scsi_Host *shost =3D hctx->driver_data;$

ERROR: code indent should use tabs where possible
#245: FILE: drivers/scsi/scsi_lib.c:2162:
+=A0=A0=A0=A0=A0=A0=A0=A0struct request *req;$

WARNING: please, no spaces at the start of a line
#245: FILE: drivers/scsi/scsi_lib.c:2162:
+=A0=A0=A0=A0=A0=A0=A0=A0struct request *req;$

ERROR: code indent should use tabs where possible
#246: FILE: drivers/scsi/scsi_lib.c:2163:
+=A0=A0=A0=A0=A0=A0=A0=A0struct scsi_cmnd *cmd;$

WARNING: please, no spaces at the start of a line
#246: FILE: drivers/scsi/scsi_lib.c:2163:
+=A0=A0=A0=A0=A0=A0=A0=A0struct scsi_cmnd *cmd;$

ERROR: code indent should use tabs where possible
#248: FILE: drivers/scsi/scsi_lib.c:2165:
+=A0=A0=A0=A0=A0=A0=A0=A0req =3D blk_mq_tag_to_rq(shost->tag_set.tags[hctx-=
>queue_num], tag);$

WARNING: please, no spaces at the start of a line
#248: FILE: drivers/scsi/scsi_lib.c:2165:
+=A0=A0=A0=A0=A0=A0=A0=A0req =3D blk_mq_tag_to_rq(shost->tag_set.tags[hctx-=
>queue_num], tag);$

ERROR: code indent should use tabs where possible
#249: FILE: drivers/scsi/scsi_lib.c:2166:
+=A0=A0=A0=A0=A0=A0=A0=A0if (!req)$

WARNING: please, no spaces at the start of a line
#249: FILE: drivers/scsi/scsi_lib.c:2166:
+=A0=A0=A0=A0=A0=A0=A0=A0if (!req)$

ERROR: code indent should use tabs where possible
#250: FILE: drivers/scsi/scsi_lib.c:2167:
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;$

WARNING: please, no spaces at the start of a line
#250: FILE: drivers/scsi/scsi_lib.c:2167:
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;$

ERROR: code indent should use tabs where possible
#252: FILE: drivers/scsi/scsi_lib.c:2169:
+=A0=A0=A0=A0=A0=A0=A0=A0cmd =3D blk_mq_rq_to_pdu(req);$

WARNING: please, no spaces at the start of a line
#252: FILE: drivers/scsi/scsi_lib.c:2169:
+=A0=A0=A0=A0=A0=A0=A0=A0cmd =3D blk_mq_rq_to_pdu(req);$

ERROR: return is not a function, parentheses are not required
#257: FILE: drivers/scsi/scsi_lib.c:2174:
+		return(shost->hostt->poll_queue(shost, cmd));

ERROR: trailing statements should be on next line
#258: FILE: drivers/scsi/scsi_lib.c:2175:
+	else return 0;

WARNING: line over 80 characters
#262: FILE: drivers/scsi/scsi_lib.c:2179:
+__scsi_init_hctx(struct blk_mq_hw_ctx *hctx, struct Scsi_Host *shost, unsi=
gned int hctx_idx)

WARNING: Unnecessary space before function pointer name
#306: FILE: include/scsi/scsi_host.h:139:
+	int (* poll_queue)(struct Scsi_Host *, struct scsi_cmnd *);

ERROR: space prohibited after that '*' (ctx:BxW)
#306: FILE: include/scsi/scsi_host.h:139:
+	int (* poll_queue)(struct Scsi_Host *, struct scsi_cmnd *);
=A0	=A0=A0=A0=A0=A0^
Thanks,

Bart.=
