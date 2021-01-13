Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,BIGNUM_EMAILS,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CAD8C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 09:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43402233A1
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 09:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbhAMJCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 04:02:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58884 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbhAMJCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 04:02:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D8rsYx034820;
        Wed, 13 Jan 2021 08:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=8EDoujIDsGwoilKxZxueX3IIZMbuWWBloyCuYjbPz+I=;
 b=Ufh52U1P5u2vOKVTUPfFtHa09dFD1ZIsdTyAyLjoXffWO5Ky3fpuiXt/JGAPZS9EvoGq
 RKWZ3XwB0Yr5wnVmxlHjyEZLJNqYry22qXS5MdcVbdU96QG3yE56bKrcBGyXrUtoEjov
 V2DWMadho/wZyfusnzOJnF7+92Ljt3Y8VXY4qMGk/Bdt7DkKheeyJLyk29KpD/N/YVqC
 Pb7vi2GVksxhuZ316YF2bvVu4Lp1Y8s/XOdKDVSwbIX+DCVIlwk/Oa10OSTEmXzMLUhW
 wd0D+39Ze9JERksRT/T3Nt2sqyUpoM/CEPiSltizrarbuH9StOqrqQoDNZiid/9wG9+F SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 360kcyt9yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 08:56:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D8negJ043579;
        Wed, 13 Jan 2021 08:56:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 360ke80h5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 08:56:13 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10D8uC7i019606;
        Wed, 13 Jan 2021 08:56:12 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Jan 2021 00:56:12 -0800
Date:   Wed, 13 Jan 2021 11:56:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     james.smart@emulex.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] [SCSI] lpfc 8.3.24: Extend BSG infrastructure and add
 link diagnostics
Message-ID: <X/61pr0UpP0M45ME@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=956 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=961 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 7ad20aa9d39a: "[SCSI] lpfc 8.3.24: Extend BSG
infrastructure and add link diagnostics" from May 24, 2011, leads to
the following static checker warning:

	drivers/scsi/lpfc/lpfc_bsg.c:4989 lpfc_bsg_issue_mbox()
	warn: 'dmabuf' was already freed.

The problem is that lpfc_bsg_issue_mbox() call lpfc_bsg_handle_sli_cfg_ext()
which calls lpfc_bsg_handle_sli_cfg_ebuf() which is where the bug really
is, I think.

drivers/scsi/lpfc/lpfc_bsg.c
  4584  static int
  4585  lpfc_bsg_handle_sli_cfg_ebuf(struct lpfc_hba *phba, struct bsg_job *job,
  4586                               struct lpfc_dmabuf *dmabuf)
  4587  {
  4588          int rc;
  4589  
  4590          lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
  4591                          "2971 SLI_CONFIG buffer (type:x%x)\n",
  4592                          phba->mbox_ext_buf_ctx.mboxType);
  4593  
  4594          if (phba->mbox_ext_buf_ctx.mboxType == mbox_rd) {
  4595                  if (phba->mbox_ext_buf_ctx.state != LPFC_BSG_MBOX_DONE) {
  4596                          lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
  4597                                          "2972 SLI_CONFIG rd buffer state "
  4598                                          "mismatch:x%x\n",
  4599                                          phba->mbox_ext_buf_ctx.state);
  4600                          lpfc_bsg_mbox_ext_abort(phba);
  4601                          return -EPIPE;
  4602                  }
  4603                  rc = lpfc_bsg_read_ebuf_get(phba, job);
  4604                  if (rc == SLI_CONFIG_HANDLED)
  4605                          lpfc_bsg_dma_page_free(phba, dmabuf);

I think this path is correct.

  4606          } else { /* phba->mbox_ext_buf_ctx.mboxType == mbox_wr */
  4607                  if (phba->mbox_ext_buf_ctx.state != LPFC_BSG_MBOX_HOST) {
  4608                          lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
  4609                                          "2973 SLI_CONFIG wr buffer state "
  4610                                          "mismatch:x%x\n",
  4611                                          phba->mbox_ext_buf_ctx.state);
  4612                          lpfc_bsg_mbox_ext_abort(phba);
  4613                          return -EPIPE;
  4614                  }
  4615                  rc = lpfc_bsg_write_ebuf_set(phba, job, dmabuf);

But this path has two bugs.  If lpfc_bsg_write_ebuf_set() then it frees
three things but it should not free anything.  This leads to the double
free bug which Smatch is complaining about.  (Smatch only catches one of
the problems).  The second bug is that if lpfc_bsg_write_ebuf_set()
return SLI_CONFIG_HANDLED then this patch should call
lpfc_bsg_dma_page_free(phba, dmabuf);

  4616          }
  4617          return rc;
  4618  }

regards,
dan carpenter
