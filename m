Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACA3C71155
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 22:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DEBD21D7A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 22:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgLBWS2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 17:18:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725929AbgLBWS2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 17:18:28 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2M2kp8161142;
        Wed, 2 Dec 2020 17:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hiSW0sTAkK3gvpRB2SA1mnfMvogfEHrNJZ0GCXbMOVo=;
 b=hhYaCC1QoBa0QGbbuZ7DAM+1A8cYRDz1ar9/jo+SA32kq69xFyNwO50gIBt/6MzDaf3q
 iA/eT3Z6gTsWs2fp3uHkVS481ItrE+vUCCJ7um03PwYcGEBY4z5MSp34kBdRCPQM3Uc8
 odIpP/jNdv/Fs7k0BpDva+Zf8zP3DxRojOnHpaxBURTblVQyotPdh82aPSZGhaIA/bw3
 UpEkLFVxsaLbSgagawgdtwach7flg/DFNVOtkjPGbRInR/H9g9scf9W7QpZVJaX+6zQz
 7aovm/ez4UEdnQEpmwFu33zR+1sANbowx2flfdmAWxgTZZsNAX62ooPfsDs9EY96xKR9 Hg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 356jdx1xh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 17:17:41 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B2MHVEr024962;
        Wed, 2 Dec 2020 22:17:40 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 355rf7n62c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 22:17:40 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B2MHe0w1508072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 22:17:40 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F252B112062;
        Wed,  2 Dec 2020 22:17:39 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF160112061;
        Wed,  2 Dec 2020 22:17:38 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.215.138])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Dec 2020 22:17:38 +0000 (GMT)
Subject: Re: [PATCH v2 17/17] ibmvfc: provide modules parameters for MQ
 settings
To:     Brian King <brking@linux.vnet.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201202005329.4538-1-tyreld@linux.ibm.com>
 <20201202005329.4538-18-tyreld@linux.ibm.com>
 <e2343b78-5be3-da2d-b2bc-ccb0a75c61ae@linux.vnet.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <7d9a1415-4c0b-15df-1b79-ef2e760f57c1@linux.ibm.com>
Date:   Wed, 2 Dec 2020 14:17:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <e2343b78-5be3-da2d-b2bc-ccb0a75c61ae@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_13:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/2/20 10:40 AM, Brian King wrote:
> On 12/1/20 6:53 PM, Tyrel Datwyler wrote:
>> +module_param_named(mig_channels_only, mig_channels_only, uint, S_IRUGO | S_IWUSR);
>> +MODULE_PARM_DESC(mig_channels_only, "Prevent migration to non-channelized system. "
>> +		 "[Default=" __stringify(IBMVFC_MIG_NO_SUB_TO_CRQ) "]");
>> +module_param_named(mig_no_less_channels, mig_no_less_channels, uint, S_IRUGO | S_IWUSR);
>> +MODULE_PARM_DESC(mig_no_less_channels, "Prevent migration to system with less channels. "
>> +		 "[Default=" __stringify(IBMVFC_MIG_NO_N_TO_M) "]");
> 
> Both of these are writeable, but it doesn't look like you do any re-negotiation
> with the VIOS for these changed settings to take effect if someone changes
> them at runtime.

For some reason I convinced myself that these could just be changed on the fly,
but yes for them to actually take effect we need to re-negotiate the channels setup.

> 
>> +
>>  module_param_named(init_timeout, init_timeout, uint, S_IRUGO | S_IWUSR);
>>  MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds. "
>>  		 "[Default=" __stringify(IBMVFC_INIT_TIMEOUT) "]");
> 
>> @@ -3228,6 +3250,36 @@ static ssize_t ibmvfc_store_log_level(struct device *dev,
>>  	return strlen(buf);
>>  }
>>  
>> +static ssize_t ibmvfc_show_scsi_channels(struct device *dev,
>> +					 struct device_attribute *attr, char *buf)
>> +{
>> +	struct Scsi_Host *shost = class_to_shost(dev);
>> +	struct ibmvfc_host *vhost = shost_priv(shost);
>> +	unsigned long flags = 0;
>> +	int len;
>> +
>> +	spin_lock_irqsave(shost->host_lock, flags);
>> +	len = snprintf(buf, PAGE_SIZE, "%d\n", vhost->client_scsi_channels);
>> +	spin_unlock_irqrestore(shost->host_lock, flags);
>> +	return len;
>> +}
>> +
>> +static ssize_t ibmvfc_store_scsi_channels(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count)
>> +{
>> +	struct Scsi_Host *shost = class_to_shost(dev);
>> +	struct ibmvfc_host *vhost = shost_priv(shost);
>> +	unsigned long flags = 0;
>> +	unsigned int channels;
>> +
>> +	spin_lock_irqsave(shost->host_lock, flags);
>> +	channels = simple_strtoul(buf, NULL, 10);
>> +	vhost->client_scsi_channels = min(channels, nr_scsi_hw_queues);
> 
> Don't we need to do a LIP here for this new setting to go into effect?

Actually, we need a hard reset to break the CRQ Pair. A LIP will only do a NPIV
Logout/Login which keeps the existing channel setup.

-Tyrel

> 
>> +	spin_unlock_irqrestore(shost->host_lock, flags);
>> +	return strlen(buf);
>> +}
>> +
>>  static DEVICE_ATTR(partition_name, S_IRUGO, ibmvfc_show_host_partition_name, NULL);
>>  static DEVICE_ATTR(device_name, S_IRUGO, ibmvfc_show_host_device_name, NULL);
>>  static DEVICE_ATTR(port_loc_code, S_IRUGO, ibmvfc_show_host_loc_code, NULL);
> 
> 
> 

