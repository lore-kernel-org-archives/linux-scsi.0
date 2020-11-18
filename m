Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B041BC63697
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 00:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8312465E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 00:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r+HDpBQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgKRAmz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 19:42:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64082 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725943AbgKRAmz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 19:42:55 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI0VT7a030737;
        Tue, 17 Nov 2020 19:42:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AE67dAyv0KV79MuSZmGwNBXOy19NH6vZIZZD4/aWxig=;
 b=r+HDpBQ0UDF5DulNEGgvRF1fsptICfZaKeUo9duW1zWvNLRUZVnofUtaw/jSd8cqr9c6
 yEi5Vp69Ezb+nJUOl/oGksJS60xx5JFQHo+Twv4JAb7t2w5w4mS0jgLVpZPQjrZUnw33
 QAFH/zC9zMxZYqQ9CFlVf3HeRYFwYP+qsMVnhlFs0xWq7YVUzUtOT8yxGcA+1EwVwRHM
 Re3t/YJm796JTaP5AQGCLIYAKH4bGGLezUUGUxp1vwX4QoLKlAeIyWyTmGbY5dK3izxM
 i6oA2OW6+vQfmyro8jFh9ZdbKsVez3FQaGf4Vl6C1w/Tv5mvzfF/Oi7otJyEVoE6YHb5 Xw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ve31w8u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 19:42:47 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AI0gaSO007504;
        Wed, 18 Nov 2020 00:42:47 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 34vgjmc1da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 00:42:47 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AI0gkZ03605178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 00:42:46 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 001FE28060;
        Wed, 18 Nov 2020 00:42:45 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A20EC28058;
        Wed, 18 Nov 2020 00:42:44 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.230.183])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 18 Nov 2020 00:42:44 +0000 (GMT)
Subject: Re: [PATCH v2 0/6] ibmvfc: Protocol definition updates and new
 targetWWPN Support
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201117191636.131127-1-tyreld@linux.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <e6354cec-787e-e1d1-409e-c06d81f89ac6@linux.ibm.com>
Date:   Tue, 17 Nov 2020 16:42:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201117191636.131127-1-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_15:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=608 suspectscore=1 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170179
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/20 11:16 AM, Tyrel Datwyler wrote:
> Several Management Datagrams (MADs) have been reversioned to add a targetWWPN
> field that is intended to better identify a target over a scsi_id. Further, a
> couple new MADs have been introduced to the protocol to be used for negotiation
> of channels/hw queues resources when the VIOS is using SLI-4 capable adapters.
> 
> This patchset adds the new protocol definitions and implements support for using
> the new targetWWPN field and exposing the capability to the VIOS. This
> targetWWPN support is a prerequisuite for upcoming channelization/MQ support.
> 
> changes in v2:
> 	Removed bug fixes to separate patchset
> 	Fixed up checkpatch warnings

Need to spin a v3 to address comments from Brian King, some commit log typos,
and a badly rebased Patch 5 that doesn't even compile.

-Tyrel
