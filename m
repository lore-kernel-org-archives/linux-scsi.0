Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842F8C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55F3A20709
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H5gtbT8d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgETRfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 13:35:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60166 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETRfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 13:35:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KHWCaM066620;
        Wed, 20 May 2020 17:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=pV/Weg8O5vP+N+LAiNcPtl1rbBn2XFyBc5t8ofB/WUM=;
 b=H5gtbT8d0llZuhB9P7kl+Z662GFbXMeX85ihfKzc8Hu0Kkt3XNt92fyTfiQHz9ya71o2
 ApTR3JdrrnIUSP/wowoqqlpmuwXworUbxy+E/8GOqG+Ti8FPNGigQyEi84EFyHbEyIF8
 6CvmuT/X3RPqVKuhdtB1EhLnV8Jyu8tb+k5QjawA67pJ5LmHQPpWG2EtyM8bDEkSP0iR
 DwtEHvvxGMTob4jg+vO2w7gb18fEhuO/kiTXoqaNJSH+AWmBS6c9JzjFuxub1x5cFA2z
 FM3sribcNOU+HguefYviDeRALxs2y//4nZ/BFgef4OK6lFW83+D6SRWU8FLigfNhVqIu Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284m4f1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 17:35:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KHXEE6028657;
        Wed, 20 May 2020 17:33:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312t3887t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 17:33:21 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KHXFoc018563;
        Wed, 20 May 2020 17:33:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 10:33:14 -0700
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, Paul Ely <paul.ely@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH resend] scsi: lpfc: Fix a use after free in
 lpfc_nvme_unsol_ls_handler()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2pmtsv7.fsf@ca-mkp.ca.oracle.com>
References: <yq1y2purqt1.fsf@oracle.com> <20200515101903.GJ3041@kadam>
        <20200520165557.GA9700@infradead.org> <20200520172433.GD30374@kadam>
        <20200520172844.GA21006@infradead.org>
Date:   Wed, 20 May 2020 13:33:12 -0400
In-Reply-To: <20200520172844.GA21006@infradead.org> (Christoph Hellwig's
        message of "Wed, 20 May 2020 10:28:44 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=860
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=884
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200142
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> On Wed, May 20, 2020 at 08:24:33PM +0300, Dan Carpenter wrote:
>> On Wed, May 20, 2020 at 09:55:57AM -0700, Christoph Hellwig wrote:
>> > James, can you review this patch?
>> 
>> He already reviewed it in a different thread.  I copied his R-b tag.
>
> James, should this go into the nvme or scsi tree?

The offending patch is in the nvme tree so I think you should take
it. Otherwise I'll pick it up in 5.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
