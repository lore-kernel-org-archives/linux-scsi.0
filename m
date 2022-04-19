Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B2FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 19:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347343AbiDSTol (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 15:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243888AbiDSToj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 15:44:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43BD4132A
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 12:41:56 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JHVvwN019815;
        Tue, 19 Apr 2022 19:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bdsVlO4Py/s3LYKC+wxUr9wnvRW35XcN6URwavMtFXk=;
 b=NwKIO+wUBN3s5E/UjMfaaJLNLof4BbUX/zrPri/ijOd2UxHFeXjdbK+tjMRtxSFo3zCC
 HXlAkCLbo54C+cCcrYJucYUGl+3/i68hcP4Gs6yA9lNYaK/ScykyaXs9cGHc2OY3tkej
 0uc6knWSlVFegiNA9R7/oP3nNSwvdfdCVbT28TRrcEc2JKtWxNrhdNRSRXbsEngZI2h8
 QpKzo8lb1PapastdBI6WjlUMK7VT1PnwcXypYxrMxnGhCAvslohUQkVWsKVMOrQtln6h
 /45cT8YDks1HnaZV2z2c1VazkBjj+XV67W9D0G4EB6HgVmfuIRUZD97XW84I4uKS1FIZ ag== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd174qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:41:31 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JJQ6he040866;
        Tue, 19 Apr 2022 19:41:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8345kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:41:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyZlxeRpNeV03wOENVSaD0Yh0fX+pxoiZ4STS8+W6M9h4O9FsZYk+1VyyJMZ5NV6OmVCRX+9jiZvcfYhXdNHAJZRk7wuoiBp2VfT/QqYBqTcQJhwPjbpm8Bg19b4NscfUUns5PbKS6NoBQb+Zn1F1TgPwud7LsRxVXolaOmTQ4DJs92EbxaGuvgZqVjQhTDKtEnXsatHWkIbcbhYtPCcM3WrVCvb8gj3c6o4CZwQeyo/sPX8VmZYMSUG+1ziZkUf389Qhe/m1/jm4Ma6sZ0asWMJiEdPXaDJBXLIz3ivbxhkqhQB4L8PFCXkuAnmufmZfs3Nv+riw516oF8Ul2v8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdsVlO4Py/s3LYKC+wxUr9wnvRW35XcN6URwavMtFXk=;
 b=jXMkFaIu3PZlxs9LG0WuMCNtBImlZ5CoDG/gMBn9TjpvFXqsQFWRF7gs8pfBFgrlpu74hFQUU38cxivBJD5XOSMEzXIXwJpscha+IdyojXFIkfpYse+wepgi2+Pu4a5Qj79VHTCAmsbHcMcvLUXqA3tqU+wJfzJw7vja+zSAU/suWidS58nlguBslFct8Z2Vz35rI3zVquG7Di9aGWKUqWx5hdy7IB7P6OZyF0ihiyynLonrK8/O6QgDnTfu88Zq5hyRn49DXjesUFnmmZFf+vIFlXqsiybY8jWgkza9bWhycQTeqEaNHc4hC/5qAWkdKg2ymqC4LYiRiT2pdATp5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdsVlO4Py/s3LYKC+wxUr9wnvRW35XcN6URwavMtFXk=;
 b=zVdJJ+q7GWRUJ9w4FV67cbrXQWTZh2QAnUKB8cY0m1ao0hhgohBEREWPPuMJbXoht7LcSOB6BP8fn5z1+Fsdd4gbH0B5IveekkPPucgC4moO/zC3/rsH0bseZ9fd9ESVnlbORWd5YYAlPhLN45CaB3FmZT51OaS63OcntkvWtIs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5336.namprd10.prod.outlook.com (2603:10b6:408:114::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 19 Apr
 2022 19:41:29 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 19:41:28 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Topic: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Index: AQHYUMYtkLBbKidY90SJACyXGZHZ2Kz3qV6A
Date:   Tue, 19 Apr 2022 19:41:28 +0000
Message-ID: <4FA3632A-690C-470F-8DEF-663F9AC0CFC8@oracle.com>
References: <AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 588e4f0a-4e06-4ae1-58e1-08da223c98c3
x-ms-traffictypediagnostic: BN0PR10MB5336:EE_
x-microsoft-antispam-prvs: <BN0PR10MB5336787BFEAA2B84ADDEDFADE6F29@BN0PR10MB5336.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JU0m5evrqxASFQokyMwM6g8mN7izgCw67HScJ12rvVEwE3C8wrVc+ndD3nRLg2wPVktd8se5cCh5FchEkxcm9ZkbIzdVyStHEa+Bxiszb5utGAbSY3pijmCtL+rM5EUQD09hB5EY9jBdX+5oyk4uu79D6tngwxEg07m2691HZ9cN5iCoZXLvVy8xGHabx1hF7mzx+/RhAtcSr9rBVAeM+OJSaES/YvA2oCrqNaTHiXLKdLzmYean2NZHq+LdOrALbqUv8kPep4D6gTl5tx2nAkw1s4WY3F1u+F1J3t/koQiNkfzqY7ll+bMkvxoaq00wWlChigzt3s0vj9yryDZ3Q8lXADk7T1kluOmyXoshgftcusgVQRgoGwWJjVDH6chxw9iteZ33XOh9k7WR3WXmOpzi2+LxC8X3CeSLEunpOGZTKuKFtLtqPcXV1SjTKFUtTlS4nF3WNIEHoU9hrOGguImpluLZCnpBOYwwSPmDizaNBew2/SuWZ+bAsEAq6GJuP8qRb97hc7io55Hsrpw2ttRb5Qf+kWtynwWbVutQrxQJ7/4fgV38NKOnUefOB+21U75SbIqQTDTbt4JDuaTo1AOeo8eTVtUIe7K7/6T8iMiSsPTZoHUtqSlijG+qS/DXFAzPLiwRp3+u1ks1VuEbuTbpsZJ5gx+wzPOtGvq+1+bQ/vJRovMeAv0Tatv85HfpwDQtzbz/F/v/Dalfj4P3qhekf2HtXLAYiVZLFeyTuZl2ZFy3VRxY/LI8WV4cFcnV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(26005)(122000001)(186003)(44832011)(53546011)(6916009)(71200400001)(38070700005)(316002)(36756003)(83380400001)(2906002)(33656002)(8936002)(6506007)(6512007)(8676002)(4326008)(508600001)(2616005)(66476007)(91956017)(66556008)(6486002)(64756008)(5660300002)(76116006)(66446008)(86362001)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QTjmJCwka08Er2UDPoFswDPuaI4jEVDKQxI45q3gGGEMcbD86uCTDmeYCp5N?=
 =?us-ascii?Q?vWc9FENM4CASZn4STNS78XjKXAFsJrUc+ud7VQarvIBbdjFn1Zfi78PPTsae?=
 =?us-ascii?Q?6JaDGwjRiZEGDcDIJ9fjJOsuFKicK+76WGc0LG14aIL6QPgJB0upEHcCAFLC?=
 =?us-ascii?Q?V+fktC3e6ksCwBvU8iwEHkzsbqC41+cFXuqEn7HcbfEfnOS0z28HLAWYz5Zi?=
 =?us-ascii?Q?8Y2KhIF9Dp7a0o9VZnwQZY27tNnXh5G8vISw1IQFW2ZTVHPURp04lPCMm0o6?=
 =?us-ascii?Q?Y+58+iUtgezZ3D7kgfe6c76f3BII7mht2yYtNb6MHWwGb2WNqYeGNHDr4DML?=
 =?us-ascii?Q?yY4sskDNOhC2N2Mn3bwqNtY/WrLbMOj1c9GOtWsiVgRjwhKytfQBxBtDVKUX?=
 =?us-ascii?Q?ILzAWlr9+J8GpmvGbiUJEFenx+WjjjF4Ek/9S1BVadDFkoAp3kfJDn4KDVRZ?=
 =?us-ascii?Q?/yr5hDWBhLjl63oaKmp63KT4qNUvqgb826j27VCYdgFRxFmdwvAhxyiJsbbE?=
 =?us-ascii?Q?kCEUKsuDCv/PRFX/9xiEiECUP+Zo8pSA1nQd0Y0YftRAtZAAmDxv7bUKKf5J?=
 =?us-ascii?Q?6VpTgB8wp9jjXC1wykbLdfbvv999ZPZrcavs1aqbfgAjN2Uzd+Wy42PEW/YN?=
 =?us-ascii?Q?hzb9jeJBXP5J9s3MwC1diML+HPxRanB36f6U4slJ9lpcEP0cZbSbpXmpfAib?=
 =?us-ascii?Q?GrLqo+sYR6/rBxgDiTIjT3G2etZ1MDcaY9axQcudBhhnIPNe1UuJXqX00Vth?=
 =?us-ascii?Q?nownSYAYZc5DjLnGgBRaQ4UYlnTps3y6cF+ct24JIRQ9iY2Q8XK3c+pY0GkS?=
 =?us-ascii?Q?X9zNmWtv/ylv9w9EkRy284p3/g7T9ne6qcs6NXwc0IRiOLw3yNIzIVi/9O+k?=
 =?us-ascii?Q?dcLkMtcaDuqpM+yWAG6vGBr772ilUWAl7EwZPs5pnx6BUKSE0u6nFZzoiMfR?=
 =?us-ascii?Q?4dEHC/z13x2f0dRmL4ioonr3VMhKHmtYpZ5/0SKgxO8JwKV9VCoTvdtONi5Q?=
 =?us-ascii?Q?gDACy3OHlvp8e4tW475cXB8dZ0cuOfIxtUOP69Q9741YbcMjxSnSrotoVN2b?=
 =?us-ascii?Q?/mN8IjPDSYWoeJ0THhRToabjo44Ngcse7mjPvcZ4enOKA2sFWc9KdsXGpsPN?=
 =?us-ascii?Q?NvxRf4Q7drGDw79nEwcK03RPbN3OknIdxrf5K983gaxkVuMdNujZyV4yAuRb?=
 =?us-ascii?Q?0IGXkZD520UHuBxlvFwzCOZIYJ153yEt12EJBVWV1jFDd45W3L/jG0plbc6b?=
 =?us-ascii?Q?ZkJcifU8wrAB48q7ihiRrnGYyqsQKdkM/OaIHYpeahhlZA0yc9oO8MTYcH8N?=
 =?us-ascii?Q?uDhL8LNxl3VrdC3nM+CumBk/vHLuDVCMhKOVWkA4dCumwofRDdZ2W2yG+qZ+?=
 =?us-ascii?Q?Ls/APuWyB78OXAkj6oMu0A2Ilx/f+FtNnvTXT490DGJimzUb5EEMnF52qBNl?=
 =?us-ascii?Q?PZgByzThC51U/Usz6ncp3MTCJGtDCp4a3OhO+/oOFPW9/zBCeGeAb02QqgXK?=
 =?us-ascii?Q?5c5EPPq1irX/y9foKf9KeNEChcipz1d+5o8ct+Z/56UehOCi8gcKNMZOKtvh?=
 =?us-ascii?Q?+Tq+SfFA2lAPEBtVpktqgUuXyAzdMVVH2ytzPsa1LF/Xmy7Uk6O5ziWcv1xW?=
 =?us-ascii?Q?msy+Z0aJmT0IE2zMeOPgqCepReo9cG96aMMnJcU6vS9dB+KnycA7NXfgdJ9T?=
 =?us-ascii?Q?yQLxYkcWS+3e0YUR8mpNZZJm4+AglN3bO10qc6qyyuVRWn6uRWo9M81JenAy?=
 =?us-ascii?Q?jbU7KbmrhVKqnNO4a9ig2seVO0IeYA2F42TwrMtrtQ1pYIkGKYAn?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC5BBC95247BB845AA8FC443661842A4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588e4f0a-4e06-4ae1-58e1-08da223c98c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 19:41:28.2042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oMcUQVLB17bG2MKOIvFFKxJwtZxgVXqdimxEe6cUxhKIXZU9h3BYyS+GDpp5oX/udxctmp80oOe6iIT/3WH9XaoxwRybHwbIXO8QHzZkrvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5336
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_07:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190110
X-Proofpoint-ORIG-GUID: m_ixC1KFulOBFZVnFisVPQ1bamhOPKt1
X-Proofpoint-GUID: m_ixC1KFulOBFZVnFisVPQ1bamhOPKt1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 15, 2022, at 5:42 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wrot=
e:
>=20
> Aborting commands that have already been sent to the firmware can
> cause BUG in qlt_free_cmd(): BUG_ON(cmd->sg_mapped)
>=20
> For instance:
> - command passes rdx_to_xfer state, maps sgl, sends to the
>  fimware
> - reset occurs, qla2xxx performs ISP error recovery,
>  aborts the command
> - target stack calls qlt_abort_cmd() and then qlt_free_cmd()
> - BUG_ON(cmd->sg_mapped) in qlt_free_cmd() occurs because sgl was not
>  unmapped
>=20
> Thus, unmap sgl in qlt_abort_cmd() for commands with the aborted flag
> set.
>=20

Do you have a log showing this error sequence? Can you share more details?

> Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>
> ---
> drivers/scsi/qla2xxx/qla_target.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 2d30578aebcf..a02235a6a8e9 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3826,6 +3826,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
>=20
> 	spin_lock_irqsave(&cmd->cmd_lock, flags);
> 	if (cmd->aborted) {
> +		if (cmd->sg_mapped)
> +			qlt_unmap_sg(vha, cmd);
> +
> 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
> 		/*
> 		 * It's normal to see 2 calls in this path:
> --=20
> 2.35.1

