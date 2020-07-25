Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3CDC433F1
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 796062074B
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vbUJbEc7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgGYCvO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:51:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39954 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGYCvN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:51:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2khCs076987;
        Sat, 25 Jul 2020 02:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=oE/helropYUUXieXgeCGqK1avvCQ3EqBvSoX776GcHU=;
 b=vbUJbEc7YeypWS7IxLYsDHI//voEsCeWADJy4dzGlx5LzI7SXJ7uvnuuZzO2BAJlHK5i
 Wb7/jAQMCFZFS3BjWwwiWBah8TDSRr+bItGhPpFxWpP+AR95CjP38D8zNg2LOCPOifSn
 t+FUeww+lYmQUWu9FtwiaQS3nyoNZM9Fo1NpUJjmmui/oEeeYOOsndQJsv6MS5ii07wO
 nEhT7sgdGrhwE5UKWtEi7sgwcM7PMcFQcxvnEK66nhXxob2KhggzRHgyJcnkomLxQ7AX
 okulwU/4r/hwLY0fb83lBtg0VzITNq4mJiaJmvskqURBFgtbkqffKWdTauaOhC7RB8MN Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32gc5qr0d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:51:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2nA1q023994;
        Sat, 25 Jul 2020 02:51:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32g9uu6psc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2oqfr004181;
        Sat, 25 Jul 2020 02:50:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:50:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Only return started requests from scsi_host_find_tag()
Date:   Fri, 24 Jul 2020 22:50:36 -0400
Message-Id: <159564519423.31464.13344730758787690485.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622063022.67891-1-hare@suse.de>
References: <20200622063022.67891-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Jun 2020 08:30:22 +0200, Hannes Reinecke wrote:

> scsi_host_find_tag() is used by the drivers to return a scsi
> command based on the command tag. Typically it's used from the
> interrupt handler to fetch the command associated with a value
> returned from hardware. Some drivers like fnic or qla4xxx, however,
> also use it also to traverse outstanding comands.
> With the current implementation scsi_host_find_tag() will return
> command even if they are not started (ie passed to the driver).
> This will result in random errors with those drivers.
> With this patch scsi_host_find_tag() will only return 'started'
> commands (ie commands which have been passed to the drivers)
> thus avoiding the above issue.
> The other usecases will be unaffected as the interrupt handler
> naturally will only ever return 'started' requests.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: core: Only return started requests from scsi_host_find_tag()
      https://git.kernel.org/mkp/scsi/c/e73a5e8e8003

-- 
Martin K. Petersen	Oracle Linux Engineering
