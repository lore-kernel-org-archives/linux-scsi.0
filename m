From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug #2] arcmsr: forever loop in arcmsr_polling_hbc_ccbdone()
Date: Fri, 7 Feb 2014 16:01:23 +0300
Message-ID: <20140207130123.GC6971@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37867 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaBGNB2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 08:01:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org

Hello Nick Cheng,

The patch cdd3cb156f19: "[SCSI] SCSI: Support Type C RAID controller"
from Jul 13, 2010, leads to the following static checker warning:

	drivers/scsi/arcmsr/arcmsr_hba.c:2474 arcmsr_polling_hbc_ccbdone()
	warn: this loop depends on readl() succeeding

drivers/scsi/arcmsr/arcmsr_hba.c
  2432          poll_count++;
  2433          while (1) {
  2434                  if ((readl(&reg->host_int_status) & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
                             ^^^^^
readl() returns 0xffffffff on failure (hotplug).

  2435                          if (poll_ccb_done) {
  2436                                  rtn = SUCCESS;
  2437                                  break;
  2438                          } else {
  2439                                  msleep(25);
  2440                                  if (poll_count > 100) {

We break out of the loop if we time out but this condition can only be
reached if the readl() succeeds.  Probably the intent was to time out
regardless of the readl() return value.

  2441                                          rtn = FAILED;
  2442                                          break;
  2443                                  }
  2444                                  goto polling_hbc_ccb_retry;
  2445                          }
  2446                  }
  2447                  flag_ccb = readl(&reg->outbound_queueport_low);
  2448                  ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
  2449                  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);/*frame must be 32 bytes aligned*/
  2450                  pCCB = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
  2451                  poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
  2452                  /* check ifcommand done with no error*/
  2453                  if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
  2454                          if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
  2455                                  printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
  2456                                          " poll command abort successfully \n"
  2457                                          , acb->host->host_no
  2458                                          , pCCB->pcmd->device->id
  2459                                          , pCCB->pcmd->device->lun
  2460                                          , pCCB);
  2461                                          pCCB->pcmd->result = DID_ABORT << 16;
  2462                                          arcmsr_ccb_complete(pCCB);
  2463                                  continue;
  2464                          }
  2465                          printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
  2466                                  " command done ccb = '0x%p'"
  2467                                  "ccboutstandingcount = %d \n"
  2468                                  , acb->host->host_no
  2469                                  , pCCB
  2470                                  , atomic_read(&acb->ccboutstandingcount));
  2471                          continue;
  2472                  }
  2473                  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
  2474                  arcmsr_report_ccb_state(acb, pCCB, error);
  2475          }
  2476          return rtn;

regards,
dan carpenter
