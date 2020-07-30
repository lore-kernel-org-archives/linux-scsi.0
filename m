Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA0CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 16:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C23E20838
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 16:11:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="yyldvhyc";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="VbDbLXHD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgG3QLH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 12:11:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40414 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgG3QLG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jul 2020 12:11:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UGAVYu000488;
        Thu, 30 Jul 2020 09:11:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=8Vxo/egLKVMUzcoc7RvwvCr3CwHU/ooPbo4cgsRw1ms=;
 b=yyldvhycEcgUB/8UnKoJjP/bCLgSOkAqRynXLnJ6S9xUps1fRljqOC0BkHYDr+hoCLLV
 BzN6eCRIxSb8ZOwqBbhH/cCQMzHgX+p/V3tlTOFKQHFPeLvb/iRu4jphwEJg7WRvrrsT
 ZC4ikyhnKUvAODA/+8Me3W5EyMJA5N9oVyg8jwgbSnSRTe9lNSrMmJA7K5QM5TsxIXa6
 mP/bsBFPoHMjNVQqWZ1M33gHJq+DIRb0B7OLW0gN7reohdvysZ0xuMyrYp15Na436bu9
 KMNXsBO9x/OjU5OyCvmMyW47Y+KfxFkDb+zDcpAyOQVOtm7NL6V+vXbd9lHIeoxah3To 1w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32jt0t0xvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 09:11:02 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 09:11:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 30 Jul 2020 09:11:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c02/wcsP9oWqZ9Tjl9pLW4LCe0W6ApqpJp9ME4ocjkrCbExyPTKG2bIRQG5BlEHqVLD+BnXIHNcN9j5BpChWy7PRCLA4OzTcYTH/0/CjkOFDZJx4aVmGgzjRtNvo4ZxVFszx/ClR4/gL1IEnFVNnSkqQwYX4HpMzc5iszWcaMZlteyIv6y/6JHU3pJuRQ/hcg5Bvn+2ku4M1eiM8/ODSiNABWMdvWXT279bXxIzii/y5kaio2LQHBlWQaIDtHFayf2USyHDVuqGOt52w7LaxjUgMi4vW6EuuWgqMVNtmfwWoPg4M5vGNmWW9Vv1JTZRmlYpMTmuQhdYnq4yqsOTnaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Vxo/egLKVMUzcoc7RvwvCr3CwHU/ooPbo4cgsRw1ms=;
 b=oHvqKkSxGCDWMP156hI9GDYsfjkQZ6Rpp8kdUnpFWcEhNQnptL2YKRSk3mqLb1+t5Roqcg+QhQkMAtUoH2ivdiGMcy/V0DaUPsRNw84BWZ+82OvGGXFWrm3Vr0qCVCotKwvk5iiNrILr+dx5+tMSqJlzsouCH8x9WDJSryelfk0VigAcFupHf9CgXKUxA1HWBvsvWKnFyzTe9i+NE34PcmvMxE9wdSte/jfUXSug2arsaftE/NfDekRzOv0x5rZ6cYZ8MZiruyvZYIfRjLT4nGzw3/zqqdOzFOoWPxRF1DH7KMjWFwlxXJjhNb+gpu3yV0lSPV3SqgT4xUDQVeQ70g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Vxo/egLKVMUzcoc7RvwvCr3CwHU/ooPbo4cgsRw1ms=;
 b=VbDbLXHD0VTNl6FMC1n0XSkzhOQEyha5XzCNzuM2UtrNwwm8kyVWYSweoaO1b8aOlWcWUP5xzh+Hp/K15c+y+cT8xp6lVbVabva3JYRph8COZreLlSOb4xxd2GeQ+WWuAQ+eOyrNEx4GQwxCjqjgQ7qcilQMcfY1L4Rai2PRt00=
Received: from BN8PR18MB2801.namprd18.prod.outlook.com (2603:10b6:408:a4::23)
 by BN8PR18MB2434.namprd18.prod.outlook.com (2603:10b6:408:9c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Thu, 30 Jul
 2020 16:10:58 +0000
Received: from BN8PR18MB2801.namprd18.prod.outlook.com
 ([fe80::8506:99b6:527b:1a00]) by BN8PR18MB2801.namprd18.prod.outlook.com
 ([fe80::8506:99b6:527b:1a00%7]) with mapi id 15.20.3239.020; Thu, 30 Jul 2020
 16:10:58 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     James Smart <james.smart@broadcom.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [PATCH 2/3] qla2xxx: SAN congestion management(SCM)
 implementation.
Thread-Topic: [PATCH 2/3] qla2xxx: SAN congestion management(SCM)
 implementation.
Thread-Index: AQHWNepxgIiivm6IzE6bpoC1uckRgKjTw3gAgBZgiICANogvgA==
Date:   Thu, 30 Jul 2020 16:10:58 +0000
Message-ID: <CAABD173-7FC1-4738-9299-CD91F96067DF@marvell.com>
References: <20200514101026.10040-1-njavali@marvell.com>
 <20200514101026.10040-3-njavali@marvell.com>
 <927c2cbd-682f-a80e-bd2e-2e5bd012ab2d@broadcom.com>
 <CA+ihqdiA7AN05k5MjPG=o8_pf=L-La6UigY4t0emKgJMXm=hnQ@mail.gmail.com>
 <BYAPR18MB2805AEA357302FCFA20D2B57B48F0@BYAPR18MB2805.namprd18.prod.outlook.com>
 <351333B3-F666-420F-A9D3-DB86D2617156@marvell.com>
 <7c33c4fb-d3ec-cd2e-4de3-ecb95ffec8b8@broadcom.com>
In-Reply-To: <7c33c4fb-d3ec-cd2e-4de3-ecb95ffec8b8@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:4f2:3b69:3052:c9ca]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f653e48c-e4e8-4119-704b-08d834a3256f
x-ms-traffictypediagnostic: BN8PR18MB2434:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR18MB2434DE69FF08BB36FE49291BB4710@BN8PR18MB2434.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6OvkOPY1tc89or40cFt/Dqo7gJbzqcsJg3DqC44cPK5g+WUATxhbZjdGUTUwW276SYQb8ciy8nuEERAV6ceciOy2Z3/rgXYL9EUjHqkdWdfCHGikcTptd69dlGm8WKrFSISjFrMiYGld/mDzAobRVUPJkhSDclv/xWwK2DbGJTKkfivSOB2Sli0UYNtRm80oqJvk2NxfGtahu6pspU+0zDJpStZ9KH3arUw1H955TgKCz8RSrEFJKon3mGwU1HFcEdPLwbZvXmO/S801AO7UObRvp17xGuUib6Tszrarm16EZtwG2nCD40dBGzBp0+Hq9Wlgha51/N0i1OQ6C8Rbndv2MD+PCzSiFDxlk6b1baYo/7gxAJIUXIWVdVpZi6cW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR18MB2801.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(66476007)(66446008)(71200400001)(2906002)(36756003)(64756008)(6486002)(5660300002)(316002)(54906003)(86362001)(478600001)(6916009)(76116006)(66946007)(186003)(8676002)(33656002)(6512007)(8936002)(107886003)(66556008)(2616005)(83380400001)(91956017)(4326008)(6506007)(53546011)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: W3vuhmjoxnhJ5atQdXvI2VseM+OeAmvynC6p9MgzZ/dBFriRB8mlmFNEAwQDN6fFK/TLP66HUQ7jdRHPUkvzuWq4ls/CgwWZXkFb1s5DC7PkElUGaVV7C3B+DTxUlq8iQEsBjZOLYEUPKCky1WoAoSLJa/qDJRxkoMJqJNd+jBalbdSrPx8+tqJ9GSq61sLoSl/sHvsVdtdZF7yGUdHmkJ+JqNBQ4Egr2A/v/t8jXstc+mmzEQwSdaXxtIGX5vxOXLvyU818IcAdioUzgEECiBlge7KgwcJkTrQ6litg4dUo4zqzh2XQzqrtDirXpCgyFEcYAdZ4aX5eesEdRiP5hP1HuJrOcCFnlSUGqzzAJr8m0xf6ebRdJDAKsJo7HKDuxcGMWGvk+MjAqzynpn5K01Ho983fL839iTTVU/6AwGNmyeizG2j+QV5NIHoGT4WpA8OMMtUiFCDO9d5JVr8lu8LGD+p686SziaU6yQcoHWNk92o01Iv2OP7BxrxdbIXD2clAggJ0oqYy+beVhuF2fi93UrEeaiEunEWABwNSegMQisVelfojm3fBItZGAkCh
Content-Type: text/plain; charset="us-ascii"
Content-ID: <44C3BFB1AE569046B0E861B9F983AADD@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR18MB2801.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f653e48c-e4e8-4119-704b-08d834a3256f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 16:10:58.3809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1+C930atd0TiHecRk8M1gKXtMDFXC75kIHXt9cBN2323T8qFpvdfNNyOQ+M0ubrmYSD0WZQ8N9jkMlTn+mFzAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB2434
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_12:2020-07-30,2020-07-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

James,                                                                     =
    =20
                                                                           =
    =20
Please review the updated patchset to see if the changes make sense to you.=
               =20
There are a few deviations from what we discussed here.          =20
                                                                           =
    =20
I have used a single structure definition to maintain all fpin statistics  =
    =20
and we are maintain them at the granularity provided by the fabric instead =
of
Using a single counter per category. The same   =20
structure is used across the fc_host_attr and the fc_rport structures.     =
    =20
                                                                           =
    =20
Given that the congestion signals will have to be maintained by the LLDs,  =
    =20
as we do not have the plumbing to push those notifications to the transport=
,   =20
I have added them to the fc_host_statistics maintained and filled in by the=
    =20
LLD. All of the stats are displayed under the "statistics" folder under the=
    =20
sysfs.                                                                     =
    =20
                                                                           =
    =20
Under the host stats, a subset of stats (the Link Integrity FPINs) are     =
    =20
redundunt, and are already maintained, read via the traditional mechanism. =
    =20
I have rolled them in nonetheless because during testing, they did not     =
  =20
update to the same values (using the FPIN error injection commands). If we =
    =20
determine that these values will be in sync consistently, we can remove one=
    =20
of the subset at a later point.                                            =
    =20
                                                                           =
    =20
Regards                                                                    =
    =20
Shyam                       =20

> On Jun 25, 2020, at 4:25 PM, James Smart <james.smart@broadcom.com> wrote=
:
>=20
>=20
>=20
> On 6/11/2020 10:42 AM, Shyam Sundar wrote:
>> Seems like this (and a previous email) never made it to the reflector, r=
esending.
>>=20
>> The suggestions make sense to me, and I have made most of the recommende=
d changes.
>> I was looking for some guidance on placements of the sim stats structure=
s.
>>=20
>>> On May 29, 2020, at 11:53 AM, Shyam Sundar <ssundar@marvell.com> wrote:
>>>=20
>>> James,
>>>      I was thinking of adding a structures for tracking the target FPIN=
 stats.
>>>=20
>>> struct fc_rport_statistics {
>>> uint32_t link_failure_count;
>>> uint32_t loss_of_sync_count;
>>> ....
>>> }
>>>=20
>>> under fc_rport:
>>>=20
>>> struct fc_rport {
>>>=20
>>> /* Private (Transport-managed) Attributes */
>>> struct fc_rport_statistics;
>>>=20
>>>      For host FPIN stats (essentially the alarm & warning), was not sur=
e if I should add them to the fc_host_statistics or
>>> define a new structure under the Private Attributes section within the =
fc_host_attrs/fc_vport.
>=20
> my initial thought was the same
>=20
>>>=20
>>>      In theory, given that the host stats could be updated both via sig=
nals and FPIN, one could argue that it would make sense
>>> to maintain it with the current host statistics, but keeping it confine=
d to transport will ensure we have a uniform way of handling
>>> congestion and peer congestion events.
>=20
> but then I have the same thoughts as well. And the commonization of the p=
arsing and incrementing makes a lot more sense.
>=20
>>>=20
>>>     Would appreciate your thoughts there.
>>>=20
>>> Thanks
>>> Shyam
>>>   =20
>=20
>=20
> I would put them under the Dynamic attributes area in fc_host_attrs and f=
c_rport.
> fc_host_attrs:
> fpin_cn              incremented for each Congestion Notify FPIN
> cn_sig_warn     incremented for each congestion warning signal
> cn_sig_alarm    incremented for each congestion alarm signal
> fpin_dn             incremented for each Delivery Notification FPIN where=
 attached wwpn is local port
> fpin_li                incremented for each Link Integrity FPIN where att=
ached wwpn is local port
>=20
> fc_rport:
> fpin_dn             incremented for each Delivery Notification FPIN where=
 attached wwpn is the rport
> fpin_li               incremented for each Link Integrity FPIN where atta=
ched wwpn is the rport
> fpin_pcn           incremented for each Peer Congestion Notify FPIN where=
 attached wwpn is the rport
>=20
> For the cn_sig_xxx values, the driver would just increment them.
> For the fpin_xxx values - we'll augment the fc_host_fpin_rcv routine to p=
arse the fpin and increment the fc_host or fc_rport counter.
>=20
> -- james

