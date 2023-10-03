Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA4EE8FDB6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241067AbjJCUvQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbjJCUvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:51:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC91FAB
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:51:11 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I56AP006407;
        Tue, 3 Oct 2023 20:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=OwQ6YP7BusLriMe90lEOm/w53nK7DGJrxlPmYW3GcOs=;
 b=jaaNA7B3qtm9UBy0s4vaf5tKYnaG/euHBZOjInnaBqxPoVCHnIsn6dUrRadhI/3iY2mT
 5oOByyfzczYdbwqRE+j6aecaBcUJLf3dwpfKzHUCE3sPo3GmOYdNuZuk2w5GPgRrRZ9d
 bk2sCZG8X76ATJQxuXfBOXovPCz4uH2y3Dtx7OKtm5Jy62tTeL+ic5Wp8fQNOxP4GruK
 mwgVH/gMS0zysDehhpEDJdP1b9iv3OhilVRMPKiTitU+IAY/czh6ztYvr8uQUxQDH1o4
 2+D4wDmqj69Q03WCwMqVffkIAAPsR19aceer9ax7BClEHz3+ETwgCRK5SDoGkcf4BIb/ wA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tec7vdnqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K0bYu025731;
        Tue, 3 Oct 2023 20:51:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4d11hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+R0AxSulu0lZM0heR2CNK9zaeLArfKr2I8HG0pjwvxhXct5pnMU50mEE9Xt3cAghHQhaelLQw5OvGJVWEXRfR8Z5G+BJ1j7XOl7ZRLEp/7WE6KDv6DzB4RWgSyILezmkd3Dp3vYEU52ht0OrclOToVFtS9wkRNiUPCfy/g2do1oC/B2jK5BZOTy/gprdmzWlOapQ8Vt+rDAPVWsEw4us9jzbmh8u+dD+F/WEozzaBoOLYPKpmbBd3ogLAFVUvoc0NlJcAbv4NhpoTM3iTduB9A8lrVitjfgz+X7G+3BIUHGHhDcpbqWL+NFmZkQZti4WLYSA2Ot06PLBvpfaVx0eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwQ6YP7BusLriMe90lEOm/w53nK7DGJrxlPmYW3GcOs=;
 b=e4v8T5nKioC7eKrRWkHZZSnnPly1ap4DPWN993ulAX9gccU0ENBhVNtkvN1gUybXszzYSFwiaXXACo86ub7+q5dZ1sMLhVMYItI5Q5z/LepfWDD3BJcoWDJiSeKDRd8pJ2DgO7NEzFNfpkb99LbCccuo/4z8Gkp7XYstFRXOKT2IH6jsBEVvxfpM2BmxSVsm2JgDOoMTmp18UdDtpJymMGQuLajKq8218zUvbxSHGJ3DCbCG4v+UpAAN7CyUUL4n2IwXGf2dMEli/xjDbLfDBhZBbS/z3C3tgqnnrFApe3mWTuqrVkm1t5/xYKaPi6OT103l3ekhP+dsaOPZFqfrfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwQ6YP7BusLriMe90lEOm/w53nK7DGJrxlPmYW3GcOs=;
 b=H8JsNG26tdcRk5frWMvkj0R6kTfgQ5WwsK98EyxFcsJ1NhZzdV+DSkK6rcEyIM+tKKQUP6J0lGkafh7SuNQaV9uFWWan2SV5MYUEiZ1RK+HNjO8ndPlvo3RFUCiZb2f1fsJWskb0gOrI8i5mCRISdoUEev1Y8onlhzbIJqnJhFY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:50:58 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:50:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 00/12] scsi: sshdr and retry fixes
Date:   Tue,  3 Oct 2023 15:50:42 -0500
Message-Id: <20231003205054.84507-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:5:120::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 696257d6-5c4a-451e-812d-08dbc4527160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQT/4YigEnpdfZ9oeEBK/leyQlpg1dDls9L45XoCKdnSO4QBeKCxLM3nsC0O+FwKn/9oKULRB+5Snx2MRA4Tbq0O7gf1AXhGwLkd9r88RpJBceLUeuMnoFyzR3rSxwzcju22cgZpYcgmA5YSEgEhOijsam6/Rwl9YHIXoZuseSulsvkE31Ehj4gHGQVN2/fpwwNQ5iz5A7H84m5z2tniDIgCrPNSTKTStOzKggUcRMrAkXjVMpKkdSnNaQodZlJf4wM/rIuYHgNJ0f8bPZsHRPwK+p6iHY2xjWFRuNQLn+mhds8xRBlYhTr91m5x7abNw7GLal/oj82pWqE6zmw7Zx0R51I5fxzk4VZrSNZwq329Q5eaLet/AzJay/shrmoAy0+GkJXvzkuHqRBRNE4hp1+/1KxlZ5eGl97Yi6eJLQ1ABAQkCDgyxZPOW7Ire0yYfWtOvzw2AmRT/757hN0nUx8zTty+yduhtlHtv8Havrgi+asZDzop1xHXG6uJpw37660NsBBscBD4nOj7TaCeKg5oZxB6AW8zivBmXlF1HOUc8m1PvZFAvR0zQ2bXb3ml
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(8936002)(5660300002)(26005)(478600001)(6666004)(4744005)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mpep6efZla4NkN1YvYdFMD7IHK8D0ZS8pjEGTispTFUSVCZd8jtTYmLS49Bx?=
 =?us-ascii?Q?fd+RwGdP/xcd5QSdyDUMG1WOtSf5S61DFNx5lrOt7xN3GisevsRYkPbouPu5?=
 =?us-ascii?Q?M9CmvgIpXjq+1QRUNX3ba/ZWtHAI9ZkNW8qz7SniGImwOwsaKIEe62ivdfFI?=
 =?us-ascii?Q?pVAev/YBhouH1p8Ctpv0p8qWV5lqR3AL1DsOgb8LVEfDO5KRDubKWAlcPCp0?=
 =?us-ascii?Q?/MOS96016ad++vvAbwA2Y4D++guCWfgvs1EelHU4F920St2WndxBEWAmfyZY?=
 =?us-ascii?Q?P+ipkPhgpckNWLSbzPrB+QM+B6Q2MGKWEBQ+Qsob3IJgTNLetzIB6mBQtzDR?=
 =?us-ascii?Q?RcFGlk3s9E8OvmCBmQJjO7WgT5aDNQBXMWINGbY5H+2SMVxRAMxUotl45Lpc?=
 =?us-ascii?Q?QR3II7AmRONc2so7WX/lYggdFGXa3rxyeRgJ9sMa6IqU+o/kk8G+jJPPefrU?=
 =?us-ascii?Q?8oD7rmdDxHrdFC8pIwnTBjyTJ52BnXjLjTcLjgPoinQKt4+nudjF1/8w56ou?=
 =?us-ascii?Q?L+/ia7nOzBG63GusHs/0l+PfhY6x/URtNaWZVPiqPkvRjOfmoywIfDPBzDyW?=
 =?us-ascii?Q?jClmxahv/WCMJBbKcb/nHmQLKBMw+93ANFUOZ7odHuPetmSdVPzMtpfeXeZR?=
 =?us-ascii?Q?43lp3aMNY3HsKV25AfI3DlmW7a8hJOfQrJGx4Eb4NQSD3gMOiMyLWbv/N4mi?=
 =?us-ascii?Q?HUMmlETYEtvHeIdKVjdbj2y4y5ZrzCkmjV9rVcRwAcJz/dQkI1Ce3AWaNeEZ?=
 =?us-ascii?Q?E2usNUvzAnHbXI9qMQEsZSIUCj3lQ/iNRosyORNxpOmEKBrVS5TCWG4iTVQh?=
 =?us-ascii?Q?linCRYrAEnyZCWYhGoVD/q4UpoQo25EJQKG4oIeS1Uv5hbXI/Eaqw87woRQl?=
 =?us-ascii?Q?KzKHc9vFvcDeLMYkI77jL7xBhnJx4L1iR7gTZcQdE7g+Tipuamyy2y7cI0yL?=
 =?us-ascii?Q?/2MsfbSVEES9G7UUqweHLAUuC9/wGnvcfR0aLt4WLhJ239jwDEVASDbCPduM?=
 =?us-ascii?Q?q8Otd+aZYU/A+YrSmYfizq9yw8HKBcusPNL5GoJeHQhIG9guKGe6cur/PMWL?=
 =?us-ascii?Q?eeYiBosicqpHJeHDb0SaH8EQDK8hZYUNPXdgI0aLR7fas3A4lR3XALhZ/go3?=
 =?us-ascii?Q?i8gRcpFoq032Yx9GFhdxyJ1K5QOyp08gRSg9uazZsiD/KmzGweJDRkmRnJVO?=
 =?us-ascii?Q?sXCMmOoJdFdoCgZWGhLpoqPQYRHSXsyEJ0F/p2wzthRCOMlXRCVpLohOxYZ7?=
 =?us-ascii?Q?PMciKnQPGDllL2zSw5Ri4yHVpJeAmH1N38Rfa25Xekj4+V/AdJd1hQ5q9kU9?=
 =?us-ascii?Q?Dv4RqUseT42sDCvWx4znEsb2xv+oRmS9/qWjxtRoPS1X/naStbrWrkW0ScK/?=
 =?us-ascii?Q?90TzHbbvSzR22Bf0a6xaDkieuv+Mz1z3+0zCOgza4mf78+Z2gzaRlRZiPNVA?=
 =?us-ascii?Q?hSZt21n9QVHspAoBJY76LXk04dh+jeI+8lAC/NOtEuBoRKbrIglFzfYlHmZ6?=
 =?us-ascii?Q?mssiEXHRCp/71K6NKKU5HAMCBtbcNt+FyRVUO/Wrn1K/BCKpnqiqKck+V2cm?=
 =?us-ascii?Q?07I4yqZ7aGfaencV0Vqg0HwKBMZBkqVsYWEOGJRQqo/XzjyaNrtuCyPwVViS?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 422uH6AXJ/XO7T7JL1stqm15LM+DlcNLHfQJB2efxT9Gd/k+Dlat3V3GpGVuKd/A2/c5LZnnI5KREYLhrBdYgDKcbsQogIfphAl8Wj//VA0nt8KLBiInERi4RVWaR0KTKDuVKplFA6f70ocH29lnY2U6WfdvJoPFVLsRC3PJt+wF6UOSaK6Zq07gTOLNKEkDZn2lWUGv3fTWMTqVQMLmSp/C+DgoJNZQlzXehC5XAWuagsuvQya6Dd06fzLwEcNUB8xGu266J+22k8SXoybtcvEOQLaWfsr/LSfTIHSulzPe4by/+ObEYbx4/E7oU0yNqzM5L7seAIUwHEhMdHGMfrKVCDB177MOxcGpwG4ks6xsNPRt/u/wqVQFRZxTK1rtth6vetNiAiPThoyCp+YRP6zdGJTC0pOUVdo9GP2tiMz8ka0nK65osm/hFVq+2eaeVUrukvfoJ1+3aaNcl6q8XBF/Fq19vPUp25q2J8CzDp9yuqjXsJnTwbc2qd0G+PB2nQCiVj04qtZG3Kws2rOTJ3dwlD5XIt51o51MlCakM8CmRLyR8krq0ftSO43CuJO8Br5JrMmF9LLQ0xocJ8lZNZB+F5K8LGaHfn3n9sXlJRBQcYqNGRTGkAPyzDJh974G4VNSWs6MXabjCLRgdghKbxzOWAyISQy8HrVRwzQvHmmjYLEXclw2wEdFjUte0hkVVc6iDZF5XHBkb5Qu6O9Pve99BVttBNQl0xQla5Ps9m01WlVeP4FiV1bgC2P6ZihTmkaWJkq+HsLKqEXyPed5cm6JWJ6e+65zsSULY9bs8f3F5yYxKb0a4kQV39poM2FyjkZ7bpSx72duL0XGpw43DKf11WtDaFWehOaF80MeXn4Kk89YHx9VpiJu/q+zSrks
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696257d6-5c4a-451e-812d-08dbc4527160
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:50:57.3980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cfmxyPdKQXJRkzXZR9cpbqYIA7JiQgRAiKOrG8pdb8zdTW022vrc1rymb9oWYv+zYfkRSwVpCA8zGBfJECiEnPikMIQ8AJQ0sfJdYxUBcaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=905
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030158
X-Proofpoint-ORIG-GUID: SLTa5XAiSXJ694dcQNRuDubfvNiLn2xx
X-Proofpoint-GUID: SLTa5XAiSXJ694dcQNRuDubfvNiLn2xx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 6.7 scsi-queue branch.
They only contain the sshdr and rdac retry fixes from the
"Allow scsi_execute users to control retries" patchset.

The patches in this set are reviewed and tested but the changes to
how we do retries will take a little longer and require more testing,
so I broke up the series again.


