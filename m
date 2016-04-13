From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] qla2xxx: Enhancements to support ISPFx00.
Date: Wed, 13 Apr 2016 15:39:33 +0300
Message-ID: <20160413123933.GA14575@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43201 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbcDMMjn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 08:39:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hello Giridhar Malavali,

The patch 8ae6d9c7eb10: "[SCSI] qla2xxx: Enhancements to support
ISPFx00." from Mar 28, 2013, leads to the following static checker
warning:

	drivers/scsi/qla2xxx/qla_mr.c:2264 qlafx00_ioctl_iosb_entry()
	error: uninitialized symbol 'res'.

drivers/scsi/qla2xxx/qla_mr.c
  2210          struct srb_iocb *iocb_job;
  2211          int res;
                    ^^^
  2212          struct qla_mt_iocb_rsp_fx00 fstatus;
  2213          uint8_t *fw_sts_ptr;
  2214  
  2215          sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
  2216          if (!sp)
  2217                  return;
  2218  
  2219          if (sp->type == SRB_FXIOCB_DCMD) {
  2220                  iocb_job = &sp->u.iocb_cmd;
  2221                  iocb_job->u.fxiocb.seq_number = pkt->seq_no;
  2222                  iocb_job->u.fxiocb.fw_flags = pkt->fw_iotcl_flags;
  2223                  iocb_job->u.fxiocb.result = pkt->status;
  2224                  if (iocb_job->u.fxiocb.flags & SRB_FXDISC_RSP_DWRD_VALID)
  2225                          iocb_job->u.fxiocb.req_data =
  2226                              pkt->dataword_r;

res isn't set on this path.

  2227          } else {
  2228                  bsg_job = sp->u.bsg_job;
  2229  
  2230                  memset(&fstatus, 0, sizeof(struct qla_mt_iocb_rsp_fx00));
  2231  
  2232                  fstatus.reserved_1 = pkt->reserved_0;
  2233                  fstatus.func_type = pkt->comp_func_num;
  2234                  fstatus.ioctl_flags = pkt->fw_iotcl_flags;
  2235                  fstatus.ioctl_data = pkt->dataword_r;
  2236                  fstatus.adapid = pkt->adapid;
  2237                  fstatus.reserved_2 = pkt->dataword_r_extra;
  2238                  fstatus.res_count = pkt->residuallen;
  2239                  fstatus.status = pkt->status;
  2240                  fstatus.seq_number = pkt->seq_no;
  2241                  memcpy(fstatus.reserved_3,
  2242                      pkt->reserved_2, 20 * sizeof(uint8_t));
  2243  
  2244                  fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
  2245                      sizeof(struct fc_bsg_reply);
  2246  
  2247                  memcpy(fw_sts_ptr, (uint8_t *)&fstatus,
  2248                      sizeof(struct qla_mt_iocb_rsp_fx00));
  2249                  bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
  2250                          sizeof(struct qla_mt_iocb_rsp_fx00) + sizeof(uint8_t);
  2251  
  2252                  ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
  2253                      sp->fcport->vha, 0x5080,
  2254                      (uint8_t *)pkt, sizeof(struct ioctl_iocb_entry_fx00));
  2255  
  2256                  ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
  2257                      sp->fcport->vha, 0x5074,
  2258                      (uint8_t *)fw_sts_ptr, sizeof(struct qla_mt_iocb_rsp_fx00));
  2259  
  2260                  res = bsg_job->reply->result = DID_OK << 16;
  2261                  bsg_job->reply->reply_payload_rcv_len =
  2262                      bsg_job->reply_payload.payload_len;
  2263          }
  2264          sp->done(vha, sp, res);
                                  ^^^
Uninitialized.

  2265  }

regards,
dan carpenter
