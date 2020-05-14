Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434A2C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 19:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F562206A5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 19:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IqBExic+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbgENTJa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 15:09:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46502 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728395AbgENSws (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 14:52:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EIqfTQ095751;
        Thu, 14 May 2020 18:52:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tvqIBLu6lg3y2HnIlnc3WUWvJNdM68/P14TI1Bz48Ko=;
 b=IqBExic+AJyH/zGV1srQ0P7B4BkhVT5S+sQRFSsst9tUg/5Fzwj+Eh2Jed3RaqK0R+4v
 xYIoMss74L4W/2DKPv6F76Y+XNPnIOLFA+f9x1Kuh+AIn0z2J3pRjtxZV1lCP8RtZxQ+
 AHFnCXXVlmCIbfEUYAq4Uj+0TbphU1GbIzJm4EfHCYhD8JRS+QYsOJxi1wvdUA2ncLJA
 gZtJa7mMIMzliI/WIb0ee0p4agQq29FN3xouDOdkxYbmFPIFOsMyRAZtOGw+9ocCSDxh
 lLo2mqlSCIMeoHRd6ZPaaGmBpf5d4FzNSy29IcaVCW2rbIyjOxmdQYBN3bRZuKL8734g jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3100yg4euq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 18:52:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EIqjh3022951;
        Thu, 14 May 2020 18:52:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3100ypvq3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 18:52:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04EIqVrM028726;
        Thu, 14 May 2020 18:52:31 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 11:52:31 -0700
Subject: Re: [PATCH 2/3] qla2xxx: SAN congestion management(SCM)
 implementation.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200514101026.10040-1-njavali@marvell.com>
 <20200514101026.10040-3-njavali@marvell.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <0f9ffb1c-7c6b-ff64-d3f3-387948b41bd6@oracle.com>
Date:   Thu, 14 May 2020 13:52:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514101026.10040-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nilesh,

On 5/14/20 5:10 AM, Nilesh Javali wrote:
> * Firmware Initialization with SCM enabled based on NVRAM setting and
>    firmware support (About Firmware).
> * Enable PUREX and add support for fabric performance impact
>    notification(FPIN) handling.
> * Support for the following FPIN descriptors:
>    	1. Link Integrity Notification.
> 	2. Delivery Notification.
> 	3. Peer Congestion Notification.
> 	4. Congestion Notification.
> * Mark a device as slow when a Peer Congestion Notification is received.
> * Allocate a default purex item for each vha, to handle memory
>    allocation failures in ISR.

When you repost this series, fix comments for function header and places 
where its using windows style comments in this patch.


-- 
Himanshu Madhani
Oracle Linux Engineering
