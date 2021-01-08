Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8A6C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3F82222B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbhAHEUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbhAHEUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084Ah0x097543;
        Fri, 8 Jan 2021 04:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VXqy0Yubrb9YIPhsD89U9Z1B1JMvZmZ02i71r3a9XWs=;
 b=tkOahpfSsCxXoMFZ/iFvoojVWRV7e53TaWYe0ZDLdoqdAqP054hzYmQjJam1SQHTUbmd
 e9w8MamKgTYM9upBIxUYwEpWGvGIXHUpftkxnkVzm4S1tB2lE5fMYizjVwTiZWAbrbwD
 7fO+6qtmKLq3wsFkMDCH9fNChUrl7u37cGy/7/lnB/IiQBH3E7nQfDTG7WjUbytKHOzr
 pZrlBykAEV5qu2UDaYFz08vj2X1Fr7n9KH4lO0qrl5UYel+TLxgtaDL0lSMM4tFTnHZX
 UlHOhbR8WGQLwOWqVfOu+FHAUcBPCuti0wzWv1m8pHnx2HZXX5sqIrlcAN01iRSs6426 RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35wepmfd91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084AUPu040421;
        Fri, 8 Jan 2021 04:19:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35w3qut08c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:47 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1084JioF012398;
        Fri, 8 Jan 2021 04:19:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 04:19:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Phil Oester <kernel@linuxace.com>,
        megaraidlinux.pdl@broadcom.com,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Yan <yanaijie@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression
Date:   Thu,  7 Jan 2021 23:19:30 -0500
Message-Id: <161007949339.9892.62073728856164785.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104234137.438275-1-arnd@kernel.org>
References: <20210104234137.438275-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 Jan 2021 00:41:04 +0100, Arnd Bergmann wrote:

> Phil Oester reported that a fix for a possible buffer overrun that I
> sent caused a regression that manifests in this output:
> 
>  Event Message: A PCI parity error was detected on a component at bus 0 device 5 function 0.
>  Severity: Critical
>  Message ID: PCI1308
> 
> [...]

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression
      https://git.kernel.org/mkp/scsi/c/b112036535ed

-- 
Martin K. Petersen	Oracle Linux Engineering
