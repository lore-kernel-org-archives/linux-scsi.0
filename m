Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAEAC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 00:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E67652072E
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 00:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="BbKLx+Ao";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="SdkZ43j0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgFZAO3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 20:14:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4154 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725801AbgFZAO3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Jun 2020 20:14:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05Q0BK3w022729;
        Thu, 25 Jun 2020 17:14:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=ctbXbZbADkp43zc1jQtfNs9dqhX5cemJeGbNGlyR00E=;
 b=BbKLx+AoZpmo1c7j1fPC3BAQsPPIP3Gacod1cnX/bHhw7oTsD1+FqeORSKc4zMJuwHBd
 eSrumz59QccigawfsfNNbXKLyH0Jju4V28DYoIkKHjw04/5gWoQdrsOw6bBkhoZ3ri7I
 rOloemunM+tBGOb1IC31pVH+wawpsmdhFrviREMVsAZHCkKAEnC+t7fGp1BEDgSjuIhV
 bFEWNQNXvEOZEsnbPqIF75/cxCCdFShvIKdGTCz44X6oqDmXBgENAZpnUu+8qtK3Zt+O
 NuCJTUsOpiAKETi4jgVrNVDAHYRGrIZLWE29HkWgrfmejCXINDx8S0MFlduZyJHefAkQ JQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh28b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 17:14:27 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Jun
 2020 17:14:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 25 Jun 2020 17:14:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtnKhRrRXMlQiMT/frH98DYi2CMDrmY59F60K6faJh/jf3gWxvORIR2Ldvv1jwMXXlbhBdRDZZD1yy0CcQSk49gu+iIFBgvG3FCO7NS8Zic2sZ9ebjuRMQl1a2sgf4aZ9TX28axPnkgqdYDQuV+fNPCBjJ0Ba7B1tiYyUu5jBEiouo2wJ2uxeIEQM7ZiI4y42XjsxsteraKqBv4UAtW6qofK8GkQWJTJGTZr62GZYOzDF5KMhvCzs6eT7RavLN4xoinCJ5Zyv2NoOEP39iBk5MaIo4lxXJ3lnoMCPbBK9HETmZVB6Q2Gq9JU5SJ0SJ0em/JDwS67C/V4kjKUv9fyrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctbXbZbADkp43zc1jQtfNs9dqhX5cemJeGbNGlyR00E=;
 b=TcJAXigE1aidJysxz+XI9Z7MaCQZ7sY7Yn4SPdutYAVj7xYb3FeSxAe6c+8CpFsZNBNRc8V8BR9lU9uBRh6h6Wz3vMh1P8WrCHhxlRtEk+dRoaRla5+JdKrCTKHowbudi71NPaaiNGq9p2p/nB6vKxgQFq50qzN+nOC5DZfqURLMzSx/BxOv3XzRxDAX0KuY9IK2aea/yWbTo24wqIKGOAIThaJnmz08+5PHRprEpWhZNjSgdPHEYxuUrT+Y2cAPmjerNZ/Lv1796TB6FYnPYqOqEXzBFwT+i27VWiD1eAUf0PmeSE1B/t0BMlr3UuCB2lUMDI3IHK2leh2rSF6byg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctbXbZbADkp43zc1jQtfNs9dqhX5cemJeGbNGlyR00E=;
 b=SdkZ43j0wHyBYLfU4owAgedcTG0sSbet/fojx9DUbO7leL3RWciCe2AecKVWDJwhjHyB6BKJEtWExY/J3jIYPBtGgk0rtunsAMeTdHzw+ETEmeXTeuFn35UZcsmwoYUHYtPHozbGcwhSFETuBNwDhHLs+ET9dzEQ0KTcRvEdEI0=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BYAPR18MB2616.namprd18.prod.outlook.com (2603:10b6:a03:13c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 00:14:25 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 00:14:24 +0000
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
Thread-Index: AQHWNepxgIiivm6IzE6bpoC1uckRgKjTw3gAgBZgiICAAA2ogA==
Date:   Fri, 26 Jun 2020 00:14:24 +0000
Message-ID: <F0682083-B6E7-42C2-9ED2-7E699B9A1DDC@marvell.com>
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
x-originating-ip: [2600:1700:6a70:9c50:a138:68ec:c97d:2206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cce19e24-5764-4874-4c36-08d81965e229
x-ms-traffictypediagnostic: BYAPR18MB2616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2616E4A7661D8C3F150A5272B4930@BYAPR18MB2616.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TS10+Zz+Vx0Y4j6mKGg7nlRLjofPve8KWscyU6Met6wbdyB2BH8KvGksCy//ArTnOv57buFzbtQbrl+lviH8ZohidsqhRkRqGmgQ/3Vrn/F3lH/LSCdJS3OhH62rp1J9xpDs0/wDDr5lCqIkvZ/mUK2NAImtl4cTnNeb+Cmv2Wn8cARtpTH++vmP2dZFsoc74qqhUh9EJdn7PcV6VjjJxDbIOLure2w6iRKNCIPIK1/Du4PgAW6b3o58UwXCUbmGObXSu+Y7HdQzP31zDmDg/cHjVWS78NxcFdEcjXw8XYlvBVGDUnpfKJRJGijfRnp73psudhmrz3sHHoqis6sKADTX4ANozp0lQ8RKYU3On5Nn8WhvrHrmRxV5piXy0avg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(136003)(376002)(396003)(39850400004)(86362001)(54906003)(6512007)(107886003)(6506007)(478600001)(36756003)(2616005)(4326008)(53546011)(2906002)(71200400001)(186003)(316002)(5660300002)(8936002)(6486002)(66446008)(76116006)(66556008)(66476007)(8676002)(66946007)(6916009)(83380400001)(33656002)(64756008)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZaHHw1c60IPRP0pFYE22hnmIAxdipwDmLTjOozPtJ0vg9xwxtj3zC5Lj+agpN+1OjuHjR5q9exFbxKHVMxPmfetBgCVP8OK8/7xeQPF/0a53EHUdpcOP9h1hj+YHdBgQ269dTINAwlWJzf8/VYC0hH4D+HA6u1t2Xlq1tXnYlkOjHVT2WGjobI68Mm5f6DWxeB4fR2Tb3cjWOAXIuz9jN1OgTv2eLCQXyKvLWhxDyP9dp2NEGC8UqS5Cw4WeliAwCDTCK7zozEvIJ7FwOGJ0aOA7CotqXCesUeNRiC/aSN8w5JCapXd24znKMgXXg01j9xEo81I4DOJQoXmr8MltutOXG/XKhYOtBMNQ2WP1WMXI6uWm7BOOrKYnYBrgI2y0jDCAVbxms+qLYr5qGTkiz8FEGe7CSAR8tAVzh4bcAzul+am3d+t/YueaxWpiXfs3pfJLhKD1YEptIXFuEk0VJjCB3qER6n7/1mPeTSoqROhskR2rOwImFQ9Iy50z1FQToxJWjfUik0nsbfYEZ07mJ9nL3Ny6PFLCAmsK+La07xiO+dIOlT+6YtaKKtRPmxJ+
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D38513103E60AC4A9AE36D4D2C692092@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2805.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce19e24-5764-4874-4c36-08d81965e229
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 00:14:24.7525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/bNDxmvgd9Q3UxWry99yXlHYKBExhV1mp15ccr7/V2uAwp7x/PHXrSJ177i5QvFA+c0cOgrfhhWYTogwPwkfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2616
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



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

Sounds good. Will do.

Thanks
Shyam
=20
>=20
> -- james

