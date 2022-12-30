Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F86C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Dec 2022 22:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiL3W0w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiL3W0v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Dec 2022 17:26:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5891C913
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2022 14:26:50 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BUFx4mV017358;
        Fri, 30 Dec 2022 22:26:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=A4y4D3a37RlCG+ByMBRUI83biY3Dq0eX6jh5ADGey2s=;
 b=UPleTdG+7Ckk63HpgS/8ldd4aZ9uwl9/5DibbZuiNu2E8DatLomsth1yqEuEt5J3fUvk
 3R7Rjmnpsuh0QIrFLuK8XWiQx8OodjKpO9S95znJZfHI3LNcyvyVpY0R5tdFq2JsFklb
 u1ksmNFB3btYi3GMpOukZt2VLCc+h6jJWJ6nyUaYn3/OJCSqPZ4Eq6rvd7hunmfAsdUD
 tRYLqdW/qUNVh+5t+mYNr1q2mtGBuoPlrCaCdK7kwh+Yms0Jetld7gDn6j7/vIhjIgBE
 ZzHNlJYTKSZtrJEW+THbACBPVWNfjUgiT8o7+NMsOVf/qM3iNBAYEZXAknxo18U7Qage vg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnsfcgptd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Dec 2022 22:26:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BUI2K4n001392;
        Fri, 30 Dec 2022 22:26:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv89gt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Dec 2022 22:26:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDw355/ywWUZN2UmYIbLqusOWQBw7FeauiKcHqbsQ/hBgyrG0HsaZPBd5JwCBb13PokNQ9/a9ytxUfmebNtnuwkj1SWedDOX3Ox50JJRTlJsbKkfvgUloroVXDiYqwu5axn8W9N8O3Qy+KzW77F7WvON0OFgjVbxJZaqlVI293GO4jN0Vbot+U9hKImHBqsGj51BxQ3dKgcBj027HTUHHXsfCwexUOq/nF0o6scNZLVEWRlnkBu9Ws8UNGiXf9yHmSyGoK4p+Y7e+FCyumjy8ZpMoVAPNCw+fWnQl+tm9pIa8Q/oVA/0eDhitu0B+bbBjOc1Zfq84POosC2HTKTs3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4y4D3a37RlCG+ByMBRUI83biY3Dq0eX6jh5ADGey2s=;
 b=RZsABL8m+dG8YfIS9upaqoCyCDto0SN0w4NUqlqT3Mbd5LVDPhX7Dnoi0+Bkh6IWuV25d3hWaxAa6gMFQyFuf4TdQNKuZD8M3xd+gxptHnmbiQ0AuKFJ9yUQfCJGZ4A0xmjbzktBwSRZXItFTqcAOzi2sb9t9r53YUIL2x+0UJPv7BerjXtSZ/G/gdIhBjwYvT8YSknxFp8kB1WgYaJXBm4Ok6iRQvL/sw8iQgoyP8MqCZH6bw7zGq/7ueK2UmzSlxNWAYZq8+PI7KOqLKT2toruKVJEvuRZSKGNWs9S/reUpsr60Mbqj7UB8reHispgNws/d2tDtFTjaXPokRKfCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4y4D3a37RlCG+ByMBRUI83biY3Dq0eX6jh5ADGey2s=;
 b=vqvtduBh2DXqlnBpfXKA4svxG9MpJ/FOl3BulG/UyhpyuGTfXikFDiLXj+3tXuVnYWYLjuhjd4tjsVj0do7YHMhenWoRXEXtYXGJSDO0mZd2Q+gcirou3qrneoqNlvSgPHddAsozvK2A1hIlko9bBsiUTGWY6gr8Kd/uePp5LKI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB6417.namprd10.prod.outlook.com (2603:10b6:303:1e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Fri, 30 Dec
 2022 22:26:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5944.018; Fri, 30 Dec 2022
 22:26:36 +0000
To:     Can Guo <quic_cang@quicinc.com>
Cc:     quic_asutoshd@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Add support for UFS Event Specific Interrupt
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6xc4jgh.fsf@ca-mkp.ca.oracle.com>
References: <1671073583-10065-1-git-send-email-quic_cang@quicinc.com>
Date:   Fri, 30 Dec 2022 17:26:34 -0500
In-Reply-To: <1671073583-10065-1-git-send-email-quic_cang@quicinc.com> (Can
        Guo's message of "Wed, 14 Dec 2022 19:06:19 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0092.namprd02.prod.outlook.com
 (2603:10b6:208:51::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB6417:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dfd7b4e-14e6-47d9-a641-08daeab4e9c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9uRjYfKgEu7xTOTRNfLPO0VS0393t+HJeQk98r3vBt/aSVJ7Xq9jmtb+Xvq8w75fpKpCE7JWmwyIQ9gtH6WM4l70neaMoIvLv2Xj17E6vjTvxy1RHsJEekqgNs987UHDA3v1EdA8rAGQbeWqom2S6Y+u/FNIqq/awleXnDpXIi88QtN6f5uOkYZlNN16PLddY+uoBYWFAHIvcNrM/8hw9tPhaqqOstdj33x27drBg9+Kb++6OzrqArS54a637LSaYDhPOUvaQDiSIuGs3cliDVWMF11rKBpqpxsAv1+C6o0Bchj8CAmOLvIyaQMwgP2pJGE8GTIRjkcJNINz6awOI5NXqPi1molu2IMvWQ06qAXbNQf6ik4xg2BIFGBsI66JDoW+8XiBItfQx8atu/ml8laHLL8gz61+5XsEGEicvpE7gK8IGUHSLa4dqQh3ilgy3skMQSuk1ypCdRvYHA6II26fwAhiMyzJJlS8IADeepreyf9wlS8zve5G7myWx2I1efMtrjITE/0exRiVIizXd7peRhw6JB2mk5T1YXAirEMnbFve+VfxHrC/9x9FK0LuPnaiHDZAAFzSoFkv7dtkdZEyQGki4p410o7ecnXcCvioT+f/OFsHQnf3BTq3ad1uA4h+YQizuiyEseMY73+Scg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199015)(2906002)(8936002)(5660300002)(38100700002)(41300700001)(7416002)(66946007)(86362001)(4744005)(316002)(6916009)(36916002)(66556008)(66476007)(478600001)(6506007)(4326008)(6512007)(186003)(26005)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eLxruCab3rDhAsabIEfWtdvwYPt69+5Ua2yPiLTuYhflFIXLSEYb8JM2/QVP?=
 =?us-ascii?Q?ns3BGi0n6nyPGCxTDqqET6VhNd1gq/05BgP3/zHZ40I9Frjaarx7ReH5Obmg?=
 =?us-ascii?Q?SGFOBDyd7ABtji9uDlFmc32BQmgOVNSFApTMngSNeeBmA5wIpiE/gV8ZG8Yl?=
 =?us-ascii?Q?SypB0lN8Uqu+LGwYjqw9bhhca0sF2jSXJE4z18OqcAohxEWiQJdpYe1xCWS8?=
 =?us-ascii?Q?Wolyha/fQlp/8TVocu8iBJrH+ydb9AMWEaU/KdhntKWmpZIR8L/afrjyu7Ru?=
 =?us-ascii?Q?CNa4hD7aOPkzm1LxmoTqJiqA92+tXLmXtddhleoccJ/3BGUJVc/a4JoYYkiB?=
 =?us-ascii?Q?3KkGFUgVHOVfMhKxsJlwfT/Xf7sPULpK+/aSBKmDPEWNoJ2rfFytB3fmBqwa?=
 =?us-ascii?Q?+OUSayDyAVUo0BjY0Bwe0d+0bJntJnQAA6MyVukT6AfJO6oihuQUxUyynsG0?=
 =?us-ascii?Q?AdItrc83YN3OLk4Itze4hpH4RS6o7ovH1/JwCaUrh19jI2xQ4bfWhQSV71Du?=
 =?us-ascii?Q?U5qygq7ifLPiILSXW9ZNTvMFHLkPj36QRwkh+qXoplT0+R5h+C5hlxU0J6gR?=
 =?us-ascii?Q?CGhZj97JKLpSBEq8hwIWf7pkAeALUypxCZjT6VG4ZiUysddS14P/pJ5m/ON1?=
 =?us-ascii?Q?AtwpYKx8RU231MjGaDS4LwGBCMLV0sXzlu6iNKu78v70RYIs8zPQ6eaUjT5a?=
 =?us-ascii?Q?OCJUVYjljYQIliGz5MT14764FOSm3fnzUzmT7KkJ834/DJEsXt0gMMLbXTYK?=
 =?us-ascii?Q?HwgBjacRwyYVNBrCQDVDmqoFUkGyM11hde/qKgqFs9W9v5moJRigjcNhaDOA?=
 =?us-ascii?Q?ucvNfHFM5ADbLgU4GO8xiuyayhP6tKT5vM7I4+NSTx+9+jDmHqpAq9T7i545?=
 =?us-ascii?Q?ql01gRC1qoW6cnHeHBky57MbJl8ilPR+NwUSDdDVaPvGmBUfHIpwDebBQZO+?=
 =?us-ascii?Q?OK1stBIk1LlO47vAPLwP89L72FFKeT0N67gluujxGCcqauBXjY/mi82i4ABE?=
 =?us-ascii?Q?SSayV+LLSE0OqPdXJ/FpVUx5E7EIyFOF3zlXurSrnOT2owytmOlrB332VWDH?=
 =?us-ascii?Q?wzOSGyQMmGbInEtJCuGkj6GkRyPeQUVq/tBMy/LqLyjHBo7I7+OmpLNHYT2y?=
 =?us-ascii?Q?CsPDauh9sql/NouZrl/qN51bLims8Pq50NygdTQGjK252VyWA61lJXobnaLj?=
 =?us-ascii?Q?CmFtMibJ5XhAPcf8UxBj2JOknqX6MJ6HYGagfv0qYTUDgoMtFRlakIUGNanB?=
 =?us-ascii?Q?O/X5MqQJVd8FZlKZn+2Rx+QZ8iGnmgUpeA2+TKwXvLLGutY0xt2NSH4ZDAfS?=
 =?us-ascii?Q?PDsYe8VwLRrKb/hE7p8Phd8O5X1gcGuEX/ApzGKw1U/62Q2k1sOOg8yCtNVH?=
 =?us-ascii?Q?Flny0/ijRv27jCuPDyVJgd8rbBy59yP8Z6YOl2Yvx/Ez+Z/jDbNFGmLGQjlI?=
 =?us-ascii?Q?KmRZE9EzQUy3k949sdGpuZHpoCJ2Y9D3ot5z+66nFBf1Ta/hedfJmHP68TIc?=
 =?us-ascii?Q?/wj/eMN6tMpNpILaHDhB6j1z9liFtoCEtd58R5JHE0EZCc7dGtKx0GUH7f98?=
 =?us-ascii?Q?jNBeoxG0+TxXpRi0pwx7t9bPinc/4TWVP5f5RBLBLbucI71Xd3ZdV5Z3TRmw?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfd7b4e-14e6-47d9-a641-08daeab4e9c2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2022 22:26:36.4613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C9v30kKcXLrtaqsHIpaWpsFDFUJl397oQou0pHDyj3W0DtHlbbrRSBEwu+/R0HzJ9eTYtBu/LSVCw9dWbT+7CJoYM/Cw/S/LUcoRpLJINFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6417
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-30_15,2022-12-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=690 suspectscore=0
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212300199
X-Proofpoint-GUID: 15yyg8kXBai7k6xyT8PwF_5A4Ku4iXQy
X-Proofpoint-ORIG-GUID: 15yyg8kXBai7k6xyT8PwF_5A4Ku4iXQy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> UFS Multi-Circular Queue (MCQ) driver is on the way. This patch series
> is to enable Event Specific Interrupt (ESI), which can used in MCQ
> mode.
>
> Please note that this series is developed and tested based on the
> latest MCQ driver (v11) pushed by Asutosh Das.

Please rebase once Asutosh posts v12. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
