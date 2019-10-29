Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A39CA9EC0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 01:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF93E208C0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 01:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="shrdyIlz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730337AbfJ2B6z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 21:58:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54130 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfJ2B6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 21:58:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T1rxAx088964;
        Tue, 29 Oct 2019 01:58:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=OIErngAPeCQNrcVluZFL+oKUc9W7C6owUwm1cx+a6yw=;
 b=shrdyIlzpTXdxmkVXeQoQb7L0cmH3tqGFvxTHpUHjNlH6aAe3P8t4S5CLPtjEkmt99vg
 Kp5a7/YlNK5lwlJObvyjRlnnvs4/9EigpFgWiuuoknE5ne1yPtA9uiJ3IhZwvgME1Oyx
 7Qb5Akir2Bx3qeebboVc3aC9bWJlLaDuVk7vqALpdUmgzXN2qlGNrTIBtl5V7HdlNRKZ
 ROEnGaNFConNH6mSeUWkVhLiPTu0csuOx8XnKIj9Ir8pUjv9GLpPhmZDeffTwM9V01mp
 i2j6y6sPYF9hU9ujmmtM67jHxGHCcpccQMUZMRxApB503YaWtL5MBt+GzZ7O7AR7ldsK lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vvumfah78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 01:58:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T1vwEX137203;
        Tue, 29 Oct 2019 01:58:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vw09gugvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 01:58:49 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9T1wkX3022805;
        Tue, 29 Oct 2019 01:58:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 01:58:46 +0000
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        zengxhsh@cn.ibm.com
Subject: Re: [PATCH] scsi: qla2xxx: stop timer in shutdown path
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191024063804.14538-1-npiggin@gmail.com>
Date:   Mon, 28 Oct 2019 21:58:44 -0400
In-Reply-To: <20191024063804.14538-1-npiggin@gmail.com> (Nicholas Piggin's
        message of "Thu, 24 Oct 2019 16:38:04 +1000")
Message-ID: <yq1h83s8g8b.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=526
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=625 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nicholas,

> In shutdown/reboot paths, the timer is not stopped:

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
