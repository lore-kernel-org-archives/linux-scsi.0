Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4C0C77B73
	for <linux-scsi@archiver.kernel.org>; Mon,  1 May 2023 16:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjEAQt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 May 2023 12:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjEAQt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2023 12:49:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C033E73
        for <linux-scsi@vger.kernel.org>; Mon,  1 May 2023 09:49:26 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 341EIpmj015494;
        Mon, 1 May 2023 15:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=cBknJS2OCRVsxWcXRv1zfajsKMumtNJaGQqOOvIZnGk=;
 b=QpBUXOOBXM+iOuPGS6Cqo42Bguvw1lEJ5i3lAiMe19gK/yvtRXOAjrwMq2AxcRFjF9VC
 TqcOvbQTdktS6lzEscpPuomVju8tVCF9TqcfSt0llQ9+r5LO5HQl/+0PsyoYITI04X0q
 V5vJCsw7y0YfuJ+wugAl5oh/lkF1MwPq1S4FeLVVVqniqukGvFSbOHfAET8I1/gHsbux
 f+5tYb3jMhgKR5b7oi0FnxsD+v04YwVTb4/0gaeC5mMMGKHtpgTMmPt7cfWVpsts16gw
 vpFq14sqZaoPF/Sc7/VC9QOrcMbTZo/0w8aqUlER/FhyQXyPEW2h7WffrsAI1sZ56NsW Tw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8u9ctjg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:11:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 341E7W5Z003364;
        Mon, 1 May 2023 15:11:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q8sp4sxat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:11:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkkKjZDuld7msWkIuqKig/HeAOhz9uhyjfK5nDLF7Hk9LZf7RnjmhBsxsGrAjfL+YcfMceUmM99kykGKSZt7Hl345fg2qEqVzDTJjnbqXgcG38+u/wWetjKj5EsTMZj+l6egpOVMmLb13VM0jujnhWOjCP/dgIUJbBYYX+A9t+r4j3OuzlNz7QJQ51RVtgUGNBxhY2aWQcgnHw2Ylfr7L3/9TUqMbVAYI7VrfKz619Hecbj6mREBYi6FUlGfkPV5YB34p04BKg6YV2/uN0XURxkG1Bu9wfEB8VZ9Ij/QINP5hPLHQFC8vRb4W2ZFU/lc2lQIPYiU5AeF61p5WsI9oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBknJS2OCRVsxWcXRv1zfajsKMumtNJaGQqOOvIZnGk=;
 b=OtJqT9FKQPgx/+0Ujr177KdoCWsHGoJtdvr3/Pq0IYIRCSR4XMdzsAYgXNHLbAMu48YmSX5pLyJF3yI54/Sh752dxk8TD1SpOYEIXyZwhM1d86NsQqHCQzWvNQB21e0TtDmb8jSQGx+EviOix2HSnSMFdKuXCFlOxbpMWfH/T+HtaAeLIgRkhQEZNKWTJFtAb26WT+6CeBLYQid7KEm5gnL8Yc+ZPP94C+dn30euOfyuu9Sbit67pUDdTfENgniMzzw4mDen3yqhsq1VNY7kd5bAyQ2CxK4cmN043yrr0J5f/u9lQJVSaJE05m+qaI7HyM7MDRz1ssl+rU1AbliD4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBknJS2OCRVsxWcXRv1zfajsKMumtNJaGQqOOvIZnGk=;
 b=Ttv6z7BzS3Nl4U1xD5y2w9glwdIAnvswr6EkO1X8PhgQvjlji+w881s4760GmACdk/tbs1vQfw0YMl5Y3zbXlLAQcudxwGYT58osk79oYkOITAP6q9EDiGq3B1ZVzFqO8qQLEbz/n9ngwT5OCytphKwBdxMBJVBdXK6eouqzmlw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB4393.namprd10.prod.outlook.com (2603:10b6:5:223::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:10:59 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74%7]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:10:59 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 6/7] qla2xxx: Wait for io return on terminate rport
Thread-Topic: [PATCH v2 6/7] qla2xxx: Wait for io return on terminate rport
Thread-Index: AQHZeaazCVLfDiPre0CcN3idu3mbg69FiuoA
Date:   Mon, 1 May 2023 15:10:59 +0000
Message-ID: <C6857A1F-FF5C-4119-9499-8D996371BA66@oracle.com>
References: <20230428075339.32551-1-njavali@marvell.com>
 <20230428075339.32551-7-njavali@marvell.com>
In-Reply-To: <20230428075339.32551-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|DM6PR10MB4393:EE_
x-ms-office365-filtering-correlation-id: 9a238ad7-58e7-4e66-c476-08db4a564539
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JHS/EIL5wuqYshugrTnGJOFAiOQ7/EiKyuSBI7L3yKBFa9ghX4GtP6lO06adgq8nlkZmaQGjqDfER86S5kLgA7nYiNXKIOdF+Q/IDLnPPMJvLx98IjQ4DNPlKHEmpFBvfEbjQzF5HVbvZa2S9FW/bz4dT/GBruIKzemqDrMPUSJXBokboxj8XhbV2uOLr5QJGkx0RmIiWTrSPopl3CQZvPFAcEXCfpKrtgJr5qxqRP3rYz2RKmGhI5Xcfta/J9DjmTOL56gCh9vHar6/K85N43HyqAYmoTvNshFiT2paYcD0LzEX4PvTadbHG37+3XcS9TYG64g+eB7kwI4nZLpdlz1prDilemXymDTHXwP3SbO0LQs2P9QmC16bG53riDTiVJUeSRI/StaxFsWwbQhXGafhpKCEPcGmfauP7ASVNtw4veFm/L35em/4rUtabe43ZhBAthNyOZRHr6uc10Nyo0qEdHhnR82tp/7NDCjSfdW4pfSddM73rFySqltxcdbEH8yIxYEPuPvNFZe6WcuOCw0M43GhtaiRGUrl1S/6PEsYz/OuFoE8/qQ0FwWPXw79Zd5sA6YdmmxdeJYR7gvdgT+Yk0XZPRRumKMDnMlB+546U9xKaUG3AWjenguy7GmSbzVk/RvGn9ymKIpktrwamA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199021)(33656002)(86362001)(36756003)(38070700005)(38100700002)(122000001)(2616005)(6512007)(186003)(53546011)(6506007)(26005)(6486002)(71200400001)(478600001)(54906003)(76116006)(66476007)(66556008)(316002)(4326008)(41300700001)(8936002)(64756008)(66446008)(66946007)(8676002)(44832011)(5660300002)(6916009)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5CmLzRFokGAGd0DUIaoFbe1+Dl16dznelLaDpGOJvhF/YRTK516SlPfG7TMh?=
 =?us-ascii?Q?lCXFNXADSLfafWNQNjZEoqBhRI3azZZjfTIl3+fPRA/cpeRHTZ4Nx+9iFJLO?=
 =?us-ascii?Q?reEnTb1IV0JeLUgVtlBPaytk+KfXXLROeJ3/B17tQbfhozQ72mYhXJhmLLQF?=
 =?us-ascii?Q?NnYtIKcshm0PVUZqmPJuJ5r1pMssBB0oJbGGrkc4zzPFVPXQyvGiNQWA42+M?=
 =?us-ascii?Q?6ursqjfCPCI11SPnauGPAUpViNKlRLUCQZvz7nW/ILeTXaeeVCpvATmBWHOT?=
 =?us-ascii?Q?cNv9M9khqUObVIq/a/nULidWKZBTyOAgAWzQU8GZ383heXPUfTST+M9QtIS1?=
 =?us-ascii?Q?M46PxMbZGnOXLBBZiY/+WLg42RkUc/Lml+MCjNrC4iQmGfRHktOeStgp8zgz?=
 =?us-ascii?Q?zDf08oZyA9lmVz1F8pC+Upby92ZXCyKGjLwjH0d6ch8OYVlsBuR1YzWzigaM?=
 =?us-ascii?Q?E2FnusbMaM8QO6MhRVSuavkGqI1QBofww7G/+2MzpqMfND6mUFrzASVitvSX?=
 =?us-ascii?Q?/F2xi5yBOrrzJcirwDQQqeKYGGPY8EDe/DFLeGraofKUnqhYJ3kd24FQDfsS?=
 =?us-ascii?Q?IBFyClyNEGkEdysBQgkmsMo4/L3bc+pVTOG24BQqlEiMpB6jLOogDnUgonLP?=
 =?us-ascii?Q?S4nh8fLG1n2jJbY6W9d1ImnWI891i1nzhAbdz8kLZfLQDquNSKg1hRmMSy6Y?=
 =?us-ascii?Q?3/c+6r48BSJJqyTfdhUm/OGi7KwlIbh5kX9nZi3BkonXGA0W1oL5/n1S/+qI?=
 =?us-ascii?Q?ApotDB8QCggR6LoRQKUTEK6mmV6wYLSta9ef2PhPiZxDnkZnQyfwB+aYBh8u?=
 =?us-ascii?Q?uqt4oGK6RJE/9pmFS1oqZNOp9VxM0weLq6Iwoa6yz5KyyJstx3OtV3SYoBTm?=
 =?us-ascii?Q?LAOBLL2XZxOiG1VXnVOqXE2aW9+/ytoJNafOUkibxl1dISLAcBQR6FG1l7p/?=
 =?us-ascii?Q?yz136ux0cZzCVfqPlMNGG4n52oSEJW6HqccrUKY8cd0h1QWSBJ/Ff6ES9wEG?=
 =?us-ascii?Q?DCz53FWtW4NKmdREuhS06JlJshH1jtwXLGRuuYtuKC8zAoxIvoGkmdiwsWxS?=
 =?us-ascii?Q?zZTP6ORb8O9ofhbTVF3o5UmJK1NX4KBkmikVZ1dy4vT4sQI9QkrafnWtixqD?=
 =?us-ascii?Q?/vQrcCz47oirSPzBShgUkyduZaw60IhZecdwC4VilHhnHi3S2+GEldEVOBnK?=
 =?us-ascii?Q?bVQnLuGpIAPo5fb6JnBo+iwkkFwYfLze0bVuKqsMdEjjMiUFENVg8Cgi5i8+?=
 =?us-ascii?Q?9a/3r2UbhWeckpSHzFmJvZsNdksnU5Fc1HFCYkU1dsyMpx6ZTUbNVK+K1618?=
 =?us-ascii?Q?Fa+CtQKTg+BiW4/4Fy2H16NYDwc5ybEG2AUkemyfgcYvZVMa0at2ciznPPgm?=
 =?us-ascii?Q?BnbX5IpQPy3VG8sSZ3sHmZberjRH+4WgOibLkpjJIenhDql/EjnBrQo3s6rD?=
 =?us-ascii?Q?2dQrnYYCVljzwvBUe5ALe3EF2wbBgTsORIKrYxuAU2RRNPbPufEOqG99m7hK?=
 =?us-ascii?Q?rKmPWeRv47lgkrobvwre2OC4Bbi3JKBCO7bTpO99DtdKaxfhTfvQHuS0llgx?=
 =?us-ascii?Q?fGXwgcRB1j3HeSytChSZjVyhs89BmAQ/HkfSfkjQWI1mNrbFr2SaPuWPEtvx?=
 =?us-ascii?Q?CA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <59FDA290CE619447AE99E2BB1DB8CB92@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yLdBoHSNUBtRlX/P+jZGllELp7Fs0zvRAozHGunURdmv8P5G9JvoRq3xp6Sqb3kfZldwHu9Y+fjopNcfdGb6VcWzA+9t2FueYC3EhWmIhitbKSQpQ0d5FvcnW8U5moBbdtfhT+KCdi6fBeUC5rfqy6bxNYdQ6Ota/uIuGTNWvHlrSpulA/l5/YNxisI5jz9dLTgd1MB7WlEZuawYPl61ql2BmMeKFdPZpmBSOq2i8kTjsc0NvXPFqMWYiQgxpR6Hehp7qbJInU3A2X5ejFU+qqfQ0g/byK3KJ9YMwekng0OxNXrtV3+/GBw+8gVPO/bC4Mz1/L5LBtDqBlmrSMbxwrkwy+LyoGY8+XoVu6E2LR9YQ1VkicxqzpWcb5NPpMaJ3FSu0uUD4504P249zKXQQtt3Juzk27P/lRZ6QnxZNElhTvTgDRLZshFbk3aXthl41+D3r2+1PRGUIZBAruF7CpYm+BlxpBGvHnP5uwv84T2uHnUwbLmciQXg90tEsXzqLTqCEWDpyBVKJlhNmnB1Po4Ihcm+OLZHkbZbEf+dYALNqwrSporv2tsavoOsEwGdeJ4wXe6X3KaaX3PUIYVB2SpLI0ln337td6sQpVyEZroi5Wj0flHZAB5lk1+CrLItSNFTXXwdCUORUCUs0hyQW7dYyerTdGVemnFhZnfLGIGPyMchuh5rfd1YO/IEwTiN6bs3DOna5PosxQHBdGyoWX+Y3raK7+i1OkCC36dnL4qysturCGvUin4a2tnHLNzXaeKhPvbDWe5srcQbUWmqGTUnaGH+7BeZStJFW197Odg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a238ad7-58e7-4e66-c476-08db4a564539
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 15:10:59.1554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PykOFuzAl9iUpR0vUBWTGSr4AZz072l17Bp6z3Cc+WgTctmGNgDLaVf2+Y0nTfbo7kYRc+56S336XV9z6G+ONyPpo8CcMMyeWa+A2jPPCPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4393
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-01_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305010122
X-Proofpoint-GUID: ax7B-aG4tYma6pHoKr5MalvD3xVrdWGw
X-Proofpoint-ORIG-GUID: ax7B-aG4tYma6pHoKr5MalvD3xVrdWGw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 28, 2023, at 12:53 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> System crash due to use after free.
> Current code allows terminate_rport_io to exit before making
> sure all IOs has returned. For FCP-2 device, IO's can hang
> on in HW because driver has not tear down the session in FW at
> first sign of cable pull. When dev_loss_tmo timer pops,
> terminate_rport_io is called and upper layer is about to
> free various resources. Terminate_rport_io trigger qla to do
> the final cleanup, but the cleanup might not be fast enough where it
> leave qla still holding on to the same resource.
>=20
> Wait for IO's to return to upper layer before resources are freed.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c | 13 +++++++++++++
> 1 file changed, 13 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 70cfc94c3d43..b00222459607 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2750,6 +2750,7 @@ static void
> qla2x00_terminate_rport_io(struct fc_rport *rport)
> {
> fc_port_t *fcport =3D *(fc_port_t **)rport->dd_data;
> + scsi_qla_host_t *vha;
>=20
> if (!fcport)
> return;
> @@ -2759,9 +2760,12 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
>=20
> if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
> return;
> + vha =3D fcport->vha;
>=20
> if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
> qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
> + qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24,
> + 0, WAIT_TARGET);
> return;
> }
> /*
> @@ -2786,6 +2790,15 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
> qla2x00_port_logout(fcport->vha, fcport);
> }
> }
> +
> + /* check for any straggling io left behind */
> + if (qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24,=
 0, WAIT_TARGET)) {
> + ql_log(ql_log_warn, vha, 0x300b,
> +       "IO not return.  Resetting. \n");
> + set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> + qla2xxx_wake_dpc(vha);
> + qla2x00_wait_for_chip_reset(vha);
> + }
> }
>=20
> static int
> --=20
> 2.23.1
>=20
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

