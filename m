Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9009C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 13:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2EA86108D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 13:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbhIHNri (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 09:47:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55934 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230326AbhIHNre (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 09:47:34 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188DidM2030484;
        Wed, 8 Sep 2021 13:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KUdbHbGVTqyQIIbNb+jFcjtOnTm13FvsierIxESwN3k=;
 b=p/mjZcxwYpQCvt58j4rT5CF1Ze0GUM2MMfjMggDiMBsXqJ+ZZxGOCEPIyhW4GcCyli4h
 kwzUrKwiv2TBMPYRUZ+hlrWkirJXFy2lCAAtvNjXRFaMGx42JKTSKjO30tJfnxN0o+J6
 63QAxC4PeOYF6ILxFSabD/BUYR1VanOXEAhrPqp+/KRr1qiQNcqs47RXTSwV5CcMQWFh
 /fP+O/JPRWj2VRlf9HZEn3LgKh2xNgye7JPT9inG3zWgd/kXw15mBpq8I5leCemUYZTt
 r1yp8eypf30sCg3UZS36gEL0RvNcMxHRxqBmVmrce3muu9oVZNLL7omnbeN4x3S8WKH8 MQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KUdbHbGVTqyQIIbNb+jFcjtOnTm13FvsierIxESwN3k=;
 b=F3GKviSig/PEHvkABQ4VJId3K/uYw4O1sBByQxUznhxQq35ODXTsKBYYTBgO81OnJutY
 FD+0Y9HJqBlRyGrGQnVP3vF/vBefY5L26fV7ZFpy2rn3td94Gu3/ewe/n407QfAmLK4K
 PxTw0lIWqhty8FxIz1aOkJR/kJ7+5CrZdUD4jWIQwLRAEK+kETl2VK4FptDnrqR07Yw9
 z3V7Ub3gEAxuL0ILXBMTmeeFyGQTRaummE2aHZDXGg4x4I1nnVYpqLok5ggIsWRP3NS6
 Md2EZrddq6dRCPl6FOqJlFRabH91akpih4YyeeXoh+l8zeS8+WTWUOgDJiusqb0AaMWr bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axd44tqar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 13:46:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188DkGm2104851;
        Wed, 8 Sep 2021 13:46:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3axst3u65a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 13:46:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=We7QhNWdsO1aohtAz/B28uVPteM1aWGWQvXpa4YM7+Q76XiXQcCWfApsTfS46ffO14pENt9qLkd3/xu/Rxw7SvtbHoqm+3RABNUHEjN9ry6OzdArO6+8KZ1mH8f2Y8GD7NYK3PLWzwud2qjlboaFLyo9MGuT9fTo5f/yOE+B4apcVIpVEWccYVNZJbR5+U7xCnnMbax5RV+RN+E82RcqN0Ar2dA6JWtytzzNP5MbEJb0GoCE8m1RBjJ07EEhx5rMpQTVl837fdsaavT5gdPF1pp6y/kejq06UD7/eukMYlfK+tFUrkZBovSw6fro23jq/1V7zMfCwLOXvQNEdphHLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KUdbHbGVTqyQIIbNb+jFcjtOnTm13FvsierIxESwN3k=;
 b=PwN9BrtMKIIA/G3QDK2uTzgqL6DI4OSi0kS7ReVXgOI6GBq+tdv4RV2nkgVHJmo5hfEdhYfCVTatxaQ81vmINuGo6SgsSGU89mEFQKk7U6RqYFOkJR3ywKshrckyjXdUAyomGtliy/cA05+JmgHrgRc0mCoQp7YgiwQoijAnNuWJwT1Q/+tKKSRfXN3miLpf3tqyIGW+puaVHRlHbeWsV3/w1+rjzl3/I4gMpTGqfr3aaGvIsDuCfcGdCOFL+szQtMR+WjGutbpI6EiahriULebD2EC+E2kN0WLIHKvG+12UgqLxfTy1+pqqkngg948F0Wf6MOzUwImMSEIoPFBKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUdbHbGVTqyQIIbNb+jFcjtOnTm13FvsierIxESwN3k=;
 b=esPXJnIQZrdkvdRBriUqoMZzHMMOaYuUsm+6p6qcnzm2DnY8x2k16eu2QmyUzf645+CCvn2Eb5/EzKv3tkY9AevNaD1qXLvnyJ0+JM5TdJWzPw/QBpDUtrmKprP1pU+b9ymaQFdwwmFqKeFVzeBAtGUlDgZLlDPNKqjVWNaKBp4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4651.namprd10.prod.outlook.com (2603:10b6:806:11e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Wed, 8 Sep
 2021 13:46:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 13:46:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 03/10] qla2xxx: Check for firmware capability before
 creating QPair
Thread-Topic: [PATCH 03/10] qla2xxx: Check for firmware capability before
 creating QPair
Thread-Index: AQHXpINwAF/C9+tRO0yCHk3FaB5BEquaJsUA
Date:   Wed, 8 Sep 2021 13:46:19 +0000
Message-ID: <DA6135A6-4DF2-4C50-BE00-7C7FD2401A87@oracle.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <20210908072846.10011-4-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6bad5ee-2137-42c8-d5f4-08d972cf09b7
x-ms-traffictypediagnostic: SA2PR10MB4651:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4651E1388DAEC401AD3A2016E6D49@SA2PR10MB4651.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dmJr+bXhRVpbRm/5s9b/H4eB0mSEeT86L+rgFCeKmazSrtgOH0y0E/q0NBlragV3xv2ebZPzegZnWwmZdGrHodjlEl+UlAcfKslzgvc9jZNzYEQOHkbI/spv1+FNNyBmgV8/hwc+ihJd4OeHKjloxu4hWqyaonU3AHwtxrivpP0z88TFN4Dl2xV+2RKU3d7pTt1loF9hrC9yz9/n3v2DJn2q8DquL4hxWu85rnpNi3GxV0Cfppz62RNgZ3R0yKTQmno9qFeGlYeiLEoG/+E/itvfHW0+zdW1EeUH/zkyN6xv+5SU8nuuyhlcF+mkun7+4ta09Fvv6Q/Uq5VJYFQIFul44UMOSfh1OuPbgC7a61JnSjn+BeLxweZHK+UkCS12ZAjYfJB9Ic4Mw4xCRYO+zaa04a+twkjVm4VzAVbR6SAshEherzO2IoT7d+Tnp8dBnjYogtCQ2BPRIqcvqBFNbJ0D4UjI8A6RDPKOF3vvkQhWhcpga9kgKUFsLM0qbdmF7XBt2GMJNLf20H4CaZQdoO6WZqHcoRViFqTw2n7+7yieAZ5HD9sfsULqbBaI8VOjnfUAtkiYefMZ9k1IfzOLyjzRgDRo9EoLIWCOaOLpSUGnZ0TNmTsOgTehfhM1VyiX40S++W5u+evAkBhyjtnly7xyDoMpONlLnGkYprnI7vSUQ8sBBxA+Xa9Z2m7hA6SRkVUVnCrSKfDtIDmtrFx0P0NaqY7/iXf/VAWplTKM6N/WVnZFFUGa494sWWCApqZc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(346002)(366004)(396003)(38100700002)(44832011)(2906002)(5660300002)(53546011)(66946007)(6916009)(478600001)(4326008)(66556008)(71200400001)(36756003)(6512007)(76116006)(66446008)(66476007)(186003)(64756008)(86362001)(2616005)(38070700005)(316002)(33656002)(8936002)(54906003)(4744005)(6486002)(122000001)(26005)(8676002)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DWitzF3X/+SvbkMrpPVPTOSkUKp/JaQPM+vkxfCdOwZjPkGcpe66Vr6+EU3g?=
 =?us-ascii?Q?rd3Un3L6YbcoXSMXxFpDIvDUBrq7csZJHyQdlbMC8w9WCETK8jj/hdYYKqWQ?=
 =?us-ascii?Q?v3zaGRjy7EMV7aSl83mijpoU2e9BY3TR0OiWbKvl8dehc+dp7z+jOTXuyZX3?=
 =?us-ascii?Q?eCcwxturbTGhP1PtIBausxtefmJS04x1kiazW1p/c+wD0hwgvqgawYjKzDC7?=
 =?us-ascii?Q?Sp4Isy36GztdEknX6KUQtm4B1O7cYEeia2RQpqx+GNt5S4fW8RPNlILZt/Ma?=
 =?us-ascii?Q?4R3DJtSyXn0pewpqADXjcXBMguyFXqFMW7ot6Ar9XgqgMJpHOH44FaySa041?=
 =?us-ascii?Q?jE2iIMeY64NjYkhHPz034ZFKFqhPuJt5IIWteIUo5lD70xnCXTfee0feGMUi?=
 =?us-ascii?Q?4mIVHhoF0z32WcEEbhuzedLmvt/gwM8DaCB5+0JEFKjBwpQZ5cAHaRAaqhVe?=
 =?us-ascii?Q?QLPjaUcKBfj/F2YHeC2aeQfDW7C3MhUeeaT+ajcdQTa/mp8TMsCixDpyehmv?=
 =?us-ascii?Q?hucZyNU75T5yMhzk/F19eFskLWz/yX6bf+0zaQQKqnHfUedKJ7yMd3/juYm2?=
 =?us-ascii?Q?wriuxYcNIquRFM2y49whxBAAoFPimvWSh9MdN3sNuD8IVsNYxFM2kJHpf+kM?=
 =?us-ascii?Q?E2V7ovtd1NUyvSSJZGLcbeGUmlp3Vg8ZIiZZ92VGDlX95nEyj2NLR0cKpZPe?=
 =?us-ascii?Q?I4fv/LN5sHbb3+8SdzZIupuHp94rGW+WYIZizw+jf4PKuB6wBhiW0Yewd3oq?=
 =?us-ascii?Q?agUT13PZsm0JvRdSt+SkmB1U3tOgWcPfjLuDe0ZPYHMjm8YixkxvyCSp4JjU?=
 =?us-ascii?Q?c4YldYSmzn2lEXJtKGDj+vM+VxTPGt+1Z81TGyfSsCIX+LpuKScJ5l6QLn4M?=
 =?us-ascii?Q?Fzb0lRgSixAiSgEbHsLgrMBqDcwR8LkrKFagKY2rSneetjdjQ6Ex8k2u40sx?=
 =?us-ascii?Q?ZTJoXxEEjgF5zHJ64FzHpiTsqS7mqNh9vA9O3OdafnF/xpib9rbPQ9hO37nK?=
 =?us-ascii?Q?oYh1ob57P8RCMLdGB1ijS3u+lqRGuXHQrB3GP3ydoUh14gyp3gKuLDX/bT6r?=
 =?us-ascii?Q?fSeULrTCU4gf+pot4GRIWzkNq4kpIKm+k9MWoQGzKPw79Uwnl/6ri8CjKA4m?=
 =?us-ascii?Q?LUHEfNkydDCSS8uZyxvSBm4voAeO7+4wyvHspF67pEPhOedcgyNMyYoBCORn?=
 =?us-ascii?Q?/tprfi+NZ/aRxHlmvZmHcQuk5Dm+NzLC2iZPQMl+dnTgB0DWjYJnNQdxi1yi?=
 =?us-ascii?Q?VSECdRDS2oPrUKw+rs8fo9v9WeEWpol4taz54i9lpTnNPg81o858cbPyHhiw?=
 =?us-ascii?Q?gtb357UKyDcROfuod4fSwn/1WyIXbvkqL6lb8E3rfWFwiw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7D097BF9B1DDC04CAC1B3ABBDBFFB8BF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6bad5ee-2137-42c8-d5f4-08d972cf09b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 13:46:19.5895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QXcBPmOV8RmKPJrK64UUMW0ruagnV3N/cWXdpq8A3RSIKNkS9fsjDDTpXEJXj/GV7+Q62itMhumFlVs8gd3TwSPiTuti466tuzZo7sGLOOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4651
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080088
X-Proofpoint-GUID: l8vu0Fs1lYS8iugJvb23wMuZOzBcy7Pe
X-Proofpoint-ORIG-GUID: l8vu0Fs1lYS8iugJvb23wMuZOzBcy7Pe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 8, 2021, at 2:28 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> Add firmware capability check of multiQ specific for ISP25XX before
> creating qpair.
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index d2e40aaba734..a1e861ecfc01 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3364,6 +3364,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
> 	    host->can_queue, base_vha->req,
> 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
>=20
> +	/* Check if FW supports MQ or not for ISP25xx */
> +	if (IS_QLA25XX(ha) && !(ha->fw_attributes & BIT_6))
> +		ha->mqenable =3D 0;
> +
> 	if (ha->mqenable) {
> 		bool startit =3D false;
>=20
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

