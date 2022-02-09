Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D042C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbiBISlf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240243AbiBISkq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:40:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB11C03CA4E
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:40:15 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HIpsn017445;
        Wed, 9 Feb 2022 18:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ELKhKCze6xIYR0VXyblMldZEVa7kaJ8AZrScC8XFfS8=;
 b=WX4ekYNDAR9EbPHqqrX6Cz1rzoIMjaoxJ0zdqi4dJ2rokDEFzEdCZCpOtPqoQx+iLbXN
 pOFRNAEuCFfDl4COfB6y7HdMt894+fgXNbbA0mSUZgNf/18cbl77CDRX+iIVySflBQyj
 ePd0d1dEyjvSiF0fFq9AzG7rIl+xWtrxxYHjB+fuFSxaiu22BusRnCpsf/kcGsQ/gOPq
 WfX4Veks1TXdXF0M/2wg7oqhxhwelDpzYZDLF4J+JRbEIktLFs/qMNlwuxcU35Tb8qHQ
 U4Wz22qDZ0EFYt12m30AvBrJQNxYdU9BIZDIfWEzJKPMmuG3ZzEAfXqIFtJuBL+K+oZW JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28ndga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:40:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IPq5g116862;
        Wed, 9 Feb 2022 18:39:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 3e1ec36j2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:39:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fttd/BuG5TIVgYUtLx5GRN82zrYNgcVAQjiAPzNmn/P+Mx9fn0KXkgvvyxJL8HzjqnBKu1j0cZSRRpDulTHL4bbDaQW/gVyxuqvbYiDy0CL081/Ujygb8Nh8jcv3R+i9qaRqroJy3Zuve+UBXMF+aBXM1+Y3yw6gGCWDPR228YWTIcuIQJq7dcnMrJFdwWaGXfBSS3MnDSTJPY0/nPgvmgcjef5USYQ1p6QS2KzkjybwmTHCPPn8JIGeBqfgM0lOtaLpoWMrIHDIAun2/A+/RBnVW6PSFkAXBX3a82W3zQK6gEdA48VU6YIAtOEUuZ3/30cgEmdtRkv3+FhZ4zYykA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ELKhKCze6xIYR0VXyblMldZEVa7kaJ8AZrScC8XFfS8=;
 b=akj3H7SzBM8HliRgCdcSJW2tu78uJQPbB4JQpVr7uHEUrdGAgRGMPh8X5EntWmpzEAE7YCSpK8zOov+RtfLtewBxge67XL8GhOOIaLlPmNjX5H8mpoWiK0FJk8qaRicnBKRIQxP2y+hBK3oY3oQJAJqpp0ZNm0u5OCLwQDfUrlJRq3ixzfye8xNkQD7WSKqP9UHCqb7cak+1RMFQC5ZennvRd1pus+PsOUx5HTzyvNgEIiDUeK3a/L6bLDAtPQErulHTuTzfh5teeTZ4NM9+gtyOJeamM7XTExV2xG3a/X9MiXsTtmyatKU1r3qJj1o95XaMBlYqDc81Q4pcCYjRxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELKhKCze6xIYR0VXyblMldZEVa7kaJ8AZrScC8XFfS8=;
 b=ZMUp54kHQKMXZtX6QRMhOaL1OE7F02EiPu4A5dRpidD6TZS+kA9vimS20smJPDLA1aa/YMRnnPVxkgJ8TM6gPDnj1LUKikqp8sMB/0wnlQ4V7m2+mCzzaSxMvN2qytZKTV9Rsu6UyJl919rEokWP/8d+vNAQnRSoOImcj9OI4zQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB5246.namprd10.prod.outlook.com (2603:10b6:5:3aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 18:39:53 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:39:53 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 27/44] megaraid: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 27/44] megaraid: Stop using the SCSI pointer
Thread-Index: AQHYHREzZYY0T9QAZkOiM/jgoqNGtqyLjrYA
Date:   Wed, 9 Feb 2022 18:39:53 +0000
Message-ID: <9B858D2A-E78E-44EC-9F9D-A454D563B87D@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-28-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-28-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95f16277-3ad0-4653-6480-08d9ebfb8ff6
x-ms-traffictypediagnostic: DS7PR10MB5246:EE_
x-microsoft-antispam-prvs: <DS7PR10MB5246F17551877319D0795C8BE62E9@DS7PR10MB5246.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a6XUc6x9A5OOEwBhjo/f4WzuZ6EhSaascYpzMUuoUZ13OHA5TlAqjeVdPaMH0Kjnq1aak+8Rg5MTThIwiRfjEacLD7rjXQFWc8X4PAOkOmPpwCHD1APBHPB/MXhgsOtm6dvL1OEeapRl33mWfnnSWhWx1k+h7F/zsuNAKGtLlrVqsTxv52lCVJ2IxKpc6bpB8r3wkEVUHOFq9sBM/o8YlNofEV9sMv0gQ11H5786Gass3Val/hyByTmVmXTNaVQhJrAPb3XpiO7Eg4nvVFQFy4RsYZzuBV/N2C1uKMDH3OCv1+eP10bzfgxI6O1DkV9DMh7vHed/WaU3RbFXXgcCQ+aDuYUqnS4XWt9O7I+bxwr935k7W/oXfJ9UAg6cE7BVyXbI5Xm5uIfxSfPCzF6wJCBC6h61QDGK8WAWevzHNgTSzqzJBQzd01pExRWglXJF0TNYKOhpRLJEU3G9T1ZXwlyfCGAwHXaYI4yrF+GWmMIavrohzyHe1nyfOERF8iD9MnI1Gc1GIhgYpjLSby9U12XV7f6JmJ+Rq9psAV77PZE3AmcaSYNwzYylQx1NXdYhLINoJNHbUB4W4MtOmbTJm1K51IGfjjHNP6Nd6H6Yn+yIGPmed0VHs+6QJMpXyWYkpexVatV1+o5PFz9EXrYpRbq0vvy2/cGPioSLFleJMJJryEv1KXQCoJVTdSZJlWb3zEo4kP4VaRFbZiW+r/xDgjhrkhiKlZnS0XEjJ2zLhef2jQj19Y7zmw/2gpGsE76e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(33656002)(6506007)(6916009)(6512007)(2616005)(508600001)(6486002)(66476007)(66946007)(76116006)(54906003)(5660300002)(36756003)(91956017)(122000001)(8936002)(38100700002)(64756008)(8676002)(4326008)(66556008)(66446008)(83380400001)(44832011)(71200400001)(2906002)(86362001)(316002)(186003)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mz7XI2C3Zx0+aNrdoZk1EpV3DeJpvecAyNIpMYUoOg15cgeGVA6L8+qJC+aO?=
 =?us-ascii?Q?HssI+uJ7TP9HkYZ8jXcIz5dQC4B4QJC09VExvd3c5lwn8twS9Xfxb4cKmkl9?=
 =?us-ascii?Q?I3/oqIhsv19HH3kXXnsWL/nMQ7Ashza1wOeJlVl7Ofg+rcm1M/qEMGAx+SIo?=
 =?us-ascii?Q?dLIP7vhbhAsoH6rfXMtKokkOtoAHwO01p/OtuFG47tDhdoWAI9ps44mZeWrj?=
 =?us-ascii?Q?WABG78P0AFEjhzNknetM9eDbTwYfcPSVh+it9GJbwsFS+06uTWxlQY/p0QJA?=
 =?us-ascii?Q?SGZUkMkPd33WYUEw3a4Aea2NKKcqxDARj9v+mzHj1oucfp3D4ONWE+g1HWq+?=
 =?us-ascii?Q?V0CbMOpJqj4YlQwh9vkQP0AVMaUmhbw+J/F/Xytv1gB1htuhpFVW2sRk/w6k?=
 =?us-ascii?Q?4/e3/U+FcuDKf08bOKPqUZI02kZOdhSglRbJo07CCBuJy9FVukafeCGlbF4N?=
 =?us-ascii?Q?/B0wHi6Yia9ZBOfudLfnEmyu/XhCDFUrjkLYG8E4Np5XumgOp8hbqzRSQSga?=
 =?us-ascii?Q?P66TOlNw6C0oKMwrlayg97fvz3P0BhF5LoBSdNeqhf/wQVVCmvJ9BFWVC+64?=
 =?us-ascii?Q?5R56ZH77HWUgbxLfUZ2ehiUz/8d+mwFKbO5s2Jw1KfhA4kjZXEX2WQ8g0/xP?=
 =?us-ascii?Q?vtuRxLNuqKWlMvJCzM5PY7p4NMuurPDVc+ZfH3F1XcUdGbIU5ElgiDfhCsJn?=
 =?us-ascii?Q?n0UJv0iK8a3nW3KOOS10bGf6NJAZhwTgkMRUox9pvoAYJAKaefzFdCOj8L3W?=
 =?us-ascii?Q?PBnSAt3waLoiTcq9PY/ORHuyrWM1lC5tA/o1jldNAOjollf2SwKJfhTCgtAe?=
 =?us-ascii?Q?pqEe2PNDnzD9RAhpuM/mcAr211OyHuEvwHy98y9KJKoEe7Nv3R/OvpfO+fO4?=
 =?us-ascii?Q?i6VJAh27Yqpx3gDoYhXQFrYwonRy2ls3LXK4BblvtSzIxorBNNqQUZPM5fGK?=
 =?us-ascii?Q?gvvloSFKxEHElfMpqMtmxQbpAUUgn3Twoi7uz/OULfKUBgR4yL20PBMjIBoo?=
 =?us-ascii?Q?gJ5vKxZ4N31m3dKHtyAVaWNKpVKrfYCgAGkAlLfqhlm/CKCsrsrhgNs92m83?=
 =?us-ascii?Q?Ojs3bMj23C8l/1xmnVaAl4qSakgILDnKfRFIDw41Gh8JCUh203J+XT8czLv7?=
 =?us-ascii?Q?VCZeybidYySGlX5fAv6Idnpcisojsgt1SGAuIH+yVkzYlVz3+RoPyVfkpqnO?=
 =?us-ascii?Q?XyY2aL7bpyoXz2lR17CZ+Fa/K7TCvWF1tyASqFy+sPOGJmuHinJGfoQ6o/ra?=
 =?us-ascii?Q?68BQLcoYjKVvEVv90mF8/sqfigk7UP9behkQTfx4NUQK9xK+Xc5FmLho1HcG?=
 =?us-ascii?Q?bEJgecT2qHmru2XdfYupEUo6z2JvaYkJHRHiYDULO890KVOiU4xK9dwgt4gs?=
 =?us-ascii?Q?W5dIrcgQgFzjtO2YvSv7Aa0tQ7c7IWqej7qunwOJNND3QKR1DLTEf3ENK9o5?=
 =?us-ascii?Q?mf5wEv+ko+7OZdu6hq1uqyz5rcDMHonyJVhWjLZJvMq8vFJ2XedcAK64+vaV?=
 =?us-ascii?Q?8FPlPaV5SrNNbgCEwDdb9fsIvP+yGCLzUlyScRoJDEgghi1fevyDc1KlTC0l?=
 =?us-ascii?Q?0e2xsbwc5s6IFmn1ESPSAUi0JemuUCenslsta4eyJ2pXPnHKHz+HIMJ74UtK?=
 =?us-ascii?Q?Rv2ka4K6+LlsBIaAPS9AS1WpnjvtnrpyjCmfdfgtDqVTMcyrMPqKXlUZV8+x?=
 =?us-ascii?Q?WnwGEI9Qlx41FKaN55OD9S4Z5RjT+RGXAQ1dVtLFfxR8QihK?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <04DABEC20374BE488D51FDD32AF74B91@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f16277-3ad0-4653-6480-08d9ebfb8ff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:39:53.3462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z1eAD/yJarXvIBJu4hun//R6JL+6CyKdaMVhmNz7Z02AU9Buwoh7pBdt/XpL8DpqPIUotdjsdnxoHYSs71Oc/O/teQkH3v3UmzytT8012Ug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5246
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-ORIG-GUID: h6pHlFf5Myl-H3fWRGn68_Ng3iMph_91
X-Proofpoint-GUID: h6pHlFf5Myl-H3fWRGn68_Ng3iMph_91
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/megaraid.c | 13 ++++---------
> drivers/scsi/megaraid.h | 15 ++++++++++++++-
> 2 files changed, 18 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 2061e3fe9824..a5d8cee2d510 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -1644,16 +1644,10 @@ mega_cmd_done(adapter_t *adapter, u8 completed[],=
 int nstatus, int status)
> static void
> mega_rundoneq (adapter_t *adapter)
> {
> -	struct scsi_cmnd *cmd;
> -	struct list_head *pos;
> +	struct megaraid_cmd_priv *cmd_priv;
>=20
> -	list_for_each(pos, &adapter->completed_list) {
> -
> -		struct scsi_pointer* spos =3D (struct scsi_pointer *)pos;
> -
> -		cmd =3D list_entry(spos, struct scsi_cmnd, SCp);
> -		scsi_done(cmd);
> -	}
> +	list_for_each_entry(cmd_priv, &adapter->completed_list, entry)
> +		scsi_done(megaraid_to_scsi_cmd(cmd_priv));
>=20
> 	INIT_LIST_HEAD(&adapter->completed_list);
> }
> @@ -4123,6 +4117,7 @@ static struct scsi_host_template megaraid_template =
=3D {
> 	.eh_bus_reset_handler		=3D megaraid_reset,
> 	.eh_host_reset_handler		=3D megaraid_reset,
> 	.no_write_same			=3D 1,
> +	.cmd_size			=3D sizeof(struct megaraid_cmd_priv),
> };
>=20
> static int
> diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> index cce23a086fbe..be809ccb757e 100644
> --- a/drivers/scsi/megaraid.h
> +++ b/drivers/scsi/megaraid.h
> @@ -4,6 +4,7 @@
>=20
> #include <linux/spinlock.h>
> #include <linux/mutex.h>
> +#include <scsi/scsi_cmnd.h>
>=20
> #define MEGARAID_VERSION	\
> 	"v2.00.4 (Release Date: Thu Feb 9 08:51:30 EST 2006)\n"
> @@ -756,8 +757,20 @@ struct private_bios_data {
> #define CACHED_IO		0
> #define DIRECT_IO		1
>=20
> +struct megaraid_cmd_priv {
> +	struct list_head entry;
> +};
> +
> +#define SCSI_LIST(scp)							\
> +	(&((struct megaraid_cmd_priv *)scsi_cmd_priv(scp))->entry)
> +
> +static inline struct scsi_cmnd *
> +megaraid_to_scsi_cmd(struct megaraid_cmd_priv *cmd_priv)
> +{
> +	struct scsi_cmnd *cmd =3D (void *)cmd_priv;
>=20
> -#define SCSI_LIST(scp) ((struct list_head *)(&(scp)->SCp))
> +	return cmd - 1;
> +}
>=20
> /*
>  * Each controller's soft state

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

