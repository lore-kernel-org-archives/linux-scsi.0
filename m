Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8179CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 11:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiEXLSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 07:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbiEXLRI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 07:17:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBAC94181
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2022 04:16:37 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24O9AAM1004282;
        Tue, 24 May 2022 11:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=h3s/3vG3K5oNfct8CH0WLi+od4c07+lHnc+mnK/ZKiY=;
 b=ODZGT0s5l98hU33DG25F/2858EGzo44X2PFB9NZ0iNV6Am9V1d43pKvwxW4iQ3F9QnTv
 6BMTGKyvqjNunMSyE10WiyZrCk13nBqQpxUt7MIe34iEOTiLx32GGQwFsjDRhKWEgBDv
 oHuPILL0WAcDuCNLMRJ4RElgXAoVLgJsMGMDSNKwRpOMHaUZCAlTOumdssdyOs/uTABr
 JNGTbFglOUbQzAXYStS2N4p89YyBqAqeAnXdw1jne+DylA813tkDBzRMhkwH63rMck9x
 DTYqTSrTlZtHm+JCHgfvVYO3sB9ArZVE6H/+81ey4tpYjalPmj6cNvuQAYngEy1fQMnA 2Q== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8uv0k03c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 11:16:23 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OB7N7e005782;
        Tue, 24 May 2022 11:16:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3g8c7gr8xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 11:16:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OBGJii22413570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 11:16:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12EC94C046;
        Tue, 24 May 2022 11:16:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 904C74C040;
        Tue, 24 May 2022 11:16:18 +0000 (GMT)
Received: from [9.145.57.10] (unknown [9.145.57.10])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 11:16:18 +0000 (GMT)
Message-ID: <8e50ff48-7ad1-29a3-23ee-48559fa79919@linux.ibm.com>
Date:   Tue, 24 May 2022 13:16:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 06/16] qedf: use fc rport as argument for
 qedf_initiate_tmf()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Saurav Kashyap <skashyap@marvell.com>
References: <20220524061602.86760-1-hare@suse.de>
 <20220524061602.86760-7-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20220524061602.86760-7-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QvkJU1hMg75LtfgTD8IYG5B6r5xmkDxx
X-Proofpoint-ORIG-GUID: QvkJU1hMg75LtfgTD8IYG5B6r5xmkDxx
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=873 phishscore=0 lowpriorityscore=0 clxscore=1011
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205240057
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/22 08:15, Hannes Reinecke wrote:
> When sending a TMF we're only concerned with the rport and the LUN ID,
> so use struct fc_rport as argument for qedf_initiate_tmf().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: Saurav Kashyap <skashyap@marvell.com>
> ---
>   drivers/scsi/qedf/qedf.h      |  3 +-
>   drivers/scsi/qedf/qedf_io.c   | 69 ++++++++++-------------------------
>   drivers/scsi/qedf/qedf_main.c | 19 +++++-----
>   3 files changed, 31 insertions(+), 60 deletions(-)


> @@ -2432,33 +2425,10 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
>   		 (tm_flags == FCP_TMF_TGT_RESET) ? "TARGET RESET" :
>   		 "LUN RESET");
> 
> -	if (qedf_priv(sc_cmd)->io_req) {
> -		io_req = qedf_priv(sc_cmd)->io_req;
> -		ref_cnt = kref_read(&io_req->refcount);
> -		QEDF_ERR(NULL,
> -			 "orig io_req = %p xid = 0x%x ref_cnt = %d.\n",
> -			 io_req, io_req->xid, ref_cnt);
> -	}
> -
> -	rval = fc_remote_port_chkready(rport);
> -	if (rval) {
> -		QEDF_ERR(NULL, "device_reset rport not ready\n");
> -		rc = FAILED;
> -		goto tmf_err;
> -	}
> -
> -	rc = fc_block_scsi_eh(sc_cmd);
> +	rc = fc_block_rport(rport);


> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index 18dc68d577b6..85ccfbc5cd26 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -773,7 +773,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
>   		goto drop_rdata_kref;
>   	}
> 
> -	rc = fc_block_scsi_eh(sc_cmd);
> +	rc = fc_block_rport(rport);
>   	if (rc)
>   		goto drop_rdata_kref;
> 

Why replace the fc_block helper here in the abort handler?
Isn't the scope of the abort hander exactly the one scsi_cmnd?
The description of this patch is about changes to TMF (so I understand the 
change in qedf_initiate_tmf() above for device or target reset), i.e. not abort.
Admittedly, it shouldn't be a problem functional-wise, as fc_block_scsi_eh() 
delegates internally to fc_block_rport(), but it looks odd to me nonetheless.

This change seems inconsistent with the other patches in this series.
You don't plan to get rid of fc_block_scsi_eh(), do you?

Oh, later in patch 09 you write:
"Use fc_block_rport() instead of fc_block_scsi_eh() as the latter
will be deprecated."

Why?
Then all FCP HBA abort handlers need to convert their scsi_cmnd to fc_rport 
themselves.
E.g. zfcp_scsi_eh_abort_handler() does not deal with fc_rport so far as there 
was no need. From what I've seen you haven't touched that part in
[PATCH v2 03/24] zfcp: open-code fc_block_scsi_eh() for host reset
when zfcp was still part of the series, so I smell an inconsistency.

Haven't seen that coming. Did I miss this having been announced explicitly 
somewhere else earlier? If not, I would find it interesting to being made 
explicit. In retrospectice, I found some hints hidden in individual patches of 
earlier version in this series, but I had completely missed it.
Also, it seems a separate topic, not necessarily related to changing the 
scsi_eh callback API for dev/target/bus/host reset to get rid of their 
unsuitable argument scsi_cmnd.

-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
