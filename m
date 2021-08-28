Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7DBC432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5AA860F44
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhH1Cd3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2996 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233170AbhH1CdZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:25 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17S1VUts013473;
        Sat, 28 Aug 2021 02:32:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=wEAuN2fzpvHhmmdpEn05B/EPJdgcck3Xzp/Nw7rnE1Y=;
 b=u8igoIG5LrUU6KU102zDd4yiFB7AKP/WXUuijeLPK8Up/EsiFPOgy81cHBXrdItE3l8y
 vyu+nbm5pvsqwgWEISgp7XfO3wTiWGMRxEhlDPg4qR6nNooneWdoM6w++gnpiHJZkuLn
 1D8tr6nEgvosF1vsMfC+ufOTGF3RFbcAsjIFgZp/e4TWiXHlTQWLaHaGiXsAvm+aZ1tR
 pblhV9k6lbhMGbJvKuoynFsForCxeSg11UPLAPyULYUdlV7gaHP268gY1tmuNP5wGS1F
 0MAQz4KOtLaxo0LVYllXZmr9KsYX6FC+Lnf+4otJr1mLInzpKWLV7ti3YlYV4V/4hZyy NA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wEAuN2fzpvHhmmdpEn05B/EPJdgcck3Xzp/Nw7rnE1Y=;
 b=nH/sX510xnsASCIyCsp4DanA9R17wJsM8N2kfClsNuwm3Ao3M2pASgK7x3LbSw8bV8Ua
 FbdxrT7WzIE3C38UJuWlMrV62ZMvYAMA5ZO2yUszjsPAWZerE1QZn3R5q1I4XNU++lRr
 +kzRsDyrSpNLU5LRhjnPH30783G88jFdb6uLy4jo06TSbXMC3yG7UayvypjnIsSqj/kN
 UqmRyLWGr88i4ZBASgwELrt/Dh2YZVv3dAkdAB54CvG7DohJ4oB1x7CTUpPZb5TPvtwE
 rgxqCuvP0askcz87UlqNBN9z/PBY2gNRvgYQ6VS2aEUy9E5s7GSLOnMciJIYXZMKdiQx ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aqbjbr145-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2I0V2170058;
        Sat, 28 Aug 2021 02:32:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3030.oracle.com with ESMTP id 3aqa8tnj9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgYUSYyFjmXASuc3x+7ssZOEjX8G+UA0MwDKvXIvkqpbhJFojXhn3u7sIKWB4gw3rYQc4+VayXzk6BFBUzBLMnwVX9dDWgeGN6rXoPVVndSBsEa2l8Hb2jV7Y4MT12S8uaNS/ZyXuc9TtL1HyMdbTryx052ihXSN6LIFboImOHaBtYo/kSLzpAYreK0FAt2vzTk9MUgkB3E3O0YCmxHScrfSyVMwrICPDP0jhEYrhmb/8EJARZzcGr/CVJySe7wJzhg19X2s6tmgLu8r0sefYQojWPt4ZExnkbJZySqRo42gn4lBa4lzTgHsNiLlakBxtyJZZdaLO32vH723Qg+nBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEAuN2fzpvHhmmdpEn05B/EPJdgcck3Xzp/Nw7rnE1Y=;
 b=Gn0UfEcE6L3ytQEF5rP3CWiufv997xlH6mh8yE4r4gqdizAz3jLIB3q5FBwk9EmTb4prLkGHN9+RQL8l9Pi2olJt1FlUXiDUiBkUuK7zHeDC/Es8NrHA41RGz+MZcyTEfsnO6MNdT0WgEl7EyuonW5uL8MVH30YM2l3MI/oBhPpxinVkGd6CbmHfAE6r874lQDYm4gRSYqm941v2Fk26HxeQ6tvym1kyelvDsYe014xuJcptunaF0JBh6JdkG+bXjddIuAcUGQKtui7FYiRo9CQGhufFDK1GGKjlhBK2usDhPNJJ7ENPlhlvq9SgM2dZlEZZkPiiqFYyKQl1bGuhcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEAuN2fzpvHhmmdpEn05B/EPJdgcck3Xzp/Nw7rnE1Y=;
 b=Q8Dj13+g9ZHmINMG2/JNu8EvbqDm4BQqQhZ9IFFwucEpPW5QqVbVQjwr0InNqOU/78BBgM8RQZY2agijzEZE06D9kJ2wOarGiWe9uKRBMBNMeRB4bTtBcfJWT0poIFRAptk44mgICuouvzMwJWagewa9047vXETwNiagylurhFM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix missing FORCE for scsi_devinfo_tbl.c build rule
Date:   Fri, 27 Aug 2021 22:32:08 -0400
Message-Id: <163011776500.12104.12801692889257976628.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819012339.709409-1-masahiroy@kernel.org>
References: <20210819012339.709409-1-masahiroy@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85fdbcb5-19c3-4071-6827-08d969cc14a3
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55154F511CAC26AC7AEFA2098EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ou/j3dDw0YC2TkKQeYiEHcpzQFm7Atk8vWY+Icq91U+OC5fsPKPtuKUwz9vvlGh5TRGCDaD3/KafaRSoniAY2md0SyoeWQJ+jGXOfpuu3N3tCvHqIjFvpI5tRrXYDJJluhK3yYnUCKUuBTIzXsSZgE+uv8U+MW1Z2rQXnkFABcXmHHHPd8Q/7w/MwOz/FINySLd07kDqbo7GLzKtmKS617Te/VpVfxPIAMGE9wc3w5ofbHYmzxq0kMb1eUBMWLozZ8AOguMejgF/QijyyP0TyHfpn/IBp6fKhvu6SlwqqEf0dqHK+EaliKwm5gw8O++NH6Ru+jHV4aiBpULATPTIS1zbo88E4YVgOgr7wXnCfg98nmtylrzr9jZEwFQkXk5k/VuphQ20C96qI+s4m3uyfUVDLzTbjyjCaLxUQw3nOYLIV7Hw7VK7TSVqXeuutKwM9t2CbeFMgDGSB6wGPVK5I51TCxWJ2kSW/XixLPLVnk3RH4jLOkH2/R8xCqHYtOStcI7mxZDOJ9pxHe9s6hgNBjjrH+n44HXDyRUtQwSbLwyDUS1CCLucs9YWJlJRNkThqg9OIvwnFyxmcUqRvtapYlnwDiPNq3ttHs9KCPYDTrzNHtZksycFRZpAVtKcXbSuuSWhXemXoAt/Rk90bM6xb3G3VJNfq+JOz1jvArMjLy2RXkc8fvsiyw3vbImkhWg+nNFjfG1HrlAr1Sv+LibiK+qDbLEDtupoih/blsgRs7jSvkiigW8vKC234IQM/LJ2Q3/Q7WKVPUGVyx9a6yJGFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(54906003)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(4744005)(6916009)(103116003)(66476007)(66946007)(8676002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXE5M29XWFBndEZ6NHRrWlp4ZUlFUVZ5ZWNkSFVVeEd5VDNXMnp2TWFFR3dH?=
 =?utf-8?B?RWwwT2pvb2F3QWJQdmMzeWxoWWVPZzc2ZkZuelA4djVOTUN6dGFDL051QUND?=
 =?utf-8?B?TGh6TG9FNEhsUGVlZG43bUFCV1FYdklTdmIzeWNEdlBMWG9RbTBGU28yeUh2?=
 =?utf-8?B?MGwxN2FIbzFyN2FRdDVHdjZNVEZqU2dRdUNUQVB0MnJXN0xaMFFCZ3Mxa0xQ?=
 =?utf-8?B?Z3pTYlVzbUFPbHovWlY4MlRNRkQzYUk2ZEtGVGtUeWs5VXBTYktGaFlDWTBm?=
 =?utf-8?B?WkE0d0lJbjM1MU96NjZYSTlORFpTNHRGQXdFMmNoUExkTkx3S2l3MWZoK3Rt?=
 =?utf-8?B?SkpjNXpBNjVwLzdGZUcvc0F2ekZYYWZUMlErNVhPMEV1OExTK1pIVkpjTnBp?=
 =?utf-8?B?Tk5WTitFT0VsdkI0TEh0MVJBdzNjeXFPdE85NTgyMnp6elhDTkJ6MEkwTldo?=
 =?utf-8?B?OFNFRU44cG5qNytkbllSU3FhNVF3aWFhK1B4TVp0TklJMXZDeDJhL0NYQ3Bq?=
 =?utf-8?B?a1N4ZlNXOVdZQ0pRRE1GMGZPa1ZPNmFRTVhuUktRN1VtWXEvMHVHTFBraitn?=
 =?utf-8?B?MGc3Z3lyQ29jN3grb25WZU5xaDM2QzZZdlA5dSt4WWgydXhTUnBEUmxYQ2No?=
 =?utf-8?B?TmVXQVZKa01ZcC8rOCsrR2tYdkFDZWZNZVJOUk42Y1JsOWpXM2ZiRzZWRVRN?=
 =?utf-8?B?ckQ0dWNDSSsrVHZzNmMrMm12SXV0OU1VWkJMVmw1bEVyK1YzRFlIUmRla1NU?=
 =?utf-8?B?NG5ETXhFY3pWVzZ3Mk95SEZiR3F2b3h0QkZWZGV3czdpVEg5blVvWW11dFZi?=
 =?utf-8?B?ZmRHdkoxZU1HQmRHTjZyMytVYis0TjJIUDY2NHlyTVFWMnQ2b1ltVTVBdjZm?=
 =?utf-8?B?elp6OVRuL1JBNjNpT0kvWFRJcUIrL0dyRnRXM3o4NFpnQWVheGs5Y1Fyc0wy?=
 =?utf-8?B?QXVUK3RLWmw4STlaSzJEWVBlVFBSTzVGTWFHYTVXeWRocllFNVA3WURtdTJZ?=
 =?utf-8?B?azZDbGJHOXl0MGU0OTRZdnRXMExGLzdoWmlzamxCaUF0eWZVcTFqckFpWllt?=
 =?utf-8?B?VmlrQUY0N0k5YVI0eUs2Mk83Vk9SdWZIemtwMVhHeE1HTDFGVnJZZExmNHZJ?=
 =?utf-8?B?cldjVkhocDVyM1hsdCtHNWZjK3g4T1I2MWpiLzhDSkZYUDFUeDd1Zkd0Sjl2?=
 =?utf-8?B?dk1vVFliL254dldMdEdCcXFVaUw3bnl6V2RSQlpJQXFMekE5MHQrYnVQdEll?=
 =?utf-8?B?Z1Zja29kZ0FmZ1hvT1RpWFlkUUhRUXFOQzlOLzJhdm9QQ0RKSzVHblpGdjdY?=
 =?utf-8?B?R09WbHl3LzIzdUh1dlNyWTdOMDhBbk5zV3RsWFhuWlBCbUxDbmp0cVRFc1Ux?=
 =?utf-8?B?SEtBNmFIMXQyTVJoSVZyWjRVRGc2NmFWNnJwMGtyUTN1am8yaW95Zkd6SWl3?=
 =?utf-8?B?TFRFTVBBNVJ1Q1FseFE5M0thaXFYWG9JQWJSYWpHT3ZqSncvTHZ6VWVCd0xo?=
 =?utf-8?B?RFlSOEdieTVTbFVTV3RCYW55d1A0TzN3eHl0dm9nbzc3K2IzQkJZT2hCV2hL?=
 =?utf-8?B?Mkl5S0RLN3I4Y21EY2h1Z1VabkZobFA5VW8zTlZnZWoyMkdFM01vSnVQelpa?=
 =?utf-8?B?MXpEcUFYdWxxNm9NL08yTUptWWM2Y0Y4OFcyanY0VnAreCtaSEFsUGErVmVs?=
 =?utf-8?B?SnFSYkdTZUtNTlNtRmx6dktWajlaNnYyV3VycnBZV3U4Mnc5NFZCQjhGVUdK?=
 =?utf-8?Q?hbmxD02d+2UlghW3efhTED9wO23CjJgyaUotcX2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85fdbcb5-19c3-4071-6827-08d969cc14a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:29.3489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hy1UXpszmoZ+Z6RGG34NqYSu9Ubvpb7T5xD1oLjXX37OuuKfG+w73fwfDy63NbpWLKHGB0MkD4nF6duipKmse0nt0Dozec1TwO4oHVLnNE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-ORIG-GUID: u9nSLLIoRS_U4hbifXId_IpSEmLEFavD
X-Proofpoint-GUID: u9nSLLIoRS_U4hbifXId_IpSEmLEFavD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Aug 2021 10:23:39 +0900, Masahiro Yamada wrote:

> Add FORCE so that if_changed can detect the command line change.
> scsi_devinfo_tbl.c must be added to 'targets' too.
> 
> 
> 
> 

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: fix missing FORCE for scsi_devinfo_tbl.c build rule
      https://git.kernel.org/mkp/scsi/c/98079418c53f

-- 
Martin K. Petersen	Oracle Linux Engineering
