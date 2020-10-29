Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5FDC55179
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 17:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9903C20720
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 17:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R7zJUjaf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgJ2Rqa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:46:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40820 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgJ2Rq2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 13:46:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THclXF137785;
        Thu, 29 Oct 2020 17:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=mgzxgjQhD4f4u4u1xj3O7TEPdKFzOgQYF6NmmWxrmwQ=;
 b=R7zJUjafR5Z1/9MhZIlQOtAhzupHYX1noS9qq+lOdCGG4znXY0/ktvckTesRcwVErhHs
 yCBZz+TNDXVNnPAE+Lv4GQbs0Z1Te+DxE2CGAtv4SEfUlfBdyQ1OX1PMI0ocW4shCHTZ
 z8/wPFPiJPvQ/aMIOOkabVC+p/ioXxcNhSPVU9kA1wbawiieEkoDUeI8xWy4aAVXcw+3
 PBv9IhS54RpootPXC0iHdx788zDXhM/+uxtcyjmW8Ouhg1ZmFiG3OLHcJa1Sx3QmmyfP
 1t+rFsiERcih/zKA8ZKbizx5+vsFMz53BJ+Ig7Di6shK5BUIkYxtxoB9dlrlBZWzJiy2 VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm4bsyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 17:46:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THeQFV156127;
        Thu, 29 Oct 2020 17:46:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34cx1tgj4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 17:46:01 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09THjwQW020243;
        Thu, 29 Oct 2020 17:45:58 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 10:45:57 -0700
Subject: Re: [PATCH 7/8] target: make state_list per cpu
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, njavali@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
 <1603954171-11621-8-git-send-email-michael.christie@oracle.com>
Message-ID: <30b3045b-fabc-38e3-bfe4-5731c408c183@oracle.com>
Date:   Thu, 29 Oct 2020 12:45:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1603954171-11621-8-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/29/20 1:49 AM, Mike Christie wrote:
> Do a state_list/execute_task_lock per cpu, so we can do submissions
> from different CPUs without contention with each other.
> 
> Note: tcm_fc was passing TARGET_SCF_USE_CPUID, but never set cpuid.
> I think it wanted to set the cpuid to the CPU it was submitting
> from so it will get this behavior with this patch.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c     |   3 -
>   drivers/target/target_core_device.c    |  16 +++-
>   drivers/target/target_core_tmr.c       | 166 +++++++++++++++++----------------
>   drivers/target/target_core_transport.c |  22 ++---
>   drivers/target/tcm_fc/tfc_cmd.c        |   2 +-
>   include/target/target_core_base.h      |  14 ++-
>   6 files changed, 121 insertions(+), 102 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 784b43f..d225036 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -457,9 +457,6 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
>   	if (bidi)
>   		target_flags |= TARGET_SCF_BIDI_OP;
>   
> -	if (se_cmd->cpuid != WORK_CPU_UNBOUND)
> -		target_flags |= TARGET_SCF_USE_CPUID;
> -
>   	sess = cmd->sess;
>   	if (!sess) {
>   		pr_err("Unable to locate struct fc_port from qla_tgt_cmd\n");

...

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index b228c66..71a6ec3 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1398,6 +1396,7 @@ void transport_init_se_cmd(
>   	cmd->sam_task_attr = task_attr;
>   	cmd->sense_buffer = sense_buffer;
>   	cmd->orig_fe_lun = unpacked_lun;
> +	cmd->cpuid = smp_processor_id();
>   
>   	cmd->state_active = false;
>   }

There is a bug where I am overwriting tcm_qla2xxx's cpuid above. I have 
this fixed in a new version of the patch where I added a "if (cpuid flag 
set)" check.

Since I just sent these last night, I'll wait for other comments to 
resend so I don't flood the list.
