Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6F0C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 908C461354
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbhDLKZs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:25:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41768 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238802AbhDLKZm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:25:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CAPF7N011012;
        Mon, 12 Apr 2021 03:25:15 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu9953q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:25:15 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAPFb1011001;
        Mon, 12 Apr 2021 03:25:15 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu9953p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:25:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdQfLCggQeGlkWXAHUje5ktoSHnijkUGUQDAeuGY8RrKulkkEbvzvW0OmcwY/Jt4x1LvO1WQSAJ5PQBg/rFwmKkFqAGAYe6ubxaML+FNR/AFYGeH3+b3TjU4txCEiYsRUGF98Wm/8+mWz+ChP/b0dRKhymmAiKxGeGsGhq2fn5hi+FJmHPQ/p/zMn2u5inqvpqZOgh2uat8liueVV8WY1Axkm0d3yRjtXG0PwhQErPkFWt52P4Hpigow/Op6cnohyNd6qVNpuN8YVvAKYSui4QAurU+sq++ye3mq9J/dJ3czz/3W6WZFudUgy5wb3xV8EyK4edCDl0Ki9HoStbctNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3oY6/J+Tnf7p57ozQF1nxh6Vu4iLcM9qewHN3cDn5o=;
 b=QkjLmJO1dTQPsYr77vQCvWZRtku1F5frmRWuzTLyW501qmn0H8iDGVMyete3F/oxTARZUSVa6ixj7ooJI53utEx7fI3frpyW0mGjOUybXNjRZmbNt84r9N0E2n1CA7V5vhB7Pe/at4SLltlTbC7maOA9RvlxKPA7TBxiR5lMtwhUVgHUTdsOUOKd7Vu0uuJwtZ4WR2kGaaut6bt8YdLVh6Wslk0ME70VO7xFD+5x89TIRF+Rt9ShydiF068E0V5pItOVCzuLmjaTe0MANN40A9aVCC0GAvOFwOBAeslAxxG6xikrJ3ZRAiD4U8q/LqeGz/n1Aiy6P3gOn5IQ09BQaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3oY6/J+Tnf7p57ozQF1nxh6Vu4iLcM9qewHN3cDn5o=;
 b=FF1fK6CJQ8ZHy5QXJDSeiwIBVQnieBlmg9e1DehxlW6pI6uxMcmpOiaYOL6RF3MThld65w29uxYs10bbyIqXpQqTOhHAccZ8W4ncGO8w2zeyTcGmWiltlUvjI8UTUrBZaTR8ur8R5B0k9w78D3tQdamHveUSa9i+TxTmvV+S1Ok=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by SJ0PR18MB3900.namprd18.prod.outlook.com (2603:10b6:a03:2e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 10:25:13 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:25:13 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 02/13] scsi: qedi: fix null ref during abort
 handling
Thread-Topic: [EXT] [PATCH 02/13] scsi: qedi: fix null ref during abort
 handling
Thread-Index: AQHXLjj/9K3201hV30WlbRL+oWgYHqqwr6+Q
Date:   Mon, 12 Apr 2021 10:25:12 +0000
Message-ID: <BYAPR18MB2998F5D44AA7B00694D0D4DDD8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-3-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-3-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f19cbb50-3523-4dcd-f14a-08d8fd9d41fd
x-ms-traffictypediagnostic: SJ0PR18MB3900:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB3900FF0FED2967BA82B647E9D8709@SJ0PR18MB3900.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rDdORdQUN0dS5RTlGwl2WuvMyQxPnTaM0EbxUN2mi4InFGSjmIVnEfEibDwYs0gtpHSEi4NEQSRYd+bjVc8OIuHJ3KvHi4pmhXfJDsPfvyTvaa5+KLw0vvKyXuP/EfkZhMlVCAXHYLL9zouXqxflVoNdm7qasaLJIT9BkgaKXTqLYU3iFnKuYqLWKilhXyr0RAhN9zfmJqVGABLCig4dEkrJBUrAT3GI7iV7gtiwW8sHFgwjCJYj1jAklYWrenPDt0BZenVu1DvNmCKMqsMkoNkwNxh7mb7JgTfgJV+Q8PnsSv8zy12hLeFkFuUoadDe+eGGOx/6OEwI0fQgIoqre3HKtUPVttMzGgEYtWHU6HjeBAKl9kBg+ijOsizMsDVC8degSxZ15PtIqr5Opm/X2hyYRlfnHeaN+POlt9MMvdMX428SP4g7SJnhbIbmoZTFacBdGqlAx/b2xIuO3r2QN2NhsaeZvpndlJ8lc0xR1KCDIM+1NNigW4glsS3eci6wLu7nrgzcFKIrXp/yIUKh2nMj+V+1sqkvnMidc789jZByoMuWLix5CHEiUR9UdAzxs08hrBf9z16eBny1FaUambyf19g7niVdu17B2lFmX7w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(86362001)(316002)(8936002)(9686003)(6506007)(71200400001)(64756008)(38100700002)(76116006)(110136005)(83380400001)(53546011)(66946007)(66446008)(33656002)(5660300002)(26005)(2906002)(52536014)(8676002)(478600001)(7696005)(66556008)(186003)(66476007)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pGXBXC8kCDXwvWZAqiMEYwFeSkTej33VPsiG3Uu5mYNPSOSqdaZX4s4U9wu1?=
 =?us-ascii?Q?dPGfBiPbAfoSYGI77CF/DnSofBlmE9ewZvViLjooDIiTH/ZyaDYIf2nPdoA/?=
 =?us-ascii?Q?yp5iVBsFnLkaF/gKTh3FgJ4GJ8s+St4JcCdHfxWDzVEwbjSQz5uaRGvOhCBs?=
 =?us-ascii?Q?bSFl93jCxMXvlk6MIWm5ss9I5cESXdruiW5dE5BxIHDCJyLiQOcgWVe0CRJ4?=
 =?us-ascii?Q?KctMY9CaE7mqf/YdqzeW4GRg+DjNsZx48Ax84gfo0tMyH6ODrBgozmMdDnxv?=
 =?us-ascii?Q?c+gVq9K5dhXAtJ+SUU8z5DtqcKeQ4Af25JBwrLRQ4gZS98x+0QnTet4Qchj8?=
 =?us-ascii?Q?9N7JXOBd4NWkVEmv5g3hVQADPAhdZe1feg/utxQcPNWK8CRMbY08aaGr9zaI?=
 =?us-ascii?Q?2IrEsxrDIXn1bdacptwz2dwcBnwjPUCuwNhcPzmamZvleFAiM4BnPmM+WwrO?=
 =?us-ascii?Q?P+o325dMXiWwpy/OOBwPEYxYtUZPv1Hxe/sKFvB/KyVFqYmO6jhWkGUlEWy7?=
 =?us-ascii?Q?Phtr/5PyO9N0kv/pgyPj87jXOVikgAhtneWcgsCGByuyUPcY7lxwbeGliZa+?=
 =?us-ascii?Q?OfcLxBurwP0ZST1AajJ/T3CSq6tlK8NwmC1V9GPvQSuO7hcTRiWnqvZ9sbyr?=
 =?us-ascii?Q?3eAASKU+XYYdCtaLLmHxXwwL9iZFlWiIHHadDuGcZDelMEaHFlE08GNdCPKT?=
 =?us-ascii?Q?xATOt8T1tTxI3EmegUzX8bHq3eocKH4eg8ljlj1cfRaLrcyeG4cZfw2agZ6t?=
 =?us-ascii?Q?mSBljyxRxUCSvS/tZpM6Ujq9DgDbi3clY3yTV1d0NO9xcgpnyuJ8SLuaD7fd?=
 =?us-ascii?Q?sLLmsSXSeUudMcbzWM6fGan6rIcwIlPzJjUQL+55w+lKUf8T5uqMlO/fnLUC?=
 =?us-ascii?Q?IxhXt+9Y5jm+zVI5hK4MrmIfP8zuXa2vdXHwmVNusHG8tHAkURZCD1q+VSNF?=
 =?us-ascii?Q?rDtMZYyx72qKrZdk1m43/Sc0phJNBlvaot0dJ/bKmDCzX0gEelh7KqiVox8R?=
 =?us-ascii?Q?lD0VrwTQouhks4mLTZZQK70cqJUgVyN29I/jBS0yS0C7P7SRx9+InpV0z8R+?=
 =?us-ascii?Q?eUKN+KZq+q92gG73OXMnSmwdG0s/I8YV/5emul4lm6bE+VBxlKkWi8Z71WA5?=
 =?us-ascii?Q?LNBb2BXVxxqWlkTrL+6913jKS3qXnBI/MpqX/Ptw97Cc1aejjZHkr3cZORKB?=
 =?us-ascii?Q?sxDAbiQ7zrx5kYCqy3uOjmzpwSo+dB9AEWrGawuUUTatBkvmCCBHQfZq0Ggs?=
 =?us-ascii?Q?fNJF4ot282aSSclGIO8KW/RmgMknpXQ21W43fA0mHfsyhnMmI+7k9+GYzD6r?=
 =?us-ascii?Q?ZE0lKRqLXeM2UWlluzR1/2mi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f19cbb50-3523-4dcd-f14a-08d8fd9d41fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:25:12.7291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBabn0CrOhW2PENIVmGX2LHq2wVxupvIAXKa34LJicGmKTDdQWVpACTIpmYnFyI7ZdaM55KH+ktbqXv1v2bUpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3900
X-Proofpoint-GUID: wBCUScoXIaq6mybU7pBJaEELr4BF4ORt
X-Proofpoint-ORIG-GUID: 1st05fqIuE78nmCYhcy4PFfQgQ-QLI9S
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
> Cc: Mike Christie <michael.christie@oracle.com>
> Subject: [EXT] [PATCH 02/13] scsi: qedi: fix null ref during abort handli=
ng
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
> list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is =
non-
> NULL when it wants to force cleanup.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> 440ddd2309f1..cf57b4e49700 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -1453,7 +1453,7 @@ static void qedi_tmf_work(struct work_struct *work)
>=20
>  ldel_exit:
>  	spin_lock_bh(&qedi_conn->tmf_work_lock);
> -	if (!qedi_cmd->list_tmf_work) {
> +	if (qedi_cmd->list_tmf_work) {
>  		list_del_init(&list_work->list);
>  		qedi_cmd->list_tmf_work =3D NULL;
>  		kfree(list_work);
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>

