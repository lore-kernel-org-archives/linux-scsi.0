Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2667C2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99ED420735
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pnKtmjhu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389972AbgDMXV5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 19:21:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45582 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgDMXV4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 19:21:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DNIfDN044324;
        Mon, 13 Apr 2020 23:21:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=gjFUs2CQ2NtV7bGfeeoxiPt6CPePudDY7PXqZGQ3ewY=;
 b=pnKtmjhu3RWO0Lba6fiqFIhDoHPBJNQ678NZR8U5z/PbRfelN5Veoxu5jHTW4ATg8dYO
 ELOHr4pMJndWtbd22sUxGo9niW2rlJUHCsMayLIJhz4cWDp4T+euIPHUghZNJ69byJiC
 PrRBmi72C1ENgUOLFQ+qwf8WdDpvRs64A7OA6IzDf14UHGqAbAmY43EqXTuMPtgvs2lG
 657F6dbyc+dQlNdB6jh1HGdvAbPcrzxrUbNiVeCdvj4Xqnxc0vCPb0UUMRsEdaNElRyF
 Gli5LWVSbl6vgqxEi+LjKSlzLCP2g0zHoOXxqIRilNDwH+QW5QQIXxHf27QjJp2C70KV Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30b5ar1c0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 23:21:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DNBtZx153537;
        Mon, 13 Apr 2020 23:19:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30bqpdth9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 23:19:50 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03DNJnsc029294;
        Mon, 13 Apr 2020 23:19:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 16:19:49 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, Damien.LeMoal@wdc.com
Subject: Re: [PATCH v4 00/14] scsi_debug: host managed ZBC + doublestore
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225062351.21267-1-dgilbert@interlog.com>
Date:   Mon, 13 Apr 2020 19:19:47 -0400
In-Reply-To: <20200225062351.21267-1-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Tue, 25 Feb 2020 01:23:37 -0500")
Message-ID: <yq1mu7fug6k.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130168
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Evening Doug!

> The major addition is support for host-managed ZBC devices.  The bulk
> of the work in this area was done by Damien Le Moal.  It allows ZBC
> devices with a mix of conventional and "sequential write required"
> zones to be specified.

[...]

> The lower numbered patches in this set contain various measures to
> improve the speed and usefulness of this driver.  It is being used to
> test the rewrite of the SCSI generic (sg) driver which is still
> underway.

These really should be separate series. One for the ZBC stuff (which
generally looks OK), one for the backing store enablement, and maybe one
for the general improvements that do not have other dependencies.

It's much more manageable for reviewers when things come in smaller
batches. Once a posted series has been merged, you can rebase your
working tree and submit the next batch of 5-10 patches.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
