Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A992C18E5A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 02:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CFB021927
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 02:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OCMhO/TD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgCKCjJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 22:39:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgCKCjJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 22:39:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B2WqLK082735;
        Wed, 11 Mar 2020 02:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=T1vuTLFwybasjMVmh5QNYh7y/tteWNgXqxwplD/1b/Q=;
 b=OCMhO/TDcuSj1zxgMMDqFgTRISFo3vHpcBUHaLzX+lDUwLXv0pC8ExJnOp1Dnc1bBotA
 WbIFulHYrPB0TYGzPfHjbQtyINw+3Z/ICYk5sbrgHjUjKNTKxWzEmFVK+vMGBnUd+pHr
 DIzn0tlfjaDGr10cvl7kqbh8nRNznjs4cdg8H0W2Zn5rW3KXKr42vLWPgZ75mULl3pD8
 hMVZrlMcm+q4AJJgTMF0lHj16Q/0YOCfJ4K0grog6UcejbfkUVFQ61VSLt3zwlTB6I2p
 mELAZ8yWsvsgUw0ETvEflqGqj0bYJDWGgF+oy+u6mSeRw2zhHp2SdH7haMuhnaZE4QVA EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yp9v6419s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 02:38:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B2YW9E130583;
        Wed, 11 Mar 2020 02:36:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yp8pvkacc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 02:36:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02B2aqgp013711;
        Wed, 11 Mar 2020 02:36:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 19:36:52 -0700
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     john.garry@huawei.com, aacraid@microsemi.com, bvanassche@acm.org,
        jejb@linux.ibm.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com
Subject: Re: [PATCH v3] scsi: aacraid: cleanup warning cast-function-type
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <9a0e6373-b4a3-0822-3b65-e3b326266832@huawei.com>
        <20200309155319.12658-1-tranmanphong@gmail.com>
Date:   Tue, 10 Mar 2020 22:36:49 -0400
In-Reply-To: <20200309155319.12658-1-tranmanphong@gmail.com> (Phong Tran's
        message of "Mon, 9 Mar 2020 22:53:19 +0700")
Message-ID: <yq1o8t3r51a.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=962 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Phong,

> Make the aacraid driver -Wcast-function-type clean Report by:
> https://github.com/KSPP/linux/issues/20

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
