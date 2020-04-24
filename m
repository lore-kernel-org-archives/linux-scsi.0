Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA61C54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 18:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD1020704
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 18:16:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ANK429qu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgDXSQ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 14:16:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36124 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgDXSQ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 14:16:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OIC7b1077326;
        Fri, 24 Apr 2020 18:16:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=t/WHq4qVVnyXue+67hKYBoJq3D5dxj/PZUwSVFd2dHM=;
 b=ANK429qusCCek93GTp4PKjoH16f+NssJtK1PzGsgRQ1zt/FIZ5oCwo4FOwpRo9ZyTj4z
 lkGhq02gv1QDeDzokvK1j1a1YKBVGTJdxSgWuuQoAv7qX50EP0UYr/h3ZKUY57clh3Jv
 JhynTsJFmFgdGPZMwpkktXW0XZB2Bob9ewBU2OyN5hh0zuSLpJFZc0NTYBLH1OxP8YAU
 djWxhHQfqm/nX6lZTv4GK1QMc/zGTJ5eEHCqYvvXgdkpyJlZQZj4whg1kqx4uM5t4ulh
 bf2G6YwjikxIR5d/TCa0UoVn84GKLicMPS9Au7RFc+lKXI0rs4PEnw7SNjfx6BFsOKBm Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30k7qe8apv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 18:16:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OICgKe185405;
        Fri, 24 Apr 2020 18:14:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30gbbqts9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 18:14:08 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03OIE7mU013762;
        Fri, 24 Apr 2020 18:14:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 11:14:06 -0700
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH V2] scsi: put hot fields of scsi_host_template into one cacheline
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200422095425.319674-1-ming.lei@redhat.com>
        <20200423060256.GA9537@lst.de>
Date:   Fri, 24 Apr 2020 14:14:03 -0400
In-Reply-To: <20200423060256.GA9537@lst.de> (Christoph Hellwig's message of
        "Thu, 23 Apr 2020 08:02:57 +0200")
Message-ID: <yq1mu70da50.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=758 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=832 phishscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240139
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Looks good, although you might want to throw in a blurb on the
> actually measured benefits:

Yes, please!

-- 
Martin K. Petersen	Oracle Linux Engineering
