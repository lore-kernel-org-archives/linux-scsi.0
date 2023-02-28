Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7030CC64EC7
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Feb 2023 22:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjB1W3q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Feb 2023 17:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjB1W3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2023 17:29:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE8C212A6
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2023 14:29:43 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SGwVaR021993;
        Tue, 28 Feb 2023 22:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=QbrVXSG36vQq5mKQ8ptRZEF1kY3ae77BSVg4//uLrlk=;
 b=hAR9MJV8ppzgS6/oU5nlozDusfPLfiHKo3/pcsWwbDPr2wDIab+2xB/i0Kywf8/I+O3x
 H2K2U+VmCp36I5obW+4UlrNNUi70RVGRp9Sd0F5hRhaxjS5UKdyiZDrJnetni3fFItu8
 3Nlu8/3c7lLOzzhAOdBRoo2tyDWJ7yacmwuteSyPne875FLgmpDvMoubkstcboOXDiZs
 1oGyQAJVggO85rsV1Ub4cGiBQrBITw9EwVVOtoLWR8kKrva0DEnAZHnWn8dRn7NGnwLk
 hmipHCpQxDqB+h7ixxraQ1ykUyRDmiJGdiFch2Ea22J1266IoWwZHkCcWifpRst4+9U7 oA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7fhem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 22:29:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31SKlLpg001109;
        Tue, 28 Feb 2023 22:29:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s78hdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 22:29:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VU1y0sAUFU3dclpEKHIf1iVljHHL3Papu0fQpsILmjEWAJ+nrhpOXJhTLJDfCbQP6PnBbuSfZgo1BVA8ryej8Tcx/P+N2j8Xi/RP1F4Kzu2j51Kt1v6Tps9cYWI0OocFBdk7iAlnlbNTl0kHBGpXbbaYUndvcEGy4J/IJcwmRlli2dWCHmtyFWlFOc6pexAxab1+6mdQMhEbWBrkCFOc9s10EXIUZUSnwSn86wJkLiTkOrJJg5ZyWjdlrHvk+eGHD+fCb44NThcbtCcJ3e88JgGxr4QWhWyaGgw3JLWQm0Rmw/lKKjSvDuSWMGVNqga9sOfmj2Y3o5BC4DUJhfKPOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QbrVXSG36vQq5mKQ8ptRZEF1kY3ae77BSVg4//uLrlk=;
 b=fHbDcLL6lHpWA3Yc+j+ErVorGekRAQ9DSsmj21nnlAH+jSBW4Bo/cWxUtQAXdAJuo4SeEXLpy/l5GxWivMHOMytFsNfM1w4vWF6JQdu+PJHGm4pnm8rdckVqseA4tvcySlIgmRwd79gCmNXuJedZwiyBxw8PcTogHbKUBx3AZUTS5bwEcMOcYAlILdAKD2vO7LD9gbK4gT22O0soDzGYn9yHg/fqSZnOqBAPPpSikJ5tihHRgIEIexmSg9pVNGgwX34VMMzngRRyh1GKj83X1MjPCCb7smGU0bdMh9RoTuhj2Yg51H8Kg05+yrP2v+IOlervQ3qxSgATZ+38pydNlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbrVXSG36vQq5mKQ8ptRZEF1kY3ae77BSVg4//uLrlk=;
 b=mIBkBlFMaYmx7j40GbbmLHHOy43OolL5thbVU2mIjIONcevnzfhzewcRjmihrsyvjzkqE8EWE0RysC72aTROGqdD7FB1N1+lV+uqxfc2+/TY2NqGvAlTgK1oMXkmAJAg1v45EEq2tuOGUhfiWjKzcrivl8T0RphPSN6N+2KNHJA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH3PR10MB7306.namprd10.prod.outlook.com (2603:10b6:610:12c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Tue, 28 Feb
 2023 22:29:35 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::c033:cdf1:279a:4bba]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::c033:cdf1:279a:4bba%4]) with mapi id 15.20.6156.017; Tue, 28 Feb 2023
 22:29:35 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH] qla2xxx: Add option to disable FC2 Target support
Thread-Topic: [PATCH] qla2xxx: Add option to disable FC2 Target support
Thread-Index: AQHZO9DimfcYENzqtUiZOYJm2a/f5K7lEJeA
Date:   Tue, 28 Feb 2023 22:29:35 +0000
Message-ID: <8969BE1D-7A02-40E1-9CFB-E783FDC845C9@oracle.com>
References: <20230208152014.109214-1-dwagner@suse.de>
In-Reply-To: <20230208152014.109214-1-dwagner@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CH3PR10MB7306:EE_
x-ms-office365-filtering-correlation-id: a1997d92-5810-4730-9b08-08db19db4579
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zG0mj+X5Il2thwYyKJjVbBP5h9mXMc//KE4FuCF5XV3CB0LbQ7E+ogrjEv2d0cjRJ1N/Ic+vgjXWBPZQyWIoeIRAtm8nz7RpuneAonoF7CYnkH0a8xfNrMvUjbFk3yCfPcHGpidgVQoUfeV5ipdrBWFLwWUdUrxU0FYTWKywdonXF21eCmwG1it76VuubMJRTxNLdnzsy+Xf4EP5JBCuK4VAMCiJIUPQGK0y+LucRiGQK+JmqzEaweSo1qm8ZB6axANzrP4gba8IisBkJUgQXAuJr9yk4Doel0zA/hgiWrLUs82q5t03X/WYxk+7SVRs2BYlB4mC1mZxhQgrYLIfSjGqbMS4jTXgltmF20wvxUPVuHPwp+U8gSnPlIJcNMBuFJjk47c2MK8vCpze1Tg+iz48AC+8Wqufdv0UdF66Vy3OL/0tWM+zLSZ1JasevB5rFPTVVDAECUxvoW+QIvlFtMvCVOWdF2PLEE5hg9X6Z6XofjMB5sM3evPhat92SioF7KuCUDSNT8xpVUV/y/bBnH/jOUjFNhxyxAxqgZqEx+5hvUZRSDoKGr6c392XwRVGNUepPKFHbVmglxw2MLQsSrAbXbocJVdYNFtQwTFcpiRMPt8FRjDX67T2+JYoWSdG2TQEl2rmQdJO6be5p1lZY3Qd126tZyoZYFoWF/9VboOootuQuqNnohmU+bBGH/f6Ji1n4f4YtB27vDsNmmI4d6v7wuq4u465o36SKH7pVaw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199018)(33656002)(36756003)(86362001)(66946007)(66556008)(66476007)(66446008)(64756008)(41300700001)(8676002)(5660300002)(8936002)(6916009)(4326008)(2906002)(44832011)(122000001)(38100700002)(38070700005)(71200400001)(6486002)(478600001)(54906003)(316002)(76116006)(83380400001)(2616005)(186003)(53546011)(6512007)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OMi9tUwCuos8ih/lrdl307YOx4g56YnQDzxU/0RYvNwJkBKPjEj28ORSt4lc?=
 =?us-ascii?Q?mbpKTWYmQ5yb/HcDye/yne5zNt5TofbYzXSSPAOy6FDFhI9UNPEdK4xKCyXn?=
 =?us-ascii?Q?cY8MbdR4vU0ZsPq4G9wcU+DfNOsfw9P81kEUmZqvD0jtbxl61BIg0Q0F2vWo?=
 =?us-ascii?Q?JPBPbSh8rJvpga0iU3xMwKGNenxm0vLJXDPPE2eAZ6KIe/OC+ZLhdkHvGMsO?=
 =?us-ascii?Q?VZSncEjzov/Yp3LOowFanw4eLtBWG9kM1Nt0Kw4I4WXTwRBy/FB8TNpbG15A?=
 =?us-ascii?Q?DU6cIpmQ0O8cLPfIgvuMmsPWpfi4Hyn7oF8QLLoT8DW/O31lyuyq3VfnMNad?=
 =?us-ascii?Q?S0e/zEKhGxCoJFbpraRW1ynAxFywep0aw2XeU6++Cc9f82m+6NRM0+nXrmiO?=
 =?us-ascii?Q?9sfb02rYnF5fJZq5YkUhIiWODYTXIUPVfoGgCbrrExIvKf30j12svlL3120M?=
 =?us-ascii?Q?MOQ15hnZfD+hM91//MOeY3DsIKWKZDrlIUf+FwIyD4SiRHDQnmAOLOofCS8m?=
 =?us-ascii?Q?9kZx3++tn4n4HsTlNxBZHM5q1W8UWEj20T6w50riq0hbeo3S4KWih7Hsn9zE?=
 =?us-ascii?Q?0Fs8QdLv+KGFAXCw7eFJ4DZ/ixyqQAthLGe+GOhdzQcVf41jgOoEwdhn3ax6?=
 =?us-ascii?Q?48F+LCuGeUPNNsyEHZT0TLUHqfFQ/9plTAxfKigNsDSGtxpHm63fbFhKGZiK?=
 =?us-ascii?Q?BVMd8E3M/M5tdEumd9aYEJcNAK2D97GuAJRznUP2B6cu4cEdLQi1+ypMDdRO?=
 =?us-ascii?Q?eYjE6ljzS//DA6CVhcR7gPOZ44h5rO7gza1r1t4sgDBvPmA3FcsdrSiuhtwq?=
 =?us-ascii?Q?JUwg2Awk/vyLJGoSI2tE/+865x+/6x3N0kEYrvuhvNSMosNr5DLESe1U+AN7?=
 =?us-ascii?Q?qlrzRsxzDuLiWBassyT0L/ugQVpj1lWoMaPHCJ2yxnAQexPSKDFHzXCbXFJz?=
 =?us-ascii?Q?BYCE8pRsGMznbC4zQ03g4zGmeEQESlOSsNVMhAxEbVVRshXPpr/rQNW4G8eu?=
 =?us-ascii?Q?GQPa2ONlFnMD1u9eoYEgKH6j7RasXH5ZgVzCU5ezEm2I41R3bv9ogdROc+pG?=
 =?us-ascii?Q?RVWowux6WARaCYbXcfd6azpK7TiDHJiZMkZBh7h9v9uN/4L4uAjsHfg2ImaR?=
 =?us-ascii?Q?2KrmLuVQLSA9LGV3AEzbxS6MWDFHmFA0cDlm1U3o/VNd1c2vsVgwVCqKq118?=
 =?us-ascii?Q?VLPCxIY+BTN7J6nIF+BI2LTHj4ufP0dMehMZc8HVRFmHjM/M+dKVrceUimsZ?=
 =?us-ascii?Q?9nbSV8F74jLxv5D/80FNd4kfTnNkYtwfvRXzr0mYIEJSpK2yAMGXh48vTwUi?=
 =?us-ascii?Q?/aUOT7UhsjMYHEguzofTAdPqWslI0teY+2QQbCzgxmSY18IzFTUWK+n46BqV?=
 =?us-ascii?Q?0jgBLcSAZpf7Ouf1+nUcxpJtKBnqobz3k6gVgObVEDcU+6leZ6SxGuZcDyMU?=
 =?us-ascii?Q?xAkYiaYhneCqXsnSU77vDz0cfFraL1pUSInnnbiNkyC4gBU01S1Bu5ByUxb/?=
 =?us-ascii?Q?jxbvtdCMrP3t4nYpbUkAmv1nKYNV9ct1iU7RFS/TNO7wmxnmSkAYXTSjf5g/?=
 =?us-ascii?Q?4XfZYqJL1zXpRcCOszQPUDxWHs3W9rkxp7MhiFBm/ozhrnJLcRjQcKhDpBgD?=
 =?us-ascii?Q?PaiIz5uAf6uyncRraMYqL+0KLuPKCN9qR++iMJlE+Mb4?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <101FD7B17AAD9D4DAFD1706274E1C60F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Dc5oMFLIwGNWscwsrcMwdSOo/5Pl9WfeUcyNbBq2S/ObfqGXr7/PA2DKTfxkdzzd1T4Q6ToZMeC4+rRg8jQyvjJtCo3Eng411DO0+8Pv238qwE9pxBBX61V8AnFMn4Omb8Oe4C8kNbmxljlxIx2dnWbVMFxaVOygyMxjAB7R2AAnczwoFk8iiW2cAyJinR6biLRQu9+67lLgTKXcHmZ/wx3h51GAHgCDBnfbCplKbZC2O8zpxwv45DBmVW7MGYtyr+3GdeIXg3eoHqY32il6nUWMBBQe/2mUdZgMmnbV/cpKIuWSDLkI8qy03iqf/B2PyIUebOMZEMGnFgH+77+yr/pA2V1RSmvfJi6N41mur3dQFuhJ1F47apqdmUKhFmPgPnqk6sOE3NzpES0dbX4XlgJDuPdkzvsxG9zq+HJqnMFJZ5+IIXCoKVGYN904tFifkjAufwKVYK8ivhOinxrKQXw8FqsaLDRjd+JgOoFmRQhA7XPXFH7nJRd+8xvnFQgbIob8uqL3p0oDjW9OxLuophgvsGrlLaAz+i6H9RkMClH0MxvG8NiERLk0XHaXJQnoW0XOR5wb+saK0H28X1YqlOrsNJulYOmxLNe7FDXNaes4KX5YLgM/sYUp1bPP9gx81RWcAshbKahX2AQWj4CBr2gBe/jVrewAwQ0qf8GxyF/KPzEyO6vYCE3ImR/I9+6mXxBoWo1fJGeTE3N5LpiKoefiYsCdB9R5Azrl+ylJG+NJ4tQKnoUpAvX6lSVqZ6J1j/R5f4g3tYAg1REJFhrrbzcTNLggsXkR0b3Vfi0uJMcdj5d/vI9FE9djcoruztLV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1997d92-5810-4730-9b08-08db19db4579
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 22:29:35.6874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /JY9GFj+TD8eU/yuzMZcHIaU9SjHy1Fsac51MypLg3+/aq15/rVkXdR+inyySi3eAPHVX45nLXs1fsgUuJgs6xE87/WSiMWE9y4cBuhHi1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7306
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-02-28_17,2023-02-28_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280181
X-Proofpoint-ORIG-GUID: n4HeUtwufk3cJ_K0X-f2XpdiQPhC0g2i
X-Proofpoint-GUID: n4HeUtwufk3cJ_K0X-f2XpdiQPhC0g2i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2023, at 7:20 AM, Daniel Wagner <dwagner@suse.de> wrote:
>=20
> 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target") added
> support for FC2 Targets. Unfortunately, there are older setups which
> break with this new feature enabled.
>=20
> Allow to disable it via module option.
>=20
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>=20
> We got two bug reports, one which dependend on revert of the above mentio=
ned
> commit to fix their setup and one which depended on this commit to presen=
t to
> fix their setup. The only way I see how we can help out here is to make t=
he
> feature optional.
>=20
> drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
> drivers/scsi/qla2xxx/qla_init.c |  3 ++-
> drivers/scsi/qla2xxx/qla_os.c   | 10 +++++++++-
> 3 files changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index e3256e721be1..ee54207fc531 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -192,6 +192,7 @@ extern int ql2xsecenable;
> extern int ql2xenforce_iocb_limit;
> extern int ql2xabts_wait_nvme;
> extern u32 ql2xnvme_queues;
> +extern int ql2xfc2target;
>=20
> extern int qla2x00_loop_reset(scsi_qla_host_t *);
> extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 8d9ecabb1aac..a6a08d475f5f 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1839,7 +1839,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, stru=
ct event_arg *ea)
> case RSCN_PORT_ADDR:
> fcport =3D qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
> if (fcport) {
> - if (fcport->flags & FCF_FCP2_DEVICE &&
> + if (ql2xfc2target &&
> +    fcport->flags & FCF_FCP2_DEVICE &&
>    atomic_read(&fcport->state) =3D=3D FCS_ONLINE) {
> ql_dbg(ql_dbg_disc, vha, 0x2115,
>       "Delaying session delete for FCP2 portid=3D%06x %8phC ",
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 7fb28c207ee5..d7c8bf3a6f9a 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -360,6 +360,13 @@ MODULE_PARM_DESC(ql2xnvme_queues,
> "1 - Minimum number of queues supported\n"
> "8 - Default value");
>=20
> +int ql2xfc2target =3D 1;
> +module_param(ql2xfc2target, int, 0444);
> +MODULE_PARM_DESC(qla2xfc2target,
> +                 "Enables FC2 Target support. "
> +                 "0 - FC2 Target support is disabled. "
> +                 "1 - FC2 Target support is enabled (default).");
> +
> static struct scsi_transport_template *qla2xxx_transport_template =3D NUL=
L;
> struct scsi_transport_template *qla2xxx_transport_vport_template =3D NULL=
;
>=20
> @@ -4075,7 +4082,8 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
>    "Mark all dev lost\n");
>=20
> list_for_each_entry(fcport, &vha->vp_fcports, list) {
> - if (fcport->loop_id !=3D FC_NO_LOOP_ID &&
> + if (ql2xfc2target &&
> +    fcport->loop_id !=3D FC_NO_LOOP_ID &&
>    (fcport->flags & FCF_FCP2_DEVICE) &&
>    fcport->port_type =3D=3D FCT_TARGET &&
>    !qla2x00_reset_active(vha)) {
> --=20
> 2.35.3
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

