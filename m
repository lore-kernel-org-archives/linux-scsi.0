Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1996ECA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 13:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6116222BD
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 13:22:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dxZeqxgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408203AbfJRNV6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 09:21:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404030AbfJRNV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 09:21:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IDIbYx063883;
        Fri, 18 Oct 2019 13:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=koup5ogY+sn8zZL0ZEQ7cZ8x8REFo/mxTqv8xNh7sAQ=;
 b=dxZeqxgAKgx1zfYnPrM4YmG9h+bD2mRea5c9AoyhcL9wXrkWcu2RCf7ZvrH6K+5i8fKK
 joQfCPt1ZlN2wDI5ZXkiqTwCX8h5ozLlcXpnkejOOIELvsTI0s069oLl0PxnaIOHrtoc
 ZDzBqZDdfh4QiKa9aD0cPMbrjUxNshmVbY++guWB+HO4p4pjAN6KEU/6UeLKdFY9cH3k
 hslZuCeJex2YzqYCeREnjqZOfBOx4goEBzqlJFA9AZDqJXeacqVad5U2QpPEaRXDSivv
 SidFnB5dhkO5K9jPmzdxr+6MKna7B6aAOC+pXtzH/6Ipg/EZ9w97N6Mmm23Zg9OeDinJ 9A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vq0q43wc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 13:21:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IDIJj0100246;
        Fri, 18 Oct 2019 13:19:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vq0ewcr0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 13:19:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9IDJjCE005734;
        Fri, 18 Oct 2019 13:19:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 13:19:45 +0000
To:     Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steffen Maier <maier@linux.ibm.com>
Subject: Re: [GIT PULL] SCSI fixes for 5.4-rc3
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1571166922.15362.19.camel@HansenPartnership.com>
        <20191018103540.GC3885@osiris>
Date:   Fri, 18 Oct 2019 09:19:42 -0400
In-Reply-To: <20191018103540.GC3885@osiris> (Heiko Carstens's message of "Fri,
        18 Oct 2019 12:35:40 +0200")
Message-ID: <yq1pniui429.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180126
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> James, Martin, I do not know how you coordinate your work, however is
> there any chance that the two fixes sitting in
>
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=postmerge
>
> get merged anytime soon?

Ugh.

Linus, these two commits were in a separate postmerge branch due to a
dependency on changes merged for 5.4 in the block tree. The patches fix
two issues in the intersection of the request cleanup changes from block
(b7e9e1fb7a92) and the request batching changes (8930a6c20791) that were
made to SCSI during the 5.4 cycle.

The following changes since commit 10fd71780f7d155f4e35fecfad0ebd4a725a244b:

  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2019-09-21 10:50:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git tags/mkp-scsi-postmerge

for you to fetch changes up to 6b6fa7a5c86e1269d9f0c9a5b902072351317387:

  scsi: core: fix dh and multipathing for SCSI hosts without request batching (2019-09-23 21:34:34 -0400)

----------------------------------------------------------------
Steffen Maier (2):
      scsi: core: fix missing .cleanup_rq for SCSI hosts without request batching
      scsi: core: fix dh and multipathing for SCSI hosts without request batching

 drivers/scsi/scsi_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
Martin K. Petersen	Oracle Linux Engineering
