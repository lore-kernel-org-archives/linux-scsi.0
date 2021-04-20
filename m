Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E863FC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4CED613C9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhDTOwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 10:52:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50146 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhDTOwW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 10:52:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KEo5PI147538;
        Tue, 20 Apr 2021 14:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xYyDFekzLIqcLS5hE6WmsrdKVpQx2qpGgE0ntVOq7ro=;
 b=wsCb0zPVdeltj9E7kyRRCxQz4mMGEcVXVpddACu9x8y28q2lDSmpKyajd6EkaMHCUyxY
 QE1sv5CPcJd6ElOxE1bJAADFQFGILNaLIOkxV3TOewVVVAom7MvBKOS8ta0TBqDqiSa/
 ++u1eUoo5riPtBPFVqBnfpWuZsHvxcCHInJgsvJdAJZUvxhV+9AKd+msc22wxH34ToIL
 n2+/ezz3fNYxkj7UPna3Lr0jkewKlG7BoTxfNk+wWGvNdyDpqAMFPtlKOy3Z8CxprDQZ
 ZIp494dG++p27Xt+n4XCWcc37dVVGaOCevMvxw4sfE810T4TvYpjZfJ454pLqxbtg/tQ jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37yn6c7guq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 14:51:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KEiogj116395;
        Tue, 20 Apr 2021 14:51:30 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2051.outbound.protection.outlook.com [104.47.37.51])
        by userp3030.oracle.com with ESMTP id 3809ky4v8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 14:51:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3HAlTjMtGQvFOhs5vQTC4O1v9FsKtufjKo4IwHN3FRRYyWZ5SrN6JZftBQFfoSghCIubeLQ47K7MIXMdS4U2nWkzeh8qZbYgiDs69wzCxf2eYgcnYFnLt+rEfTihiBMg+prccxJDGz1zQWj80EoY7XaQluJntHJgwAIsgOm4HxZo9Sl+OEr/HYMe+UNZtdFvFfhDAHCyF5M35F2uhVxYqBylJ+1pncWSzCjwZGSgbNLHaEwpOBSkH2FYi/GDw+Xh4aUq/b/UP/Szkad3W3oDp7+21uHvfTX3tTZiwFWqIDJtDBvwvkJwf9P5c0bTxZguy9dKppH/cGbbBPZ4oWbXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYyDFekzLIqcLS5hE6WmsrdKVpQx2qpGgE0ntVOq7ro=;
 b=IcMl0todfaLct5Sgzitn6Qo0FakGbczugWOL7FLVgct9NqwzS9gi2DjZ1spM5Rg7eeHslp6ksowxrdglFqLkTOpQ2T1Ho9Wg3KTHWH/mKyt/QSf71ldZZ55lP/ERp78OQplbBZkf8ns14ZImeghyTitea/Ag0k9cDzWQ//LQc0oDhjYS+2DYswJk7MOL/wfqMw2yJBZMTsE5SM8QqOkFcfL71TfWlOCfBxZA1Phb0oDgk41ShrT0gcGhXCKXj5nwUvTyrGXsYH9hzM6eKWK3vAYS5YtuK0WIl76N7vYi+e7Ku4f7Gv/0Bc0+kEjOD6d5cYLpAC6f+z8BHcfgGADj5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYyDFekzLIqcLS5hE6WmsrdKVpQx2qpGgE0ntVOq7ro=;
 b=FQKmVcab0uWu/sw+BFra+GyNdrW6Yswom0YE0KSFcG5VqRKc1EB2vqzt4nhW/ufdecUiX/itjCC6rNIM3T0wJmz2zljf1DqhhOsKsCXevutPXrydVqoj0ElgoQOIy/OIGTOEjI6XjFzap6GUSdurDaKtgePJ+YBVl3V0X+U4qUs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2509.namprd10.prod.outlook.com (2603:10b6:805:4c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 14:51:28 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 14:51:28 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     Randy Dunlap <rdunlap@infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
Thread-Topic: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
Thread-Index: AQHXNQrZqRHpkmbuhES26la6rL5ce6q8BWKAgAFUW4CAACV0AA==
Date:   Tue, 20 Apr 2021 14:51:27 +0000
Message-ID: <83B4512E-17ED-4061-B27E-B2EE71E772CC@oracle.com>
References: <20210419100014.47144-1-dwagner@suse.de>
 <cb00b188-31bf-d943-8f82-31c8c966c728@infradead.org>
 <20210420123723.bregf4debvyincpo@beryllium.lan>
In-Reply-To: <20210420123723.bregf4debvyincpo@beryllium.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3503b4d9-12cf-442a-84bf-08d9040bc70b
x-ms-traffictypediagnostic: SN6PR10MB2509:
x-microsoft-antispam-prvs: <SN6PR10MB25099A3589904B678D8B559AE6489@SN6PR10MB2509.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nyxhl3P8LucAhi8ka7GeDg/gQ1hdQ9ZHhLDptOlg6Xpx6FpQ/vWk4QyrS8HsBRtn5aU6wLNZLuqEkqNGSI1XF5Vzxzhpve7DDHfTw5jIxtWKeaFce8bHwEPBnfmeeRMOas4LQcUdn11iVIu8in1wEc4KoW6b8dm5k6ZGiaQyhcE6vAKgrpdcL4YLGZSdnvTPOBN/7iS/mPMFPlNlP1XRGSHEAgCP3dXxKzF91D9A0OQE5lSM2+gWNAYtFzBvlWtUYDaTml2pkz7V1MPApC8XGUxnhnJGff4lvRiN8ThGPVDoOk+/GDc+YwP2jBHX8D8f4/k1XyUun7T3R5mAHAF/ypdSF37RDp/gE+90RTrOJ8Y3oiW9lOU/WMAqfZBKw/l4+0UhYJ+4jC/3ae4jv1NwY89zimRN54qsbHLhDIVlnfTRJJUetB2hkHNoMJH6GQ4Sok46CRsO3mE5ZSxNRoV2WmS8oFz/JnUJraof1JSCiFWN4OHT6OVqa7LeQpnOGTWpXRnmbTnvzidCBbRFTBR+Xv5BiFUKj0p3oKUi+4fu1SMUfZfhIDNd415EoRboI85wxutK5GrO/JTZa46wWH8L+4tDWdUP5xk8auaVRubR5LbMemp+cENll8b3xUHdpXqksqIvMyPPg89Z8gWM1m05518Js1o+2ZYrzcunPlop6IM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(396003)(346002)(5660300002)(66946007)(66556008)(64756008)(6486002)(6512007)(66446008)(86362001)(122000001)(6506007)(53546011)(8936002)(66476007)(76116006)(8676002)(38100700002)(2906002)(6916009)(316002)(83380400001)(33656002)(26005)(4326008)(44832011)(2616005)(54906003)(186003)(71200400001)(478600001)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9njqYCAeNScQ1H7oc8+CZdAh/vq+FuYRT1ULTDC4BRle4/L326ahBHoxWwsY?=
 =?us-ascii?Q?T5Ewj3WQK5tJ9AEnU0aAATIB7ErZ/P9cKmIyDDR1PtbfaLM+DlBeiW27mDaJ?=
 =?us-ascii?Q?IYChBYyiOknxcfdbEm5fZqkN/RPSKgckkUpb3SuPX8fGqacHo+qdKYkulW+c?=
 =?us-ascii?Q?0w8wsaD+34l0++D0UPzSlNpCZuTpmMetBJ3sU2QtzHnat8Ld/VqPTcXpYANf?=
 =?us-ascii?Q?3QTfOQ/k+NaXTTNhFL9zO1ANzWW3DyrOfYfAbJc5MTji9HfUMYmKDvq5rXVZ?=
 =?us-ascii?Q?Ls58PY44cBkZm/GgNMT2259g+AWuQAxzaW3ydKrpAFS3bfuknH2wgUxZc6JL?=
 =?us-ascii?Q?8bUTml2jZnFn4KyfNfca8lOjWgy+utut//MYwo/Iw5NC731ZDMzuYIBKi8Ka?=
 =?us-ascii?Q?Fs5D9Mv35AOlkQYt7i048Gccrq99sv7a63VSgBLQr/H+jK30YEQmgZj01kYi?=
 =?us-ascii?Q?bXPiu+LLVDjFmujF7r74eFJIZz1ydA/3cfpxAsWh5m9xsJ+OZCAtZfA/pxUQ?=
 =?us-ascii?Q?CLfFJxwf7FzftZwFDoDbrlS2g9eZ47+sUJl9tfKAwrO1c5gbUw6kakEKg7WA?=
 =?us-ascii?Q?b1uCGEZwm9WmxRcGt3QszPF6qbUa7ZpJM3sKhnItAuE/r/t9jZ8QHxKaNzmF?=
 =?us-ascii?Q?6/Jo54FGJUCW3C+mjXGLFFE9CcI7+5YUgE3gcaKY95uvr3f01x5twMdQ/eau?=
 =?us-ascii?Q?Zzy7Xxw5CiIDCD1tCuNYWLQyuDZDTEeTu2y+RNNZfrvKdY+AIAqMAyR+YCOs?=
 =?us-ascii?Q?H4eN/LFe/flWhiBahQkVegFbQxzYiia3eAXHXsZ+zOkuirz8o1KTpj+w5pWI?=
 =?us-ascii?Q?9sEJEYJtM0tmPYjQLq9Yt2urrV09FN18KJLNPxa5QNy6zN4LC0ZYg+QTQqqQ?=
 =?us-ascii?Q?8sVRE1jezuMMQ9ejI32xUSH/pNJ2tU6EkVNutkQ9wEJkeQGqIhVSO/m/2XYA?=
 =?us-ascii?Q?KwXj7jLo6P2dMOqvGRO6GTCpoSvhzhf4IVPEdSZhElNhpdm29P5pRygDbK2t?=
 =?us-ascii?Q?UxFt/jHLkOhclcVDlwNnMno6PT4isaoRfgqgGav3qrFKpC0/DLNDsXhayRdy?=
 =?us-ascii?Q?eE+/iW/xCRRu6Oc7DItmcsjmtSI2hITr45W2grUwZpNWtPqQTCu/H0JcCbNX?=
 =?us-ascii?Q?xJNouOhlh1kH/Q5nBWOvMfqTwkc+67bxLPlGAwGNUr+B0u72xdmvAeC/oHpn?=
 =?us-ascii?Q?zxitnZYd9M6l2Gsht22KivG2Lu1Co1lTPY7OSdaGFhFPp2P9ET40z436Tbdf?=
 =?us-ascii?Q?aHL+uAUjHCq95RU3kWSApGZfKbq8yc5/DmWG8mnmjPrd/YTD9p0ZFGt9vHGU?=
 =?us-ascii?Q?S41rpv06Ce1FLJQGdmfXilEnhiYaNye6nqrRZorybMrPRw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D11744207098342B076F6DCBE672769@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3503b4d9-12cf-442a-84bf-08d9040bc70b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 14:51:27.9070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M8tSW4iHigbNkofb8eWyYPjMKJCfTmQRw35GeajBww8d3jMAZdsV4hOZgCGrZNo/BJVp7h6Pu3ci/KLwBP3rUYjIJJLFwcy1csfklHBkq/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2509
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200111
X-Proofpoint-GUID: sS28a8_eijCpKZil5lR9zXrhwHXlyp1f
X-Proofpoint-ORIG-GUID: sS28a8_eijCpKZil5lR9zXrhwHXlyp1f
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

> On Apr 20, 2021, at 7:37 AM, Daniel Wagner <dwagner@suse.de> wrote:
>=20
> Hi Randy,
>=20
> On Mon, Apr 19, 2021 at 09:19:13AM -0700, Randy Dunlap wrote:
>>> +int ql2xdev_loss_tmo =3D 60;
>>> +module_param(ql2xdev_loss_tmo, int, 0444);
>>> +MODULE_PARM_DESC(ql2xdev_loss_tmo,
>>> +		"Time to wait for device to recover before reporting\n"
>>> +		"an error. Default is 60 seconds\n");
>>=20
>> No need for the \n in the quoted string. Just change it to a space.
>=20
> I just followed the current style in this file. I guess this style
> question is up to the maintainers to decide what they want.
>=20
> Thanks,
> Daniel
>=20

Some of the instance in the file needed \n for readability of Module option=
s. In this particular instance,=20
I would rather move \n so that the message is displayed on same line and de=
fault option on second line

Something like following

>>> "Time to wait for device to recover before reporting an error.\n"
>>> "Default is 60 seconds\n");

With the change mentioned above I am ok with this patch. You can add my R-B=
 when you send official patch.=20

--
Himanshu Madhani	 Oracle Linux Engineering

