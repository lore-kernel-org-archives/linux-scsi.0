Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D54C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 18:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 318966105A
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 18:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJNSdW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 14:33:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2544 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230494AbhJNSdV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 14:33:21 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EHlsWo022285;
        Thu, 14 Oct 2021 14:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=R2asSbv+NdyzUsI8Jr1RnJVPyY3zko2/IqpUCEiFIXc=;
 b=CqRQGVXM8rNRUcvaIlERsRCPkFxTZLreNxbUZD9iGdzOlpRBTuiiihmQ016h21JM9A4G
 jwyGj4Zxy85Gw9kwU/tmLhCK0T7gLaFn/AmW9w3+ff7c2XeiphJrQ931xKmEdSXTCZLW
 uBlZTz2u6lxmhXRjnqyKbH2sZGZ4P4ZfdS8VK1472+7EKtMhU28GRJHpWcWYf1WeS0od
 xAEDsS16rGBabywio6wopMaKptiCbn+Hl+7FzrG5eMj0ZYHehK0xMV2AwYtt+N2/dEBk
 0Jq9KpPSSDXp5NvSeLuXv6C2OwDXUlRTxjJuybq6egkCQhqm7exq3Nd1t4ouwdy5pdy5 xA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bps920u4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 14:31:05 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EIHqLW006006;
        Thu, 14 Oct 2021 18:31:05 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 3bkeq8r5ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 18:31:05 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19EIV4N114090580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 18:31:04 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EFD5B2066;
        Thu, 14 Oct 2021 18:31:04 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EC78B2068;
        Thu, 14 Oct 2021 18:31:03 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.220.106])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 18:31:03 +0000 (GMT)
Subject: Re: [PATCH v4 24/46] scsi: ibmvfc: Switch to attribute groups
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211012233558.4066756-1-bvanassche@acm.org>
 <20211012233558.4066756-25-bvanassche@acm.org>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <a1ac5d9a-5536-0be1-ad9a-f0cbbf060c85@linux.ibm.com>
Date:   Thu, 14 Oct 2021 11:31:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012233558.4066756-25-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yjcXZ_NmN9VUcsthmgab0nduL0pVJ6zY
X-Proofpoint-GUID: yjcXZ_NmN9VUcsthmgab0nduL0pVJ6zY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_09,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140104
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

