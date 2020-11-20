Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB5FC63798
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAE1322256
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:30:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xTBgh7iV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgKTDaB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:30:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45622 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgKTDaB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:30:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3OnBd070169;
        Fri, 20 Nov 2020 03:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JUl9Oy+xUSpMnGiSebmleA6BvZq25faqvbOg2K3HtkU=;
 b=xTBgh7iV8YnnOhUYaRIdM1MX6c7+x2x5WM5JSCOIw7iaT8Q0ky18bz80dmfkqCBoiI3I
 bO8wBaAh8hoGUD+eYAFmNzXrI6aeZ2LohCRQEANd0Cqj3OVca7HQ/VZbbmCPYJRGrxLd
 IQkh//oZj9KwXa9qlf7/ek/QI9jE2+ZollMA/IxC6SG8KWK+bfjQBnLV0ODR2K72TTLW
 O2vORRdhp5yLySz8c39Bjhg19FUkOmWbIzJaKo9vuZbw0xAlGmZ71OAXEm/4rYW6SVzu
 +hjHVWADfVRnc0CW04D3EqbCNj6PAxDCeAThNBT8eB4TTc9BV1TGXmFw+v3RyvyUQXl5 Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rb8tu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:29:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3Pi4n032359;
        Fri, 20 Nov 2020 03:29:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34uspx2g7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:29:47 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AK3TjdM029067;
        Fri, 20 Nov 2020 03:29:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:29:45 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Justin.Lindley@microchip.com, Kevin.Barnett@microchip.com,
        joseph.szczypek@hpe.com, gerry.morong@microchip.com,
        hch@infradead.org, POSWALD@suse.com,
        Don Brace <don.brace@microchip.com>,
        mahesh.rajashekhara@microchip.com, scott.teel@microchip.com,
        scott.benesh@microchip.com, jejb@linux.vnet.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] smartpqi updates
Date:   Thu, 19 Nov 2020 22:29:33 -0500
Message-Id: <160584262850.7157.296979724827286830.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <160512621964.2359.14416010917893813538.stgit@brunhilda>
References: <160512621964.2359.14416010917893813538.stgit@brunhilda>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 11 Nov 2020 14:24:33 -0600, Don Brace wrote:

> These patches are based on Linus's tree
> 
> This small set of changes consist of two minor bug fixes:
>   * Remove an unbalanced call to pqi_ctrl_unbusy in the smp
>     handler. There is not a call to pqi_ctrl_busy.
>   * Correct driver rmmod hang when using HBA disks with
>     write cache enabled. During removal, SCSI SYNCHRONIZE CACHE
>     requests are blocked with SCSI_MLQUEUE_HOST_BUSY which cause
>     the hang.
> Also included is a version change.

Applied to 5.11/scsi-queue, thanks!

[1/3] scsi: smartpqi: Correct driver removal with HBA disks
      https://git.kernel.org/mkp/scsi/c/1bdf6e934387
[2/3] scsi: smartpqi: Correct pqi_sas_smp_handler busy condition
      https://git.kernel.org/mkp/scsi/c/408bdd7e5845
[3/3] scsi: smartpqi: Update version to 1.2.16-012
      https://git.kernel.org/mkp/scsi/c/5443bdc4cc77

-- 
Martin K. Petersen	Oracle Linux Engineering
