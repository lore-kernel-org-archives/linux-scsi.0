From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60648] New: csiostor/csio_scsi.c: out of bounds access
Date: Mon, 29 Jul 2013 20:10:17 +0000
Message-ID: <bug-60648-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40738 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab3G2UKV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jul 2013 16:10:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 773A020372
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 20:10:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 497B320343
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 20:10:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60648

            Bug ID: 60648
           Summary: csiostor/csio_scsi.c: out of bounds access
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.11rc2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: mikko.rapeli@iki.fi
        Regression: No

Coverity id 751478 reports:

1581static inline void
1582csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
1583{
1584        struct scsi_cmnd *cmnd  = (struct scsi_cmnd *)csio_scsi_cmnd(req);
1585        struct csio_scsim *scm = csio_hw_to_scsim(hw);
1586        struct fcp_resp_with_ext *fcp_resp;
1587        struct fcp_resp_rsp_info *rsp_info;
1588        struct csio_dma_buf *dma_buf;
1589        uint8_t flags, scsi_status = 0;
1590        uint32_t host_status = DID_OK;
1591        uint32_t rsp_len = 0, sns_len = 0;
1592        struct csio_rnode *rn = (struct csio_rnode
*)(cmnd->device->hostdata);
1593
1594
        1. Switch case value "137"
1595        switch (req->wr_status) {
1596        case FW_HOSTERROR:
1597                if (unlikely(!csio_is_hw_ready(hw)))
1598                        return;
1599
1600                host_status = DID_ERROR;
1601                CSIO_INC_STATS(scm, n_hosterror);
1602
1603                break;
1604        case FW_SCSI_RSP_ERR:
/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
69        FW_SCSI_RSP_ERR         = 137,  /* */
1605                dma_buf = &req->dma_buf;
1606                fcp_resp = (struct fcp_resp_with_ext *)dma_buf->vaddr;
1607                rsp_info = (struct fcp_resp_rsp_info *)(fcp_resp + 1);
1608                flags = fcp_resp->resp.fr_flags;
1609                scsi_status = fcp_resp->resp.fr_status;
1610
        2. Condition "flags & 1", taking true branch
1611                if (flags & FCP_RSP_LEN_VAL) {
        3. Condition "0", taking false branch
1612                        rsp_len = be32_to_cpu(fcp_resp->ext.fr_rsp_len);
        4. Condition "rsp_len != 0", taking true branch
        5. cond_at_least: Checking "rsp_len != 0U" implies that the value of
"rsp_len" is at least 1 on the true branch.
        6. Condition "rsp_len != 4", taking true branch
        7. Condition "rsp_len != 8", taking false branch
        8. cond_const: Checking "rsp_len != 8U" implies that the value of
"rsp_len" is 8 on the false branch.
        9. Condition "rsp_info->rsp_code != FCP_TMF_CMPL", taking false branch
1613                        if ((rsp_len != 0 && rsp_len != 4 && rsp_len != 8)
||
1614                                (rsp_info->rsp_code != FCP_TMF_CMPL)) {
1615                                host_status = DID_ERROR;
1616                                goto out;
1617                        }
1618                }
1619
        10. Condition "flags & 2", taking true branch
        11. Condition "fcp_resp->ext.fr_sns_len", taking true branch
1620                if ((flags & FCP_SNS_LEN_VAL) && fcp_resp->ext.fr_sns_len)
{
        12. Condition "0", taking false branch
1621                        sns_len = be32_to_cpu(fcp_resp->ext.fr_sns_len);
        13. Condition "sns_len > 96", taking true branch
1622                        if (sns_len > SCSI_SENSE_BUFFERSIZE)
        14. assignment: Assigning: "sns_len" = "96U".
1623                                sns_len = SCSI_SENSE_BUFFERSIZE;
/include/scsi/scsi_cmnd.h
106#define SCSI_SENSE_BUFFERSIZE   96
1624

CID 751478 (#1 of 1): Out-of-bounds access (OVERRUN)
15. overrun-buffer-arg: Overrunning buffer pointed to by
"&rsp_info->_fr_resvd[0] + rsp_len" of 3 bytes by passing it to a function
which accesses it at byte offset 95 using argument "sns_len" (which evaluates
to 96).
1625                        memcpy(cmnd->sense_buffer,
1626                               &rsp_info->_fr_resvd[0] + rsp_len, sns_len);
/include/scsi/fc/fc_fcp.h
157    __u8      _fr_resvd[3];       /* reserved */
158    __u8      rsp_code;           /* Response Info Code */
159    __u8      _fr_resvd2[4];      /* reserved */
160};
1627                        CSIO_INC_STATS(scm, n_autosense);
1628                }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
