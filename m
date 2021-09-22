Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773ADC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62FD76109F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhIVEr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27042 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231782AbhIVErQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:16 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4RIJs028916;
        Wed, 22 Sep 2021 04:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=XCnMd1zzxQMiU5IeunrhuMZwqgYhk7D5zOtrXM/IRc0=;
 b=uefGKe1vSfbCknj/4KF+XUiTfevmcYrsRuHav7YbEY7dKVeut/29bnknPTvfsD178Sgk
 /x1r2ak09RK/tohJYFMPfAR28Otl0NQC6K3AihmSW8Z+qfLxF0zsl2Cb56xDPC2Iu/rs
 X3Vj3p0tD/6m7FjT4gUUl4NRIN4ioiebjat789M6JtyzfN0zBCFSyycqnS4cFf9hbBwu
 /gdGzUc7QpbwV2V0CpFYZ8HKRySpjsqyqrltYuwDoi/ChjlNTWLKJl/Ms/ZYnt4oU5UE
 wV7sgZQ2ddZKmQi/3xscnohLOGvgytTM2f2evpJraHYezksW5EYfuDr6LX2uyNn8yfr4 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4r9dpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4imvJ117636;
        Wed, 22 Sep 2021 04:45:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 3b7q5a3ry1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJw2QobWBsrLM0e/Pkq0EaP3IjzInzS24fD0l+n8sd6gnoEsqNmNoNmgADWdpy5W5iJhBZ0mrAtirSi2wY9HMLk3yZtc25pAaszc60qg1K/CGAytrASxSbk/dIW9rLe78byI/589/pozsIrel5U/iATp+DI1xtxLUk+RtZwqLwSttILKhEYM4Y+9Rd6Z5Bqj+a7tk5M0H6eOAyDSonLlMhuufpp4YGegQ/sfTIL7Qc70dP5LRd2aXTGWzfSKraqfdK4TeTnn0LoB0XZttP4wh3OUBOPhbxXWXKL17crzcQ5/NFw+LOHRkdwJbNehoxrB9dLylxyznt9lMOCJi02aqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XCnMd1zzxQMiU5IeunrhuMZwqgYhk7D5zOtrXM/IRc0=;
 b=DWZEKG6dScfF1EirC/SGiXrizIi/fmWw++EtlD6YpVhImxy3lAxrfguhlgdvBTK1RbIawj/5OmoEr4s7AG115n+Sc7eyYpK4J+rd0XA7CUI+G1GoAiSaZfXlvpZa3JktN1lxoX2UaiWOCqEO5T9CiPy8enhY8NkQas7IZyM96SlqLVEdSFAMKQKCBLS0sX5KkREtNTozw7K0qCXqjfCRy1TtNTtA+oYuaronR1M36yNNJxvESEYuZg+G3g2omQkYdTrYPyuL/bl1dZn/9FZC9Om4YyDpGmEQzh5x30qor1XoUEa6O2H8mgEdyYHHGsNIvRYLJaCUoJv/Xzz2btsL9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCnMd1zzxQMiU5IeunrhuMZwqgYhk7D5zOtrXM/IRc0=;
 b=j2BDhr38U+6TCmiy0x0gVHRAGQFD3qNccDCScNI8FX54FNTZQLcOSKK2KWblc9zyUwnkRNZkBaf3YdCrZLkLm/HEKH9p/UYTW4KKZ1rpXaoumGtFRvoR4YCgJtA39O6haccfcMN0d6qmwpeMPyBazasewNjIfnB2L/ogkMwkcBY=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libsas: co-locate exports with symbols
Date:   Wed, 22 Sep 2021 00:45:19 -0400
Message-Id: <163228527477.25516.12699911650428155781.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1631530296-32358-1-git-send-email-john.garry@huawei.com>
References: <1631530296-32358-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca112087-e123-4031-c035-08d97d83d0dc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44560F2E8B2AD31CF26573B88EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VAAKpy6W3w7etmkAvSvGyGbFqM1PYyaBJG0DUi42GTT3T9Bf5snjR2v2ABeClsAmcboVZuUb/hcF/Uq/xEOPq0gQfJiTbpMfs26YyWlsM78n6JQZks5i3ZTGTQV2FQdjn/BgbAl6KA+oAIR5wIe83plXyn6jidDsX9daINazioz82aXsFi1BWGWhNu8RpxdA+KeAuc/OOOHPC3sQ8aeyt+Coca0n/xBg9KUespZbjOFfvVTZD3K/3kjdK5W2MGrLgnVBUbutNIev+cBdI7tIem9KDiJ2WhsVoMqCVh9kIVq4llJjhl6xR1RZHxdIKAl2VolZ4a0EvSLUOjZDTbKIOwkjdq6Mi1zaufIU+kP4tDr/RfqxuoGj+ZVVwQDN9DEIUTARQMIaQVIq2Usrc5c9d10mDllFrKmFBiz3/286taoodQhaibfqq5om/I+GJPA+GKemPHnUWkh8uSp85CabNFP/RkBcb9Wnh67r7I/YisQ1fblgPHanZqzRV0OeUwxLzuS5bKrrVV1u683DTWAsMlUEwqMSrrsd0noM/GHZ1CPAXXlXwwNBubNlOaF6nua+RWKd0VAHQa3MzB1VbjmjSUaHjoCObFI6ifyWzspFIyi2Aj4vWAVjF60qCl9FgTjuZSv4CxMQ4X2heEUv66Y4p2kHheMkFTc8WchbtU+5R/nRXMdAyJ/GStBvKSs3kWRJUcwFO+Ym618S8ajUlSFn6agu+fNO5e2ptAwOG3X3AaTZKLpWktZO5a5P4Ytm23FfC1cNID2AB4qQKyQRkqM9AYQSXLaaq48Pmb/QSmqEMxw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(36756003)(6916009)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cE1XaGVJbm5DakJTVDRUNkhVOG9pM2FBTnVBZWJQNGlBSzVyeHl1UFBBREFi?=
 =?utf-8?B?VTZONitXTVlhMjhBZVRuNExMY3hBVEFFNFFBYUxsWWZKekpUVXlnVG5OS0Vj?=
 =?utf-8?B?WFJaWlA2ZTZoUk44dGtoWU80b3B0MGU4bklFWFk1Z3Z5QkJpa05aYm5DYzRq?=
 =?utf-8?B?YjJjaUJJejJoNVhJai9IQUlQRGo3M2JTZDJzYTQ4UkdyNElxY1p3KzBOVUg0?=
 =?utf-8?B?dEpSbk1NSmRJSk9hNWxOMExLWHp5TGRUY1RGWnh4amxCeHBkWjh3TWVCcXcr?=
 =?utf-8?B?dTFCRnhaZlFTaDBqSWlFWXJWTkcwcno3eXFLTDNkaFoyUnI3S1dCTEtHWEEx?=
 =?utf-8?B?YUdUN1FJSEVVWVJNNFpYOURiRktEZkVDa1JoRFFNajc2UHArVVYrbGJNa0ZS?=
 =?utf-8?B?Skdja1JqaTh2UjJYN21LQ3NnOHN3eUdoY0tWMm1kYmNVUlhNenhIWTVrQmE1?=
 =?utf-8?B?WEFJeitNLytIYmQvWG5TdlVoWnFZK2lUMlVGUXhSNFFiZmN3aDdzQVpmZnJJ?=
 =?utf-8?B?eW50ZEpNdVBGQ0ZLL3RwUTZaSHFtV0JwQkg0TFpkVlE0Zkg1YUhGMWF2bVR2?=
 =?utf-8?B?SWh6dTQ0QU1SOUozSUVwcUVRaUJuZ1hTUyszZDV5VGFQVkVlTk5taCs2bkN1?=
 =?utf-8?B?eEs1K2Z2ZmZaU0lsUHltcWhKSXd3S3A3N01SZWtsQWFxNkJJejNHcWxCd0xM?=
 =?utf-8?B?bHB1dHZROGdqMUZIT29BQ3JMSWpCdGtqL2xvTU83OUxFdzVHVGJIeGNON1A1?=
 =?utf-8?B?ZmdaMjlLdWFNcUFwcjNDUWFkaE9nK3R6bXFTTldlRU9oQWo5RGplZlBLcld1?=
 =?utf-8?B?cW9oMTdSaXpWOWpRUDY5a0NDeDJCOWdoWU9hZXVIRkJkT01XS2l4cVR4SkJB?=
 =?utf-8?B?cVBlQWRsRlNFai9ZY05MWmxuZWJUeFpJZVVmYVhXUjNkZ1pmdzF0ZG1NdnJz?=
 =?utf-8?B?YXhPK040c2p0ZUg4Z05DUWZpRjNWVFBNUExEZWx5ZzdxTGwvb3FoUDgwT2hV?=
 =?utf-8?B?VWtyOGNWR3NCZmdud0N3YzVaWEQyNVpJeVJ6ZFN4YU5vWTFUUzFhL252Z2Uv?=
 =?utf-8?B?azFuaEVHU2ZDZStzVW9wS05HaWlGQTdpUkw5WnhKejkyTHQ5bFJLN2hodUxa?=
 =?utf-8?B?T1A0NTRlNDY2bzhtRWRHTVExelV0ZE5ncFZMc1ZQcE8zUFlWbVUyWEYvU0Fm?=
 =?utf-8?B?bFhyVWZzYnJoalZJa3lBM2F4Z08wbFB5MmI4emlCTnVFOWQrMnlYNmdnbVMv?=
 =?utf-8?B?dHJ5L1E0UEdJR2t3bmNnU1VVbnB0MGxITWQ5Y1M2UStKbGpMZk9JcjNMcDJy?=
 =?utf-8?B?LzBjeVowOTl1eUJlZVorUjNBM01EeFdnS0tBOEtiemZGUHc2eU9ac2tJY1Za?=
 =?utf-8?B?RWU1ckIxYWxNS24wdEYrZUdDVytzOHVpWXE0WlB4R0VLRW1wUGJmL3JOaEVw?=
 =?utf-8?B?NERscldFRVNuYzZzUUZ2Rkp6RzVVdFlpTVdNZVR0VEw5a04ybkZhOS9PVzNm?=
 =?utf-8?B?OVJ4YTVyZWtEZHl3UnlNb2FqNWJ6VWhKYUw4TkEvMk1DNkVReUs2cUZEUDZq?=
 =?utf-8?B?M2ljZTBGVFRmeThwRlZVTHJib2ZxbFEvYzFwM3N2amdBR1hvSDg3Qy82aVpT?=
 =?utf-8?B?SlppOFJqbVlhWEE5TDlUcHJ0anU2Rzd5Y0FreGRxWWFpMmxuSGgzV1BTNnVw?=
 =?utf-8?B?QzB1RitOM0d5VlU1ZGU4Z0RCeWtlV2NBbjlOTnpadGxwRCtwNlZHbElvd0lI?=
 =?utf-8?Q?YcI/ko78CDcVh/OOQsg5/rtbeVkjewhgkjKG2+5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca112087-e123-4031-c035-08d97d83d0dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:34.9584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHwli5npjJaUl8HY2lnHE1Muj7xuaxWdZYaD7n7UKOu3N8K8VzCYiY1xdB2TuTtDv1PYIG4lvBzqQomWUifUd1eR/+7Dk3Hdkgs+K1SVBnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: PF21nXmcFYxSeS7fn2SsD4HXMCXyif33
X-Proofpoint-ORIG-GUID: PF21nXmcFYxSeS7fn2SsD4HXMCXyif33
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Sep 2021 18:51:36 +0800, John Garry wrote:

> It is standard practice to co-locate export declarations with the symbol
> which is being exported. Or at least in the same file - see
> sas_phy_reset().
> 
> Modify libsas to follow this practice consistently.
> 
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: libsas: co-locate exports with symbols
      https://git.kernel.org/mkp/scsi/c/ce4fc333e599

-- 
Martin K. Petersen	Oracle Linux Engineering
