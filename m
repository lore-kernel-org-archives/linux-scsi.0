Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9EFC54EEB
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 21:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21E332072D
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 21:06:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KkdziZAL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCVVGa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 17:06:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgCVVG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 17:06:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ML4IRh090724;
        Sun, 22 Mar 2020 21:06:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZhSy0kbf5SXe2zxblH5X+Of+nKWvQknh068g/T1dPAw=;
 b=KkdziZAL81MFQR0aVfNRkhYxqddrRuFmpMN/Jg+NkBJsu+9gR0HLJW37aKvS4w4ch/b4
 BqeV/bx+AGJQNCzABgcnzzaYr4Zeku+mIu9dUhY9G56XLpbdnoIiY192mEde7LKpEhgb
 5iwsghzCspP0cWqHWUPJQDpYXKNe0Ks+2S1l8eL0ufsvP4D3KQIUzRe0z/1bjFOvD4yh
 JW1qEYG2zSsiR2HRPC9gHPt/YPLymw9ke5+MGptDEJ8Ny9x7drIopc3LhSq0v+NAtr8X
 XCZDBQlqiRpNBdu8RZTRAqwKONvHoRJJo4s9iTD2PCzT8qU8sP7I5XieGfLM9bvTtCgz Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yx8abrpmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 21:06:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ML1sfC086159;
        Sun, 22 Mar 2020 21:06:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ywvqp2u51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 21:06:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02ML6O3O026183;
        Sun, 22 Mar 2020 21:06:24 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Mar 2020 14:06:24 -0700
To:     Bernhard Sulzer <micraft.b@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: Invalid optimal transfer size 33553920 accepted when physical_block_size 512
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
        <yq1o8sowfzn.fsf@oracle.com>
        <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
        <yq1pnd4tbxm.fsf@oracle.com>
        <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
Date:   Sun, 22 Mar 2020 17:06:21 -0400
In-Reply-To: <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com> (Bernhard
        Sulzer's message of "Sun, 22 Mar 2020 20:45:31 +0100")
Message-ID: <yq1eetkrtf6.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003220128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003220128
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bernhard,

> # sg_readcap /dev/sdc
> READ CAPACITY (10) indicates device capacity too large
> =C2=A0 now trying 16 byte cdb variant
> Read Capacity results:
> =C2=A0=C2=A0 Protection: prot_en=3D0, p_type=3D0, p_i_exponent=3D0
> =C2=A0=C2=A0 Logical block provisioning: lbpme=3D0, lbprz=3D0
> =C2=A0=C2=A0 Last LBA=3D15628053166 (0x3a3812aae), Number of logical bloc=
ks=3D15628053167
> =C2=A0=C2=A0 Logical block length=3D512 bytes
> =C2=A0=C2=A0 Logical blocks per physical block exponent=3D3 [so physical =
block
> length=3D4096 bytes]
> =C2=A0=C2=A0 Lowest aligned LBA=3D0
> Hence:
> =C2=A0=C2=A0 Device size: 8001563221504 bytes, 7630885.3 MiB, 8001.56 GB,=
 8.00 TB

I sent a patch that I would like you to test. It adds some additional
sanity checking to the block limits handling. Given the VPD output you
sent earlier, I am hoping it will work around the issue.

I still can't explain how the physical block size can be unset given
that it is reported by the device and the capacity is > 0xffffffff. I
even tried to tweak scsi_debug to see if somehow the no_read_capacity_16
flag for card readers happened to be set in your case and caused us to
go down the wrong path. But no. I'm stumped.

Do you have any READ CAPACITY errors or messages in your log? There were
none in the output you sent.

--=20
Martin K. Petersen	Oracle Linux Engineering
