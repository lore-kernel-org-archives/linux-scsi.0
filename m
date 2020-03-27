Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AD1C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A6F20658
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VsY4FS/p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgC0OTW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 10:19:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57196 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgC0OTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 10:19:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02REJHqV196020;
        Fri, 27 Mar 2020 14:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=geQCMwPccqMlO2I7mjX/OXILykNwKh8lM1S7o91X+vg=;
 b=VsY4FS/pV+pY4KbZQ4zmoLlsUeNWtBw85VtIqfdiovAGdYl2RbUDRyCVapXcs7zJOYi+
 OSxReNKnx1dEnPtzPkqbKMzoXooUJbXaUtmdUDEynHWBRDxl+UhEIgMX9JElp3sfLP5z
 xf78iKMvC0WmhHaw5OHsUXLdvT1NEWD93V+ZwxS6AQA/qMllalwOa5ipnsQLlFflmqUs
 PNDwIuY+Ag4/C7WVqvhUnyuzB3KZ1jp7yrflVB0iMu2u3yDghHhyGbiug1pkX1F/r+D8
 PMP3VpTQBlEtUdvfCfO9b5CRyzIrEQndnCnnaU4RMOLqQnEwZgxSE84L8ZDIvVtk3xsd NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 301459bbh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 14:19:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02REGxEA187165;
        Fri, 27 Mar 2020 14:19:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yxw4vxyee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 14:19:11 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02REJA5V008041;
        Fri, 27 Mar 2020 14:19:11 GMT
Received: from [192.168.1.16] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 07:19:10 -0700
Subject: Re: [PATCH 3/3] qla2xxx: delete all sessions before unregister local
 nvme port
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        emilne@redhat.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200327102730.22351-1-njavali@marvell.com>
 <20200327102730.22351-4-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <eb0b8e2f-96cb-61e0-f6fd-e8075bcc0b3f@oracle.com>
Date:   Fri, 27 Mar 2020 09:19:09 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200327102730.22351-4-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270132
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/27/2020 5:27 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Delete all sessions before unregistering local nvme port.  This
> allows nvme layer to decrement all active rport count down to zero.
> Once the count is down to zero, nvme would call qla to continue with
> the npiv port deletion.
> 
> PID: 27448  TASK: ffff9e34b777c1c0  CPU: 0   COMMAND: "qaucli"
>   0 [ffff9e25e84abbd8] __schedule at ffffffff977858ca
>   1 [ffff9e25e84abc68] schedule at ffffffff97785d79
>   2 [ffff9e25e84abc78] schedule_timeout at ffffffff97783881
>   3 [ffff9e25e84abd28] wait_for_completion at ffffffff9778612d
>   4 [ffff9e25e84abd88] qla_nvme_delete at ffffffffc0e3024e [qla2xxx]
>   5 [ffff9e25e84abda8] qla24xx_vport_delete at ffffffffc0e024b9 [qla2xxx]
>   6 [ffff9e25e84abdf0] fc_vport_terminate at ffffffffc011c247 [scsi_transport_fc]
>   7 [ffff9e25e84abe28] store_fc_host_vport_delete at ffffffffc011cd94 [scsi_transport_fc]
>   8 [ffff9e25e84abe70] dev_attr_store at ffffffff974b376b
>   9 [ffff9e25e84abe80] sysfs_kf_write at ffffffff972d9a92
> 10 [ffff9e25e84abe90] kernfs_fop_write at ffffffff972d907b
> 11 [ffff9e25e84abec8] vfs_write at ffffffff9724c790
> 12 [ffff9e25e84abf08] sys_write at ffffffff9724d55f
> 13 [ffff9e25e84abf50] system_call_fastpath at ffffffff97792ed2
>      RIP: 00007fc0bd81a6fd  RSP: 00007ffff78d9648  RFLAGS: 00010202
>      RAX: 0000000000000001  RBX: 0000000000000022  RCX: 00007ffff78d96e0
>      RDX: 0000000000000022  RSI: 00007ffff78d94e0  RDI: 0000000000000008
>      RBP: 00007ffff78d9440   R8: 0000000000000000   R9: 00007fc0bd48b2cd
>      R10: 0000000000000017  R11: 0000000000000293  R12: 0000000000000000
>      R13: 00005624e4dac840  R14: 00005624e4da9a10  R15: 0000000000000000
>      ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 3a5f6f27587e..4cfebf34ad7c 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3055,11 +3055,11 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
>   	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
>   		msleep(1000);
>   
> -	qla_nvme_delete(vha);
>   
>   	qla24xx_disable_vp(vha);
>   	qla2x00_wait_for_sess_deletion(vha);
>   
> +	qla_nvme_delete(vha);
>   	vha->flags.delete_progress = 1;
>   
>   	qlt_remove_target(ha, vha);
> 


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
