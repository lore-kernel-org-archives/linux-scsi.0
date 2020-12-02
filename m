Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36ECC64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 16:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9822321D7A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 16:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgLBQA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 11:00:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727106AbgLBQA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 11:00:58 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2FlHsm131084;
        Wed, 2 Dec 2020 11:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ix5xI4eV4ktS+Si1szwX06PnD5N08iIL8loUbC9USd4=;
 b=nsB7YB15ipQBreJGZkiwN0XbG2LBNzH2DL294GudnK0QelGbvRwXCuvCHtrd5Bt/+5MG
 pCbWiL/it9FIaG0UHc9psoqReFqXkaB2l9xOpPMfuOu8gVivfrww0IG6uKEYQHPTnHdd
 OnzuDBI75KOZFom7PNwNRFrt0vqbugUR8GolykImVtvvZE2jIXt3tjOl7YKe7nTt2sq/
 AFqTRrMCa5jAMhPgavMkjd+fE31Th0NO07z4uk/12lOSpPPuWpLSRSGEeiUyWTWqhsRC
 u0VHWHwiDEQ535xzPZiQh1XM45gxas/ATDc4RxUl9r3zr3SPqBEb3xmTu2vk/uNBt6Bs Zg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355sr5vdan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 11:00:10 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B2FWWEP004650;
        Wed, 2 Dec 2020 16:00:09 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 353e69hvgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 16:00:09 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B2G09Yl40960468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 16:00:09 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F105FAE064;
        Wed,  2 Dec 2020 16:00:08 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23A5AAE066;
        Wed,  2 Dec 2020 16:00:08 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.78.151])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Dec 2020 16:00:07 +0000 (GMT)
Subject: Re: [PATCH v2 14/17] ibmvfc: add cancel mad initialization helper
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201202005329.4538-1-tyreld@linux.ibm.com>
 <20201202005329.4538-15-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <fdcd6adf-be55-7319-e98b-5d5217fa2410@linux.vnet.ibm.com>
Date:   Wed, 2 Dec 2020 10:00:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201202005329.4538-15-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

