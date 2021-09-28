Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135F1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 16:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0D3560F6B
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 16:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241877AbhI1Q4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 12:56:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4924 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229795AbhI1Q4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 12:56:11 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SFrb1J028439;
        Tue, 28 Sep 2021 12:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=iBjIDsbEkT3Gysv4bKV9sCEsYK8ezX7aOYTAPzOE1wI=;
 b=WZoWmsrUFGwiTl+5gjkZ3p/OYNGmQm4HGb3Tjfq5dXzzQzeX/zGC7TZqu1mtTM2tbT49
 n23sLODjBHsB2LzeEspC1j6iVQTkNhVsZr6TuxG4Hy/8XbY8cgkK0rdjep2qvYHFEBAn
 Vm473A3hE66PRtJmdLk9JB1HQqRv/h73Eidkzx1+q7kF36Ls5rh97XtRrshkyrQD5WcX
 W+6oJJxbQP8FaQZeq8k/cwSgTd5vdMUkr0lyQFeQd3uOA88ZSkl6zjVsS7TVw6fuL58k
 2c/93i+01KAoLRfSenKSfYH8mH+es/PYb8DoLTvqJVD4bApgyHFhK5mJv056dxrI31kM DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbjbn1qh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 12:54:15 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18SGrxfs013301;
        Tue, 28 Sep 2021 12:54:14 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbjbn1qgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 12:54:14 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SGltfW019887;
        Tue, 28 Sep 2021 16:54:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3b9uda02ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 16:54:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SGs9gZ66715994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 16:54:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29A7911C058;
        Tue, 28 Sep 2021 16:54:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1735911C050;
        Tue, 28 Sep 2021 16:54:09 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.153])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Sep 2021 16:54:09 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mVGMq-000EGA-FI; Tue, 28 Sep 2021 18:54:08 +0200
Date:   Tue, 28 Sep 2021 18:54:08 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 01/84] scsi: core: Use a member variable to track the
 SCSI command submitter
Message-ID: <YVNIsDkFIL1xV8o9@t480-pf1aa2c2.linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-2-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210918000607.450448-2-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nr-qG49hRn9_MHsdIITPt8g9O5ASbaZ-
X-Proofpoint-ORIG-GUID: mgZdMLn8vGwPIQPdFlsISC4cH8TS2K0y
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280096
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
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index eaf04c9a1dfc..365d47a66c18 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -65,6 +65,12 @@ struct scsi_pointer {
>  #define SCMD_STATE_COMPLETE	0
>  #define SCMD_STATE_INFLIGHT	1
>  
> +enum scsi_cmnd_submitter {
> +	BLOCK_LAYER = 0,
> +	SCSI_ERROR_HANDLER = 1,
> +	SCSI_RESET_IOCTL = 2,
> +} __packed;
> +

Might be prudent to not make them as generic, especially `BLOCK_LAYER`
might easily clash without namespace. `SUBMITTED_BY_...`?


>  struct scsi_cmnd {
>  	struct scsi_request req;
>  	struct scsi_device *device;
> @@ -90,6 +96,7 @@ struct scsi_cmnd {
>  	unsigned char prot_op;
>  	unsigned char prot_type;
>  	unsigned char prot_flags;
> +	enum scsi_cmnd_submitter submitter;

Do you think it'd make much of a difference, if you initialized this in
scsi_init_command(), or somewhere around there, explicitly to
`BLOCK_LAYER`? Makes it easier to maintain, and to not forget, that it
needs to be done, if the memset() to 0 ever changes... after the
memset() the memory should be hot.

I just had to search a bit where this gets set to 0, as I didn't
remember exactly where it was.

>  
>  	unsigned short cmd_len;
>  	enum dma_data_direction sc_data_direction;

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
