Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F562C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 05:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD006105A
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 05:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhETFSu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 01:18:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60334 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhETFSu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 01:18:50 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K5ERxU181362;
        Thu, 20 May 2021 05:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kXAbVmzY2Vr39sZ8jzpcxrD3siazfk5ugcT2ZXVs+xY=;
 b=l2w2Wtz1tsBdBO+hQm5g8FGgCD0GgtuIs1XGEsVpqR2QhPCrV/M4SoeHUYhhRnC6C2xT
 kKUMY44iWxn3GqCV8icxNc/As946Qtusby46gM2dC8knPQMSV7van8H+HZ61yLhAvAZj
 NHBGZ2VAL3AC2UeBUtOQw+o7GfzcgvuJKpnlZTb/0tHPr07klrT9YEGwsflD/r/pjXlG
 ZEr3CDZGoiRR2i1dbfUKN0lc2Mg6AjnlACM2GqDX69Fr9sFqKcOab6m6hehthsF4+xOK
 WHcOCKFZrH2x0d31PT4a47J02uAR8itzY5Cmqlbl3K5ZjaP09LkIDYSZwjtdy3megRcc Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38j3tbkjqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 05:17:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K5G4L2054464;
        Thu, 20 May 2021 05:17:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38mecm8c1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 05:17:27 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14K5GvSl059925;
        Thu, 20 May 2021 05:17:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 38mecm8c10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 05:17:26 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14K5HMlB019306;
        Thu, 20 May 2021 05:17:22 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 22:17:22 -0700
Date:   Thu, 20 May 2021 08:17:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: sni_53c710: Fix a resource leak in an error
 handling path
Message-ID: <20210520051715.GZ1955@kadam>
References: <5a97774020847f6b63e161197254d15ef1d786ea.1621485792.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a97774020847f6b63e161197254d15ef1d786ea.1621485792.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: B7-_USFOj86VOVhwwljGs6TeAHKeqzGZ
X-Proofpoint-GUID: B7-_USFOj86VOVhwwljGs6TeAHKeqzGZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200042
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 20, 2021 at 06:44:25AM +0200, Christophe JAILLET wrote:
> After a successful 'NCR_700_detect()' call, 'NCR_700_release()' must be
> called to release some DMA related resources, as already done in the
> remove function.
> 
> Fixes: c27d85f3f3c5 ("[SCSI] SNI RM 53c710 driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Good catch.

Reveiwed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

