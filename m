Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA554C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 15:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B13DB2074B
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 15:36:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ldvy6TJe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbgFHPgE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 11:36:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbgFHPgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 11:36:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058FQLka068178;
        Mon, 8 Jun 2020 15:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=C5BuYfH84YjPDQriIjYBmeL+sRH17IqCmDm1ZBwn/Wk=;
 b=ldvy6TJe+odAATzMbZ3a7eutRFTvMms87ekqIjdL1Qy5E7eBQLTURWyZsQ4iFGrOoZId
 3/Mqdsxp8b1asBgbGHXuu0RluzulDsXi5GaXguxQ2P5cJEFFf9AkH+pi84v67htRsLhZ
 w/uaiPhmZYvV1GJTPWSubQyM0TV/iRcXZgdNYDXNBM7PRL0Ov5kEasIrBHK7EOrnec19
 IlaP7jGDKQfcypf8auiY2tibl60B0eHoMFsDEKY9RSziPKU6YYwSRpGSFsIlDt9uj7cY
 FjTBl+DlSfGuJUsBxwaPDklfZZmVikvExJB3SGhV+/lUDoxT8m49OFsxbAgTQ03bD8Aj cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31g3smqet1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 15:35:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058FSfJv024377;
        Mon, 8 Jun 2020 15:35:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31gmwq3ry9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 15:35:56 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 058FZt83028974;
        Mon, 8 Jun 2020 15:35:56 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 08:35:55 -0700
Subject: Re: [PATCH 11/17] target: add session sysfs class support
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <20200608053259.GA241877@kroah.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <1bb2e8f9-d433-de3b-3c4a-2ded2fa54240@oracle.com>
Date:   Mon, 8 Jun 2020 10:35:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200608053259.GA241877@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=2
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080114
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/8/20 12:32 AM, Greg Kroah-Hartman wrote:
> On Sun, Jun 07, 2020 at 03:35:58PM -0500, Mike Christie wrote:
>> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
>> +			     struct se_session *se_sess)
>> +{
>> +	struct t10_transport_id *tpt_id = se_sess->tpt_id;
>> +	int ret;
>> +
>> +	if (!try_module_get(se_sess->tfo->module))
>> +		return -EINVAL;
>> +
>> +	ret = target_cp_endpoint_strs(se_tpg, se_sess);
>> +	if (ret)
>> +		goto put_mod;
>> +
>> +	se_sess->dev.groups = se_sess->tfo->session_attr_groups;
>> +	ret = device_add(&se_sess->dev);
>> +	if (ret) {
>> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
>> +		       se_sess->sid, ret);
>> +		goto free_ep_strs;
>> +	}
>> +
>> +	pr_info("TCM added session-%d from [fabric: %s, target: %s, tpg %s, acl: %s] to [initiator port: %s%s%s]",
>> +		se_sess->sid, se_sess->fabric_name, se_sess->target_name,
>> +		se_sess->tpg_name, se_sess->acl_name ? se_sess->acl_name : "dynamic",
>> +		tpt_id->name, tpt_id->session_id ? "," : "",
>> +		tpt_id->session_id ? tpt_id->session_id : "");
> 
> You have a 'struct device', so please use it, no need for pr_info(),
> always use the dev_*() calls instead.
> 
> but, when drivers and kernel code is all working properly, no need to be
> noisy at all, this should just be a dev_dbg() call, right?

I liked the info one, because the the code can work correctly, but the 
remote devices we are connecting to are normally going to hit issues.

For example every time the storage network goes down temporarily the 
driver code will call remove function, then call the add again when it 
comes back up. Having it always logged helps us figure out the root 
problem later when the customer only has logs available.

> 
>> +
>> +	se_sess->sysfs_added = true;
>> +	return 0;
>> +
>> +free_ep_strs:
>> +	target_free_endpoint_strs(se_sess);
>> +put_mod:
>> +	module_put(se_sess->tfo->module);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(target_sysfs_add_session);
> 
> I have to ask, EXPORT_SYMBOL_GPL()?
> 

Just a cp mistake. The original author/maintainer of the target code 
used the non GPL calls, and I just blindly copied it over. I will use 
the GPL ones on the resend.


I agree with your other review comments in this mail and the others and 
will fix on the resend. Thanks,
