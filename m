Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C98C2D0F7
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 18:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48A6E206D3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 18:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pXPfJyHQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgELSS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 14:18:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44388 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgELSS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 14:18:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CIIpvN040091;
        Tue, 12 May 2020 18:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=VviYrr/USMV/gMJUYUTpsN6oJQuVWzCYHlCvsK+0aSk=;
 b=pXPfJyHQ6euIXTF/aX94ymfcK/kQTuXBmca/EKkwG9lwWp9SXLyxLT6C1Xtgy/X9/Cvj
 KbdJ+0tUkjb/Syb+LDrwM40HQ/oaPsWaXllkFwE3A9ZRLUvSiG24hXc3dgerPHUryHSH
 bAgC/fVF4G+3E/kKwhnNpQwMM84h4J7paV0j5iPFVlIDahvV8zd+CGjwoJDJk/2DQAoZ
 QWBlyfKFQp7Tb8nXD9EnpNU3uIFiGJqVQ+k88+ZWppMrkRFBt35y2tdvE+N7IVrKTGbL
 ywEYKV2iXZywdNirG7HPx7SDeMLw7a8ka8ih2Cq7WCMIort2uFW3ZFI8Z5gW7ms9NQMd Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3100yfr01v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 18:18:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CIIEkV047101;
        Tue, 12 May 2020 18:18:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3100y8r1fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 18:18:54 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CIIrx3005130;
        Tue, 12 May 2020 18:18:53 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 11:18:53 -0700
Date:   Tue, 12 May 2020 21:18:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] lpfc: Refactor NVME LS receive handling
Message-ID: <20200512181847.GA299019@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=10 mlxscore=0 mlxlogscore=694 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005120138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 suspectscore=10 spamscore=0 mlxlogscore=728 malwarescore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120138
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch 3a8070c567aa: "lpfc: Refactor NVME LS receive handling" 
from Mar 31, 2020, leads to the following Smatch complaint:

    drivers/scsi/lpfc/lpfc_sli.c:2905 lpfc_nvme_unsol_ls_handler()
    error: we previously assumed 'phba->targetport' could be null (see line 2837)

drivers/scsi/lpfc/lpfc_sli.c
  2836			failwhy = "No Localport";
  2837		} else if (phba->nvmet_support && !phba->targetport) {
                           ^^^^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^^
Assume both pointers are NULL.

  2838			failwhy = "No Targetport";
  2839		} else if (unlikely(fc_hdr->fh_r_ctl != FC_RCTL_ELS4_REQ)) {
  2840			failwhy = "Bad NVME LS R_CTL";
  2841		} else if (unlikely((fctl & 0x00FF0000) !=
  2842				(FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT))) {
  2843			failwhy = "Bad NVME LS F_CTL";
  2844		} else {
  2845			axchg = kzalloc(sizeof(*axchg), GFP_ATOMIC);
  2846			if (!axchg)
  2847				failwhy = "No CTX memory";
  2848		}
  2849	
  2850		if (unlikely(failwhy)) {
  2851			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC | LOG_NVME_IOERR,
  2852					"6154 Drop NVME LS: SID %06X OXID x%X: %s\n",
  2853					sid, oxid, failwhy);
  2854			goto out_fail;
  2855		}
  2856	
  2857		/* validate the source of the LS is logged in */
  2858		ndlp = lpfc_findnode_did(phba->pport, sid);
  2859		if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
  2860		    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
  2861		     (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
  2862			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
  2863					"6216 NVME Unsol rcv: No ndlp: "
  2864					"NPort_ID x%x oxid x%x\n",
  2865					sid, oxid);
  2866			goto out_fail;
  2867		}
  2868	
  2869		axchg->phba = phba;
  2870		axchg->ndlp = ndlp;
  2871		axchg->size = size;
  2872		axchg->oxid = oxid;
  2873		axchg->sid = sid;
  2874		axchg->wqeq = NULL;
  2875		axchg->state = LPFC_NVME_STE_LS_RCV;
  2876		axchg->entry_cnt = 1;
  2877		axchg->rqb_buffer = (void *)nvmebuf;
  2878		axchg->hdwq = &phba->sli4_hba.hdwq[0];
  2879		axchg->payload = nvmebuf->dbuf.virt;
  2880		INIT_LIST_HEAD(&axchg->list);
  2881	
  2882		if (phba->nvmet_support)
  2883			ret = lpfc_nvmet_handle_lsreq(phba, axchg);
  2884		else
  2885			ret = lpfc_nvme_handle_lsreq(phba, axchg);
  2886	
  2887		/* if zero, LS was successfully handled. If non-zero, LS not handled */
  2888		if (!ret)
  2889			return;
  2890	
  2891		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC | LOG_NVME_IOERR,
  2892				"6155 Drop NVME LS from DID %06X: SID %06X OXID x%X "
  2893				"NVMe%s handler failed %d\n",
  2894				did, sid, oxid,
  2895				(phba->nvmet_support) ? "T" : "I", ret);
  2896	
  2897	out_fail:
  2898		kfree(axchg);
  2899	
  2900		/* recycle receive buffer */
  2901		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
  2902	
  2903		/* If start of new exchange, abort it */
  2904		if (fctl & FC_FC_FIRST_SEQ && !(fctl & FC_FC_EX_CTX))
  2905			lpfc_nvme_unsol_ls_issue_abort(phba, axchg, sid, oxid);
                                                       ^^^^
phba->targetport is dereferenced without checking.

  2906	}
  2907	

regards,
dan carpenter
