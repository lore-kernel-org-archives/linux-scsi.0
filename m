Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BB8C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 11:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345559AbiEFLYW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 07:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345685AbiEFLYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 07:24:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB67716594
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 04:20:37 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246AmEe1006771;
        Fri, 6 May 2022 11:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ZHuSIniha1hT0FIUe2my/CulWsDtiCylkprhMNESMek=;
 b=KThb76D9AiKz74XDvQD0xCo0aGpC3P4lEnNfXDOKQuUUx/UBUSxXHITwhFwirDCBhp9Y
 f/uxF8Du66KTOexQVXNvryF46UpAUsXhPTFsd0k+1acHLOIG5OcwJJnedx3BL++KovTM
 ixCmvSJ+NPKkaVtDueUSFb4AZtBvkE8uvSBut1ZZCQK63Tw0UZPpQjbJc5dxuyKpDoAt
 H+zyAPKaYsqSjtKyMybO7lXjs545rI3zx/pPmTLhPM89iH31PepZGlA7jt82508Hir8h
 pTKaZDWlWiLqCnDafcHby8CYGQV8Sdmlwr1dDVLxrOQv5VZ9U/09MJBLMe4s8ELrdTyC 3g== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvy3bvq68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:20:27 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246BIwsQ031760;
        Fri, 6 May 2022 11:20:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3frvr8xur2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:20:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246BKMj654526456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 11:20:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D86DBA4051;
        Fri,  6 May 2022 11:20:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B86FA404D;
        Fri,  6 May 2022 11:20:22 +0000 (GMT)
Received: from [9.145.173.100] (unknown [9.145.173.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 11:20:22 +0000 (GMT)
Message-ID: <95f2a09e-cf96-c80a-4e45-7a59a07af259@linux.ibm.com>
Date:   Fri, 6 May 2022 13:20:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/7] scsi: Use Scsi_Host and channel number as argument
 for eh_bus_reset_handler()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502215953.5463-1-hare@suse.de>
 <20220502215953.5463-4-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20220502215953.5463-4-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GrNsKyuRpNn0gd7rUTTGgnswd8ltBDuH
X-Proofpoint-ORIG-GUID: GrNsKyuRpNn0gd7rUTTGgnswd8ltBDuH
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060062
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 23:59, Hannes Reinecke wrote:
> The bus reset should not depend on any command, but rather only
> use the SCSI Host and the channel/bus number as argument.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   Documentation/scsi/scsi_eh.rst                |  2 +-
>   Documentation/scsi/scsi_mid_low_api.rst       |  5 ++-

>   include/scsi/scsi_host.h                      |  2 +-
>   36 files changed, 150 insertions(+), 163 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
> index 12113cca5ad9..5e2d04e64005 100644
> --- a/Documentation/scsi/scsi_eh.rst
> +++ b/Documentation/scsi/scsi_eh.rst
> @@ -214,7 +214,7 @@ considered to fail always.
> 
>       int (* eh_abort_handler)(struct scsi_cmnd *);
>       int (* eh_device_reset_handler)(struct scsi_cmnd *);
> -    int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> +    int (* eh_bus_reset_handler)(struct Scsi_Host *, int);

IIRC, checkpatch prefers using variable names with prototypes. I also like it 
because it would explain the semantics of e.g. the "int". Is it possible to do 
so in function pointer definitions? [method seemed to work for me with gcc 11.3.0]:

+    int (* eh_bus_reset_handler)(struct Scsi_Host *host, int channel);

>       int (* eh_host_reset_handler)(struct Scsi_Host *);
> 
>   Higher-severity actions are taken only when lower-severity actions
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 784587ea7eee..1b1c37445580 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -741,7 +741,8 @@ Details::
> 
>       /**
>       *      eh_bus_reset_handler - issue SCSI bus reset
> -    *      @scp: SCSI bus that contains this device should be reset
> +    *      @host: SCSI Host that contains the channel which should be reset
> +    *      @channel: channel to be reset
>       *
>       *      Returns SUCCESS if command aborted else FAILED
>       *
> @@ -754,7 +755,7 @@ Details::
>       *
>       *      Optionally defined in: LLD
>       **/
> -	int eh_bus_reset_handler(struct scsi_cmnd * scp)
> +	int eh_bus_reset_handler(struct Scsi_Host * host, int channel)

exactly like that

> 
> 
>       /**

> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 3b8d9e65ea57..73c9971e7334 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -140,7 +140,7 @@ struct scsi_host_template {
>   	int (* eh_abort_handler)(struct scsi_cmnd *);
>   	int (* eh_device_reset_handler)(struct scsi_cmnd *);
>   	int (* eh_target_reset_handler)(struct scsi_cmnd *);
> -	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> +	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);

dito

>   	int (* eh_host_reset_handler)(struct Scsi_Host *);
> 
>   	/*


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
