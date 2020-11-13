Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45B4C55ABD
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 19:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BB0D22248
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 19:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iCQz/8Sk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKMTj4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Nov 2020 14:39:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgKMTjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Nov 2020 14:39:55 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADJVUKv069329;
        Fri, 13 Nov 2020 14:39:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nPwIVS1T6ImUpr2jIqRuuKKMr+2ETbA+Gq0kZ/tqCVg=;
 b=iCQz/8SkXOg3XXaQfJVahDrDIbsIRLkFMBws6norJAThObkrjTT1s6b/78/nG0xDnq5I
 bPi21MUX+5A+1OTYTW5PeYLH7VGKmy39Y5kkNEyYx+TdCNhsr2E9mVQPLg0+3qpp3HwA
 dnbDtRMUpPDvQXNA0FHqxUIm6nbVd22LyDZ5Rzy3BPitmgx+DhnUOjL/IzGPGt4VfNNC
 5rCGNaO1t8jRy7RFc39ISjDoqwa+tDTtbdPTl+6B7Fi6jVbgpTVsuGjjZVEnfcCkAWim
 M5EyqJZzWG1U0+Ar5vLSn6aO8Uv8fODwUDnyS9ga7x3PHQFH750bCOo9ySfdimaJQ7wA yQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34sxs2bj10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 14:39:40 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADJbWWE012766;
        Fri, 13 Nov 2020 19:39:39 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 34nk7ajmw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 19:39:39 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADJdcRg20513420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 19:39:38 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86D9F28058;
        Fri, 13 Nov 2020 19:39:38 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C573A28059;
        Fri, 13 Nov 2020 19:39:36 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.230.183])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 19:39:36 +0000 (GMT)
Subject: Re: [PATCH 1/6] ibmvfc: byte swap login_buf.resp values in attribute
 show functions
To:     Christoph Hellwig <hch@infradead.org>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
References: <20201112010442.102589-1-tyreld@linux.ibm.com>
 <20201112093752.GA24235@infradead.org>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <7df9d768-e008-a849-5fbd-78d6bd0536fa@linux.ibm.com>
Date:   Fri, 13 Nov 2020 11:39:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201112093752.GA24235@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_17:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 clxscore=1011 suspectscore=0 mlxlogscore=999
 adultscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/12/20 1:37 AM, Christoph Hellwig wrote:
> On Wed, Nov 11, 2020 at 07:04:37PM -0600, Tyrel Datwyler wrote:
>> Both ibmvfc_show_host_(capabilities|npiv_version) functions retrieve
>> values from vhost->login_buf.resp buffer. This is the MAD response
>> buffer from the VIOS and as such any multi-byte non-string values are in
>> big endian format.
>>
>> Byte swap these values to host cpu endian format for better human
>> readability.
> 
> The whole series creates tons of pointlessly over 80 char lines.
> Please do a quick fixup.
> 

The checkpatch script only warns at 100 char lines these days. To be fair though
I did have two lines go over that limit by a couple characters, there are a
couple commit log typos, and I had an if keyword with no space after before the
opening parenthesis. So, I'll happily re-spin.

However, for my info going forward is the SCSI subsystem sticking to 80 char
lines as a hard limit?

-Tyrel
