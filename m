Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F00C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 15:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8661A61151
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 15:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhINP3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 11:29:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43860 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233202AbhINP3Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 11:29:16 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18EF85st006296;
        Tue, 14 Sep 2021 15:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=oFRxf0zVFyEumEKoFdFOtF+KhKmV68JQyU2aUXw+mGw=;
 b=I4lo4arkiJfjH5apx6NAlKrsba0/Rj43meTUlRL1qQwM2Ed/F5sr5sUj0XbtQPB9NXuK
 zPbUKBgoPUxNhV6undBVkNvDbfWXXrQp7PIIp5gnZudPoLlIALbOKQzFTtWiGMjvTCM8
 aVY7pkMRxYIDxplpl5n8shLOQCBEYd/6NuEahW62g/dpF+qzbbUuCEir3dcIu0EUObEn
 0jMbwkuuWCIvs8MdvBl2SHPGUtpLz0z2i1UDeelKVEfqlKTZmknHHmj1DZ8sainhX2QF
 +wjUlc6zRPc6TqolZhvBo5m3AMbK/xREBrk2G8TUXNG736f7bXW5/r4/LqwMs4Z2a5uG Mg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=oFRxf0zVFyEumEKoFdFOtF+KhKmV68JQyU2aUXw+mGw=;
 b=HDq5dc8pEW5Kz9mD/xZPG1czcBN++bUXH+FCs/+rv+BHzOKMgNnl4EdK0Mpn0Tq8EiBp
 pRmvYDKTsKcSlTIGIJsI13T8bIcXxQUxVseFsIVD5DuQIt3mi8Q+ixQhexhlfWgfukz/
 3L5fLzu+LBu+/r/CZSys8Nz3zhSLmCW1KN8m38op0VJgCYjhCTSd4xgtZGjGeX2bMOyC
 DqfNucHBGxGdOoAhvCY9iixiafVG93ZVGpJDLczBRWWAztVsTmbF3dCFKcJ2rVYa4HaE
 FMfII7oyLgPjEkKySsaQyH8tGtD+e1LU2TR81zmz/EBVCmg5XParm4ZyTNc/Rl807ClT tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p4f1y15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 15:27:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18EFR62B092333;
        Tue, 14 Sep 2021 15:27:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3030.oracle.com with ESMTP id 3b0jgd9qa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 15:27:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcdwvFP++qxJA9WE7svqbt3/iKgaIQ5BneUjsjafF2YQVhObTi7d/G0jMhI5OdSIwego4tJCs4dC43IZ65o686vwpC9XrbU/X9AtYQ9U8D0Hhs12G31KqrV9psNvGSQKfn0XHBSoWqgSraS8GLolxZl+2t4VtiMDX063Ut/fHecqXB9M+DNNdjGtfkyOykrPTnhxgHtUosIqktUV1k3N6SCDCv6DBpj8EWZel4VJvP6yrTCf76qROGyc4ZwdHeHcTB7Rh11kscIUwxMxtTNx4CeG3beZrHoTwQ5XFWgq5Z3HlQZo22X/ONEmyTB1gEz6j9uNdnGAbz3GxTEkdfF9/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oFRxf0zVFyEumEKoFdFOtF+KhKmV68JQyU2aUXw+mGw=;
 b=bu6ZAaEuMQvYYdQDeFiY5ARrunzSB+D9npQCiby+K+tiUhs+tfOt30khfUUD6f+j8KE4cuqGjBllbC9mviriadGXFOtIXfWcFNS9pc5bbSEXYSYShNDAOw90klX+YdHq7z6LLXvx2gpehggdiWZaeXcZgz2tQmA0TRyYJgfq0/AX3UKqxIjqoEtEmD0sYhyOoxHWup/wzsCWjo8XvU8Wm3WTC+J/zx+rbyuxJLKnjX9Wd9oh14+A/XwvASYP+FymKQk+dP44NfRO/grYTs206tE0SWAqUSznXXUI9pbs5HUbMSzEODXWGgIzTch5cS0JaFTu7AKXabrG8yu0gnUBnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFRxf0zVFyEumEKoFdFOtF+KhKmV68JQyU2aUXw+mGw=;
 b=FwcWAsIZjR1lnyWCLGmUClfH+WmAhT3prQV3KI5m0ZlEB3gaa6/A2OUz7Gwwi7N+KmTsQhzGtd8TC9Z07A118WuKr5N6x3EK4UyzYtSKNMlgBLCv0b7uuYBYQ1FpQyiuMosay2Rv46xTXw8/EfMYAblLeVtj5TUG1XJrstfgsHI=
Authentication-Results: us.ibm.com; dkim=none (message not signed)
 header.d=none;us.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 14 Sep
 2021 15:27:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 15:27:53 +0000
To:     "Wen Xiong" <wenxiong@us.ibm.com>
Cc:     martin.petersen@oracle.com, brking@linux.vnet.ibm.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        wenxiong@imap.linux.ibm.com, wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH V2 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnnjxk0c.fsf@ca-mkp.ca.oracle.com>
References: <yq1v934yysg.fsf@ca-mkp.ca.oracle.com>
        <1631300645-27662-1-git-send-email-wenxiong@linux.vnet.ibm.com>
        <b73451e25a3f7881fb507500cb6bc0eae63f605b.camel@linux.ibm.com>
        <f754c31d348465f96ad4cd7541a86168@imap.linux.ibm.com>
        <OF31B21169.103CCF65-ON0025874F.00776468-0025874F.00778F79@ibm.com>
Date:   Tue, 14 Sep 2021 11:27:50 -0400
In-Reply-To: <OF31B21169.103CCF65-ON0025874F.00776468-0025874F.00778F79@ibm.com>
        (Wen Xiong's message of "Mon, 13 Sep 2021 21:45:55 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Tue, 14 Sep 2021 15:27:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44a86078-6494-4db6-1a16-08d977943860
X-MS-TrafficTypeDiagnostic: PH0PR10MB4631:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB463151A327A5B5864BAD830E8EDA9@PH0PR10MB4631.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOIlEq1/P8Sr/9WnNDv3YebVc5R/8A8mTw3NJz2h8LT8kIPhI49qzx52w/bjhUS3QfT8y2TvM6yvK4YafXWdRuAD4+7EwiE7ElGwTIQ2+u1oqKe5tNtvjyNCJbpC1ktbCMbwuCndzLi4mhwySbTNGV5+tS/8BC+s/awvYZf6e8hlrAzXS30tsIp8YQBZw3G7Za3UaMoOXjmczX5ERyDz+eORjAZsJ5QyWEDSrOt1RnG5NSP19MeLOSg60a4uk/2a38h8CfVEWtVN5lBuF4Bi6/gs+M6LpHv/6W2tdkiU5bMP5BjwgP/4CPeXsOanoxNfa+Bk+CohqRG412tv4AQqB/3KC2/NLlPEhFJOca5n//rFa4xP+CfdjQHMc3lVd3cV4mTWa/K7o0ZaEpc5Lf0sob0okhRs/9OXZi4i0YdGXvUbH4qj5JkH56RBQe+RLKpUtOD7EqhRQ6fvcSIM+vAunpck75llJLy05iajSkjo7PvgZbVZ3S7GQ95/VX4iCuWeHKVhtg//IhIvriE+eek/vCzVXXri7CGijTwoQAXRNw/lrbcSgocOvP24nZar7s79dCt5DFXwvf92aNFEBTV0VJqrn6DaPdGU8gD1yCcWh8YD3l4YqcFbw9XkXVnN7DnKYGkNvSNcSIbCZBHiudO9QzXWHUsqwjZxgWxQPUedZ0SeTJa1tVc+DPjkjXf/q9pLNMiJQ4vYpJgZ3abFPXkn0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(39860400002)(376002)(396003)(2906002)(26005)(8936002)(6916009)(478600001)(316002)(38100700002)(38350700002)(4744005)(186003)(52116002)(7696005)(4326008)(8676002)(956004)(55016002)(86362001)(36916002)(66946007)(66476007)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5mXBA9H2nKX+7cJyicU+uMhCd/YeZMS/pk4U6vgiNlTsuXAl8kDEPR3hPfXv?=
 =?us-ascii?Q?7ngabAT+cVoHA5ytJowS+cbUNYvSDFKsIdLWihVjlD5dZxoct7E8eEEciisT?=
 =?us-ascii?Q?ShZb1SNQJfVhao+jXum3woFUJZG+gZCNUjCgXGLjFf32rjnkCKpUnmBcq4mw?=
 =?us-ascii?Q?c8CGB9NZSgNRrBs6iI8KmU2c1KzWTYIZMLiR4a1NKUSa15GmayOJXGS6jGSF?=
 =?us-ascii?Q?FZLa8pYjY+kJBjymjcbVkMtOWBdhnScVX12Z46DE/UqR7N50ZtPgJc8VPRRZ?=
 =?us-ascii?Q?uOCVFBxK9PzmlEK7wvoe1U40gGZN1ooIJU4PV4+VBQHxgBFKRCc5IQMwxk5m?=
 =?us-ascii?Q?CivWBQKWpPsjBMR78Kmsw5/rxerAVk6rPhTRHM9jamJYud0CiFNGij6MM/Ju?=
 =?us-ascii?Q?DEoQJtFt594pUeES1bRBz5pOYSgUgB3DoSbI1EyN7KobeZe4vJ3a0gzcVSMA?=
 =?us-ascii?Q?FtqrjCzfFEB8Qfm4FRY8SBgoDrwQ10wFP2QXuh4Dp99lOSlFoIM67Lln327A?=
 =?us-ascii?Q?ee9rt2Jk6OI84yLNmORiUEGLQg8KJFo0ArI5JG3r2Xb370pAERwsn54gDxcq?=
 =?us-ascii?Q?Wf29Kfn08ei/TouXaAeB5EU0qdG0MUm3+zcQ1K9xJ49zbwHRGHhe8X0TyAWg?=
 =?us-ascii?Q?zvgpBE6k1DzA4X7wVr+KJrcmXLAQXeHvwWY/tHGEvbirbh0rq9aVbSBdp5zf?=
 =?us-ascii?Q?wq4FpCHmpC0uy1og7TpZlKbcmzi5IqET7h24YWSLR913ES/Ab27vKfh3gfAq?=
 =?us-ascii?Q?djIk7QzuYK+QkMANUgCnkK1tCHBM3mOWSemOWXjuiqGnjnS6gXP0VABZO0XV?=
 =?us-ascii?Q?Gv+NFCfZxZ4NIOZ06a+rqAFhuAClUlX6xjukq03GUJSdwrRRqhmh0VH0Lrt0?=
 =?us-ascii?Q?4PjplATB2Kt5wC5HCGXhCQLTTFttvkRzewV3BHPKqy6utzH38FMMXnLrqZZ/?=
 =?us-ascii?Q?YOtKDbN3cHE2F03YZe6S0+OaQ9wVIwUoSSz0uoTeORVfuRKL5/n7JVK6qdW4?=
 =?us-ascii?Q?97tyEguEMPv/Oed53dfxXafJdXIVRkMOakyH4U+kM6unBvNcsSAXBQsrO3OR?=
 =?us-ascii?Q?qujOSc0WmvX5oewCYkc9LQQnokMy8LZ/ZX3wi1dyDfNGVCrwfSwEIj82FeHj?=
 =?us-ascii?Q?/K/bINoenw5SCrw1N0ty8fhxlJpZzl2hc+nx3vp8IrErBHTjBWKkGV4SVz0f?=
 =?us-ascii?Q?XoJvJAaxR3u7MIo3qvzSbGq3O0/x0YTNUkiJIbANI1+YafMzBbmzEbg3+wia?=
 =?us-ascii?Q?Rx3kzucvjsZg6TVEII6oi+QfHMshUqWjd/Ad8nsZoN800k0ZM+6ZC49zDBJf?=
 =?us-ascii?Q?fjYh3gL7EQrnsZZQhso3As3G?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a86078-6494-4db6-1a16-08d977943860
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 15:27:53.6633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efuWSkF+B1OHPrrT8v78QCBqaQr4sS0cud2JSkxTdFsBnqt64e22v4SXHIf6Q/peOpNwLlYF+aqyNdGP96hudsA5Un7QK0fW3tr7A/+MTIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140092
X-Proofpoint-GUID: uaZzNd5N3kvyTTQbhT5F-Fj-Uq5pkR0c
X-Proofpoint-ORIG-GUID: uaZzNd5N3kvyTTQbhT5F-Fj-Uq5pkR0c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Wendy,

> Below is error with enabling scsi_log_level;
>  
> [108017.427791] ses 0:0:9:0: tag#641 Sense Key : Unit Attention [current]
> [108017.427793] ses 0:0:9:0: tag#641 Add. Sense: Bus device reset function occurred

OK. I propose you refine your check to retry on NOT_READY as well as
UNIT_ATTENTION with ASC 0x29. I think that would be a good start. Do the
same for ses_send_diag().

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
