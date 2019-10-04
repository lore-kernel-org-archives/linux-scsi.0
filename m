Return-Path: <SRS0=tG2Y=X5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0C5C10F14
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 01:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C80320862
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 01:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="crZrhvNg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfJDBqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Oct 2019 21:46:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52388 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729891AbfJDBqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2019 21:46:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941j8M0048737;
        Fri, 4 Oct 2019 01:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=RJQdZFxBWIYX96pchD7HqTSPHJaX4qzUeE/6y+0fzEk=;
 b=crZrhvNgC/X0+vC8BufedLAjuahrGItOMvEztIExDRnmL8LNaOk/xTK3QQcPxSMqX0Qd
 6YSrdhouFhhtXWvKoU7tZFdrEmIj/pDwdaz9g2YaQxzM0XyKAJzGoWCOc+vvmy7/P/4x
 IinnYJIi/24HuT0Zc2DSz0uVz4dXdqvFdo+7w06/0UVr0DSoXsd7eCOpPunMjmpYmKN/
 voB2eDyND16tRYYK56k/Ezh/horxQDbiudOGMUS/CDSkNWwIGiWSuNbk76SducCz9P14
 5J0vaaHf5DD4BaV+PpmZxu5gxULOrTp9Fyb3gjLSMH+NDLLP6cndZlt73KUzJ1I74V4x VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v9xxv8733-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:45:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941jiK2061395;
        Fri, 4 Oct 2019 01:45:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vdk0tb50r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:45:58 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x941j3JX012844;
        Fri, 4 Oct 2019 01:45:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 18:45:03 -0700
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH V3] scsi: save/restore command resid for error handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191001074839.1994-1-damien.lemoal@wdc.com>
Date:   Thu, 03 Oct 2019 21:45:00 -0400
In-Reply-To: <20191001074839.1994-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Tue, 1 Oct 2019 16:48:39 +0900")
Message-ID: <yq1tv8ps2qr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=908
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> When a non-passthrough command is terminated with CHECK CONDITION,
> request sense is executed by hijacking the command descriptor. [...]

Applied to 5.4/scsi-fixes. Thanks for debugging this issue!

-- 
Martin K. Petersen	Oracle Linux Engineering
