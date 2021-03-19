Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4A5C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDA3A64F33
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhCSDr6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56796 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbhCSDrk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:47:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3TfEK075090;
        Fri, 19 Mar 2021 03:47:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ij1xQ34yRv8h94MaqnWtV9tVuSHiMlbSdf2TYTnjTdE=;
 b=NMM2OgiHfz3PWNC43sKL4RGs0aiXbXa/OkRtKKWKqYfL/uCfYTADOBwRD8VRH3k6bhHo
 5fkDNkpwFp+ujk3i3ljsVbAvgXb8cvZuy0mvy3U0w/jvYFEtFk/pvQm5ThgPqER6xS9G
 SY0wML4MSSggP3slVJxi3xm9wY/KNYtxgJitlyb83KeqqC/LODuCobbqL7f0ZvV/oN07
 StUDeFYHG9CvyY8hrDIYISKpeyv1WhxV8brVIDd/go8w6wPwj26TIQo+c/ii+6mq3V2Q
 RG5PZIpAZ3v/aT8HhG5Rbo2j9oJAV59BwViHs9b+SOqlx7vWXNYxBm2lFtOzzvnmqvZ4 uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 378nbmhhe4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3Up1V154005;
        Fri, 19 Mar 2021 03:47:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3030.oracle.com with ESMTP id 3796yx0ep2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZD8/oacKM3ikJBsEj+3fQC5QhYnwaGy7aiKZwqdMd/ulbaSjnNPqADfY48iFfA+LWxRQpg6YDrvwsdPbLIY50haMoLq1lqYS4VjNHBVq1uY3tXeU0jFVpLvajmV9RtAaEqRpcbIczqCygnqVJ47KkqmWutOadZ4Ifs1Tfm7pdCyk3H4WESCyfsyw4VIv2lLTVREmAKq4WQgaqGeXstcDh6qzQ6HQ9DWp1aJCbA3BN5E5jsE8QhIDqqxWaxMLSVke7dQjxO7Tl5CkZz486MFq2DAX4rZVXNz4o5ZYVeWTbwGkSoJmUKgkDfziahARRTw/7GCjjtYPp0SDjJbk9dLy4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ij1xQ34yRv8h94MaqnWtV9tVuSHiMlbSdf2TYTnjTdE=;
 b=HJTxdwPOXuTbR3S9gjjBtC96xqmpgfDb+vFCrR1GV8NIvOesWd91xYMGA5ICOYFge/sthaAeAoPIDoct42D93RKxlySQooihEOCDRQUYcPpD4Ns0qBny3xb99r6EZxg0XjNnTZRj7DvhYJL3+Y66o4F8a09+gtEERM3iG3oQ1DkxBDXVvaTiSeMmV1vxm0no/5T4R/FZS3UAA4YJq8mKr7yiBxUEVm3IF2rXWVG2jcl4thrB0xum6exvIKviWFEJmdhpUvq6FCgEmu+oBVZ3/kqAzWrYA5jx3zFzjxXp7Rxiah///kqx+FDI9hrQoqHEzVxL+5Yx3SG9iQWTpwP0yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ij1xQ34yRv8h94MaqnWtV9tVuSHiMlbSdf2TYTnjTdE=;
 b=gPQcwSK0jIII7ItudqELpDB8rSVOzHaYusWlPk4NEQ373JDJLwHSuC01LQLEwv10M9LFaO8A+YHUT7GLjop7KByc5yggF4HMpVz3sNX35FL1U07kgWE3O3MFBlSnRxZTcNSw2EeOCk5w6cEBwfkyQDojBYKRlhHiWoB6/o7c1gc=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:47:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:47:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, beanhuo@micron.com, avri.altman@wdc.com,
        cang@codeaurora.org, Yue Hu <zbestahu@gmail.com>,
        stanley.chu@mediatek.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        zhangwen@yulong.com, zbestahu@163.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        huyue2@yulong.com
Subject: Re: [PATCH] scsi: ufs: Remove unnecessary ret in ufshcd_populate_vreg()
Date:   Thu, 18 Mar 2021 23:46:46 -0400
Message-Id: <161612513551.25210.13542348088832231641.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310082741.647-1-zbestahu@gmail.com>
References: <20210310082741.647-1-zbestahu@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:47:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee16a609-3d8e-4a6f-e5bf-08d8ea89afa5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB447062A50E10FBADEDC97C818E689@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zjljms1nSfTsb6XqSiDB/69thFOT+Rf7e280KG4Rfc0x6jB+8zz80PZkBsQiQvVfmacLCKhHG/y69c64hRFk+1j/vc2/qgZC4Ey50yMDS5aY1j9Qa44bscmBB/jSjh3Qf4s6easvtUhwrcouXG5T43hR8sHS3fYAG5nVmULkg5TYxYoedHTRAKT8rZ1NWd4gHVgf/ef3yLMHn2ZybWxFFM6zRn6Wo1aVxVwmL1V+ybp4j2rnuVp024stIenvqYlaldnv8EoVsw4JNer5JoxexGQ4WNsMUM56mdq1LuuLrvslUEZvESaBwIbLVxpKKc2qO2PRs+sXKAB9/nxfXMXUHw/nAtNYZAii2bsN9LH+cFgZW8gg+OrDIiYCNwllD5hqfOqep+9wKMq5YRbzjTFm5E4+hqdA0QGPnGyzyawmQTPLl5Dj1n2AdrYZwWWS0E2jnUS219NYfjBVnm3jGP7OeERI3JlGwOI2OiB5K3oNY2pQrl498TkucLghDMwGcSBo2WKeioQegVXuFFi7iAPjOzy66daiN/r6Ib6Nu2T2D0wKMVZSw999cihNeZHc1/agvJpfIf7tYdGzDn9nyMYWEPnDqljL6MjdPZm3nysxWSnOf6W9+k16JNo7jg99hjbqle4BMzgumMUpaZeAqN0k/msg39Z+RlpHr1ceHT8emGJTj8VHHkrU0SbFBCO3mvwT3W+nZ8uQn5xEJ+HULIrUu2fgyktWJzN2CNnKFzVY4TM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(38100700001)(2906002)(4326008)(956004)(6486002)(5660300002)(8676002)(16526019)(66556008)(186003)(6666004)(316002)(8936002)(103116003)(86362001)(966005)(2616005)(26005)(4744005)(66476007)(7416002)(66946007)(36756003)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WmUwZ2VSY0pKWlh4NGs3NFhxR3dPZ1BDS1hZQmUrd3U0Wko2SjR2MUFvL2l3?=
 =?utf-8?B?Mk9zZDBKa2NaZ0s2ZEpSeEtSb1hkeGY4S0NZSjh0ZFA5MCs2a0hRYXlrcVow?=
 =?utf-8?B?cmZWdmhCcjVDNnpGbjRKMEhheEFaUmR0WHorcnY5a2tYZlgvaDl3OTJQUUJP?=
 =?utf-8?B?Y0Y3dFVTZDQ2MjJOVk1FNFU2UUJiMHcrMTFnKy9TbHRzemdVdjF3MkNLTDhp?=
 =?utf-8?B?WEQzY2ladlpYN0x6aXRYd1MwSmMvYmdRTnd3cVB2ME8xSUt6WUw2NkpVNStx?=
 =?utf-8?B?c1BMNDlqWDQrZUtsMUhtV2ZreTZNSDl5dGNNMEZyb2JCU1BDaTJhR1NwbG12?=
 =?utf-8?B?UlRlclg3bmRnVDFSTUU3NkN1U3pFOHlUZmM3T2ROUE5sVEdaZTdPN0ZDU0gx?=
 =?utf-8?B?MlJtNlNNOFFpTkduZ3RZZlMzZXYyRWdlYkJNUWVJR1lkRFljNTZpdmJDTDB5?=
 =?utf-8?B?TzNmZS9UUVUrZWk3U0REK25rY2JFSC8rUG9TbTdUUnB2SkdXUm02cVVjT0VO?=
 =?utf-8?B?QlhZMFZscWc5U2IrNDIvTHRySVo2RE1UQ2FvNmFuWGZjQWx3N1JSYXlUWWNE?=
 =?utf-8?B?eHRlQm5oVmt5N0xuYUhnSmV6MUwxS2NWaWZuWlZwcngzN2ZzOWMyckFVVUwy?=
 =?utf-8?B?SFJZU0JubmovSmdxZURkNldqT1NQYzlvQ1c0QTkrTzZsK2tGVkswVlR0a2Nm?=
 =?utf-8?B?MHdqM0orK1pEalBLRVRpKzA3U09oYlk0eEYvelBld0VhMDNISGQwT2NKLzky?=
 =?utf-8?B?aUx1VVZ6UmtNM1l2ZUdVNjFMR09KM1lhTjVmOWJDV2xCcFFJMUE5RFdFWWRa?=
 =?utf-8?B?OXFWWTBXdE1Rd2orVW5hV3lFL1U3R01GL1FKWlJHbCtJUWs0aDdGVG1IUVVm?=
 =?utf-8?B?V0UwNDB0dFJDVG9PY2U3UEVFNENZY3k3Q0VUYy9KK2JaY21EcWl4TXRMdE9u?=
 =?utf-8?B?MGRiNFcxNGJxczQvTGRtb3pqZTB4TjVMcFlSSHcyMGx5dnZXRlVEd3M1QURU?=
 =?utf-8?B?YkZWZE1Od1o2ZWUzeGNkaGlnWlg2TmNqZlJwWnJVS3oxbnhNWC9HTGlHUXBL?=
 =?utf-8?B?NDdTMXFBdFIzZWRKUFlUblh6dk5NZjhUQzhHcThvaEtpcklTcmJlMC91K0N6?=
 =?utf-8?B?bzBkbzA2Kzhnc1FtZXRkSW5JT0xxUGdGWk81MTlvNElHdTgwZmJnRnVPZ3NP?=
 =?utf-8?B?eTFJdkFucHlZeUFHUUJaYWJVYkI5UTdzMVl5S0hVdElsMDlnK0Vtblg2cUhv?=
 =?utf-8?B?Z2lzUWFUbjJMM0w3L0VvMTFCUnRVeTVHOVd0QzJubmlxV2pqMWNyTENQOFZN?=
 =?utf-8?B?Z1VibWxjL1VmaE9mNmV0anRtTUJpU2hUVkQzNlp0RTdEZDBLZWQ0UEFSVnN6?=
 =?utf-8?B?L3RaZ0ZPekV5WEVmeXplL0lYTDVHaEMyQVFqODljRUk2Z0cvai81Wnl0Qjkx?=
 =?utf-8?B?b200NVR4eGR6UEJGbDVZWTI2TXBhNnc3aU41djVHMDArSHBGL0JxTEZXSk9O?=
 =?utf-8?B?NG9zUWdFQWRxZWNkTmR6dHlkL0RlMDN1SGNnR1REbWtyZGFqQVlOeVdXOW5J?=
 =?utf-8?B?Z0kvcFZIbTJ3TGVQVThFUklxR1dicjljaE45NXVqVjdWYVNqYUtJWFp4cVZN?=
 =?utf-8?B?eGFBa0JnR1VlRHNNN1B0b3VBRE91TkpNMGl3RXZTUm1zL0h5YUtmR3dSNDRm?=
 =?utf-8?B?ME5rajQrdDk0djAxdU1jUWlsdXBIdkZNTWEyRWF6R1Z1T1JUR3U3VDdRRUZl?=
 =?utf-8?Q?Gz6F80S7QOeKn2ZBtSirzpsb/CSfTbepjj1oX4l?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee16a609-3d8e-4a6f-e5bf-08d8ea89afa5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:47:15.2921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +QCiyvVgu2RJB+C37zYlPc2Q6hfL8dZFspYWioXjnLgJsAD5bVPrM7DW91Q76sYTgG7OU9B6hOjulSknfA8yAYv9vDaGuSHP/BbAvSob7Yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2021 16:27:41 +0800, Yue Hu wrote:

> The local variable _ret_ is always zero, so we can remove it and just
> return 0 directly in the end.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: ufs: Remove unnecessary ret in ufshcd_populate_vreg()
      https://git.kernel.org/mkp/scsi/c/2a8561b78e37

-- 
Martin K. Petersen	Oracle Linux Engineering
