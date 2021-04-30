Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A89C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 19:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B1661400
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 19:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhD3TiZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 15:38:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59614 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhD3TiZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2021 15:38:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UJYx2G136454;
        Fri, 30 Apr 2021 19:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8qMv10SYb+fZ5+uVVr27jLd1wUi+D42j8N85R1oZImw=;
 b=tzeeW78tZkKR2+JtFhjN7MbWm2MtPLWwAnh47lT31kl7geJBUf0hu8mHuZk/VZX63tJu
 nLxMQPoz0BQfxvpqAhsTvc72/43bGktWKTP7X0vOa55U0J8NfGxo7DJXPeIqZyJwEClz
 AhgLKBxMgv4yNO+6sslcVap977L2TE/ULwr+E2Mp8aNG9dmH6OIaGmicya1KFrA2Pph1
 wRiurQ/aFyPPj0deHVfRO7wGZ1Wgrl1WmesLy4cB2Nd9Qb4aP0X9b3X3thnfRVfv1FuI
 89gHz/yVPjJ9aebZq1AxbIfjHE03vdUCWJ04eV/elV89DIRAKLEvX8C9TR4olcuIRaki Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 385afq8u56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 19:37:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UJZ0XS144396;
        Fri, 30 Apr 2021 19:37:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3030.oracle.com with ESMTP id 3874d5bdqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 19:37:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b780KYDVYLmXQ7n0hKZkoDbX5TDMPOxq1fQ16iDsgfcBOt64RKIaHsJ2yFS9CTlMZg28RXQj6eI4f1kFYrOLY9ewKrqkQQtXYFYHymoXnuKZz196pYzcxJ+jL4hi3Zf+4/vLZehk0ionHhRBWs+oOBz5ofwl8b+CFjT2aT7fF+49ehHPXpzfq+BH4OSZaokeJXzhdLH32SulIKkYmtDpIRiksg2N7j7FlCxGqK57NGb/8oQy9MG4YMxbwkzbyxEO0c0uoshjscnR2AHtMNxltboIq18yVIg9+QzUoj19sorRhSC0sgiEyXUl0gMWxbxc9s1cJW9F+Hu+fHATBR0W4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qMv10SYb+fZ5+uVVr27jLd1wUi+D42j8N85R1oZImw=;
 b=fzMKpO1wRuojCrYXY42Lgp+1tlUL4lm+HsQmJJLYeoOuuqrPO/0cPJq6t7r7JVShQAxCWtOE4wAxBYnAIAN0WU4UHBcKmCUNmnwJtD17eEswgAXXsoqIGKWvfsfb2weXe4903IsVL3sdR4Y4QHwb02dMZ4OLuoTqp8PTjItfIAYa/qAY/K0+lVcoAUxGcw7LImvTt3U8g0/iRaj8rCbc3nxkHBeuLqcF1s8xioCjW+2C2VSxloVSACbetqUsMdFRnawyaPezr6d6loq4RUKO+j7NiX9irSQN+juaSO7eXLa9V+o8fRoBaSIA7+J+gzRZqaYMAWwQ803lgm5rsYK2bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qMv10SYb+fZ5+uVVr27jLd1wUi+D42j8N85R1oZImw=;
 b=nvuYlbV1MfolmTcyY6cf3yO/NNL1fJKC1AfjB1+k+XREF6QPrl0ydVrQ0v1q//Z0RAEMIUuz48sRqvX7Tr+K2A1QYQSDPXo8xoq/4GKtv6CJFBJWEHXm8R9ZfOBpzMbKiVVerdkEbEH6F0suRZRexuBydXXC46e0u0W/fIguSzU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 30 Apr
 2021 19:37:22 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 19:37:22 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Muneendra <muneendra.kumar@broadcom.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "hare@suse.de" <hare@suse.de>,
        "jsmart2021@gmail.com" <jsmart2021@gmail.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [PATCH v10 02/13] blkcg: Added a app identifier support for blkcg
Thread-Topic: [PATCH v10 02/13] blkcg: Added a app identifier support for
 blkcg
Thread-Index: AQHXO/BT/v4la0A70EOp0sARaekkC6rNeJkA
Date:   Fri, 30 Apr 2021 19:37:22 +0000
Message-ID: <CBEAFB03-2B54-4251-8168-02BC31020217@oracle.com>
References: <1619562897-14062-1-git-send-email-muneendra.kumar@broadcom.com>
 <1619562897-14062-3-git-send-email-muneendra.kumar@broadcom.com>
In-Reply-To: <1619562897-14062-3-git-send-email-muneendra.kumar@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24e4715c-6a3c-49f4-664a-08d90c0f5ffb
x-ms-traffictypediagnostic: SN6PR10MB2701:
x-microsoft-antispam-prvs: <SN6PR10MB2701DFEB95A85585E81CA175E65E9@SN6PR10MB2701.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w/Jx/HHovAie1uSxl1/+fShyanzBm0WHmZ3Oo8CSs7pZFUKLaqbROcCzGBkeRFBigqBxf0Kulp3j7lpMzuX8nyvBuU91FtlxpF7I6tx5lgIMnxoC7ZhJBkrbh8hOHeWkrtRkvWVWyOgSwF1KCw+YkTAAjKhJyW89mXmWp3AZiY8zeqZqH7IWrh6PgZN9krcbIaRdAeYGYHBmWkfIBfqfjOkZ5TYqQtzvm7ejOB73PB8YqYARtlewbTGIdCsrvDEq46MFPLljIKN2h4DyztG3t3gkFgsOjQgvS8jw+X9FVDX/dAfD1cRM7YCjpDwRaPNNsEE0+xhILhciYnR2VyzWLd6Iu10hRWWvSFdVBxOhfa/2IyU+EYuuDJj1sTBw8zDP3oH+2MQ0e36/m9/fditoJYEaF3GnrxD4+KI8oOtlzyuLkOpfXiFkOPDXuQH4jGvmsxMR/66ZPEzbrrpDaEu2GA/UaF29R7Q/LUEWu7vvXCBSLHA0zX3FhMwP+XULLSMG5SWwQFbm7YD7LooXepy5YTQnfZkgkCsWunN2OS6B8NwTkzWKfQS31JvApcd87AAmNNYuuRRW0qg9VT9wGMbN2LiMnD4dOxvoNyjP/onI/e7caVSbmW5ESftX6E+u7bGRDGl/Ip3ogbqU5yb/75UYARTpNtDZvVKNdhTMEDFmTomCN9AVGR6wO1FfBzofqrUo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(366004)(136003)(376002)(83380400001)(6486002)(86362001)(33656002)(71200400001)(122000001)(53546011)(36756003)(6506007)(4326008)(66556008)(478600001)(44832011)(5660300002)(8676002)(6916009)(316002)(26005)(64756008)(186003)(76116006)(8936002)(2906002)(2616005)(6512007)(66476007)(38100700002)(54906003)(66946007)(66446008)(17423001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VlSnnlK+Q/td+sB+zyKhMWFhkkrXJyp9B+LThhazI6WaTeRl22HLQ2tsKZ15?=
 =?us-ascii?Q?cyir9/H1PO812qswE7Lf2gvEjQTRJe4ye+OmG55CfmkGJpy/hbN1uJRJXiq5?=
 =?us-ascii?Q?K5+S4Mkw2Mr7kvrt/7Z1QPHKcvsJVP9aREtYuTckQypiFS2Plf7QddDBSHmn?=
 =?us-ascii?Q?RaeqR+1bzfNBMgGceN22ipf8BAJbYu9Dc8R+kSl4Q83YCWpx6OuufAs2u5F0?=
 =?us-ascii?Q?L8nIycAbxxCTX4GYmLWEI0f9TrZdpzN58r/mubqkQ5Y0F1GOEZABlcC773qK?=
 =?us-ascii?Q?NUmEHal4YyLmHY5SYX/RGJxP8l2cexQ5S7ZYZV02qerKITTXF2mG0SxWUyN7?=
 =?us-ascii?Q?/yNQS5NSXjcLQcY39CU/29DUNjwwy7LuqTwDevN3wJUNBKZLGssNLvlTgLm5?=
 =?us-ascii?Q?D3AZDMU+v1vopHkA/La14Etdtzs7zb34D6Q3F8jlKxWRTsKD8gegJkli0mZ9?=
 =?us-ascii?Q?kUwZ71zwQnisBmSzZFP5hei5a0rrgNRXSNGj93HS5Fr47wMtkn/OHfxdgp0A?=
 =?us-ascii?Q?6xGTERg7SZY2hgEcXaEsi0pLtxxG0cAMpp0rCLiFE7HA9kHTdAF73+UfWUw2?=
 =?us-ascii?Q?zEbaNkS5w6sR3ihzQ7OEdJ8pI2LFwgDEgWz4x0zT015X/TZDpAoyCpivcmPO?=
 =?us-ascii?Q?DF8ip6dJN8KAboAyIT23dPOmvssVKGnr8S7TSFTsz6banlXYyDdu8orZj3Yl?=
 =?us-ascii?Q?7zXdZhU/Ild+nDutaJUA9gLMOq3UmiBvejSpTgMltv9GcR09cHBRQd8vA5Vw?=
 =?us-ascii?Q?C7VWJnHTN4fejZToEvjeSh/pX9T2QWdRAUwklBtdyT3RVqfU5HOHQAgriErQ?=
 =?us-ascii?Q?ikgeZdSm6mxWBeLGCBtNCcbg6TVxvekb/kCpe+WoLAituiVY2Zgld7Z1Yi1i?=
 =?us-ascii?Q?Ay4TSfrGr/qY1sTvnn+kbf2mKsrbxcqxB4ZeacGd20m/QLXde7TKE9MTXOIL?=
 =?us-ascii?Q?cKJYgMfpDzcKVTcvdWFk83nebIsD5fY+F0P6R269nKBzQV1TIc0qU2vCxFXV?=
 =?us-ascii?Q?ZYnD7HNuRlaE0g5fOQVLeeXuEs2AXrsLrxGb6PRdALaM5lp6q284lcnP+ErK?=
 =?us-ascii?Q?5BlpfVyrdgZXzYYTv+KWwjkHJkG/JyHP48zflbGoa6vT3OSPJfcsibIOTvJr?=
 =?us-ascii?Q?UHHRsqpBdrUJB/V0+m7UQtsQGE/QevmFhZjKBCeSdW+HmkSRgkK09uA5PecK?=
 =?us-ascii?Q?ZgmIXImtq/jUhwXK1YwTalStq3bBW+dsPVpRfoDrgGN8cIDSBGPxzj6s0nh2?=
 =?us-ascii?Q?bhzfLUXqhz0ne6Ngdk/jB0Q2KeGiTWG0rUaAx0uQvetFJm/mnYqYFWpyyQ7l?=
 =?us-ascii?Q?o01FfV9LZxpu/6X4aKaXVukBciBdiXfjDbgPdXHbz80GRA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DEC45037BA451F4DBA7F7A86F2E4BC49@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e4715c-6a3c-49f4-664a-08d90c0f5ffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2021 19:37:22.2780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bXUAjNvauUOhUetGE05It1tSAMXr3nFeORe1cgOe0DLXPp5i/NbXzlV+ufHE+CGMU57neF8epRqGondFMcwHp/tcWNE5vb1WtZtpWKkYW60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2701
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300135
X-Proofpoint-ORIG-GUID: yWf23vjh_rDNddeiL6zTqW2Lquli0gKD
X-Proofpoint-GUID: yWf23vjh_rDNddeiL6zTqW2Lquli0gKD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300135
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 27, 2021, at 5:34 PM, Muneendra <muneendra.kumar@broadcom.com> wro=
te:
>=20
> This Patch added a unique application identifier i.e
> fc_app_id  member in blkcg which allows identification of traffic
> sources at an individual cgroup based Applications
> (ex:virtual machine (VM))level in both host and
> fabric infrastructure.
>=20
> Added a new function blkcg_get_fc_appid to
> grab the app identifier associated with a bio.
>=20
> Added a new function blkcg_set_fc_appid to
> set the app identifier in a blkcgrp associated with cgroup id
>=20
> Added a new config BLK_CGROUP_FC_APPID and moved the changes
> under this config
>=20
> Merged the patch 16 of previous version in which we
> added a new config FC_APPID to select BLK_CGROUP_FC_APPID which Enable
> support to track FC io Traffic.
>=20
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
>=20
> ---
> v10:
> No change
>=20
> v9:
> Merged patch16 of previosu version to this patch
> where we are using Kconfig settings
>=20
> v8:
> No change
>=20
> v7:
> Modified the Kconfig file
>=20
> v6:
> Modified the Kconfig file as per standard specified
> in Documentation/process/coding-style.rst
>=20
> v5:
> Renamed the arguments appropriatley
> Renamed APPID_LEN  to FC_APPID_LEN
> Moved the input validation at the begining of the function
> Modified the comments
>=20
> v4:
> No change
>=20
> v3:
> Renamed the functions and app_id to more specific
>=20
> Addressed the reference leaks in blkcg_set_app_identifier
>=20
> Added a new config BLK_CGROUP_FC_APPID and moved the changes
> under this config
>=20
> Added blkcg_get_fc_appid,blkcg_set_fc_appid as inline functions
>=20
> v2:
> renamed app_identifier to app_id
> removed the  sysfs interface blkio.app_identifie under
> ---
> block/Kconfig              |  9 ++++++
> drivers/scsi/Kconfig       | 13 +++++++++
> include/linux/blk-cgroup.h | 56 ++++++++++++++++++++++++++++++++++++++
> 3 files changed, 78 insertions(+)
>=20
> diff --git a/block/Kconfig b/block/Kconfig
> index a2297edfdde8..03886d105301 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -144,6 +144,15 @@ config BLK_CGROUP_IOLATENCY
>=20
> 	Note, this is an experimental interface and could be changed someday.
>=20
> +config BLK_CGROUP_FC_APPID
> +	bool "Enable support to track FC I/O Traffic across cgroup applications=
"
> +	depends on BLK_CGROUP=3Dy
> +	help
> +	  Enabling this option enables the support to track FC I/O traffic acro=
ss
> +	  cgroup applications. It enables the Fabric and the storage targets to
> +	  identify, monitor, and handle FC traffic based on VM tags by insertin=
g
> +	  application specific identification into the FC frame.
> +
> config BLK_CGROUP_IOCOST
> 	bool "Enable support for cost model based cgroup IO controller"
> 	depends on BLK_CGROUP=3Dy
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 06b87c7f6bab..20aa1536a3ba 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -235,6 +235,19 @@ config SCSI_FC_ATTRS
> 	  each attached FiberChannel device to sysfs, say Y.
> 	  Otherwise, say N.
>=20
> +config FC_APPID
> +	bool "Enable support to track FC I/O Traffic"
> +	depends on BLOCK && BLK_CGROUP
> +	depends on SCSI
> +	select BLK_CGROUP_FC_APPID
> +	default y
> +	help
> +	  If you say Y here, it enables the support to track
> +	  FC I/O traffic over fabric. It enables the Fabric and the
> +	  storage targets to identify, monitor, and handle FC traffic
> +	  based on VM tags by inserting application specific
> +	  identification into the FC frame.
> +
> config SCSI_ISCSI_ATTRS
> 	tristate "iSCSI Transport Attributes"
> 	depends on SCSI && NET
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index b9f3c246c3c9..9204f8f8a932 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -30,6 +30,8 @@
>=20
> /* Max limits for throttle policy */
> #define THROTL_IOPS_MAX		UINT_MAX
> +#define FC_APPID_LEN              129
> +
>=20
> #ifdef CONFIG_BLK_CGROUP
>=20
> @@ -55,6 +57,9 @@ struct blkcg {
> 	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
>=20
> 	struct list_head		all_blkcgs_node;
> +#ifdef CONFIG_BLK_CGROUP_FC_APPID
> +	char                            fc_app_id[FC_APPID_LEN];
> +#endif
> #ifdef CONFIG_CGROUP_WRITEBACK
> 	struct list_head		cgwb_list;
> #endif
> @@ -660,4 +665,55 @@ static inline void blk_cgroup_bio_start(struct bio *=
bio) { }
>=20
> #endif	/* CONFIG_BLOCK */
> #endif	/* CONFIG_BLK_CGROUP */
> +
> +#ifdef CONFIG_BLK_CGROUP_FC_APPID
> +/*
> + * Sets the fc_app_id field associted to blkcg
> + * @app_id: application identifier
> + * @cgrp_id: cgroup id
> + * @app_id_len: size of application identifier
> + */
> +static inline int blkcg_set_fc_appid(char *app_id, u64 cgrp_id, size_t a=
pp_id_len)
> +{
> +	struct cgroup *cgrp;
> +	struct cgroup_subsys_state *css;
> +	struct blkcg *blkcg;
> +	int ret  =3D 0;
> +
> +	if (app_id_len > FC_APPID_LEN)
> +		return -EINVAL;
> +
> +	cgrp =3D cgroup_get_from_id(cgrp_id);
> +	if (!cgrp)
> +		return -ENOENT;
> +	css =3D cgroup_get_e_css(cgrp, &io_cgrp_subsys);
> +	if (!css) {
> +		ret =3D -ENOENT;
> +		goto out_cgrp_put;
> +	}
> +	blkcg =3D css_to_blkcg(css);
> +	strlcpy(blkcg->fc_app_id, app_id, app_id_len);
> +	css_put(css);
> +out_cgrp_put:
> +	cgroup_put(cgrp);
> +	return ret;
> +}
> +
> +/**
> + * blkcg_get_fc_appid - get the fc app identifier associated with a bio
> + * @bio: target bio
> + *
> + * On success it returns the fc_app_id on failure it returns NULL
> + */
> +static inline char *blkcg_get_fc_appid(struct bio *bio)
> +{
> +	if (bio && bio->bi_blkg &&
> +		(bio->bi_blkg->blkcg->fc_app_id[0] !=3D '\0'))
> +		return bio->bi_blkg->blkcg->fc_app_id;
> +	return NULL;
> +}
> +#else
> +static inline int blkcg_set_fc_appid(char *buf, u64 id, size_t len) { re=
turn -EINVAL; }
> +static inline char *blkcg_get_fc_appid(struct bio *bio) { return NULL; }
> +#endif /*CONFIG_BLK_CGROUP_FC_APPID*/
> #endif	/* _BLK_CGROUP_H */
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

