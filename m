Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA37C2BD09
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E722073D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:15:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uvc4ao3U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfLIXP6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 18:15:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38682 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfLIXP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 18:15:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9NEXAt192736;
        Mon, 9 Dec 2019 23:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=nVMKkNRVusSAquMj4+OPkuKnOWiU08LDTPsMrN1zdc4=;
 b=Uvc4ao3Uxp9DQj4U+2D/kblKFQG977g6XHvoB2V2fCq0J2QalegHh+YbjcIO8qA26e7Y
 Ar9LfyXrDrI5M8T4Qj30fqe7lZEqFDJ5jt0KL+pz8dtnL+5fcbG9Edz4c7JBpD2aw2Yf
 AQAwZKOscuiYJMF/eUvUN3WyZSO32+ttI89kVq3UPfL+M2e8PWnBKQAAUj63IpbuDMEc
 QfsUKmlZGCd13auuWWeGyRy1vUhI2ZkLgKg/35nd7k4HYmbid8h6pP2jT/g4/brSSR4P
 TONw60wL3b5KllzctJKm0FsPMEqODYZIoB1SqpO2pigHcMusVMTlqjLoZMMQaj2UUPLK PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wr41q2rrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:15:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9NEk2D160118;
        Mon, 9 Dec 2019 23:15:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wsru823tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:15:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB9NFi9Z002004;
        Mon, 9 Dec 2019 23:15:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 15:15:44 -0800
To:     Kars de Jong <jongk@linux-m68k.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-m68k@vger.kernel.org, schmitzmic@gmail.com,
        fthain@telegraphics.com.au
Subject: Re: [PATCH v5 0/2] Some esp_scsi updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191119202021.28720-1-jongk@linux-m68k.org>
Date:   Mon, 09 Dec 2019 18:15:42 -0500
In-Reply-To: <20191119202021.28720-1-jongk@linux-m68k.org> (Kars de Jong's
        message of "Tue, 19 Nov 2019 21:20:19 +0100")
Message-ID: <yq1k175qee9.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=718
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=799 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090183
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kars,

> When trying kernel 5.4.0-rc5 on my Amiga, I experienced data transfer
> failures when reading from my FAST-10 SCSI disk. I have a Blizzard
> 12x0 IV SCSI controller which uses a Symbios Logic SYM53CF94-2 "FSC"
> chip.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
