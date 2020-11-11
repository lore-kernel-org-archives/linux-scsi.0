Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E887FC5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87F3220809
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EJ/hIdQV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKKC6w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:58:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56076 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgKKC6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:58:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2sjT3089694;
        Wed, 11 Nov 2020 02:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=J3pE1RbLFiglHMn3Sff61j1KCciT9vzj2mPaKBQh+Go=;
 b=EJ/hIdQVMHwYxR472bsPRGgeihxLIDZe2UUrO0k6OOKubyvaR60jq+nsxClnTBK71eit
 Xij6Yu48pWsYtlU/d4oF0A9KBq8g2K8Ixe39KWyeGj0iSVYJg+IEa2CBtVmfkFPk+gnT
 ss7RMKzIB05MVzuUntrE1g/gXEARf0BrqWVUGtMv7AO6RLdkRDFKNz2cj8W5yRw1VM3h
 huNUSJ1j48Rjtaq0vo/+jT6zsXrZrBbZRMmxJ+B302i7Yh5Q8HBspY3u09CSbXUZOc4F
 B3VGqzomBp+081Nnqn3sC0ig5jinMc9e/SriMW7gqJ5zELBJMg05SfErf2y8mH71COgx vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34nh3ay5a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:58:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2ssFv153808;
        Wed, 11 Nov 2020 02:58:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34p5g15je3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:58:35 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB2wTvt024323;
        Wed, 11 Nov 2020 02:58:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:58:29 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 1/3] scsi: aacraid: improve compat_ioctl handlers
Date:   Tue, 10 Nov 2020 21:58:21 -0500
Message-Id: <160506295513.14063.11866299888883533879.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164450.1253641-1-arnd@kernel.org>
References: <20201030164450.1253641-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=884 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=901 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 30 Oct 2020 17:44:19 +0100, Arnd Bergmann wrote:

> The use of compat_alloc_user_space() can be easily replaced by
> handling compat arguments in the regular handler, and this will
> make it work for big-endian kernels as well, which at the moment
> get an invalid indirect pointer argument.
> 
> Calling aac_ioctl() instead of aac_compat_do_ioctl() means the
> compat and native code paths behave the same way again, which
> they stopped when the adapter health check was added only
> in the native function.

Applied to 5.11/scsi-queue, thanks!

[1/3] scsi: aacraid: Improve compat_ioctl handlers
      https://git.kernel.org/mkp/scsi/c/077054215a7f
[2/3] scsi: megaraid_sas: Check user-provided offsets
      https://git.kernel.org/mkp/scsi/c/381d34e376e3
[3/3] scsi: megaraid_sas: Simplify compat_ioctl handling
      https://git.kernel.org/mkp/scsi/c/bba84aeccafb

-- 
Martin K. Petersen	Oracle Linux Engineering
