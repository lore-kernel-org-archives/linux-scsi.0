Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C59C35257
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 18:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D8E320795
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 18:08:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LWsjGMav"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388139AbgJBSIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 14:08:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33924 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgJBSIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 14:08:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092Hs31A001877;
        Fri, 2 Oct 2020 18:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=k5FGaYqAJauONBf2OjApTJE80M8btWDMePMZ8+ICYe0=;
 b=LWsjGMavk8cW7P1WmP7NpK/mrxAz767GH5HrW/MJyb3JfCqCz30Gv0cDlJ3N3k1phYf1
 jr3mfxQA9DiDZv9KiJRqPQeSa/4IFD7oBFAX1WTJTaqDkg5TAHcyLEmEwYg15Vw0ThgF
 J7jgSNemKlelxZYpzc5/SSGWp+0S3I9vf/iJ2EhyWaQqN+2KGEXFFbH6hDv7cNtw30Ka
 9G6kU2c77d4DoEKXAwHeJWKelaBg/8jSfUPhF+yePaQEJPNSpvHXtNE5eqTy49rQ8+C9
 hVtnI6qiZ9sV0U2vdpZtZM11BseuRPKaoqWPrBw/G1qFbmWOCfqgH4IVK35NiUidu3mo RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33wupg350v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 18:08:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092HotHQ132990;
        Fri, 2 Oct 2020 18:08:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdxx24k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 18:08:11 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092I8Anu030352;
        Fri, 2 Oct 2020 18:08:11 GMT
Received: from dhcp-10-154-128-128.vpn.oracle.com (/10.154.128.128)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 11:08:10 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.5\))
Subject: Re: [PATCH ] scsi: page warning: 'page' may be used uninitialized
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <9c22ec6b-7487-300b-e376-b05297a5d0bc@oracle.com>
Date:   Fri, 2 Oct 2020 13:08:06 -0500
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bstroesser@ts.fujitsu.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <0E12A198-4C8D-4A24-946C-CF9DC74500AB@oracle.com>
References: <20200924001920.43594-1-john.p.donnelly@oracle.com>
 <9c22ec6b-7487-300b-e376-b05297a5d0bc@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>
X-Mailer: Apple Mail (2.3445.9.5)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 2, 2020, at 1:01 PM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> On 9/23/20 7:19 PM, john.p.donnelly@oracle.com wrote:
>> From: John Donnelly <john.p.donnelly@oracle.com>
>>=20
>> corrects: drivers/target/target_core_user.c:688:6: warning: 'page' =
may be used
>> uninitialized
>>=20
>> Fixes: 3c58f737231e ("scsi: target: tcmu: Optimize use of
>> flush_dcache_page")
>>=20
>> To: linux-scsi@vger.kernel.org
>> Cc: Mike Christie <michael.christie@oracle.com>
>> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
>> ---
>> drivers/target/target_core_user.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/target/target_core_user.c =
b/drivers/target/target_core_user.c
>> index 9b7592350502..86b28117787e 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -681,7 +681,7 @@ static void scatter_data_area(struct tcmu_dev =
*udev,
>> 	void *from, *to =3D NULL;
>> 	size_t copy_bytes, to_offset, offset;
>> 	struct scatterlist *sg;
>> -	struct page *page;
>> +	struct page *page =3D NULL;
>>=20
>> 	for_each_sg(data_sg, sg, data_nents, i) {
>> 		int sg_remaining =3D sg->length;
>>=20
>=20
> Looks ok for now. In the next kernel we can do the more invasive =
approach and
> add a new struct/helpers to make the code cleaner and fix it properly.
>=20
> Acked-by: Mike Christie <michael.christie@oracle.com>


Hi=20

Thank you.

I am not always on the email dlists .. Please do the right thing .=20



