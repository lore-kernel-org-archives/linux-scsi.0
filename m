Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8B0C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 02:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B90D220700
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 02:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eCLS4l25"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGZC7F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 22:59:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35294 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgGZC7E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2020 22:59:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06Q2x0DM118836;
        Sun, 26 Jul 2020 02:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=c/0r16exnF4ozU15nfo9XpSx9mGupj9h4yEiGvAZM/Q=;
 b=eCLS4l25FgOtAzibPLi8in9mfgV+vPj53u7AiRJfeiNbv55D+qCcOoqQ+/njlaY5jDEz
 7Y3X1gxvGQbAY2fy2FCOtHyccT71/y7RGWFLtkSHH2BZ2pW2/FR7kqhc11uNuTc7WAtx
 0vWhdEqkKfeZsYRkm32NQ7vP4GcdHCNT3W5qmj/2Tew5uByKKJbqz/L7xs0vl2RSSM+d
 zpZ62WyuASgAMroYCfrsydf1YXqN5h+TQ1G/je9kezS5DGIol6vEtEFYVMJMqZv55Sem
 S+jqgXaF60g5nsKHWw8EAVho7TyXbgivY/jSLuaLeW7WB7+xTSitmZ20crN/2GxXF7Mt cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32gx4rr70s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 26 Jul 2020 02:59:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06Q2wG5n018170;
        Sun, 26 Jul 2020 02:58:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32gyur5fh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jul 2020 02:58:59 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06Q2wurr025457;
        Sun, 26 Jul 2020 02:58:57 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 19:58:56 -0700
Subject: Re: [PATCH v4 0/2] iscsi-target: fix login error when receiving is
 too fast
To:     Hou Pu <houpu@bytedance.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com
References: <20200716100212.4237-1-houpu@bytedance.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <a78662d5-0bb4-8b27-125e-b4c2176b70c6@oracle.com>
Date:   Sat, 25 Jul 2020 21:58:55 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716100212.4237-1-houpu@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007260022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1011 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007260022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/20 5:02 AM, Hou Pu wrote:
> Hi,
> We encountered "iSCSI Login negotiation failed" several times.
> After enable debug log in iscsi_target_nego.c of iSCSI target.
> Error shows:
>   "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"
> 
> Patch 1 is trying to fix this problem. Please see comment in patch 1
> for details.
> 
> Sorry for delay of v4. Version 3 of this patchset could be found here[1].
> 
> Changes from v4:
> * In iscsi_target_do_login_rx(), call cancel_delayed_work() if it is final
>   login pdu. Also call cancel_delayed_work() if current negotiation is failed.
>   This is advised by Mike Christie. See below[1] for more details.
> 
> Changes from v3:
> * Fix style problem found by checkpatch.pl.
> 
Ah sorry, I thought I replied a little later about my concerns being overly paranoid and your patch being ok. I don't see it on the list so not sure what happened.

If you are still not liking the cancel call, I'm ok with v3. Add my reviewed by to either version you prefer.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
