Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA571C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 04:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EF58246A9
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 04:36:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uX1UISkZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgKQEfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 23:35:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37792 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgKQEfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 23:35:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH4Xn4D057847;
        Tue, 17 Nov 2020 04:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=I2SuI0FlryjUNxtdB53M6t41ZCMvVryVylVSGwDiXvc=;
 b=uX1UISkZgAAva6Iv2lvnzq2qcSBsDemHrABwwkFr8dZ+z8jlRjc1tgLF3z5Hq1Jqqadk
 6/GnOti4dNp1bmta60nrYKUQ9B4OUxMp1C8v4JDt+cwotVHzdSlUyoVGYklCrIy400Sa
 f0ZFvVOXGOVeO31hcyUkckje/kqMtfWuUsWJdDGohvJ4yVaxJhPa6QaZDRrpmj2J+30y
 RImgtuLMyVZU4hezl31lIFZBan7m98nPAyqP2PypTNhuN2Jd9Zp1CjYQhtmzhO7/D+7+
 ESfRd7zXnoHuB22hKn7qCAQplyWBAf4r/hMt3yEUaZcd1+Zme3AeebYtd0A989quk+OK 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34t7vn0egn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 04:35:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH4VZwU039964;
        Tue, 17 Nov 2020 04:35:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34uspsv2ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 04:35:40 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AH4ZcK1007646;
        Tue, 17 Nov 2020 04:35:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 20:35:38 -0800
To:     Lee Jones <lee.jones@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Don Brace <don.brace@microchip.com>,
        Bugfixes to <esc.storagedev@microsemi.com>,
        storagedev@microchip.com
Subject: Re: [PATCH v2 19/19] scsi: hpsa: Strip out a bunch of set but
 unused variables
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtzg4n3j.fsf@ca-mkp.ca.oracle.com>
References: <20201102142359.561122-1-lee.jones@linaro.org>
        <20201102142359.561122-20-lee.jones@linaro.org>
        <20201112101929.GC1997862@dell>
Date:   Mon, 16 Nov 2020 23:35:36 -0500
In-Reply-To: <20201112101929.GC1997862@dell> (Lee Jones's message of "Thu, 12
        Nov 2020 10:19:29 +0000")
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> Fixes the following W=3D1 kernel build warning(s):
>
>  drivers/scsi/hpsa.c: In function =E2=80=98hpsa_volume_offline=E2=80=99:
>  drivers/scsi/hpsa.c:3885:5: warning: variable =E2=80=98scsi_status=E2=80=
=99 set but not used [-Wunused-but-set-variable]
>  drivers/scsi/hpsa.c:3884:6: warning: variable =E2=80=98cmd_status=E2=80=
=99 set but not used [-Wunused-but-set-variable]
>  drivers/scsi/hpsa.c: In function =E2=80=98hpsa_update_scsi_devices=E2=80=
=99:
>  drivers/scsi/hpsa.c:4354:9: warning: variable =E2=80=98n_ext_target_devs=
=E2=80=99 set but not used [-Wunused-but-set-variable]
>  drivers/scsi/hpsa.c: In function =E2=80=98hpsa_scatter_gather=E2=80=99:
>  drivers/scsi/hpsa.c:4583:36: warning: variable =E2=80=98last_sg=E2=80=99=
 set but not used [-Wunused-but-set-variable]
>  drivers/scsi/hpsa.c: In function =E2=80=98hpsa_init_one=E2=80=99:
>  drivers/scsi/hpsa.c:8639:6: warning: variable =E2=80=98dac=E2=80=99 set =
but not used [-Wunused-but-set-variable]
>  drivers/scsi/hpsa.c: In function =E2=80=98hpsa_enter_performant_mode=E2=
=80=99:
>  drivers/scsi/hpsa.c:9300:7: warning: variable =E2=80=98rc=E2=80=99 set b=
ut not used [-Wunused-but-set-variable]

Applied to 5.11/scsi-staging, thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
