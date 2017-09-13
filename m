From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] [SCSI] lpfc: NPIV: add NPIV support on top of SLI-3
Date: Wed, 13 Sep 2017 12:15:41 +0300
Message-ID: <20170913091541.xwhaqzr2ydogdgzx@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34190 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752050AbdIMJP7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 05:15:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

[ Really old patch... :/ - dan ]

Hello James Smart,

The patch 92d7f7b0cde3: "[SCSI] lpfc: NPIV: add NPIV support on top
of SLI-3" from Jun 17, 2007, leads to the following static checker
warning:

	drivers/scsi/lpfc/lpfc_els.c:6148 lpfc_els_rcv_rscn()
	error: buffer underflow 'vport->fc_rscn_id_list'

drivers/scsi/lpfc/lpfc_els.c
  6128          /* Indicate we are walking fc_rscn_id_list on this vport */
  6129          vport->fc_rscn_flush = 1;
  6130          spin_unlock_irq(shost->host_lock);
  6131          /* Get the array count after successfully have the token */
  6132          rscn_cnt = vport->fc_rscn_id_cnt;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We set rscn_cnt here.  rscn_cnt is an int.  Smatch thinks
vport->fc_rscn_id_cnt can be higher than INT_MAX which is not actually
possible but hopefully explains the warning message.  More analysis
below.

  6133          /* If we are already processing an RSCN, save the received
  6134           * RSCN payload buffer, cmdiocb->context2 to process later.
  6135           */
  6136          if (vport->fc_flag & (FC_RSCN_MODE | FC_NDISC_ACTIVE)) {
  6137                  lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
  6138                          "RCV RSCN defer:  did:x%x/ste:x%x flg:x%x",
  6139                          ndlp->nlp_DID, vport->port_state, ndlp->nlp_flag);
  6140  
  6141                  spin_lock_irq(shost->host_lock);
  6142                  vport->fc_flag |= FC_RSCN_DEFERRED;
  6143                  if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
On this path we check if it's invalid.

  6144                      !(vport->fc_flag & FC_RSCN_DISCOVERY)) {
  6145                          vport->fc_flag |= FC_RSCN_MODE;
  6146                          spin_unlock_irq(shost->host_lock);
  6147                          if (rscn_cnt) {
  6148                                  cmd = vport->fc_rscn_id_list[rscn_cnt-1]->virt;
  6149                                  length = be32_to_cpu(*cmd & ~ELS_CMD_MASK);
  6150                          }
  6151                          if ((rscn_cnt) &&
  6152                              (payload_len + length <= LPFC_BPL_SIZE)) {
  6153                                  *cmd &= ELS_CMD_MASK;
  6154                                  *cmd |= cpu_to_be32(payload_len + length);
  6155                                  memcpy(((uint8_t *)cmd) + length, lp,
  6156                                         payload_len);
  6157                          } else {
  6158                                  vport->fc_rscn_id_list[rscn_cnt] = pcmd;
  6159                                  vport->fc_rscn_id_cnt++;
                                        ^^^^^^^^^^^^^^^^^^^^^^^
It gets incremented here

  6160                                  /* If we zero, cmdiocb->context2, the calling
  6161                                   * routine will not try to free it.
  6162                                   */
  6163                                  cmdiocb->context2 = NULL;
  6164                          }
  6165                          /* Deferred RSCN */
  6166                          lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
  6167                                           "0235 Deferred RSCN "
  6168                                           "Data: x%x x%x x%x\n",
  6169                                           vport->fc_rscn_id_cnt, vport->fc_flag,
  6170                                           vport->port_state);
  6171                  } else {
  6172                          vport->fc_flag |= FC_RSCN_DISCOVERY;
  6173                          spin_unlock_irq(shost->host_lock);
  6174                          /* ReDiscovery RSCN */
  6175                          lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
  6176                                           "0234 ReDiscovery RSCN "
  6177                                           "Data: x%x x%x x%x\n",
  6178                                           vport->fc_rscn_id_cnt, vport->fc_flag,
  6179                                           vport->port_state);
  6180                  }
  6181                  /* Indicate we are done walking fc_rscn_id_list on this vport */
  6182                  vport->fc_rscn_flush = 0;
  6183                  /* Send back ACC */
  6184                  lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
  6185                  /* send RECOVERY event for ALL nodes that match RSCN payload */
  6186                  lpfc_rscn_recovery_check(vport);
  6187                  spin_lock_irq(shost->host_lock);
  6188                  vport->fc_flag &= ~FC_RSCN_DEFERRED;
  6189                  spin_unlock_irq(shost->host_lock);
  6190                  return 0;
  6191          }
  6192          lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
  6193                  "RCV RSCN:        did:x%x/ste:x%x flg:x%x",
  6194                  ndlp->nlp_DID, vport->port_state, ndlp->nlp_flag);
  6195  
  6196          spin_lock_irq(shost->host_lock);
  6197          vport->fc_flag |= FC_RSCN_MODE;
  6198          spin_unlock_irq(shost->host_lock);
  6199          vport->fc_rscn_id_list[vport->fc_rscn_id_cnt++] = pcmd;
                                       ^^^^^^^^^^^^^^^^^^^^^^^
But here we don't check here.  It feels like we should be checking on
this path as well.


  6200          /* Indicate we are done walking fc_rscn_id_list on this vport */
  6201          vport->fc_rscn_flush = 0;

regards,
dan carpenter
