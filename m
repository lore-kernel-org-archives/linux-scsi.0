Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCE7C2BA2B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE5E20692
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qypbwXhy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403904AbgDNB7d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:59:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38144 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgDNB7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 21:59:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1wWIQ128662;
        Tue, 14 Apr 2020 01:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Pss09eBJvBQFMkNBerzkwr8grKGZSCPuJdKRQI0iY6I=;
 b=qypbwXhyoF8mF6bYdiGH8RRqpTWteyQuD7lBD8vZAAo22kvgrfv7itVr3il+4kWa8T4F
 EpZcJxT00ZWVeJYS4daY1f34mCijuzcnvc+tmJDS3IDtbEJyscb+pcqjF/6vdBvB7vE/
 a9T12H29lFnElAL8qH8+fv35VrINVn5cKoz/nFiahHL9p2t4FbhorlGTrFV9GUFnHoJZ
 pPSndRos+SqqlqJ3CiCaLHcwPzYbRPOmWOpd6bh/YGsHkafFOskjwjZHXQjMdJdbdeUS
 bJ054h7FrUN2XrzFrMCu/aIW077b4VdHVioVqIQxZbK0wPk89kIGMrv0NwZzsOQLyYDL jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30b5ar1pya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:59:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1vgrQ090924;
        Tue, 14 Apr 2020 01:59:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30bqcfyvg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:59:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03E1xHAk026817;
        Tue, 14 Apr 2020 01:59:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 18:59:17 -0700
To:     Li Bin <huawei.libin@huawei.com>
Cc:     <dgilbert@interlog.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xiexiuqi@huawei.com>
Subject: Re: [PATCH] scsi: sg: add sg_remove_request in sg_common_write
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1586777361-17339-1-git-send-email-huawei.libin@huawei.com>
Date:   Mon, 13 Apr 2020 21:59:14 -0400
In-Reply-To: <1586777361-17339-1-git-send-email-huawei.libin@huawei.com> (Li
        Bin's message of "Mon, 13 Apr 2020 19:29:21 +0800")
Message-ID: <yq1a73eu8st.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=923
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1011 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Li,

> If the dxfer_len is greater than 256M that the request is invalid,
> it should call sg_remove_request in sg_common_write.

Applied to 5.7/scsi-fixes with a tweak to the commit description. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
