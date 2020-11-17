Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19174C63697
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 22:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73913241A7
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 22:23:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="J8TGxg8J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgKQWX0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 17:23:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63196 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728928AbgKQWXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 17:23:25 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHM2UQO141041;
        Tue, 17 Nov 2020 17:23:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=h8IAoc/2erbo5y/+8cyz47rQpuAVhFzgrZwxWyqbEdI=;
 b=J8TGxg8JywvTfanKjYuUmisaPaZ3E+QHqrXOc5BlNvTwzgtDNtMlUgRhHtjAmJYLZyP6
 KlLg9blb5KTr8CYGZ4YEWhBEaMezpG1dTUUUzGQ8UeT7m6VtYorySptM1CjI/9QE6Wjx
 MSGdMwX7HqmN2wcsVoP7cDrdMMkVW7Shsty9YlBfXV+QThV4L1mnIzjmqdKNnWfmc4uX
 +KcZtqLDwVYE+bT4U7kGRvJqLhKKgKlheL0wS41QKT+3BjgBuvoXhjEyzIzD3Hz7fSFT
 z747UuLEEayjJGIVXw+Vv8R253aOBcdFl5/5tYh+OzhclmFQsp3CgNdyIcnU6Q94BPPR 0Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vb0w0eyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 17:23:20 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHMMcrw007260;
        Tue, 17 Nov 2020 22:23:19 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 34vgjmb5ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 22:23:19 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHMNH3g11076114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 22:23:17 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76D42BE053;
        Tue, 17 Nov 2020 22:23:17 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09655BE051;
        Tue, 17 Nov 2020 22:23:16 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.40.231])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 22:23:16 +0000 (GMT)
Subject: Re: [PATCH 6/6] ibmvfc: advertise client support for targetWWPN using
 v2 commands
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201112010442.102589-1-tyreld@linux.ibm.com>
 <20201112010442.102589-6-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <b7662270-4875-0a25-d1f3-ea778059f64e@linux.vnet.ibm.com>
Date:   Tue, 17 Nov 2020 16:23:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201112010442.102589-6-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_09:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=931
 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Everything else in this series looks OK to me.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

