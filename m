Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5DAC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC3FB20857
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i1mob5Pi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgF0Ep7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:45:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48308 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgF0Ep6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:45:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4hX0G067788;
        Sat, 27 Jun 2020 04:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=nFo71nSVFCsU+0FggxHBmS1HfWVT47gChz2B23U4Cnc=;
 b=i1mob5PiUBCDlVuQPzWIJTbDDuX5XYgB1YfeTpaeew1ObHT2jc9xGFfIXRLd6tPe4VLe
 5L0xw5gFjpAdDpDoRqBBM8tbYbcV85dsuy92YYO9bWMZ+vUM+s3BmO0DMeTEUySmmtEy
 anLxQi14mjYrlMuSgK/Mtsmqe/yNrEI0JqdMsEdKN1OszZZP1ET17ZGaiQBqG/n3m2zV
 UrWEphn9Ytc07kIuRsijDdWmTBCWJ0McTCj98L2LLJAHUUFSRh8SGOA6F907Weh2mrVc
 0WpK0eJ8vKWTiUAmdugeln53nLsgXxKWRTVNtAIJUUBK8rJJ2dDwY2hmkno+EjD7BXsE jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31wx2m82rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:45:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4iNKT109356;
        Sat, 27 Jun 2020 04:45:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31wwwyw9p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:45:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R4jmpd009716;
        Sat, 27 Jun 2020 04:45:49 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:45:48 +0000
Subject: Re: [RFC PATCH 09/10] target: add helper to close session
 synchronously
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-10-git-send-email-michael.christie@oracle.com>
Message-ID: <89747f03-3bbf-a210-bf7d-4c487d80f285@oracle.com>
Date:   Fri, 26 Jun 2020 23:45:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1593232509-13720-10-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 impostorscore=0 cotscore=-2147483648 priorityscore=1501 malwarescore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006270032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/26/20 11:35 PM, Mike Christie wrote:
> +	if (!se_sess->tfo->close_session) {
> +		pr_err("Session %d does not support configfs session removal.",
> +		       se_sess->sid);
> +		return -EINVAL;
> +	}

I just realized I posted a slightly older version of the patch I meant 
to post. The locking issue above will be fixed in the final version.
