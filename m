Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08537C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 22:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiBNWCo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 17:02:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiBNWCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 17:02:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D373013A1D2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 14:02:33 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EIPqD6021228;
        Mon, 14 Feb 2022 20:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=akDrqSovx5OpJ0yoHMbwA5uIcl+B7gat9ykysZlYr84=;
 b=m90ySXuGw9VttLwIq6NqhONMfEl9V07b07rGy5+zisiD9rauVBVTGff6SRLQ8FI3OCZa
 /rWEHXlH+UAd6ridtjMAv9qtyfB+a0uTYBm/9KnkvKviAgIHNEswXc4lZfk42rIY9i0h
 BSZiLA9V2eXoqDbQopTUqxWdpObaEeyIgt6XM+xbuCuR//QyJYTZFcjsNQFs9VqefyIU
 qO4+71da4ebXX9vEs+GlwhI6qV8iV3YQf6UONUuGGQ3qwYiWnyENdaWwBk47WEtQ3AVT
 4t470BjRr4wlphIOrlzrzoRLzkVMVLyhzV7pZXd/DGIDX6Z/LyQqcQYVEgexet229Rf+ mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63p25rb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:00:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EJea5f169389;
        Mon, 14 Feb 2022 19:59:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3030.oracle.com with ESMTP id 3e620wg3nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 19:59:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQ5ZxWsSsImbbH3HI1u+Si3tYP8rwv9gCxMQbtlpD6gJqAQ2FOApigdnBx1JEXrRTKjW7umYbInPHqLpHJOfA/9qRimutqDVMCiw2SHN6Q5wdwT02lCdppF7VWLuWJvk/dkGUidy/8fv7hbfxuhcZagrEHBKN7zx45/4eIkcgznC4gBWRQPmrIOiOBEkRc5gwii3160PBqWAIhBrL0Kr/3Hm1mHo8/hdYVhnT20psZ7+bb16qz5HshZRocp37JxSIAbk5IjRHvjd5LKGNwvgqZkaObdru0v7Aj8q3NQjPmjUcFhMmH3e6G9dduXgs8MRoLLUQzVsnyj/WCsES4GfIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akDrqSovx5OpJ0yoHMbwA5uIcl+B7gat9ykysZlYr84=;
 b=ZTlEbqRa09aEPCm+e5p7X06uwwki+ip9f3+5vg3JWrGiEmtr7AVdTFdGRo9qXW7pMdFtdLF6A8CbZll3Jlx+wCW1L4shde/BgfqIIUffEA2wehs/Wd2WaKeZWhRyLcIPXstUxftMlrX0d2CxBZeKMQW8G/QVBME1A4qhSnMc4TCtysk5+ENRQLCX6Vwco+t8PJOCOZ+ahkkNzGNecsNnb211S4przFXY5VkTcbhfwQ549gQCWAnSqFmQv6v9o4VhsA+mvy4aM8STFTz3f0n/Im/AnWMwuedOr4FpB9ZDneQpacoQKdnL6Ca7boM0iZQyIXMYx8g0SQCGFqVrRT74ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akDrqSovx5OpJ0yoHMbwA5uIcl+B7gat9ykysZlYr84=;
 b=oxe/QOlZxV+7kOdwJukQqPE4ENppDjG72MwnlBdhjkbsheDampc+RFmLg6zNYuHVvIt9dbEjlmaeXND+ETiui5OZbzLDSuEJAMP4hUOWFSB2iI+QPi3RkofkbLyOWfgJLDB5VzCryvLyu+DXGHU3+1t9gdxl1ioiQJnPcoOOMDk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN6PR1001MB2212.namprd10.prod.outlook.com (2603:10b6:405:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 19:59:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.4975.017; Mon, 14 Feb 2022
 19:59:55 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 01/48] scsi: ips: Remove an unreachable statement
Thread-Topic: [PATCH v3 01/48] scsi: ips: Remove an unreachable statement
Thread-Index: AQHYH5dXWuY6Mb0ECUu28st8c6/D9KyTe6wA
Date:   Mon, 14 Feb 2022 19:59:55 +0000
Message-ID: <593FDE04-28D6-4D7E-8D62-D48AB503D406@oracle.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-2-bvanassche@acm.org>
In-Reply-To: <20220211223247.14369-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 158dd757-3f19-450a-914a-08d9eff49285
x-ms-traffictypediagnostic: BN6PR1001MB2212:EE_
x-microsoft-antispam-prvs: <BN6PR1001MB22120ADACC5E7823FE5432A1E6339@BN6PR1001MB2212.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iAraypElgFyWNctz2KieQw4BhQBWrAP5MWBp9AO0yw4HjpJPaqQd2hPeJ7+/FRV8Lbr+fGDFTNgBx5/CErIHBK+YIzxFRU7Gm0S9ygqbL6PCkbOzGNasb061EP/vU5BV29F+nRvW6/17cDCzO4h2h11JoIHulA751WcX3Tdh87B83pJESNl3RLqkm0z/bH6FbrKi5VUCdrLJpd8PoZCTPCntuBg0UrsDu/m6NEL9EERKLQQpV9RgABoa3OyJVH2OIR5RAcErQpSHEiXp6AX7pQpHwe+pv7tw+LNhxQhu33dQ6crT2SygQWlb8320lPBf1mf/AlLm0nu1xBqT0Jc6wfzXeqFPwBSe5HDlf7YPtHwKhm4Fts2XAzyS7X9XYfP98vSSq063slR92H/EttyIDN8ug52abibeJWbze2S0AP5vFJ7f9sqp+cfuIZPCJWM0xfr40G6OCI5P1Trh3i5Tk2YXjkZY963isbXdurp38J4EiTxKzSNo3b7eAdVjua1AWKBs9jRJJwNlwBtiWuQ0PV+FpYk08Sk8Ee5GARFWy2yjTIE5fj4xkrpXek/T73mMMdiuWF6bgpzd+l7PnPE4aJR9Ta0zYASamrY6q4CNQBbBuCUaH0TMK/6MeLzoCv4pDdzyVXuTUEwWMnptJc8NIuVGFKrfsWpV049xH5CthM/L0lQwlPLA4hEISnU0E4MGwPCgj8x1RaXvmn/gGx/sHyF8UmaVmAh56UYqxRtxEgXvzSPNOtJvmLeFtcU+jeTr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(71200400001)(38100700002)(38070700005)(4744005)(44832011)(53546011)(8936002)(6486002)(66946007)(76116006)(66556008)(36756003)(33656002)(8676002)(64756008)(66476007)(508600001)(4326008)(66446008)(6506007)(186003)(2616005)(316002)(86362001)(83380400001)(54906003)(2906002)(6916009)(5660300002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FA0Nj9S8JvLiefXPGX71raquajZPBvvaFrEJ5EVfreLWS2XwZH4+aY+WQTAp?=
 =?us-ascii?Q?LKG3HIzO9fiMIQhzNoBjhnSiFF7N/gbKfNuwl03s20zJZ1EXwxHUzwz6Gl7g?=
 =?us-ascii?Q?JCJdQXjUXz/I93qRgh0OufqKdv06CxsW8Rnjee5QIiYbz3k1lGN1n1MOiv3G?=
 =?us-ascii?Q?OYnWwBWVdyv1qcfZIJmXyMFFtl51c+Vm4OaIV+0H9PJ9a8P7v214bEUZOV10?=
 =?us-ascii?Q?g88uQmUu2p2fmjpTf10asRfdQhTYujgKEHcrHeOCy/0abuqBc3DOexTPpNm4?=
 =?us-ascii?Q?N4a5mgNgE73Gq1qLibfFXxDKcgAZlTj7KOKFi8z7XpTCPc/FAxs3/NlJ6S5C?=
 =?us-ascii?Q?mXbGF153BbqB+PafYKmekCfbfb53DAmo1JoZgIpeQlHH5sfJU4ReKoBWyrIJ?=
 =?us-ascii?Q?5FXATGqhz0S7mS7wMcVAxw0aDuNWWwrPFkUe7y8/aJWs/sYa4D3AF7KLz8R0?=
 =?us-ascii?Q?ZK+OkIiif/zSUN+HYCESwDwF6tkvfUVXoOPTLnF1eMyPCV1Qf45fqZyW6Yyd?=
 =?us-ascii?Q?K4qMO7jX+wN8qWH5NUylS+wPI4GX/yXf8TzbX252F6ZNu3wZ9GWx7pCOjAk0?=
 =?us-ascii?Q?PQUgNe3lRQrenlomnk1MQWsN0M7DOYO4qhrLMEG2m5ByYnJoyiSLMBfVg0P8?=
 =?us-ascii?Q?hOj4MnSfEgWxawKRcauVq92LVTEan+VANxru3Mk73NugIRgalYQ2sRUNtLKG?=
 =?us-ascii?Q?+loKzREUmOhd7M30fr4tcUVqvcD3zV90mYad0Q2Qw4HEEM1Olxk2S2PInzvd?=
 =?us-ascii?Q?8kL6FYgMdSCAIq+t9ct73FPf10R15s1K5FICOsBIOcD+qtekBVnnQhTK4fcj?=
 =?us-ascii?Q?cKt71mZl0AaFltnjiffMAUDaFivoqReqhEUiqtXzUP4zjQ7T1KTlXOna6mpd?=
 =?us-ascii?Q?YXFHFYHkS3sWhQ4M6v/KUQCEPqJTnr3/kHLmEo1lg0PmVStPEhAl8/c+iZl4?=
 =?us-ascii?Q?nBoo8SP9S98Q3tjpZvQM5/Qt5B+kCRM5NTSGvBHy5SmZvi3T2VmyMyQ9aVeX?=
 =?us-ascii?Q?BkjzxzIKmx/Os+1G0Wz3b0PaoT1+YoQSfsiWcUKyRhEoRP24GHTf7Qy4qzSQ?=
 =?us-ascii?Q?hPWku6O3jRZypbUbdsw5iHYGWcGzpmyE4xEXBotLkVsrEzHxYv9SokqFzc8G?=
 =?us-ascii?Q?PUPszCdQvmrSDdmlzgmFOFLUPjwuZikSRZzguqLB0snGD7Lv6e/ZmE+GYZY8?=
 =?us-ascii?Q?XiZaJWvMWDCipPG482bvWBSA4sElDWYc0kPjS0XjaucmRCEgEYF8XinYVLu+?=
 =?us-ascii?Q?kHOOONHLr7EI8FYepjaRo/6qfJdj0De4ctTpVCubVDY4ABaH6jtl+9Hf+yeJ?=
 =?us-ascii?Q?7akIQUYpvjSFONO+zxov/Rqg6OYDsLZi4cDmeb9aJD0OvSkKbeQC0AH06W6X?=
 =?us-ascii?Q?J813D507k9N8rYqH6ZKzbzXa0IpfLW1p14ouY5tqexHt0nwuPKvXMoYIuNKB?=
 =?us-ascii?Q?CGXK5XFI9mURYJhXFpgf0ofm5iFUIt5NA6XFAAAUFmGNL0WpdfGgrTdG6Sdk?=
 =?us-ascii?Q?QbThNsIdNL4eZwXZwhO/fJmL8oeE1TO8BXCUYfHmiKScVhrBOKv9UDi5tcAh?=
 =?us-ascii?Q?RzjuPapxnJNzKDQTtUFbqSE7OAlBx+b6lXEBac6Cf0z5YRpxQXhyGRhM9+6/?=
 =?us-ascii?Q?nYdpSb6RGPc3kZJ6oTcy4hoXZ0+SX7OJiGPhc52QiWfqbcamzObsMcyhVvcn?=
 =?us-ascii?Q?BrjaiAFsC7T8PSEdBhydRYVP+4lWDJAGfA+F9zSQWIXMMDI3?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7193BF88C0F6F54B99C20CE0851EB6B1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 158dd757-3f19-450a-914a-08d9eff49285
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 19:59:55.7671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sSt+zwxvWJN87HYTWUI6/HkyC1fqQo5dsKgNsBH7FUBVOtrwLk/ApyUJchS6oTDIVFsjoc5KT3/Wp08aD1Xiz093hDF8uT5xhwiZHwBJWp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2212
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140115
X-Proofpoint-ORIG-GUID: vdiT748mVtojz15gc_5tWfn8JBsn-ZbJ
X-Proofpoint-GUID: vdiT748mVtojz15gc_5tWfn8JBsn-ZbJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 11, 2022, at 2:32 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Whether or not CONFIG_BUG is enabled, BUG() never returns. Hence, code pa=
st
> a BUG() statement is unreachable. Remove one such unreachable statement.
>=20
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/ips.c | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 498bf04499ce..0db35e97ce8f 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -655,7 +655,6 @@ ips_release(struct Scsi_Host *sh)
> 		printk(KERN_WARNING
> 		       "(%s) release, invalid Scsi_Host pointer.\n", ips_name);
> 		BUG();
> -		return (FALSE);
> 	}
>=20
> 	ha =3D IPS_HA(sh);

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

