From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: myrs: Add Mylex RAID controller (SCSI interface)
Date: Tue, 13 Feb 2018 17:37:27 +0300
Message-ID: <20180213143727.GA21178@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbeBMOrl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 09:47:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: linux-scsi@vger.kernel.org

Hello Hannes Reinecke,

The patch 8a8606895947: "scsi: myrs: Add Mylex RAID controller (SCSI
interface)" from Jan 24, 2018, leads to the following static checker
warning:

	drivers/scsi/myrs.c:479 myrs_get_event()
	warn: right shifting more than type allows 16 vs 16

drivers/scsi/myrs.c
   461  static unsigned char
   462  myrs_get_event(myrs_hba *cs, unsigned short event_num,
                                     ^^^^^^^^^^^^^^^^^^^^^^^^

   463                 myrs_event *event_buf)
   464  {
   465          struct pci_dev *pdev = cs->pdev;
   466          dma_addr_t event_addr;
   467          myrs_cmdblk *cmd_blk = &cs->mcmd_blk;
   468          myrs_cmd_mbox *mbox = &cmd_blk->mbox;
   469          myrs_sgl *sgl;
   470          unsigned char status;
   471  
   472          event_addr = dma_map_single(&pdev->dev, event_buf,
   473                                      sizeof(myrs_event), DMA_FROM_DEVICE);
   474          if (dma_mapping_error(&pdev->dev, event_addr))
   475                  return DAC960_V2_AbnormalCompletion;
   476  
   477          mbox->GetEvent.opcode = DAC960_V2_IOCTL;
   478          mbox->GetEvent.dma_size = sizeof(myrs_event);
   479          mbox->GetEvent.evnum_upper = event_num >> 16;
                                             ^^^^^^^^^^^^^^^

This is always going to be zero.

   480          mbox->GetEvent.ctlr_num = 0;
   481          mbox->GetEvent.ioctl_opcode = DAC960_V2_GetEvent;
   482          mbox->GetEvent.evnum_lower = event_num & 0xFFFF;
   483          sgl = &mbox->GetEvent.dma_addr;
   484          sgl->sge[0].sge_addr = event_addr;
   485          sgl->sge[0].sge_count = mbox->GetEvent.dma_size;
   486          myrs_exec_cmd(cs, cmd_blk);
   487          status = cmd_blk->status;
   488          dma_unmap_single(&pdev->dev, event_addr,
   489                           sizeof(myrs_event), DMA_FROM_DEVICE);
   490  
   491          return status;
   492  }

This warning is probably a false positive which you can ignore but what
made me question it was looking at the caller:

drivers/scsi/myrs.c
  2222  static void myrs_monitor(struct work_struct *work)
  2223  {
  2224          myrs_hba *cs = container_of(work, myrs_hba, monitor_work.work);
  2225          struct Scsi_Host *shost = cs->host;
  2226          myrs_ctlr_info *info = cs->ctlr_info;
  2227          unsigned int epoch = cs->fwstat_buf->epoch;
  2228          unsigned long interval = MYRS_PRIMARY_MONITOR_INTERVAL;
  2229          unsigned char status;
  2230  
  2231          dev_dbg(&shost->shost_gendev, "monitor tick\n");
  2232  
  2233          status = myrs_get_fwstatus(cs);
  2234  
  2235          if (cs->needs_update) {
  2236                  cs->needs_update = false;
  2237                  mutex_lock(&cs->cinfo_mutex);
  2238                  status = myrs_get_ctlr_info(cs);
  2239                  mutex_unlock(&cs->cinfo_mutex);
  2240          }
  2241          if (cs->fwstat_buf->next_evseq - cs->next_evseq > 0) {
  2242                  status = myrs_get_event(cs, cs->next_evseq,
                                                    ^^^^^^^^^^^^^^
This is an int.

  2243                                          cs->event_buf);
  2244                  if (status == DAC960_V2_NormalCompletion) {
  2245                          myrs_log_event(cs, cs->event_buf);
  2246                          cs->next_evseq++;
                                ^^^^^^^^^^^^^^^^
And I guess this is where we set cs->next_evseq.

  2247                          interval = 1;
  2248                  }
  2249          }

regards,
dan carpenter
