Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FC0C388F9
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 22:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F0E20B1F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 22:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X1fa+KeE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393588AbgJZWX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 18:23:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47576 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393583AbgJZWX1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 18:23:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMFJi4062018;
        Mon, 26 Oct 2020 22:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=emhWMktnclQMOOmxz8sOWxEItdTMM71hGUV7xkNfgns=;
 b=X1fa+KeE4Cm4QcpGl6Fa6X4HsJLpQoCv8bCmA+HbeME+7YUZj0W3TcJUFXEM/mMoJV0m
 wWKWIfxZ7Na1yz5hH/D4nu5zDhZ/5mEV0DQitIh8mHUXjW1vcLQJgDfUi6ouwqUEfC9z
 hgxOx+GEbnhAdOchjpmmq9/d9Hd3iO2QFRmoLhW6CWLYCO8RnTZ0+wUqWcAF4TF+ODcn
 yoEvoCyx3nKEtchCYkyFI32seFJLcXZOANSWiuvw0vZbEKXbB7plmd8FolLnTz5Pzdjg
 rc2CWSvifUOPBuVA9q4CpMV+/XXyWNh+VUryKENieePCVi5zkw1QiHnPAgraAyIS/nO0 DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9saq72q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 22:22:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMLFkr159252;
        Mon, 26 Oct 2020 22:22:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6v8qbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 22:22:33 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QMMRjM030164;
        Mon, 26 Oct 2020 22:22:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 15:22:27 -0700
To:     trix@redhat.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, skashyap@marvell.com,
        jhasan@marvell.com, hare@suse.de, don.brace@microchip.com,
        linux@highpoint-tech.com, brking@us.ibm.com,
        intel-linux-scu@intel.com, artur.paszkiewicz@intel.com,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        yokota@netlab.is.tsukuba.ac.jp, njavali@marvell.com,
        Kai.Makisara@kolumbus.fi, willy@infradead.org,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, storagedev@microchip.com
Subject: Re: [PATCH] scsi: remove unneeded break
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pn547hmd.fsf@ca-mkp.ca.oracle.com>
References: <20201019142333.16584-1-trix@redhat.com>
Date:   Mon, 26 Oct 2020 18:22:22 -0400
In-Reply-To: <20201019142333.16584-1-trix@redhat.com> (trix@redhat.com's
        message of "Mon, 19 Oct 2020 07:23:33 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 suspectscore=3
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260144
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tom,

> A break is not needed if it is preceded by a return or goto

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
