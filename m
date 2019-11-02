Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BADCA9ECF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0F3F208E3
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CQhnScgw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfKBAW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 20:22:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45412 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbfKBAW6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 20:22:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA209ALg014779;
        Sat, 2 Nov 2019 00:22:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Zr+2/CGypW8li7ScROmNO0zVn0QbL0c+ibQmK9V/bp8=;
 b=CQhnScgwP8TC8AvCXx5uVnDzFYupy4hTGmee0eyi4Oc6uNsEUWvl3St7OSJy6SNa3Oxd
 dZIMazEKH540iSRdEpTOv+xSQqQNp4AD6aSw2Dx9Hix1hnMVubUpo0WrwC6XFtgAtU9c
 4mqTVPVNMJqttY3WSjhIQlkSHS/Sz0+JwLoCtELWPWYUs2ioc6WTdRtvJzJCuk95SpJs
 dZLBPjKQFOatr0ctjQ/H5TtM+jA/rW3YqQEkWZ/iOqUPbCFcBMqW1uIB+QeUbdCjEH9k
 LTSh1A46gbfIe9wQiB5TuVDDyf9JbjNpN9VDPRqhxtiA+NclqUYG43keaT1L0Ml/Sh98 Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vxwhg4het-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:22:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA208u8E140961;
        Sat, 2 Nov 2019 00:22:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w0rusetr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:22:40 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA20Md9g003201;
        Sat, 2 Nov 2019 00:22:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 17:22:38 -0700
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, varun@chelsio.com,
        emilne@redhat.com, gregkh@linuxfoundation.org, hare@suse.de,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
Subject: Re: [PATCH] scsi: csiostor: Return value not required for csio_dfs_destroy.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191028194234.GA27848@saurav>
Date:   Fri, 01 Nov 2019 20:22:36 -0400
In-Reply-To: <20191028194234.GA27848@saurav> (Saurav Girepunje's message of
        "Tue, 29 Oct 2019 01:12:34 +0530")
Message-ID: <yq1sgn75dpv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=788
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010224
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=887 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010224
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Saurav,

> Only csio_hw_free() calling csio_dfs_destroy() and it is not
> checking return value. So remove the return from csio_dfs_destroy().

Applied to 5.5/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
