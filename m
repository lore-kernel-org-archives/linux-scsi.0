Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D072C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 16:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D76A864F13
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 16:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhBZQoM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 11:44:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbhBZQoL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Feb 2021 11:44:11 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11QGXJWI012902;
        Fri, 26 Feb 2021 11:43:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ix5xI4eV4ktS+Si1szwX06PnD5N08iIL8loUbC9USd4=;
 b=irOTXMJe2j0rhwzK2d1SgFN6tLfbRF/Vr/EfeAljdkm4hvNdO4fuq76jxd4Bk3zx7QNr
 6GplXeEVnPv+G6ZEj8PKjMlGRRYuU1WlrW3OWfVVYShw4SqBAMkcZrVxgtgmlw6TCVbF
 Tb4aN3xdFQoFSUaRGNL1UU3b+ap/Zn/9JilDr4amSY8uWoqEJaXWXtzvlrgJwN69dBgO
 kkKAHFaRncoNEeLMYpU+NRYRBnMgv/mc1nz9+97lwxKl1z27Sbi8fKefuIuFHYGVEbCx
 g61SXu5qSM5OClJLeZNsrvYowpT02K2r3mhRFRigT8u5hO+Sh6AQzH5mbpBjevwPv/OL FA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xphv18k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 11:43:24 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11QGXbLe022113;
        Fri, 26 Feb 2021 16:43:23 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 36tt2am1f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 16:43:23 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11QGhNdK32833870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 16:43:23 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1507528059;
        Fri, 26 Feb 2021 16:43:23 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AFEB2805A;
        Fri, 26 Feb 2021 16:43:22 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.115.75])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 26 Feb 2021 16:43:21 +0000 (GMT)
Subject: Re: [PATCH v4 5/5] ibmvfc: reinitialize sub-CRQs and perform channel
 enquiry after LPM
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210225215057.23020-1-tyreld@linux.ibm.com>
 <20210225215057.23020-6-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <97b21163-de62-9913-231b-83e555b04fb8@linux.vnet.ibm.com>
Date:   Fri, 26 Feb 2021 10:43:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210225215057.23020-6-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-26_05:2021-02-26,2021-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=991
 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

