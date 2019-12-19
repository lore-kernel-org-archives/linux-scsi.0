Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C221C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E77524676
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gNErIB7X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfLSXbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:31:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41022 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLSXbY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 18:31:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNTXOg073864;
        Thu, 19 Dec 2019 23:31:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=XM5vEgks4cb5sO1+swRp9MqjfBI14nr9sYPl3TxMAqY=;
 b=gNErIB7XnekOcNUEIqxZj9UdMaBZoMIaI5fbujuKglUTC1yc/PrkbpcpcYn9FMkGeX4E
 uuK/RY6c8Yd3RegXjPFElXXBxZDP0pE4tulQqo5tR8O07HlAPDn2kluY47ugfWZK+WUK
 FWtZQ4No1keyQLwf4+BBZ5cwdu4+lpBqx65Bkae/CSRQS5p7r1FK/G8qFOTAydgpOGA/
 9WHer9hWKOYvMTR80DjD5uHvMOlf9iNIUR8eFslewEunlEPxHm+p2l9qcxX4ncpkm+/w
 jPQUn0vqPyANcTFWzK04TkltQMhc/0XngLtXCKdeiErYkHq8K0TwxxSgXEDCrCEAGDoo Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x0ag12v5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:31:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNNDTq162361;
        Thu, 19 Dec 2019 23:31:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x04ms5u1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:31:16 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBJNVElb017175;
        Thu, 19 Dec 2019 23:31:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 15:31:14 -0800
To:     Michal =?utf-8?Q?Such=C3=A1nek?= <msuchanek@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: blacklist: add VMware ESXi cdrom - broken tray emulation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191217180840.9414-1-msuchanek@suse.de>
        <yq1bls6h9ir.fsf@oracle.com> <20191219143422.GJ4113@kitsune.suse.cz>
Date:   Thu, 19 Dec 2019 18:31:12 -0500
In-Reply-To: <20191219143422.GJ4113@kitsune.suse.cz> ("Michal =?utf-8?Q?Su?=
 =?utf-8?Q?ch=C3=A1nek=22's?=
        message of "Thu, 19 Dec 2019 15:34:22 +0100")
Message-ID: <yq1pngjc2pr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190173
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Michal,

>> Please don't introduce a blist flag to work around deficiencies in the
>> matching interface. I suggest you tweak the matching functions so they
>> handle a NULL vendor string correctly.
>
> I don't think that will work with the interface for dynamically adding
> entries through sysfs.

Please make it work :)

There's nothing conceptually wrong with being able to do:

        echo ":Model:Flags" > /proc/scsi/device_info

We keep running into issues where the same device needs to be listed
many times because it gets branded by different vendors.

Brownie points for making all this less clunky. The libata globbing
blacklist works much better, fwiw.

-- 
Martin K. Petersen	Oracle Linux Engineering
