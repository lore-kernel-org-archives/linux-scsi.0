From: Joe Jin <joe.jin@oracle.com>
Subject: Re: [HELP]: qla2xxx driver reported Mid-layer underflow
Date: Mon, 30 Nov 2009 10:45:14 +0800
Message-ID: <20091130024514.GA6041@joejin-pc.cn.oracle.com>
References: <20091125133754.GA13439@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:57485 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZK3Cpp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 21:45:45 -0500
Content-Disposition: inline
In-Reply-To: <20091125133754.GA13439@joejin-pc.cn.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: gurudas.pai@oracle.com, kate.zhang@oracle.com, joe.jin@oracle.com, linux-scsi@vger.kernel.org

Hi Andrew,

A question about resid at function qla2x00_status_entry(), when @comp_status is
CS_DATA_UNDERRUN, will set @resid according to hw IS_FWI2_CAPABL(ha)(Line 1466),
when comp_status fall CS_COMPLETE|CS_QUEUE_FULL branch, will we add the check? 
add below code between line 1413 and line 1414:
              resid = IS_FWI2_CAPABLE(ha) ? fw_resid_len : resid_len;


1405         switch (comp_status) {
1406         case CS_COMPLETE:
1407         case CS_QUEUE_FULL:
1408                 if (scsi_status == 0) {
1409                         cp->result = DID_OK << 16;
1410                         break;
1411                 }
1412                 if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER)) {
1413                         resid = resid_len;
1414                         scsi_set_resid(cp, resid);
1415
1416                         if (!lscsi_status &&
1417                             ((unsigned)(scsi_bufflen(cp) - resid) <
1418                              cp->underflow)) {
1419                                 qla_printk(KERN_INFO, ha,
1420                                            "scsi(%ld:%d:%d:%d): Mid-layer underflow "
1421                                            "detected (%x of %x bytes)...returning "
1422                                            "error status.\n", vha->host_no,
1423                                            cp->device->channel, cp->device->id,
1424                                            cp->device->lun, resid,
1425                                            scsi_bufflen(cp));
1426
1427                                 cp->result = DID_ERROR << 16;
1428                                 break;
1429                         }
1430                 }
1431                 cp->result = DID_OK << 16 | lscsi_status;
1432
1433                 if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
1434                         DEBUG2(printk(KERN_INFO
1435                             "scsi(%ld): QUEUE FULL status detected "
1436                             "0x%x-0x%x.\n", vha->host_no, comp_status,
1437                             scsi_status));
1438
1439                         /* Adjust queue depth for all luns on the port. */
1440                         if (!ql2xqfulltracking)
1441                                 break;
1442                         fcport->last_queue_full = jiffies;
1443                         starget_for_each_device(cp->device->sdev_target,
1444                             fcport, qla2x00_adjust_sdev_qdepth_down);
1445                         break;
1446                 }
1447                 if (lscsi_status != SS_CHECK_CONDITION)
1448                         break;
1449
1450                 memset(cp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
1451                 if (!(scsi_status & SS_SENSE_LEN_VALID))
1452                         break;
1453
1454                 qla2x00_handle_sense(sp, sense_data, sense_len, rsp);
1455                 break;
1456
1457         case CS_DATA_UNDERRUN:
1458                 DEBUG2(printk(KERN_INFO
1459                     "scsi(%ld:%d:%d) UNDERRUN status detected 0x%x-0x%x. "
1460                     "resid=0x%x fw_resid=0x%x cdb=0x%x os_underflow=0x%x\n",
1461                     vha->host_no, cp->device->id, cp->device->lun, comp_status,
1462                     scsi_status, resid_len, fw_resid_len, cp->cmnd[0],
1463                     cp->underflow));
1464
1465                 /* Use F/W calculated residual length. */
1466                 resid = IS_FWI2_CAPABLE(ha) ? fw_resid_len : resid_len;
1467                 scsi_set_resid(cp, resid);



Thanks,
Joe



On 2009-11-25 21:37, Joe Jin wrote:
> Hi Andrew,
> 
> Recently we were ran some testing on QLogic "ISP2432-based 4Gb"(devid: 1077:2432),
> when do lots of I/O write operations, got below messages:
> 
> qla2xxx 0000:0c:00.1: scsi(1:0:0:1): Mid-layer underflow detected (4000 of 4000 bytes)...returning error status.
> 
> Driver information:
> 
> Driver version: 8.03.01.03.05.05-k which came from Redhat EL 5 latest(2.6.18-174)
> Firmware version: 4.04.09 (486)
> 
> Module load parameters:
> ql2xallocfwdump=1
> ql2xdevdiscgoldfw=0
> ql2xenablemsix=1
> ql2xextended_error_logging=0
> ql2xfdmienable=0
> ql2xloginretrycount=0
> ql2xlogintimeout=20
> ql2xmaxqdepth=32
> ql2xplogiabsentdevice=0
> ql2xqfullrampup=120
> ql2xqfulltracking=1
> qlport_down_retry=0
> 
> 
> I have added some debug printk at codes and found error reported
> at CS_COMPLETE/CS_QUEUE_FULL branch, and at the time, 
> comp_status = CS_COMPLETE, scsi_status = SS_RESIDUAL_UNDER.
> 
> >From QLogic document TroubleshootingGuide_23xxSeries.pdf p5-11, it pointed:
> 
>  ----------------------+---------------------------------------------------------
>  scsi(%ld): Mid-layer  | An underflow was detected. (%Id) indicates the QLogic
>  underflow detected (%x| HBA number. (%x of %x bytes) indicates the remaining
>  of %x bytes) wanted   | bytes of the total bytes, for example, 200 of 512. %x bytes
>  %x bytes...returning  | indicates the minimum number of expected bytes.
>  DID_ERROR status!\n   |
>  ----------------------+---------------------------------------------------------
> 
> Is that meant I could ignore it safety or could I understand this willl not impact the I/0 
> performance? If no, would you like to give me some advices?
> 
> Many thanks,
> Joe


