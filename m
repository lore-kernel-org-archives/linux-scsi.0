Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5ADFC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 02:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97B5920825
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 02:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tp6MxkR2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733052AbgKEC6i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 21:58:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41566 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732559AbgKEC6i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 21:58:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A52sx7P090538;
        Thu, 5 Nov 2020 02:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=W/1TissJbzD6xSkkqsokMINoZ34UrX/RxfLjTq+Qk7I=;
 b=Tp6MxkR2N3O8maBR4ZT7I/85b1iyh0UfLe72pStIthzdqIDFkXNnycOKrnWbgRdOjCgd
 UbI3lOgLs6I3Rs10O1TniLvi/15kcB2IicwiW5iAS91zgwh0Dr3DaNSDSYHf4U10bQV8
 QxOMZSvfZ/Vg+vuX/bSvDpCGT1aGpDMD7fnzU/z0YKGWks0Vh6gpShjWsaEDG8FF9n2f
 fGEGxUi46DBQnuP8eD+M1xEK0WzK/bznd2nIz38dKoe0FRxd2g9J5PiR9wu+seuxrBUQ
 k3dgUtHB7FMQ6xqUHis+SKhyuB9NmiLGUa7KNjvc0gaMHBz2CzODbOSATNzGGhuL2VCH pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34hhw2stfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 02:58:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A52tmFu002753;
        Thu, 5 Nov 2020 02:58:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34hvrytkqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 02:58:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A52wY1Q012935;
        Thu, 5 Nov 2020 02:58:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 18:58:34 -0800
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH v1 00/14] mpt3sas: Add support for multi-port path topology
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7q4tssf.fsf@ca-mkp.ca.oracle.com>
References: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
Date:   Wed, 04 Nov 2020 21:58:32 -0500
In-Reply-To: <20201027130847.9962-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 27 Oct 2020 18:38:33 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=1 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=1 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Through this patch set, the driver now manages the sas_device &
> sas_expander objects using 'SAS Address' & 'PhysicalPort'
> number as key.

Applied to 5.11/scsi-staging.

Please see Documentation/process/submitting-patches.rst for guidance on
writing commit messages. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
