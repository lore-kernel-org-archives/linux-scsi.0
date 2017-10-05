From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 4/9] qla2xxx: don't break the bsg-lib abstractions
Date: Thu, 5 Oct 2017 16:58:48 +0000
Message-ID: <A918CA8B-A8C6-4CC5-8619-8649810ADEAE@cavium.com>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0060.outbound.protection.outlook.com ([104.47.33.60]:38857
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751335AbdJEQ6v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Oct 2017 12:58:51 -0400
In-Reply-To: <20171003104845.10417-5-hch@lst.de>
Content-Language: en-US
Content-ID: <EE1D822B205529449EEC2280F96C801D@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>


> On Oct 3, 2017, at 3:48 AM, Christoph Hellwig <hch@lst.de> wrote:
>=20
> Always use bsg_job->reply instead of scsi_req(bsg_job->req)->sense), as
> they always point to the same memory.
>=20
> Never set scsi_req(bsg_job->req)->result and we'll set that value through
> bsg_job_done.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c | 10 ++++------
> drivers/scsi/qla2xxx/qla_isr.c | 12 +++---------
> drivers/scsi/qla2xxx/qla_mr.c  |  3 +--
> 3 files changed, 8 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 2ea0ef93f5cb..92a951fcd076 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -919,9 +919,9 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
>=20
> 	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply) +
> 	    sizeof(response) + sizeof(uint8_t);
> -	fw_sts_ptr =3D ((uint8_t *)scsi_req(bsg_job->req)->sense) +
> -	    sizeof(struct fc_bsg_reply);
> -	memcpy(fw_sts_ptr, response, sizeof(response));
> +	fw_sts_ptr =3D bsg_job->reply + sizeof(struct fc_bsg_reply);
> +	memcpy(bsg_job->reply + sizeof(struct fc_bsg_reply), response,
> +			sizeof(response));
> 	fw_sts_ptr +=3D sizeof(response);
> 	*fw_sts_ptr =3D command_sent;
>=20
> @@ -2554,13 +2554,11 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
> 						ql_log(ql_log_warn, vha, 0x7089,
> 						    "mbx abort_command "
> 						    "failed.\n");
> -						scsi_req(bsg_job->req)->result =3D
> 						bsg_reply->result =3D -EIO;
> 					} else {
> 						ql_dbg(ql_dbg_user, vha, 0x708a,
> 						    "mbx abort_command "
> 						    "success.\n");
> -						scsi_req(bsg_job->req)->result =3D
> 						bsg_reply->result =3D 0;
> 					}
> 					spin_lock_irqsave(&ha->hardware_lock, flags);
> @@ -2571,7 +2569,7 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
> 	}
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
> -	scsi_req(bsg_job->req)->result =3D bsg_reply->result =3D -ENXIO;
> +	 bsg_reply->result =3D -ENXIO;
> 	return 0;
>=20
> done:
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 9d9668aac6f6..886c7085fada 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1543,7 +1543,6 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct r=
eq_que *req,
> 	struct fc_bsg_reply *bsg_reply;
> 	uint16_t comp_status;
> 	uint32_t fw_status[3];
> -	uint8_t* fw_sts_ptr;
> 	int res;
>=20
> 	sp =3D qla2x00_get_sp_from_handle(vha, func, req, pkt);
> @@ -1604,11 +1603,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct =
req_que *req,
> 			    type, sp->handle, comp_status, fw_status[1], fw_status[2],
> 			    le16_to_cpu(((struct els_sts_entry_24xx *)
> 				pkt)->total_byte_count));
> -			fw_sts_ptr =3D ((uint8_t*)scsi_req(bsg_job->req)->sense) +
> -				sizeof(struct fc_bsg_reply);
> -			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
> -		}
> -		else {
> +		} else {
> 			ql_dbg(ql_dbg_user, vha, 0x5040,
> 			    "ELS-CT pass-through-%s error hdl=3D%x comp_status-status=3D0x%x "
> 			    "error subcode 1=3D0x%x error subcode 2=3D0x%x.\n",
> @@ -1619,10 +1614,9 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct =
req_que *req,
> 				    pkt)->error_subcode_2));
> 			res =3D DID_ERROR << 16;
> 			bsg_reply->reply_payload_rcv_len =3D 0;
> -			fw_sts_ptr =3D ((uint8_t*)scsi_req(bsg_job->req)->sense) +
> -					sizeof(struct fc_bsg_reply);
> -			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
> 		}
> +		memcpy(bsg_job->reply + sizeof(struct fc_bsg_reply),
> +				fw_status, sizeof(fw_status));
> 		ql_dump_buffer(ql_dbg_user + ql_dbg_buffer, vha, 0x5056,
> 				(uint8_t *)pkt, sizeof(*pkt));
> 	}
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.=
c
> index e23a3d4c36f3..d5da3981cefe 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -2245,8 +2245,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, stru=
ct req_que *req,
> 		memcpy(fstatus.reserved_3,
> 		    pkt->reserved_2, 20 * sizeof(uint8_t));
>=20
> -		fw_sts_ptr =3D ((uint8_t *)scsi_req(bsg_job->req)->sense) +
> -		    sizeof(struct fc_bsg_reply);
> +		fw_sts_ptr =3D bsg_job->reply + sizeof(struct fc_bsg_reply);
>=20
> 		memcpy(fw_sts_ptr, (uint8_t *)&fstatus,
> 		    sizeof(struct qla_mt_iocb_rsp_fx00));
> --=20
> 2.14.1
>=20

Looks Good.

Reviewed-By: Himanshu Madhani <himanshu.madhani@cavium.com>
Tested-By: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
