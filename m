Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC6EC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 17:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiLORiq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 12:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLORip (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 12:38:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E2C4387B
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 09:38:41 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFEn1ie029516;
        Thu, 15 Dec 2022 17:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=K8BbCB0OYg77FNvBopbwm+/Obad2pFSpq/hI2NGH1kQ=;
 b=qYtlmyik6Azeh5ZCRnVHVAViVkpGwFX74pUoBNeq7Tv0EcKlrsex48lElLPXio+MjZ08
 YmJx+ciNvJYdaXTp0q31HvO5aifJug7KhpC3a/8D1J4kRB0hPvkMpFpy/BjK4N+1MuqZ
 UI5uBAXFbOre6cHTvdto3xUjH7B0Ps70RH69h5hcBfvmyhsPbXi4LnPJntM2Ai+/Dv8p
 rxDuOuqmzfR675GzbnaMu1pLWZrzLDy5c9U91JWmCEWyUZQ5Ilr9I+X5wMdd41oVPZQG
 XxRF9hDurBHY9GW6kVMCGNdOL7+BLnnzbjGcctGN4u25MJ7jBIGCLAOqe2nI89d2r8q/ jA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu5tec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:38:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFHJg6W011010;
        Thu, 15 Dec 2022 17:38:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyervaha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:38:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W44C/cemIQaeie1VVDD/5V0PMupbVwIefdd7Oz6pYnwk9FL8Z9/RPcI9uIxZ/gGhgP3yymW5a/UAzCgxrVFCcnHyu2JqPJF/AQxBHNBousuLRsJBo/szdOQGQPXIr7ldNkRgRIXIB+5/zbntCMpLVVhBYwi7UtTxcEED9038pUsMD5b+wdJ8EUqFHlNPUQlNcnmSU0yu8G/H25Y5OaCs/JpYlHBCAb2jBYLDvSBcXmt88Njn4y2GfPuApGg1cR/v4kdvkY+CNZgMqUx+AeArUVSQ0avQzpBXS7YM0Zewyh2+dFWq9PQWvB6fYBR3RfO0EERp+Pe2LaoW24D2cpXeDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8BbCB0OYg77FNvBopbwm+/Obad2pFSpq/hI2NGH1kQ=;
 b=GAvhAqqjsakcjYKXPNhQdQJQTE8P/Mc7KEfnQc6dqhaOdykWkVlFG3WGeTISPoX8NdO1qrOhAHln7445l9N2JNoWPHM0sjxVzy6XZ5M+CPIbKvdybrXzc9fVQXmNQIBfwVxy4WwJcjjKkVPkiLrmLac/T9fRO3y9miLg3sjR8FO/O5upNv1gVO6DoxYZtVQrOA7/BBeh/bEIYJAmCKczw+h4tQ/o1D6ffxBqrhbpuouhu1os1jilzmR/FyMVn/Lr5mEyil3IGRwNrSBnJgYSUPuw/rDQ72ou5+dPeHaNbsAwR14oB6b0FSgHOvStrQE1BoDpfDYhIGjpGbn5Q1zIvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8BbCB0OYg77FNvBopbwm+/Obad2pFSpq/hI2NGH1kQ=;
 b=VhHMfi8UTBFbBkL4J3HVOzdbK8R+FOv1uJqurGWcZ1yqXlWE4t+riIH9vxnDgylV0ddcCosmDc/uPyGa2QfFnQbJIHRwGTXqW1pyNjTKOJQj3oIb6b0Dbb4aivQsdtuVC8J1WVj2vrrzEc6uh1kkuPtFeDS3xXUuEEbb0YiOq4c=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY8PR10MB7266.namprd10.prod.outlook.com (2603:10b6:930:7c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 17:38:37 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:38:37 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH 07/10] qla2xxx: Remove unintended flag clearing
Thread-Topic: [PATCH 07/10] qla2xxx: Remove unintended flag clearing
Thread-Index: AQHZD3ewmP8jZ+cx/0uyeZQdUnjsEq5vOS8A
Date:   Thu, 15 Dec 2022 17:38:37 +0000
Message-ID: <A443FF1A-7866-4E70-9C40-A762B8F43AE1@oracle.com>
References: <20221214045014.19362-1-njavali@marvell.com>
 <20221214045014.19362-8-njavali@marvell.com>
In-Reply-To: <20221214045014.19362-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CY8PR10MB7266:EE_
x-ms-office365-filtering-correlation-id: 10995336-f01c-46e5-bd07-08dadec3328a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bwm+YZTRhHr9OJdxqNEK+fjUWOKSYd3+F9QMSDfKAIl2UqHSk+lK0WSy6Onjd40mfcjjZcYCOvAoViC7iofl7xPufWsbUddd7JM6krSUA7G/9pvOgxYJMeTcRac1FzBfl0hQpM0fIO6huKjHeokyW+M4PL664TWYOIku3l17HfVXUPBm4q1oY/HrRiocnqZBCGHKZJetNC70mHvjeuqPCSMBAUf4bORVO+UiDUH5IcpN+Ol/njAsD+VStBaebGtp+mNuwudCUWMX75qc3y51pPsuIHTOl5wkQSr4dnwEWYLR1FH9JO9CP21mqWYSQG5dSCeFh4XBy/kanSr4Yjt/q1apBRhRmV44iOYjvezAC15CQ5qE2G3IQqN750NJ3o+msOfVFsP8abUA3LrcRtcsumkealzZPSQUQg616LE0ZdAEgqRBOsMsh3DjzF3/g51tyg1lnxFgDdmwPmLMRhnsV7sh3jSkXRHk9teJ9dcJYenuhq8wQBjqO9224Q5nOHQwdcCXd5Mp2+pE6U8jc+lpa23uc3TxFOOiG4QHkxH7waraVwJHtKWVcdYgWv91hbHL1lC1H2N4uXmB5v6/jHbLGNar608EDvgHVFJfdeuxkLY88nHthJxZmzX3lpES2rM4mLM9HfAQd7YEEgqcYGs8zBzjSa9J3QSid2qh8GGI/ZGNIdK5n8eG52jYdwOhhe6kBKspaY0Ogr4s2hDq2russYa9YQ0Vptp9mhljVm3w5D0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199015)(38100700002)(122000001)(38070700005)(41300700001)(86362001)(53546011)(6486002)(478600001)(5660300002)(6512007)(76116006)(71200400001)(54906003)(66446008)(8676002)(4326008)(66946007)(66556008)(66476007)(6916009)(83380400001)(64756008)(2906002)(44832011)(186003)(2616005)(8936002)(6506007)(316002)(36756003)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PdxoEWAC10ZPK9w9Ap8QCD8anwDvaQ1UU6q78slaAD1xjrQ5pa/ERJQFbVXE?=
 =?us-ascii?Q?deI5jBZPW9KIt3bm6EoZexigoUGOAoUKeaFsOmodwDBk2icfIB03gla+zfvs?=
 =?us-ascii?Q?esoy2XN6heS3azRuG1uRYB8farcDb3Vf6A/M8sbF65nse75Gv5SHTESjeL4T?=
 =?us-ascii?Q?2VmOVBJUsaiWYzMqDAHuYvGU2JVW/JQLwgTY7bXwsVRAxDnadeKRIvoaOOx2?=
 =?us-ascii?Q?BdWXtbQSXmCYqC2N0mLhY1NS6VeGjELNC8NN6Lob5y+uFVJ96wnvvgc0qhfw?=
 =?us-ascii?Q?HbvtNy7pwipD4DywpON96mxqHIZ0hOhKx8BMRjeKGIxqB5T39j6iVLBmx8MW?=
 =?us-ascii?Q?tS8eAsUKi/URx4ufiAMwszQj6zlChoddAwj+c0/elBZFyRVB1ZUgom7n9DgT?=
 =?us-ascii?Q?/aVy/BFDXMoPSAimYOt4xvPC5jr4575URjKuG7e8l/KC5bfjvMvuKQQW/Wg4?=
 =?us-ascii?Q?UWIo17j4ok55hGRPIZabiEwCx9LWGo2GEyN/1+HP+ni8s4Zaz32/1sptV7TJ?=
 =?us-ascii?Q?+fie+nepL0y+DMuMOHnGywZJIrFIPAO5JBFm09vwtYgSNaw14u3uoOCkYg7e?=
 =?us-ascii?Q?JzuZF40oqjT6X9hxmduY1ybTNXB24XU6f++0uqgHVGIdQ1+4IOk0orkJWNzo?=
 =?us-ascii?Q?LDeEPL9RJmR1bcqOsFCpryp6NpvOO3iOoc7WLJppfIYtAj1ckjeS/Eq8U3y1?=
 =?us-ascii?Q?rGKfUkJ7P3NWG7YehxgHAZ4KRIFpHmwzv4SeNLKQGRrRio5sEe+gQznQTxNE?=
 =?us-ascii?Q?jfCnAgIJZUICrTaR8qYQVUGytoq8kEc8/KoFivY2pjOkZRFv9NVVsvjeVGhW?=
 =?us-ascii?Q?3Mp8iy18+qYn18Tlua4rwgaN85dbh8DE0MVv+oW795bX+qTXWYLOWoY/f2wy?=
 =?us-ascii?Q?5wvpRhsd1vINPnYEyFbVnbyU6B3FuRYwSvblB6Mr9mfJF1EpMXh4BGseAogL?=
 =?us-ascii?Q?nCZXer7yEGxAZnJVFVEWMBxlawp0cRjdatloLxTFM1Ps0d2Q3LH4o6tvbciI?=
 =?us-ascii?Q?PQ54XQUdqhHapYNbtNu/9ZAPVPlk8dFNTPoQgzKjOLw2SAO9U7PpRDteTWVR?=
 =?us-ascii?Q?LEowAf41RB4GKWCj9s9Qjyv552xmaImkeZiLv/FbetQcSVZYu8uP7ONAtBwC?=
 =?us-ascii?Q?xXM9XXmPruQnLzZbHS/jG5Sr2432icTCi/ftixJhvFkj/54EZ0ZodzsvF+0g?=
 =?us-ascii?Q?E3/4cdn8HoN+zYXevCK4vPo1zopjiaSNN0NtO0Lq1AaJ0bhHtTbLAZPqSaBZ?=
 =?us-ascii?Q?WKv7Om2rB3XHeRbtQRMiuJpA2sRLJhRPgdor9nuAiSjmfZ5BSps736FfwhOy?=
 =?us-ascii?Q?EWrrdcGK+e277XkB0KIvU968o5n8AWWJlRnoocCTeEBHxXR0n45v0BL8msm4?=
 =?us-ascii?Q?kVpSwGRsRfZw91u6wcWjE3hrQy/2jia612mU3qJ93kOJ7vDcjcmvHwplbcBJ?=
 =?us-ascii?Q?+qrLIXwVcI+RFvFfQOVmp1uOEd7LZmBsfRijNNlqs6LWYEUSF7ss1cqqlhrI?=
 =?us-ascii?Q?otvucVhQyYWWtoJ1guNHy0hXnQKusCVDXz/v6+1Wv3xGjB/TY3YfZOFXFv4n?=
 =?us-ascii?Q?J/WufZ0Dt4uDu/eKbOtjnDPb9n2SuobhjZHt7q3Em1uOZtnIZQtsQToTzWia?=
 =?us-ascii?Q?PcgqTu+kF7mhace5NEziRZKIRdB4/KBdrTDczl8KWV3Q?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <580A92883D950E488DC121B93B872750@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10995336-f01c-46e5-bd07-08dadec3328a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 17:38:37.4132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ndFL3UhgIhA5FH5zqYGu5PXyPJMLzXUHEvkOUCQnXycKJDCQtOk3ESGSl+XruA4QEIU3GxKhIe4//RRC6c7HA/SpTgd99C9Ahr9AYdtrk6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_10,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150146
X-Proofpoint-ORIG-GUID: 6RqTBYtdKeIn-STw8fVvVLLcqGAVYBba
X-Proofpoint-GUID: 6RqTBYtdKeIn-STw8fVvVLLcqGAVYBba
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 13, 2022, at 8:50 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> FCF_ASYNC_SENT flag is used in session management. This flag
> is cleared in task management path by accident.
> Remove unintended flag clearing.
>=20
> Fixes: 388a49959ee4 ("scsi: qla2xxx: Fix panic from use after free in qla=
2x00_async_tm_cmd")
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 745fee298d56..6968e8d08968 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2082,7 +2082,6 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t fl=
ags, uint32_t lun,
> done_free_sp:
> 	/* ref: INIT */
> 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -	fcport->flags &=3D ~FCF_ASYNC_SENT;
> done:
> 	return rval;
> }
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

