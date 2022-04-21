Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A5EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 20:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392191AbiDUUIg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392190AbiDUUId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 16:08:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71164C795
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 13:05:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LJEAwu012431;
        Thu, 21 Apr 2022 20:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KaYhmV/T0nu15lF8uMdUH4ekg1HsR3NVdJMH3rgwuFQ=;
 b=I5Cspke5bu2GSTm0snybVm8nE0JKGYdPCobU3b4fRAL6iprd/BQJhitoR/+tHT4BPV5w
 rbqSW3WTRVLyyvSEVQV4nixm05gF3xAOJ4ARhLT4RX3wqQ/PY5xPGb0AeWvyxqDJjUGb
 mtbQVFnVd91lteF14h5QMKisltYKbLc6Q+Kj52kqqDfg/tERlX1mYisxj/iyx1GiChEC
 ioKnJQ2XLFBublgzPNwMASeoNSflPIByBAJgdjBVkdtxZJCZ0BatPd23v4F8qigbXmmH
 hvq2Yo5qL6vcx83fJdbwbuvJRMrKzv/mW7NTq+jL1XG+DE1jQkj3yl86ND596i6wPidI Kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffpbvdcb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:05:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LK1qs3030315;
        Thu, 21 Apr 2022 20:05:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8cg76t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:05:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVsgS6U64wY/zo7odpoh7794tyZeW7hYznL58wHDND9KnfO62ixJdzLqv1URxYPFAkBcMj08z1dp7qOnOZjSRzYFxfm0kEiOAHWmEWYWCLl3l+CnkPz0fyOhGBXVog3WkgpdzQ3cvcUaUH3Mv0Ppvqdda77dkQ5pmnJNdRZn65NuAohKk2S0hlNLkp8B1U3fUQiS9k8HRHSym5wcuZBDeUi8dEBinCzTSK3qCLmpyBxjxnMfLfHvaMmhbbDs0TdUhbQ9bXZ7nZF0dm711dDsTL8W/vlWUntL6B3GzVT9DGjcKbbFjxe8hqMkzr2liNY+wB/QtOl1N31lqh7YJeyz9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaYhmV/T0nu15lF8uMdUH4ekg1HsR3NVdJMH3rgwuFQ=;
 b=mspBlNkxwcvnlxZiZXjbxztuzx8cflJz2IKGS2vGvSqvPVNmluakXvv929dQZi3oR4apTgrELbO2JIefIxsUkazV8g1uQRgYMajilwhuWNFD3qD4YbCZF2t4V0CboXVqATeXGOKEQk32hG6RfvWlFfCY3L9RfqDszsceAd2KzYdFLD9/NAi24+1YgQpDSLMO6i+HNspqJdW/Gor2IroGBTJlYwLocZ0NaelrgHI6O6trUkdz99UhJkPMDYXiZA75Zj7Px26pjEShihPfoTOKWekcBSBNuRlLF3ercFDaBnAn0odAKquee5X4Jfj/PJBZ/l9d/0D4b2CnwodxL8NNUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaYhmV/T0nu15lF8uMdUH4ekg1HsR3NVdJMH3rgwuFQ=;
 b=ViYav6AxbylAi5SUQmJZHV/Spapm2x94YRXQ2h9mU5xFfcYXUw7sJIW3g2geiQHenRqRzSMD39HqQIhC61A/El8gcyjBHo7uxaNbc0uyxDT6aLKJ76u0OODo4Oq3HYU2tWjf7bBL5Cim1ODRaIj4bGZB/kmlOZPJt6sFBdxPOgo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3180.namprd10.prod.outlook.com (2603:10b6:5:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 20:05:11 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.026; Thu, 21 Apr 2022
 20:05:11 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 2/9] scsi: sd_zbc: Verify that the zone size is a power
 of two
Thread-Topic: [PATCH v2 2/9] scsi: sd_zbc: Verify that the zone size is a
 power of two
Thread-Index: AQHYVa4/85Q+r26YpEKwdqQoNlIsK6z6ytgA
Date:   Thu, 21 Apr 2022 20:05:11 +0000
Message-ID: <9FC1E112-1826-4569-9999-C28DA79E1C3A@oracle.com>
References: <20220421183023.3462291-1-bvanassche@acm.org>
 <20220421183023.3462291-3-bvanassche@acm.org>
In-Reply-To: <20220421183023.3462291-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c7acd29-3ee4-4950-b6e8-08da23d23de6
x-ms-traffictypediagnostic: DM6PR10MB3180:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3180D4EAB999212889889F5DE6F49@DM6PR10MB3180.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LmCan5n1uouTIgO+16h0Q5ks4tsPbx1LBpepJwSiKcZ/HH+EcZRi821KjHQ+RqRBZKNJrJ9yPxn6CICcHv9NrPSyARUR2QiWBFSWnXwG/ZcEjNyeV95pN54J4/vM+BoppgfiIJlebyfIWZrdOUxOiW0geDIUmEunVlm9oW2NuwE6HuIZIUzBOt4hIxZaWl4tart1uAG6CFqJ/ZyhCqqBGC9XHIBVEwhIOcI6GzdNkb8fPoYJFQmPb1S7Vbk2JUokYTQajDKDUM5269XZOXKit5055qUXgI84SR7PxwHYNTKKhw/+uHqFw+ZSs8ALIvRvX809VeySu5zoLkdTuldiMzbtdzDQbrFBwg5i3FXJkI5mMZzRZbj221Ybpl701txwx8QDKDF+z5H9NRuQOguoFfAvry0qkBwn34lWGUkKCwjaA6Oc+1LBVpl+MRVQ6lv02LJDHYZ3kU0L6Agmr1Q994GLU2adp7M23qgZy92u/zSs3BDWJAJlAJovUxn7HHXsEQjhR1NPQbi5xd7rJ4alM7Au3sY+0ZtPZDrkdIvRqlVLmuwbJRaAwMMq/JEesh8t8Yf6cwu6gN0TroEHEfsKmbfh+VU3EyDK8ejkbE0DNOgnRiQMFesLt2ys0LVPBmrqG6cn/XR4G0SCwcdqWSxYaRi9TgttPcfORh/BT6lhb6ifrtubL+NzFtlQhN8TaVhTmuF7Jxcm28VUa101JG6xhoByiq7kWpchJL5r/FXFTwk3nkEfYyNkAjKqTJuQyHKx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(36756003)(26005)(186003)(83380400001)(122000001)(71200400001)(2616005)(53546011)(38070700005)(38100700002)(66476007)(5660300002)(66446008)(64756008)(8936002)(6486002)(44832011)(2906002)(6916009)(66946007)(76116006)(33656002)(8676002)(4326008)(508600001)(6506007)(6512007)(91956017)(54906003)(86362001)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TPSL5AiYKocsk2Vn38ftvnIilL+SBcd7chFqX5bj/MvVVaWPqfkJk295ttMC?=
 =?us-ascii?Q?E1wASt6IWuRtAzm2PS/R1YufS5tGJQcslGLVTn6kpwRaqEpQA2XfNDci5YvY?=
 =?us-ascii?Q?nWV67cPZ29CbyTus9IdS89zVmJQ1J92xyahK6i+y8Vy5QoEcevslc+Fs8+SW?=
 =?us-ascii?Q?61tHvWg1xnUw80tb4ArfUnQDbWUrPFCWKlcwFh5myRqDmadkmVGxeHjC1bx4?=
 =?us-ascii?Q?SFNQ2xfC8b2birAmcfo+WwrSD7n66gu2F78W9LS5gWs2eDpFiHnOVSsB6Imn?=
 =?us-ascii?Q?9wghwTcQumblWVfNwjuauA2HCN9iwpXgZCf5MAXb2sH0iuGpdiwkC+EpsuU6?=
 =?us-ascii?Q?uon2OTcKX04k14FVuKqzPfyRonkiB7Yy8XCNBLr2zwa0X++IpY8vlUrnHy+e?=
 =?us-ascii?Q?jjnoyBnAnMm8zbGVAQljIuX+9b9wGsmXS2VMth0Na39XLBmsaSQxbqm8ICs4?=
 =?us-ascii?Q?9RsQqZfrR8Y4I6yLaa1ZALgnpxTqDCJD1vweW3KSNBvJEfrJ9miqMOCDyZzI?=
 =?us-ascii?Q?zQdmqk7XzYURRFLmvLGcL18Et0I37iJrzbCY+dqFE7K/asYEQJDPYUQhSh6E?=
 =?us-ascii?Q?4jlkboyWilK+0GIlWur2TDL7HjewuI5FReOFzC37+IjEMD6gn523pMImspQG?=
 =?us-ascii?Q?NyF7xxXm/faL1dZnprcy67LoR2pPLkSuh92sbuRUjSWDCxyB954b89IUu6Rw?=
 =?us-ascii?Q?7lK3pg09ex8sv90ukOGeVZHoHVRciOOP9Kzqc8mIPOA5PJXpW1F7iTQgPnlr?=
 =?us-ascii?Q?KogXIecp7T2FHeUJt2SPpGnPR4VWIKpiV8KMotSzg9dRFCBAj9HLH1njdM0r?=
 =?us-ascii?Q?hNN1kGitAh8/YqaS5DPgBGRFIUIf+CkT+yERoLSKBazsY4SSF3fSG6ss/wzw?=
 =?us-ascii?Q?tqsq3whcNGxgw1VlqPeQrPKt4zr3z0MtW5+kmBx9PW8U6IDF1TR/35oer/yC?=
 =?us-ascii?Q?5u4xQ31MkH0Ef1Bz3Y1lywqUWe6QMSQvEbQu7wQ73/CwLUKt4y9jlAnqLyb6?=
 =?us-ascii?Q?fZ1NWJWOUhpavIlCBUCjc5qqVCAqATqGUZ722PalMAiFsCYuoa9y6vNM3Np7?=
 =?us-ascii?Q?S3Gr03cC1bMSETg02kcVcJjMeeb9Utv5Fg0ICX6r7GpMDZ8oky6v3lQmL+DE?=
 =?us-ascii?Q?Y4DbWAiW21tKsXV34SZ8G8GBDERCStmA8QAKmWY8kOyY++cKyf23d72bGdxs?=
 =?us-ascii?Q?CT7covNHlJX1/NOmSG1bVO2ExYJ9FcAf+y+JcAHsurd0klTANy4EM8p3eQ7S?=
 =?us-ascii?Q?+a+HlF07PslGZMddALtVBswhOaeN5J1pMW8efstysljjjtjAVQI0zqjaLyPq?=
 =?us-ascii?Q?3sdnPsrHBSJ90EHNrgTVB6h2VfpaBU/BJSYUmZL2XEd2BWg3k4/mPFhwhqoq?=
 =?us-ascii?Q?af5fpJawQKp7aP0NHbHqhKuUt4gVwrFbFhXbwXJGqovtB+wlK7FKiPcHAjNp?=
 =?us-ascii?Q?lwv8ehKGI3qcynLWW/i7aLHLNc3wwawiBMaRbw6jH35zTu1zSw77G+d0PiU0?=
 =?us-ascii?Q?jnbL0uzNtTIlQzRtUT9qzdl/LNH606cLeCYSftEXikrd5vT7FqxMr8PQZqmQ?=
 =?us-ascii?Q?bt7GUkwTRFXB7pCgeM3V5wlbXLaG6+p3/AzBgCKa4wZoZWkFR4ARR//lJYiN?=
 =?us-ascii?Q?7PwC5MbRhL/StR2DhdGEJ2PkhHqWa0eW78jblEp1pt9XpqO5D8FIOdgXJCDw?=
 =?us-ascii?Q?3iGrjkybLp2uVlaiVUlpwaN44X8JHKTtFzoHd4dIW9vH/Y8hTILvqGwdMNXD?=
 =?us-ascii?Q?JDWWQX3O6DKGPWMWgXoe7I6OKhZojI7Zk0sWTZJN+mh2nUZYbDJk?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <019629839EEC844F886A91A75F45A1DF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c7acd29-3ee4-4950-b6e8-08da23d23de6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 20:05:11.4199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GetqpXAP8vbXEuQbg3T67DWjqUZkdGji1K5dQGWGpXGLBu9gfmquQR9X8LWp1LLQ4y2+knV8X4R1soDxGqaW3SSo2EvZjMtzT2DRkfvZlzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3180
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_04:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204210106
X-Proofpoint-GUID: lhk0F4KiSH8UEJzgRMTeYzqlTRlezNQf
X-Proofpoint-ORIG-GUID: lhk0F4KiSH8UEJzgRMTeYzqlTRlezNQf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 21, 2022, at 11:30 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> The following check in sd_zbc_cmnd_checks() can only work correctly if
> the zone size is a power of two:
>=20
> 	if (sector & (sd_zbc_zone_sectors(sdkp) - 1))
> 		/* Unaligned request */
> 		return BLK_STS_IOERR;
>=20
> Hence this patch that verifies that the zone size is a power of two.
>=20
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/sd_zbc.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 2ae44bc52a5f..9ef5ad345185 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -664,6 +664,13 @@ static int sd_zbc_check_capacity(struct scsi_disk *s=
dkp, unsigned char *buf,
> 		return -EFBIG;
> 	}
>=20
> +	if (!is_power_of_2(zone_blocks)) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "Zone size %llu is not a power of two.\n",
> +			  zone_blocks);
> +		return -EINVAL;
> +	}
> +
> 	*zblocks =3D zone_blocks;
>=20
> 	return 0;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

