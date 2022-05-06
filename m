Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E89AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 10:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390854AbiEFKWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 06:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239719AbiEFKWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 06:22:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8885DE54
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 03:18:38 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2469jP95028897;
        Fri, 6 May 2022 10:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3rIPcz2N0D6++pD/AzjO214gwx2wmRrFMAzgXTYJJU4=;
 b=N1OQ4qd1Lx+OZIkBkrzuAwzr8+HDAZGNuAAQEbHAV2cgJBOk4r5JIPhbi5Utp7cKAm66
 H7ZOasyp3XysJflV9HhesZdP7lbuM/jpUPy7/QYD0dmyyU8/mFmsLUf+gmQOJpg6eLO9
 sePy5kbD8uXW6HBOLfQzLiaAhG21md2wgKDwsZ/RzShAMt+/JdvmQHYCCCp/UM3iP7HQ
 Ay51KAX4g2sGrTlevRBOSN2IwHOL3MmCFIt5L7u8L9ZiQS+k27y3pfF03q7nk0ATEqXT
 52iSq0KC4WKqMeJhnfZtu8OYVBGfuU4VsqfV2KplzFDyekjn3Opf5ShHkJCa1Tv51TMT 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw1avgq0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 10:18:23 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 246AGb77027693;
        Fri, 6 May 2022 10:18:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw1avgq0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 10:18:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246ACUGC032356;
        Fri, 6 May 2022 10:18:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3fvg6114ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 10:18:20 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246AIHME43778410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 10:18:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B31F8A404D;
        Fri,  6 May 2022 10:18:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EC9CA4040;
        Fri,  6 May 2022 10:18:17 +0000 (GMT)
Received: from [9.145.173.100] (unknown [9.145.173.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 10:18:17 +0000 (GMT)
Message-ID: <6992b790-ac24-0b42-31f5-d3d0f886ec94@linux.ibm.com>
Date:   Fri, 6 May 2022 12:18:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 3/7] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Benjamin Block <bblock@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        James Smart <jsmart2021@gmail.com>
References: <20220502215953.5463-1-hare@suse.de>
 <20220502215953.5463-7-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20220502215953.5463-7-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fY8QPC7rChUEF2pfztrntG0a_8BAKPza
X-Proofpoint-ORIG-GUID: 2Yf6aEJYfMkl8fgkFlyzJD1EGaPYchDs
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060052
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 23:59, Hannes Reinecke wrote:
> The target reset function should only depend on the scsi target,
> not the scsi command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: James Smart <jsmart2021@gmail.com>
> ---
>   Documentation/scsi/scsi_eh.rst              | 10 ++++
>   Documentation/scsi/scsi_mid_low_api.rst     | 18 +++++++

>   drivers/s390/scsi/zfcp_scsi.c               |  7 ++-

>   drivers/scsi/scsi_debug.c                   | 21 +++-----
>   drivers/scsi/scsi_error.c                   |  5 +-

>   include/scsi/scsi_host.h                    |  2 +-
>   34 files changed, 216 insertions(+), 190 deletions(-)

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 873ccc60e4d6..10bbe56189b3 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -340,9 +340,12 @@ static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>   	return zfcp_scsi_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
>   }
> 
> -static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)

> +/*
> + * Note: We need to select a LUN as the storage array doesn't
> + * necessarily supports LUN 0 and might refuse the target reset.
> + */

That's not the reason and this patch does not change anything regarding LUN 
handling within target reset handler, so I wonder if we should just drop this 
new comment.

The reason was given in the description of:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/s390/scsi?id=674595d8519fdf4f78e1a4cceb2130ffa46bcdeb
"zfcp_scsi_eh_target_reset_handler() is special: The FCP channel requires a
valid LUN handle so we try to find ourselves a stand-in scsi_device"

I think that's sufficient. If you think we also need a copy in the code, you 
can copy&paste the description.

> +static int zfcp_scsi_eh_target_reset_handler(struct scsi_target *starget)
>   {
> -	struct scsi_target *starget = scsi_target(scpnt->device);
>   	struct fc_rport *rport = starget_to_rport(starget);
>   	struct Scsi_Host *shost = rport_to_shost(rport);
>   	struct scsi_device *sdev = NULL, *tmp_sdev;

the other change to zfcp looks good


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
