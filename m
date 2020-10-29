Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430A6C4741F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78DD20756
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KQdh9Nx3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgJ2U3G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:29:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35478 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2U3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 16:29:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKSbHJ091149;
        Thu, 29 Oct 2020 20:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=9EWWwjuo8uGJP735lozWCy00h9jVEqAdxObH1eLL55k=;
 b=KQdh9Nx3ffpWc3UW0G7Mk+Rx0RW8sFaAtJ1E57s2fee+TGSyq7uw6ScuNO4PdDF7OP3v
 B8rcI4m+4onJx39P5ItUsLu4hy1LlOTy00/qnF57So2LOKlURFrqAVHKF3HZhX0lEKnT
 1SvbCM6OhFL58SgiAm/6I0W5lA44Hx2IAiW4JEzE84nh7oPI9JR0viUZvpx6Bsqt+cqr
 JhSRnmDxyBdnzn3QhXD3qvzanW03RAfxi9CdJZHPcOfhX0iRkZ5YRmEfZUrOGhE/wwh8
 fUH7mYMhZPCqOfo72GYeQFzwYLiJojZv+XGMVAqQNsaBRTR1a477Z2hueYuTFsvjXoUf qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm4cgg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:29:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKLRdF183186;
        Thu, 29 Oct 2020 20:29:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6yw6yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:29:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TKT2Pq015101;
        Thu, 29 Oct 2020 20:29:02 GMT
Received: from dhcp-10-154-184-179.vpn.oracle.com (/10.154.184.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:29:02 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 7/8] target: make state_list per cpu
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <30b3045b-fabc-38e3-bfe4-5731c408c183@oracle.com>
Date:   Thu, 29 Oct 2020 15:29:02 -0500
Cc:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <861D52A1-1752-4FA1-92E4-5FCEE023D214@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
 <1603954171-11621-8-git-send-email-michael.christie@oracle.com>
 <30b3045b-fabc-38e3-bfe4-5731c408c183@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=3 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290142
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 29, 2020, at 12:45 PM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> On 10/29/20 1:49 AM, Mike Christie wrote:
>> Do a state_list/execute_task_lock per cpu, so we can do submissions
>> from different CPUs without contention with each other.
>> Note: tcm_fc was passing TARGET_SCF_USE_CPUID, but never set cpuid.
>> I think it wanted to set the cpuid to the CPU it was submitting
>> from so it will get this behavior with this patch.
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |   3 -
>>  drivers/target/target_core_device.c    |  16 +++-
>>  drivers/target/target_core_tmr.c       | 166 =
+++++++++++++++++----------------
>>  drivers/target/target_core_transport.c |  22 ++---
>>  drivers/target/tcm_fc/tfc_cmd.c        |   2 +-
>>  include/target/target_core_base.h      |  14 ++-
>>  6 files changed, 121 insertions(+), 102 deletions(-)
>> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c =
b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> index 784b43f..d225036 100644
>> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> @@ -457,9 +457,6 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t =
*vha, struct qla_tgt_cmd *cmd,
>>  	if (bidi)
>>  		target_flags |=3D TARGET_SCF_BIDI_OP;
>>  -	if (se_cmd->cpuid !=3D WORK_CPU_UNBOUND)
>> -		target_flags |=3D TARGET_SCF_USE_CPUID;
>> -
>>  	sess =3D cmd->sess;
>>  	if (!sess) {
>>  		pr_err("Unable to locate struct fc_port from =
qla_tgt_cmd\n");
>=20
> ...
>=20
>> diff --git a/drivers/target/target_core_transport.c =
b/drivers/target/target_core_transport.c
>> index b228c66..71a6ec3 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -1398,6 +1396,7 @@ void transport_init_se_cmd(
>>  	cmd->sam_task_attr =3D task_attr;
>>  	cmd->sense_buffer =3D sense_buffer;
>>  	cmd->orig_fe_lun =3D unpacked_lun;
>> +	cmd->cpuid =3D smp_processor_id();
>>    	cmd->state_active =3D false;
>>  }
>=20
> There is a bug where I am overwriting tcm_qla2xxx's cpuid above. I =
have this fixed in a new version of the patch where I added a "if (cpuid =
flag set)" check.
>=20
> Since I just sent these last night, I'll wait for other comments to =
resend so I don't flood the list.

:) you caught your own error.

Other parts of patch looks good. Once you fix it Please add

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

