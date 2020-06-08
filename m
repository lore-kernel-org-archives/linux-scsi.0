Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724DEC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 15:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49048206D5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 15:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h5Eh3aiS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgFHPV1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 11:21:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54890 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729668AbgFHPV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 11:21:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058F8ESX153145;
        Mon, 8 Jun 2020 15:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KCO5BSGqYsPeKSv+2Mh1C58DWzbWo560XFe5C78PTzc=;
 b=h5Eh3aiS1cjKTzE3Ae17y5e9J0bdwIe24U6Ll3zidDvcFtuaAwSF9N7PLqfiXrsw8jYA
 O6de/JjLlje6ds1QUbW47ELnmESP/Pkh2PiuRQGFvETFkT4jAuEO0E5U6oDHEbyqwidP
 O5zaTJCzC7UyqP+wLFNflV8gBS/NlqIJlckmosEM1Kfd204DGn2ETxHEyGjvSG3h7EPa
 ildSXeE5rnEY45RTElQTMm4jHVxo/ffo8i93/dTuj7m70GQ42sM3AEuSbXF1d9ez8N5+
 svNTIxslSwIYNAPPSMo6+DiDYcQZBlQtVQ0xiD2xUJgEEdPwFRBvlleRfwQLxiXi6cyD 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31g2jqyfw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 15:21:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058F8I4W112016;
        Mon, 8 Jun 2020 15:21:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31gn232syy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 15:21:17 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 058FLETF021282;
        Mon, 8 Jun 2020 15:21:14 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 08:21:14 -0700
Subject: Re: [PATCH 11/17] target: add session sysfs class support
To:     Hannes Reinecke <hare@suse.de>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <75aa23e1-2194-31fb-ef12-90f868e12494@oracle.com>
Date:   Mon, 8 Jun 2020 10:21:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=2
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080113
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/20 1:14 AM, Hannes Reinecke wrote:
>> +    se_sess->target_name = 
>> kstrdup(se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
>> +                       GFP_KERNEL);
>> +    if (!se_sess->target_name)
>> +        goto free_acl;
>> +
>> +    if (se_sess->tfo->fabric_alias)
>> +        se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_alias,
>> +                           GFP_KERNEL);
>> +    else
>> +        se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_name,
>> +                           GFP_KERNEL);
>> +    if (!se_sess->fabric_name)
>> +        goto free_target;
>> +
>> +    se_sess->tpg_name = kstrdup(se_tpg->tpg_group.cg_item.ci_name,
>> +                    GFP_KERNEL);
>> +    if (!se_sess->tpg_name)
>> +        goto free_fabric;
>> +
>> +    return 0;
> 
> I wonder if we need to copy these variables.
> Why can't we display them directly, returning an error if the respective
> link is not available?
> If one is worried about the sysfs/configfs reference counting we can get 
> the reference in the _show() functions; wouldn't that be a better solution?

Do you mean in the sysfs show function do a configfs_depend_item() on 
the tpg, www, acl, etc? If so, I'm not sure that's safe, because for the 
tpg for example, we could do:

1. Userspace starts tpg removal with a rmdir.
2. Userspace also opens sysfs session file and has a ref to the session, 
but not the tpg yet.
3. kernel tears down tpg and sessions under it. The tpg is freed. The 
session is not because of the ref taken in #2.
4. sysfs session show function starts to reference se_sess->se_tpg so it 
can do a configfs_depend_item on the tpg_group.cg_item, but the se_tpg 
is freed in #3.

We either need to:
1. cp like above.
2. Handle both configfs and device struct refcounts for the same struct. 
So add a device struct to the www, tpg, acl and then coordinate the 
refcounting.
3. take a reference to the se_tpg when the session is created then drop 
it in the session release.
4. add some code and end up mix locking and state checks with refcounts. 
For example the tpg would have its configfs refcount like it does today 
(no new device struct in it), and when it deletes the sessions under it 
make sure the se_sess->se_tpg is NULL'd in a way that the session show 
function can do

lock()
if (!se_sess->se_tpg)
	return

se_sess->se_tpg access
unlock()

And then you have to do that up the stack for the other structs we want 
to ref.
