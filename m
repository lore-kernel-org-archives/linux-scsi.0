Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC4EC433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 21:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E49B22206
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 21:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hEUkSZLo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgIJVfV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 17:35:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41620 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbgIJVeu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 17:34:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AFjLjD171684;
        Thu, 10 Sep 2020 15:45:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=ZRWbOAo3YhHyatHpLIFwfMdIGIkU5prHLHjUW/jRFpk=;
 b=hEUkSZLooV9wKy6B30SxuBX1GQiPBv4samStX65Z+sXJpEH48v96PRIom5Iy3WsDj6ZP
 D82D81ueagJX9ujb/qQU7E1XpL9bXj39UrB3DEB9Ay4Ql7FT3gh8IOfDIow+fLkEuSUY
 ORUfPAh6RD/NoDGP15qZsIWOwMpFgreIKMFGVbZb2nc/03bLTCq4FmZ1acgTahaZZAzA
 fKzg/z7m36WftYB1WbS4Mn1oh3DJtnnOtY/iRdF38M3sV0qdgmX9L7ATzNO92PYnI8uh
 20Z2XN8h1Db+r2w7i4+r2IPm5iU4+/UFBn1VajtfT4OpJCGl2CVd4ZwRP8UTTd0jmLv2 kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33c23r91ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 15:45:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AFjW2r193943;
        Thu, 10 Sep 2020 15:45:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33cmev65pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 15:45:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08AFjnPM032350;
        Thu, 10 Sep 2020 15:45:49 GMT
Received: from dhcp-10-154-107-125.vpn.oracle.com (/10.154.107.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 08:45:48 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 1/3] scsi: Cleanup scsi_noretry_cmd()
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200910074843.217661-2-damien.lemoal@wdc.com>
Date:   Thu, 10 Sep 2020 10:45:48 -0500
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Transfer-Encoding: 7bit
Message-Id: <F946D669-CE85-4383-8EB2-7C92CE4EEAB9@oracle.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
 <20200910074843.217661-2-damien.lemoal@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=3 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100145
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 10, 2020, at 2:48 AM, Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> 
> No need for else after return.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> drivers/scsi/scsi_error.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 927b1e641842..5f3726abed78 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1755,8 +1755,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
> 	if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
> 	    blk_rq_is_passthrough(scmd->request))
> 		return 1;
> -	else
> -		return 0;
> +
> +	return 0;
> }
> 
> /**
> -- 
> 2.26.2
> 

Looks Good. 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

