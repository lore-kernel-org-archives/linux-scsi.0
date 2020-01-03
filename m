Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105EBC3276F
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 02:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D13BE2085B
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 02:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZrB8excr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgACCzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 21:55:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51020 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgACCzb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 21:55:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0032t6o1102019;
        Fri, 3 Jan 2020 02:55:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=sxWadHnSenV2hzpz2e0AAl0DaPD2cUac+JDTrvcCkE8=;
 b=ZrB8excrO9S+tjcEQn40hmjYBoEsoK4RU8JJD9c+qZNue60FzkzNrslWjg+kspeJvRjU
 6HmnaF+4XLjrHwjzhTc/iiNJEh6NL9pkEAFHLDjPLT3Ne/rJ0TRj5B/ZDN/Ki7JVbYaE
 FzRcn6YpmqS31nKN7JHPitoqz2juHJ6QfiLYKhNyHxFhhR3hq7ZghvjfTq+3MUwR1AVI
 OeFc5UIXuGmhpYfaiJEjSs4vu+CXel3t06VgEk9ECMIJHsg2MI6WyniA4FH4N5dy4kHb
 0XCeSI3vOD3T0p0dEbuTns18dch6b0lEw7dTTsZTqHQ6QYnTwvN91ccsADPomMcuS7ag EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xfttec3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 02:55:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0032nJf4168756;
        Fri, 3 Jan 2020 02:55:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x8bsttb31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 02:55:17 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0032tAWa020448;
        Fri, 3 Jan 2020 02:55:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 18:55:09 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] qla2xxx: Improve readability of the code that handles qla_flt_header
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191219004706.39039-1-bvanassche@acm.org>
Date:   Thu, 02 Jan 2020 21:55:07 -0500
In-Reply-To: <20191219004706.39039-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 18 Dec 2019 16:47:06 -0800")
Message-ID: <yq1v9pt5jw4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=847
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=910 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Declare qla_hw_data.flt as a qla_flt_header pointer instead of as a
> void pointer. Add a zero-length array at the end of struct
> qla_flt_header to make it clear that qla_flt_header and qla_flt_region
> are contiguous. This patch removes several casts but does not change
> any functionality.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
