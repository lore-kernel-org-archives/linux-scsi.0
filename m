Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C72C88CB9
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbjHYBcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238873AbjHYBbt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:31:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331D31FF6;
        Thu, 24 Aug 2023 18:31:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEJdt009502;
        Fri, 25 Aug 2023 01:31:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=f8sOKxIbWaItjJJavN3HoW1GMHYsFtaGa3Wfdezokkk=;
 b=QEnkP1/ZDWXbA3BWWlT7QHz9FIzx1lc1su47+Vybu1reDStyIfQbDA9SnUdRbB6MXpRh
 hZtu5oc+HkmHkA5C0KSFGz1A9SeYGBeEtczFdXOd3Lv753I1Bvh0n3ESP59PD/6EU45W
 wngz6pZ1D6Me9yZetVTLmpEmtRDCpALeT2pD915aM7bj/RJ9hqMcHZrcZsXuhuofUfQj
 4+kj87NbnIwWcz8Rh4vLgJ52SzSy8AgShS6YivYMWc2b11F1TPGmd93x7tOSr6YJhS10
 b0TKICoyGC08MoA6lKcYxr0dWweWKd5IZwt40TUKUEDToQRO450VqlvXVt8g+hJy504J yQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1ytwee8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:31:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P0KVkh035809;
        Fri, 25 Aug 2023 01:31:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yq7j0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:31:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLlwsUUJtNT4G0V4NYn06NJYMqwvSpJGYb0BXYplm0cNHySbYSeX24QJ4gqUnRClsmhlcIxNcVf+hRoS2xSd/jfR5s7a2D8cFgc5v8wNBzMSE27YdAuoYW51gwQ9kU8XVtsM5lxC+Tuh+iswpW6uj1vZVspAcsJ/IHbnyaT3cllYHLKzLCULoLdvQv3qJVBTPPvBYh2VQVb1YQovxQPQVUTlCYDxl126KCgVSl7jNsvnXNiHhllzwsDzFmlN3lLQhePLyKIeK/oQADQ6K9jsLk21CmoSg5bFhj50YwzOOzJOz1jIXvLwo84jiju0V6dqUFhP2+2vToyrIqbVqUlsXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8sOKxIbWaItjJJavN3HoW1GMHYsFtaGa3Wfdezokkk=;
 b=ARuCTLG/NmknDArwtrSaZ6y4VRhkQhXv86mu4sej2u+lxs/r53geM7Dvl4ayeGi4Dl1sjdA7zp/iZjtKhzM4D89yHstVom/6uSCRzmGhncQWrAuLMT0wImJVao/YRfYFoCdwufzBr3uSR9TCA194mF4pb3w1aTr9NtCOtzCy09hdnKlhSdoJgj933YuotFNERzolzrqVm24XDwSoTPRamiMGPSkJLjZc0rHLa94NH7H1SIn/os1M63JbKpUO5e9/ozRysgcOMGKUXK9YbWZw0aXvUcS8yY+1+JnLQ+SVozNie9kZjEtq2UsBPmFe2GZbBy2tpYybd/ti4EqZao4yEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8sOKxIbWaItjJJavN3HoW1GMHYsFtaGa3Wfdezokkk=;
 b=ncImTAsqcLwzVy/7r3uWmP73Jx6DJBnVXecH8QHX7h8VAstPfw8+te4Xzc96rwjJkMcqn6TtKWIcAadFtH/tylaWxg9U0oC7upZ7yqMHaJGftIGSdpduInb95RcuA4fDh4zMgx7k9PjDwjOPHhiKkf5OmxKVSrSGJPLeHjGZ5D0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6855.namprd10.prod.outlook.com (2603:10b6:208:424::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 01:31:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 01:31:26 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Rodrigo Vivi <rodrigo.vivi@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zg2f3ocm.fsf@ca-mkp.ca.oracle.com>
References: <20230731003956.572414-1-dlemoal@kernel.org>
        <ZOehTysWO+U3mVvK@rdvivi-mobl4>
        <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
Date:   Thu, 24 Aug 2023 21:31:23 -0400
In-Reply-To: <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org> (Damien Le
        Moal's message of "Fri, 25 Aug 2023 08:42:13 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:5:335::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6855:EE_
X-MS-Office365-Filtering-Correlation-Id: f214fe8b-0519-4735-e150-08dba50affc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vra6l/gNjJaWbh4cxmNgI2TG2tUTlBRoFKWkcal3Oqm7ZK6aN5l2hcspksq052WIQoJnml1KtenzqjmQZZ+CBzedxdSl2NUqvaCrheko2ieXjXkHn+EntcyUE4Uvo+sI+L/u+msXCTbHuD8Ha05cU1tWgaZBIAWe4GJMu6/tCIhkgx79UTud/eWcBgpPlB3Re5aOPBoOcfeZ1ob/aU2fHycRowNC5t8FhbgWP8r1IBGTGanCMn6ObqYCJTQZxOiaMZFoPrx02okSHFW4tVhrjFIcfVWjwo4cNdyidKxyec9Zs21OmflIVZM229kF2sHqqRh1Md9O3bY+samhpyWVswFsC/sPrHWS/ZExhtlGmg6h3GgLyvn0w8lcldTCOASPwSCeZpMf1p34Q8p16OLtrXqtaEjkOHjXUMKbsW8RQb9h5W4iU1iqvVQ2LStKAhZxHitCXHd0GBbha6hU/c/kpy3HtaVegsAzv9DN3/ECqmPHmYjArTqeG4KSPMjFUno2tisxzB6eNfmpxH9W/5KKaDVKeZ2S04KkhLHPgk4fpLFrbNYNlcffc0j8PR5gUdNg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(346002)(396003)(136003)(186009)(1800799009)(451199024)(54906003)(66476007)(66946007)(66556008)(316002)(6916009)(478600001)(26005)(38100700002)(6666004)(41300700001)(6506007)(6486002)(86362001)(36916002)(2906002)(6512007)(4326008)(8676002)(8936002)(558084003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lUwzes0ZcFQA/9E2dJbNAfvB+fo7YLjBH1khzEfhqQ1wTxPLH0n/d6OpA6Bs?=
 =?us-ascii?Q?2FDeHJ0zq7HdVEE4PWdOqN53dPfDh6S1JqZCO3nfTJjiJ4QiPt32j/xDgji2?=
 =?us-ascii?Q?mk8a2t5r/7WIc7+6gDrMzgMGSCdbHEiYmtmDC5MY+YzImFPzRMqfQRwSUIaZ?=
 =?us-ascii?Q?LHXomxSFiQbkuOxVA6H9WBs/39IG6bdM+dcK4w/e09LbuzC/1pyxArE2rb9s?=
 =?us-ascii?Q?wp+hwWqmo3wRvu+/TDFEGIvj2whaGb33kPcpTxGHtNqAqz42x6I5mYhvWDpE?=
 =?us-ascii?Q?MiesgwudzAx+DDC2+54x15t9fmtW1/CYdPkuJy1cWjAYfUdnhFd75EDIOMWB?=
 =?us-ascii?Q?I+h/0/WY5f6GbgdD07OOjS7ylf+13I/b420JUXcYJNI8P2/+rS9bPrj3a8st?=
 =?us-ascii?Q?DAsXPdj2SYP20JYf+IYfwCuHYINPPSQBYBMtDaeY6NLUmKZxKuznbVwgBTk1?=
 =?us-ascii?Q?X7ITSqtPoZtT/mrQmsJexaSZBpqlRSKPSmr+8ePdXJxb9CNW7EK7ZhG7yJ9Q?=
 =?us-ascii?Q?uoV0iqgWCbCCd3TyBiJbHmmLrGXiRxvL+UjDrd+9o7maDOQMna61OyBRlhMu?=
 =?us-ascii?Q?8NYZ/DmCNRQLshE3JnjTg0+Z7rB36luvImPiugRe3gbrxQEPKa4HP5821LgL?=
 =?us-ascii?Q?Yusm+iBNDvg2yr4JPcTsUbrcXGbZbu/u6fdLNVBrLsLMCOtJxQzoXSum3HWc?=
 =?us-ascii?Q?KnudqJJuc0p8FZtduZYTKNwl1MS6W2LnaNlDtUnSgdnhLsxcTxhm4vpc35NM?=
 =?us-ascii?Q?aNKSFPP5FSHWwGhdlInatGd4i+RZh5cvOFNpcgMQEZrPHNFxum7StwcvWIbV?=
 =?us-ascii?Q?O0tLdBGBp1TuDUH5n2+IAV9T2fjSKR5CLH1G7YtBpA9OBdgHrpOGxDFx42j6?=
 =?us-ascii?Q?GOw0Z8LQQ0CWiAllLw764e/MsYaqHKUPvJasKTlyWnSxPiyBF5pDTKziii51?=
 =?us-ascii?Q?VTkdw32/BImWacL0gXll+U6jOK6q4nFo7o2YMyWFu/oy6N0YvSwxmGtsUDbW?=
 =?us-ascii?Q?LgvYB3s92veC+wx73iF91kshiCSc8oIzS+4GtTkuTyUMxd8oVRtSlbGdV8Cy?=
 =?us-ascii?Q?C+a5Edb9FfO/ND39fPnCmto2quvFGu/KSMGBf/x30hPB5kqduSdVO0B5D+f2?=
 =?us-ascii?Q?+5hHaX3FUNJkLERwqMNc13EJbnHTrdCGyutL5ENXSRokp0OiLMiBA5muHwb0?=
 =?us-ascii?Q?yCX/dvLqIgZSo4RCyxmhnvkyyH4Cgl2DnKzXpMc8SQbABNtr1ny8j73cDq71?=
 =?us-ascii?Q?1DQduHsCqolgCIbzKR48Ty1fAuZ7X0/BVWe01LAPfAPBndOKS3uxWsz6ZfcQ?=
 =?us-ascii?Q?39lAAhq19YVq2sKqOT2rHD8gzS+GzRlT4ML6BZIAhp99+7aBPNFjsD/e6Jw8?=
 =?us-ascii?Q?clBkqf3J97eEsLsY0lUnpN3rZ0auTteOKESC9J4BXNi0h1wPv5BBFY9Ds5kc?=
 =?us-ascii?Q?QH2JYg8FlVa5cVjgvJlzHEWaxpXfsPl9bewnBsjPSe9RpWo4eIOFLl2p1pYL?=
 =?us-ascii?Q?Z5PGzLt3vD7bHN/rbEB2kqmajJk2sAnkYgbnz8nkg/lyjXfjuTGp6dqZMFZY?=
 =?us-ascii?Q?jl9HwtEsGkz4xM5q1ydwnN0dkbJtm6e8Ypf47zPkSe3SMizb3qFMBSr5OdKX?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ak1jz5G424MmgqAwd1NcBHYsNOHYCnHIVHBEiQ7OY/2AQ+vPzzTE90J7zyKE?=
 =?us-ascii?Q?20vvHlvDQw1EOo5vbFDmFSmAiRHPtXYUH59/63Zp10oqp7DzvdRQBt8Nco+8?=
 =?us-ascii?Q?0Jo5fd1z8Ipocmnux6z667fgljZKFWBo70W9KOXjCPT5HD2zKXAx4XUsZVED?=
 =?us-ascii?Q?AjL+STDOYIO0bq++fc/FMVggshtT12rnYCI6kb4MYAPxT3z5ZEtEDVCX5Wjs?=
 =?us-ascii?Q?iVIqNaTiLr0RQwNus8Rbz5PXrfZMaw36lxxPDtd7bb0Vrbm0s6o0EOoDQKpC?=
 =?us-ascii?Q?qAmkA7DJ4Zt2WtuyRwTgxVrzkIJW4Lnj7c7DxSeSlebFlYwo3d9h5ejxF08d?=
 =?us-ascii?Q?7sFNQl8r/RMm2C0J13nJpfUxTaOb1/TKQ3v1wu0siDOJ5W8UyngcT+X9Enr/?=
 =?us-ascii?Q?HbX/E/KAG6sL3+eABGk0gkr9F2FDeWRbtgeIaY6ZYyCr6k745y2/OoUng0GH?=
 =?us-ascii?Q?65iQjkPGw5Ao+FFVHsra9Mdqfm2eY6AhRLRrq1SykjBjjaf51wJZs6jiuVEi?=
 =?us-ascii?Q?FBL0SAAdfNsYWDHmnlaAZTSeXO04rciD18LYNgquEunooXvAgllmCVxMduU0?=
 =?us-ascii?Q?PSkcPiie8prDMhEv8dBH/1SFDf15FgjE0VkaAV0qluGt6zjbfNfjR7/5Jr/8?=
 =?us-ascii?Q?YDX/X/csy3V2Df8icMbQGJPoHbzctPDViMe/JOhsyZwN13CK+ph57RQ+4Tuh?=
 =?us-ascii?Q?M/ZTQBYOPr7pykX2JcuJLJnHIqTGs+bk+J2EQLj251lKD/nVGmGE1DMXg+1v?=
 =?us-ascii?Q?RlzbWXpNPitJEbpw6s5c5Q88mXUNd1QYGMMWggvAw8mnWhG6aYzFOceYidk2?=
 =?us-ascii?Q?dgDv/UirwCTu0w/PpAtFcOsMQapBJ/VYrtM5KkqN0EDBVZDFOKLxSc5UVp1L?=
 =?us-ascii?Q?Z4pBtBrorykkx5+2Iaq+ekSDiVfGKtRoIKb5i/NQV61imtvEw4l/833qSSQN?=
 =?us-ascii?Q?wrw/hvQvt2ZLczecDi9G5g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f214fe8b-0519-4735-e150-08dba50affc6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 01:31:26.3823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFB2FEkywHN4N8LsUiZl7NQ2YiF+ITPsbEICucumWZZQMD4XaC1rZEQXEcI+A+qcC0fRLRYjigRd/RLSWsUzCCpKddckg/Gum4QlZ1RvP80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6855
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=835 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250011
X-Proofpoint-ORIG-GUID: lwBMArLApX46A_DQ2jCwOZIcKnSCIcMp
X-Proofpoint-GUID: lwBMArLApX46A_DQ2jCwOZIcKnSCIcMp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The main issue I think is that there is no direct ancestry between the
> ata port (device) and scsi device,

I really think this should be fixed. It is a major deficiency as far as
I'm concerned and it affects other things than power management.

-- 
Martin K. Petersen	Oracle Linux Engineering
