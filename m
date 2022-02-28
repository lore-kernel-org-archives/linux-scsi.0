Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83360C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 02:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiB1Cit (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiB1Cis (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 21:38:48 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6084659A
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 18:38:10 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21S0t7iZ026173;
        Mon, 28 Feb 2022 02:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4mK5uLuie9TpqylHnUIFT8mBYUZCISmGIYb+xSFygdQ=;
 b=KEzxbnpfQ0wZ1ug9d81GCxJ7a4IgHqLeLQrXY9kHfbOTKSprcMrlfFDgOPM22v6KHaW2
 VuiIo8iHiFjg3kxBCUQLmPWqAyosTkpDo5TWcAc315XijDPqAl4hoO5ICqjdvojxyjuE
 /keBNc63y6ssDwU1D9FH0BYrSAoib1nqbu47w8lxqd1fjkY6/qK0Pzojc5Fh4tcVDnRN
 q68SI/+vWd2pC5AFaWqUy1TWKIizjgwW28JhQIWJ31Lj9dieH+Iedr+3gbnpGU5DcEPw
 mwRYfzME2HFhUKz9PhG982pEr7h4PV0rgAg0ED9LfO6LzYCQ8g3laGEPvjASZfosZZvM bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efc3aat0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 02:38:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S2VrnG016861;
        Mon, 28 Feb 2022 02:38:05 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by userp3030.oracle.com with ESMTP id 3ef9auqdua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 02:38:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akT8/XXCsHJF3z/Ef5B+4f50Dj6Lj2BZS9D9EalR9a2qPtzAHmCFt408NiwxLnx4CBFyLqqJv8tL8u+Y3esZibG01Xjv+Bko/SVLJalD/LbMOmWRDP83uocMRBFENbv3MgzAxxZtGPvrdlr/WhupcIYf/Wgsj5HDdRtzZ/tVe1zOwJMHRZWCNqLHMp5hc7GT3AJtxWML2urS2UTTnjQmV+RQ8smOP0XEC4SOgnh+G2wgVo98GgUqLufo0CZbK5QvJfg8uXuUxTVwRChHaPon0C868GCnpTQ5H0eEiViCuVphLhnqqulXsaug9dmul4JCCGKkF6agHEtRSubAHUYfnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mK5uLuie9TpqylHnUIFT8mBYUZCISmGIYb+xSFygdQ=;
 b=K6u+7fRw/Lqt4ngtLcz9qVXGMh4qYIhbivG1aEgy9+4W+iPrx2+re7/tLuTn+AVTNImOma9Vc+JdF7QfLRn7UAZ51wqqUkFGqtFVaEowKREOV7Ue45ypE6k7JbFLwPgvtyQ4lG8PQsi7twwV/NNFCRP83w9ol8KHmfmgrhERAHLteH8vlDYyirGVDGLC8jJNslYBPR2Wg7JWIyXhUsXpdSrWOeH6uLYR/zQS6PdLVweqJM7X2etQfzO8HY0mrAqpCXIqB55UTDhO42XK0rZ7nqbPtOYDrRGUWt4KQUWsFsseq2+KH/jYcyXi4jVieEZo7Uxsln2I08O0QBmFO8hopg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4mK5uLuie9TpqylHnUIFT8mBYUZCISmGIYb+xSFygdQ=;
 b=JFng22I5WbNpGcgWlXNy/09RoDUnD0hWtUwgIW3YEFAl/ytGiHdmYXww5MGFMx36l/VYaC5wXDduHDqjBOapsnfeAZZP6CflHOflkfW1VTSPv7n+gaOIQstzRXSLE/4xvvvITKlqdt43YjNqAn3xv73U9TtytAgOz/dlQjNa218=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB3717.namprd10.prod.outlook.com (2603:10b6:a03:11a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Mon, 28 Feb
 2022 02:38:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%6]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 02:38:03 +0000
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2] scsi: pm80xx: handle non-fatal errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtib7m2m.fsf@ca-mkp.ca.oracle.com>
References: <20220222092618.108198-1-Ajish.Koshy@microchip.com>
Date:   Sun, 27 Feb 2022 21:38:01 -0500
In-Reply-To: <20220222092618.108198-1-Ajish.Koshy@microchip.com> (Ajish
        Koshy's message of "Tue, 22 Feb 2022 14:56:18 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0188.namprd04.prod.outlook.com
 (2603:10b6:806:126::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b876b65-c135-4046-c18a-08d9fa6357c7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3717:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB37173A0B75C1073AE1B9D4E68E019@BYAPR10MB3717.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RP5DPdI7pq8J9HhIg2M/095xOUjwy5/iXBvkvJhY6mtg9nSwrhua9azKXgPYmDJmbBp3t9IbxyjVd1OjpySSsUNONDYbf96jTLezRsDvJeEqi6rSNhvpzmh/DHxfpv9PAORImg6sVF0RX44+88w9phgXdN9Glsv2C1Rrn/YWB1kWZMX6Z4JbmEhV4syrKR3wxEzkw77RU1MWEWvVZlv/DF40WUF3egMGWL1naX0IJbxs1IXZ58FPyEWua29I1haq2G7ylqxQ6dJvjPfYEwQbELtfVC9d612P/gQ/bRngtIaJtOE/cLW/BQWnsmVZ30Bfb5pCrDHAJTWtT0OZ/DPyWcb/bk7+XKUMAeCDlPYGnQ+mkxv/Whdy/DsNpFcex9yh33wIPtHrzx7bzUqXfjv/9iHfX2RK+34q1oQ7d1GK5lGEEZQ1lQVCLP9LqSJ7bldab2hBBsRZt5O5K/B2dadb5OO07zIVzbiYDr1/Er+qYk3naeh5e32TdVz39rncYH0bTE4rwGmk+lC1eSRWE0mmaGoQR+cbVeCTzQ6PVU5Ye+XXVbbBdz6dAPaAirYDGSWlzz5PtDyjfE5L8ojKaESxPcWQB3KYePLmtwpWugrGGb0x7E4IO1dm02uUd1Tjm4pDbbCKGQoYmrcudOSlR8qKEvbc/NOZTeuxMGhuK5I1X77UUyD9l7S6OrpqZKYCVznHqkLCjFj3jlwsl3krh3lDag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(2906002)(38100700002)(8936002)(5660300002)(36916002)(6506007)(86362001)(52116002)(26005)(4326008)(558084003)(8676002)(66556008)(316002)(54906003)(6916009)(186003)(66946007)(66476007)(6512007)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LkLEVd+aG9Z8lu/7hWmude+32ICQaZuDCtseCWzuhagQY6CJBMZr46939Vn2?=
 =?us-ascii?Q?20QjMLIofkqCBeuAnlGlFkBPawD121BLpDc42AEMfAkmJd4DBsmapSDn6Zwr?=
 =?us-ascii?Q?/+XLSMCfhDjUpuAd+4yNLTDlKMT6i+0lUeeqY5BO7al6pMlL4nvwgnOVtD0v?=
 =?us-ascii?Q?EnmZil4u+mBGozRb4QKgOs9V2C7KJchce0lRrhpiVr0Z00AZ7yyULnXiMIDV?=
 =?us-ascii?Q?xyyA7g/jAxzicTn1l86Bo9Pb6/VxHptzlvcO0xjUcJwvBI9hJpiJtih2Slcr?=
 =?us-ascii?Q?xojhtnMv712eeoSRAI2Adn438jbei0zJ1sAYWlsW4JRZYT6y0wtrQ6HVOQIM?=
 =?us-ascii?Q?LCWDzs3ZYS4jfcieo3lIugZyXjZ9Gni2IaQ1J+4oFbnIWsQyReRXC9cqrNhp?=
 =?us-ascii?Q?pEucbAmy8PKjE2xkyCtgdLThWzrNsDqCJAmwUW9SVQWapl3KP+Gs6WpYcscJ?=
 =?us-ascii?Q?KOIkbQLRuU3LMYlVd2w5hkzUtM9WWIkL7CnLUbkNMwKR+P0XOwi/ekOj0TAe?=
 =?us-ascii?Q?H6UUXZOwsWQbPT3eacp3eNMv8vmoxWdm+f4yCCfJIw5c4AAkhQHuWndJ+WpT?=
 =?us-ascii?Q?XxhiTE+F8e3lgD0rLTaYdCMPn+n4ABk1jlkAB4Lt/x9KP30wQTUjt6yz/x9K?=
 =?us-ascii?Q?mROahx2NYxQ3c7ktAqtkFFTv3o0eOsQ/VkAa9DOzNt3POTe5uUdpRkD/T27Y?=
 =?us-ascii?Q?mVwvS2sqrJzYHQ3AY2qzLuJ8n7mD2svm1zePejh9+njEL0Uj9JtVMDm6kN1j?=
 =?us-ascii?Q?tUsUt4126xf/SZRD7Yv8wB86DvUwChRjC0VXdolHMLH56Rz6zBNsBN3OG8+j?=
 =?us-ascii?Q?ei5WrxJXJx/Z+TWOnSiJugyTPL1IJgPmXFURgLM6D/bix4o2uMo1xl1oNuAu?=
 =?us-ascii?Q?2RVsSj1cfyuB9LshHRXaOO6Mn9B5p+7n+GGNPXeFKI41wj5NNZ9BZTwVfpYM?=
 =?us-ascii?Q?sKQn4UHp0EQ5MhwK8nfjdorsY5moLiQdTYHc2g2p2H50UG/mb4LKyn2P0akX?=
 =?us-ascii?Q?V/xdfyUPy6gBubZNpA0KZVpDXr8i5FsCSAO5ndQ8TT9rB5ZnoLddUbStQlga?=
 =?us-ascii?Q?q3gWNlDEryHY4eXBttWon2KcVFGTOAEGRjye5DsUmOpESn/68l2PLc5r7FeH?=
 =?us-ascii?Q?a8hbdc3Po6OpkUE4NqZKQyE18eKXN5UxXE1VWLbUOrHTK9DPGYDWxfoQSYE/?=
 =?us-ascii?Q?DOQuhC/3lu5JWyCd/k+HC0SJzN81Qg7w9S407CoIeeZppd5fYz0+ZKPzNhoM?=
 =?us-ascii?Q?1UK009v2VJ9ozBuIabUQBvOf+hmy4sdtcloeJs93AgPTc0TaeIlRCuxnLG18?=
 =?us-ascii?Q?bzcWyhElfO9jKuWjGb2MxZv88Fas8pBOaMlPU+XbrmZxRloi5RaIbXG6qcav?=
 =?us-ascii?Q?u7QBLdJEsI7e1MZ+aCbLH40ZdjlMDb45RSB9UiAriXTcah2By92maXYR7eWf?=
 =?us-ascii?Q?isb9xNcU5y3Gcac5hIBenqpW/L0iuK2VcTaA+cnoWCC6qEwnn2IXrErolHEN?=
 =?us-ascii?Q?2+dns2SeDJbd3heYH9k9JogxFuIMWiRs3ycwh/bASNoEfETv2Gt453683Xqt?=
 =?us-ascii?Q?0THhuFBato9WLITf/9DyN7sxYYz6lXI5WsGfHSMzuHqozxL2wJoUnwadtHG9?=
 =?us-ascii?Q?IQMfRdfoGDuz/MoPT2e/Rk8DQ6hNvTp6QwkopwehGH6GhW1rCYz7Fv5L2XqL?=
 =?us-ascii?Q?D52oMQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b876b65-c135-4046-c18a-08d9fa6357c7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 02:38:03.2301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prJhacOfKBrt6gFcyIb5tvs40Joa9OJN/dUtrdqKXELzgE3/Dp2PnfbxiN76riOu+Klp0pYrNzQ6vUjAIX9hG7ZtGjJA/cbyUl2ixd26EkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3717
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10271 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=798
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280013
X-Proofpoint-GUID: QdyG7tOEHVuziY-LDiV4K_DWlhgzVDQB
X-Proofpoint-ORIG-GUID: QdyG7tOEHVuziY-LDiV4K_DWlhgzVDQB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ajish,

> Firmware expects host driver to clear scratchpad rsvd 0 register after
> non-fatal error is found.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
