From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [SCSI] qla2xxx: Enhancements to support ISPFx00.
Date: Fri, 15 Apr 2016 16:29:01 +0000
Message-ID: <D33664A2.417AD%gmalavali@qlogic.org>
References: <20160413123933.GA14575@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0102.outbound.protection.outlook.com ([207.46.100.102]:60512
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751917AbcDORCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 13:02:55 -0400
In-Reply-To: <20160413123933.GA14575@mwanda>
Content-Language: en-US
Content-ID: <6ADF42AD00C3B347BD5D73B2EE1F6FCC@namprd11.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



On 4/13/16, 5:39 AM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:

>Hello Giridhar Malavali,
>
>The patch 8ae6d9c7eb10: "[SCSI] qla2xxx: Enhancements to support
>ISPFx00." from Mar 28, 2013, leads to the following static checker
>warning:
>
>	drivers/scsi/qla2xxx/qla_mr.c:2264 qlafx00_ioctl_iosb_entry()
>	error: uninitialized symbol 'res'.

Dan,

We will rework the patch and post it. Thanks for bringing this to our
attention.=20

=8B Giri


>
>drivers/scsi/qla2xxx/qla_mr.c
>  2210          struct srb_iocb *iocb_job;
>  2211          int res;
>                    ^^^
>  2212          struct qla_mt_iocb_rsp_fx00 fstatus;
>  2213          uint8_t *fw_sts_ptr;
>  2214 =20
>  2215          sp =3D qla2x00_get_sp_from_handle(vha, func, req, pkt)=
;
>  2216          if (!sp)
>  2217                  return;
>  2218 =20
>  2219          if (sp->type =3D=3D SRB_FXIOCB_DCMD) {
>  2220                  iocb_job =3D &sp->u.iocb_cmd;
>  2221                  iocb_job->u.fxiocb.seq_number =3D pkt->seq_no;
>  2222                  iocb_job->u.fxiocb.fw_flags =3D pkt->fw_iotcl_=
flags;
>  2223                  iocb_job->u.fxiocb.result =3D pkt->status;
>  2224                  if (iocb_job->u.fxiocb.flags &
>SRB_FXDISC_RSP_DWRD_VALID)
>  2225                          iocb_job->u.fxiocb.req_data =3D
>  2226                              pkt->dataword_r;
>
>res isn't set on this path.
>
>  2227          } else {
>  2228                  bsg_job =3D sp->u.bsg_job;
>  2229 =20
>  2230                  memset(&fstatus, 0, sizeof(struct
>qla_mt_iocb_rsp_fx00));
>  2231 =20
>  2232                  fstatus.reserved_1 =3D pkt->reserved_0;
>  2233                  fstatus.func_type =3D pkt->comp_func_num;
>  2234                  fstatus.ioctl_flags =3D pkt->fw_iotcl_flags;
>  2235                  fstatus.ioctl_data =3D pkt->dataword_r;
>  2236                  fstatus.adapid =3D pkt->adapid;
>  2237                  fstatus.reserved_2 =3D pkt->dataword_r_extra;
>  2238                  fstatus.res_count =3D pkt->residuallen;
>  2239                  fstatus.status =3D pkt->status;
>  2240                  fstatus.seq_number =3D pkt->seq_no;
>  2241                  memcpy(fstatus.reserved_3,
>  2242                      pkt->reserved_2, 20 * sizeof(uint8_t));
>  2243 =20
>  2244                  fw_sts_ptr =3D ((uint8_t *)bsg_job->req->sense=
) +
>  2245                      sizeof(struct fc_bsg_reply);
>  2246 =20
>  2247                  memcpy(fw_sts_ptr, (uint8_t *)&fstatus,
>  2248                      sizeof(struct qla_mt_iocb_rsp_fx00));
>  2249                  bsg_job->reply_len =3D sizeof(struct fc_bsg_re=
ply) +
>  2250                          sizeof(struct qla_mt_iocb_rsp_fx00) +
>sizeof(uint8_t);
>  2251 =20
>  2252                  ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
>  2253                      sp->fcport->vha, 0x5080,
>  2254                      (uint8_t *)pkt, sizeof(struct
>ioctl_iocb_entry_fx00));
>  2255 =20
>  2256                  ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
>  2257                      sp->fcport->vha, 0x5074,
>  2258                      (uint8_t *)fw_sts_ptr, sizeof(struct
>qla_mt_iocb_rsp_fx00));
>  2259 =20
>  2260                  res =3D bsg_job->reply->result =3D DID_OK << 1=
6;
>  2261                  bsg_job->reply->reply_payload_rcv_len =3D
>  2262                      bsg_job->reply_payload.payload_len;
>  2263          }
>  2264          sp->done(vha, sp, res);
>                                  ^^^
>Uninitialized.
>
>  2265  }
>
>regards,
>dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
