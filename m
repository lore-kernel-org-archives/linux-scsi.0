Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EB7C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 04:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbiBHEHY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 23:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiBHEHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 23:07:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA475C0401E5
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 20:07:17 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2182RR86007544;
        Tue, 8 Feb 2022 04:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BG80KTw5690xMmjym73Qk86F0KmM1TfZQTXVdn5JAnA=;
 b=VJCi/2ASfbungJbJY4HF1a4IhivYMZhlaGaof9DihT35sUB5u+dizQaqKkJIYNEfPlP3
 ED91BRi6oddTDjlocAlKOKPzzbcnZspxwqkF7rlU/P9Ko/cRD6iD4Yvg6ZZhisKRObGu
 mAXFPUNcz/GIr+kUs0pJuAisnlfWr+MXDfEwE7sYuXcN1yCV3Hi0wovZkE3PrF54y+7c
 dmGYAKnfRcV9KHTtN7l1abXMwDzMdBPRfcR78xeWTwrovuZOFEIPd8CVVdUJLGickPLc
 yIPHZPJ8BQaOhyjh/e/kwIkyahmquwBi7o8+ZB0H6CLLWsWWA0+14U3p34C8+hT18UPz UA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368tshfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:07:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218453uZ147045;
        Tue, 8 Feb 2022 04:07:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 3e1jpprcpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:07:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0HOBxthoMSvDCAQFYnlF/YJqJMKkYSF6pJp/mhRcRX3nVxYOousoNXKYUjHZcNb9VPd7iNYfDvcS4gCgK/mdWNOS/s5VGm3wXJrw4YkI9dm1gRumAd5v4NAxL5jFwOmj0HaHQ34m5+uS/QazBJbVO8IOulvigH0k2O8xCkvU9aStBzr4xeobl87p4fbwGlFfYkdyPfQOlBiiitYPziGD6gVLJXSZr7CJAEn/EG09+Hxf9NTPLYAGTuMvwcDhearisO8rkl7PVW3u16S0jWbdSxxmTeG3K3q3VoOSDcptIzYFBW/eWuH3QMU4A0LKbB8tn11BPcgDXZd9SoB99i/Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BG80KTw5690xMmjym73Qk86F0KmM1TfZQTXVdn5JAnA=;
 b=nuwIcdpEu+FVrhm7Ita9NCBmkUQZYSMOxjZTwnm9q3Dda/Vpe4zpry2yE8gUfCehdXcKa0NFJLgbd0BIgZXibSIcbO21gFGNp7Ii8agM0JS8Ds0+Iebj6FFlWB7TtlZF4/1hKePQK2Gd15K9IBsh67uJgiM1JT3TB+aLZT9WAx6IlmMcX7X2lX8yPtCeJRXMjgX2Lpr256j5AbEdsnZ2TpHuF0tTig18cUjhKYRFJbeiT3oZEHnocBMZkoJ40SOGGaXTHJ3L8QoRmuWnGdRf/JAze7jOQuFMuNnZ9q+Gc/HI74yNw9dYAxmHPkvSDD6leqXZvzib9SDG0R/DKBIkag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BG80KTw5690xMmjym73Qk86F0KmM1TfZQTXVdn5JAnA=;
 b=SzZmsU1qD/zw7LS3nvkiR+QSqc8cfkHc4gVz3XZVKxkJvhGQI/utIvwXxdby35hOfO/pPBNXRtKFS/XufE1CYpdgDgredDjWBZ46WOFx2/Wh19n31d39gt4/A5GWLj4Y5F1FyEbP/8LhcZTPVwAudKAjkgy69Ahbq1xhkS22sT0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Tue, 8 Feb
 2022 04:07:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 04:07:04 +0000
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: make "access_state" sysfs attribute always visible
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rumxar1.fsf@ca-mkp.ca.oracle.com>
References: <20220127141351.30706-1-mwilck@suse.com>
Date:   Mon, 07 Feb 2022 23:07:02 -0500
In-Reply-To: <20220127141351.30706-1-mwilck@suse.com> (mwilck@suse.com's
        message of "Thu, 27 Jan 2022 15:13:51 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0017.namprd02.prod.outlook.com
 (2603:10b6:803:2b::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7806ccca-c293-43c3-9920-08d9eab8775b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2709434CC786929DC0734D6A8E2D9@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XHDb6qgIXA0JBfZSCdJVsl0Gyf184L82EnQrwXDYzIzYYIqY/24MFIgmLH5+aHDUvY3UBvS+Ng0yPKPsj27AivKhec6eB1SKkX9k1WwbgOQaANbiRpxuIA76Wfmns/hdczn/HtPijOKWnFygkGOwuWcSREE8L6E/hxu8Wd2qhw2jd+vU508cvFEuDPpTD3RZIbrr6Y3loCdI34SxT5Y0MVf5/4AKmmxG7J+1F+iBwT/JHLoBFe5Fd8FRW+oLpif6p5S7r5qBiLR1U3rrG7la00DEyD6ov7W8ZuaMPYLHT7mS+2PhfPcUIJ+SUgRd2LNCN01/ptXp+6eLvC+3pxSspqoh9cV6Jyi/GMudUMko7e8xiEQ/FH04MsIQkoGkT9YPAsg8rMjY538mQUulHRB6tgx2T0gJcz5Wju9lZfxJm4EnlJjxAWCjlxBboRPYoFn8dYeVtd5mWw/oM+t4qq4KwKhgpQY8v5ykgOQG+WMnlWD/YbO6UrIzqA/occCBtoJq0BCqe+pLHvsxuNnMpN66MJsVzT3AqskBGXH+IDb47qI3Yv24qRjamgxU2lpJg/7aHbcSCrmvRC82ecXIKnMSsbrWHEqbAaI2Tp5sKUwS8ASzbKQsbO60H11HeyJiD//X4jX7gQCI9ftx5cJyo9znlEoeJPeZG+L1OpzTIA5/2qVIrnEKVvzKNw9sxE9g38FdENBwbMrCXk/L1xsUDbZwJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(6486002)(508600001)(52116002)(4744005)(26005)(186003)(86362001)(36916002)(66476007)(66556008)(8936002)(66946007)(2906002)(4326008)(8676002)(316002)(6916009)(38350700002)(83380400001)(38100700002)(6506007)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OCWqsqs+J2pQ86SLcXFeLNLPy1Df2vv36RwjwsH7v9XUGsx0yH57b7C30Nx0?=
 =?us-ascii?Q?1mSR4knmXoBCXm1OL4dGdDIu9BXUo5MJRLJAln54yqKe8G3n4MF72+k5HjRJ?=
 =?us-ascii?Q?cgBjxkm3HAahSKyQnUE6Hp6FKhS7szVS/bE8W1SO5+y1ztvrE8uk47mBfPGn?=
 =?us-ascii?Q?8KFxvv6olopceT7iyERAE3d9UtbMC1NtIWx8qBeZCnkfTeXl0yWD8OkEXLQq?=
 =?us-ascii?Q?WfElZNFg9aBiM3+y8249Ztn5/21misErLmbuDjYHkD3qmrtZEkQnvLHdQtyt?=
 =?us-ascii?Q?aiVZh9cpL5EphXpOPe2t4ypCf1nxzKA0tbSTuRtxlkHlZcmqH9Pq55e8y78E?=
 =?us-ascii?Q?f8j7GUFfx4dOEoMWcncKL2zjTV/hiPCCqsjVGywjcI+WnD8pl37UedsNsuxW?=
 =?us-ascii?Q?R0e5PvaA2Y/lbGC2miU9+mkZVDmTt+j+S5PiNw2oi/7PppvahSLbIJnbjZ9G?=
 =?us-ascii?Q?BhHbZfxYiU5e7ctuiO4emLX3xR/xsdChyQI5LpkJ66jEcMIUfh4MvQqwoaYe?=
 =?us-ascii?Q?wi4kNSWIlkaVZbce2ZKeQNqt6sOO4Syn/Dk2dCgCSM5SuzDMN/QnWsZzHv7Q?=
 =?us-ascii?Q?ycqYnQcl9r7ru+HJz0iNaIuQ5UPGfiyqUOhCYb7yQ1nTJp6feGgMCA6H9LLI?=
 =?us-ascii?Q?PihLiIytNnji8l+WFeits/ZIP+ComsNVYF1hsx2Mnfc9UBvmABmSmIngerYt?=
 =?us-ascii?Q?3HeUM5VQnUZ/GQHtdkekBZAyb4pgvkkZaEBFBYCpIjVN+a5jiGVVPH71brET?=
 =?us-ascii?Q?SNY+eRe0iq77O5ms4KLrg1+WR6wTstt9Bm8RGBepPb/wEiKAe4GEmnRp2KUE?=
 =?us-ascii?Q?aYMZ+PVrcu8a9SG/XaJma8YwurYw2dhZF08tP2geLJzkmC1Xxfl7bIomiSI3?=
 =?us-ascii?Q?RNTxwcIz8u1HdSy1oTmPXBmfmzY8AqsMMiyZHEruQc6p+pweiOf89SjdV/Kp?=
 =?us-ascii?Q?aAUu58ciMaw3CSfXwxx0BR7ZV9oBgfu61fg/atxDGxN2sKkM5xlBnAqMkEJZ?=
 =?us-ascii?Q?qZlsUWHGnVWkgcBZPrd4dItHbrQ4kT5yQqUVywUZqLXrg9n2mexElJNt+AaT?=
 =?us-ascii?Q?CGs0/xRzAMZ04AJMH5S/5WvYgFQvSBQbv1msmwX3MqgFLI+M2VDVGxRa5f62?=
 =?us-ascii?Q?zLiY7XsGQBLJVsN/E3dDbOiy4clj3/HfZVhRuT3QBCHkHLz1XwbM2JNp1lh0?=
 =?us-ascii?Q?n7ISmBennM5cS4WKm8PP+0z57t1EZDXEqHBqvbayP5L7hf+3EISZkjBTtYKX?=
 =?us-ascii?Q?eJPb3PbJi7Pyd1yUDncpDIq0qQtEt3H8P+Hl1nyggGqUxr5Yfc3EUy4orPj7?=
 =?us-ascii?Q?Mc0pSahtLnSfVB1HDZpb0ZueFYfhnavHonLqOfCb8bslS5A5iCn8BVysyK4j?=
 =?us-ascii?Q?7lo6y/SgxEk+o06+7xCZsk83UnHv3WNDBo+5EshiuLJBiCJjZaqrGRK6D8f8?=
 =?us-ascii?Q?gWWHGv1kxj+GB0A5VzgNzgvArBwP0UStZd64c9C1xFWs8QHoX6pPzk4EkkEw?=
 =?us-ascii?Q?sx5qwLv5x78dzglXZ1iv830t5PYHEX9+/hIr2qGYM4C3tu29NvE109WTQcR/?=
 =?us-ascii?Q?54V0sOo+4OvPD02Cpu8aCLH54fM/y4128f6vYFXA17dpgG23+3z4Ii/JlHcH?=
 =?us-ascii?Q?G5YaU8GgZtqYv22q2lhwiDjYX1Lb9wlVNPUXScNdbAlCp3omLT6308Tw+sE1?=
 =?us-ascii?Q?RtfSbA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7806ccca-c293-43c3-9920-08d9eab8775b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 04:07:04.8742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5nTWZCT5RcFn/S+LACWchYa9sQV0m7iXJ4NxN9pt1LLC4iln+i4YjcO0ByqkeQ5QSFVxKvbm71ZL5IbOPi5A4BRVWnVW3a1HX/RzmD5oQKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10251 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=685 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080021
X-Proofpoint-ORIG-GUID: LkPDOlA3o3HKumgWo9jllLwZOZoMxfqX
X-Proofpoint-GUID: LkPDOlA3o3HKumgWo9jllLwZOZoMxfqX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> If a SCSI device handler module is loaded after some SCSI devices have
> already been probed (e.g. via request_module() by dm-multipath), the
> "access_state" and "preferred_path" sysfs attributes remain invisible
> for these devices, although the handler is attached and live. The
> reason is that the visibility is only checked when the sysfs attribute
> group is first created. This results in an inconsistent user
> experience depending on the load order of SCSI low-level drivers
> vs. device handler modules.
>
> This patch changes user space API: attempting to read the
> "access_state" or "preferred_path" attributes will now result in
> -EINVAL rather than -ENODEV for devices that have no device handler,
> and tests for the existence of these attributes will have a different
> result.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
