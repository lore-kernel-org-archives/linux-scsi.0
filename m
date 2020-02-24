Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E675C38BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 20:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB15620836
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 20:08:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CbIF5SEd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgBXUIO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 15:08:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33774 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgBXUIN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2020 15:08:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OK4TLV133082;
        Mon, 24 Feb 2020 20:07:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Hd3LEkvAPQYHika9QfHdeFbvOxdWRjzd8q/4lvbxKVY=;
 b=CbIF5SEdVsVyMvVmRJoqInq/Vinm8gJQXm7cSWIwJYJSMP40NrswmhZMDmaO1sp8O8l3
 Sth6a2w7STp5MrgFIfRADFjWYny5vl2WbLIdDAZKjh1MMzKMs6e7nQR3D2uQ/jXx6Co4
 fQEbk/2detkbcClGayIPs3kqgUPZMH+I/KdB2T4MVjDCiKNPJz54PyVdyr+Lim0aRd/I
 08fzRb/1+KwZWIHUoA8Xg9msKIpHelK18bghPrcnHuVUh9vbFQTYbkWGHLTDywNFqVz1
 GZQkOgS9WUzAOzLZ2jW/tS2exLXUEZYhuIS/fn/0zqDpPleCrYQtbmpX4CAd3+QiyRrj Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yavxrhqkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 20:07:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OK2pQe147603;
        Mon, 24 Feb 2020 20:07:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ybduv428f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 20:07:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01OK7DdR008300;
        Mon, 24 Feb 2020 20:07:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 12:07:13 -0800
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adam Williamson <awilliam@redhat.com>,
        Chris Murphy <bugzilla@colorremedies.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Waugh <tim@cyberelk.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] compat_ioctl, cdrom: Replace .ioctl with .compat_ioctl in four appropriate places
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200219165139.3467320-1-arnd@arndb.de>
Date:   Mon, 24 Feb 2020 15:07:10 -0500
In-Reply-To: <20200219165139.3467320-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 19 Feb 2020 17:50:07 +0100")
Message-ID: <yq1eeujda1d.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1011 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240146
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Arnd,

> Arnd Bergmann inadvertently typoed these in d320a9551e394 and
> 64cbfa96551a; they seem to be the cause of
> https://bugzilla.redhat.com/show_bug.cgi?id=1801353 , invalid SCSI
> commands when udev tries to query a DVD drive.

Applied to 5.6/scsi-fixes. Thanks!

Jens, I hope that's OK? I keep getting mail about this bug.

-- 
Martin K. Petersen	Oracle Linux Engineering
