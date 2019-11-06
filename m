Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F074EC5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 05:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE017217D7
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 05:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aKg3kg0u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbfKFFCS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 00:02:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfKFFCS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 00:02:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64wolA089081;
        Wed, 6 Nov 2019 05:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=NjqShIr0eTXs7H+3Bd+eIfAPs602OYG2P/RM6BaAgbw=;
 b=aKg3kg0utqkSDExVsLtPYJfHfsPoqwhQuW4Na+5RxjEqjRnbMAkqTGMmd/3WjMzIsWTl
 qRGp+F+hK5IysoVJBe5j33w0aYro3nvFraPuBUa7Nm195KpgqIb4Lk+XVWgzwI+PZZ5W
 xhazie/UBCzOgNMYtw6mUdp1pQ6FybEnQgzC2RwukGCCRwgp4rrZesEH+bQ6zFnZp1jE
 ahajmyL0kW1VfWljLtOpEB86oCJDTLlKfHF7+AT917Rqa6deDon74H1oQtUE3PbbT8Nr
 nEgVSDHXN3Dd58Ohy0jnQn23+AJuYy4Rn2eYXKFRPrbAUICXmMOwfzl7NE39y8NoMEAR EQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w12erb0qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:02:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64xK0o147027;
        Wed, 6 Nov 2019 05:02:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w333wjnyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:02:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA6520H6018046;
        Wed, 6 Nov 2019 05:02:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 21:02:00 -0800
To:     Martin Wilck <Martin.Wilck@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Daniel Wagner" <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND v2] fixup "qla2xxx: Optimize NPIV tear down process"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191105145550.10268-1-martin.wilck@suse.com>
Date:   Wed, 06 Nov 2019 00:01:58 -0500
In-Reply-To: <20191105145550.10268-1-martin.wilck@suse.com> (Martin Wilck's
        message of "Tue, 5 Nov 2019 14:56:00 +0000")
Message-ID: <yq136f138e1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=709
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=808 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060052
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

Applied to 5.4/scsi-fixes, thanks.

Next time, please run checkpatch on your patch and please make sure you
get the ordering of commit description and commentary/changelog right.

-- 
Martin K. Petersen	Oracle Linux Engineering
