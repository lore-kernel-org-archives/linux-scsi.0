Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFBDC2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA6920692
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F7rD2y9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389879AbgDMXDG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 19:03:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389875AbgDMXDE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 19:03:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMnJnc035709;
        Mon, 13 Apr 2020 23:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=dSxlQbv0ZCH1aNETMVihcrGeIuEKPspk1KdSE1a/O1c=;
 b=F7rD2y9dUsNgJHmHSX36F09zo2hNN8e/zL79dGDtJWtJn87GagFX+UgTYsyJPCXDi990
 b+QNGkF6MM8gH3z5IXD2NcInpfaJoYf66FeGVFCs6MbYeA1OCnwGaKTC/fiZe3YRp9p0
 2XVwkzFxskKZ0MtqbqW7AOqjNogtVFoBUjG6Ym4hxa94hwN6fIC+AslQ7YfgSV+73KFf
 k6RAlbPuXVQFRGeYCjMbN52iE4WcoXzwC9FiOhMKjpvoLbBAY/bFXBVZQcQYxra/HBfz
 X2eZY2I1BLihESG7mvwPZrnbryGZrthKmYGpABbleJsQnxWqIdjBZTS2HzUdpJUujUFE NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30b6hph9b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 23:02:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMh4x4188734;
        Mon, 13 Apr 2020 23:00:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30cta8av46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 23:00:59 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03DN0uAE016448;
        Mon, 13 Apr 2020 23:00:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 16:00:56 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, Damien.LeMoal@wdc.com
Subject: Re: [PATCH v4 07/14] scsi_debug: expand zbc support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225062351.21267-1-dgilbert@interlog.com>
        <20200225062351.21267-8-dgilbert@interlog.com>
Date:   Mon, 13 Apr 2020 19:00:53 -0400
In-Reply-To: <20200225062351.21267-8-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Tue, 25 Feb 2020 01:23:44 -0500")
Message-ID: <yq1a73fvvmi.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=971
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

> The ZBC standard "piggy-backs" on many, but not all, of the facilities
> in SBC. Add those ZBC mode pages (plus mode parameter block
> descriptors (e.g. "WP")) and VPD pages in common with SBC. Add ZBC
> specific VPD page.

Also OK. Would benefit from a Reviewed-by: from Damien.

-- 
Martin K. Petersen	Oracle Linux Engineering
