Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024F0C54E4A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 08:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF184206CC
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 08:46:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jYXGq5v6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgELIqg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 04:46:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgELIqg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 04:46:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C8h2JH052096;
        Tue, 12 May 2020 08:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=sUcWufXYK5jH9Tzpw8fNYnpiSXb1JjxD6fHu5JAYX4A=;
 b=jYXGq5v6HaWmfa+e5Rm2azZobLfYterxKYV3jprEkNmKUnJqvufL7s7CIOhDHiy90uJw
 Ye/TG2qaUEOIUV4fy/kZetWJecTsRNEu21Am0U95ji97hrQHMLR1Q/K1nkXzJFv2D8kw
 iSxj02LPzFU8uyP03A4dpfgpclG056H6WoekHYXHM7WseCpfT2nta7cgP9jZqlWJtmOk
 L0lprbS5kLNsKwsTsVGjpJE9h/zaiO+MWNI6E2p9VOASoHVkXuNKqsE4nndRrre1E1KX
 UIGKy/Uho3dLYLhREzBwCWjPbtPdbp6zheXs4zy7z/xvS7YK3sK16CoswqiZy4s31i97 yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30x3gshnut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 08:46:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C8cX85095532;
        Tue, 12 May 2020 08:46:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30xbghrd95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 08:46:33 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04C8kWAJ026252;
        Tue, 12 May 2020 08:46:32 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 01:46:31 -0700
Date:   Tue, 12 May 2020 11:46:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] lpfc: Refactor Send LS Abort support
Message-ID: <20200512084626.GA252662@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=3 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120072
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1011 bulkscore=0 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120072
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch e96a22b0b7c2: "lpfc: Refactor Send LS Abort support" from
Mar 31, 2020, leads to the following static checker warning:

	drivers/scsi/lpfc/lpfc_nvmet.c:1366 lpfc_nvmet_ls_abort()
	warn: 'ret' can be either negative or positive

drivers/scsi/lpfc/lpfc_nvmet.c
   832  /**
   833   * __lpfc_nvme_ls_abort - Generic service routine to abort a prior
   834   *         NVME LS request
   835   * @vport: The local port that issued the LS
   836   * @ndlp: The remote port the LS was sent to
   837   * @pnvme_lsreq: Pointer to LS request structure from the transport
   838   *
   839   * The driver validates the ndlp, looks for the LS, and aborts the
   840   * LS if found.
   841   *
   842   * Returns:
   843   * 0 : if LS found and aborted
   844   * non-zero: various error conditions in form -Exxx

This is an unpublished Smatch check where negatives and positives are
both treated as errors.  I think the code is correct.  But the comment
describing the returns needs to be updated.

   845   **/
   846  int
   847  __lpfc_nvme_ls_abort(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
   848                          struct nvmefc_ls_req *pnvme_lsreq)
   849  {
   850          struct lpfc_hba *phba = vport->phba;
   851          struct lpfc_sli_ring *pring;
   852          struct lpfc_iocbq *wqe, *next_wqe;
   853          bool foundit = false;
   854  
   855          if (!ndlp) {
   856                  lpfc_printf_log(phba, KERN_ERR,
   857                                  LOG_NVME_DISC | LOG_NODE |
   858                                          LOG_NVME_IOERR | LOG_NVME_ABTS,
   859                                  "6049 NVMEx LS REQ Abort: Bad NDLP x%px DID "
   860                                  "x%06x, Failing LS Req\n",
   861                                  ndlp, ndlp ? ndlp->nlp_DID : 0);
   862                  return -EINVAL;
   863          }
   864  
   865          lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC | LOG_NVME_ABTS,
   866                           "6040 NVMEx LS REQ Abort: Issue LS_ABORT for lsreq "
   867                           "x%p rqstlen:%d rsplen:%d %pad %pad\n",
   868                           pnvme_lsreq, pnvme_lsreq->rqstlen,
   869                           pnvme_lsreq->rsplen, &pnvme_lsreq->rqstdma,
   870                           &pnvme_lsreq->rspdma);
   871  
   872          /*
   873           * Lock the ELS ring txcmplq and look for the wqe that matches
   874           * this ELS. If found, issue an abort on the wqe.
   875           */
   876          pring = phba->sli4_hba.nvmels_wq->pring;
   877          spin_lock_irq(&phba->hbalock);
   878          spin_lock(&pring->ring_lock);
   879          list_for_each_entry_safe(wqe, next_wqe, &pring->txcmplq, list) {
   880                  if (wqe->context2 == pnvme_lsreq) {
   881                          wqe->iocb_flag |= LPFC_DRIVER_ABORTED;
   882                          foundit = true;
   883                          break;
   884                  }
   885          }
   886          spin_unlock(&pring->ring_lock);
   887  
   888          if (foundit)
   889                  lpfc_sli_issue_abort_iotag(phba, pring, wqe);
   890          spin_unlock_irq(&phba->hbalock);
   891  
   892          if (foundit)
   893                  return 0;
   894  
   895          lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC | LOG_NVME_ABTS,
   896                           "6213 NVMEx LS REQ Abort: Unable to locate req x%p\n",
   897                           pnvme_lsreq);
   898          return 1;
                ^^^^^^^^

   899  }

regards,
dan carpenter
