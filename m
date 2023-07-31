Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EFBC001DE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 17:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjGaRya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 13:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjGaRy2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 13:54:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C85CDC;
        Mon, 31 Jul 2023 10:54:27 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDTJ13029570;
        Mon, 31 Jul 2023 17:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=geVoIMBljwTZjFbaaZFURlcsL9wmjotoUgbo3FEEGCg=;
 b=bdMCWl7NfHh7TeGvLglGxfCi6JXlM46s8K50yUFn8L+BA52YNZHgit8SQEPNGHBlTY5N
 BHxUuzq4tEmufRl2dpvgQnQJE5GgcXrRfqOIftYMQzDxqnnReEYa+U4HnQgr6G3MI+3U
 JoxqUGiHeykJMTNo/reT//8HjtUtciJ712gKaoswKsZ8rWnD1C3qLLIjj+HIGmZknnbp
 YgSLFu9nXlzj3mLNzaCYHKLlatgjK1+2ZvBTL5CvYvMO4iGygHZ/bVXWiR4qj7+uiOhQ
 rQ1J6RvJsUOBGsZnb8yAzo2ZTjdjAqPirkgE6J4W+Uo0QQKd3vRghr2kFx6f8GA2itoh 5Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4ttd382h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 17:54:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36VHpB3P000737;
        Mon, 31 Jul 2023 17:54:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7ayxeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 17:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRzlWY5ekOamcaDVKmyYUPOiXIbARPO2CDscDKHNrs0PR32LYmRWSXUZPnyXKWwDKWII0zz9Oja1GIZd0Dp7+BsvvYol3lR/Q+6oSx2RTCK7AxYaaMjll0Eg4TJHZ3/hY4KlM/ew0CQXLBCYT526Yd2/SeLW3sD2q04TP5keB49i3h4l5k4+8CXC/YAV+0xiBwj9V71wd/C8u/GjqpOFWpvE3DEOL8lOcY0mwQZ+mEy+laHsfAmdfLKFlrtjOQTPyyF9JGabSz2n/6+Dz7JLbFbfYDnzvlvbRQkIOrx6rbVsuFQrt8kj9IvHkymXK1Wi9TvCKXAZo9xwVgbAxC9fUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=geVoIMBljwTZjFbaaZFURlcsL9wmjotoUgbo3FEEGCg=;
 b=cYpYhP+6pGTGGaVVAxZgRchTvnlDpl5pxW4GesdaSdIyvOCJOSF3/QqKDg33Me1LERe9Alo1vd0bwxqOkiaEMQT/dKpN34mt7xbKS4DaQt1nj+3evFiZkZKQLtX2dSR/idZGrPAYswmGoQD56Yvp47NU8emYJsnCzQOv75Tj1cX3WDy4z0iPSQfPmBmJo4MNPyWOHvI/4BaXPE6wRPAwjlGPqnWHQJzldFCAYqxxQkEGn+CYkD1bvkmrlFI+aBXCnuR2NRoBpezFZSP54ptM3XiWVbtNoL8CHSjvjBVMG92/1LI5nSb4ENUVjsJ6wxE+CG2ZMkjeZJoltze6K6VTJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geVoIMBljwTZjFbaaZFURlcsL9wmjotoUgbo3FEEGCg=;
 b=pJz+9P/m5NzM96SKZoxaDA4DBxYSjK4vqNGHX9qovPHKMpBHpkq3BcfH6WaPpHJQAzMZh6H1OBy2KDGF3likKBDaLYs4oTiD3Bx8F2WYvf8AxyKVEM0aWlj8rE5mZ/GnETqoAx9XBMJXtnuu0a8XVUbdd+vmuKqWI1LEh99cXD8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4453.namprd10.prod.outlook.com (2603:10b6:510:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.42; Mon, 31 Jul
 2023 17:54:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012%4]) with mapi id 15.20.6631.041; Mon, 31 Jul 2023
 17:54:18 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Perform additional retries if Doorbell read
 returns 0
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7jsq9lq.fsf@ca-mkp.ca.oracle.com>
References: <20230726112527.14987-1-ranjan.kumar@broadcom.com>
        <20230726112527.14987-2-ranjan.kumar@broadcom.com>
Date:   Mon, 31 Jul 2023 13:54:10 -0400
In-Reply-To: <20230726112527.14987-2-ranjan.kumar@broadcom.com> (Ranjan
        Kumar's message of "Wed, 26 Jul 2023 16:55:26 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4453:EE_
X-MS-Office365-Filtering-Correlation-Id: 211b2ff7-e032-4afc-e722-08db91ef295f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kc3L1DB7g8VEVP9Nq6/CRfpU9dstgPjVCfdIhHfnUf31ofJ/izGWILsofkE7HeUcIa7LhS4P+y/ShZyijWXT1nrt1mVJa0aU7p41bRf8RGQC3GQuOOPs9Vkb5mWVS1Vt57cZSsa9n/oNfzc6xLU6kwR+PNc96/MZfUH2NVIILjt1VHlLrcgFPSNOFhTK3xlgk9uwzUopDS+2QGZzPG/PzSGzWbT4Q5K66cqTlKusbE+cSmKgR2QD2tKx4Cx72liZ8eYRXMzQindMgnhauKvi9CzpTIdi7g+Z/9imZ3K0lQ041iLFtIT5PBZGw7suoOwRr48+S8IlR1bhzGs27qZ7RIMAyoaB6oBwwMz9UdvCJQ4EdsZgZ/Ba975gAwGPFbf00ktv68ZnSVSqiUmtyzAd1Oyp8CoMxWHQgVs/ji3c1aFTaS5u2oZmvdxpjO76qa+Bu9M6METKrkrgUI0AuHfGPOqk4vJLITgGvBYlUtK75m8a3tDUigVUSjb1xebHOGFJWz1TLffHrjeSa6B0D+o2u9mX1fw9LcGFsJN2Y2Du2DResj0Pm5F+QDJkwuBuejnv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199021)(2906002)(66476007)(66946007)(6916009)(66556008)(4326008)(5660300002)(4744005)(41300700001)(316002)(36916002)(6486002)(6666004)(8936002)(6506007)(8676002)(26005)(186003)(83380400001)(478600001)(38100700002)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dKw9vblVFk8U2T/440+QrjTY6favV4dOZv0S/y2zjiGVYr9jN+DSL9CYgdtu?=
 =?us-ascii?Q?JDe2y7b3FpV1jszmk0wZ4qJyg32OZekRxdYjKWVlBrclDL/iFSLhMUsREegt?=
 =?us-ascii?Q?QC2bTlAiU6mR53H5Ox7aiZXvAnQhhzGHL59VaDo4wjxlt3XGu6alPAEc6J1l?=
 =?us-ascii?Q?0W5oO4lwCiKoitX8OKda5jq4DtF0z6RhCyb8PH5JgusuKAqSwi0xlp+J5v7z?=
 =?us-ascii?Q?yyuYWmX1zKkl3sr+ofFN5k1TBZQFVXHDsamzjKCjjSywFzixRhtN2TTOI/Ez?=
 =?us-ascii?Q?twV3kS/NSnfzpQ4a2CJBmjWkPf9r0+GVhC45TALTXhjzdAtOcb+9y4mIIF1H?=
 =?us-ascii?Q?+Wz00wEkyAvjaE9rSQCIg+2tgLtXkDHSt7Whd+gqGHRyTk0ioiRPQKnB8PO7?=
 =?us-ascii?Q?UBTmaD6m2F6dTH9muy+PIEg5T3JycQI3IRLAdE74MKv+iOs1T9laToXVrxua?=
 =?us-ascii?Q?jtzNoa6wnkOthxfZDwSIxP6uHZRSrk/6AzEsBFKbn2ni0Kz9shosg5XfcyC3?=
 =?us-ascii?Q?LwFW4GekWbfXVnmwK2yCdT9cvvKDtPkQAHfWQZkk9odgNukM+bNdF+CBWDpi?=
 =?us-ascii?Q?vtagGKTmNe118+p9b5T6K7BJQ7xkIGG2xUC3xCpS/h4ZFGETXyBeFGVnY4HF?=
 =?us-ascii?Q?ybc8vEw3bZSjgSycE0tOM2QfsgWlVgdsLaPKbCWXoWS3iIe9RAQUo55GwNFF?=
 =?us-ascii?Q?kSiQYLzFtlMhYsuvynjGQ8Lvy9NP6MXrzvAcF3eEpksAo20sW8Q/gATrFO8B?=
 =?us-ascii?Q?0XHSra8GCizfaRZqvReLfEDlDfHvnJBf+vRw1EK5fzazbAU3GO/GerVCSxCH?=
 =?us-ascii?Q?U/FUJwE1p3o8hqAOnOQRp/LWrNdWQmfrroYYZXSYtJbshRKLm1FpOks5QFge?=
 =?us-ascii?Q?zbpSKCT+xHb9tK6++l9eV5U/Rd+D2zi7nxsG22LZ+7W95F5/RFOWnLImCohK?=
 =?us-ascii?Q?BJD2vrCzg5Gq7yTATcxRPwGeV//fS/ppqqGqG+dEQ5YIHKPax/5sPjRkRFBx?=
 =?us-ascii?Q?Og8ioXbri7umATE3JjER+bLL9xeumg2ojuHg/Zr0u+EN5kesFY6m/nd8Xltn?=
 =?us-ascii?Q?R1OS/tPFN5zs91AaE6UlEszhnhaPB3nWSoWgi4CoDoqkHWEnikpciMA3rZ0f?=
 =?us-ascii?Q?RmprrZL9e9hCMhASegQaGwtHA11E5gJv5c1hXB6NggSG9XbHhWhgChf6s8C9?=
 =?us-ascii?Q?+vH7p5PqViRteZ/dXTAuoaHp/W/9SygeYzvOJ8lxMRnW1gmxniFwKE8/Q/Nm?=
 =?us-ascii?Q?PpPPsARHQWoj8ajF3lfSh6aaahY0XntoK2ZOJf9phIzkx1SFuRs062Ubo2AL?=
 =?us-ascii?Q?fm9akwLHIMJ64G+GgMNIca5YC+vabGx/x8VxmP1/ZN89lWDRZYovuxUoxNrh?=
 =?us-ascii?Q?0dgEvU8jEplvIUEBZXqtnDBkrtbOBNZcfMw1N2Oz6zyDfixHwVuxgV4VosLN?=
 =?us-ascii?Q?YRzCit9Bf88wPJCJEf4edYXONpUy1JR2A1KNf0yTGoTlbpk0mw2AwMaObT/k?=
 =?us-ascii?Q?spzxETXxxhhrSHZJ25pQTLQuB1X3PSGDR85IIiDEEvmQZW6lLCDlLhjtzyfb?=
 =?us-ascii?Q?bSTQ6bmDuAMEisPos5vgDkhsXQp3EDIx9npSh6SX5v08fajz23izvfBVN2u1?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /RX18A0KT4oSGK8LJ0LR9NaCm1PNa2BSawCzmC85TmQE8bSMVTh5B9zYZ4CWXUYoArG0Yw7hHn8P8awdsx0wA/bXIbii2Szzz+DDGXLtQhOGdSRh+rQNeYvQAVdTsEkBYTgba1Vlog0qj20kodTfL92Iz8iGLv/vEBovjq/pMFjRx918plOonu/LO2Rdfe0yvsuQElzQOsSM9kA4LkMO8VhC3KgdTNiP6jA6XY7dwCX4MWJVNN71ynIFsGftDZZxYJBPt+r5iKDY2/fqWozSDhanUN34iDMT5LlOPBkyHehZUbUkSSZ0dI8sb5EzBixnviGuBuNLBZ72Du9ewY19bUbvr+UVvRoTOgmeS5SElwxOAK5XJoKUqp12m+oQ9PxYfshiUmH5EK/Qrfp983QF0KBeRVfQSsTPSPcdeBTKP9OpV92iRb14Sf11TDr95SoX/hPluyo2ZSymKzM8ToVVb4QAkfwZsuOmxpWXeStriEH9hKLcJkVXpzuyhteIHSLTQXG4duQO9QW94ulqyEvilReK5pOlgVlU2mJlHxVdwBmeLjpp1mQ473T6YgiBu2LBBGS7ltZlQUAucyVGF07dSGvGTcDhJ5Bs6hcDvd7IQLJdhW7QvjvjKydxYYAOSwN64REb3Jrngv6MfnZLVPdKj01/yfVvhFxewu5m6e1cKRsHbS1YCfgpRxO4YSWj5H/nAI0VfkllVKK/yS0Dsu8dNJfmKjGt8xki/v4oGDxElXVZfi1WjrjYqLC+H41Um6nEJUclhKJJeagNk/EcpXUWDO+/xeDOlZ0bQ/sDh9DPGhY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 211b2ff7-e032-4afc-e722-08db91ef295f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 17:54:18.1631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Mgv8BBd+ruQt/JDlO11W1SZ8v525CpIReIpZpQyZPHTfAtjyf/2xMJzplGojQGgjlm5ZDkwxsi7KQFGrkr0sa9Wp+N7vuHWxZOIdzyA9gc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4453
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_11,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=977 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307310162
X-Proofpoint-GUID: YY2tk0WCHS9IKG5fjK1P879wcF6Z9Il6
X-Proofpoint-ORIG-GUID: YY2tk0WCHS9IKG5fjK1P879wcF6Z9Il6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Ranjan!

Since this patch is a candidate for stable it should be as simple as
possible. I don't understand all the complexity introduced to
accommodate the new retry_count argument.

>  static inline u32
> -_base_readl_aero(const volatile void __iomem *addr)
> +_base_readl_aero(const volatile void __iomem *addr, u8 retry_count)
>  {
>  	u32 i = 0, ret_val;
>  
>  	do {
>  		ret_val = readl(addr);
>  		i++;
> -	} while (ret_val == 0 && i < 3);
> +	} while (ret_val == 0 && i < retry_count);

_base_readl_aero() is going to return as soon as the register is
non-zero. Why is it important that some register reads are only retried
3 times instead of 30? Why can't you just bump the "3" above to "30" and
make it a one line change?

-- 
Martin K. Petersen	Oracle Linux Engineering
