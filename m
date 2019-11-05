Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5907CA9EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5FCB20869
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OX+1ep7k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfKEFTH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 00:19:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKEFTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 00:19:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA553prF106586;
        Tue, 5 Nov 2019 05:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Yuh8nhSJRJ/ZoUor/oy9hRqDcQxmnXcCZ8jg3FBxtSo=;
 b=OX+1ep7kk6SYrYdlHA1gGsXcj8b8I1+8aKFrXAbsHkPvd27MUf21yannfjwQpK1X5/ab
 BnDOYjRksJkqCPgNFFf4dtfTnunZQWXT+rBqpbkfcTRFa5IVzSxm27nyc/7P+Iitlgc8
 hXmwMenl2CmcdoWMB0GVZ3Yo9t/R++3NVMyecRDdPGR0eeg1/r9faaw4wCr9pFOufvMZ
 a0o0uWHLdd0wL+245PStzhVczgr6AlNXCLsrZnpoiqSN5WjpQK6O9+o2A6Z7IGFDTHZ4
 coW+Dz/jF/tkyBjQQbZimv6vSB91GzoXbN/IaXTVIyL/BR1J64MdtePDmgOvkTgIlhKk XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117tup18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 05:18:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA553moj181884;
        Tue, 5 Nov 2019 05:18:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w3160kwn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 05:18:49 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA55Ijeg016265;
        Tue, 5 Nov 2019 05:18:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 21:18:45 -0800
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage\@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191030090847.25650-1-damien.lemoal@wdc.com>
        <af516590-58dc-0377-5c54-ac63cffbafc8@acm.org>
        <BYAPR04MB5816D4B866F2E7CC421E8488E7600@BYAPR04MB5816.namprd04.prod.outlook.com>
        <a33afd2e-a7d6-5584-dc26-79fb8f3d6a97@acm.org>
        <a640ee15-515b-6811-9883-48b49ead9276@suse.de>
        <BYAPR04MB581685E630A8EA91902B2F9BE77E0@BYAPR04MB5816.namprd04.prod.outlook.com>
Date:   Tue, 05 Nov 2019 00:18:42 -0500
In-Reply-To: <BYAPR04MB581685E630A8EA91902B2F9BE77E0@BYAPR04MB5816.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Tue, 5 Nov 2019 00:11:01 +0000")
Message-ID: <yq1eeym52a5.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=555
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=633 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050040
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The SG driver can make use of this field to keep the io header resid
> as an int, with negative values indicating overflows and positive
> values underflows.

I am all for synthesizing what SG returns to userland.

That is also the case in the context of Hannes' SCSI result revamp. I
would much prefer to have well-defined and consistent internal kernel
status fields and then transmogrify those into something compatible with
what userland applications might expect. As opposed to perpetuating the
train wreck that is the current scsi_cmnd result.

-- 
Martin K. Petersen	Oracle Linux Engineering
