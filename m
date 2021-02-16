Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08CAC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 14:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8147E64DF5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 14:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhBPOkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Feb 2021 09:40:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230305AbhBPOjx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Feb 2021 09:39:53 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11GEZUEc051715;
        Tue, 16 Feb 2021 09:39:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ix5xI4eV4ktS+Si1szwX06PnD5N08iIL8loUbC9USd4=;
 b=gMzCO/qcyzVEvg/TocQu4V6G+fSEk6lRzbp0oAhI3ZvaIM8tSWEj82WfTKu0Tey2jOkn
 WKnWeID2805aCiLtTYrKbbq7HANDn7Qt3vXS1Acsl364xejF2DtW7wKQwSnj5ZeL/Cad
 YRjI7I+qqDHAYvRMXVKk52eTfNuFl/FT2BaV+RnajBpJjUI3ywq7qsN9Uy5Tu1SWZ+2S
 wxFnc9kkthOdUGov7yxORbfcKkuY1zPgwLJ8y2/gIMD5ffIo9bhR4B0d7rBTuoBnSjSV
 mWjomY4Ir3WQ2KCoVmL+sgmhSRb5/EBksdaWhvxslViYwZnzmr22G3wb4mrJJBPZBdXW Hw== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36rdr5vbbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 09:39:04 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11GEb4gw007619;
        Tue, 16 Feb 2021 14:39:03 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 36p6d9cnbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 14:39:03 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11GEd2ER6489054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 14:39:02 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B767112065;
        Tue, 16 Feb 2021 14:39:02 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C971112061;
        Tue, 16 Feb 2021 14:39:01 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.23.155])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Feb 2021 14:39:01 +0000 (GMT)
Subject: Re: [PATCH 2/4] ibmvfc: fix invalid sub-CRQ handles after hard reset
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210211185742.50143-1-tyreld@linux.ibm.com>
 <20210211185742.50143-3-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <9c53ed35-7f15-8c4a-7cab-378278444ab4@linux.vnet.ibm.com>
Date:   Tue, 16 Feb 2021 08:39:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210211185742.50143-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_04:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=882 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

