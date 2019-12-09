Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9A2C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C41702073D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ix9Owl8+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfLIXJp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 18:09:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfLIXJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 18:09:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9N9IsW005786;
        Mon, 9 Dec 2019 23:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8tjmVSeobmMgjonTroVTxesPehyw5ZOz2eTvOwDYaIQ=;
 b=ix9Owl8+yPjzAGYtgiSvAz7bur2EksS6KCkJK+yiT7g30omzAp4kJB9zYMiNgCGBol3F
 RpK4m1aTD2Bomv5Gsf6DAIyDn3wXF4WGMMqHo8/BGtELAs9k6I1guYykAyRrkb9IBbkQ
 JyX0EG99XuKVAVpIX2BwX2h4CjIJJ0+lRw/HabBZ0r4e7bqshoT/Zq/1o+nrwUqnJGi+
 v9gdWc/IIPBGUAXC6txEisif3dvvTS2PoeddspJ2sfFVO7DYyh7V9Rezep0DgrVUIUw1
 6EEFlplXPfTUVbL2qOgHJfxzsYrh3tzEHx15eKLpd+xc68CqMEhmilmDNrPC9Nlu6JDf 0A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wrw4myj5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:09:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9N9NP7149624;
        Mon, 9 Dec 2019 23:09:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wsru81vt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:09:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB9N9AaX015611;
        Mon, 9 Dec 2019 23:09:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 15:09:10 -0800
To:     "wubo \(T\)" <wubo40@huawei.com>
Cc:     "james.smart\@broadcom.com" <james.smart@broadcom.com>,
        "dick.kennedy\@broadcom.com" <dick.kennedy@broadcom.com>,
        "jejb\@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "martin.petersen\@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: Re: [PATCH] scsi:lpfc:Fix memory leak on lpfc_bsg_write_ebuf_set func
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E7A966@DGGEML525-MBS.china.huawei.com>
Date:   Mon, 09 Dec 2019 18:09:08 -0500
In-Reply-To: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E7A966@DGGEML525-MBS.china.huawei.com>
        (wubo's message of "Sat, 7 Dec 2019 03:22:46 +0000")
Message-ID: <yq1sgltqep7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090182
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


wubo,

> When phba->mbox_ext_buf_ctx.seqNum != phba->mbox_ext_buf_ctx.numBuf,
> dd_data should be freed before return SLI_CONFIG_HANDLED.
>
> When lpfc_sli_issue_mbox func return fails, pmboxq should be also
> freed in job_error tag.

Applied to 5.5/scsi-fixes.

Please make sure your Author: string matches your Signed-off-by:. Also,
please use checkpatch!

-- 
Martin K. Petersen	Oracle Linux Engineering
