Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F997C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8682760BD3
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFBNhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 09:37:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33226 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhFBNhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 09:37:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 152DXoPY024065;
        Wed, 2 Jun 2021 13:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=CMa07xJ5SqKKQQwd6O0SDYUcDy/6vePY5EF0rHA9C74=;
 b=rJRRtIA/HhOORdUVhaSmFSiCKGyjHbzmIs6Eul8Qf3scTf6guSWZRcsyhTrR+wRtJ321
 ARS90ajmETVsF9qJDcu1B/mIHqcDenbDP9QPO8xegpceXsY9LA+1fLFKBQF5a9/v1ZZp
 qnzl4X3L/jLdXE1jc1VDLBQR7JTjW2kK3o+xvvmFGJQ2Yx8+6u5XSIVM+1NUBCF/uVfg
 EhDPmO/E8zJGkZEGYL5p32JePO/mpVS5R1UKEPEh/vRkfYJ5xfAR1v4e7og0ABMD2Kg9
 QhClIjbjZZnJ2spzvAFiEH/L65ApadGZLojvfBhW4QTGjxBAY6WPUsJaz2fAHpAAc/mo 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38ud1sgk20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 13:35:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 152DZUgS196603;
        Wed, 2 Jun 2021 13:35:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3020.oracle.com with ESMTP id 38udebvdd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 13:35:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGnX6YwnJYFzFqDyME79Yd6KVowLxEfzaMb864+Np2kmQrNZrgQe7raN3MmdOWVou+J1Zr5GqhSIXknOas1BesCuyQgcUtqQBak5btRQDpgsm4+j0FaPN8O7Px9xKZ05X6arz0E9aZwE0BzfmmF6L7+BN5c7a+QjZR6ZLoyHnM5FPigLCc0dpLPvk6ng6GvJqqDKrrtPpWBnj1m51GkZzlY4+ATtec0i4/h6j63wWErOiIRUGdGDz+ViVl58dpIf822VmGSwpGw/Dwj1pPXo+b54n8D8uMgZeWcCf8UD2ftYn7m3f4F0V3Q1K2MuvOLd+R93vgbOr+5JFawy6ACeRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMa07xJ5SqKKQQwd6O0SDYUcDy/6vePY5EF0rHA9C74=;
 b=jU2RbH2qKDY3Q08eYHLl8YiWF/LLqd9pxqXuN2oWP2RXCVBfOhCjGhQxfPK7MhRTftpM7TmxaX1X8gBLXgM5hgWCn4yiv+2CR4UlAXD3LF5C+leXPV0QNDtH+VZrDFwN40zt/PwQukp09Vkph5yQgkgekFsvZZrJYp7dlJAMZZFqt+Y+teeICLe4Rx9eEeM2bLM7+BwkAi9f1SJ+rIFis/Rzuh0UTXm22MdFcWu5XozAK3Jwlkb5vysWqttOe6+3qlC/acuNOc/RuzhA/DROAWyL2ci+ANTcN7wdQtB8R/C7nioAqDF38P7fArLz4OFVGIQJdCG4lGfjdW/BQjC2DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMa07xJ5SqKKQQwd6O0SDYUcDy/6vePY5EF0rHA9C74=;
 b=sQk2Kx/yHI1q1Wsj/UwQMfP6TUDk8xRj/TkNIETRuUEori7/mSq51RXZZgPsrhZC5e/7Slcor1lKnMQuye2kYP60zSaCV0qKE3kgxze7Z2WOeuAYJtkaYSqexN0rjdfodTGYY40mp3sNbcwprRr8tXWzPeqJiYFDPkia4hkjl/Q=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4553.namprd10.prod.outlook.com (2603:10b6:806:11a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 2 Jun
 2021 13:35:21 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 13:35:21 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [EXT] [PATCH 1/2] scsi: fc: Corrected RHBA attributes length
Thread-Topic: [EXT] [PATCH 1/2] scsi: fc: Corrected RHBA attributes length
Thread-Index: AQHXV7Qik4ZP5/qkF0efQSyk8I14aw==
Date:   Wed, 2 Jun 2021 13:35:21 +0000
Message-ID: <AD8A5A85-2B9A-4D8F-8279-36A5EAD0A207@oracle.com>
References: <20210601172156.31942-1-jhasan@marvell.com>
 <20210601172156.31942-2-jhasan@marvell.com>
 <dd421a80-36c5-337c-d786-a3039183e534@oracle.com>
 <edfb9c44-10d5-b2d7-1f3b-c3012ebb1128@oracle.com>
 <DM4PR18MB414166DE9322278ECF474A71C73D9@DM4PR18MB4141.namprd18.prod.outlook.com>
In-Reply-To: <DM4PR18MB414166DE9322278ECF474A71C73D9@DM4PR18MB4141.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd39bba2-2350-4dd1-5ea7-08d925cb44d9
x-ms-traffictypediagnostic: SA2PR10MB4553:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB45539B83A9BA0DEB8ABEE6C4E63D9@SA2PR10MB4553.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TzPBDZ2c60OJR0w32s6MHmM7AQQ6QgMpmpOyeymTXCqWdkOhQzHF0zqEpeLGe43hwUAYdhfITKoIwqlaPqhcHnJd3q0db2p7iMdxSGJznhy7v+N1pxmC2jEqSFkg1RI/KuM6qPZnnEBV1s+7i1l/zki3Y82WfJtYKSjXjMawVMi8cB5xAW6iWktksS5GEjKdBeLC3UquvBS0p4T9w1s+IyVY8g8VZCKi4F/rwRRUthUMe4/czCwfdjNdiCr3d9marO2Z/Ysc3yTFknx4lmyUMG6IEqZXhMsK+bDXoEyNO7BD43kbZrAS099v/3aAFttCFR67Kr9CssomAXoAEfvbOwhigHF/dcAq2kheRPNKe9CRwjpNDRfR1L4STCsUs1dngddVWZqEQTD92PozWoAgL7Sffr46WZtA3QFhML4djMQOhEM2Mduxck8ED1cCKMP4eC5z3pc8VVPCoyRBw9BJBToNcHxpOtt4WcD4/Ufjn2O5vZgvSi1MCcIQgsftRxJD6RnS9TxeDwKnC743+Js2TWjdHTzYHHSoyB5EkSBh/Iq1l/f473cacY1BwUPRX0HW+NR9cyds8xzHfmOjdogyi6htZtt+zEipa4iKda9lnFTLV10sxq1i6ttjUE1wD2KOOyu9SJ7tFuCg3wHH/YqE82uDaNobqledR0SBAj5XzVI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(136003)(346002)(396003)(6512007)(2616005)(76116006)(66556008)(4326008)(478600001)(64756008)(66446008)(66476007)(66946007)(53546011)(8676002)(44832011)(122000001)(36756003)(2906002)(6486002)(8936002)(38100700002)(316002)(186003)(83380400001)(5660300002)(33656002)(6506007)(71200400001)(54906003)(26005)(6916009)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Hb/CrW7/2VJkrHZTFcfic49x4XloHJvJ3E9gA4BptgNr6ETNxCoCcOr6OPaQ?=
 =?us-ascii?Q?yHlkf7zoJ+HFoTVYcxXaSxsyOH2gA9P5RrJ1ZpVaF0Ao+gpCAP7aa5Whd0fJ?=
 =?us-ascii?Q?/S3kXhhyiiZF8qG5cDbP1SJ5NVMP4vdldQLHrFaT8PtFFjVc+3psF4JM1Tg2?=
 =?us-ascii?Q?isAlf+b1iQNaw3Q8SvuWqrN/2LD+00ea7MBaV2RYYhvNkUSIZ0rOeLMZphGQ?=
 =?us-ascii?Q?oLfejHyJkpnsTWpAZwiuUBn4ofTP4m9qQTDkL/EuOpkjt2Ais6RBkq4dVTws?=
 =?us-ascii?Q?Fa3PSuX6CCC51h5Rhz0rVB4edELCoIR84Tho2BksayaAePYrwelgOBKPO+zR?=
 =?us-ascii?Q?428dfsoheHvu12/UUEi1RS4/QLcHUVrftseBczA6xF07Lp9K93YOcoBE3p/4?=
 =?us-ascii?Q?2UoDvhHJEuLQV9WR2cID+0WQPdLyRKdj8C4SUm1Mt6B6lZgIXnjK46co1Iz2?=
 =?us-ascii?Q?3zfMWoB06nuetdsJsVx4BqCsdFiRkDMI0B3JQu8TvoMXYUEa/Vs8GwTO5oqG?=
 =?us-ascii?Q?SV1XZzhk0mDohsIYG1rteLo9MiRNA2I57qZ6wouoDcTOqfMFLjIKGWUliicS?=
 =?us-ascii?Q?kzQM5rXasCx4xdMYKtQuKlb3uio2N4xTx3moQL7J5eyhvj9Gu8urnjuF5F4Z?=
 =?us-ascii?Q?nSst2PGQql5gWXXUpOExd5ZG0KCJW1iRrF4HjY1Hy+vdpB9q79SojjidZ3Br?=
 =?us-ascii?Q?/d5TVvZBLI/XgYCgkTja378IQpYzee1KGe0sP/PRRRP31vwHXTdNPEHNTyaM?=
 =?us-ascii?Q?mu3/DGj/nDVeB80HcS5IeRm7RLaSrujEX1iUmzgvTuxtHsaNCDO72ns0ujHb?=
 =?us-ascii?Q?KbW5O7lAEJ1tKN7k4KyCnhbNBVE28H77oH5sfcGfZAy/+mOETwydV8KhsVF8?=
 =?us-ascii?Q?TfXwjzCdf/YRTHGVl6Xo9UF3/zywA0O7rgIsYn4tNxKP9Jre0l26zBzZpBHF?=
 =?us-ascii?Q?dHFjrAmBZyCTC6lj3iccmYkHXa8giGNROQDmahJSss1d6XqAoUJDqgmogefj?=
 =?us-ascii?Q?y5pLA56tSFb7ou24J8Fgx7WKX6sVwmNsQGCNpr/8M6A1xdyYiAf/WoXDYGvk?=
 =?us-ascii?Q?Kfc9H6q0mCKZeCfG/n0FINRkPcoGsciBQdfEtIn9+eRRjEsSTmXdOFmI3M0H?=
 =?us-ascii?Q?jxZQl0QY3JqNYMkidM3Vnq/mVZpfQU0wMqcNvX0EaagfilcuyoVJUQ5o4M4J?=
 =?us-ascii?Q?fRqrUmRZtZ19KEHt7VcvIJwLpL6iK+osSQnVRz0bGHtoFlh1W0Zzt6vmsbik?=
 =?us-ascii?Q?oeLFjNaKZ6v6In2wUfwg/GMmkDRak5eFssr1RwGnP8XRaSs1NHsN1bhBQAQc?=
 =?us-ascii?Q?QST2iDbTXYKyfS8SFM9tk61z?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <794D03CF5D09C14582A3D5C29DBD88BD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd39bba2-2350-4dd1-5ea7-08d925cb44d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 13:35:21.2301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8p2TYGNwCdsLw9KbkSMnJ6bIyDStKJDJFKc36iFhS77hRroqLnqmQ19DDeQaFX1kTUvIbL2/AyX+PjqljQONtbsyTBB8UzPiaDg1jzjrz9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020088
X-Proofpoint-ORIG-GUID: gyvqJHZpcFTd6karpQWoQtzRSnOQq7gN
X-Proofpoint-GUID: gyvqJHZpcFTd6karpQWoQtzRSnOQq7gN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 2, 2021, at 1:01 AM, Javed Hasan <jhasan@marvell.com> wrote:
>=20
> Hello Himanshu,
>=20
> There are no warnings resurfaced after this fix because second patch of t=
his series taking care of those compiler warnings.
> Verified using "make W=3D1" Command.
>=20

In that case, Please resubmit with Fixes tag and Cc to stable. You can keep=
 my R-b.=20

Thanks.

> Regards
> Javed
>=20
> -----Original Message-----
> From: Himanshu Madhani <himanshu.madhani@oracle.com>=20
> Sent: Tuesday, June 1, 2021 11:38 PM
> To: Javed Hasan <jhasan@marvell.com>; martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Sto=
rage-Upstream@marvell.com>
> Subject: [EXT] Re: [PATCH 1/2] scsi: fc: Corrected RHBA attributes length
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
>=20
> On 6/1/21 12:52 PM, Himanshu Madhani wrote:
>>=20
>>=20
>> On 6/1/21 12:21 PM, Javed Hasan wrote:
>>>   -As per document of FC-GS-5, attribute lengths of node_name
>>>    and manufacturer should in range of "4 to 64 Bytes" only.
>>>=20
>>> Signed-off-by: Javed Hasan <jhasan@marvell.com>
>>>=20
>>> ---
>>>   include/scsi/fc/fc_ms.h | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>=20
>>> diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h index=20
>>> 9e273fed0a85..800d53dc9470 100644
>>> --- a/include/scsi/fc/fc_ms.h
>>> +++ b/include/scsi/fc/fc_ms.h
>>> @@ -63,8 +63,8 @@ enum fc_fdmi_hba_attr_type {
>>>    * HBA Attribute Length
>>>    */
>>>   #define FC_FDMI_HBA_ATTR_NODENAME_LEN        8 -#define=20
>>> FC_FDMI_HBA_ATTR_MANUFACTURER_LEN    80 -#define=20
>>> FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN    80
>>> +#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN    64 #define=20
>>> +FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN    64
>>>   #define FC_FDMI_HBA_ATTR_MODEL_LEN        256
>>>   #define FC_FDMI_HBA_ATTR_MODELDESCR_LEN        256
>>>   #define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN    256
>>>=20
>>=20
>> Looks good.
>>=20
>> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
>>=20
>=20
> I just noticed that this patch is basically reverting commit e721eb0616f6=
2e766882b80fd3433b80635abd5f ("scsi: scsi_transport_fc:=20
> Match HBA Attribute Length with HBAAPI V2.0 definitions").
>=20
> Have you verified that the compiler warnings do not resurface with your p=
atch? if you see that compiler warning, please fix appropriately and resubm=
it this patch.
>=20
> --=20
> Himanshu Madhani                                Oracle Linux Engineering

--
Himanshu Madhani	 Oracle Linux Engineering

