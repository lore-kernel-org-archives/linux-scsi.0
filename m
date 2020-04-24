Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2461DC54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 16:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0440920857
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 16:49:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EqcSW7yI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgDXQti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 12:49:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41218 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgDXQth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 12:49:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OGmrRr029656;
        Fri, 24 Apr 2020 16:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=nNYSh5k6xwe8DoqI9uKkrfPMSL0GeIOszrxes7VfxaY=;
 b=EqcSW7yIMQZX1A+cUsMWAApQ2HkewUrRqA7IovQ0rh2ihRWzdfMY04RR7bCJgAmF6li6
 aNYHsya7q4gNzS/kyhN4y3wP/wrgI0v7K2WYO4UtGNOeRdKlgb7/Lnd5I2XbZElH7Jku
 jBcdtknsyw8A764T832cXZw+7Rpydk/L9VWC/uC9+AYt45IxTpRHK/TuV8FSgXBtJ5L2
 xE0ehbeAYlq6Vt5yvMFWvBDLbAka/nl67hQb4pzWBgGy3Z3S0V7UEHRpXFrsyo5X5oGd
 tZbVqW02qIRfNkB/yrDQSkd50+TgxID/8dI7FuairEfr41p53IdFwRi9OHlEgjPhaSRO eQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30ketdneax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 16:49:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OGkhrg095612;
        Fri, 24 Apr 2020 16:49:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30gbbqm8wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 16:49:29 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03OGnQk0018093;
        Fri, 24 Apr 2020 16:49:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 09:49:26 -0700
To:     Alex Dewar <alex.dewar@gmx.co.uk>
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Use kzalloc() instead of kmalloc()+memset()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200403163611.46756-1-alex.dewar@gmx.co.uk>
Date:   Fri, 24 Apr 2020 12:49:24 -0400
In-Reply-To: <20200403163611.46756-1-alex.dewar@gmx.co.uk> (Alex Dewar's
        message of "Fri, 3 Apr 2020 17:36:10 +0100")
Message-ID: <yq1mu70esmj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240131
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

> There are a couple of places where kzalloc() could be used directly
> instead of calling kmalloc() then memset(). Replace them.

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
