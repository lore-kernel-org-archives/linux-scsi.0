Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C678C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 22:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD1C32339E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 22:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbhANWm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:42:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728452AbhANWm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 17:42:57 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EMVwve071300;
        Thu, 14 Jan 2021 17:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ix5xI4eV4ktS+Si1szwX06PnD5N08iIL8loUbC9USd4=;
 b=tAjtKcdmoxSqp46w+9J3DD89vfoK0l3BlYLn2SZl+xjV1lH/n3DK7pgM2gL3uNim39jF
 lM9/EwpQUIH6/ZUnTufH6b6pFlydC14OzTC9MefhgKAQu9pDfqmHokmcolE0SeJgX3Pj
 gumfQtIEdD6COYvW5mhod0ExWTNsH23Q12YI0g6s4VZL0R9UDSdcKueOUcFXv1PgYp2g
 GtT4TxfRTPzh+Y5Cywf23HXLKaikR+H4dXvXJ1yMrAKkXskt669MG2p5ig5bZH3hKyAM
 nJaTf4Jy/znfwRfL7kbAOCdfGz+EpAZNp7owi0gnKLkJXrtBttwQi8FGBCGgxOkWJAoL 9g== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362xm8gjsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 17:42:09 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EMZI78002451;
        Thu, 14 Jan 2021 22:42:09 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 35y449gfuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 22:42:09 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EMg7CK19202514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 22:42:07 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C41DC6D51;
        Thu, 14 Jan 2021 22:42:07 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE631C6D47;
        Thu, 14 Jan 2021 22:42:06 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.16.139])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 22:42:06 +0000 (GMT)
Subject: Re: [PATCH v5 18/21] ibmvfc: send Cancel MAD down each hw scsi
 channel
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210114203148.246656-1-tyreld@linux.ibm.com>
 <20210114203148.246656-19-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <6717b277-f4a0-5379-2c0f-d19b426254b8@linux.vnet.ibm.com>
Date:   Thu, 14 Jan 2021 16:42:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210114203148.246656-19-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_10:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140126
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

