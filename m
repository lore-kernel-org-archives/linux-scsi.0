Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9098AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 07:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1022073B
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 07:33:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zr8ftTxm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgEVHdI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 03:33:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbgEVHdG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 03:33:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M7RiMI099138;
        Fri, 22 May 2020 07:31:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FHKudRAmfJMTmkL5lBhr9gMRqVNot+ZGcY+gLOKSPWQ=;
 b=zr8ftTxmN8djMVNxsfauxHijqmQZJ27JNYNzSbiwZV1H4No0xKEXcoTBytv3PDJSvcrp
 /Nyramp0bw+dLsKfAey75XBoOuEv6PhQEYKJ3fSf3n1UF81MxbM2guQfVP9qMNYBHSff
 0IBWTd1TSwN4MLhOwVoRqfipf6RiOQW0ZCK7XL0FAcRfHgkHtQjUaJ+5Ssh5CBYpXINY
 19VERK0I4Y44f8lhzUIpFleEzhe1ducy/y6uezF+0Px3K3Lqe7sK49O1DZqJJPuH2L+p
 jIo5SWG9s0WsYzgwXQcbaKu7YC1xheaXy9TBqY2v9S5VpftJZIi8oHvInJOIZ0c/DQKw 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31501rjt8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 07:31:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M7TICY165649;
        Fri, 22 May 2020 07:29:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 315023u8fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 07:29:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M7TJnm022187;
        Fri, 22 May 2020 07:29:19 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 00:29:18 -0700
Date:   Fri, 22 May 2020 10:29:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, paul.ely@broadcom.com,
        hare@suse.de, jejb@linux.ibm.com, axboe@kernel.dk,
        martin.petersen@oracle.com, hch@infradead.org
Subject: Re: [PATCH 0/3] lpfc: Fix errors in LS receive refactoring
Message-ID: <20200522072911.GA22511@kadam>
References: <20200520185929.48779-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520185929.48779-1-jsmart2021@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220060
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220060
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 20, 2020 at 11:59:26AM -0700, James Smart wrote:
> A prior patch set refactored lpfc to create common routines for NVME LS
> handling for use by both the initiator and target paths.  The refactoring
> introduced several errors spotted by additional testing and static checker
> reporting.
> 
> This patch set corrects those errors.
> 
> The patches should enter via the nvme tree, as the lpfc modifications were
> in support of nvme-fc transport api deltas merged via the nvme tree.
> 
> -- james

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter


