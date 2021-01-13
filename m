Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,BIGNUM_EMAILS,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EDAC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 09:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CB4D233A2
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 09:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAMJzs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 04:55:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49380 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbhAMJzs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 04:55:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D9OJAO091307;
        Wed, 13 Jan 2021 09:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=I/fNAgRINFeegmCJqm8P1zIB3iEu1/42FD0qFVA4Ydc=;
 b=p8vlGr1oZdn/60IIAvM1iHjaHszbg6y0VpTQonHTcpqZBPLObjc04y6iNNR1xwehbotp
 sjG4NYaBnALz7BpV2jFMJbZt8DmLPheQq366XHVvqszSV2RZpek6qlycZeZ/uqhuBLCf
 /QNSpPsiQun/a6M402uz+fsk+dnaQSIlJNaoX5+jaxjrtYYq0IlVIbs/3B5DMU0zMXKU
 W5peba9iWo0whUCGuZbuGyfPycNPt7LxoreeFq+Q17RvFtU8rDLFqEb1yoBgu2PErNw7
 MMYFSgLaIW1R6S0pboQHvHXioKrs53ffiphTK6j/6qOzWJ2ZbzYE7X8fP6LXhGTba+MU eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 360kcytkns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:49:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D9k5Wt161605;
        Wed, 13 Jan 2021 09:47:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 360kf0a1t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:47:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10D9l4vu029532;
        Wed, 13 Jan 2021 09:47:05 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Jan 2021 01:47:04 -0800
Date:   Wed, 13 Jan 2021 12:46:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     james.smart@emulex.com
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [bug report] [SCSI] lpfc 8.3.24: Extend BSG infrastructure and
 add link diagnostics
Message-ID: <20210113094657.GH5105@kadam>
References: <X/61pr0UpP0M45ME@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/61pr0UpP0M45ME@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130057
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130056
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 13, 2021 at 11:56:06AM +0300, Dan Carpenter wrote:
> Hello James Smart,
> 
> The patch 7ad20aa9d39a: "[SCSI] lpfc 8.3.24: Extend BSG
> infrastructure and add link diagnostics" from May 24, 2011, leads to
> the following static checker warning:
> 
> 	drivers/scsi/lpfc/lpfc_bsg.c:4989 lpfc_bsg_issue_mbox()
> 	warn: 'dmabuf' was already freed.
> 
> The problem is that lpfc_bsg_issue_mbox() call lpfc_bsg_handle_sli_cfg_ext()
> which calls lpfc_bsg_handle_sli_cfg_ebuf() which is where the bug really
> is, I think.
> 
> drivers/scsi/lpfc/lpfc_bsg.c
>   4584  static int
>   4585  lpfc_bsg_handle_sli_cfg_ebuf(struct lpfc_hba *phba, struct bsg_job *job,
>   4586                               struct lpfc_dmabuf *dmabuf)
>   4587  {
>   4588          int rc;
>   4589  
>   4590          lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
>   4591                          "2971 SLI_CONFIG buffer (type:x%x)\n",
>   4592                          phba->mbox_ext_buf_ctx.mboxType);
>   4593  
>   4594          if (phba->mbox_ext_buf_ctx.mboxType == mbox_rd) {
>   4595                  if (phba->mbox_ext_buf_ctx.state != LPFC_BSG_MBOX_DONE) {
>   4596                          lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
>   4597                                          "2972 SLI_CONFIG rd buffer state "
>   4598                                          "mismatch:x%x\n",
>   4599                                          phba->mbox_ext_buf_ctx.state);
>   4600                          lpfc_bsg_mbox_ext_abort(phba);
>   4601                          return -EPIPE;
>   4602                  }
>   4603                  rc = lpfc_bsg_read_ebuf_get(phba, job);
>   4604                  if (rc == SLI_CONFIG_HANDLED)
>   4605                          lpfc_bsg_dma_page_free(phba, dmabuf);
> 
> I think this path is correct.
> 
>   4606          } else { /* phba->mbox_ext_buf_ctx.mboxType == mbox_wr */
>   4607                  if (phba->mbox_ext_buf_ctx.state != LPFC_BSG_MBOX_HOST) {
>   4608                          lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
>   4609                                          "2973 SLI_CONFIG wr buffer state "
>   4610                                          "mismatch:x%x\n",
>   4611                                          phba->mbox_ext_buf_ctx.state);
>   4612                          lpfc_bsg_mbox_ext_abort(phba);
>   4613                          return -EPIPE;
>   4614                  }
>   4615                  rc = lpfc_bsg_write_ebuf_set(phba, job, dmabuf);
> 
> But this path has two bugs.  If lpfc_bsg_write_ebuf_set() then it frees
> three things but it should not free anything.  This leads to the double
> free bug which Smatch is complaining about.  (Smatch only catches one of
> the problems).

Actually the other two are local variables so freeing them was correct.
But I've added the mempool_free() to Smatch as a free function since it
wasn't tracking that before.

regards,
dan carpenter

