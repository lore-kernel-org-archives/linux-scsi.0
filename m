Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8995C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A705C20828
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JIJSkj+U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfH2W6t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:58:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52970 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2W6t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 18:58:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TMrUND049882;
        Thu, 29 Aug 2019 22:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Y9KVsNHJ8CUFKe64GT7n5oVYFghHsJkoPRCde19Kris=;
 b=JIJSkj+UQyfRClV0PZMyVtN0VI9nVQuO9WHS2u1CTbN6BRPknuwi5YQZ/s6zETMzA3gr
 iPPwxaDqyS/HqSg01D7GiiP57BR5+mq+lfgUS6wTkQftoxLWJ/4Btq6/SpG0xnZN+aMu
 Rd9GZCAfm4eHAI9gbQHYFJSxJnkpPqpOxFv3LLSfXRVUMlCfAbITMR4m3qnQNINsvicA
 tRGqMUkDjdm109Yxne1ZXsKJCkSVK/l4xrFWKvpp9ArZ4PqLwbNmnKaQDOQn3PNzlz2h
 T2i5yUTKNDjFYr2JxoP0OlaZreezDIrpMOK62RgPhAzxkoeArhyxFoFZfAyqA0tYjAR9 Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2upqsdg1ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:58:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TMvgFw055687;
        Thu, 29 Aug 2019 22:58:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2unvu0qvvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:58:35 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TMwYhV000897;
        Thu, 29 Aug 2019 22:58:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 15:58:34 -0700
To:     John Pittman <jpittman@redhat.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com, satishkh@cisco.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: print port speed only at driver init or speed change
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190823140852.1852-1-jpittman@redhat.com>
Date:   Thu, 29 Aug 2019 18:58:32 -0400
In-Reply-To: <20190823140852.1852-1-jpittman@redhat.com> (John Pittman's
        message of "Fri, 23 Aug 2019 10:08:52 -0400")
Message-ID: <yq1imqfpoiv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290229
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290228
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> Port speed printing was added by commit d948e6383ec3 ("scsi: fnic:
> Add port speed stat to fnic debug stats"). As currently configured,
> this will cause the port speed to be printed to syslog every
> 2 seconds. To prevent log spamming, only print the vnic port speed
> at driver initialization and if the speed changes. Also clean up a
> small typo in fnic_trace.c.

Applied to 5.4/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
