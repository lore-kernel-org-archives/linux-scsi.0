Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF14C63697
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 00:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BDEE21D91
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 00:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="d2Q5qnD0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgKRAeW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 19:34:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbgKRAeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 19:34:22 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI0Va7T019736;
        Tue, 17 Nov 2020 19:34:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WloHQdcmYyUMLpwOdVXWfLky5lvL+h4HkGaCVtd4WBM=;
 b=d2Q5qnD0uoL+t2eYmDclogxYCYvCj092VzPDXKH1KjmQ1vAQprEQbLAAqkWmi2SrlkOe
 XMem/r0bxcFblIhXSQfTUBJXiRFePDm7X8VGTFnjzNoBKwYtW8nLD9fOT7a5q85IJ3TE
 Hc7yL8ZGpWYC9GrvevNUh6HVrokbbo0xlMQLSSFMwQGTJe5j/jSkd/UKflGTY1GNbL7q
 dS1Rt5Ifr6GNXzRIhIKv9wLXJjom6XtfU+bYUfww6MsQK+9BeZBLbo1KiHoqQm1dn1za
 odjE0NSIfOt9ff7b1Q9c/KaCDxDBtewvHoTSstXVjfc4SG/IfVh50GTDGTvwhJhp9pDX Uw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34v9626dpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 19:34:17 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AI0RhHw029550;
        Wed, 18 Nov 2020 00:34:16 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 34t6v9gvmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 00:34:16 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AI0YFHx000678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 00:34:15 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88B8F2805A;
        Wed, 18 Nov 2020 00:34:15 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F6412805C;
        Wed, 18 Nov 2020 00:34:12 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.230.183])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 18 Nov 2020 00:34:11 +0000 (GMT)
Subject: Re: [PATCH 4/6] ibmvfc: add FC payload retrieval routines for
 versioned vfcFrames
To:     Brian King <brking@linux.vnet.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201112010442.102589-1-tyreld@linux.ibm.com>
 <20201112010442.102589-4-tyreld@linux.ibm.com>
 <9e38f449-d2e6-6408-4fef-cfb5351393cc@linux.vnet.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <a590f3c6-43a0-854b-13f8-dad13b249795@linux.ibm.com>
Date:   Tue, 17 Nov 2020 16:34:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <9e38f449-d2e6-6408-4fef-cfb5351393cc@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_15:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170179
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/20 2:14 PM, Brian King wrote:
> On 11/11/20 7:04 PM, Tyrel Datwyler wrote:
>> The FC iu and response payloads are located at different offsets
>> depending on the ibmvfc_cmd version. This is a result of the version 2
>> vfcFrame definition adding an extra 64bytes of reserved space to the
>> structure prior to the payloads.
>>
>> Add helper routines to determine the current vfcFrame version and
>> returning pointers to the proper iu or response structures within that
>> ibmvfc_cmd.
>>
>> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c | 76 ++++++++++++++++++++++++----------
>>  1 file changed, 53 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index aa3445bec42c..5e666f7c9266 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -138,6 +138,22 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
>>  
>>  static const char *unknown_error = "unknown error";
>>  
>> +static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *vhost, struct ibmvfc_cmd *vfc_cmd)
>> +{
>> +	if (be64_to_cpu(vhost->login_buf->resp.capabilities) & IBMVFC_HANDLE_VF_WWPN)
> 
> Suggest adding a flag to the vhost structure that you setup after login in order to
> simplify this check and avoid chasing multiple pointers along with a byte swap.
> 
> Maybe something like:
> 
> vhost->is_v2

I considered that, but opted instead in my v2 respin to add a helper routine to
test login response capabilities since we will also need to check for VIOS
channel support.

-Tyrel

> 
>> +		return &vfc_cmd->v2.iu;
>> +	else
>> +		return &vfc_cmd->v1.iu;
>> +}
>> +
>> +static struct ibmvfc_fcp_rsp *ibmvfc_get_fcp_rsp(struct ibmvfc_host *vhost, struct ibmvfc_cmd *vfc_cmd)
>> +{
>> +	if (be64_to_cpu(vhost->login_buf->resp.capabilities) & IBMVFC_HANDLE_VF_WWPN)
> 
> Same here
> 
>> +		return &vfc_cmd->v2.rsp;
>> +	else
>> +		return &vfc_cmd->v1.rsp;
>> +}
>> +
>>  #ifdef CONFIG_SCSI_IBMVFC_TRACE
>>  /**
>>   * ibmvfc_trc_start - Log a start trace entry
> 
> 
> 

