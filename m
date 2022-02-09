Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30BFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 17:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbiBIRuD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 12:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiBIRuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 12:50:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF25C05CB82
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 09:50:05 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HE2Ui027620;
        Wed, 9 Feb 2022 17:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7lJyazee4uc9LpwtFDDtTgJnCC/rb/JV4rDeV3v7sWI=;
 b=CMU83ytkU7VsI5K1iZzOQkkYiS4Us5p9KFJ6KWrmFIGGU07iM2TV5YoWl81DBQYfchGV
 dbNj0hz8scj1xIlFCVO/Yv7ccMFHXs+LfPRJJpspXeeNyZrmFIUZ813l0XAmuKKLadl8
 ibCtawig6wSaZL2GJImLA+qlVz/o5hyNIS75M62bgTihvOqu96oecYlvtdCyMsvmN2we
 vOutyUZRl0iqw4ruWXef0Rqukr1SG7aQsmOZnPz/CN58WkwqK2mUzE9d2gowqe6LYUY5
 XottU4/FuEauPcTCv86mrzfW2ZcE0v2AFkNv/9tv6mumodGhL90OtS8Ra2t3orE8VBCu 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdswads-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 17:49:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219Ha2oZ011022;
        Wed, 9 Feb 2022 17:49:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by aserp3020.oracle.com with ESMTP id 3e1h28p8rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 17:49:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkhUdq3UdpaTSLJnO+k1f6P0CcC43sh81kddciu7JF6e1qMR20/bR0CYrxbFh0m1scFw5Se71SM3p15Y0F9EVgOf49fKKMyeB/YT99Ux33+samygF/idT1CDmrTalEoS+y8U1SJ53HbGrlUuuOU/fSsRIvtL+ddp4pvTgeD3ohJyR1Qbar5nhXRaN4ffBMtud455YjM/gwUrxdsjCCo511rCS9UFZ0q2yJyOpinuxMgd7VLZuZjvBO0FusKM+guYsKOttjEflA1k3kdfTF3zdo/KYvfw4FCXWXmCpTjxV2lOvhZMEaxNEdyUoS75pkcfVG5vm41NFuLjd/DB/bZTVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7lJyazee4uc9LpwtFDDtTgJnCC/rb/JV4rDeV3v7sWI=;
 b=R0ZmNoIRAesmRrhb1K9884Rosm0TiwyEGXld8mUHxUh+vyHbnWwYkf/uACey+oPB/s0iHF+QvFlzsSM9FFW40c+ggtaLsK04jgnua/6EU22Xc+R7PF1x6fF1pTakpZtH1ygv+tmfCcl4qK14OdjYb0fdMcz0ANN9dJ1iKYA8SFpyyFmy1Plc3ofUR1qFBysI8wyGH7wcMC71L0r3KkRkP4dC7rmxY80C1WzTgF/emLkZ3bqmX17ODDNO29mnHUwvv18zqqgUlrvJzeMEAowotimPaxkncTwuD0fLSDdugtizuiPKkwSsm4YaxPlEegpjnXVlJsEJEAoSZnzrUlj2Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lJyazee4uc9LpwtFDDtTgJnCC/rb/JV4rDeV3v7sWI=;
 b=TxqMJPOa+h3d0GMmsBm8bcCYqNnRI0+BiRgBahd2gh2lpWyOiSXN64Z0leab8ZcyXoaTuhqjaA8AmYDBwtoZJ3q+jOChSiM39/jazoaNlZcP6aBBfomXLqrh4fBh8jHr2sstDLqjaaonlJrFAtyjjNZAQmnBx1aqXbeFHJrIhL0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BY5PR10MB4019.namprd10.prod.outlook.com (2603:10b6:a03:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 17:49:53 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 17:49:53 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 07/44] scsi: arm: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH v2 07/44] scsi: arm: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHRE2Z/lr9MboNEKdeSJUHqUzEqyLgL4A
Date:   Wed, 9 Feb 2022 17:49:52 +0000
Message-ID: <E50DB928-3231-459A-BF7A-EC74DA1DEE4A@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-8-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2f0f2d2-627c-4bb4-ddd6-08d9ebf4939e
x-ms-traffictypediagnostic: BY5PR10MB4019:EE_
x-microsoft-antispam-prvs: <BY5PR10MB40198A946A92A41E0F373FFEE62E9@BY5PR10MB4019.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pecnqadp2kahPP/C01nZpGOX/zCS6Q1Js9AaXz2GVpKmE8WaDqyggLUfQOz+xx5NqibJUS5p35Vrbz5n/7mJd6jKm6yj6Dp8CGJub+18jgtlNvOMQKaLYZKJ3LGrwyzTCwAgnhFclBFd0SQDq6ln0iMh3Pt+s5YH3HAj+ficS0EcXrCpqDbmh33p1F5dWT+mQCVRvETsl7QAIrK0ztL/w2jxibtQU9g/QByPIV1+JBzXOpkFEsFptk5Iq5zK+8fb1fEpyus/EtTecwAPPv/Fq5FVzMFU1CzFGH7Ft7Av9t6ImXi3nQYnwLeSI5WC5rtywAlzbDKiEvxTFVvNZ2O44I3ufldiFPEO82/E6SKmZvQPcCSBGy/OrXuVv/lCHBYdozKTAVKAg4O64PWn/sWi+5U3YUkfgsj8e4x5TUxW5R8BOmvYMM9rWfQjzOkdv2RFI9g064FSP9BoD1OO4u90HraLb5aLBYQOn5yAXhjLdzHZOBU4IWeow6OU/KNIEATTpoAq4h33UM59dLu2gubW2P6xgtrTALYUzUUP7FP4W5Yy9yOQGUb46amSC/V5P3+WvQGSxPONJsKp63ys5Fj08gKDhuXnIag9FqfrVDY7Gz78NhfX5MRaLU/mLt5wZM+MIJjNMTDszIHPPmO7DeLjo98RA8kqfgI6am/meZajctQ+A/5YJjekf03XcF1z+9xK5rH2F4ReGgv/8fQKuGG7gP74uA86UpY/ZTW8+v0WW3Xa/3dvqSCmakMwiMAlN3g6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66946007)(83380400001)(38100700002)(122000001)(66446008)(66476007)(44832011)(5660300002)(64756008)(36756003)(2906002)(186003)(2616005)(6506007)(6512007)(54906003)(71200400001)(6916009)(508600001)(8676002)(8936002)(86362001)(316002)(76116006)(6486002)(4326008)(91956017)(33656002)(53546011)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YenYcHVq4EBbA/rFq6P1XcqZ3HhSrWDdlVI31HrQGE73p4XMhXoJkba4VZQx?=
 =?us-ascii?Q?0grIpVFz1GI2PKMW+egbG9X0KmuXnKiEIfZwDeLYyUti3v0kbhhFfTy3pNfn?=
 =?us-ascii?Q?kyufioJHZmm8zby35Kb7D5sIDQec8PPTgikhT4C/oUjbvkN3h/fHvbsiP9SY?=
 =?us-ascii?Q?CBt3HyRVNwGJ+hBDpeu831xAhAHckPvbls1Bb6AJwmkjlcbwVr/FkvHxpDlH?=
 =?us-ascii?Q?Z4MFul3Y/p9jmVFh1M+TlosYV6ZpmEPHGhIVq/ATf3n2qt+CLyGqNtdGxLoZ?=
 =?us-ascii?Q?5hPSubtOcytbTG9slfmjoDM/X2Oijq6S4JwIg3C5VqIOnHS5mnbVKxUFAo9X?=
 =?us-ascii?Q?WmRcP6HvZPnhr35bSiXCoG8ozeJC+ibUWlUFMJSRqO+Xco71CvbY8DCKOK68?=
 =?us-ascii?Q?xyOPrgDMdmdswxs/zl49caMrYAm+5pX7qSVnqx7ULnZNAgOd1YpdPmiPLFOb?=
 =?us-ascii?Q?eIr7AtS9FDS1Zj65wJ3y+kU+UWysbjxPcYN+TDzcRVm8E5N0fdMyPjl8R7qr?=
 =?us-ascii?Q?iJNcotytB1Q990oTcx7fle301Yii9sAbi7n20/blLsZxvoiImaYfn18+2W26?=
 =?us-ascii?Q?91l67gCEYOVhqHpEII4yOJ0JlmcGnGoZqfUxioqqQriidecAMQP8OSeP+qYA?=
 =?us-ascii?Q?pFoP0syYyEzYeH231bnnA7chjATckk8LVCaxnoxYtQeOiFgrEz4AC59QTiso?=
 =?us-ascii?Q?3KYB9UixBEPuUZRonm+pbkwxqG1o53onkyXveySgSSkcuLZ2MRMCtdRBsO+j?=
 =?us-ascii?Q?Ct89RQ1JOrBxeBceOOMSbpNnJExJ+K0xPW3d7rwnEGnddY1bRmNBRT4hVgWC?=
 =?us-ascii?Q?FCJxNTZOP/0o6H/65ZAARhgP4AZ04o4Sj4AJ5NW1w3PxIpWtqkeReJlZImHb?=
 =?us-ascii?Q?E8Q9+05uzdOT4dcWIOvGF2P/4Gt7UIvaDKKQlMFoSKyoyrUZikDzszWWVtq7?=
 =?us-ascii?Q?A/obPzwsraOJIg6Ox5VpZaqNcZjVDj9y5zxPS0fAIYVGX/YpQrKO9EiBemuM?=
 =?us-ascii?Q?iyqWWY3ixWaqxLoTZJxEdTcBxX3lBX/h3tHIrkV3YR7v6bXMBHHGk3eDf/dk?=
 =?us-ascii?Q?/R58HJxrqs7S2nEZQYHlcuJeBLn4hcZXKrHulDtZSQdKCHxJBF5VSzveorMs?=
 =?us-ascii?Q?TYYvn2vFfxt9aIk0BJzmZvca464V00hNXwvx3npQuKIxyBzG2Q/fAzAcQ+u2?=
 =?us-ascii?Q?tQ7UVmuiN96fnvXTru0QN++l1OubqAaYhTsCMnQkSNe92xIFGOR3gyVvQ+FK?=
 =?us-ascii?Q?nL/ujhYxrpn+rYgGymKfNBBrENP0ZGK3bWO9RggXpKy8kf28XskfYigDQb5d?=
 =?us-ascii?Q?naglRDp00ohojgiIUMh/oCiQYYwGIKc6tsBiw0ek8dXRn3eWiH7LCP4iFN9W?=
 =?us-ascii?Q?p3sA9vh+lzM8JY508F071HKBpE/T6yvpd9E07Jwm3pMS+hzBuQzPSkev/999?=
 =?us-ascii?Q?aPPrkqE1a9O3FoC3DJqsBXv8bD+VpFX5M7KmhgVCX4N0b6PezH3wW2dg4+PG?=
 =?us-ascii?Q?Ik7qHiw+qEiLKs0i0IhmTrlMaHZh1aeuGiKH3SMSUBGFLZ/kOnRUX6gA+WMQ?=
 =?us-ascii?Q?l3MJnPf0MUhgjfV8rth4gtNSJhOdc7608Sr0Q49aW/6Hu8H0hP88HitWUORh?=
 =?us-ascii?Q?bS6yDywGq+IsDQEcP7TNfvRv7rkVtknGMTEptr88s0R4DPM3LfYdUHnsRxQD?=
 =?us-ascii?Q?KiTRbicq4NZrjmdej7KHyXfDQIUoag3UsBISgM3qZ0xah5rm?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22F92AEA77CB534A92D4B5F5A9CEB887@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f0f2d2-627c-4bb4-ddd6-08d9ebf4939e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 17:49:52.9751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /EmKhfgZKTH2DT7mOL+iif1N2zdVzvNBBTAeEdwF0XaBXV1HJu8timIzRMujTna/Rdc7ayolVzR+1fItEBMAT+i4JNXUo6ScOHhTzkUgNZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4019
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090096
X-Proofpoint-GUID: qv0tHUsfucBw8CfuyNQumm4ORsEus_DF
X-Proofpoint-ORIG-GUID: qv0tHUsfucBw8CfuyNQumm4ORsEus_DF
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
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/arm/acornscsi.c | 20 ++++++++++++--------
> drivers/scsi/arm/arm_scsi.h  | 33 +++++++++++++++++++++++----------
> drivers/scsi/arm/fas216.c    | 28 +++++++++++++++++-----------
> drivers/scsi/arm/fas216.h    |  1 +
> 4 files changed, 53 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
> index 38aa9333631b..7602639da9b3 100644
> --- a/drivers/scsi/arm/acornscsi.c
> +++ b/drivers/scsi/arm/acornscsi.c
> @@ -729,7 +729,7 @@ intr_ret_t acornscsi_kick(AS_Host *host)
>      */
>     host->scsi.phase =3D PHASE_CONNECTING;
>     host->SCpnt =3D SCpnt;
> -    host->scsi.SCp =3D SCpnt->SCp;
> +    host->scsi.SCp =3D *arm_scsi_pointer(SCpnt);
>     host->dma.xfer_setup =3D 0;
>     host->dma.xfer_required =3D 0;
>     host->dma.xfer_done =3D 0;
> @@ -1424,6 +1424,7 @@ unsigned char acornscsi_readmessagebyte(AS_Host *ho=
st)
> static
> void acornscsi_message(AS_Host *host)
> {
> +    struct scsi_pointer *scsi_pointer;
>     unsigned char message[16];
>     unsigned int msgidx =3D 0, msglen =3D 1;
>=20
> @@ -1493,8 +1494,9 @@ void acornscsi_message(AS_Host *host)
> 	 *  the saved data pointer for the current I/O process.
> 	 */
> 	acornscsi_dma_cleanup(host);
> -	host->SCpnt->SCp =3D host->scsi.SCp;
> -	host->SCpnt->SCp.sent_command =3D 0;
> +	scsi_pointer =3D arm_scsi_pointer(host->SCpnt);
> +	*scsi_pointer =3D host->scsi.SCp;
> +	scsi_pointer->sent_command =3D 0;
> 	host->scsi.phase =3D PHASE_MSGIN;
> 	break;
>=20
> @@ -1509,7 +1511,7 @@ void acornscsi_message(AS_Host *host)
> 	 *  the present command and status areas.'
> 	 */
> 	acornscsi_dma_cleanup(host);
> -	host->scsi.SCp =3D host->SCpnt->SCp;
> +	host->scsi.SCp =3D *arm_scsi_pointer(host->SCpnt);
> 	host->scsi.phase =3D PHASE_MSGIN;
> 	break;
>=20
> @@ -1809,7 +1811,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
> 	/*
> 	 * Restore data pointer from SAVED pointers.
> 	 */
> -	host->scsi.SCp =3D host->SCpnt->SCp;
> +	host->scsi.SCp =3D *arm_scsi_pointer(host->SCpnt);
> #if (DEBUG & (DEBUG_QUEUES|DEBUG_DISCON))
> 	printk(", data pointers: [%p, %X]",
> 		host->scsi.SCp.ptr, host->scsi.SCp.this_residual);
> @@ -2408,6 +2410,7 @@ acornscsi_intr(int irq, void *dev_id)
>  */
> static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt)
> {
> +    struct scsi_pointer *scsi_pointer =3D arm_scsi_pointer(SCpnt);
>     void (*done)(struct scsi_cmnd *) =3D scsi_done;
>     AS_Host *host =3D (AS_Host *)SCpnt->device->host->hostdata;
>=20
> @@ -2423,9 +2426,9 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd =
*SCpnt)
>=20
>     SCpnt->host_scribble =3D NULL;
>     SCpnt->result =3D 0;
> -    SCpnt->SCp.phase =3D (int)acornscsi_datadirection(SCpnt->cmnd[0]);
> -    SCpnt->SCp.sent_command =3D 0;
> -    SCpnt->SCp.scsi_xferred =3D 0;
> +    scsi_pointer->phase =3D (int)acornscsi_datadirection(SCpnt->cmnd[0])=
;
> +    scsi_pointer->sent_command =3D 0;
> +    scsi_pointer->scsi_xferred =3D 0;
>=20
>     init_SCp(SCpnt);
>=20
> @@ -2791,6 +2794,7 @@ static struct scsi_host_template acornscsi_template=
 =3D {
> 	.cmd_per_lun		=3D 2,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> 	.proc_name		=3D "acornscsi",
> +	.cmd_size		=3D sizeof(struct arm_cmd_priv),
> };
>=20
> static int acornscsi_probe(struct expansion_card *ec, const struct ecard_=
id *id)
> diff --git a/drivers/scsi/arm/arm_scsi.h b/drivers/scsi/arm/arm_scsi.h
> index 3eb5c6aa93c9..ea9fcd92c6de 100644
> --- a/drivers/scsi/arm/arm_scsi.h
> +++ b/drivers/scsi/arm/arm_scsi.h
> @@ -9,6 +9,17 @@
>=20
> #define BELT_AND_BRACES
>=20
> +struct arm_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static inline struct scsi_pointer *arm_scsi_pointer(struct scsi_cmnd *cm=
d)
> +{
> +	struct arm_cmd_priv *acmd =3D scsi_cmd_priv(cmd);
> +
> +	return &acmd->scsi_pointer;
> +}
> +
> /*
>  * The scatter-gather list handling.  This contains all
>  * the yucky stuff that needs to be fixed properly.
> @@ -76,16 +87,18 @@ static inline void put_next_SCp_byte(struct scsi_poin=
ter *SCp, unsigned char c)
>=20
> static inline void init_SCp(struct scsi_cmnd *SCpnt)
> {
> -	memset(&SCpnt->SCp, 0, sizeof(struct scsi_pointer));
> +	struct scsi_pointer *scsi_pointer =3D arm_scsi_pointer(SCpnt);
> +
> +	memset(scsi_pointer, 0, sizeof(struct scsi_pointer));
>=20
> 	if (scsi_bufflen(SCpnt)) {
> 		unsigned long len =3D 0;
>=20
> -		SCpnt->SCp.buffer =3D scsi_sglist(SCpnt);
> -		SCpnt->SCp.buffers_residual =3D scsi_sg_count(SCpnt) - 1;
> -		SCpnt->SCp.ptr =3D sg_virt(SCpnt->SCp.buffer);
> -		SCpnt->SCp.this_residual =3D SCpnt->SCp.buffer->length;
> -		SCpnt->SCp.phase =3D scsi_bufflen(SCpnt);
> +		scsi_pointer->buffer =3D scsi_sglist(SCpnt);
> +		scsi_pointer->buffers_residual =3D scsi_sg_count(SCpnt) - 1;
> +		scsi_pointer->ptr =3D sg_virt(scsi_pointer->buffer);
> +		scsi_pointer->this_residual =3D scsi_pointer->buffer->length;
> +		scsi_pointer->phase =3D scsi_bufflen(SCpnt);
>=20
> #ifdef BELT_AND_BRACES
> 		{	/*
> @@ -109,15 +122,15 @@ static inline void init_SCp(struct scsi_cmnd *SCpnt=
)
> 				 * FIXME: Totaly naive fixup. We should abort
> 				 * with error
> 				 */
> -				SCpnt->SCp.phase =3D
> +				scsi_pointer->phase =3D
> 					min_t(unsigned long, len,
> 					      scsi_bufflen(SCpnt));
> 			}
> 		}
> #endif
> 	} else {
> -		SCpnt->SCp.ptr =3D NULL;
> -		SCpnt->SCp.this_residual =3D 0;
> -		SCpnt->SCp.phase =3D 0;
> +		scsi_pointer->ptr =3D NULL;
> +		scsi_pointer->this_residual =3D 0;
> +		scsi_pointer->phase =3D 0;
> 	}
> }
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index a23e34c9f7de..4ce0b2d73614 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -761,7 +761,7 @@ static void fas216_transfer(FAS216_Info *info)
> 		fas216_log(info, LOG_ERROR, "null buffer passed to "
> 			   "fas216_starttransfer");
> 		print_SCp(&info->scsi.SCp, "SCp: ", "\n");
> -		print_SCp(&info->SCpnt->SCp, "Cmnd SCp: ", "\n");
> +		print_SCp(arm_scsi_pointer(info->SCpnt), "Cmnd SCp: ", "\n");
> 		return;
> 	}
>=20
> @@ -1011,7 +1011,7 @@ fas216_reselected_intr(FAS216_Info *info)
> 		/*
> 		 * Restore data pointer from SAVED data pointer
> 		 */
> -		info->scsi.SCp =3D info->SCpnt->SCp;
> +		info->scsi.SCp =3D *arm_scsi_pointer(info->SCpnt);
>=20
> 		fas216_log(info, LOG_CONNECT, "data pointers: [%p, %X]",
> 			info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
> @@ -1054,6 +1054,7 @@ fas216_reselected_intr(FAS216_Info *info)
>=20
> static void fas216_parse_message(FAS216_Info *info, unsigned char *messag=
e, int msglen)
> {
> +	struct scsi_pointer *scsi_pointer;
> 	int i;
>=20
> 	switch (message[0]) {
> @@ -1078,8 +1079,9 @@ static void fas216_parse_message(FAS216_Info *info,=
 unsigned char *message, int
> 		 * as required by the SCSI II standard.  These always
> 		 * point to the start of their respective areas.
> 		 */
> -		info->SCpnt->SCp =3D info->scsi.SCp;
> -		info->SCpnt->SCp.sent_command =3D 0;
> +		scsi_pointer =3D arm_scsi_pointer(info->SCpnt);
> +		*scsi_pointer =3D info->scsi.SCp;
> +		scsi_pointer->sent_command =3D 0;
> 		fas216_log(info, LOG_CONNECT | LOG_MESSAGES | LOG_BUFFER,
> 			"save data pointers: [%p, %X]",
> 			info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
> @@ -1092,7 +1094,7 @@ static void fas216_parse_message(FAS216_Info *info,=
 unsigned char *message, int
> 		/*
> 		 * Restore current data pointer from SAVED data pointer
> 		 */
> -		info->scsi.SCp =3D info->SCpnt->SCp;
> +		info->scsi.SCp =3D *arm_scsi_pointer(info->SCpnt);
> 		fas216_log(info, LOG_CONNECT | LOG_MESSAGES | LOG_BUFFER,
> 			"restore data pointers: [%p, 0x%x]",
> 			info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
> @@ -1770,7 +1772,7 @@ static void fas216_start_command(FAS216_Info *info,=
 struct scsi_cmnd *SCpnt)
> 	 * claim host busy
> 	 */
> 	info->scsi.phase =3D PHASE_SELECTION;
> -	info->scsi.SCp =3D SCpnt->SCp;
> +	info->scsi.SCp =3D *arm_scsi_pointer(SCpnt);
> 	info->SCpnt =3D SCpnt;
> 	info->dma.transfer_type =3D fasdma_none;
>=20
> @@ -1849,7 +1851,7 @@ static void fas216_do_bus_device_reset(FAS216_Info =
*info,
> 	 * claim host busy
> 	 */
> 	info->scsi.phase =3D PHASE_SELECTION;
> -	info->scsi.SCp =3D SCpnt->SCp;
> +	info->scsi.SCp =3D *arm_scsi_pointer(SCpnt);
> 	info->SCpnt =3D SCpnt;
> 	info->dma.transfer_type =3D fasdma_none;
>=20
> @@ -1999,11 +2001,13 @@ static void fas216_devicereset_done(FAS216_Info *=
info, struct scsi_cmnd *SCpnt,
> static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt=
,
> 			       unsigned int result)
> {
> +	struct scsi_pointer *scsi_pointer =3D arm_scsi_pointer(SCpnt);
> +
> 	fas216_log_target(info, LOG_CONNECT, SCpnt->device->id,
> 		   "request sense complete, result=3D0x%04x%02x%02x",
> -		   result, SCpnt->SCp.Message, SCpnt->SCp.Status);
> +		   result, scsi_pointer->Message, scsi_pointer->Status);
>=20
> -	if (result !=3D DID_OK || SCpnt->SCp.Status !=3D SAM_STAT_GOOD)
> +	if (result !=3D DID_OK || scsi_pointer->Status !=3D SAM_STAT_GOOD)
> 		/*
> 		 * Something went wrong.  Make sure that we don't
> 		 * have valid data in the sense buffer that could
> @@ -2033,6 +2037,8 @@ static void fas216_rq_sns_done(FAS216_Info *info, s=
truct scsi_cmnd *SCpnt,
> static void
> fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int =
result)
> {
> +	struct scsi_pointer *scsi_pointer =3D arm_scsi_pointer(SCpnt);
> +
> 	info->stats.fins +=3D 1;
>=20
> 	set_host_byte(SCpnt, result);
> @@ -2107,8 +2113,8 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd=
 *SCpnt, unsigned int result)
> 	fas216_log_target(info, LOG_CONNECT, SCpnt->device->id,
> 			  "requesting sense");
> 	init_SCp(SCpnt);
> -	SCpnt->SCp.Message =3D 0;
> -	SCpnt->SCp.Status =3D 0;
> +	scsi_pointer->Message =3D 0;
> +	scsi_pointer->Status =3D 0;
> 	SCpnt->host_scribble =3D (void *)fas216_rq_sns_done;
>=20
> 	/*
> diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
> index abf960487314..d2e7478aad12 100644
> --- a/drivers/scsi/arm/fas216.h
> +++ b/drivers/scsi/arm/fas216.h
> @@ -312,6 +312,7 @@ typedef struct {
>=20
> /* driver-private data per SCSI command. */
> struct fas216_cmd_priv {
> +	struct scsi_pointer scsi_pointer; /* must be the first member */
> 	void (*scsi_done)(struct scsi_cmnd *cmd);
> };
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

