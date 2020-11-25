Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E9DC56202
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 17:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E362083E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 17:04:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QHP4fQ+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbgKYREX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 12:04:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731040AbgKYREX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 12:04:23 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0APH2P7l169603;
        Wed, 25 Nov 2020 12:04:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=ONdEbafrjKnm9FRn4qnebqbuL9ulbRiyTVkfSL0+RX4=;
 b=QHP4fQ+hSHizsmsdKmsX6hsLEmF6Jxnh1vSUsaFaJVwYOchdLbb2Hw8835Z3I96qD62T
 9cJvg2JKaADTEFOpl4/7elQHV1z1Zrz+E1ohSTXKZ4IKDpZQEfX6BXPqGARo+NfJIGdi
 Z6cDlc+jQuijnr9LE+1qPtnmcIjVtvDECA7YunjIhNh72+mPllgJpgrp27jjJUmYu+n9
 vLL6sobKnu/19uGlTNggrqjWEP0zUXqZVGtmZzBVGteeQrFccy1f1ipaIuhJMvA32Ixz
 on/xKNiS6OwHupRtvPjDJWuxuQqff1xd05hX9yBysZWbyWeMhPzswJUipZmpuMc0Lj3H GQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 351ry9necw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 12:04:15 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0APH1Nw7001157;
        Wed, 25 Nov 2020 17:04:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3518j8gw9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 17:04:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0APH4Asn63832412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 17:04:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D72F611C052;
        Wed, 25 Nov 2020 17:04:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C542511C04C;
        Wed, 25 Nov 2020 17:04:10 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.2.194])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Nov 2020 17:04:10 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1khyDB-002ZW3-SE; Wed, 25 Nov 2020 18:04:09 +0100
Date:   Wed, 25 Nov 2020 18:04:09 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: zfcp: fix use-after-free in
 zfcp_sysfs_port_remove_store
Message-ID: <20201125170409.GA8578@t480-pf1aa2c2>
References: <20201120074853.31706-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201120074853.31706-1-miaoqinglang@huawei.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-25_10:2020-11-25,2020-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250104
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 20, 2020 at 03:48:53PM +0800, Qinglang Miao wrote:
> kfree(port) is called in put_device(&port->dev) so that following
> use would cause use-after-free bug.
> 
> the former put_device is redundant for device_unregister contains
> put_device already. So just remove it to fix this.
> 
> Fixes: 83d4e1c33d93 ("[SCSI] zfcp: cleanup port sysfs attribute usage")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/s390/scsi/zfcp_sysfs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
> index 8d9662e8b..06285e452 100644
> --- a/drivers/s390/scsi/zfcp_sysfs.c
> +++ b/drivers/s390/scsi/zfcp_sysfs.c
> @@ -327,8 +327,6 @@ static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
>  	list_del(&port->list);
>  	write_unlock_irq(&adapter->port_list_lock);
>  
> -	put_device(&port->dev);
> -
>  	zfcp_erp_port_shutdown(port, 0, "syprs_1");
>  	device_unregister(&port->dev);
>   out:

Hmm, the placement of the put_device() is indeed strange, now that I
think about it. But just removing it and then having a dangling
reference also seems wrong - we do get one explicitly in
`zfcp_get_port_by_wwpn()`.

My first thought would be to move it after the `device_unregister()`
call, and before the `out:` label.


-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
