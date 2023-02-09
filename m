Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B09EC636D3
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 00:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjBIACu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 19:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjBIACm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 19:02:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AB82194C
        for <linux-scsi@vger.kernel.org>; Wed,  8 Feb 2023 16:02:31 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318KwnQI002957;
        Thu, 9 Feb 2023 00:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=fcgHNm638Ttzl45uViZiy1S83R1DnOfmSrztRQsbLCU=;
 b=azmw2pz1C5y8BYpXuVBiIRCdp/+fYOfy4MDHroEvFp1JdWFQvWNHNSKxv0+LDjLBrHin
 FHzJx2VntaOVVpcgiMVvjtJgob6WqlNS2LT/5ltLl9AtnahgZDvWfQC5HgXhYrLLlBl2
 8rigVVdnOHs0HTwaFqAyo9VRmG7oQCQRNhwa0sC4qcZWKcnXLMX2Qfzcfy5skkDaG/ZT
 ubpakDNfeLfch3zV5rY2mBc6vO6Jojm7AuhedXw2rciy8UNt0rzsv5kKhtJUSnhiddwO
 H0lQqMof9ONVkbvMJGQ42K5AET+iH0o0+CfRnoB/zF5iPS5pjh4wY6NGjuFx1c7tZFvE Zg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwu9hjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 00:02:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 318NJChm028341;
        Thu, 9 Feb 2023 00:02:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtegn1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 00:02:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvVdpQ2xTvWvy3+YQ63mogn9dPfEy5YyvjPPTTJyph21bTXL1F+8uEQOZwI4GqP2TI1DhxkzutTmeocU2rKzrWdBWi7DEPA8r8KyBmXS0Q3iddTN7PB4v2bJY9bacaxEb9ZoM1zWzs8fVo/FUyZK81n9FaZLQKsOu7dVh2geB0+c5VSBgtfWOfKIDCbvUV2GpLCK7zOcfINVpf3HmwLzH04FIJQ9qv69vzXc9ZhLdzqyjZ4R1PXmtzA2Nq1c4YRYB1SKqmHgy+DKA3b7a5cwF/fK6isQqe0bO/VEomtAUc9vpEib9LZPvZ4zelU8Ev3Mt8XeOLbJc2QndHyfW332eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcgHNm638Ttzl45uViZiy1S83R1DnOfmSrztRQsbLCU=;
 b=QI6QC3RI6zXd9a0+eWsRY+n4wHiIdD19qEVUxwffHAPfdGGmO33OXDrwWldCnX5Q3/H473tCKpTXM4/VSSBXTSyVasz0TwKRuIRjn7EP8nF9VmSX3SKFTZqto6BY2O41Iiq27/ISKDvXUmb2+xRJOPeytt2HUkbIoPFc1L6s73TBqehPLTNDJhiy9nXGSaS7eE77W13Jer8TilxPkWD8BFnFM7Z8AaRl9ugwJ40QFZBQNBSpzDdvLa65dc/V0iinvpiw/wy0Wt+qg7ze8i2GTRgqh6Tw9uJEtrO7eErZNU29AmjVSOzYHDVWrl65kHI12nuFc9I+bPiWFwDPcWF87g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcgHNm638Ttzl45uViZiy1S83R1DnOfmSrztRQsbLCU=;
 b=S+X0zddcqa6tfsroSfeLnjIQKpS1ekTby+Sl6OcEVsjiuF1X66bpwc5gX6Sh5AuVtnbrokaXeIZi3HGydhvD6u5QbW0n+ZpmCWNWTuBbbVHefy/AlyWUWJ0ODeENTem2mT4kGEB6ENXP4oIeaIGU2bUV0ErsxGOKgskuxdHU4Cs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW5PR10MB5739.namprd10.prod.outlook.com (2603:10b6:303:19c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 00:02:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%4]) with mapi id 15.20.6086.018; Thu, 9 Feb 2023
 00:02:24 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH] mpt3sas: fix a memory leak
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cz6jyad8.fsf@ca-mkp.ca.oracle.com>
References: <20230207152159.18627-1-thenzl@redhat.com>
Date:   Wed, 08 Feb 2023 19:02:21 -0500
In-Reply-To: <20230207152159.18627-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Tue, 7 Feb 2023 16:21:59 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0149.namprd11.prod.outlook.com
 (2603:10b6:806:131::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW5PR10MB5739:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dd0bcdc-fd53-4ab7-68f7-08db0a30ec31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ki0sxbvvgf5K5oY5Q5Dxv0k8dm3vSl/EMLO1gsCs0tFaJOhQVkMAhYTc+CyLiTkvB1MfyGISfsVB2GJoztQUnkQV95G7f9RuVuvmGfTDjEUfs6zOONnAqAIwNSBAdut1A/0iIHvvWueuJNgMJ1bWwqye3uGCMJ2ltt8IVVaQo2ep4+AaZCRFaTQt4TIikQNHJy21N47VdQhyJvWipGS8dUWtBBIr1ZDvpIxn/ZbLS3U4FtlQz8TcMcOzd5jFamzAZzg1sIfofFJOk1BsQgCy7p3plSO5HZOLo8d2josww/YFM+ChrnwwhJDRASRXW9bY2DvY0W51P1ZRtjazDKb4DrTIYVR4/nopvofBxLjD368KLP3FvvCQqmGrEvdRP2Y4+HJFQD6FvVCJcuvyf9m/rsqPwmieQSfej6csTzXQNrBLxPag/EhK9+SVGpwAVM5NkloaaYymeuU9BrXeRpcMdwTcUDkU1LflbvpR6n/dYdpwR/9L2L2Nu9N/SkFiR5t1KO/SglxzwEOio7dvDZvLXIwgmB1sArRpHA2Bvuye7uQZWkoprv0hKJGnM9Iz/z9shUkksT0F3/YU5FOQNfFlwm8XjNDykB6UlJ6Nn+8L/J1BTSL5BvODPMUj41vPJ4qNDqr8G4j+waDKf0TA75gC3L8r0N4Hlwr6gm5QrvTLDEhfzXoZ1Rp4GOXGyLLkyDRz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199018)(6506007)(6666004)(6512007)(26005)(186003)(316002)(2906002)(8936002)(558084003)(36916002)(5660300002)(478600001)(86362001)(6486002)(66476007)(66556008)(66946007)(41300700001)(6916009)(4326008)(8676002)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0PtHVXHJIru7jzKnYy0ToNyWbylWicQP82kVAFC5I4RTn8ZtktIkwnySxOLU?=
 =?us-ascii?Q?ae4ndz/06MUStJSa6NO7T4OfC3hWYH+/MgFPTKpDHR1jxnS8hMxMs9sTPF7s?=
 =?us-ascii?Q?zAvZHgdG3YfuYUMOcpAH2+eMU53QjCGEu7wDI60Y+90/j2KqcXNJV9r274U9?=
 =?us-ascii?Q?uei7YdbUMdfY5DTG93IiIiYeEFE8ZCIXbn3jRI3kikku5GgZq2EkndQaVIgR?=
 =?us-ascii?Q?shKrSXQqJ9NorqSyeZo1ySzeYvS49Pg9utgfhBIRsFRfMwhUAAvtkAYpO9+z?=
 =?us-ascii?Q?qAB3JTnUO8MO6cwDgNhZN2hP4NPVipfVKh0WLXKuLcL6k/xh5vdkwkf5SOcP?=
 =?us-ascii?Q?U4DdZrMG2auV3LnkSQGQiIMDQtLpeUgkBkPZ8WMvpHB4Vd9P8vq6epfB00v7?=
 =?us-ascii?Q?I2XtTbrW1HpJDidRVtPtJmcnVOb3KwM7Xn3x7L6KZjjzdVKjBg5RNB9I14h7?=
 =?us-ascii?Q?EIR/u+UqhBet1fguTPOufqI7f1xpAMAlZ8cUekAEUgiH4OGJAX7qUz0acu8m?=
 =?us-ascii?Q?7sUrks3wNOt1f1XM2FZe+4lFg3LkEzqvSCwkR8zodrYVAf/WMHOoRttIUpXa?=
 =?us-ascii?Q?C1+sDhyA4+dDj4rcKR7HMSQyOr94D9i7CDmw+yAp9lGxu5WLrtxDRww3gjGS?=
 =?us-ascii?Q?Kechq+eaj2bYisGhqv9+g2UFnyhhW/QZIQk/I9qLDfAGtd8u42ZckUznhpsF?=
 =?us-ascii?Q?W4dANr59WpgfjZyGwjIFuvt1C4LJElX3W8+KAD0CuK6gEuV9XFE0XtVPd7eX?=
 =?us-ascii?Q?Td9nk0Wkhim25U67WPkzT+qe9YcVTgJRy4r1TyOY/qinrOB/Fq414gKHulWO?=
 =?us-ascii?Q?zxB6EkEC091ljwHuJubbXRtM8AsiV3lD4Ho4TdpKPMk8gWbirh6JJQPRBmAm?=
 =?us-ascii?Q?KVq2yDl8Ls3Z1RBjmbMEGQ8xdEkRQSxYqdYx8p2xl/vVyCYJ0qtJfyFJp6/n?=
 =?us-ascii?Q?TIDWPGSGJAE4gugMymAOwsC5aw+0TBjh+IQhr98Aj9wvCfikKgFZtf9wt54Z?=
 =?us-ascii?Q?Vc1Px59zF6vyUG952A8FA/aptsatndy6QaCHePq+qXXjgxoTiIxVdZzxeP12?=
 =?us-ascii?Q?hlJogk1fzCA65H3ff7BoMiysiUS3Ew0wZ2dUNLyOx8FQRrWNtoIOyPQ3/92+?=
 =?us-ascii?Q?zoRZeiGXKLsmIwdfSgNVITaFjvfMwta44mvVnY9ZWHoz1ue2IXvLtyPtPy44?=
 =?us-ascii?Q?GbQqW4R7cx2op2yfF4ThpU/Ge1DC+C1X1smq5uQAonXhkc7uiL1H4MPfz16a?=
 =?us-ascii?Q?BMopEtyZOHK6vfoR3B1Ia4uBn+owrLM/j6r8/I0VAEiupujD38/IH8OFYs8O?=
 =?us-ascii?Q?EtTPPmq+kq9P0xYxV4qTL5mjFhlLaahO9ajLwBTS1aUn0YCB8+H0eN9RCuVp?=
 =?us-ascii?Q?NJ27b1bfKEJJvaDZqTktVSE+C46pd7/y3wrFaEJj9jErimyTcUHuJC16MO0F?=
 =?us-ascii?Q?gQyTJa7yGvzKroTVqW/xRNvZK84yWSX4quqNty6DQgvWJ1YfMonHjH5hilaH?=
 =?us-ascii?Q?8iB3XhW5CKlsc6WlHZcUWufwBBTIPPbW3iJwq1Fhq9+pVDWh43+s5Pn25ldG?=
 =?us-ascii?Q?HztSgAKr0/Eu+QueNHGQ2lonnprnNcl7CNlSgy57yXMeF/xRIaXHcjk68oYp?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MnBy4BQ7O7mG3/8rlVYWJaVY7wnEB4u2Ox9O009GBYbcCWETt4iMeX5b59fjyEmvm++3+DwODOImlvOol7nYKxu5BV3ct2DVuCl13gCba4WScIO08uHGNnod0Wll/J9MDtpwmABnjNCa5UbxlANdSWpDRUSZPp54BM740CJHL0QNS649z0LX651XyTiD4cGqYPvi+UsZrqFhwtQfA9on1jDF1wPfDrOrp/+MfaTPzB57xfJ/lGFZT2gNNsQZ13BXTlINsLOWBre6+JHjlGyfCCrHrMMwgGSQPF54S1P+hxesaWaL+cJ8DLpBbgQkY7FTF9NJOB0jEDiF2/5LXQIj0Ea/xYyv6le/RP/nhKcma9ohH1wQZHmj4HcwN9TpqfnA4OkDX1bq2802mULhz2xjbhIr6csIw0D7Qfz80pj5HNWQ3+CQtqrRzs01dz9IUXstveMRVseB1By6C/P2oa5qQ1ZLPhgHmEgU2uvQD43txVqcjaQPJKy27Rfhz2UAkYOlJy4VUt68egGtJCWaiXjiR6Kkm2yg7UN1/FBhTl3PaXZxuB4q+uiwTWPtO60TTUIbFKcIehKATH/P840knxFqTHYXvagSXZWeVZSkx5rEXFNP/kkbVS6zz/+8N9ZoXwj3bdT+dcmeMBXlr5TuhAJzcXOIvuftRTFYe1iNX9UDF4/y5xucZx1rGHhZ9bSZpnv2nVxytp37sWhzhkoRXV2dxiam9++Np58K/FCfPL/+KyqxbkQU0Tf8c2IBiFp6R56dXvCrpRvoN+jJBlyEJY/slxFWMtp2YN5deVv56xDjNsVllKsem58XXvcKP5VJEkA0X6svD3hqWS0fhSu/WlNITQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd0bcdc-fd53-4ab7-68f7-08db0a30ec31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 00:02:24.2613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUj9yBbAcka6CdM6wn8EOgnKlYBLBxzWlBm0OPjy2GvdKUlED1j3rzfdY/thMrh0+KJPWxqMApX6Lg0EQxaCOwaRcWLeBsOMQMysHyp8G04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5739
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_10,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=590 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302080203
X-Proofpoint-GUID: tWFOU5a7QbVMSRSyqpqMwQCev_m_iuV0
X-Proofpoint-ORIG-GUID: tWFOU5a7QbVMSRSyqpqMwQCev_m_iuV0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> Add a forgotten kfree

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
