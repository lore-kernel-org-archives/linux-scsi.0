Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D35CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 03:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbiCHD0T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 22:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiCHD0S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 22:26:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF054D74;
        Mon,  7 Mar 2022 19:25:22 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22823Toq028212;
        Tue, 8 Mar 2022 03:25:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JqwQ+IizYeMdkeMhdk0fkyj9l8WNFcWMlwH+BE3uq5Q=;
 b=KLzRJ6TLYToDOTnLyzpYnZLV/Qvu6X0bdnLGJrfr4KKn3ghrEuu7GbOTLycYMgtC9GR8
 +Ac2XVDQ21KbXaPeTaAzfVhKKDtQ4z3+j4rK9AwisGwjRZW0AZTLRY5/layj+zarraQl
 md308aiLp+PAjAXRM2PuPBhJeWg40H7IyawiW23DTOeWUoZvfaXzEvduprwhiZHEQexb
 ucyYe0E9jezIynzPxjAuTCBzZVyqXdtGwnAuv/B5HuQyMkzLz5nXLxenFx4XJxIBc/33
 O96cJcli+l+efZFQGGvSkcvpIyYi4oOY0Ucv7iQR5EunVDp8RbqqWXA5sAvvYSafMRdt Ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2dt65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:25:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2283KMc1035631;
        Tue, 8 Mar 2022 03:25:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 3ekvyu778b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:25:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jhryd62UjEg6M8uteWIaN97RCqFs6FZ5RC1eAi6GZtTBjf0JBclwdfEgxu0gPN0AQKGSx8TWtZzOH6xuFJvMRYURi4UHaYmoQN2CdLgkrPRXmBKJMofz+H1MaYu80w+hK6lSgJQ5SAAa0uhkWa/xyBnKbMJ6fdj6X246URetKqEpyAb+FFYDAsXMho6pqYITpShJTJDclbCN8tDcNZW2U45ihI+HGuCH2BMpEI74AwCV3sCqxfzztwUOXUp7Aj1b1rwGzavedQAwxBGHUg2xFT82jw25gp4HoFviG0gG2PNPwlymMtWG2iFJMlP31zpodXgnkkKlg9GEiegtLASsrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqwQ+IizYeMdkeMhdk0fkyj9l8WNFcWMlwH+BE3uq5Q=;
 b=oIzpR3+f7uHlUslWlEQNucPd2Domk6MJE15DbUoJ+VInQs+mENJGyYF/MEVVCuyzIRgrARjjTzJQh9JFqOiBwk7aCwZT7q+iu7pAA0ApCmil/c1hvtPAbTXQjpPSUiEx4oDRLT0YofbdM0hXEeXliF/ws1T352pDydKZCE+xUC0tvftH7goPlw7/pUpcxPFlkxdzSURHFbEhJE8tBgSj1oSfu1HBhlDS33+cP5paipQLQt4UqpOW7JaMj8lT0ry/U9Ec1+99ueGZr53eHucrmOcgnd9gk4o9ZcveRowqByRf5ORO+gLpq2pvxy6NS/7vBozsc+2xce0IjPXHyQggVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqwQ+IizYeMdkeMhdk0fkyj9l8WNFcWMlwH+BE3uq5Q=;
 b=0Stjkw/oUjUoh2wLege8ghjiA+2kqUEM7yZ38+yPyhAhnpl2baMg4g2ezOMVhs6F4Ei5K9Cf3fM4iQtZPQHQ83a0a5++4YwTIZc6Fjf+LWuZlLSH9GsvP+BBt9dSNfm0WGhhBurXvKZ+T18aopFtI9kVMbUUetb5YYrgkKur9Ss=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 03:25:12 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.026; Tue, 8 Mar 2022
 03:25:12 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 04/14] sd: rename the scsi_disk.dev field
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnh5p1x3.fsf@ca-mkp.ca.oracle.com>
References: <20220304160331.399757-1-hch@lst.de>
        <20220304160331.399757-5-hch@lst.de>
Date:   Mon, 07 Mar 2022 22:25:09 -0500
In-Reply-To: <20220304160331.399757-5-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 4 Mar 2022 17:03:21 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:806:f2::10) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e072d364-d645-4003-8d7d-08da00b34198
X-MS-TrafficTypeDiagnostic: CO1PR10MB4481:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4481F511F990775238A4816F8E099@CO1PR10MB4481.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lNnuFS9q8EBwvxTCcPj/vbgHwNDywj9SxPkqFJjwPOBaLYyLzVOISk5BUyMdE/T6t52FmvJQNDkh48T37MmJfb12vdBiWE9sJSWaDuzoLEP54ipD232MEYa4mL4E1jPQ0oDk62kteDLLONUs0gfXOKCqDGobRInb+7c047AVMmwh9/jG6RnJMLYHqYme23wuaTWikFDyYDYtJuKWmogKDKpE3w6l8Ect/IMv6ZlqS7zk+V1KtaKE5GwlGp4XiLaNXWjcJavFgksiTr4uN0f9s4T56FIsZ+kI4L5bFXZAz/qpetI0BLGjFg6Wal+Cxait4mwpaIVCoFLF2Kq145H1guhcmAv6eH4nyVuQQXhrX7arghPcuUAswutEIzQEPtNE51Tlwya+EXkeyBHzgp+LyqM+sE2CxBatMEIinOjBvOk01Kh1KS+UF85yRJilntY5bPafmAp/CrtgsoX0Pq96xHKEso1WWvLaLkt0eCbBAkVysrqDC/TDXyTe1AyCe21neW72M0DWs4mztn2Vl8cuCsR4zJ6D4ks2twYHG4ct/HUJB4/tXD6HoSLw1Dg+NDX8aoHBw0ywcx/K0i/JD42IFgO5DAxUrQ6n5A9fywhV0noj5N40TaIoggcHqnoEZyxvb6xslMI+sKh/8PCnYnwVMz7HSx70L3lPC11//IfKIdxULE4EXCFVRGPBAuVcK26ZIGvjeUgQ69pmmU/lb4nrFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6486002)(38350700002)(8936002)(6916009)(54906003)(26005)(38100700002)(508600001)(4744005)(5660300002)(66476007)(8676002)(4326008)(2906002)(186003)(86362001)(66946007)(66556008)(316002)(52116002)(36916002)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s6RQ8Y7diK8ihiLK1KZVAP4Ot4E9lyBO+3vfuoLEF2fTkIr9IWyeMOxQvAN2?=
 =?us-ascii?Q?gu/Y1RxgXGF8Kmoe4swxBW6Jid9Q9tPi7tpa3mMjaoLWVo5u0mtz/7Joyoge?=
 =?us-ascii?Q?DgHWOgwXEWNSCPNLAWwcPeTW7cGHMW/w3wW/R818CGJky05RLVoh6SpwPI67?=
 =?us-ascii?Q?kcOmnhE+59f3yIRbGo/MjQrulw1miubH+oTveTgv8p6P8OmBkaBZgiUfuZxk?=
 =?us-ascii?Q?6nWATFB9EK7EAWxh7Q+79mNyYNafJZfBvJmtNRz8foXq7zg8MZVTD2p4iCz3?=
 =?us-ascii?Q?HWuj6uChOQP/CI0ErVbML3Og8RzF1fSrut3UCGCrH3rzr8PQHKB+giC3BayR?=
 =?us-ascii?Q?CA6u1Z1YHz6Hn2KQk/VeV5LYozjzSAnlGg57/mH6CpB/CUlrD16Fc4ThcVvq?=
 =?us-ascii?Q?2zveBoKCuS80nI2oq3JI0hy+7O9Jkik8BvnMVOapKupmPzUjk9yqUJ9nZRmo?=
 =?us-ascii?Q?8/jXqAOypr8FclryiJxRrjGzu+G0WHmZMgDWO1Sftfe+48sQiEfDkUgTqa4I?=
 =?us-ascii?Q?NRk55IOUidyA4lc7Xvd8etYjSY1wnKRL9xF4fs+azBB8kPTNgucyBgmdvm3K?=
 =?us-ascii?Q?J5j8mTlxPLRFt7dIehmg65FFyDkYIlBzHdHHJAGAPimsya/CcHpkj/DXtcdg?=
 =?us-ascii?Q?7l9ISwL1rTjeeZ4igMIiimY5bD+kJdggYoiegxiujlymBsiINW9kgL9gqlNv?=
 =?us-ascii?Q?3SgV+DD4k5+u8qoZuE16dwX8BnhFVJ+Vo8pIoIlBWNUSRXhfkfWdoFlUYsQE?=
 =?us-ascii?Q?uO4DAqJfV9OGkwC2vKPsdZbeLLD/fCowF0EYzoCemUe3EsWqwAS5SsmOdpja?=
 =?us-ascii?Q?/od629nPE8DTCMHibtyI4AUk/C/oAuvdHrUaGiDO0lx0wHcHuzWg0iPSJ6C1?=
 =?us-ascii?Q?e7P39KpT0n6R8qH3ikSMj7Iw9gLSTF3TItye8OQUbrYx18Rq/BiPvMKKU7Qm?=
 =?us-ascii?Q?XmEucH69aO3oJBJ0ajqtKKgErQbxn37mGxHe6vBywJdnyk3mE6BgEp2uLg7h?=
 =?us-ascii?Q?qEqsHAv2ReUDJZuYh4COQVMtoSQIOnFcfG0mmCituU7N7X8c0/5b12ZxKElg?=
 =?us-ascii?Q?WPKW85Oysnby2ZKy/h+zSSC8T7/SDoTXyKHN/bm4VAppi9THIkChy9lDLOJv?=
 =?us-ascii?Q?3UXaHGQvIwDtS3EIqALCZseNZynvlIXDZmocFFzijlT2sqgrgAvXri0X+fpv?=
 =?us-ascii?Q?wBJYTA1FqacpuWDgbOAZQzvkZ0Pih6aSR48SvckX1a0vIOJbMG01763frLe0?=
 =?us-ascii?Q?+ihPDK5cZrrzvY4hdjtZXuCbaGofAFNIgn3MUkZ6+mDSccwzpMO+PjEUuZOh?=
 =?us-ascii?Q?nPgq1nKsKWT2zuhveN4ykUh6D80GoLrH/o2HlEwtdpcb3XM4Pf1aTIEKYbtl?=
 =?us-ascii?Q?Jv3Y+hBoLtx30/XwjtpMYHTn+tB1RTINtNZcNro1AA6eU1tYarUxyp9M7GfT?=
 =?us-ascii?Q?g5tOJqRm872P0KZFlr8fy4skEeeUpolnARNfPGkIMVB+SCplW3JFxm4AvszR?=
 =?us-ascii?Q?Yhm2YXn7c/RDSgLjbyw1YTaKjgFAilwXtg7HfaXbaV2zFji46G9pGYVL25Vr?=
 =?us-ascii?Q?RzKLeVNP6ggFQ1vId3TIzXhYP/NvVayEDtw60SyK/J9ekq5//R+YUFInvsD3?=
 =?us-ascii?Q?m0ZeyJpZ+hWDRYnPRMAuk8/tJoBTIpjrLR40XY4kAVqZC8xW5VCtc92+Ehrp?=
 =?us-ascii?Q?iz09HA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e072d364-d645-4003-8d7d-08da00b34198
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 03:25:12.7415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXEswwEQ6He9agekVLFF3T1kLwjIDEzzYNlwTfEH8giTatWg6KauQFpYklY1dkAuc4Zsyh47xMfk2OO12pOe4ctX6okHzvNoCa/1/WIYXco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=793 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080007
X-Proofpoint-ORIG-GUID: kanhe35qXrH0sZ4dEGGUZqq15mFicrHI
X-Proofpoint-GUID: kanhe35qXrH0sZ4dEGGUZqq15mFicrHI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> dev is very hard to grab for.

grep?

> Give the field a more descriptive name and documents it's purpose.

its

> +
> +	/*
> +	 * This device is mostly just used to show a bunch of attributes in a
> +	 * weird place.  In doubt don't add any new users, and most importantly
> +	 * don't use if for any actual refcounting.
> +	 */
> +	struct device	disk_dev;

I agree with Bart that this should be more explicit about the
/sys/class/scsi_disk location. Otherwise it is not clear which device
the comment refers to.

Otherwise OK.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
