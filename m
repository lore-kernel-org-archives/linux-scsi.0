Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88693ECE58C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 617B32086D
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:43:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n8caEaFs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732746AbfJJCn6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 22:43:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49150 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfJJCn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 22:43:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2hhxB056638;
        Thu, 10 Oct 2019 02:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8+9m7UPT+0tdGgND7ubXqfzGrHBnRu5oKcs0NAyitLk=;
 b=n8caEaFsWyBU0g04CmGmGQd732Hgq3uPL2i44HPqZQOoLwaEd9TEaI4vd18V3+DdZ/1K
 vBBkpkSAsi1S/DAjFVRmE6SlFe4fLPV2IHl5XeBSldJzLjCiufxdGzIRaIl6tlY2XC2s
 rFBnCJK5v+x0+SwgXZ3P4rEVe0GNi7ox5zeOzjptGmCXuEjm0Eb1o0x+ffxpj/HK8E8Y
 otJzRCtfHpXupQBoB4KVUfQHgndY3zXizEnVRUBj1n4inpsMer4xasEvnCvjDK8xdqze
 /Kr9t8DCSlMcZ/L0Lo9Qn10fdqyK1Gi2yCyaMEeNWLeMGLrYZCaRITVeZDux2m+iJjks HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vek4qr80a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:43:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2glEn060776;
        Thu, 10 Oct 2019 02:43:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vhhsnrp4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:43:42 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9A2hbn7031667;
        Thu, 10 Oct 2019 02:43:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 19:43:37 -0700
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Martin Wilck <martin.wilck@suse.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi_dh_alua: handle RTPG sense code correctly during state transitions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191007135701.32389-1-hare@suse.de>
Date:   Wed, 09 Oct 2019 22:43:35 -0400
In-Reply-To: <20191007135701.32389-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 7 Oct 2019 15:57:01 +0200")
Message-ID: <yq1y2xtialk.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=740
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=826 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> Some arrays are not capable of returning RTPG data during state
> transitioning, but rather return an 'LUN not accessible, asymmetric
> access state transition' sense code. In these cases we can set the
> state to 'transitioning' directly and don't need to evaluate the RTPG
> data (which we won't have anyway).

Applied to 5.4/scsi-fixes, thanks you!

-- 
Martin K. Petersen	Oracle Linux Engineering
