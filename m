Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62FCC433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 00:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0A2A2070E
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 00:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e+LVgcKb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgGZAIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 20:08:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52032 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgGZAIU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2020 20:08:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06Q06lAK034513;
        Sun, 26 Jul 2020 00:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=06XwXv0O/mhfCOSdvINR4HUm3BTXZaR3BE9TSFz2SnE=;
 b=e+LVgcKb8Y8RAJL5wPfqjvWwObfPbbqXvQwz/q98E4QgD1pn2gi/qiHjE6JRP+UBnAHO
 5wlB6vGnu0YSos97k5OG9yOPMECmgcaIVUQX8hdfYdNRY63zYel7rQZleuDLkVLPbepo
 EJOjkkhWq+7qmI9fteyXrG1ctZRUnDgDLsfWL3U+R+N1+Ypu3TLcdCOoGjLltjMmg60L
 zDwz5kR1AcK93GjObNqMWiraPNU6UjZUrz+l9ubbPaDuLVuhdQ7CcF59yxN0POC3Vobu
 zufo2jl4Dvum8ymH7/9dZVj1GHIDtw57XJ4mttI/uIT0Eo5UmG3X7N1sKQgxOs1c2DOq dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32gx4rr1pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 26 Jul 2020 00:08:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PNx9LA089197;
        Sun, 26 Jul 2020 00:06:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32gxnt8n1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jul 2020 00:06:16 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06Q06GYN028431;
        Sun, 26 Jul 2020 00:06:16 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 17:06:15 -0700
Subject: Re: [PATCH v2 8/8] scsi: target: tcmu: Make TMR notification optional
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
 <20200717161212.10731-9-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <454b34ff-47c6-f54d-7b52-642b08f8cbd1@oracle.com>
Date:   Sat, 25 Jul 2020 19:06:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717161212.10731-9-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250201
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/17/20 11:12 AM, Bodo Stroesser wrote:
> Add "tmr_notification" configFS attribute to tcmu devices.
> If default value 0 of the attribute is used, tcmu only
> removes aborted commands from qfull_queue.
> If user changes tmr_notification to 1, additionally
> TMR notifications will be written to the cmd ring.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>  drivers/target/target_core_user.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 92b7a2e84e64..95e66b707373 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -118,6 +118,7 @@ struct tcmu_dev {
>  #define TCMU_DEV_BIT_OPEN 0
>  #define TCMU_DEV_BIT_BROKEN 1
>  #define TCMU_DEV_BIT_BLOCKED 2
> +#define TCMU_DEV_BIT_TMR_NOTIFY 3
>  	unsigned long flags;
>  
>  	struct uio_info uio_info;
> @@ -1260,6 +1261,9 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
>  	if (unqueued)
>  		tcmu_set_next_deadline(&dev->qfull_queue, &dev->qfull_timer);
>  
> +	if (!test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags))
> +		goto unlock;
> +
>  	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
>  		 tcmu_tmr_type(tmf), dev->name, i, cmd_cnt);
>  
> @@ -2706,6 +2710,40 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
>  }
>  CONFIGFS_ATTR(tcmu_, emulate_write_cache);
>  
> +static ssize_t tcmu_tmr_notification_show(struct config_item *item,
> +					       char *page)

Sorry about this. Just some nits.

The spacing above got messed up a little. I think you only need 2 spaces, but it looks like we got some extras.


> +{
> +	struct se_dev_attrib *da = container_of(to_config_group(item),
> +					struct se_dev_attrib, da_group);
> +	struct tcmu_dev *dev = TCMU_DEV(da->da_dev);


Could you use udev or tcmu_dev for the name. Sorry for being a broken record on this one. We use dev or se_dev for the se_device struct already and it throws me off when scanning the code.

I think patch 5 and 7 need the same fix up.
