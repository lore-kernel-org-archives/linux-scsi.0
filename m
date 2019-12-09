Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0622DC04E30
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D12CF2071E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZX8PtOrZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfLIXS7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 18:18:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfLIXS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 18:18:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9NEOc2189054;
        Mon, 9 Dec 2019 23:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=1hHPUUqK8S/dULrSvDP3f0npIWlbovAtTKUhCIJBB/w=;
 b=ZX8PtOrZP4AjBk2R1NknpVkO0sWmHjL00XFSkXRfAEvXdZzbKO56QZSpjaK7vuJ4NsON
 fDM5ee/ndfQ+M6r3jMcvww4h7RyyjtTagNdXSjGp7PQetdkCPTPEcrrJA/KFMt3lZmAf
 I5lcehtTM9TRqOWsC8liceEGRGUAMEuzj1Sd36jZ5UrfSExb2p879sQQF5ZYN1/olWT7
 ELiLeTsg6hVe0Mhz/3/JdOacLeGTr4vNpj+WDiUxlz0eJSBFytv83KW7gd8fpgZNLc/e
 QWoD7t4jL6HD5WuqwM+fJCozpuVGvGIoUqkS2m3L1gWs5XYRliT1gNPrYhOTko5gYIIU oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wr4qranpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:18:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9NEjUE160042;
        Mon, 9 Dec 2019 23:18:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wsru82701-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:18:52 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB9NIpSh003567;
        Mon, 9 Dec 2019 23:18:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 15:18:51 -0800
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191109042135.12125-1-bvanassche@acm.org>
        <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
        <af903206-ce02-ef50-567f-d647efe0476a@acm.org>
        <20191202205554.5p77fyot6bc2ij6t@SPB-NB-133.local>
        <10e0c0c1-f3ad-7233-995d-59f1b748e39f@acm.org>
        <20191204120715.dgpr6xcdcckkae4q@SPB-NB-133.local>
        <90b2e3b3-4d9c-d997-37a3-fb8c5bc6d927@acm.org>
Date:   Mon, 09 Dec 2019 18:18:48 -0500
In-Reply-To: <90b2e3b3-4d9c-d997-37a3-fb8c5bc6d927@acm.org> (Bart Van Assche's
        message of "Thu, 5 Dec 2019 22:03:03 -0800")
Message-ID: <yq1fthtqe93.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=720
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=784 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090183
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Firmware can do implicit login, and this is how it worked for a
>> while.
>> 
>> Then explicit login was introduced in the commit you referenced by
>> setting bit 8 in IFCB fimwrare options 3 for 2600/2700 series and
>> issuing ELS IOCB. However, for 2500 series, bit 7 should be set to
>> disable implicit logins.
>> 
>> The latest commits that touches the bit is 8777e4314d397 ("scsi:
>> qla2xxx: Migrate NVME N2N handling into state machine"). It sets the
>> bit in qla24xx_nvram_config regadless of chip.
>> 
>> Does it help to set bit 7 in IFCB, firmware options 3 for 2500 series
>> and leave the RESERVED S_ID field untouched?

Himanshu: Please advise on how to fix this regression.

-- 
Martin K. Petersen	Oracle Linux Engineering
