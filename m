Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CD0C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 18:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7766B611C0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 18:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJNSdM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 14:33:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230181AbhJNSdM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 14:33:12 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EHmXmD014903;
        Thu, 14 Oct 2021 14:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=R2asSbv+NdyzUsI8Jr1RnJVPyY3zko2/IqpUCEiFIXc=;
 b=ZZL8bSRADTbgniAdJB42hEe2+o5jppejFCJzgUlb72PRbzUOnbi7qp4tZU5qahpqCVUX
 LskVud4jRhzm+kfyka1e3R68muCFkwkt1ImKxJJ9+o+EbuAapKHIuIhAkHIQHiSLQX8X
 twX09uVNnM5nZ86Tff+wd1cdA+ggijOLla2Iae489hbqjUVQ8h8NziyhTMX+GIgio19i
 qXUAgJXNABMCe6dqzsfTcvXoaS0L4RQwePkIr0XYhvlC97W6NSJkHn+evm0qFwNwnjQb
 uXzaJ6iAENjt9a0qYBs2lRjiI7eVtgTsayPX+7v3MHD0mRt5USfK7G1+LC8XTS8+qhhf OQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnqmqdns7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 14:30:55 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EIHh7R017125;
        Thu, 14 Oct 2021 18:30:35 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 3bnm3a0snj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 18:30:35 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19EIUZnP54198548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 18:30:35 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F6EFB2064;
        Thu, 14 Oct 2021 18:30:35 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5C40B2068;
        Thu, 14 Oct 2021 18:30:34 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.220.106])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 18:30:34 +0000 (GMT)
Subject: Re: [PATCH v4 23/46] scsi: ibmvscsi: Switch to attribute groups
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211012233558.4066756-1-bvanassche@acm.org>
 <20211012233558.4066756-24-bvanassche@acm.org>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <f9187e49-0079-7a51-81bb-16ab65a08fd8@linux.ibm.com>
Date:   Thu, 14 Oct 2021 11:30:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012233558.4066756-24-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GGoK23731zGGMX14QuqNTosICvs4f6NN
X-Proofpoint-ORIG-GUID: GGoK23731zGGMX14QuqNTosICvs4f6NN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_10,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1011 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110140101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/21 4:35 PM, Bart Van Assche wrote:
> struct device supports attribute groups directly but does not support
> struct device_attribute directly. Hence switch to attribute groups.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
