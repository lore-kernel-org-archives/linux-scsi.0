Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BB7C2BB1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E45320737
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:47:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D097tOZ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392682AbgDOBrg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 21:47:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387783AbgDOBrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 21:47:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1gxkc085152;
        Wed, 15 Apr 2020 01:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=WmbYu2O3yF2wXYEPuVo8l8V7RANT+hNBcsLrEVAvWvE=;
 b=D097tOZ+I4fXRykoTeLhImIAuGQ4bxoXDkc330roQnOntNmZADxEwc8WIP5PXIQQbO/q
 nudRe2fAQ73IWZpVbICJ1k0hvg/KiuKdJeQQhNoLonCLdJARAFOqchAIGwpYMaYCmPWA
 q4A2x0xSkcrisB8qduBZDQ/DynB9dqSpnUBpbD+9R7Gy2CCRdGGGNy6BTkKkA7LfYfhe
 QtRSpmeAlpXkP1db012vLMgrbAXunOr1DhY+GxgoZ6vnXGsVNeo3OFAEb9Lsg1C7Xc7i
 uclbJfaOmH/SEsEGyDGoKd0WYbtIgrup29+GuZEQ1UMlst5GqDKIyflkMjkjQMYanm/5 yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30dn9cgmjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:46:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1flhc017905;
        Wed, 15 Apr 2020 01:44:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30dn98g6tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:44:44 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03F1ifdg020838;
        Wed, 15 Apr 2020 01:44:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 18:44:41 -0700
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     linux-kernel@vger.kernel.org, boqun.feng@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Allison Randal <allison@lohutok.net>,
        Hannes Reinecke <hare@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
Subject: Re: [PATCH 6/9] scsi: libsas: Add missing annotation for sas_ata_qc_issue()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200411001933.10072-1-jbi.octave@gmail.com>
        <20200411001933.10072-7-jbi.octave@gmail.com>
Date:   Tue, 14 Apr 2020 21:44:38 -0400
In-Reply-To: <20200411001933.10072-7-jbi.octave@gmail.com> (Jules Irenge's
        message of "Sat, 11 Apr 2020 01:19:30 +0100")
Message-ID: <yq1zhbdplo9.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=965 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004150009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jules,

> Sparse reports a warning at sas_ata_qc_issue()
>
> warning: context imbalance in sas_ata_qc_issue() - unexpected unlock
> The root cause is the missing annotation at sas_ata_qc_issue()
>
> Add the missing __must_hold(ap->lock) annotation

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
