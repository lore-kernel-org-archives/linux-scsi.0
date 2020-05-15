Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718FBC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48CE820760
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:19:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AOrQHDKh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEOKTb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:19:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51830 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgEOKTb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:19:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FA6aWf066361;
        Fri, 15 May 2020 10:19:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=Sraec879HLM5mjkyogjFeEukkZwmyXPLKB47XiprxHQ=;
 b=AOrQHDKhZmh7LCauki/I/L1zz5BtGRBDBykkJnK5poPnUy/7xKKy3L7uNzf0I57JLG61
 pNt7KfFXAiKI7OllVQyWXCra2aY7vN8op9V4JPlTEyuy3viffgcmCAtIalCD0oC1fj76
 tTFJijWEj5OYto0qQAf5r9ccW8dhk8/MI/QdF6Sipdx8nlzvJs5CWhEgFpWHCXdEaTnb
 fY/YsfGDlz2TZN8WAMVvz+hHr4i0hhhizF5AKOYKYr0X2EBx4lyML2Yoe6Div6Vj8GLr
 dGJGN/Ud2YZ6sJjdUGovMWPbRkGz9TRpkqgvz6rRsWEWPHMJhA9TVa+LmkkJiujJOx+y GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3100yga5jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 10:19:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FAEBC8192223;
        Fri, 15 May 2020 10:19:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3100yjqfnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 10:19:16 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04FAJDdv007968;
        Fri, 15 May 2020 10:19:13 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 03:19:12 -0700
Date:   Fri, 15 May 2020 13:19:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>,
        linux-nvme@lists.infradead.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Paul Ely <paul.ely@broadcom.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH resend] scsi: lpfc: Fix a use after free in
 lpfc_nvme_unsol_ls_handler()
Message-ID: <20200515101903.GJ3041@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1y2purqt1.fsf@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=2 adultscore=0 mlxscore=0 mlxlogscore=903
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=2 spamscore=0 impostorscore=0
 mlxlogscore=931 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150088
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "axchg" pointer is dereferenced when we call the
lpfc_nvme_unsol_ls_issue_abort() function.  It can't be either freed or
NULL.

Fixes: 3a8070c567aa ("lpfc: Refactor NVME LS receive handling")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
---
Resending to the NVMe list.  Added James' R-b.

Is there a way we could update MAINTAINERS so that ./get_maintainer.pl
send these to the correct list?

 drivers/scsi/lpfc/lpfc_sli.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 38889cb6e1996..fcf51b4192d66 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2895,14 +2895,14 @@ lpfc_nvme_unsol_ls_handler(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 			(phba->nvmet_support) ? "T" : "I", ret);
 
 out_fail:
-	kfree(axchg);
-
 	/* recycle receive buffer */
 	lpfc_in_buf_free(phba, &nvmebuf->dbuf);
 
 	/* If start of new exchange, abort it */
-	if (fctl & FC_FC_FIRST_SEQ && !(fctl & FC_FC_EX_CTX))
+	if (axchg && (fctl & FC_FC_FIRST_SEQ) && !(fctl & FC_FC_EX_CTX))
 		lpfc_nvme_unsol_ls_issue_abort(phba, axchg, sid, oxid);
+
+	kfree(axchg);
 }
 
 /**
-- 
2.26.2
