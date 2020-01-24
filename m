Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4FAC35240
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 01:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C73B21835
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 01:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UtWNHzkp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgAXB7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 20:59:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37832 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbgAXB7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 20:59:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O1wskm087187;
        Fri, 24 Jan 2020 01:59:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=taQdrRdcpKgSpb6y35yA3R4kkotFmZIEdBjVF+7xJFA=;
 b=UtWNHzkp9LavK0w8BqruHzWK9jOg+iytTwVR5n79rOVo6f2yGQPq1lKCQPQuLcV9xKSt
 U9DWbtOPl5/kD/y6fZCU3dC44AVMJi9Cd5tmeUh84ovfG4VAVzJRo1viwpzGrVQ2O2Dc
 VgwQfShC80M+9T6X2+fWq1qbD3yITN44ClYF0MRvdMR/o6mfC+8LSmMZYwTKZ83+j3rr
 oxOcKzbCO4S5QpYh0OL/oOeoo0xTG7qDL9oVHMRPlYD/tgoHbUD8mbcwIR6Vdne6aHCc
 XSRWhxWS7L48cR5qESBkkrcvsw9E6xEEY+WXyUnOuVwm5JlLeqCSFuIY28MjWOetT68R pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnrp3a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 01:59:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O1xFSl190955;
        Fri, 24 Jan 2020 01:59:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xqmwbjq4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 01:59:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O1wWRi027709;
        Fri, 24 Jan 2020 01:58:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 17:58:32 -0800
To:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD when HBA needs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200119071432.18558-1-ming.lei@redhat.com>
        <20200119071432.18558-6-ming.lei@redhat.com>
        <yq1y2u1if7t.fsf@oracle.com>
        <ab676c4c-03fb-7eb9-6212-129eb83d0ee8@broadcom.com>
Date:   Thu, 23 Jan 2020 20:58:30 -0500
In-Reply-To: <ab676c4c-03fb-7eb9-6212-129eb83d0ee8@broadcom.com> (Sumanesh
        Samanta's message of "Thu, 23 Jan 2020 17:01:47 -0700")
Message-ID: <yq1iml1ehtl.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240012
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumanesh,

> The high-end controllers might expose a SCSI interface, but can have
> all kind of devices (NVMe/SCSI/SATA) behind it, and has its own
> capability to queue IO and feed to devices as needed. Those devices
> should not be penalized with the overhead of the device_busy counter,
> just because they chose to expose themselves has SCSI devices (for
> historical and backward compatibility reasons).

Please read what I proposed. megaraid VDs don't report QUEUE_FULL so you
would not trigger the device_busy counter.

-- 
Martin K. Petersen	Oracle Linux Engineering
