Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465D5C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 02:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12236206F8
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 02:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pYbVzvk+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387439AbgDBCHU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 22:07:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732462AbgDBCHU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2020 22:07:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03223boR185375;
        Thu, 2 Apr 2020 02:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=WZXyOYO9D/+sJyG8OFa+UWGWzbiIHW42gHIui+JUTGc=;
 b=pYbVzvk+B07jXcf/KJtmehgVC8/FV3kqEXpp+tEnQpfZmPMfMYyuIUaoQ3128K56Drmq
 3YmpiDugBh4BS9Hp7Zkt6wp+TIH56+LvTDlnkN1TgLEbSHYTQC9iPJtgCmyzFXAKwIHZ
 BZP3a4AqTVc68eb8LcZhPMwUFXFCBbFNbRJY7ZWedYKk5tU2uk5782u93pEpOmECxR2Z
 v5fSsZBjBSGxAhTpnl1SGcYTCLyrmjiijbiHUe6z7N6P0JrXkx3Atkvu2R7wht4IQVhE
 wbCOWe2T7zH9T0a3GmtpAHJmj51Fl5Vh5OGNz7coiu1EN5UY/OaWpJW/Un5S0WA5MHJk Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 303yunb9xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 02:07:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03222831098458;
        Thu, 2 Apr 2020 02:07:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga1h9pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 02:07:02 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03226xks013183;
        Thu, 2 Apr 2020 02:06:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Apr 2020 19:06:58 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     John Garry <john.garry@huawei.com>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] scsi: remove show_use_blk_mq()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200401134049.9352-1-yanaijie@huawei.com>
        <57f6fde1-fe0c-68e7-f476-35d92902c6b1@huawei.com>
        <ba97c964-1da2-e465-f472-dce50dcfd3f6@huawei.com>
Date:   Wed, 01 Apr 2020 22:06:56 -0400
In-Reply-To: <ba97c964-1da2-e465-f472-dce50dcfd3f6@huawei.com> (Jason Yan's
        message of "Thu, 2 Apr 2020 09:19:55 +0800")
Message-ID: <yq1zhbu4p4v.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Maybe. But removing a module param may break the user space too.

It won't break loading the module.

The intent is to leave the sysfs parameter in place for a while to make
sure nobody depends on it.

-- 
Martin K. Petersen	Oracle Linux Engineering
