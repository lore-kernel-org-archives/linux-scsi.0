From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: libiscsi: Use scsi helper to set information descriptor
Date: Wed, 4 May 2016 14:45:54 +0300
Message-ID: <20160504114554.GA8805@mwanda>
References: <20160413131425.GA9719@mwanda>
 <570E5D54.8070303@grimberg.me>
 <20160413163053.GD4247@mwanda>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBDIZTUWNWICRB7GBU64QKGQEVT2RUWQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20160413163053.GD4247@mwanda>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

You saw the bug in the end right?

  1112  u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
  1113                               enum iser_data_dir cmd_dir, sector_t *sector)
                                                                           ^^^^^^
The caller assumes sector is initialized on error.

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

But we have an error path where it's not initialized.

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
  1158  }

regards,
dan carpenter

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
