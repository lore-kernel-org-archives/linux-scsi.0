Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16A3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 09:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B7E6103C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 09:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245228AbhIXJiv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:38:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S245054AbhIXJir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Sep 2021 05:38:47 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18O7Lr0T004108;
        Fri, 24 Sep 2021 05:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=SjiT9i7qvq4gHObZodCRRo/eCp5BIHeOzxFg9+UuOwI=;
 b=R08l10Pjcv+VaUAny1wwRpddfWtxPWG+Ixm5RJ04ZDqJezekh83ojLf8xcFstqe6NZRV
 xqY+VBqcglamWSH5EHLYAXLtiFSxtjipun0cyafU4R9F7NRF+S8i3RwwwqO3z0hZdGMs
 Ak5JPBKi89KKUIrGctkjKirIDjJF4W5aG1BB7x8jyw+dTxQD6bNAXk+5+a1x8zylGxz7
 PLYtEMRL8yApUlfkJsIm4vTUa3IzibogUfTQqXf6sFcMrXQ6tr6DlcxFqLatwT5swcJf
 Kol7UTmkTMaxxeHYK+oJu3QFnhLxRcQBM1p8PMnJKJxPO5jJ8BFhrcFgyr/TKSeahIGc Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b979uxpva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Sep 2021 05:37:02 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18O9FQYu024482;
        Fri, 24 Sep 2021 05:37:02 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b979uxpup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Sep 2021 05:37:01 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18O9WGfW016620;
        Fri, 24 Sep 2021 09:37:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3b93ga46y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Sep 2021 09:37:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18O9auqL39059966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 09:36:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB6215205A;
        Fri, 24 Sep 2021 09:36:56 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.165.67])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 9902C52054;
        Fri, 24 Sep 2021 09:36:56 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mThdY-0022gl-1c; Fri, 24 Sep 2021 11:36:56 +0200
Date:   Fri, 24 Sep 2021 11:36:55 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 01/84] scsi: core: Use a member variable to track the
 SCSI command submitter
Message-ID: <YU2cN5H7CqVFOzTQ@t480-pf1aa2c2.linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-2-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210918000607.450448-2-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ROJBV8MtvL8zjkfmtcynBqpRNAihrMwj
X-Proofpoint-ORIG-GUID: oe-uZCBvHGE1THPs_1vnbleDC0uHzIGN
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-24_03,2021-09-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2109240057
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 05:04:44PM -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Use a member variable
> to track the SCSI command submitter such that later patches can call
> scsi_done(scmd) instead of scmd->scsi_done(scmd).
> 
> The asymmetric behavior that scsi_send_eh_cmnd() sets the submission
> context to the SCSI error handler and that it does not restore the
> submission context to the SCSI core is retained.
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 18 +++++++-----------
>  drivers/scsi/scsi_lib.c   |  9 +++++++++
>  drivers/scsi/scsi_priv.h  |  1 +
>  include/scsi/scsi_cmnd.h  |  7 +++++++
>  4 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 572673873ddf..ba6d748a0246 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1577,6 +1577,15 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>  
>  static void scsi_mq_done(struct scsi_cmnd *cmd)
>  {
> +	switch (cmd->submitter) {
> +	case BLOCK_LAYER:
> +		break;
> +	case SCSI_ERROR_HANDLER:
> +		return scsi_eh_done(cmd);
> +	case SCSI_RESET_IOCTL:
> +		return;
> +	}
> +

Hmm, I'm confused, you replace one kind of branch with different one. Why
would that increase IOPS by 5%?

Maybe its because the new `submitter` field in `struct scsi_cmnd` is now
on a hot cache line, whereas `*scsi_done` is not?

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
