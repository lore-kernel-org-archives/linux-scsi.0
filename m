Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FADC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 234BB6109F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbhDLKXa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:23:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49594 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237524AbhDLKX2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:23:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CALK7s004451;
        Mon, 12 Apr 2021 03:22:53 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu994wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:22:53 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAMrIQ006753;
        Mon, 12 Apr 2021 03:22:53 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu994w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:22:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5oSuqLov26pInez+aMHTHpmykPvUgJeLfHIY82y5HjERBLMacTS7dBQe2edtitGGQq5m25gw3mzn/BNHXkLN131+PpkRA9xtA3+Wov1A0GW9r6nwy6g+PPFxrbi60OrFLcI7fWOTA7MTBjCdMcX9mA8uXK0v/jH9JUtvcCQl9H9ZtQTKG2KvKnL/vXMk9YRfZPMsTohgsiqgWO7AkTdjnztLSeLIiXcIMTAfgG7NoTZFjK2n+dhxkv1U68FJrmlfJI93Zs+nYNIA73eF8Cer8xVrm82+QgKg5vCn9K3E8YogFXa0FLCQep3/ufAfVaVVhY3E6ooPt2vP6TOfoNtrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvT+75dx5+JE8Q4dgL3pIhbbMy6ddMzU2jAwqCSkbH8=;
 b=EEZBWPrKV8kqapw3ylD0FEyLFpwA+kj6i+k8eM37mzMOHGlrHVN3cBMjac7FqXh/V/EcaUBFv1Npq+foD4041lNaNs1vXv/2RAEUeO4BdzXIgy34Mt+vz4w5LkKQ2W0hoFBmQ1rn1mAMGf98nKqxSjRQuRUcGrs2+LUTc3gy+IqE6RUf3Iens5RgHaN5x9G/CUgE6DSwZV98Kd9VwnkkbaMg6iUl7rlYVvBjCywQ47Wzs05eyPsHvs3PT23NVHCeMJu9Zrxhmic6yVbDjBUjKrBlp1SuePVSlCKMDAJD67Wzuuzx5PxeR/JeT3kWqZtxe0QsdfAvre2aQcqWqztXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvT+75dx5+JE8Q4dgL3pIhbbMy6ddMzU2jAwqCSkbH8=;
 b=X/aTvqz7pZvsrvb0810bBwu72uz1xc8Q+3yX3iLd7r2udiQl2x4tsDZt1HTrfU/Ef6+9TshCWtbcc0GFO5Ge/hVYqI8u3HQ3ToT1yAxFf+5FdTr+TwTbAAWh4AJe9WH8Qtnykp7hxKkTNPARLWNWVBt6Hj7OkkE7RJdr0Of/MUQ=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by SJ0PR18MB3900.namprd18.prod.outlook.com (2603:10b6:a03:2e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 10:22:51 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:22:51 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [RFC PATCH 0/13]: qedi tmf fixes
Thread-Topic: [EXT] [RFC PATCH 0/13]: qedi tmf fixes
Thread-Index: AQHXLjj+dRG28FMxrEeKgEqZthI3NqqwrThw
Date:   Mon, 12 Apr 2021 10:22:51 +0000
Message-ID: <BYAPR18MB2998A8166E6E1AE4635A738CD8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-1-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7251aac0-b1df-4724-faa5-08d8fd9ced6e
x-ms-traffictypediagnostic: SJ0PR18MB3900:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB3900943FDF2CF3EB797F10F4D8709@SJ0PR18MB3900.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EF8QHF3gQ/XRuZ/aCc/r2k5+0qOfBoTLwoUKexSFcwgIV4soEVmSsv2AEcoK06i/hx6/9F7YQP+s2hHIOGt2Z7n0q0cV/CZxFknIUhjApg7SWRKyVTii63d1cg9F/yYsAzOE9cRYhqloR74bEnCHtN9xkPl23cWKZ0WrmFLBGTnsb7ABllQpF2sTK5JRsvbhGfrUUTifQbPUrIOAqaYn5ipAKoLyn9gTFFApHHwnjX+dMO11hJyksVkw7Lvj0h/qz2GaEy8P0lIIYC1iUlp6XV86ZIT/kTYDOFwMD+ynHbfV4ujfNP/HTrg/dV2V4JdYLw6BmTkjZ9aPydMJOLosmgX8Vd08DzyccWoTHRZb0YzDNZYh8gi/UaFT6bYQIAvKAn5vjN4sTEO1X67nPZP6J7pju1ah8w8SD/kZQnNOpBYxjKnXM+uLrnkjbNGCOulxITC9CrAyIixD69fpUmN57kaEi7kGUP5fCzMCGr4VBrgL4NZGe0ZK0xt+gq8bwjwUp6GxPnv+4JCnVejYvfHuX8gkTjpGyXHrEmtXHyMhhGHc9woBL07b+C75FF8AY3xVoM6/KUfNc7D/aG4R6U2Rs/sPWIbfToIjApbiqJCXK4o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(4744005)(86362001)(316002)(8936002)(9686003)(6506007)(71200400001)(64756008)(38100700002)(76116006)(110136005)(83380400001)(53546011)(66946007)(66446008)(33656002)(5660300002)(26005)(2906002)(52536014)(8676002)(478600001)(7696005)(66556008)(186003)(66476007)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Mz+5/85hN981YNtf2a5XAV2fVPndVVuBJ/T8SilJoqfZt2yiDapr97tpxaEu?=
 =?us-ascii?Q?u3YCDQH7GU1yagSeISoIf9mRMXht1/tOOnI7VUbJpYafQ+OPFEJ7YBHR4VMS?=
 =?us-ascii?Q?wBulUux5+D/CqNfQxTBWL17FbDd9j5t1VErWVYLZv1UQro2rp68kXztTXIh7?=
 =?us-ascii?Q?SA/0U0YR1I6DC9y0cK1aC2ZuI3apdL4FCPJWBxoP6kpWzQ5k4dELIwsAGE1J?=
 =?us-ascii?Q?SVekllbtyayd99uIabU7uUpdCncV7P63DVs7S94JFrzfpn8VxYBwygZj+H0D?=
 =?us-ascii?Q?RePx748VpiEdOHyb5xFUJ/rKIzImPkrPFB/urWiU3ubKrQTSsLbOqHo0/cq5?=
 =?us-ascii?Q?mD1AUZGYBwCHJqwg39jwZ1HyEhzA/DwN30YUWWqGJTloU7tpXLv6w0UDpfaP?=
 =?us-ascii?Q?Pl7RxZMOwu8dFK/3lWl95jbfAYblnovFaZj+fmPC3UzFPrWuV3ZsW4bOq8T2?=
 =?us-ascii?Q?vLbidJPCr4g2jMtFxbYSc/nFuElcMHoKFsOs9yDhEq3myOXmSs/lePUtY+dl?=
 =?us-ascii?Q?quSNI0qsIK9tjMXgKR6EACYHNH+/dunoXzT9AQ20Bwm0Ks8yCCBW9gkE6U1z?=
 =?us-ascii?Q?HzjfUmYS6wGaMIEdrmeu6tXe4crXXK2eafGF2lvduDdxu/qg0DGD/zdbRWRj?=
 =?us-ascii?Q?HOm/bpF+DM4kxbUTZzHpAyE+6Et/WWSzuycXYQ1E5xGs8nuLmxfmVyRr722Q?=
 =?us-ascii?Q?PJPwQcuwBTiKu4dpKJ8Iip2I0OFBiDOI2STWo+/PdwzXjETFqPvKs3/UYNqx?=
 =?us-ascii?Q?/ToLF4ePw3vrQ8Loeajc/CSihs9a9LsVtlUEGaLFbajnC64rSJOwsk2jtiJ/?=
 =?us-ascii?Q?Ii6on8ThkJ29S6kLG99OWA+2uKedLzhcnWTPCo2oghzylvRrc2CggJiZ7+C7?=
 =?us-ascii?Q?VbRY8vH6V1ghdkF+F8igXrQsvqlofF5/Nj02z8sv2j8TVKoojLuZwSSz/nQ6?=
 =?us-ascii?Q?LmdrK4VW5VNifO7uEjsufxA1yhbMm0CnJsnfzGMsmaZnejwuKa8fiDonOEy3?=
 =?us-ascii?Q?qOw5+u+iGixGVooUKATjhcT8ru25ZvatSlMfnWU25PQaongK+9Wk56gO3hdf?=
 =?us-ascii?Q?M3T6MxgQ6wkFH5zKyxDKFEE2l8CPeQrhbxV8y1LDbTQrIU6E0xvloBG8vMud?=
 =?us-ascii?Q?QvzYsk9voOmcC3xGhIOxtlOTdCXMkUPOvruwNPi8nPYbYM2OHqOhaxGvrTI7?=
 =?us-ascii?Q?sQXNIndLtx1Tnx+CUpKFSxHwSU6MJWxA1898gLhZjyQCJLEXjixURh3MGl+S?=
 =?us-ascii?Q?0f/OVu12fSbaxUM7lrxZkt56krf3Km4/CRu+GBI25I4y/t1n9RfYbXh8UR67?=
 =?us-ascii?Q?KEHmMKiToGjCcGMvJ+gGWQP0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7251aac0-b1df-4724-faa5-08d8fd9ced6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:22:51.0785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CCSF8+3/Gfpq/DkoMAjQtSOO+Lox+38YfFd5+8rLWoCY9gjMBTly+udNfWEEAfzEqA0kQIjRRe66aubRzLZu7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3900
X-Proofpoint-GUID: b152hVj1xIgdxmdkA5CF9Sl1m18aloqz
X-Proofpoint-ORIG-GUID: lp6mu1UgMPe9KHSOO7jYEZtiQed9OOV4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_09:2021-04-12,2021-04-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Sunday, April 11, 2021 12:10 AM
> To: lduncan@suse.com; martin.petersen@oracle.com; Manish Rangankar
> <mrangankar@marvell.com>; Santosh Vernekar <svernekar@marvell.com>;
> linux-scsi@vger.kernel.org; jejb@linux.ibm.com
> Subject: [EXT] [RFC PATCH 0/13]: qedi tmf fixes
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> The following patches made over Linus's tree fixes a bunch of issues in q=
edi's tmf
> handling.
>=20
> Manish, I did some tests here. Please test it out and review.
>=20

Mike,=20

Thanks for the fixes. Various recovery Test with and without IOs with the p=
atch set went fine.=20
