Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CC1C18E5B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 21:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2DF2205ED
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 21:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="hnFYqgm7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732650AbgCPVNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:13:50 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:56576 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732608AbgCPVNu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Mar 2020 17:13:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584393229; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: To:
 Subject: Sender; bh=2ttSlxY01AYEuim0+tiT10Zwj/1U0CEsQU2cnVV0vZQ=; b=hnFYqgm7u7EJBjHKtg5VR4mowpp5BGqS4q+3ug9ULOBQZgM0zC+xEoLhrc27pTRDQKW2T9fF
 VYsTex6pl+hFKv43CIbTk541lf+fCNBneoysmI4Z8MPoatAF4/vvQmeOM+ri4owRU51/dylF
 CYv/65/giK90HIV8otAMxzGmyCc=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6fec09.7f428791d8f0-smtp-out-n04;
 Mon, 16 Mar 2020 21:13:45 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A561FC44788; Mon, 16 Mar 2020 21:13:44 +0000 (UTC)
Received: from [192.168.8.111] (cpe-70-95-153-89.san.res.rr.com [70.95.153.89])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0FF59C433CB;
        Mon, 16 Mar 2020 21:13:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0FF59C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [<RFC PATCH v1> 1/2] scsi: ufs: add write booster feature support
To:     Bart Van Assche <bvanassche@acm.org>, asutoshd@qti.qualcomm.com,
        linux-scsi@vger.kernel.org
References: <cover.1582330473.git.asutoshd@codeaurora.org>
 <0eb182e6731bc4ce0c1d6a97f102155d7186520f.1582330473.git.asutoshd@codeaurora.org>
 <a5a45551-8852-a8de-3ea5-f7cf761c7a15@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <d941590e-7bfc-645d-2b69-dc67e680911c@codeaurora.org>
Date:   Mon, 16 Mar 2020 14:13:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a5a45551-8852-a8de-3ea5-f7cf761c7a15@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/21/2020 6:40 PM, Bart Van Assche wrote:
> On 2020-02-21 16:38, Asutosh Das wrote:
>> @@ -371,6 +379,12 @@ UFS_GEOMETRY_DESC_PARAM(enh4_memory_max_alloc_units,
>>   	_ENM4_MAX_NUM_UNITS, 4);
>>   UFS_GEOMETRY_DESC_PARAM(enh4_memory_capacity_adjustment_factor,
>>   	_ENM4_CAP_ADJ_FCTR, 2);
>> +UFS_GEOMETRY_DESC_PARAM(wb_max_alloc_units, _WB_MAX_ALLOC_UNITS, 4);
>> +UFS_GEOMETRY_DESC_PARAM(wb_max_wb_luns, _WB_MAX_WB_LUNS, 1);
>> +UFS_GEOMETRY_DESC_PARAM(wb_buff_cap_adj, _WB_BUFF_CAP_ADJ, 1);
>> +UFS_GEOMETRY_DESC_PARAM(wb_sup_red_type, _WB_SUP_RED_TYPE, 1);
>> +UFS_GEOMETRY_DESC_PARAM(wb_sup_wb_type, _WB_SUP_WB_TYPE, 1);
>> +
>>   
>>   static struct attribute *ufs_sysfs_geometry_descriptor[] = {
> 
> This patch converts a bunch of single blank lines into double blank
> lines. Are such changes useful?
No its not useful, let me re-look that.

> 
>> +	/* Enable WB only for UFS-3.1 OR if desc len >= 0x59 */
>> +	if (dev_info->wspecversion >= 0x310) {
>> +		hba->dev_info.d_ext_ufs_feature_sup =
>> +			desc_buf[DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP]
>> +								<< 24 |
>> +			desc_buf[DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 1]
>> +								<< 16 |
>> +			desc_buf[DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 2]
>> +								<< 8 |
>> +			desc_buf[DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 3];
> 
> Please use get_unaligned_be32() instead of open-coding it.
> 
>> +			res = wb_buf[0] << 24 | wb_buf[1] << 16 |
>> +				wb_buf[2] << 8 | wb_buf[3];
> 
> Same comment here.

Ok.
> 
> Thanks,
> 
> Bart.
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
