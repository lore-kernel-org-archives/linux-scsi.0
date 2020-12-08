Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAEFC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 03:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E3D523A5D
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 03:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLHD3O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 22:29:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgLHD3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 22:29:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B83A6ns130886;
        Tue, 8 Dec 2020 03:28:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=XXKFuLbv9CbLVfydTiQfFk6GtwkNNWu39vu/1add21k=;
 b=h8tQ2Bih3bX0kfQc/b+gC5x5cf0tTlW0r1bi1OmPMBG+YeRWbQv4vqvMcLNHgz094VNR
 GKXiaBnPzVCLNryxVV+Z4QOHJrekPFzxTp6fcCveS3NhqdfwkYlQMWgwgIHU9WWCxlVQ
 OShDyzFFXllYEZa+YFJPzzYIdsyPTqNSzQBwm7SWy1h1mOeg0dTgkerUPCHRITSZVaFt
 7avZwSZa98B9Ekr+dSS/UneJULA6Cu+L3okGrkvNtBHcIXRtV7ao5e59AM3v1Il/mZm8
 hm93cBfQjRDMspXKSOgpq57IW8X/HXkF6HjOm59mwMPDbPHfR9/8X3p6YPbOU4zPRSx9 IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3581mqrk2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 03:28:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B83Fh4p129047;
        Tue, 8 Dec 2020 03:28:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 358m4x4ygy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 03:28:29 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B83SSAL021525;
        Tue, 8 Dec 2020 03:28:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 19:28:28 -0800
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH v1 0/8] mpt3sas: Features to enhance driver debugging.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dptyo1f.fsf@ca-mkp.ca.oracle.com>
References: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
Date:   Mon, 07 Dec 2020 22:28:26 -0500
In-Reply-To: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Thu, 26 Nov 2020 15:13:03 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=877
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=891
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Suganath,

> Suganath Prabu S (8):
>   mpt3sas: Sync time stamp periodically between Driver and FW
>   mpt3sas: Add persistent trigger pages support
>   mpt3sas: Add master triggers persistent Trigger Page
>   mpt3sas: Add Event triggers persistent Trigger Page2
>   mpt3sas: Add SCSI sense triggers persistent Trigger Page3
>   mpt3sas: Add MPI triggers persistent Trigger Page4
>   mpt3sas: Handle trigger page support after reset.
>   mpt3sas: Update driver version to 36.100.00.00

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
