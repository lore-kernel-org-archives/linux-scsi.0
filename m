Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B451C33C99
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E08020721
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:00:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dz7zI0X9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgAJGAl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 01:00:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgAJGAl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 01:00:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A5rftl050875;
        Fri, 10 Jan 2020 06:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=PVym3IK25VYl8Yy2zr3ccIqnRJ0jc2dT4Ove3ntsDho=;
 b=Dz7zI0X9BDk4hWEPptLu5doyRmpSrSPjYjiEh2+xAM8h3biOX7h9y8PuZx7tpOKPj7/G
 VUW1khUsuZ7HrQUMkaIXFQwVotqDNlkwPzPfhnTHnhGnAur354CA5UIc5GFGHeEIeD3v
 BbvXmAqnNO/7x/O8kOeX0KIPJ3qDAm8/B9KWCfQWomeNIHmzx8OObE5/NlSJTurrrGbH
 q17OeORa4kUN3oWh07vE4eBPBqg36yaE0rgdzhHBuCSb5kHcX1n7Wllp4VJetiwkiQ75
 nZmLFjX0gYtR9dP7PyHlsTrQUUvFofrTGKyyKh2SlJ82n+S3+qJCtvVmB+Pb+umOELmG zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xajnqftar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:00:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A5rNEI066387;
        Fri, 10 Jan 2020 06:00:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xedhxdn53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:00:38 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00A60bic012596;
        Fri, 10 Jan 2020 06:00:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 22:00:37 -0800
To:     Anand Lodnoor <anand.lodnoor@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: Re: [PATCH 01/11] megaraid_sas: Add transition_to_ready retry logic in resume path
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
        <1578051155-14716-2-git-send-email-anand.lodnoor@broadcom.com>
Date:   Fri, 10 Jan 2020 01:00:35 -0500
In-Reply-To: <1578051155-14716-2-git-send-email-anand.lodnoor@broadcom.com>
        (Anand Lodnoor's message of "Fri, 3 Jan 2020 17:02:25 +0530")
Message-ID: <yq1imljx33w.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100050
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Anand,

First of all, you need a better commit descriptions with a rationale for
each change. Several of the patches in the posted series have vague
one-liners.


In addition, this hunk seems odd:

> +				if (megasas_adp_reset_wait_for_ready
> +					(instance, true, 0) == FAILED)
> +					goto fail_ready_state;
> +				} else {
> +					goto fail_ready_state;
> +				}


Couple of typos. And please add a space after /* and before */:

> +			/*waitting for about 30 second before retry*/

-- 
Martin K. Petersen	Oracle Linux Engineering
