Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83946C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 14:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CBCB610A3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 14:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbhITOC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 10:02:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36534 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236897AbhITOC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Sep 2021 10:02:56 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDTm33026673;
        Mon, 20 Sep 2021 14:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MWbUjGtUIXQaBmGD4onYypmI49nTd7Yzk2Qb0D969uQ=;
 b=MgScugymuaLjj7iOnh/FJK3VAKarPpGnznIPpiRmjDA9i5ZWOyPoTjktXiyz0T1m8dq5
 rS6zyQ3wo1mbGeqI0Iv0C3uJYqnzZN31Vl9n3n12SsCGYQ8jHGDjg7c3VropVbkDhlO0
 kJiwM4nWPT3u5WAiHlAn6sifK1xzKQf7E8Gy4WlJzoA7zqGSkZ0x0agzivHXwaHyZggM
 Z4pAh4uaEdXg2hj/3/mGpqEUHHhxrO/xB+1Y5TryalualPezbX9hzT1SZ/ZDP561O8W6
 sMq8d7w5GsjK95W/jA78VhOViJmILiFVNtjE8w79+RjIyxEpMAoM7x+GOGVGQaQ0xm78 Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b6426axxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 14:01:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KE0tLs063149;
        Mon, 20 Sep 2021 14:01:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3030.oracle.com with ESMTP id 3b565cn1kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 14:01:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfYYnoEF6ii54qXAZ8Fp+v7UEiqiI6nyIH7lz0Y0jmELZMtB6Nw0EkoZCqYCxaj/3smEc7BCYPPf0NKVdaN9ZhRbP3b7Sct6Xb1ZaGQfSxcGD7Bg+8oIOJMOaMGCxVjWg9VnKG96nglZciOUT57J2RByzqM7+ccZ7zI80l77BN9NyuDU9/LKpLa5JHngLBuCvcD/kQWd27C0qXkMsd6wb5wOy0feinrSCQHDyf/kd4auKAxyAGXLwSTXPE49aWTuJW9+Ly6omWYqu8hIoFy4QSnkhCEs8Gv23szpOrp0ckQvhNUhht6Phh3LJT74XkRkctZQRcq0FaTmup/S/wzgZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MWbUjGtUIXQaBmGD4onYypmI49nTd7Yzk2Qb0D969uQ=;
 b=bcCmTSG627KjRAXZUuadJxir3TxKaM4yfnteX0Xi3rzJ/CK4+SHzEnEVmciL6v5BzPKAPpbsl1hCYWpGFgZyH2KjUlUFuI6rmBJ4smEVjb5WTZP1P81E5TJ3N+mF9HJ4xpfiei2O6JE46J1t7FSxJxIo3pC1v1hxfF4d739I890Fq5yd6EvB9OYK5mLpmItECXO+jV3Yy0QTvcWZ5rVZCeMRXZEQ1u5KoT402ygB2/sAwOhNbCjkJk8HlR8vxiGazvUJDiurhIvGbfQL/vw/aYhxhdlSb+HjkPuh/1XA1C30Sp8QYOv2Uf/vLq9jtec4aEMblK9RnAl6LAQqgE/4Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWbUjGtUIXQaBmGD4onYypmI49nTd7Yzk2Qb0D969uQ=;
 b=U9zoHlYg2/PmqgeHyI6/4lJ9fP6XsJzRTiRR/6Xtibz/nQs8vX45X3ChiQMGbuD41R6tr6aKvscRmbicWiOooQa7OlFbF8WOOPvGdPqkifLigqNSUBJCw+DpeWaY+/TJZfMqnJn5F8TQkkzGOto0ZbSx3To75iaS1TI0stY3S5k=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2464.namprd10.prod.outlook.com (2603:10b6:805:4d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 14:01:23 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::60b7:cbb4:9c88:941f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::60b7:cbb4:9c88:941f%3]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 14:01:23 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH] scsi: core: Remove include <scsi/scsi_host.h> from
 scsi_cmnd.h
Thread-Topic: [PATCH] scsi: core: Remove include <scsi/scsi_host.h> from
 scsi_cmnd.h
Thread-Index: AQHXrArnJVgLsRYZV0CBosL3YiUNGKus9+eA
Date:   Mon, 20 Sep 2021 14:01:23 +0000
Message-ID: <6491CF3F-BFAA-4EF9-B230-75BE1701F80C@oracle.com>
References: <20210917212751.2676054-1-bvanassche@acm.org>
In-Reply-To: <20210917212751.2676054-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d1c492f-58c0-4075-34c7-08d97c3f218d
x-ms-traffictypediagnostic: SN6PR10MB2464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2464A0D603A1D9B75EB985D5E6A09@SN6PR10MB2464.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /0RBfB6WOETP+YIaeywi7lUGfmfEOHEazA86eXaWTYdXTI/fZwmigo35Dhm7BhjOC7PfrEzRa1fubg18e78AqgvD650J33sZF4fguZT/8Wmiz5b1feMCE1SFLWs72dPdDqsG9KHkPG8I82uhEaDSqFS5Hyq90vKGUDhWaTgcGyRvanCrDS+eLDqz+y+7EEDixmQFytj8H10YqBHiRtRzOQ+JoM55JSpsNdaEn2qlHEngvAY/CZXv6VU8YMND/9+RcLeF0rjT/r4UiN/hXmFh6QLThs+M+IUChct33aDhO/X/L0/XMVEq6AM/V6Dmq5LI+HiJCCxnsH2wZPO9kLhpvZVUxnEPoY17mViQZ2HBCBaJx/T8wv33HkL50W2Sr5b0MUEXlJefqABMM8DFPETdNQUE2+VbZbu0hMocejYVzyztGsKR+1PlnVhhoiSWkHvj7rm4ZOYn4yrZXzfmAAo5iXI38S2wC26SLoSqkckTQWdthq+fFs9sTbx+YEEF3tl3AseaHX1YWW44cmKnHiT8mp3xVVJ/N7gbmtGI5AIPKm1rcjTZH+OyMWpApdHq/laJgwC5YiWS8aId5LmH8DV8tOy+lki7cQBk8ceEmVlidY/hP1SxFytklp4vgHmhp5aqVJVW4W71QrdSOk2QpMpKtc54uJciOqSekeYmTbab8CD4AeClaLawk/J7Vjs23APOz0ufmnb7aKYm9H1qEKHEhqbHbNowHbB8t51FeWO0VQNkemkblIIFt/jYHe/3x2pY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(6916009)(36756003)(71200400001)(8936002)(2906002)(53546011)(6506007)(66946007)(186003)(4744005)(6486002)(83380400001)(38070700005)(4326008)(2616005)(33656002)(122000001)(478600001)(316002)(38100700002)(66446008)(76116006)(66476007)(64756008)(66556008)(5660300002)(54906003)(44832011)(6512007)(8676002)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZznaKWJ/H8sn2vOXMX5OQ6ux/8hxaZFCHO7j59iTolMhIUSzCpSP6RVJxJVs?=
 =?us-ascii?Q?uUA4Ua0EvqyFXmfZa5Otu40NQ6P5LLeNo81wl3x+5Oe/813ngAt9HjxwcV1I?=
 =?us-ascii?Q?fdusZiFUFIPIYZeDhBB9tDq1q69SrYQn71hv+gF9yacjGP1fptC3p+xWK9PG?=
 =?us-ascii?Q?DiSQ9IS29kPzCIcu0/Os1un3aap6VIZ5Am8i0vKM/kWpvbAZpPrSgnMkoxO0?=
 =?us-ascii?Q?F7AWVO7C4N2MlWPcTYHIvHG1AYIdjEfjSE/1iFg+VyV7Q4bWUOVay9yBCjMC?=
 =?us-ascii?Q?/NGbJKhdPf9Ehx1Ma8dADCR+yXW2rRm8p7HhG6C0dyqypj3rFvhzXmJB0x1P?=
 =?us-ascii?Q?tlfiHf3vD34hVBYSfo6odxqNaP5DMXUGfvDio/sZXQzpW+yWfzEqMAw6mPQd?=
 =?us-ascii?Q?dnK2Ybp6WB4nnrE3jnSF4bgas5zGQTt4sTkfkOpASd2YMehieemFWhT+kB4a?=
 =?us-ascii?Q?mAE/D/kK+DjcoAnEB/ZvYJwP/lTextayeTmtDRB6Yr4BjLKFpbqbEmwt2v1x?=
 =?us-ascii?Q?JYo1qEmUb9SbkcDSztKATlpLgSU2EFWNpDqnVqBQiHuxIQJPWNPmFCWpl7gZ?=
 =?us-ascii?Q?cy/VD25oR/CkL4P/XZMe0NlUKc08jhKn4jIelICaTXH3MqB4Jhu7WEjxpJgN?=
 =?us-ascii?Q?U/XtqQhDhoeL+EPT7nc1N/VnXR2Fu1zJ6PSuAXijNqX6pXev+bbjvQ9u73xo?=
 =?us-ascii?Q?kGaZFlSYgTpZ3zX1l5QRnoBRR90+l3T2VlSbAS9Zzp57WaCvGFoqQb+Jm/hg?=
 =?us-ascii?Q?x+1FKBHLpvv+j8n07OkNjgKIulG1uqqIUVontnsbHpHW0lAtXnkWaXydLyqw?=
 =?us-ascii?Q?qBGXDi5KDiYymRIBbgqgEbzQbi+cIjzR6ZkiY5T1YgiaWON4jlaUCdcSsvQv?=
 =?us-ascii?Q?w5kPoHuzY7RQYvtwg0dsCxYRj2aBixty/0B68e6zAIJXX47RsMu0FDeHj86N?=
 =?us-ascii?Q?KSmVkYgRo3Z5GOgOK8mjLNFf5LoDqyxWKaPFeL1uNpyzWVxcDSMNZcXyBtBZ?=
 =?us-ascii?Q?d924MBMYxA1lRrTQqpo0ADPA2HKh6wNNbn2uSzYkPYGrJFA1xfwILplI9GfA?=
 =?us-ascii?Q?mhBDbN4IGKRwYZUQ+abqOhJVBU79jRj9bpnu9YgQ6n83c6ighlwvFJoClsIq?=
 =?us-ascii?Q?4IldjwyTLB9++g6/uyQVRIxlaN1U26XfCdFS8RsARQqINqiP0zX3/UqAXCvS?=
 =?us-ascii?Q?qUJU990ncacRkmO9Udu2yJ5rwf8qCUBCoE4C3lJYWFyf9LJxz8RstVAjOgYO?=
 =?us-ascii?Q?i9Xk8BmQLLEWH0TC3UMs9TrEyPW0PYfg0I8Yv1uy9jl78+zRry0y6nifEtPk?=
 =?us-ascii?Q?4YyvXPB5OXoMTXIzgBc9ltI+iMyj/6MQGr6SHSqn8889YA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4DFCDEE10510CB40B37E73584BDF6874@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1c492f-58c0-4075-34c7-08d97c3f218d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 14:01:23.6102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RuwagWuJt1g6IWQVqx8g4663d6ArqJ51iSNe6p5AWDk6kAJ3qSzb8GiQTNhxU/oXbpIgEzDV+05aQrYAuBY2uwMAm9n5hmhfEUmBUIihGTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2464
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200090
X-Proofpoint-ORIG-GUID: Sfqo2_EJt43VvhueSynH7cUmxx-oQHkd
X-Proofpoint-GUID: Sfqo2_EJt43VvhueSynH7cUmxx-oQHkd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 17, 2021, at 4:27 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> There are no dependencies in <scsi/scsi_cmnd.h> on the <scsi/scsi_host.h>
> header file. Hence remove the scsi_host.h include directive from
> scsi_cmnd.h. This include directive was introduced in February 2021 by
> commit af1830956dc3 ("scsi: core: Add mq_poll support to SCSI layer").
>=20
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> include/scsi/scsi_cmnd.h | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index eaf04c9a1dfc..a2315aac93c7 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -10,7 +10,6 @@
> #include <linux/timer.h>
> #include <linux/scatterlist.h>
> #include <scsi/scsi_device.h>
> -#include <scsi/scsi_host.h>
> #include <scsi/scsi_request.h>
>=20
> struct Scsi_Host;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

