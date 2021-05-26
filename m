Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465EAC47082
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21D4A61090
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhEZEKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:10:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40314 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhEZEJs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q3xW0R141815;
        Wed, 26 May 2021 04:07:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sorR8ulAbYAsB7pW3p71TPPzaONQMVwx/W+sAan0HUw=;
 b=TLRqVqXOkCmljUjnJeLviKlzb3NjY37+IaTYeYVuBFZ2vsQo3O2oasI6qBcoPUlGTSuF
 t70r7ZseJbClivPO3/Nh4WiKr07QGMFPo42wZE0X/7tc0fmnjPhHMq14g2Iy4Gg6qPe0
 rkOgXQEmAyFdTmANbVfNLJShVQZ3Yt+vv2uDwZu2mr85N3nNLELHxSMyThipuBDA0h5N
 xO3uiy7VH5Bwt+87R85UPEYz4rUrPCp5VL0ygY3rwcdPLZOL01Uh7W6iz5l/+cHuyphx
 MKuwst0vyAbpNzYtPxbAzC0AdaEdYM1RhwDGApJeYFpHNPh7b6XeLla/QvHL9UquQnFO Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp7pyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q44tGQ175510;
        Wed, 26 May 2021 04:07:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 38rehbs0ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciMXkcflsorlJDK44LZlEjiOQBdtV3WstBUvFHceGFaFeWSjt7bs9O0XKYWNQbvbv+eycavyOX7ZBmyLsWAAgnzKdFfO9+HMoiptvzqQzHMRvEqNx+i3xU/DLzzV87O9JwbGxSGxeGuzFI62lNWNqnzkxTwqXWeYyv2YdBqbikagTjzbJZo0xd51tq7vfRC7hqj+jbmLQb5vDa6JJbGgQBzEy5U/7bIHNQVUgidlpO4GqAWjKlq+RUErnDEzhwUXIY0frP3rCOFcN8uEGDSyN/1ffBfGFkGfOtVDHw46ryKW8ZvkTcoW0QA9K10VMwhVDruqdbyQ96g1t+4MnVaKyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sorR8ulAbYAsB7pW3p71TPPzaONQMVwx/W+sAan0HUw=;
 b=XplgGGUdvAYkkLO19Gq0E4/akszZ5oEBl26JKd37pACAC2JBG8L5UxcGz7NAI3JWfsBH/3q0tO6qcMvI+Q6XL09PK5XQp0aP65KD3HTIZu4GQjO16dwZR4166TNb9Jmftnu7KvlEFfByur+mvsY7zocob2msfQnJMKUin9Nj6/zGbz1Dp6NjYLPDvUvm+utUKoOTpNAB9la8DSue9dhv+QRhMBSheLDQxzYOkuFQC+wbQTWlBQBG7Gjh0O62dciJi4POCdD7EnShTXvLSEIBrDlwWnLqtqtGmzGQD4D0RHioCPEZnhw2j9piXQZXTnX9JzBkVl5RsPnTKBtjX1PEOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sorR8ulAbYAsB7pW3p71TPPzaONQMVwx/W+sAan0HUw=;
 b=mMXhwGfMJg70ErpTnIZTUMMA/PXbYGxzqY23TCIlVE1K8Z2Hk1BZ5ibgP9VcdXAhPDcU+LIlLIwNN0aLjyZBoRAucNYzPs5KWQLK9QioddIo1S7PL0N2fQdzQ+kWZIs4Jns6muQqgw5E52xFvkaXocU+zujp9Ct++fali+25N2w=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Lee Duncan <lduncan@suse.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>,
        Chris Leech <cleech@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        open-iscsi <open-iscsi@googlegroups.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: Fix spelling mistakes in header files
Date:   Wed, 26 May 2021 00:07:31 -0400
Message-Id: <162200196243.11962.5629932935575912565.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517095945.7363-1-thunder.leizhen@huawei.com>
References: <20210517095945.7363-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ba9203d-48ee-4e0f-e277-08d91ffbd609
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4469B4992C2FFAD188AD3E578E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0JYPb1Hw9JroKOpfl0HnppuDIohMUIpSF8ZZ5c9Bc1Ehh3s0nD+uEvR+hPPT2D2X6h7wqS8pVU6gFhqzlAgN5iL6q4HGIu+AA+3jPe5X4wYELljZhwj9ClTvhF5Hvs4wULbbplfo4E88pbDiXYQf6GdxhZhM14QfdsAYrAlCLoG27hWs70KvhYXr4bmyyocugDxLqZuiUYpwXtLitrVHefYmhLN+su/j5zKIFnubZN16v/P5UNiYD5UoaiHOTKetF+KIpbvCSsvQT5Ufc6dOIYOdJ/Ev9hh5+y0K6S9o7/UictLR8dm+nFnjcyWWa7/BgX2zv+tChSC57LfKVxSlEIpAYsq3jaJRX8MzNgwONZq1BrJE5Yd5CkN8eTRDArOYdjO61d4tnVpc2zZu0iP0Qe2f+rSzv/IDTrGKXjRbf1MTMk+QwnPs/YvU5chdsVXgz18y+bFdVbSEhZN4MH7TIPxNDOD2/nl3BxNnnVxVxOUsvxiCONoCBHu7CrY4enHJn12Qbqqwe94qvqweO/cLvaRrIlXUHmn6zZpZ4+UmmZB2nD8bQ5RZgEtX+sNsKbceblW1WHfZ88KrMQeZoKgO2zDFdrzQRNUp9cfoYnLypmlrTjGmOkUBzwoBvqYulNS6WTYJdWbonI0krdGk1JQ3B0rmPDb8qbHMK1EvrA0++RUomg3rJY/JO4M9N2ABqrfDOPfXWDPzYn+IIdAvMTCLL9NJBrQ5ieulpRp5eJ2J9uslsBGFlpqAE2vkRXi6SYwcBsifkd3HwRJ8pshvWKj0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(110136005)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(478600001)(966005)(36756003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QUFSeHIxYzl3OCt2SDJaREVyK3hEOXRPNHhGRWZ1bzF0R3FwY05iMUxBZC9h?=
 =?utf-8?B?YkJTVVV3MithVDJIQkdudzUxNC91bE9QVHg3QnRaaEVvSHNUZ0ZacHBIZjhN?=
 =?utf-8?B?VkVQbzdrbnYyYndacUJJb1VZQWtMNzkxQ09oeVdzUERQRkdyWG5yQUhSNjEx?=
 =?utf-8?B?TzR0TkkzNG9CTWJ1aEZnRHZ6L0pjVERPTzAzVlpRanUwaHRYcUtoQ1dNVS9a?=
 =?utf-8?B?YStobklrdkpYZU9ET3doR21pK0ZWR2JwenR6MkZJL2wvRkN5QWU1Y0s4c0Jq?=
 =?utf-8?B?QUdFMFJpSFJMS3dKVFVUbDFyemFvZmN3dnZiNVdoYnNvSHp5TTZITVpBUFBP?=
 =?utf-8?B?M1o5MDdSN1FFZmh1WERUVTM3WGlFbUhDb1BZbGRadzBvekZGaU5ucmdDUnFt?=
 =?utf-8?B?ZEpsWDIreHExWjlOV1BTdW11UGN0QUE1a3psWWJpZFZpak8yODBzb0hmL2Rq?=
 =?utf-8?B?V043Sk9Bc2VvVVphaXhmUkJCdllYUUs3ZWtUaE5adHY0ZEFyejNURVF6Vzdt?=
 =?utf-8?B?R0IyeG90WndZcjRMZkFoK0YrK2lLZ2tOZ3BsNGhEZkNyd2VDY2tsRGRZSU5q?=
 =?utf-8?B?SVhQTGlUQUcrTXlZaFMvUWMvTm9Ya3VkdHdEMFdFV3c4cE5JZ05TempWZStD?=
 =?utf-8?B?MlBiZ0FRQkpTN2JVaFVVY2Z6U205d0JrdnNzakl4UXhyZlhPZ3lvMVBnb3V2?=
 =?utf-8?B?ME41RjRscUNDMFVxZllRaWdSZjQ1WjVsK0RNbnhkSHNqcUFrWmVySzJpZGw3?=
 =?utf-8?B?QWxGV0cvb1RWQ3JkaEJZMjJHZFlhWVFSeDUxdlBZWThhVXIzOE83M0VuWGI4?=
 =?utf-8?B?WExkdFBuMzIvWjNhMVd6L1FaV2pueHhFUXF5eHR4NHF3U3FjMUNUbXBYVDVU?=
 =?utf-8?B?ZzczcVBSdGpkbUdHS0VJZWovbk5ObVkzOXZpT0ZXZktnL0ZrSlg0YTA2b01a?=
 =?utf-8?B?dzJKcDdOc2tzSHR2WExtVVNRU2FFZ0d4dVVabUpHSzNPcHJKeWJwRlQrTlh4?=
 =?utf-8?B?cXFuUk90N29UWFZ2NDNMT2RNYVg1c1VZdk9HQzg3TytJL2pEbHZuVkVJUnRI?=
 =?utf-8?B?NVU0VWV0ME9iVGhpN2FvbHMrdHhpRUcvS3U1aDNRWm1LVkZFOFhBcVpEZk5u?=
 =?utf-8?B?c3VnSjJqVndaeHNybDhBa05INy9ETkdnWUE2dTZyR0dpME9JSndKRGtQaGNK?=
 =?utf-8?B?T1J1TXJGeXFvR1JIMnp3RzlmWmVUQ09lUTNLYXR0RGNvOE1FM3lXZjBNMmQ0?=
 =?utf-8?B?a3pZOTE3Y1ZQb21iQjEzYnFYRVM2bTFHQTdWdTFGb3dVOHFaZ0ZPM0tpQnZQ?=
 =?utf-8?B?U2k2TXhlTXk3R0Q4RHVGK1czbWdmZzhpN1ZDbjY1RWJSUUl4WmpGY1dGVWZh?=
 =?utf-8?B?TlBleE1VdXlpUG1FUkZaTDBNa0szdUU1ekFDTll1MytsTnFNVFBnWGMzSUR4?=
 =?utf-8?B?cVJKRmFxZTRVOU1pT0RRZUh4RjV3TWlKVnJLRzhTWVFsV2ZtNWRzODFPUDhM?=
 =?utf-8?B?bWNKVFJCd1BrUkdYWVlRYjNaUFkrcUVWTmoyVUJoczI1QStMSEhLRk5qQ21s?=
 =?utf-8?B?RVVZTXJRUjZuNXBKb1NocndqVzQydS9vYlhtVmJYSUQxQVBrUHBqclhmc2t4?=
 =?utf-8?B?WllLN1FVRnFXSG1WR2pUZGpUanpwOU56Rlc2dW9rOXZuZS9VWmo3MXEycm9S?=
 =?utf-8?B?aHMxTWl2SzRBRk5ac0UvMytJODMxWmNIcjlaRXZQbUJKWlVTMEhONkZnK0dn?=
 =?utf-8?Q?4o/Qn0New6Fj5X+z9L9jo2oNYF2SanENu7LhnhU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba9203d-48ee-4e0f-e277-08d91ffbd609
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:53.9931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hJrSvgX1T8b/e05FQAhG/ZWOUgIbsLRUA/0vk5PGPbHMI5mM1kJbW6vCntGfqIhan2hqsinxdSN27hGkr184LB5UJW4SpXG/38gMeJijlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=898 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-GUID: mJV3TF1vj9YZIxdsnge9_TLZmdEa9xUR
X-Proofpoint-ORIG-GUID: mJV3TF1vj9YZIxdsnge9_TLZmdEa9xUR
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 17 May 2021 17:59:45 +0800, Zhen Lei wrote:

> Fix some spelling mistakes in comments:
> pathes ==> paths
> Resouce ==> Resource
> retreived ==> retrieved
> keep-alives ==> keep-alive
> recevied ==> received
> busses ==> buses
> interruped ==> interrupted

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: Fix spelling mistakes in header files
      https://git.kernel.org/mkp/scsi/c/40d6b939e4df

-- 
Martin K. Petersen	Oracle Linux Engineering
