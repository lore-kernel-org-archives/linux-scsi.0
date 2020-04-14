Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7746AC2BA2B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8652072A
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qAlgXrwL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403875AbgDNBzw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:55:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44532 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgDNBzw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 21:55:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1sK7r164236;
        Tue, 14 Apr 2020 01:55:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=P4pWp9Sp2n92w/l/cFSI0tNS0Yz371dtCtsj30FF7jU=;
 b=qAlgXrwLq7VIyj6uCWupeoqGZX6BWTZW6HIc0WN4nMrbirjFa+JRm9H1WCrCceUdQaU3
 uJgCY+jJVoYV2183JwpUYCZhlbRbi6x+Jjqls669NWEFoddUnuhyzdRouvG8w9UlZj4r
 GAlMm8GbZ3R0dR8QbsITG+lU5qlSriBomg5SrW7JOmkcY/9ZppifigvlOyCxXHnWwubg
 gNW/fMqllcNIsSwwSsMRFGUIzuhx420W8CLSNj76i41zd9WTWUX0Q0MaajP8t+ypHqqy
 8Q4DHdada5R7ma/tms722d6RcqiWvjYxgN4wrw53RVemOHHMjXTjmfD8EipoNArgYQA/ aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30b6hphnk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:55:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1r4WY039336;
        Tue, 14 Apr 2020 01:55:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30cta8nj61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:55:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03E1tgkq017714;
        Tue, 14 Apr 2020 01:55:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 18:55:42 -0700
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb\@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare\@suse.de" <hare@suse.de>
Subject: Re: [PATCH v4 07/14] scsi_debug: expand zbc support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225062351.21267-1-dgilbert@interlog.com>
        <20200225062351.21267-8-dgilbert@interlog.com>
        <yq1a73fvvmi.fsf@oracle.com>
        <BY5PR04MB6900CB37BE3A595454FA476BE7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
        <BY5PR04MB6900A558706F2ACBA6BDE602E7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
Date:   Mon, 13 Apr 2020 21:55:40 -0400
In-Reply-To: <BY5PR04MB6900A558706F2ACBA6BDE602E7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Mon, 13 Apr 2020 23:06:20 +0000")
Message-ID: <yq1eesqu8yr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=930
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=984 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

>> Tested-by: Damien Le Moal <damien.lemoal@wdc.com>
>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
>
> Oops. Should have sent that in reply to the patch email... Should I
> resend ?

I would prefer the ZBC changes to be posted as a separate series with
your Tested-by: / Reviewed-by: tags added.

-- 
Martin K. Petersen	Oracle Linux Engineering
