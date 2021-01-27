Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7C9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0AE82070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhA0Fh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:37:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36160 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238696AbhA0Ez2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:55:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4jANH092678;
        Wed, 27 Jan 2021 04:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8CG6nYSHXsaH0d7M6nkRd2u5i3C2x2Ber76EYEJP430=;
 b=I9ziGjjxp76pnDCMFcpl8yvKeMI+zhCtx+PQzI7cVVTHjDgAPzuxCCKzeg538Gy3SJOa
 v16xIA6zzqtlEsJSKbZr/Y7XVqnWOLJi+oT8mBQnyYjUfziWGqBghzCoYlSDcMkblilJ
 8GILcXUEHUyA5kAl0yLwB/UditzRHtg8Ajqv0pdB6T1lhkNaRoQD8/kCLQ+tz9I6xj+n
 spzaCLbCd0DySaVvcON8SBhRcK3Avh/FIvuNIKRLDEqlf6G+obn34Njz4GNysViDeEkE
 9MeomNwPImBSLFJOvK8jAFZIvwXEmRjxpVeFVK2lF1ypov8veksr375a9JvXoNZc311+ 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3689aanbax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4newh014991;
        Wed, 27 Jan 2021 04:54:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 368wjs2ayr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNJkVNjBsPXHzBPerdgCNSEAhceptTsuAaOKai28aM+SaibPm3SNVvlJvIk7aZvi9hqhkoj3FKOtMyd4uGFzvOVofSt0nxAunkv4LF7SiYO8dXEmcVuKs6MyTPcE0eOJWciE+hIdMRvBpYA8kxcV7Mfl7mjhOt+V7MC+Y0V6ovFlDovax6o48zgSZ7WB4nR7ZErr2wGdHEHMhq4nQhtSMo764+3g1+DYjnmXe5egW/t7BkPZ4nm4yffZpcPNB+l7d8GNCop1BL9SWRigFBikmWq55tvguWx2MjAU0z0nxJcyygA0AGvsHhUoMH5ZDhgIlknOq0mzFdSenuSAyZJIYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CG6nYSHXsaH0d7M6nkRd2u5i3C2x2Ber76EYEJP430=;
 b=YhDVe78nQJ2lyxMm+mP8nkJrjcdeJ8PsTTBDq5stXyuwsb2mXabWcCcPNlBt+qjAAbSQql8hToDaIuJ94wcXFMltbB/24+whMWH2jvl8GLGqrD1vF8RbIyvcwA/pG/PCtlvpk0FtJu2WCezXf+d3r4AVyYza3c0G2+xsYBTNJTNMM+RR8kTYuLwyD/B/N8zPVnG105DgaY0Wc32zSPhKZ7Fuepz3EbmVgWnJR0yLYUDa3CK7qlk7nwqk0YnQazcneUaPu70Ev/jsrUUjqnUncu3DbfuROngG0VtewermqPfz+qJtrTIDlK2cAJWNRy5r/6MZo8FLjYrhTaFeJzsLpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CG6nYSHXsaH0d7M6nkRd2u5i3C2x2Ber76EYEJP430=;
 b=sTBsscGQJeMQuS/aG/EbFDKCB8D576I3E0G0L3+FWfopjAye2XI+g2oEfz29aSpnqFE9snrCqjsABDr4CKw0m4hKRUTsQieLCrQ/Oiqdz2b6sQRbgAeKtGzofStQOQ2W4dZSKCfJlAi+igw9Z2PfgkEqJUX02HnBSKCAXCKvo3E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: remove unnecessary NULL check
Date:   Tue, 26 Jan 2021 23:54:22 -0500
Message-Id: <161172309263.28139.7036192153186894654.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <YAkaaSrhn1mFqyHy@mwanda>
References: <YAkaaSrhn1mFqyHy@mwanda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee779f0a-22a0-485e-3c55-08d8c27fa811
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB458456C10B3530E3C4A66B0C8EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: winiKLfPr/9ZNH8rADabB4bQVUbBXaPwUg/WUV31jwdI9GLlEuqRSAG6N6zr41YlukdHxjDMz24fndFWHySgFHrZb1EcfuOYFd8SGjkE6I7Hbtyp4kPzZCmccoilUqZcuqAzpVyXqr1J4Sr/wYlz4S208AkbzQGtuB4p93cgytA7RKesQNceAp8qfFixCmS4IXExMc1lWNyPMBv4KXJxobmXXBu6Ttq6KMNRV3HqA41wu5koR9BzDG1f3dfEDk3Amen6XxtOFEZDZ8jVfETWMDv14388rVdtyU3V9+NJqdmfXUqHkzQRMFrNcHh9ycI+vf9DDYl5kDUGia44hU4MxCM7npVdDjcdoZchnep8Dv4yjgkGZuI3jzwM9qtA9Jb/NrDmlc+PCNhGapomL/PIDUo+g6IbAx/ienv5Y7DEh/sG7DD4qA9EiBIkF9Ouf/OnnWbtjWwQtMUA4KhdIMPLyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(4744005)(26005)(86362001)(186003)(36756003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(110136005)(4326008)(66556008)(54906003)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Rm9KbE1KTkNNNmVDWHpxaUp4WkNydy8veU9yVU5vSUZTWVFPcWcrb3JFNU5t?=
 =?utf-8?B?NTR5cUsxVEpIS0Z2R1E5WWFuME5hdGRYWnRIRUtqeVYrSmJ3ZURzekQ4eWFU?=
 =?utf-8?B?TUdOVno0bWJMdjZyWjduQlZTV1JtQnJ2VlRyUnBSN1R0WGhWaHBjZEozYUxH?=
 =?utf-8?B?bkN2L2pOeU1iNnhmM3dKQ2RYRjk2eUQ0cklSbStJSDdqZ3Y1RVQ2elhQOEND?=
 =?utf-8?B?UExXSGFBWGRyWjY2TFlYN1lXb3hrclJtc0oyTnArVUNscjhLeTg4QVJZY2do?=
 =?utf-8?B?Vko1TmNGWHhheVlzKzJSemtRamc2NVJuamZnV1hMeTdCV1IyQy9mc1lWSktD?=
 =?utf-8?B?dVEvNlNOd1JXNlE0MnluaENDS1JHclJHcDE1OERlbGUyc21DeW80dU1XZFgw?=
 =?utf-8?B?V0hMdHczZHdQY2NSRElLZkd6cGNUY1ZtV2J0YVhpZGVtZ1JpQnc1VWlkODhG?=
 =?utf-8?B?dnVIa0N5R0dLeGtTOXBHSXZBQ0UyOXZsN0F0LzdNaFFtSTJYSXk3UFJwQ2RM?=
 =?utf-8?B?dm5UY2tkbWtsTXdOaWlwQkhhM2Z1WEdmbk1oZVQrMktSZ0VBNWtOTVNjN1lL?=
 =?utf-8?B?UG1GNWY5TFhyK2srUzM2M0J3YW1jbXFHZGtFR1BlcGNyMjh3WEJzY3Z0ck0w?=
 =?utf-8?B?bHJnT2pDWVBlVHJIWXZuK0F1OVNzUlZRMHVzWlFsQkN3eldVSXZLR0Y3bjZy?=
 =?utf-8?B?WjJSQzl5dEhuMHM5TXZZempuWlJmYUNGWjlLTUtOamNhR3hHdzJvQ0JyRFJ1?=
 =?utf-8?B?TTdBdmNxMFJzWUJqY09wOUhqVk1aT1VHdzNuRHZ4c3BIaG1haDExa3BJdmZI?=
 =?utf-8?B?aE1id3ZmbGZjVnFYcXFPVmtub2xLR1IydEtJSkRRZkRsSW4yRkpQRmJNdVhL?=
 =?utf-8?B?MTg4aDMxYnh2WVcrSExmMzNUaUo2clhNSzhYNmNMMHlQMWdXNGhpaHRNTXVm?=
 =?utf-8?B?b3prbDh2RVZSbzVyTWRpb0UvTlNiNnlJMkExVWtSbTdaUGp5bXZKWHlXckxx?=
 =?utf-8?B?QWZ2NXlRVGpuUjVlS3BtTDN4WjV4UnZ0V05pemxRZ2NWejZkWFc4UHdWd1Jj?=
 =?utf-8?B?NDFhVGMrV1Y4YjB1SVhlQktNWkZ4R09aeGFqQ2dSM3JCRFgwbXlLeWZCZmRv?=
 =?utf-8?B?QXI0VlA0SjFySFdrbVBlQmp4UHRiamhPSmJFcGFJbzNZaVVYZGZUT3ZIYVlZ?=
 =?utf-8?B?Sk96M3BEZG1UZ2VGZnhkdzI2RFI0NUk0ckNFRkZYWDdRTUtjZjR2Y1p3eUlx?=
 =?utf-8?B?TkNjNjlJL3dLbWYzeGN5eVM4eFluQ0QvZnRrNDRhUnphTzAyZzdBT3gydDNS?=
 =?utf-8?B?eUFwbG1YMTBFTWNmYkhEOU9rSHRJK3VHUXZMZkdLYk9jRlJuNFdETFVwL2V0?=
 =?utf-8?B?QXErVmpjcGZFOFU3VEhlM1RlcklxZmtTaXcyVlhYOUlVeUt1dnVLUVcxeDIy?=
 =?utf-8?Q?AvZRVK6t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee779f0a-22a0-485e-3c55-08d8c27fa811
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:41.1810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZrzOybuVZvf+RHQJ6dDNyHKjxGR69dmRmfJc5oWlOBcoKZpcpWsP+ZmJbaf6PbMS5CrE6jD17AYVio1+h0uqVsc7yH0wjhmD6hspVGSH5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 Jan 2021 09:08:41 +0300, Dan Carpenter wrote:

> The list iterator can't be NULL so this check is not required.  Removing
> the check silences a Smatch warning about inconsistent NULL checking.
> 
>     drivers/scsi/qla2xxx/qla_dfs.c:371 qla_dfs_tgt_counters_show()
>     error: we previously assumed 'fcport' could be null (see line 372)

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: qla2xxx: remove unnecessary NULL check
      https://git.kernel.org/mkp/scsi/c/c750a9c9c59a

-- 
Martin K. Petersen	Oracle Linux Engineering
