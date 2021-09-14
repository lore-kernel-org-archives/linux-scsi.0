Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF78BC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8CED610CE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239252AbhINDpj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53044 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239168AbhINDpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:31 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXvfX008709;
        Tue, 14 Sep 2021 03:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8+Gx1ggixyLIaP+KcrMH0aVQKHkN2Z751cLCXRaAf0A=;
 b=r0tdaQIsaaEhavZkKZ8LY94yH8fCPuJfkNBYcQlh3qN4KPk94r3VYT1iA2S8fB3ArPmJ
 sY076O0yu4HDKIX1MNYEQQvEEzrDfQ3qu+H6O+vafLVJAzDpECnE4DyU4NGmqm68prpK
 98QS86akZTaigA31YOIFS+nq6qYTwmmam5N+FVvb8jHx8H2ck3vWQeV17bEYGAkMSNuC
 4AYpwsnfDkzlfoKHDCUpcOXLzIM/XZXvGpR+9C9AXwR7lBLViqRY2CbbkrLhVHQOP/RZ
 kgOCz3LvspUlD5mejQ5wBNfblCCagrEV87HrfN6HfP1QSql1h8X8sX2C4MhISPBpxNhB 0A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8+Gx1ggixyLIaP+KcrMH0aVQKHkN2Z751cLCXRaAf0A=;
 b=fgX/rLXv7m1AohuwypZsfxVHulYnN2MpslzZGor4AptaxssRkdsKAgWNIOIENkbMyrhw
 iuAykRZ01bx7+2UEwad9XkB+OPM9X4z2Z/f6EsmkvAne63s0uv6XCPN0QvDzISLNfUnm
 tEhMdYAN3akEFbLmd7DI+prW72D+pmJ36RwIXuHvOAZH2J7yVauMEZhKrsnH2DpHszsX
 qc2eLPV7R0laPXClWEWjfORao6arg8K5YYm5GFnPNt6mjuLqmR96u5xclb0hicH1v6AH
 gSTCcw5t66xFxrAdzENuJoxLXJSs1NYOdYDSshDHeqk0jsQ+YuIG7sv87TiD9akzwCjA Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1sd48m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f7l2097788;
        Tue, 14 Sep 2021 03:44:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3b0hjuesry-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRdInepumrVPvhxA6mg0Pgzd3ms9CgW+uJZWusaiTARnJ6Yrq1FVKUNRtHJv0v98gJw1w5Swy1pXcpcDCLXu7koUX+F49S9xQLbJ9VSEgwb3ZdXmpWvy5ccgVeLriBsjnUQhznl99mG36g4KDvn/m6XMpkspbOr8JpKLplO5kK5ooyYBY3A9HtAKL11GBzKSiueCkYkhsPJveYqiPyBZuPlRPHa66HckOrrosUq+dq+QK1STYaB6Yqvh/3mB6fDAePwAs1G3hQDNQzeyKC7q44sG00SSr2CjjPPnxLGUrJcjmwDvZzQ5mPNLX6fpKX2N9PUGCdl+z0oCIVu85GTYqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8+Gx1ggixyLIaP+KcrMH0aVQKHkN2Z751cLCXRaAf0A=;
 b=m/qL4rz2vIMAsIlDQnB1Y1O88iBsy+81dVJey+baEGgvzNF5XQPjqRuPV+DsDVPf558tEi9E87DZL8i8b5GQOu12C82HsJz66KfBlZVkJKOR64nv/2sXXoJLWPMuGDJooJf+xilSrgR8Za92LQZCn8YslkHndM7qZKcx6j95mofdvJjCCvznEAgizu+fLLotWNNaVH3bTIvxxt+yNjSKgXT/NYW6tELSo2GUrSJfzhJisCGEBVulY6vVwsQMSuhTLRa5n0DT/JNWl+blZxYZW2xG2FG0XIImTRLEjEU9OiBs2tuEPu0VMx1R65vACKJpFT3BaPugsqqkGWhu39MKvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+Gx1ggixyLIaP+KcrMH0aVQKHkN2Z751cLCXRaAf0A=;
 b=eneh+HM5eQW9OfcFruy9aIB33tMBDK/RePrIeK5+azSWxFavUkoOwS73bJYthuVLcTwmfEnHYxC4Sqg+AxMjavDbJtdyHeHHtJG9SdSNyFUH0DUQucQoFchrw6YXVs404Q7dyrXMTdxSWbQDWg0vMlcA35gq8ddcdBUlsUQszKY=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Colin King <colin.king@canonical.com>,
        linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid: clean up some inconsistent indenting
Date:   Mon, 13 Sep 2021 23:43:45 -0400
Message-Id: <163159094722.20733.9002037986325578287.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210902223643.56979-1-colin.king@canonical.com>
References: <20210902223643.56979-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 671899c9-5721-450a-7c07-08d97731e7c4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB450216CFD8CC8788BC12EC188EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13stGp4V3t/gyyeKQ9m7BwkzufRnX91T1SMsS0LvVH4VWIlR/PRbNXQGpIOW4HFt3kyePTRuFwlY604y2pg8nICNGwG7Nz8wRXcOJY95XUBr5FceNZJ31Q3zKkdNfc+oE/j/7/EQUQQ3qhamy9gz11qGrD166/asDYb89OEMFNzD4XK1v3gfHn7W7g/P8fQK1V2KZFQHxA01bK2i9jXUCHr07MzJT+CX5AwQLAu1JKRuneEavR+eHfCI2/VYIvN6ezWJpqDPOQ9L12tVvifHmXRsS4nha4sP4I27p4aXfzmwiynfDGRtFMt3BEeKCoPAFRJiIif03DV4rS5UrbKb+XHgps1sZ2O2KsMGGTLmhoPH2gr74PqHfFqQZecVbXLt6uhCyhIpXi6YlFam8SqVd8ux92Kok88d/caYAdr6qcpOgfDvObP5/qOkO9y0M74Itmfg1vTBbFioISwzTbrgt3ZYkpKPh2B1+mzzeEPK0e/GDWFdipxdojOSnON4mpmRl3ANIfSOhJEoFDH1bHSP5wPpuBuL2vT2loFmDW3ZKcjwTukZcMUNX3XLuSWpxfL/WDrBA4S5vxLiPpbvnALeQfReJ15qXgATWo/rmlFhosPDVRX+0mdXXYKtJxSNOkTCZ7Sz8ikLQ0heoDyRr6GR3+TQCkXHo3Cq4ehieL1tlYVxrD6PJfKU1WmpLDoRlcWcUFsQL+djwlIB+sC7UgHGuSzUxHF4Chu+crw8BP+ZxQTHrd5zYeLX1amiuB1HqtnUvUyGCwEPJq4MCZhuWR3P6psuHqts9CCIWHq3/XlfMl0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(110136005)(38100700002)(2906002)(956004)(8676002)(36756003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXM4MHNRdE1OenVHQlhPd2xkdmw0QWZEZlJVM2VSMHkyMGE2S1o3RGx5OUp3?=
 =?utf-8?B?NmJ1MUJxSEM2S2FqdFkxUnBBdlBqY0Y0R3RaWVJuVG1mdGh4R3R4Y0ZLT2dr?=
 =?utf-8?B?QTFJTkt5dE5DM0VWVmpGbEs2dit5U0YxZkkxZEUvNHdEcFJuSDBCY0RtZXhz?=
 =?utf-8?B?Y01vMURSSndodWtMK3Z5LzhHZVhXdUpDdjdNbDd1ZmZQMURvYjAvUm9uVGZh?=
 =?utf-8?B?ZUUrdlhxOWR3dll0MWpROUtRYWQzSTNERm5YT2p3L3k5U25GWGxWaGlhNXFL?=
 =?utf-8?B?VklPZHZEYTVVNGhJVktyVkRuMUoybnlPVnhEdnNaK3VSRG5hN0I0MFRPcnEw?=
 =?utf-8?B?TVRncHBLMXZ0NjYwaWRNbDJFclYrVDIxS2RKZUs4Rlp0Nnhld3NaNFlsczdK?=
 =?utf-8?B?eHlNU2FFKy9TK003NndnbWhtMTRsL0VHVHR3SjhjV1UvcjRTVXAyRTFJajFr?=
 =?utf-8?B?aHMwc3FiRllqbVc5NHdTL0psOFNTUnVySTBxQUNIakdZdUJBSm9LN0xNUUhh?=
 =?utf-8?B?OGQrSFY5WjJCUHFMT1BXMEV4bTBuQXN5WlJRbVpqNE9IMFFjNFN5MFNxMWo1?=
 =?utf-8?B?L3NLNHJUbjBWUlpyNVpFZGhYbGZxUzFQK3lPVGw3YlB3cmVrNG1PSEZTOHBX?=
 =?utf-8?B?TWY4WUdMTllXZ0szOURBeU0vQm5PcDg0TmJFSFBwOUpXeHUxVkgrWTdjS01w?=
 =?utf-8?B?VmJpSm44WUNDT1Ayd1hZNFE1R3EzZkc5VmwvVUtKQldDQzZqZkhDQTlwNDNK?=
 =?utf-8?B?NGV2THVZbTdFa2tYZzBOZWVzbVh5MnBYaDZ3SkR3Um1IbmdWS1R4aXFyM0Y3?=
 =?utf-8?B?Z0s4aEJYWldLNjJKc2JmRWhxcU14SHJaR25HZUZiV1JwQWZkZUp0Vzlvdm45?=
 =?utf-8?B?SjUveWJJcHNET1MwQmd4bytteVdXcG10d1dldk9ickVneGFCVzlNYTF5RmQz?=
 =?utf-8?B?T0ZPZDVSLzlFdmszTnBUWjlsVGFGOEw5aDBHeVFFQzFETFNOeUVUSXNyZjFy?=
 =?utf-8?B?Q1pMcnJ5b3hVd29OYkhSWUFTUExXY2JiM2JnVGdlMFdlVThYYmN2R0JvUkdF?=
 =?utf-8?B?QTVlYVNQem81K0NkVGtoZGdHWDNuNnNXd2JYNUtRYWxnUEUrUlkxeWNwZ2Nr?=
 =?utf-8?B?VkZYSG9EbElZSnRxZGk4R3B2Y2dXd2wvNGJjaHd1ODJCQlJscXdIR0RFNkdj?=
 =?utf-8?B?Mi9Zd0FRWEl3cE82S0k2ZWwxTWY1b0hrUDBBSUNPUDJpamhmbWc5UkRPZWtH?=
 =?utf-8?B?cVE1WGJWME4yRFpuMlExbERwbnlmeDhlUm42T0xFV3lVTW50anhGZnpDZnh6?=
 =?utf-8?B?SkVpWS9IMVZYQkZHV1hEOGhtS1VnemxOTXQvS3kvT2FZT25HQStaaVp4eVNo?=
 =?utf-8?B?L0RTTFBzU0p4VWtuOVZ4QzF4KytneVJiV0QrZ1JnZm5SUXh1V2xrTlozZ2tl?=
 =?utf-8?B?aFNWZXBxM0VOSWVpcDlISndPNDRZRno2N0dNZUs1YzVuN1BaenU2LzN2K1ln?=
 =?utf-8?B?R3JXeVZyQXRtR2QraFlGTHBhU1BSaGdqMFJKS0xlVEMwWmx4Tm1mbVVPa3JN?=
 =?utf-8?B?NHF6Y09LV0UvNzE3MTFiMzEzUENlK2FzUmhzVjQ4RENOdk53SklRMHFndjVF?=
 =?utf-8?B?aGJ0OUlSN3FKNWVSeUFLTXo2S3NCZWFhcXhNczZJSitUZE5SNnlibHR0bHlN?=
 =?utf-8?B?ZnVwTUNCUUFsL1dnckxQWE9mZnIxQ1hHME4zeXRORSttbk1wT0UrMmZhQXBR?=
 =?utf-8?Q?NqAFnHwtTthgmHr/HlpTmmdanzIGU64n1bPqueE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 671899c9-5721-450a-7c07-08d97731e7c4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:07.6924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q9jvCQlIzWwm11lftGAMb3Fq3qkh7FWoSm+BevSAo49QUViJTvFYvBtJ1wM6v3ityIrQjzRfCTRX2hx5X0If+UP3xU6QYcz2X7K2MIuI5g0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=810 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: lpCUW09FtIlaw67YzaizpdckAoiWO9mj
X-Proofpoint-GUID: lpCUW09FtIlaw67YzaizpdckAoiWO9mj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2 Sep 2021 23:36:43 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are a few statements where the indentation is not correct,
> clean these up.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: megaraid: clean up some inconsistent indenting
      https://git.kernel.org/mkp/scsi/c/655a68b2203e

-- 
Martin K. Petersen	Oracle Linux Engineering
