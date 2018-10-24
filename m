From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] SCSI/libiscsi: Add check_protection callback for
 transports
Date: Wed, 24 Oct 2018 10:32:16 +0300
Message-ID: <20181024073216.cmouje6zxmeyhdqc@kili.mountain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDIZTUWNWICRBCWAYDPAKGQEYPTEFEA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello Sagi Grimberg,

The patch 55e51eda4820: "SCSI/libiscsi: Add check_protection callback
for transports" from Mar 5, 2014, leads to the following static
checker warning:

	drivers/scsi/libiscsi.c:865 iscsi_scsi_cmd_rsp()
	error: uninitialized symbol 'sector'.

drivers/scsi/libiscsi.c
   833  static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
   834                                 struct iscsi_task *task, char *data,
   835                                 int datalen)
   836  {
   837          struct iscsi_scsi_rsp *rhdr = (struct iscsi_scsi_rsp *)hdr;
   838          struct iscsi_session *session = conn->session;
   839          struct scsi_cmnd *sc = task->sc;
   840  
   841          iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
   842          conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
   843  
   844          sc->result = (DID_OK << 16) | rhdr->cmd_status;
   845  
   846          if (task->protected) {
   847                  sector_t sector;
                        ^^^^^^^^^^^^^^^

   848                  u8 ascq;
   849  
   850                  /**
   851                   * Transports that didn't implement check_protection
   852                   * callback but still published T10-PI support to scsi-mid
   853                   * deserve this BUG_ON.
   854                   **/
   855                  BUG_ON(!session->tt->check_protection);
   856  
   857                  ascq = session->tt->check_protection(task, &sector);
                                                                   ^^^^^^^
This returns 0x1 - 0x3 on error.  Some error paths set sector but some
don't.

   858                  if (ascq) {
   859                          sc->result = DRIVER_SENSE << 24 |
   860                                       SAM_STAT_CHECK_CONDITION;
   861                          scsi_build_sense_buffer(1, sc->sense_buffer,
   862                                                  ILLEGAL_REQUEST, 0x10, ascq);
   863                          scsi_set_sense_information(sc->sense_buffer,
   864                                                     SCSI_SENSE_BUFFERSIZE,
   865                                                     sector);
   866                          goto out;
   867                  }
   868          }

The error check_protection() function ends up calling iser_check_task_pi_status()

drivers/infiniband/ulp/iser/iser_verbs.c 
  1112  u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
  1113                               enum iser_data_dir cmd_dir, sector_t *sector)
                                                                 ^^^^^^^^^^^^^^^^
  1114  {
  1115          struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
  1116          struct iser_fr_desc *desc = reg->mem_h;
  1117          unsigned long sector_size = iser_task->sc->device->sector_size;
  1118          struct ib_mr_status mr_status;
  1119          int ret;
  1120  
  1121          if (desc && desc->pi_ctx->sig_protected) {
  1122                  desc->pi_ctx->sig_protected = 0;
  1123                  ret = ib_check_mr_status(desc->pi_ctx->sig_mr,
  1124                                           IB_MR_CHECK_SIG_STATUS, &mr_status);
  1125                  if (ret) {
  1126                          pr_err("ib_check_mr_status failed, ret %d\n", ret);
  1127                          goto err;
                                ^^^^^^^^
"sector" not set on this error path.

  1128                  }
  1129  
  1130                  if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
  1131                          sector_t sector_off = mr_status.sig_err.sig_err_offset;
  1132  
  1133                          sector_div(sector_off, sector_size + 8);
  1134                          *sector = scsi_get_lba(iser_task->sc) + sector_off;
  1135  
  1136                          pr_err("PI error found type %d at sector %llx "
  1137                                 "expected %x vs actual %x\n",
  1138                                 mr_status.sig_err.err_type,
  1139                                 (unsigned long long)*sector,
  1140                                 mr_status.sig_err.expected,
  1141                                 mr_status.sig_err.actual);
  1142  
  1143                          switch (mr_status.sig_err.err_type) {
  1144                          case IB_SIG_BAD_GUARD:
  1145                                  return 0x1;
  1146                          case IB_SIG_BAD_REFTAG:
  1147                                  return 0x3;
  1148                          case IB_SIG_BAD_APPTAG:
  1149                                  return 0x2;
  1150                          }
  1151                  }
  1152          }
  1153  
  1154          return 0;
  1155  err:
  1156          /* Not alot we can do here, return ambiguous guard error */
  1157          return 0x1;
                ^^^^^^^^^^
  1158  }

regards,
dan carpenter

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
