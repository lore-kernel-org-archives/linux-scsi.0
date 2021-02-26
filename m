Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C8FC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C2364ECE
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhBZCXU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:23:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53014 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhBZCXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 21:23:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2K4pI151375;
        Fri, 26 Feb 2021 02:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AdU7KK2wGdsaGWgnnMNl/xYiPjoHMej6VfRDRxQrBws=;
 b=N4pQ/3jX6VwCErDGN4KOHcJ/Yk0RnltMmkRZBgUbqkCW+OHXb8E/aeWFkQpQDvF2NECS
 kn1abRxuC+LpcztXlekeHIJybGZsYDBJU1XF/9Ua6ipOZH/2EF8adkh7QZ3O8PQ3pJQT
 xik4NGw61XkKqJgJ9xz29J5DgE/2Q16MakjbDPNuTR+uy0IL8ZYxNSjPNSsUb6EDNCpX
 hoz5GNAKAqTDuoywAgvZfdsaPusXADTP7YWOWxXhB8XabLGfq5Id/kFuL130HLeMS1Ta
 Y8hpiPdQuPcshwnUOHcSEibJ115a9PhPTe/3H2YZGbStD/q3laaZ6rnDYOtuS3mhrCMw eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36xqkf81h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2KGTP073027;
        Fri, 26 Feb 2021 02:22:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 36uc6va4jj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iR8ohaRZkNvZv6bt8JxVZarIGBDLxztAGNBDA3T/LQA+D11YoVVH1XhlfO+3KOiGkMonLQUO8ibsnLW+xb/jswhqXPKCXkmFC38aSpKii9RrNR4Q4gxDybu3UHKpeontfLOppttGItB0xmpoEb+SEFoTH6nk60/2+AXjo/WCf6zBKlr2taXp1qoSoR01w6SFT2EVdFrYBZj687lBUXXEGlD3YUYcGj6ObgW4ZehEWjiXa8qtxVKpF3jCLPU08SlrCniCyQhMLETnOHsdZ0mhZh3IvokkRgudbv1kVxoiYlRSgObnfpO5Hq7IKXnTioK87TzHGinEh8S3iqtSeDl6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdU7KK2wGdsaGWgnnMNl/xYiPjoHMej6VfRDRxQrBws=;
 b=JXHNB4qU54ezVR78qHbKaYNXtEYjNZFlGsf152Fs9aMkFa8fth7ylGD+D8VJ0L3QoQd+qV0wS8YLaEUkoPt+f4VLWe7gdjMAUMpuI1WyvYiTxPHH81M0DX4Fl4+WadsKe0cD+YgnVd+15OD9+7BaReJaEOXfndDlgiW2w7GwcYdFuu+LhpEhZ5/xaKZlB5JCjHIcwBpl6l6fdFaed3CNLaChhkw/wPN+DFzMrUXY7lN653kS7A6boUH2YySy/HtqdbM4IeYIsdnJcgY9xlxrntXu3f3MbWsUtVzI6zPLCpfvKhzUetiw+7xjl++q16fRj4zjbDidceFFcCL9WJ2/Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdU7KK2wGdsaGWgnnMNl/xYiPjoHMej6VfRDRxQrBws=;
 b=nvtuOQzcdeurMK4WaQuJRE4mw8ZWUVyvVdlEmR8whyWa3vWcIuL7BkS6AmB8xwuEn4DswAzy1lz1/7tL6mNvhijA7nitnjKJD14adKsrrjV/16irAooWFmBOrkMrdi7jdhAQ2BzRVUsc89du9Ck53+uG+lJIGL6T7vEdKrzAAwo=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 02:22:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 02:22:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] sd: sd_zbc: don't pass GFP_NOIO to kvcalloc
Date:   Thu, 25 Feb 2021 21:22:10 -0500
Message-Id: <161430583251.29974.7141365255972126309.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <5a6345e2989fd06c049ac4e4627f6acb492c15b8.1613569821.git.johannes.thumshirn@wdc.com>
References: <5a6345e2989fd06c049ac4e4627f6acb492c15b8.1613569821.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:22:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ac27a65-4315-4707-ac99-08d8d9fd5bac
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4696ED542CEAE4F3F5F6E04E8E9D9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S1sbZXnFgjOWQK5EnvVkdmULWh0mAmTQbfNsl43gdlOix6Ww4zCg9LbVnVjrM4OHwAIW5TFUsUWwADXR6CCYLf3biotv5+gUmDo1hLzPkeK8T/zzxYL4ZjQBxfzpl33RRvhcz+ecjpFyCCW1C2Rp4+nN/gPP+0WcFBVd2st3/uvCam/ycgp6oTai5LsewCYfDJFrgynup48ZUPxcWzo9QqFvxO1JNQ4zydJ3EvetJUSCudewVc7hmx6JyP2M07P9GtzEkYA8Q7HxDBUOTysUzw4IBzRA9IBRssoJBD6H7hsNyOEqht4TdB3Cee6+uwzvm6CpxGH32C5ZSj4SuM8YLx5QiUiW1qsfx4SA4bgOSflzdn9pze26nUj26cijwnQ8E2aEqM5C+loL5GnXv/8FM+2e3aFEbuWevYE0GUwrr9xHk6GRMp/fWM1GJNjw+/AYQfswoZ1BadSb7APqtKKKtQ+3Rzh1lB+FY3lcpzsN1grN+gcHkHJHV41fl4xHovab2UhL753guBQHHBQnnmcP6Fa2jHqA1Dra+IXQb94A1MhnJElCMiqHm6nZrHmiGMZg/C6Stok7/vGesDrYQyLpgz4Zww2ai9KfNF/g6cpq89E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(36756003)(4744005)(8676002)(2906002)(7696005)(52116002)(2616005)(956004)(966005)(103116003)(6916009)(8936002)(478600001)(26005)(316002)(6666004)(5660300002)(66556008)(66476007)(66946007)(107886003)(54906003)(4326008)(86362001)(186003)(16526019)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R1RHT0EybXVlRERoZGJHdHFuY1RQa1JnTFJvQUtjaWxXN0tpdXRQYWMwWE10?=
 =?utf-8?B?MDR5bmNlWWoyRThOZWszZE5sZklqWWZVajJQaVVLNmlYTmhMZHBLNHZ3WDBj?=
 =?utf-8?B?TlVleFl5Q0pQSUtJWWJuRVVISStJdnRQUHFSUU0yVU10VGpLTzRiellidWRY?=
 =?utf-8?B?SThnTzBzSUlzM2Rmb0VrS2h4UU9CUmtQWFhmdHhkZGJKeEJPbCs4ZHR0VEda?=
 =?utf-8?B?NEg2dWJZNkQvWDR0VVdzclZqQ0hucHZxUUpLMWljbkZHYXI1ZzIxVUZRaHVX?=
 =?utf-8?B?azlvTEs0WVZBKzNxRmJ1b1NwTE1QdTdLZW9pcjF2VG82Ujl6bGVrd3pOelNC?=
 =?utf-8?B?UXFyaE1OdGt0ZUNDbk1BcUlRd1BCMTBXbTgwbVBYQmlYcER0S2lYT2ZvY2hp?=
 =?utf-8?B?MjhTSC8vemlDVnAxU3VESU02MTVrVlE2UHQ1Z3I3ZWl3K0swejhQSi9vaEpk?=
 =?utf-8?B?L1VKcEp4eDMwdU1tcXhrYWkrdTUvWDY1QmRjLzE4TnhHNGlGN09tTDNJakt2?=
 =?utf-8?B?VkU2cDlNNlVaYkZrRW9hNTRWYXRycG1KVWtleTExRXhQR3JoQnU1MW9yc0xy?=
 =?utf-8?B?M2szdjRhTllJb0FCSGw2dndWajczTGRZd2JFQUVlNmxSdFZLTjJ6c3drN1Fj?=
 =?utf-8?B?ZmNMSjBaUjcyTWpFRVFreWl1aUdBSXkyMVFDMFZ6VmxTR0JuWGdEVjdTVWxN?=
 =?utf-8?B?RFVQalB0MlRoTi9ibG5Ibks0cnYzb1RMNWVLSHQrREcyMkFLK1ZYY21Ob2Vk?=
 =?utf-8?B?M2JVRERpOWJMdUVYZkxDMzV6N0Q3Mk1lZGRJeWlzTFVkS044UUd4MTNwRVQ3?=
 =?utf-8?B?bkd5QzdZUmJjLy84RzZrU3l1d2V5TU5KemplNFRSa3RWREVSTTVGQXdVTzNO?=
 =?utf-8?B?N01nMVFwSU9pWXN1K2VhRG96b3VZd3RoVHlZbVhVemQzWkYwUi9FRlFxbEV4?=
 =?utf-8?B?dG9lSTNZanROSkRjeE84UXZHSkViWnQyaDMxZ2VPb2s2OVozMTRSOURBVStB?=
 =?utf-8?B?c1U4NEtSeGlRSVdvZHU3bUNjdEZ2SEdZMXpIdWNvTnkwRkYvamFlN3lrWmI5?=
 =?utf-8?B?M0dyaE14ZWZCejRndlpSc24yRVRyTGVwZmU0TW9SeXJHUkQxamxxYWJNYUky?=
 =?utf-8?B?T1A3YnNCeHIydFNrRmJDNXpmSFRVME12MXpjZTRoc0dGanNNMDNtNVkwN205?=
 =?utf-8?B?MzA0ajJ1dTVrMU50Ti9iL1RERkJKWTcrNGZiQ2lYOWE1L1plMlhoNjZRUGI0?=
 =?utf-8?B?VnZqMXNDWDVaY3Bsamd4R01oL1dyVGZjSlo3MDBqcTFJZE15QW5MM3lrcEo5?=
 =?utf-8?B?ejNNdEFqUjQwS1AxcjJzcXNLVENDYjQ0c0tuRzRUSlF0RlVTZlM5ZjIraUJF?=
 =?utf-8?B?YStPYkFzem5EVHRGbjcyWDE3djBEeFI4Vkc4Vjl6R25XWklxQWhUM2xvRUdS?=
 =?utf-8?B?THNFc3plUjViYXhvTW8zZ2JZdXMxRGNBQzh4MjFLYkJHNFpZcnVIa2ZoZ3p6?=
 =?utf-8?B?R3ZpL3ErMGRYMUFsOExablVEVGoyVkNRTHpGYS9vN2FVK2xtcGdyMXdDcmVX?=
 =?utf-8?B?TXRKTGFsWDBZNFc4T2wyWUhDaXNyWlpDR1NvZnBRbUY2V08wQ1RpOWVtWWUv?=
 =?utf-8?B?V0ExcWpzV1lDeEtVWWYwOTliVStyeDZmL0dyMEhpNHROVUVwZGx5VmtZanQr?=
 =?utf-8?B?R1kyelRPZG1iV2JMaHNFNWVVaHEzRGE5UEZXR1Rwd0tkMEZrSjBsSDMvTEZE?=
 =?utf-8?Q?a6exF3TmV+tumT90l7ui1CRlB+PazR8YxoQo4FW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac27a65-4315-4707-ac99-08d8d9fd5bac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:22:26.3012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rBgcWe3EUaa4VZMT+wrbiu1fCw7KW7xpEgOK1h/pk0J+iAgJ0TGz7F+/oKOr4bRLegJhM79quVg8N6SLpnbsOfkU7HpTC9uFfSd1LDf7kac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=812 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=994 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Feb 2021 22:52:45 +0900, Johannes Thumshirn wrote:

> Dan reported we're passing in GFP_NOIO to kvmalloc() which will then
> fallback to doing kmalloc() instead of an optional vmalloc() if the size
> exceeds kmalloc()s limits. This will break with drives that have zone
> numbers exceeding PAGE_SIZE/sizeof(u32).
> 
> Instead of passing in GFP_NOIO, enter an implicit GFP_NOIO allocation
> scope.

Applied to 5.12/scsi-queue, thanks!

[1/1] sd: sd_zbc: don't pass GFP_NOIO to kvcalloc
      https://git.kernel.org/mkp/scsi/c/9acced3f58ad

-- 
Martin K. Petersen	Oracle Linux Engineering
