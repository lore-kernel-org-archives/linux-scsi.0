Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DB9EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 01:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjHHBNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 21:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjHHBNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 21:13:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044DC172B
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 18:13:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 377KxQ5R010919;
        Tue, 8 Aug 2023 01:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=KY4y9BW41CKXQBmP+W6Ow7ztykwhNJMolar8P0tooxM=;
 b=1y8Q7i7k/jCHdEkvy3Xz+duNhpNln6wD6J452L0wamKbIdXa1Wk7YRHQmUfYHKTVnUf9
 VVjUlQ5BU/FbUp9mhPBlHrtTRRzjapuePVrPLI2e7+XjDSKg04UdBg9WZOxySCzLVIVi
 INnHju5yV72/dkSPIe+5Pb+mnxbfeAMautm1WBPGCAoTPMdiRiCiKoBdt8mGnMbB0Yd8
 maNyU6MmKnZEBiTlbBCtDwxhXan6O/NErfgFZH6XLaz1ucCQ0/4XXJKJcj1MJ/ksI8zZ
 S/yHJ2XMgDcMIq4l8V/9gNUykMehbcJkMqI3vB3ZCiBCj5FgFLtZgAGlq3/hX5AnFTWh Lw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9eaam0ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 01:12:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 377NmGE8027681;
        Tue, 8 Aug 2023 01:12:49 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv540vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 01:12:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTh9kfE4je+QiDwPTCWByeG111eMsHSIvqJ7zROvDZJDaB92LYv3TVdArq7CYWrQr05IllKr9KAww962htYQk/ELufXoEcbK20Zo/Udqbc6M5mvr9sP+xhb1+UbQukmtQ02Wtkc9+CEKc/x7e7WecPWm05wf1wacZaV+vvkVz1QKE2BOMTV5TijZ1LWah1t0FslP34579Jk5W4xjpG6HVqLdp1+vIhP63AbyCVl9VW+BS5r/rIfb+YoOKWJL8vM/N4iHy8bWM5FDEJPAZz/aJhyS7H9iJXEKpEA0sFj64GKcwvErcXT4ImRvC1oIzGmm4SK2m50967AzWj2lpFeeCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KY4y9BW41CKXQBmP+W6Ow7ztykwhNJMolar8P0tooxM=;
 b=a8IblUjhZZm+gQ9pZEetvjLgngZBPoIGiTdeIc03xO8x4MsiDrWoEG7HNA0AzY9oA2gR0KH/hLILZFMPofmn14RwQKpndUm9Gxw8ukpsmHfK3+UDtnOddeRMMPrmd7hX0NeMuKHBk/wbNFrdpnBslcgsjwXmGHh5m3a+qCXQd5SUgEiACyJM/Q7w/F3PklH5uTAjvXbCvS+OjTWhJc/0YMfEsDHUTddBRbMcvk6fUcOKfxOhhuGswIFxHwBiLSaSVhsOS9kN9J4TLKEDI6FI7LUi6phNu0fr26Lo44X9vd7nGY+OVPOo08GIr+RSJxDyJhmBHGkYCSzLMVRACXcFwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KY4y9BW41CKXQBmP+W6Ow7ztykwhNJMolar8P0tooxM=;
 b=a9yVtCS0j6XubHwqWN/1FyIPLfu6yU0mMix7PRzXTu6naeFhJOzFWL7BCWp22G9LURoMqX2nqqV6ghjDO/zowBgfcg+JqiWWrS03pb9hTrcRyYk9TGYgYeUT7X5yUxas4XrOd1ZMEr89OJ0mLKSLadKDf7spcyZ+JskVsGBoyuQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6385.namprd10.prod.outlook.com (2603:10b6:510:1c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Tue, 8 Aug
 2023 01:12:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 01:12:47 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Can Guo <quic_cang@quicinc.com>
Subject: Re: [PATCH v2] scsi: ufs: Fix the build for gcc 9 and before
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1leeml4l5.fsf@ca-mkp.ca.oracle.com>
References: <20230801232204.1481902-1-bvanassche@acm.org>
Date:   Mon, 07 Aug 2023 21:12:44 -0400
In-Reply-To: <20230801232204.1481902-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 1 Aug 2023 16:21:50 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:332::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH8PR10MB6385:EE_
X-MS-Office365-Filtering-Correlation-Id: c0c30be1-71d5-4d98-2075-08db97ac938e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5X5m8RjE+cTTKAjlttv2bhTtSZw8bhpRgMhnPvVmKllmf9h0PqrwcIITwdh3xzuF1o9FSQ0Acsvss1T9gMaT7WiaJlTQj6IgEpMWHCogHyA9RWWtiombEJlQfsswFph3c7rJtRe7Y0Y8xytpfCFhz1S7pF+UoR9QB5mGvyU4Jut8vV9ALibJD1FpNuFn8nK+bp9U1gZESB95SWWCc4w24DhZ+Lj6LjqN3H5CRuoZRIGGg/z/7+lgpWeb/LwmmyaHvG6dYXu/IrQYRdd0cGKxhT0dD22c74j8ggwi+nRjvICNG0lCDQ4HJdRn+ZkcjAV9gN+10pRiOCiSOOdjPhU5l3zKO+9RgB8t4sWzPidEUz15HT1/08pZS+I0OqvERK7gDsHtBr8vpQ88UB3ErmRlsIPig0kpqPmpFD39l05VoCCUU+EyoiG3ydR5IEIISiXx0RTk+0hAuFm6JPZjXkSCMnyA/maDo6cDEVFuxAJSgUXdmxayxNN4qt2/YXENHAwuhGbLakKQ5Vt7KoHgjFkbOBB8djBYy16g+u07vgnwXMESR6iWLZXzw8ka6bNbsm8kR5IypRFNQ92aagZhPCaQzDVWJB0vqFjAm0KKqE1iO7sUbrO/1GspPDVehsYLvBeZ7Ge8KR+M7qxl8uudYlMeCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(136003)(39860400002)(376002)(451199021)(90011799007)(90021799007)(186006)(1800799003)(478600001)(38100700002)(54906003)(86362001)(6512007)(6506007)(26005)(6666004)(558084003)(36916002)(6486002)(6916009)(4326008)(66946007)(66476007)(2906002)(66556008)(7416002)(5660300002)(8676002)(316002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k4s1ObMSnVS1mptmm1z10if9dxcYsXXAcnLtjCV6twu1LSzb+l9HSexV0Uxh?=
 =?us-ascii?Q?8ox6Ro+nmmi3tGSCIUleBhLS7ry8KN8sQFbRD+OpeTMzBg97kc+9shwwQ/7Z?=
 =?us-ascii?Q?sVw+BHA77/9qoq4UgaUvT/7QWt+gOumIs+wbGQv+beqrMWXwxCSCvhAlpHNX?=
 =?us-ascii?Q?dTiF2ncQMfy4Kf4AIhdFr4UKxk6b8WIvGBCTTaM0fWcjf/Yy+3EHm2XxM7QL?=
 =?us-ascii?Q?fh295Itpqn3el306Zz/OejDYatdtPnlZp8fgWFP/5S2yJyTqAJONR6vCXCfe?=
 =?us-ascii?Q?6bAv/+xLqZwGJpTBTi8OGSqtF4Xmo2Bme9LS/J7bXTz7flsSkgQd6fEPBlJm?=
 =?us-ascii?Q?oA9hQJXDYOsrDp+6WvqJc/tn9W7hiIITjZ1h0ajwi5gB0WkcrfCBBndHFzFa?=
 =?us-ascii?Q?MlmgZRZ40hdljGlDnZxrz7gZkb5mivbcXaLCH23tNfAYhJeFjOaxkKBX6wSM?=
 =?us-ascii?Q?BZq0MlnBmvLgrwF56fc04L/N2pOQHiYdGfW0xOTKy2ihGFitC7105FqUOMmo?=
 =?us-ascii?Q?mnEQuSifnegVYuM9IT/VpWcsEG0YaoBdxV/vita3BG4z/xrMlW++1Chv5Nr1?=
 =?us-ascii?Q?+frlv3UrQiHExjPSkFtkKSU5zqPS6bks8ZUMPevf2cgqH9NMEZAsDaugKg3x?=
 =?us-ascii?Q?JTV+LX0BFmvDSPmrbYivLmBODBn3dzNZBvziL4qfvEPWOnQRuHu4kk6Nc1Yn?=
 =?us-ascii?Q?kQLs+OUBZ8Sb6xjLGVnpAxbW/RP6eekuOOMHpElZCB5skhm3YgoLDRhJ6KxG?=
 =?us-ascii?Q?3XkCuZtTkith5OHnnOt+NlDCQsVHqrjiYgrPZ2wV/l5q4A0Qcp6Xm96aX8GY?=
 =?us-ascii?Q?5vTOSMiogkkgKJSTVR0VnpBr1bPnYMHoWWH70rFzTzoteeaFBylhYh29oQKL?=
 =?us-ascii?Q?wMZA6RR5ipemmp/DzYWRyQzTiKI7Oh+bGy6Ygi6vDYpKZvsmBBDIM/9yxZl5?=
 =?us-ascii?Q?z+3WxsT2KFtcsrGEkV3MbKvaBoRfRRHGjCksQ6+9iJhRwA/7lQ4H0/bIGpPP?=
 =?us-ascii?Q?cbiL0APrtlqQ+0r8pRJQRQeF/Dv6GvcE/PmxjtKoTwksSUzKsxxkIJ6diSBB?=
 =?us-ascii?Q?qyDvkzdmChIUsH2qHjW3MoaPcbPwdIXVBe38oxPyI08tk4WWicKQtOCcEw+o?=
 =?us-ascii?Q?48Q1QERNgtuGJ/qwsvoKa5djA0LLMp/mXoIO9zLw3qU+Qj6X0tEZ9xR2CBfH?=
 =?us-ascii?Q?2/FCLqjCBSz8D2qjq8K4J7DwU0iB6p5YOadDla3g0zvQCcg6i2qNeLGth6Ee?=
 =?us-ascii?Q?WbtgQYznC6MQO+tOGlCLOD9gEUtbZXjADnVq6Y0kDC2BFg/XwqIfCD0umjIf?=
 =?us-ascii?Q?Pk5lI2DS+eCP03/vn2Ucn71slgdrx7J9cJ93KfqzzGHRSopIlzB3L2obFNg/?=
 =?us-ascii?Q?xjS7FyVE3npdPbdosp/sBFPivFDULuNKiG3h302+jNgKkYb0NnoiTqCdGCU5?=
 =?us-ascii?Q?U9ZHXj+1vX55/kEkgFIlvQBgzDOwfm71K9qPMt+AYaPfGgMq9JsY5dZX02yx?=
 =?us-ascii?Q?VyJd9215E0lZ5lQwKwKWqJHVysfgxcCIh8rNNGhar+BP9cWrwMRFBIqiCKXc?=
 =?us-ascii?Q?YKSeRL7Lf4qEwlOZV+HTR16OKzem2h/lxK+1u1oqtOMKlvcDSXfAnNtajWSy?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?As55jtZHdclx4hUMErq/gfL5SnrnIdb4iwvxGa1XKVPUiOSF5/xV/XTbz0Kj?=
 =?us-ascii?Q?XUi5Uz9ketaAoS6p5xSzYVKKSsJpIKe6twQpzF2xc8mw0NRKShsqYE6swJfg?=
 =?us-ascii?Q?VZ+ZIUTCIqU5Y1t7zjjsUZwR0eYBO/jrzvzri5fLYrmEkR8gC0ET8KPRipWz?=
 =?us-ascii?Q?8DmS28m5byFSJhXGkRb6ia3i8VBGjP2cvyojDscCfTL9eG0GkmrpFNhl4peY?=
 =?us-ascii?Q?RhLLqvOctCERbPD+0gSy/4TpkEmMx2dT9VNK0W8IG+WdkgLHLIcdfPuYC/S2?=
 =?us-ascii?Q?99ua55WUcabPg0XnJXu6BSvkEJeYB4GcbZWY4dlYEoCgLUGrqfe3uM5mqUjH?=
 =?us-ascii?Q?WrlN14zxfdBYzxyICYsBLTY7Bn+/t/On/spY7WVzKNKP+Cj0nL3wvGba98tz?=
 =?us-ascii?Q?2WT5+MQe53gIO11EuRaf1fecVlUJsnCLt37Jw0JhyU1XyPN6xUJrtkOaobak?=
 =?us-ascii?Q?hSHEuW/NtRHsOwJYDGj7D8DbBExBHEPKzUiWFbzHGlX06qaILfewUMwfyp8E?=
 =?us-ascii?Q?ajhKsiTwHNGl9ZIjQRGMKMlLrjbTGOkdt6qwyRT4xgAmbtmBqaYhWQ1Ukxc3?=
 =?us-ascii?Q?393frgyqUCd+4NFTVXvwZR4OE51t4v7Gtgn2ewHgb4loB3XRZFJxNf9mAAP0?=
 =?us-ascii?Q?OQScMYXXEucUTveen0MzIim4klP1U2cWzD9+OCaTGfQynM8t0VbGrHE9kfrM?=
 =?us-ascii?Q?1X1NBUDnGjtRH13rOdvUdCjoFMvBfnJDQX+Xs6BI4KUpRXstAAsNXAG4+SFQ?=
 =?us-ascii?Q?VLNM6s/doBJXfBrhn+HrxYN+8RQ3Fqw4O6H35god+fFhJPVXnH9Fm5mBK6nS?=
 =?us-ascii?Q?+otLt2Th9xeCLhrzmJkNbPyZ8LoxhaRcbuflrO3bONbesczpy60zdRHakLmk?=
 =?us-ascii?Q?/xUA+S0Vk4pUN2WhrGD6tcCkMV9EAxMQP58MOx6El7Gun1XCuqPcHSaSNVRJ?=
 =?us-ascii?Q?8kOPHZNv99rPdFktm9tECryJkEkSMoqIs9BdGduiJ2QSY0ef4VlHrkSNXJJu?=
 =?us-ascii?Q?6p2PwkWMzDUDnBe9Atn4eoibvQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c30be1-71d5-4d98-2075-08db97ac938e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 01:12:47.0313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJi6/qofihkamyo16cBAx6scXufFghH0hK1kGcd5CUOUweSPpgiIfWktXjKKSmYxj5JN4P1+toqV42zCc4nJFRO1uMq1Rdblhi4Kh6eHTAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6385
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=794 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308080009
X-Proofpoint-ORIG-GUID: PgEeAWW5flKpYJI_kR93MtrROSlCIBkj
X-Proofpoint-GUID: PgEeAWW5flKpYJI_kR93MtrROSlCIBkj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> gcc compilers before version 10 cannot do constant-folding for sub-byte
> bitfields. This makes the compiler layout tests fail. Hence skip the
> layout checks for gcc 9 and before.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
