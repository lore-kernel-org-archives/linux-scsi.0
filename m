Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF28C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ECCC22244
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UlW90sej"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392127AbgLAQSs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:18:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390823AbgLAQSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:18:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G5I67099368;
        Tue, 1 Dec 2020 16:18:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=l+x8wpkXP5iqaWwgYUNLeU9jW73efgcTE+WWnUZlx3s=;
 b=UlW90sejdYvBNwpRDv6JNwoOtie4IGMy178a6ylMKa99elNhGp3V/si4/G5cvXMxQka3
 xD4URDNCgoBk3AwWOiekeZj31Bp4EXO7U0iaFWx+TzjLhlpWjdjJYAo7V0u1qAMMz/FM
 TUoMYOdQQYC2b5HWmSgOvnCSspEaUz+qDOapass+N5qVREsyXQGy6YWHAytJf5BymEKZ
 pbmzw5wvmZaXROSrQP5lzPFlTa2cBOxSB4Mk14Wrj4AUODiOb8qzAobtipwzNLaiPZPv
 Dsyuoy3dpE6t8DT8kJu55QwfmxJel6rI2lOHs5tLo9GFOIy5pGnNruP5ebv3mxuGEOwk mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqkf62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:18:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G68LI043004;
        Tue, 1 Dec 2020 16:16:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540ey659y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:16:03 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1GG20x029029;
        Tue, 1 Dec 2020 16:16:02 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:16:02 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 02/15] qla2xxx: Change post del message from debug level
 to log level
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <DM6PR18MB303442AE6B84810FE6604CC5D2F40@DM6PR18MB3034.namprd18.prod.outlook.com>
Date:   Tue, 1 Dec 2020 10:15:59 -0600
Cc:     Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A1F83C12-6AA8-417C-AC24-31F6BFC56C43@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-3-njavali@marvell.com>
 <3CCE1C90-64DB-46C7-A49D-9378077CA083@oracle.com>
 <DM6PR18MB303442AE6B84810FE6604CC5D2F40@DM6PR18MB3034.namprd18.prod.outlook.com>
To:     Saurav Kashyap <skashyap@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 10:05 AM, Saurav Kashyap <skashyap@marvell.com> =
wrote:
>=20
> Hi Himasnhu,
> Comments inline
>=20
>> -----Original Message-----
>> From: Himanshu Madhani <himanshu.madhani@oracle.com>
>> Sent: Tuesday, December 1, 2020 9:15 PM
>> To: Nilesh Javali <njavali@marvell.com>
>> Cc: Martin K . Petersen <martin.petersen@oracle.com>; linux-
>> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
>> Upstream@marvell.com>
>> Subject: Re: [PATCH 02/15] qla2xxx: Change post del message from =
debug level
>> to log level
>>=20
>>=20
>>=20
>>> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> =
wrote:
>>>=20
>>> From: Saurav Kashyap <skashyap@marvell.com>
>>>=20
>>> Change the message debug level.
>>>=20
>>> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
>>> Signed-off-by: Nilesh Javali <njavali@marvell.com>
>>> ---
>>> drivers/scsi/qla2xxx/qla_gs.c | 8 ++++----
>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/drivers/scsi/qla2xxx/qla_gs.c =
b/drivers/scsi/qla2xxx/qla_gs.c
>>> index e28c4b7ec55f..391ac75e3de3 100644
>>> --- a/drivers/scsi/qla2xxx/qla_gs.c
>>> +++ b/drivers/scsi/qla2xxx/qla_gs.c
>>> @@ -3558,10 +3558,10 @@ void =
qla24xx_async_gnnft_done(scsi_qla_host_t
>> *vha, srb_t *sp)
>>> 					if (fcport->flags & =
FCF_FCP2_DEVICE)
>>> 						fcport->logout_on_delete =
=3D 0;
>>>=20
>>> -					ql_dbg(ql_dbg_disc, vha, 0x20f0,
>>> -					    "%s %d %8phC post del =
sess\n",
>>> -					    __func__, __LINE__,
>>> -					    fcport->port_name);
>>> +					ql_log(ql_log_warn, vha, 0x20f0,
>>> +					       "%s %d %8phC post del =
sess\n",
>>> +					       __func__, __LINE__,
>>> +					       fcport->port_name);
>>>=20
>>>=20
>> 	qlt_schedule_sess_for_deletion(fcport);
>>> 					continue;
>>> --
>>> 2.19.0.rc0
>>>=20
>>=20
>> I am okay with the change just curious, Would it not flood message =
file for
>> large number of sessions?
>=20
> This was added mainly for help in debugging, if debug is not enabled. =
Sometimes we get logs
> where it's hard to tell what happened to particular session. Moreover =
session deletion is not
> very common scenario.
>=20

In that case, I would also prefer to see message coming out from =
qlt_schedule_sess_for_deletion(), because that=E2=80=99s where you can =
track that session is scheduled for deletion.=20

I would prefer this message also changed to ql_log_warn.=20

        ql_dbg(ql_dbg_disc, sess->vha, 0xe001,
            "Scheduling sess %p for deletion %8phC\n",
            sess, sess->port_name);

> Thanks,
> ~Saurav
>>=20
>> --
>> Himanshu Madhani	 Oracle Linux Engineering
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

