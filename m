Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39DFC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8433261417
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245648AbhDUUgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:36:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33320 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240021AbhDUUgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 16:36:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LKU3pU189816;
        Wed, 21 Apr 2021 20:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2y0CNa91ed2MrvtVGj/C962vHHAY9PsFTBwRnUR4n5Q=;
 b=Km/I3Ni6TMIPh7jUZFcMqZKm1cKhY5W9/hX3YMjj314wDH52rQyioKRfQf5L3/So6iEH
 +MmRw6tEf0YJ/cKCbJ/vjmpueZZn42rEJDgjuQZTI/R1Q7ZJ9LoPrhrkBFmsFqqu14U/
 nXEbz6rIpX0+h9z7i5dOZyOo3mvd+BnmllipkTAS8VVn6dqbzenIoHBXEwm/ca+1I3tJ
 Mh6jUIKp4HU4LXIHU15M6/qBLIcsvQMr6SiOcTGcuHxqA7eBgV0+EpDRquk3ECJ4nf3i
 QPJUjvdXesTixwJbH97xqnJSvUClMKtuRgGhrsadHy8O/nYoH4urM4VJG7eCb/Z5qBEF qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37yn6cbjfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 20:35:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LKTxk5006585;
        Wed, 21 Apr 2021 20:35:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3020.oracle.com with ESMTP id 3809eutnqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 20:35:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqO/FJUDV+K+AHW4BVHKKtBWCfTre2C+kEoYu5TNvyxL5AuLUis+pRl1vN4Wd+EUMwmWH3oaDU84ef4olJiCtVu63f5Z90Qc27WnyVE4ostD+nI7ERaXVugEE4BK8x0NJyg0qpyQHnhUUXqLBLR2jURnOumMaODXo4f4ZNXwtLudKiF/bThc4VVwnNifZyfw4kAfp+uccrhLJAZsei6a5ULiexbfcuDiCCsGbldvPZLiL3G8k4AO8IrmR/aUQ8vDjZJDdmp13FXdbNweY/jAjd977JAwHWFBzAt7wMnKgiB9p9u7xnQqSqTuM0wAqJ31m1bJOROBMeNfpe6feJtEfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2y0CNa91ed2MrvtVGj/C962vHHAY9PsFTBwRnUR4n5Q=;
 b=nhKPXV/pks/15B6Ayco01GGHrsJ/bXIN7zzZXJ2E+X7ZtecbMUKDewc0bn7FNxsQweJDEqeltA1eNy4hcFAN+z8XlhdkdWHtMAz2vYZQxaLfhukxdDLsr9Kw0ns9eGLo7tiiaoQw8mj9EwvvjG02NHr7Ea8tF8J37PZUMi3ddIpKQGVjj5umrUlNPBD5o5d69YzNOJGdHOBpwEOUL0BCNR25FFxLocqsYu3BXT+grBuwBVG1pAlrat4bbCn4znc6deczH0oB32PFKPwksXW9p1S/oVKMliGuhz72u71rrezYCJOuMikp5VXFhbS6LNDELglqq59qVFIyt2ZOBtX4FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2y0CNa91ed2MrvtVGj/C962vHHAY9PsFTBwRnUR4n5Q=;
 b=mfJFrr/JiEDDbd/fwel+HqC67HxGFVkilHldEMMIkrec3jP9k94HeiqKqt7L6c3BvozLMiN9m7YDqJmZt2N6g6hOD4hFEOFDwQ+jJ5xow2Gi1RRHEL90gX6vuNVjymAHR4/W4yeLJsDp8JfBT08IquQG43scRph5lMhEXwG1ISg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2909.namprd10.prod.outlook.com (2603:10b6:805:d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 21 Apr
 2021 20:35:29 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 20:35:29 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 08/24] mpi3mr: add support of event handling part-3
Thread-Topic: [PATCH v3 08/24] mpi3mr: add support of event handling part-3
Thread-Index: AQHXNQuER9Nif2y9tUCEddbzGtd6iqq/caMA
Date:   Wed, 21 Apr 2021 20:35:29 +0000
Message-ID: <539DE00F-7C7F-4343-866F-372F7D8ED86B@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-9-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-9-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6829fb28-3c27-4f5f-8e5f-08d905050094
x-ms-traffictypediagnostic: SN6PR10MB2909:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2909C988B5EC170E35860E23E6479@SN6PR10MB2909.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G68+ynO41nfHPCLDPrT9yr8NpdU4vuDe3r106QZbFTj++GzIKWbJRobJHzn7UE4tFk6GToBmKjzjUEWMdFRRXhLHeJtf8mAkbbDrFKnGfwlg8RVfG26717M5zwT5tMqi2mlZ2u/dhu5WDWz4HCEq0DsnxzaCxmLkgyL/hYh+AvP9dO19HVS2SJtPwel2A36vPzd2M8Bdol3u4oNpsPFgbWzfsDsDxB9TjoLRnOB670/0reAwztV9dj9vRyeXVPFqwZcR8UpjpNNx/bJlyvAnrD90ZsZxxOJ+9gJeLXeD9mYpXrq5KB+etaSErtW5kOD7QQe0RN1v3zhhPxGZWEfr8xfrHR6WpqVBNx9p8EHb+IBWgAECGzHtTwKIl+aqX2XdH7Ajij+qKvBStH2y8Kpxkj+yOwQbQ7UWF3j86+OClmmnMJ0aIHj0RqfWyJI+YWhS0W5HVQfkQHXyYnJPnEmWIwdakoh0ntakE1uck18CSeJ0UCl191mjhjs3/0KK/KrbW9qo5mW3Kxp/9j9UiSW6ywBHJXUcXwM3XdTvLXAgtsuUYPcZVssg3dNIEE21rH9zZKXCT77LZLvkXUaGSzce65k5fjxMRy2u+mkvaiUGZ37aOtccnrbNEvQfR/Y922y1gEw+uqodHYsJNDXzmjlt13PyL4+CNZpurW5O7JQhCWMB52dsPSzGY1uZAi3fEX+K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(346002)(39860400002)(5660300002)(53546011)(4326008)(6506007)(6486002)(33656002)(316002)(6512007)(86362001)(2616005)(66446008)(64756008)(122000001)(66556008)(36756003)(66476007)(478600001)(2906002)(44832011)(83380400001)(8676002)(38100700002)(8936002)(66946007)(76116006)(71200400001)(26005)(186003)(54906003)(6916009)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HaC22cv9PKq4VgP079aCYAaj33ZmdUsqLhH3JEBuV7Dv+wBwh851Fq5adERs?=
 =?us-ascii?Q?OCqNRQLQpLHiQjG8qbFzWV8ILfs82yWF+0e61x53ctdByds4LQsheuJERiag?=
 =?us-ascii?Q?qmkQ6DKK6PCPOqCjMLG9oVi9KwWZBug8N/O2Ffshn0ZO2F52VcgcBy8yOR+Q?=
 =?us-ascii?Q?V6iMH8fKTeiAIENkBIsm3+RHYJQtDd11s7pZVos9i2moqvOlHX3tB5z4FX17?=
 =?us-ascii?Q?1Y8fSe0H8ToYyj4fhaGjz/NR9GORpHejfAs7I44KcLm130/aUL8DNjs/gjMy?=
 =?us-ascii?Q?bac+/3QwlxZBi6SqpD8QdiYkdBQeKmH/lvvqF7LPbAigV977fe/L26/z3XJ6?=
 =?us-ascii?Q?3BPvxCP03lsDk1VuBs1x8Mh4wnkb2i8pmNUU6JrMAeIDv7C1nagxVqLofbkb?=
 =?us-ascii?Q?Nxsb7qvdJJIQL3xs4BTZqQc8n0KQt7maZCk36rppjDQiyL4LhXyHZocJGPRb?=
 =?us-ascii?Q?KQ2acBMarHAR11PzLvPN2VZga7JkioxY0yO00YvSvLKKRXl/KnworqdIKA8b?=
 =?us-ascii?Q?K5Qa61wT0H+KPi7C3StdYAWdRIbNKCNnBekxEz6UGwRAeBZ5zm59yskFWcC0?=
 =?us-ascii?Q?o/F/tABTnngjv94jDw7PHIc5/LHqOgaEJffmmwoTA5JXnsREK1gucYze3tjW?=
 =?us-ascii?Q?+lEQTdUZlmfnDeIyxIfkU7vH1JL2kd41Q/fk4pG3SEQ8/1WUWr98ckGON0l7?=
 =?us-ascii?Q?rYRnkl4gVhStOuKlyllLP6OUj0uZQXgGBbQb8QKpkOFv+l9NR9RYlCLlclJZ?=
 =?us-ascii?Q?PPnKbTuwfYWxHEVPS3jFSxSkthB5r7fVbJMX7PbvUZDj1ZUPrZZQsseX1zgI?=
 =?us-ascii?Q?gGxYbjhg8nl8Z9XVnNUztxlc1Jdocn1OP11uuKFlV5KVR//nGuy1YQ0gZ/QC?=
 =?us-ascii?Q?x6h/Gzk+Dsp2MOIpGTHoMOtkJnun7MYl/JzaZpcbQ/8YgnbIuEk0ZtZOvdGu?=
 =?us-ascii?Q?oan2MLyYNg6e85LHjFpjom8o6W6EShN6/eL7eMMUlzm6gmZeA0rHgsILIT0X?=
 =?us-ascii?Q?i2n+Z33WSYw+CTYBi60s5vq/F6qUwsoSmmD3qCUb3vgS7Mg0fyUgpnE1TV29?=
 =?us-ascii?Q?IfosPFnZnqwIcZ32X+ATFEDT+RW9PCD8LIFmPniSQOYzUVYfK5Gkqmq1gyNi?=
 =?us-ascii?Q?xQeU5f2WlW8UodrH629XlzUya3KY71kq2RI2ZHQkwBHCEriH7bOt9FCDD8/k?=
 =?us-ascii?Q?LSDgr1p8Boq5Qe6tHrO30BybTDX1KGiOdIF6CNbGObcDdIJAyBDin/Of/vsB?=
 =?us-ascii?Q?dH9uesACG36CTEMbBXGzMd73PjqMd9ytxxtZjA6Xprqfr4c8rEfPNuDyb5nU?=
 =?us-ascii?Q?7ZYzcCCDcqGQGGJsJ5UnIhd5TZ5PU0Iv7Q4GiezoVHDH4Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C22BAE076D2E849B7AE9CA2163C6666@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6829fb28-3c27-4f5f-8e5f-08d905050094
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 20:35:29.1363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KNtndR3ZU6RL3jtiT8BBDG9mGssVH8vd6N4iythqME9LIPUm+R0/3h4xPQ1RIuAFoBtzbBxFnlQjSxqvs93+4/qoTribvUHqQi7ZtlJBdRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2909
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210138
X-Proofpoint-GUID: x8G-xTnOTBPyp2TL7hnZejVDfHoi1DKz
X-Proofpoint-ORIG-GUID: x8G-xTnOTBPyp2TL7hnZejVDfHoi1DKz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210138
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Firmware can report various MPI Events.
> Support for certain Events (as listed below) are enabled in the driver
> and their processing in driver is covered in this patch.
>=20
> MPI3_EVENT_SAS_BROADCAST_PRIMITIVE
> MPI3_EVENT_CABLE_MGMT
> MPI3_EVENT_ENERGY_PACK_CHANGE
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr_fw.c |  3 +++
> drivers/scsi/mpi3mr/mpi3mr_os.c | 37 +++++++++++++++++++++++++++++++++
> 2 files changed, 40 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 7f3b553e5b86..00c3996de032 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2745,8 +2745,11 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_BROADCAST_PRIMITIVE);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
>=20
> 	retval =3D mpi3mr_issue_event_notification(mrioc);
> 	if (retval) {
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 3d78c558fe2a..3629184f68f9 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1496,6 +1496,36 @@ static void mpi3mr_devstatuschg_evt_th(struct mpi3=
mr_ioc *mrioc,
>=20
> }
>=20
> +/**
> + * mpi3mr_energypackchg_evt_th - Energy pack change evt tophalf
> + * @mrioc: Adapter instance reference
> + * @event_reply: Event data
> + *
> + * Identifies the new shutdown timeout value and update.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_energypackchg_evt_th(struct mpi3mr_ioc *mrioc,
> +	Mpi3EventNotificationReply_t *event_reply)
> +{
> +	Mpi3EventDataEnergyPackChange_t *evtdata =3D
> +	    (Mpi3EventDataEnergyPackChange_t *)event_reply->EventData;
> +	u16 shutdown_timeout =3D le16_to_cpu(evtdata->ShutdownTimeout);
> +
> +	if (shutdown_timeout <=3D 0) {
> +		ioc_warn(mrioc,
> +		    "%s :Invalid Shutdown Timeout received =3D %d\n",
> +		    __func__, shutdown_timeout);
> +		return;
> +	}
> +
> +	ioc_info(mrioc,
> +	    "%s :Previous Shutdown Timeout Value =3D %d New Shutdown Timeout Va=
lue =3D %d\n",
> +	    __func__, mrioc->facts.shutdown_timeout, shutdown_timeout);
> +	mrioc->facts.shutdown_timeout =3D shutdown_timeout;
> +}
> +
> +
> /**
>  * mpi3mr_os_handle_events - Firmware event handler
>  * @mrioc: Adapter instance reference
> @@ -1559,9 +1589,16 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mr=
ioc,
> 		process_evt_bh =3D 1;
> 		break;
> 	}
> +	case MPI3_EVENT_ENERGY_PACK_CHANGE:
> +	{
> +		mpi3mr_energypackchg_evt_th(mrioc, event_reply);
> +		break;
> +	}
> 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
> 	case MPI3_EVENT_SAS_DISCOVERY:
> +	case MPI3_EVENT_CABLE_MGMT:
> 	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
> +	case MPI3_EVENT_SAS_BROADCAST_PRIMITIVE:
> 	case MPI3_EVENT_PCIE_ENUMERATION:
> 		break;
> 	default:
> --=20
> 2.18.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

