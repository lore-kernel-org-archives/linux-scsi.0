Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA53C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C57D2085B
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zheSDPZZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgJHDrl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:47:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55518 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgJHDrl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 23:47:41 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983UM7k099323;
        Thu, 8 Oct 2020 03:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=eP3vPWwy+ViuyUKhs7Cc5erqErxWZvAnKpG0nxxsl0k=;
 b=zheSDPZZOSShqojlkFnxUDu9FCR3HxWUnNoW5oQTrmiMxRE5bainBJpSXc2hwy8iqd2m
 6crJr5Rkvg/ofn/MjIOldOLiyc5pTGb0GVN3soMxpZvfdKXm+MeTKjYFW25x2xxjiB7S
 2XFmUmKTT/LgVcAoeKpytgMU9JNZiUD0WQAUtvmFLjcWhE1+0ibvYLuS1qx4dBRpn0TG
 esl9h7Uv32vfXDwg0KIhntSQ5ruplXEhjt0mUMDTtDkRRZq8wit0viJrjcw0pSKgkJG8
 kZx7nohrH5NIQkVOnHmvG1x0rc6LTfpfbt566Gf2oaat3UxEPmxJxTtk03RsdPj2uP1i Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetb5fk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 03:47:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983jLFX180956;
        Thu, 8 Oct 2020 03:47:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vqbdyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:47:34 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0983lVQ1026976;
        Thu, 8 Oct 2020 03:47:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:47:31 -0700
To:     Bean Huo <huobean@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] scsi: sd: Use UNMAP in case the device doesn't support
 WRITE_SAME
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kn5wgqf.fsf@ca-mkp.ca.oracle.com>
References: <20201007104220.8772-1-huobean@gmail.com>
Date:   Wed, 07 Oct 2020 23:47:28 -0400
In-Reply-To: <20201007104220.8772-1-huobean@gmail.com> (Bean Huo's message of
        "Wed, 7 Oct 2020 12:42:20 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> There exists a storage device that supports READ_CAPACITY, but doesn't
> support WRITE_SAME. The problem is that WRITE SAME heuristics doesn't work
> for this kind of storage device since its block limits VPD page doesn't
> contain the LBP information. Currently we set its provisioning_mode
> "writesame_16" and didn't check "no_write_same".

There is something odd with what your device is reporting.

We support WRITE SAME on a bunch of devices that predate the Logical
Block Provisioning VPD page and the various Block Limits parameters
being introduced to the spec. Consequently we set the provisioning mode
to "writesame_16" if the device reports LBPME=1 in READ CAPACITY(16) and
nothing relevant is reported in the VPD pages. That is by design.

> If we didn't manually change this default provisioning_mode to "unmap"
> through sysfs, provisioning_mode will be set to "disabled" after the
> first WRITE_SAME command with the following error occurs:

If your device supports UNMAP it *must* report it in the Logical Block
Provisioning VPD by setting LBPU=1 and report MAXIMUM UNMAP LBA COUNT
and MAXIMUM UNMAP BLOCK DESCRIPTOR COUNT in the Block Limits VPD.

Also, "no_write_same" disables attempting to use WRITE SAME to zero
block ranges. That's orthogonal to the logic controlling which command
to use for performing an unmap operation. An unfortunate choice of
naming which can be attributed to the SCSI protocol using the WRITE SAME
command for two completely different operations.

-- 
Martin K. Petersen	Oracle Linux Engineering
