Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF0A9C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 14:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C74619A5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 14:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhCVOtz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 10:49:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52344 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhCVOte (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 10:49:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MEccg6054161;
        Mon, 22 Mar 2021 14:49:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=N9/wLcdOEyvDWJztarO8AQsTyI7RNp1/8nbsK7nhskE=;
 b=WZnWpvvrYWOBo7LVexfJbsxS72LNyK9LQTK04v+IdS1Elap6FQwDkD8yFU9l5Si3Ycdh
 4HK+B388hE6CWxzrL4b8lOC4TYytmxXwOf/yVEd4Kwz6J60ivWE9miJVy9zSST8AcNmo
 i8izu9Y6kn/S6i9d3xSo+vtMzju61JMvKTQwnYmV/HUgvIImH7pfNU5TLLqJq70BXzb9
 +ZB3gOYO0cCPqLtUSltWIXN1YWPyjKSf+DlnsSOfy9mClsqjT4trbhHtLJA/R1c0/pMj
 BDThNjMN4L1HPzobgF6h5/pSYzO6pE/FQgNlTnm60J0dnhO6m06cfNbEkn6LDifNVKoP fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37d8fr3rgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 14:49:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MEeIek173404;
        Mon, 22 Mar 2021 14:49:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 37dtxx1stu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 14:49:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NT0cNK+GyboGC5k9++XY5ZzwnXyrwF2cMpN7CaCmD2M1GXCj9oUm3sMfxtGMz7f8n6pcAkR5wikwaZDcCeBWMyhm10i3wNRab32sQyOWpbse0b5D04RQ1C5aYhbEvk7DEcsFyQ4LrTY79A9hi7MbNT95ssa5Oz3pXTo2pfOxhJkUUH+IQCsCGm5+gY+DRQXOqDqSVqi49CaI39td50FZoc4adYA04loyrX8nr82xWVtg+NYFE3GJ12fy7pyvr0gcTSVqyAl0eTRLzWkF0AfKOPTjsPHJDzF7BK1Vc6voZ/rawLq1NZmDvPd7e2ydt5yNe0ZXCCwlBY8VnheE7jGjZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9/wLcdOEyvDWJztarO8AQsTyI7RNp1/8nbsK7nhskE=;
 b=jG1WMQdrGYYwEokcANS3lrCbKoTjtL2r+cvvePT93xnw6CepnlG+Ar1fxK2leYL8uiDbqaKlF7zY67zmnj5XSHBuUBkqXGCZodaIh7A2Pi5GX3+z77hYpk+o+ucXpAKqm+SDeq5aNicX6T09r4CxfjH+4hD/tlpj4SF918ZXpT2oj0aEgUFyt6xIbCuvmVWAbsIo5fc2XuzszJCcgsyz1O+pTHitOfZ7vMr1/mwlUV5vYHJvsB0ipO2woCQTl3qMREbOnx54f86Eyi2+v4pb2DKk0WORBFJB8LuONi9c9mN9LhQlxqVENrRM3B7Hnpa/Yfr9/89etGOh5z8qu2l1DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9/wLcdOEyvDWJztarO8AQsTyI7RNp1/8nbsK7nhskE=;
 b=z23D4GpA964cV4iYMRzjG7itrpeDAGwavl3UBmDCiFwgadtghwbNfcZqaFsY/dmxCLOwFZjeaQTyUdeM7iIy5FYuhz2frKwu4WSjX/REU/g/M2XiOscnHzjTuNorsd4A8+gUGfqeAroSWuygA3KRYEiU3TkudXUsIt8YSi3wI1A=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3455.namprd10.prod.outlook.com (2603:10b6:805:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Mon, 22 Mar
 2021 14:49:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 14:49:20 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH v2 0/7] target: make tpg/enable attribute
Thread-Topic: [PATCH v2 0/7] target: make tpg/enable attribute
Thread-Index: AQHXHvJYTyjsVQBRK0azeqKemNddxKqQFy8A
Date:   Mon, 22 Mar 2021 14:49:20 +0000
Message-ID: <8F4C2C39-8182-44F4-B20D-90CF5B518EFD@oracle.com>
References: <20210322080554.7611-1-d.bogdanov@yadro.com>
In-Reply-To: <20210322080554.7611-1-d.bogdanov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 769f35a9-ce70-4432-4325-08d8ed41ad50
x-ms-traffictypediagnostic: SN6PR10MB3455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB34551307F66A2C070CE46AF6E6659@SN6PR10MB3455.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TBWvVkKWuLN6NUEWHSQxQAIaIbGKmX5hBQ0GSCIE4Tn0HCSWIp0606k66sUDuFXRFBembCDXyM3DnSK+IOf84+3BL6LDH6qhH5vs5+1IeREkUH9Tr1Tlu+xIzmwtTBazGPQIAoz+kBpHVFGM+DocuTKqsE+WpaoSAwZWccK8eQanhmpSJTb80vaxOz2AFS81vVtdvi2//olbZ3s4XDiwJ6ouY/hBIzvFZAJhftTbCzP72sbDaUP7LcA1tH9I8FvSrDMpdIG0NNCq7XPzrXO9ypv7Nmyo3rgr89J5e1lkHJGcFLGM0+PvF73HcMQKBc/eN+5xJs657cZqOxPHBKKyAnAjU2gP1n2YblFh9oVwm8Hc4J345+empWz9P1JSKPXhk6s5jWC2xUo13qQUzfOB2iDkbOb+amvLagL3juFQr+7EOuqkcUYClNFejMDd+1FYLXrOIV7I1mePR96uqynDVvMkFxtpUDp4ZrUBMeHiphP72GVSIFINK0nUwmZ+pmPbTnZBKeoKAP6RiEoKK/MgKTCsUNPfwqlSbbbtGDNJ7N/ujfyWVZ8iBzXiu7p1zlvP/QIWOxp9YE+StmqK+UP4Re0UfbINPSRcxKSGSf7j9qgunB49+pHGfUU4gf7VsWmOo33oawCNMTMaUetacpcMgo9op8XxHNQlv/4YWogMD29sR4SVlp5+8qn3enCWpzBH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(39860400002)(396003)(54906003)(5660300002)(316002)(36756003)(76116006)(66476007)(38100700001)(6486002)(26005)(66946007)(66446008)(64756008)(66556008)(2906002)(44832011)(83380400001)(6512007)(86362001)(53546011)(8936002)(6506007)(478600001)(2616005)(6916009)(33656002)(4326008)(8676002)(186003)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?61aPST/e9EQBC5k99wSKwaRr3Zvhu4wZO2X6B1l/2gwsWiAuZyt5R6m6dY4x?=
 =?us-ascii?Q?Kucv6LVwslV8DvB4ezY0yliyTL02NPKqz7DWRxZRnBUvVuNQK5wXKFydQgYM?=
 =?us-ascii?Q?2nZ079Y49GCzFgeWDcvJoJIXlUrB2h90eoyCK1OcDZseSTm0TzbgTK1qbvAz?=
 =?us-ascii?Q?K0FXZceTCvRhBV3DzBN1mWKIYu94GZK2YBd/AxWeqFj6cN1DJOt9atR9bZi8?=
 =?us-ascii?Q?UtFro4xPPp8BMzoXZSawWnPrTnt4mC1TjVLhl47hIBMWhZoAVi0uH/1f5Tn6?=
 =?us-ascii?Q?7YNJxs9WjaRWzWMbvzfZTOxiucOtKxI+AM7irvFcYmUZOlqF3mK4/g33mmQa?=
 =?us-ascii?Q?1JUSUPhxmv0sKGwMr72p+AVdTZcmG0m17al1TfDtxfL/4h/NtUDERd1bVUMv?=
 =?us-ascii?Q?bVtOZ3Z6DkYi2AnLnnmOnB/1QKbWwEP+H+5DbpXrmcCOTOjRatypn03MhIp/?=
 =?us-ascii?Q?+dHA+JkzA7t2WxQB3RVfQDD6sJVtpOwih1N0D4QIYxMRxsCKV0WNq3YvTkXa?=
 =?us-ascii?Q?QXtqjy58RGoOgW+Jl+mempbscWv4lq+zF/1lIR4fjry9TeMA3UxImzGWHVFh?=
 =?us-ascii?Q?Ol5F7CN6vBR0xawJsFpIqGcvlX4go6cfM01Udq4U9MgIc5Mukh6Bz2VNIBgF?=
 =?us-ascii?Q?eBSWo/M8Bfr/RQYZfb4nrk1lnXiCLtD8TPBo7Oxar+roKxe2JES/1H+6o4ea?=
 =?us-ascii?Q?iReCff0gBANVSHHBrwVTmv+IWBJ9kt6I+AACh08rrBxxJ9UEz9DHexwEcMqv?=
 =?us-ascii?Q?tjhdRNzN75r7xAypxceO5QAn3/eBJXducwBmPT3fG7h+YHM13acaefa/rCQm?=
 =?us-ascii?Q?DQGV1L6/BRUHMDJot4F7UjKnadOXg8eufUxt9Y9QnyDo/gUUHGoh8YQqtEWo?=
 =?us-ascii?Q?4zh7hnV/c/I7SzfbTbrUxAaoX4x+68XSwgt/5stagj/BZaYpLDJljICIiKvI?=
 =?us-ascii?Q?R+6r7lDo2B3tG8hiuXSe8vIuandjQaFU5R0midAwMlRzg9Q11Q+c7kizKVvJ?=
 =?us-ascii?Q?6jcfMEvfuTxSCnMJw51/sd/VTH9DZifGJMQUY6thg5i4URf11apGentqLvii?=
 =?us-ascii?Q?4RU6TneDcd7AO/ewNrOyy38Yx6nTXG/35Ox0fkpnsZdMGfI/MKxoN+tW+BSY?=
 =?us-ascii?Q?8f0JIVU0q9pMjpSwu4SSOjXNWhp63m2+vXOb5QdIXVDKeqjzJlQhGZsmiQoT?=
 =?us-ascii?Q?kiDTpBpdv6NhVNGAgH8h0bIBGxfLLrkqtIfHmZqsvTu8Qe7yKx95wWTl9QjR?=
 =?us-ascii?Q?Dct+jmEMTOcncvARu1vzsJrqWevbzzxQbqir7zmn8zBQcRjMvNwr3kgvBLHP?=
 =?us-ascii?Q?JShHpxBkRBbE/Tz4s5V6CVJ2WcTcjhdycavIMRURxYjYlA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F023B0A0883E3E45AAEF6B001ECEF358@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769f35a9-ce70-4432-4325-08d8ed41ad50
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 14:49:20.8321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YvmfdbMNfVjba+fowDu3PwmA/vnbY3kl6F0uxQnV9VgRxU9YRCyitTiqCBehKIgLXjpcHdXF+Nl0OrqviiZi24mtd4EShhtv4trugKmip2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3455
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220108
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220108
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 3:05 AM, Dmitry Bogdanov <d.bogdanov@yadro.com> wrote=
:
>=20
> Many fabric modules provide their own implementation of enable
> attribute in tpg.
> The change set removes the code duplication and automatically adds "enabl=
e"
> attribute for fabric modules that has an implementation of
> fabric_enable_tpg() ops.
>=20
> This patchset is intended for scsi-queue.
>=20
> v2:
>    create enable atribute only for modules with enable_tpg ops
>    add patches for srpt, usb and ibmvscsi
>=20
> Dmitry Bogdanov (7):
>  target: core: add common tpg/enable attribute
>  target: iscsi: replace enable attr to ops.enable
>  target: qla2xx: replace enable attr to ops.enable
>  target: sbp: replace enable attr to ops.enable
>  target: srpt replace enable attr to ops.enable
>  target: ibm_vscsi: replace enable attr to ops.enable
>  target: usb: replace enable attr to ops.enable
>=20
> drivers/infiniband/ulp/srpt/ib_srpt.c        | 38 +-------
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     | 42 +--------
> drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 73 +++-------------
> drivers/target/iscsi/iscsi_target_configfs.c | 91 +++++++-------------
> drivers/target/sbp/sbp_target.c              | 30 ++-----
> drivers/target/target_core_configfs.c        |  1 +
> drivers/target/target_core_fabric_configfs.c | 40 ++++++++-
> drivers/target/target_core_internal.h        |  1 +
> drivers/target/target_core_tpg.c             | 41 +++++++++
> drivers/usb/gadget/function/f_tcm.c          | 31 ++-----
> include/target/target_core_base.h            |  1 +
> include/target/target_core_fabric.h          |  1 +
> 12 files changed, 146 insertions(+), 244 deletions(-)
>=20
> --=20
> 2.25.1
>=20

Series looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

