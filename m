Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4A0C4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 07:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C7D8239ED
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 07:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgLPHkg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 02:40:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33242 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLPHkf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 02:40:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BG7XgB5112482;
        Wed, 16 Dec 2020 07:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NBK/huWzTvrkip435O75lUOYm3OisT//rGhilU+0maY=;
 b=TnycAfsT7Vj4T+E736L3vSJpRIaMoklh2amNVrpVbuDVrbUYgAtdlDMXUPiI3vrvdblS
 nbsSeX0WZgrZi5wRlYgLRzKsjht8VQpp0kaoqLzfF1CvDC3hbtizmexX9Tm1Icz3LdqA
 6f+yxjGU3t5S7SR/siRQT4m7nyfbB0e9PMVOYovov2a05ehPEex13LGeyRZbNYdWUsCs
 f9sXqTPxnquJ+0pSfUIfdK6GNrAKMMmalLYxudqI7sl/dunVqJbr8qoL2yM+8IsOpU3/
 CRrj/g8Ut7W5SUFKheTdzwf0a6+eKOWrE1JMg9dsr3DBEfpLXg3LxH0buSvT6Gy7xZfo zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntm6kfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Dec 2020 07:39:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BG7Z9iY153740;
        Wed, 16 Dec 2020 07:39:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35e6jsc8cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 07:39:02 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BG7cx42020847;
        Wed, 16 Dec 2020 07:38:59 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Dec 2020 23:38:59 -0800
Subject: Re: [PATCH 3/3] libiscsi: fix iscsi_task use after free
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608069210-5755-1-git-send-email-michael.christie@oracle.com>
 <1608069210-5755-4-git-send-email-michael.christie@oracle.com>
Message-ID: <89689289-87cd-a122-0da1-0569c5979f4c@oracle.com>
Date:   Wed, 16 Dec 2020 01:38:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1608069210-5755-4-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/15/20 3:53 PM, Mike Christie wrote:
> @@ -1990,8 +1993,11 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>   		 * so let timeout code complete it now.
>   		 */
>   		rc = BLK_EH_DONE;
> +		spin_unlock(&session->back_lock);
>   		goto done;
>   	}
> +	__iscsi_get_task(task);
> +	spin_unlock(&session->back_lock);
>   
>   	if (session->state != ISCSI_STATE_LOGGED_IN) {
>   		/*

Just below this we loop over active tasks and access their scsi_cmnd,
so that will need to be fixed too. I'm going to send a new version
of this patchset.
