Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72C0C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 14:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A21D6144B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 14:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239857AbhDUOXj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:23:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57052 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbhDUOXj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 10:23:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LEFlRJ106912;
        Wed, 21 Apr 2021 14:22:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SKUPkE0eFfmkd4koQUB/vDknfAdoS4ze892g/TiRF0M=;
 b=wSc/U+E2GCucp5AcN7k6i/FuM0L++z/4U8Zb95FdpPz8zqnOCSlhQN4yPdxWpnOlOJ0a
 Y2v1kMpkc4PuNVZY7h3gMYhrI1eMUyk/f13UxgF/raQIG5D6x1UHUtfWjpM4U8T3LkzL
 1bCGySvzThoKg6NgWerBNCv4wTf+Rb91wZ/nZfUiPSfvaknNHpo7RCEhp4iSYZCWe8cR
 Vms7Mm2q7+iRN2NFLLHH6lUcnNPheyz6aeW4J1mwb7Xr+Hu19e/29jEh9t9IufCzIYNz
 yHsdw38EEqARYqQ7JDMQ/8dS43lccU49u/JU+c9KQNSpaRAVnlxRNw2ExHM2IiQ7bzbg IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38022y1uvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 14:22:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LEExvS139712;
        Wed, 21 Apr 2021 14:22:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3030.oracle.com with ESMTP id 38098rt2x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 14:22:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nF393ELrlBXh5U6VkrDQwxHtlgKdPN3j1RBV/4XPL7NO+B3jxmBoT135Wg1RjPA4WWkc+PBzEgq1sYf/sav15oWOazSLtF9eVms/7XvBz4CiaFenIyhK3S4HnmCbf2YYyrANNgxijMpr8m1wxFt47jdoU4GZt08UHjmACaoGUzJsJvUmzDeFhLE/XqN35ZWiLApxEyGsdupLzD/bD/lcac4nl6vrxnfKOuAjogZO9DvpfISzZbG7LwjLkj2YPdU6xzYIjaJXonH5ZNqu8ImBmCAarO7GNt2fScrDjW02Uv9qG3D6Ola960Ljmd6Qx/YottaCLBQTGblujLMsXtYJeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKUPkE0eFfmkd4koQUB/vDknfAdoS4ze892g/TiRF0M=;
 b=Trpn5NzK++mzIoXuZrObTvRtr9iidz5mnH8nCAqjyyTNqrrc9chX/5fc2/dQY0bSWbDTVPGV6XM466cjkNQXnEz1ELsz58SK+0O4cEInEmxMsKCv0oE3LjrwOnZQ6vSE7hBbqdgwzLedFOjcjHy7PkDhh//XtlkFGKIoT3LnPs7rDLf4HstKrOu7JbUcSyVG2fFwVtT7ui2rwgWiDNywzJd9hjXVrtFQH5WdDoMA620u0zHenOjBk05+t+/zTyXimAI0hbU9eWtmO2ORnKNjjv9CfqZpbd5KdPYODQ4mMLOBIytu1oXljvY3phcACf6OUC84L0tiFX/xFA73muJywQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKUPkE0eFfmkd4koQUB/vDknfAdoS4ze892g/TiRF0M=;
 b=S+8Utw9IiLbTpXRv8NUQ6Lc04WC1IJ1/bLFHZHQzS7v0Whr1/avIkxwFOI3TTAIur0i6PfvsCB9kmPm4+fSHhjIZfGbAZq23w81/CIgoWGOlBPyBeJNARBdJRM8exZ/SifhrCcg61ReutfKAwrz64Q7vwgFGZSd038LZWbaBMDE=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3334.namprd10.prod.outlook.com (2603:10b6:a03:15b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 14:22:52 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 14:22:52 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bruce Fields <bfields@fieldses.org>
Subject: Re: [PATCH 075/117] nfsd: Convert to the scsi_status union
Thread-Topic: [PATCH 075/117] nfsd: Convert to the scsi_status union
Thread-Index: AQHXNXo2BUl5yYjJDkWhk4L177onwqq9eg2AgAAj6YCAAWq1AA==
Date:   Wed, 21 Apr 2021 14:22:52 +0000
Message-ID: <5F9582A8-3E5A-4810-9579-51D2BD3A8B83@oracle.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-76-bvanassche@acm.org>
 <67BD8DEF-7C29-458A-9135-6602192594D4@oracle.com>
 <8775e8c9-49cf-c3eb-0933-8029494f2ff8@acm.org>
In-Reply-To: <8775e8c9-49cf-c3eb-0933-8029494f2ff8@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 993093db-2e5d-4c37-0c28-08d904d0f2fc
x-ms-traffictypediagnostic: BYAPR10MB3334:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB33347F3C3F97C3A48490953F93479@BYAPR10MB3334.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FdyOwfjWqLSK7KgSHxGcvCPp35ZFoHFbkwsHWVdUrkSEFqwYtxZtQClfXUfzVS+YdDd4B6aIAt/OLsQX/mFjoP/IYkEpzhc4WI1VTdc3c27dgvwtbiy/hwqYM8mNEqQ+BGQWsCi+nNWelow2tZWYy3sjt/xEb+kBEUVZ0Oh0zauntkNIg4ZB9E7Mv8crpXnLcBAiAM0FbhNPbQ6Tbz0/+gysmPD6oB+cxpSFi+HwGyqoVzIL1pc1lh2tgJLYOaQwOTjhgv3A9BlSRg1jmxxVFDrGlqtuz9lbkqijdvibkDfks1UNF5e2iSmDRmHuMxYfUHPEx5egSbzb3oldXwmG379bQ4a6T0QRyA4vMOjPleb37ObTEIJ/lzeNu2fsOYMwpGabC6R6tjCoPdiyvwgym2ggcN82bKxkr3FAOwfEXfVLsrACFs4hcuaGHU4wj5ClEu0w65YneiHdtCrERXddjhiXhAKmCdubvXHChHGnkYKCbNYG8bM1863Ct+/J8AlOAdd1MzTr9jiPyV3JUzb0SmwynhQ7hfDtjhh35rSTuEZD6wK/QULqKQoxltzHdorx18CIgbJKrbQ5fL/Y1ohrOmq7wRnulOLybHZmi1MRHNgwzwYkj+oEErc35VtCeA1jWIvLoE3ZuWE17XqzusyNrOSiSAj0CP0NAleeJ9dKvysOCRNfw3n7CTAXeD3mSXuQejsX2KmooKOhom71mH7js2jldROs6OsWe7lROZTweXsMk0KnGWK2Z1u8n9nfUrot
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(39860400002)(136003)(54906003)(36756003)(33656002)(2616005)(6512007)(966005)(26005)(6506007)(66476007)(4326008)(186003)(8676002)(316002)(6916009)(8936002)(71200400001)(53546011)(86362001)(64756008)(66556008)(122000001)(2906002)(66446008)(76116006)(66946007)(83380400001)(5660300002)(6486002)(38100700002)(91956017)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5B4k9jA4qzlm5tfovpqoyFl6LHUUwpMOjfxBLUF1eWC64qZYO6LkOvEOt/M7?=
 =?us-ascii?Q?5I4ZmSz+PJs0/ok0a6zsQjn6OGRSieJQVtbw01bGa5C7QsTARBoJA+OczatE?=
 =?us-ascii?Q?x9ahPdgYBHyvJ7h82j+QTlY1o7LNTlnsZRQdl2nHk0DSAj7s0H1ur/WNuM5s?=
 =?us-ascii?Q?aH1zIeDgsXlb+iqy+LBKgc5Kp+XNGSrDrQZ4KSP2WFWAh3v5HQfujyGcpalt?=
 =?us-ascii?Q?iRX+8AwmmrvJwUsMiZtMFZYFKnhytBAZEPvV3r+PhQvJCMVXEfvWgtoLrrw5?=
 =?us-ascii?Q?KSoCfU5ke0K4q86ZFYX7qTkKSBJyo00xaQGg96mb8uv4ogA8nBx2s1922691?=
 =?us-ascii?Q?gxGuTZCWOxotNkfh+Lr6ztcggg6soZnL912hqEX0zy5PDWIUqPOQACf2lgRD?=
 =?us-ascii?Q?snxWnvR0j5RGBBZFzXUAJbnEpulKBtnn1uioYsG8BEzcexGPR7Bkeeq42WGm?=
 =?us-ascii?Q?LZJph95z10xizKzy0m9Znk6sgbK0HRnju9rta+OHN6NTJoeVjY5DGrDs9ysx?=
 =?us-ascii?Q?DWKGxECxWRDV7Z6wZdicRC/V0w3CEpHF+3iMY4hhGpyjK4vHTgE3jZV0Gvep?=
 =?us-ascii?Q?+tnqc09ykwkkHNpEPJmzSkgo9j0QKsrNljxK62WFQZMZgfWWPlnuU4FnEW6k?=
 =?us-ascii?Q?xJmfZKJVRnFh/UVUUsTAxcQSUwXgc4rnFbuB+O/xm6h9aP7Y97DkQedySijg?=
 =?us-ascii?Q?qfb5cv2FgEPQbHQvSGeEWPPSrqvYPxWqmajmhwS6aUsl5ky0j1ryhrQ3rc8P?=
 =?us-ascii?Q?Aev0ZmSCWVCJZ1slhstSVXWPGGU7Ca7+j+u2qsQ4Y16j3+aWD+jn8yvIvLgx?=
 =?us-ascii?Q?rlnIA8+5Hzi3F6NbQIV2MALu+QLbsAuvYhvtoGHvca4s9nT32qACy590H3Xq?=
 =?us-ascii?Q?CvyBbGeiKnJN4o7MZHgm6f+z1DQR9Y8RY7ccH/mBcH3+HdKM6/y9+pHEeTEu?=
 =?us-ascii?Q?toOgjC88MOwK6uyUKJZxLrZfbXtixu40Q746vI8AGoFONEBbvhFeyD0nu40t?=
 =?us-ascii?Q?jlt/yBblo1hgJpugW1xsxFOpUrPYrnJTkDp/bO5+yKI9Y5YynUut1UVbvZGJ?=
 =?us-ascii?Q?KVVVR1kwdGHAgCq05JHkH1iPJXbZThqCMjjN6s1UEZrF9Hlx+frUyvRU+uPe?=
 =?us-ascii?Q?yVO4z6Cu7JDbZuJP77CUDWDLZGaXv5J1fFH6JCSzV3NlGYSgvS5Bi5OuogD2?=
 =?us-ascii?Q?h3p/f1qUp4mi7SZ9a3nuGX+DnC+auAuXY8dbxxV6vO2po/RsWyLzOwinA75P?=
 =?us-ascii?Q?YJFOt5vjEhJb/EMljJUgYjvF60YqQ29iel9YInEbnUmiLhYryHR1wlCImm5j?=
 =?us-ascii?Q?CBGllrPfYZ/tfE5tOmKGldixi54xHKZUL5w/5XYHDYV0+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A1E65989B1E9AB49B4B9BDB1BA1A91E0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993093db-2e5d-4c37-0c28-08d904d0f2fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 14:22:52.4993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xbAafrq47k8XYZh6YkJKXIxhO1zIi2wU/Zdc05YBWX2gCMiix32JJOfTACrpWsVbTqQfjpPUbK25T4DtYyuMpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3334
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210111
X-Proofpoint-ORIG-GUID: TNbjx09iBq2ne-D-p7BVPmiozylimirg
X-Proofpoint-GUID: TNbjx09iBq2ne-D-p7BVPmiozylimirg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 20, 2021, at 12:44 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 4/20/21 7:36 AM, Chuck Lever III wrote:
>>> On Apr 19, 2021, at 8:08 PM, Bart Van Assche <bvanassche@acm.org> wrote=
:
>>> An explanation of the purpose of this patch is available in the patch
>>> "scsi: Introduce the scsi_status union".
>>>=20
>>> Cc: "J. Bruce Fields" <bfields@fieldses.org>
>>> Cc: Chuck Lever <chuck.lever@oracle.com>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>=20
>> Hi Bart, I assume this is going into v5.13 via the SCSI tree?
>> Do you need an Acked-by: from the NFSD maintainers?
>=20
> Hi Chuck,
>=20
> Thanks for having taken a look. In case you would not yet have found the
> "scsi: Introduce the scsi_status union" patch, it is available here:
> https://lore.kernel.org/linux-scsi/20210420000845.25873-12-bvanassche@acm=
.org/T/#u
>=20
> An Acked-by or Reviewed-by from an NFS expert would be great.

The NFSD patch looks OK to me, but I'm hesitating on sending
an Acked-by.

I went back and looked at the scsi_status union patch, and
that looks dodgy to me.

AFAIK, "enum" doesn't cause the compiler to reserve any
particular size of storage, it just makes a guess. What
keeps those enum fields from being 16- or 32-bits wide?
Shouldn't those be u8 to enforce the correct field size?

I'm not sure where to look for further discussion on that
part of the series.


> The names in the Cc: list come from the following entry in the
> MAINTAINERS file: "KERNEL NFSD, SUNRPC, AND LOCKD SERVERS".
>=20
> Bart.

--
Chuck Lever



