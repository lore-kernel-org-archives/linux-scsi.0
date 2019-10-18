Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970BACA9EC9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 05:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 686A12064A
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 05:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EvFUChpm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405307AbfJRFuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 01:50:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36556 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfJRFuG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 01:50:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I2Y3Ca145940;
        Fri, 18 Oct 2019 02:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8h6xwIncBn1iW94mNqc4k4qljgcfBF3+FzfDP4/FvUE=;
 b=EvFUChpmn3AGeaYHsQefsz8aw14DdKYv9W39dTgu+Jkn/avVNyjsJcQpTWJVhVYIEHJR
 V4OSKN/5XUt4cRuWJFgWk32soJrXhjE1PlwWo7FqlQFMhtS4WCVlHaUky3m64LwxNi9D
 18jiPboJfVZOeg25KRKv/KVPyIQmjDm8NlhgSrpaBUu0FOwW9lP42enPxl9rESvyC9nN
 3AMbYDVeaX8PvsN1bvllrlU0RjUCCd68/PnmLNn7S5Fb4rlVbKF5t2m3rE9DCqLgENGb
 vhNYSiprgC1utDYjUihEpGa0eYL/YnQ+LPYFv4zbHc3Mfhx65nvq1onVp8OryByPZTaR fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vq0q48uj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 02:38:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I2cMpW065724;
        Fri, 18 Oct 2019 02:38:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vq0ed4bt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 02:38:56 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9I2crr4022384;
        Fri, 18 Oct 2019 02:38:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 02:38:53 +0000
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <yi.zhang@huawei.com>
Subject: Re: [PATCH v4 1/2] sr: need to check whether sshdr is valid in sr_do_ioctl
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1571293177-117087-1-git-send-email-zhengbin13@huawei.com>
        <1571293177-117087-2-git-send-email-zhengbin13@huawei.com>
        <yq1a79ykdjh.fsf@oracle.com>
Date:   Thu, 17 Oct 2019 22:38:51 -0400
In-Reply-To: <yq1a79ykdjh.fsf@oracle.com> (Martin K. Petersen's message of
        "Thu, 17 Oct 2019 22:12:02 -0400")
Message-ID: <yq136fqkcas.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=541
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=627 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zhengbin,

>> Like other callers of scsi_execute(send_trespass_cmd, hp_sw_tur...),
>> we need to check whether sshdr is valid.
>
> Applied to 5.4/scsi-fixes, thanks!

Actually, after looking at this again, the function is making the
assumption that if driver_byte(result) != 0, then the sense is
present. It really should check both driver_byte(result) == DRIVER_SENSE
and scsi_sense_valid(sshdr) before poking at the sense data.

-- 
Martin K. Petersen	Oracle Linux Engineering
