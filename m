Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C28C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 01:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12CAD20738
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 01:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m3Zqlia+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgFCBcl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 21:32:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42540 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFCBck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 21:32:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0531SNAq088939;
        Wed, 3 Jun 2020 01:31:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=/VqIWsQJCRuNm9QmFUcI5MVBJ1+PNqJu4INvjofmiUE=;
 b=m3Zqlia+iNC+L6X8DHaZCHC9LA0LD1IjtCpDbc6ORaq9XTlcgcOlr+zZ8Cuc1dqLcZwb
 b1p62qaWXJ4lXP0MT1k+e7LSaVE2AUlk9xItH3sHNkvGqKoaLbqb9N+CeNYqYIFNms/b
 F/6NNo/5AFjN/nW/RPEZ3OtvmvOToXOsKmKAETmteOm1HuGFUgc6zp3F0NL5yE+GOeKC
 oHTqocGvXkt+sol6rEsBPAYF6tBtm/fd5iPRdXTXV0UUHFaW1hddE6qiYoldx+8lSKgf
 QX2dJHx/3tYd/yk3Z84QvPcO1xQGPuN8Jhe/BqoK0zJxm4/aOb7y7XsKkr+TwUoW0ixm Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31bewqxshk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 01:31:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0531Rv5j057807;
        Wed, 3 Jun 2020 01:31:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31c25qjttn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 01:31:39 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0531VaN2022948;
        Wed, 3 Jun 2020 01:31:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 18:31:36 -0700
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     xiakaixu1987@gmail.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoming Gao <newtongao@tencent.com>
Subject: Re: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused
 by JBOD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dwp9bss.fsf@ca-mkp.ca.oracle.com>
References: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
Date:   Tue, 02 Jun 2020 21:31:33 -0400
In-Reply-To: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
        (xiakaixu's message of "Thu, 28 May 2020 15:31:55 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=1 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> when kernel crash, and kexec into kdump kernel, megaraid_sas will hung
> and print follow error logs
>
> 24.1485901 sd 0:0:G:0: [sda 1 tag809 BRCfl Debug mfi stat 0x2(1, data len requested/conpleted 0X100
> 0/0x0)]
> 24.1867171 sd 0:0:G :9: [sda I tag861 BRCfl Debug mfft stat 0x2d, data len reques ted/conp1e Led 0X100
> 0/0x0]
> 24.2054191 sd 0:O:6:O: [sda 1 tag861 FAILED Result: hustbyte=DIDGK drioerbyte-DRIUCR SENSE]
> 24.2549711 bik_update_ request ! 1/0 error , dev sda, sector 937782912 op 0x0:(READ) flags 0x0 phys_seg 1 prio class
> 21.2752791 buffer_io_error 2 callbacks suppressed
> 21.2752731 Duffer IO error an dev sda, logical block 117212064, async page read
>
> this bug is caused by commit '59db5a931bbe73f ("scsi: megaraid_sas:
> Handle sequence JBOD map failure at driver level ")' and can be fixed
> by not set JOB when reset_devices on

Broadcom: Please review.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
