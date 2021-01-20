Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004FAC4321A
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 15:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C61732343E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 15:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732600AbhATPhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 10:37:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389676AbhATPhT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Jan 2021 10:37:19 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KFWHve187670;
        Wed, 20 Jan 2021 10:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=R2RIBpwZDEBNU18LwgcUXYyWUxt5dd69H5SvHZw9sNM=;
 b=g/5h4g/dZ8YM6IGo6PhGGccKuuR5Z45eEsOEKbdZSv8uqB36/xFQtz/1zNKt40PruVaB
 IMuGH0iE6B0SGTWSQhlXVYVhId5OVtX38CMckNzBt4pPPFNCwN9xY71QLSKShl0KjJcc
 ziOnFUC2c/7CMEcQhc07tDz04kXB0oD2MFJDc7CGMTGUi7DFfL0ydRDOj4aTHhklxWbL
 fU1OxjeIk+o6x3v62P+E8ytnrJjdmQhLX0uG5wfEVvEtWSE4HP4mBbpcxMc3BCSVP9BP
 timPICzt6b9J3uM77fmLFUHek2lG22+jRXgW4OT7XgLkbgGHWDt3XY+5Yg5UxhE4Os2X 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366q8887m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 10:36:34 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KFWJPU187854;
        Wed, 20 Jan 2021 10:36:34 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366q8887jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 10:36:34 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KFOSGQ019434;
        Wed, 20 Jan 2021 15:36:32 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3668rv56rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 15:36:32 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KFaVHs37683602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 15:36:31 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6F6B7805E;
        Wed, 20 Jan 2021 15:36:31 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BFFB78060;
        Wed, 20 Jan 2021 15:36:30 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.161.248])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 15:36:29 +0000 (GMT)
Message-ID: <9829db9b8e207f5ffc57cfbe19a0d3b4d341a302.camel@linux.ibm.com>
Subject: Re: [PATCH] drivers/scsi/qla4xxx: use scnprintf() instead of
 snprintf()
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>, njavali@marvell.com
Cc:     mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 20 Jan 2021 07:36:28 -0800
In-Reply-To: <1611127365-45929-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611127365-45929-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_06:2021-01-20,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101200090
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-01-20 at 15:22 +0800, Jiapeng Zhong wrote:
> Fix the following coccicheck warning:
> 
> ./drivers/scsi/qla4xxx/ql4_attr.c: WARNING: use scnprintf or
> sprintf
> 
> The snprintf() function returns the number of characters which would
> have been printed if there were enough space, but the scnprintf()
> returns the number of characters which were actually printed.  If
> the buffer is not large enough, then using snprintf() would result
> in a read overflow and an information leak.
> 
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> ---
>  drivers/scsi/qla4xxx/ql4_attr.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_attr.c
> b/drivers/scsi/qla4xxx/ql4_attr.c
> index ec43528..1a16017 100644
> --- a/drivers/scsi/qla4xxx/ql4_attr.c
> +++ b/drivers/scsi/qla4xxx/ql4_attr.c
> @@ -170,7 +170,7 @@ void qla4_8xxx_free_sysfs_attr(struct
> scsi_qla_host *ha)
>  			char *buf)
>  {
>  	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
> -	return snprintf(buf, PAGE_SIZE, "%s\n", ha->serial_number);
> +	return scnprintf(buf, PAGE_SIZE, "%s\n", ha->serial_number);

This is the wrong ABI to be replacing anything sysfs with, it should be
sysfs_emit()

James


