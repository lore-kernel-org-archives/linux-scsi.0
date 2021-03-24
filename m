Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556CCC433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D5AF61A09
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhCXQZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:25:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56026 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbhCXQZA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:25:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OGEFQk165229;
        Wed, 24 Mar 2021 16:24:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=caQd0fRXyI9B7FC5Jfv/29nLfXUtVfPa3hUnIdNBKro=;
 b=gKcfT4bD2pbhm38uHfGOIA+HOcJ96xQ9v3p3dd/hxOWu2IKz1QWyxM97RO7PUo0BUsKe
 In5PMYcXcKp5a1uPZ+uQGqzs6smfTu8dCJK4qmxnOLuTNUkAaMwx0P438B3Xsxw5sONE
 9zaJNSKsJDLQX46qPByCUbidYp+1KuQPauLFhzxy8iwyfsNOUq29CQSr5yPe+8BgbOpb
 ppbeotvoy6H5XzubJwqduIlAW/P0/qKRoPDePQVCMVxT/X1LlmDmx7z44WQeLiuSpbvP
 s+wQQAoIW2hOSARWDQ4hlujEIMsQDTDnq2EJIA3mfYF56p+8fTuORWSjCRPfxwdwassh /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pn3b25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:24:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OGGixo026900;
        Wed, 24 Mar 2021 16:24:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3020.oracle.com with ESMTP id 37dty0ss6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:24:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FufsuyVQJGnNg1zx87QHahAWB7+iLxgpnGFBH0zgenD5lh4o0jAv+6oXUTkifPL0WpWx7m8tlOEGhptHrdNWaPZ1+d38su3978Z2P4/yP1NSCmMx5olpckK6pOajjaRKypgLABi18WfBrKnTyGZSBm2sBI1a6N1UmBN/tu3GZ4v93IF7c2qdoMDvtXPLV+oZycBAMdEcx6rSrFcpN9F30zQaLO+qIBwrEsscqcllj+S+pYDkstZMQjDo5I/ARL7Ae2D0gAdNmoQjuitLHKO34qhuFgjNIiJoUDzw6+L6p0ho2VvA6JBuGNXxLW5BTYgkQqvOkNB3BkALqctAwc9H4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caQd0fRXyI9B7FC5Jfv/29nLfXUtVfPa3hUnIdNBKro=;
 b=iAN61SJraVD06nGRG7ppJQf86ibJD14o6x5bD89B8UxBOe8pxy0og96NQWKEsfh8pXD29MkUWbsjuVTr4BPERG21ADl31s5UOpEDCEUqVUKi+k5wG3K6SIvy3w4xHo/Wlpqy8MCIpFX9CjKgxemnf0M6nbr81vMwtLepI3nNQPj3QZfggBhGlVcCMAkqR88Ib4Q+qy14AVJcfpcv8McVLrAlkAT/7Oqm6QEI8Rk2OJEUWt51/v7ReB6HefbsjNwvb3bNQKJ6HbYaB5Dz81/E4FCY5jgICBR6+UYPd0Nls6fvlwkCya+iTbXGvb42aB5VGCi70AUh7usBexAL6YZN3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caQd0fRXyI9B7FC5Jfv/29nLfXUtVfPa3hUnIdNBKro=;
 b=rbkWQFLvwKdS+BIIVe3+CFlJgj3jRYTLAzTnQXbVQ4Ugzk9apqLiwGDGvJi9mRJEYkasq5L+B4VEC3WdgYAZSQTzqXK8NoPPQsNvBsTyveYY//Ph904C8u9WFALre4+IWQzixikwEWbzo5a2l2QgWkm7oSsfyQoDS39siyxLyiM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2862.namprd10.prod.outlook.com (2603:10b6:805:ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Wed, 24 Mar
 2021 16:24:54 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 16:24:54 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 11/11] qla2xxx: Update version to 10.02.00.106-k
Thread-Topic: [PATCH 11/11] qla2xxx: Update version to 10.02.00.106-k
Thread-Index: AQHXH5/TellE+3XMB0KOnU/HuqLeHqqTVTIA
Date:   Wed, 24 Mar 2021 16:24:54 +0000
Message-ID: <72E84A1A-760F-4919-BFFD-7E60DF51E343@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-12-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-12-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d9922e7-20a1-4de7-4a1a-08d8eee15bd7
x-ms-traffictypediagnostic: SN6PR10MB2862:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB286212F332AE3E4D3371DD18E6639@SN6PR10MB2862.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YnVj7XmG2W1n+xga04RASxcsbokLBOiJBqKfJopZAvTHpVa879WATWDV9mZk8Nd5PCpKVlUI+3IEUU2R48o+SlOk4c0cMZI7G3nKAe2khN8gm3hgtjrEATAeCQFGsVC83lnMxtdmUXWWb2YhoOEuL5cBZzta2Ft3sswVvFO6AtfZ8DnQiCrNjYY0ZAJE22g5pwWxIA6KEhpMG9kpnZDhGn7+I09wv6jLLbQ57gbzf/14vdFMmR2C03dgd8HW/8QlMDl0UZK9nU2O4bRNSLqwbgTi2zZzlpQ/jDNCGr+fPcjXXsYn25ypx4oRMI0+Pi6RFyEgXazN/H4nV0e47R3grO730fsyxt/+Wi9nYw0oksXxs8nVIf1LE6JBjaQi+kajOvoKWlAOvInuZLv2k+t+Z1Qvteh9zA7WvDzYJ6CAxvvFf6zeZ23OsP4s+7xMeEL/3HvF4muVs24rT6/abh4KjeL3S3+qEHVWPOdt/F9hBayOa0HGMudm0cgEV74224Eq5F39toyDKe5q/dzDp9aH1+wKX8AOtXmtNam4TptXyHlJ7eEEu0F8vGfS4yRJNEBlWjOdvH5AEMubNOILCeR66B0K/BluLQGIAfunsQi9KLcSycZs70gxxhgXf/BWjeipgPiuEbotuK+43H6uGVEKwJt4PcOregYvP9XzOJosasjDoL38yO4z1dSyj1xWR55r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(8936002)(66946007)(71200400001)(86362001)(83380400001)(66476007)(64756008)(6512007)(33656002)(2906002)(36756003)(8676002)(4744005)(66556008)(5660300002)(76116006)(66446008)(478600001)(6506007)(44832011)(2616005)(6486002)(38100700001)(4326008)(186003)(6916009)(53546011)(316002)(54906003)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9Esi//mfv2Ijv+OHDX9Vt8BfmVNFHme15O//MZx7b/N5959AMMAk92WYq/bs?=
 =?us-ascii?Q?VHnVhnczu36UysTv3OJ0YS8X21zjmboeAXO5yxtqj0/M0GNygSg/6+oCALLe?=
 =?us-ascii?Q?Rjbpqh7WfmZuKa5239QUyznlEXjdJw6rf3aV6HZNX89iwIk9SiRQdIqYTDei?=
 =?us-ascii?Q?95UAQk0WBjFb+qTRAtwtSzxrFV6V6n1v24i3U6TSNod9gFRRan3NDqFnDjbf?=
 =?us-ascii?Q?zBrVMf/QOjdB07PlnrICOPX9wzmpWIn9SdjG7Bkmsc2iSeDo9cA0v8digESZ?=
 =?us-ascii?Q?CV1QKpM06/6obQX5QuSY58bDeDLYMKko7TIU3EvBNQMfEz2YKjxb5Xm0UFxI?=
 =?us-ascii?Q?qqzn0jNN3LyB6A9iZ9fbVySfAe04EEAUPgPlqU4Kg4uvuYEeA9wcpDs7kZOq?=
 =?us-ascii?Q?6GPltTTUD8V9JSgy+GZKnzjaz8VO9/sW1m0SJNUn89lxyYJ8qooLUJBjPmeE?=
 =?us-ascii?Q?Y1We1WFahf8bZUkac1mfAlyKUsIIdDhG0Eli29nLthkK3YNUpp0D+6L3XaVe?=
 =?us-ascii?Q?fFUe0NQ4xqTGIDqB9z5Or2/F8mC+W3KezMbLvDS+YqnH4PTpI/xApgO1vqtX?=
 =?us-ascii?Q?htUnndUNGPLBw6O2t6rbASV2e69UHV1qvJN40AhJf58No6afbyghYyBjPc0r?=
 =?us-ascii?Q?eCyYrqPaXGv2XnzBrkigeFrZbIepu2IxXbEpILjyuCbc5vzufsF8AhAKuj5n?=
 =?us-ascii?Q?aonniygRp2JGDUahTdIDBUwrJhjJ1lHc0ZUiPqdnBAYqsOufmI1Ca8qusuQC?=
 =?us-ascii?Q?vIwlAJp1FcLgky5WaEmtqr/YWhmSuUMVxpeEVCTzb8cHcRGd4adkp94pQbAl?=
 =?us-ascii?Q?zkSrA8V8p38qXZ2Wjg+/D51e1xW/I+zFmR1+lmgyTDNlwtU5fVcs4rUye25l?=
 =?us-ascii?Q?BLwbktCIebX09TKmfMP1YI/SAtiVcWps6GZgs7QofJKOexQgfLDHZwQGyigk?=
 =?us-ascii?Q?N0HpHceDC7+QOYTJryoXAZ5kdmUP9KX4C5IyRx0btfdbtEPWbmsxeVwEPbow?=
 =?us-ascii?Q?/SrK6KN2PMI3DAP5jhluBVfIBJVH85r1r9nrcScQdBz0J53sZ1ft/WhKTQjA?=
 =?us-ascii?Q?GCmsg8pnphS7Jrso7RAtxtKdh0Q0SsqP2a4FxCz15p7+he2FWMi/302k08b6?=
 =?us-ascii?Q?bN8bMhxmcVmtv8Pmo+sJj/3Rcz4Crvkr0ztI6KDCT2wSQb/J10zl5dIdYg4A?=
 =?us-ascii?Q?p1LVzNO1roxNdBIZ8Y8PtBSlTKRysCAnAQ+dp2QDZXLj8hM3JImhrRIrHbLu?=
 =?us-ascii?Q?weAKWcoKNkqrmnL245/+krO1/QHZ38WVR6yka1e6Tem4wSwnElpjqnPUujFK?=
 =?us-ascii?Q?/Kiotgd1X+P1+xrp5uTYuzJ9?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29B7DA8CDEDE0647A2C05FE748705677@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9922e7-20a1-4de7-4a1a-08d8eee15bd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 16:24:54.8003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4wkZBW635+8HPZFHfXDT6a0CpzD1Xe73/GLYcUgR2bWh1wGpd/4OPhspp9KZZm2970fmeUC3doV4S+rkLQlePqnwb3ReM8XGFp4WGBhpgGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2862
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 72c648442e8d..da11829fa12d 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.00.105-k"
> +#define QLA2XXX_VERSION      "10.02.00.106-k"
>=20
> #define QLA_DRIVER_MAJOR_VER	10
> #define QLA_DRIVER_MINOR_VER	2
> #define QLA_DRIVER_PATCH_VER	0
> -#define QLA_DRIVER_BETA_VER	105
> +#define QLA_DRIVER_BETA_VER	106
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

