Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A38C3E8C5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 17:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71E0E22242
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 17:45:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ck5WUnD4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732382AbgK0Rpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 12:45:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729305AbgK0Rpl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 12:45:41 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHVZOl115791;
        Fri, 27 Nov 2020 12:45:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ix5xI4eV4ktS+Si1szwX06PnD5N08iIL8loUbC9USd4=;
 b=Ck5WUnD4VSkcQae8Z39rcwtp3VxY9jCxGGmW9h+WloU/eA5Wqah475Bld1ymElcKJOie
 QIwBgd9sItIAu6ZcViM/N6qXyNSUH/ty9TxAEVS5Mqz16mfzvlYtVfUnf06EgOnAIM/0
 NvTgXA667W7Yih/x/FzMhj32X2k78L4AyyfAePklM8X+Yxcrf7DPmAJs+xVFHmu1yHf5
 vqXvjo/WAdInDtd8e22REUjfrQOiYeUZCHTyFPfyTH5Usd8J60KQe9kSWV206alkeZXh
 3+46EP6r3/uhg+0vNeJ2jUUBBGzbVMHbj6yR7APlBn/fr4VXjhC7pAZbyFPp04Q2lZdQ BQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3534yr9nnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 12:45:33 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHgCQA017147;
        Fri, 27 Nov 2020 17:45:32 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 351uh8jnu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 17:45:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARHjUKS20447682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 17:45:30 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA26CC6062;
        Fri, 27 Nov 2020 17:45:30 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47F13C6055;
        Fri, 27 Nov 2020 17:45:30 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.79.105])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 17:45:30 +0000 (GMT)
Subject: Re: [PATCH 02/13] ibmvfc: define hcall wrapper for registering a
 Sub-CRQ
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201126014824.123831-1-tyreld@linux.ibm.com>
 <20201126014824.123831-3-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <0bcfe2f5-21cd-3ac6-aad9-3f345223d400@linux.vnet.ibm.com>
Date:   Fri, 27 Nov 2020 11:45:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201126014824.123831-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_10:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 phishscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

