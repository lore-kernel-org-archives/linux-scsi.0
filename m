Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC56EC5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 17:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AAD8221FD
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 17:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eER3WRTg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732551AbgK0Ru0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 12:50:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731612AbgK0RuZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 12:50:25 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHVVsJ101636;
        Fri, 27 Nov 2020 12:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ix5xI4eV4ktS+Si1szwX06PnD5N08iIL8loUbC9USd4=;
 b=eER3WRTgDZ3j6VNr3eUW7i5A4SpZ4caWwaY5hrGflDftlq8gf6XfxnxOVUdAIM0boXr1
 u8GvVbarOMLdBh1m+w+k0QJ9irgZmweAZtpA0UXsigFw/8w+k8wJrlF8nqs2+Ht0mUHV
 lG0bUxLte4mynb/syRdztWoR3Rz+viiOI9/Ud5dnCbcEzqFVeqPamo3MgE77+eQnjPvP
 8WvwbyEHJufaMjJBQHD31YLdDAyRcmLr9Dh48Qo5eX+syTw5TMnSzSIX9kfS6RfykCN2
 +l4TCg8uM9OXG9W+Qw4b85nOu5ChqvmVSib3ilpEwKzUg8QdIl+3zLJMaAjpfwMffEnH kg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35304w9un5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 12:50:16 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHg19c031565;
        Fri, 27 Nov 2020 17:50:00 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 34xtha4ah8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 17:50:00 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARHnx3Z11534956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 17:49:59 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F14ADC605D;
        Fri, 27 Nov 2020 17:49:58 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72013C605B;
        Fri, 27 Nov 2020 17:49:58 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.79.105])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 17:49:58 +0000 (GMT)
Subject: Re: [PATCH 10/13] ibmvfc: advertise client support for using hardware
 channels
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201126014824.123831-1-tyreld@linux.ibm.com>
 <20201126014824.123831-11-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <0d8e3caa-99eb-a94d-1821-4264c1fe46a3@linux.vnet.ibm.com>
Date:   Fri, 27 Nov 2020 11:49:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201126014824.123831-11-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_10:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

