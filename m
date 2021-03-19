Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE8FC4332D
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6619E64F42
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbhCSDrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56534 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbhCSDrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:47:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3TfYY075095;
        Fri, 19 Mar 2021 03:46:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=f0DOj0BLmOhzlis8ve7a2yMwq6Ip90d8x9lsKhdKRMs=;
 b=VUnUh/rfwO/ISg9gox5SP+Je1TPRHzTPgU91jv+vT3V2RvuzKV44l9n8dK7j5ybXQ0Us
 mgsTy/Cr5ZNS8bBcPibEF/4TPpuGnLa1k7yQ0H1mMvjQF1PzoWQeA6NnG0RMfOyd3l9n
 FowcCEyY1x7zeShPAFGivFY9Zfa24o1e54jQfmLp2ZIFuVR0WvlR6Rk8C0cJqsBJgs+c
 7apNhy2ipMkgzPJvYrTFjEVci6+K2XT/ft38eiZ53qZNxrArW6oNvhZUJW1yEB+oTaNx
 UOuMqxLzM4jdzE4vy6BXbRSDoB21Ug46RF/yB3PercUTQ/Tkdyoak2dTnVSwz7vZf7UF QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 378nbmhhdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U9tk120047;
        Fri, 19 Mar 2021 03:46:51 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by userp3030.oracle.com with ESMTP id 3797b3rkue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ix2m5qGG7x1neyr/Un9C1M9cCOMmdL/5bZ/eGJlTmM0XuHw8m12cwvyPSfroURogzdo8Izmu9QznNrhyCpmk32waaCgn0nH70Kj4vYZlroHM5vmt73R4gEz0N2vluSnuDrEZ658TysG/Xs/W4/GgB+9AhhwXgOwaTpeOxnifKzam06MOSmAPjPcg25DzPmSDQE+n6lrw5MD9vIpsvH1oMQxdJHJ8OVD+uCp/Qn4I3Z2P5ayYrNqf0TCn5rbc4Kkl7OLXOTaD8bYA0/fwIcErrG3h5wjSFhUYj4YgKf5IhQldmr5ML2Hluaz1FkD93owokbbtxHQiSOjIx3qrzGoKaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0DOj0BLmOhzlis8ve7a2yMwq6Ip90d8x9lsKhdKRMs=;
 b=CLVo7/nW0DMfQtwUZ6xNcqskZ5+qeTVAhsYpp1FWCHtqVyOiBmb27yuEh7TLid9+6EPuSIfqqBCOtfguGPD+cTYAfuOffUK5d/FUND1dTFsl+0TqQRg8PKa/XKHLqx6lNU7KLJ0h1uyr60g2k9AIrBQQNr54s2ZysvlqJM3i8KavltL1GqskBiFVr1CtC/s7GL48z6oIqCQ3et9rPrLGtzUt6yjW9oT2JpvnoDbwi97BeBI1jnXXXddH18THlbyxVjd1vy+PTHbwhbrlt19BfFLbYIJlUhK0V4V9pP6TfNpAt5Gnpk3opR3fG0h793NvUbTypvw4GTacqEEfQud04A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0DOj0BLmOhzlis8ve7a2yMwq6Ip90d8x9lsKhdKRMs=;
 b=zLFxE8NVcYqlE8mCQwYUlpSCNIsqrvyAMOd7J63UMrY9/5i+s22FVIrVLqPSrBjCZ1+uOumCOg0BnZpPJ474J8FQUSJUFzMPO1OGlokUBkixWMPpt9VA+Q+484CMwpQ0hlJ3HDn+6wBDfIJKqzUeotFTpN5XBkDoyOkHbOv8TYM=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:46:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:46:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH] scsi: ufs-pci: Add support for Intel LKF
Date:   Thu, 18 Mar 2021 23:46:31 -0400
Message-Id: <161612513554.25210.13743585564539536266.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210312080620.13311-1-adrian.hunter@intel.com>
References: <20210312080620.13311-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:46:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14e1b872-3471-4ceb-0bc4-08d8ea89a05f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46167522F38E6AB68B2550278E689@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0sDfYqb3jpjK9uRh7WOkQC6hM/wNfsfZ7YhC8PwP4PV93EMxUme8sjGIBuup2eMJ+E00QtNxEMB5xTKSfAFpDMWrtHI1ZrQCig5E96+UaI9O/mlQMYydKtGjTi3MGXQUTVBBv8plKxutIHaoCvpc7KnCHcOhLDBYmR3NKp6myW8I4who+8SZSP/lcvyZtR0Z7g4v1QLgbNq091aMzx5C4EWpmlgPcw7UsSHKOu5D/ETrTu1/Az7iLAX8TzIBdh4NDXKGKnzkk4GCK1eitZ+iAkjl6Gi+8L58zukUaAGH8TiEbrbQHQochHEp6w42xsJEnYQPAAlUlUe6qIsRw6YmmmpCAmA+ojNnDW45x+STrkbPvxeF8L88aHX2uFrjTnLjeTarBs1HyVbkkuit9EBSwoOtj6Ec3Zm4GD19i5elYX0IoAHNJuq/J48pMklxEpv+f6ZCN8wWW/1IRL3WK7qQ8vJhzrzJuRKCwUqG9K7Uc7t+H471hERwHdwZQmAcW/2FmAsaNcOQNmlg6JZFxE7EoX2YvNgo4+EK9nesnraMqoC8/LR0t5VlIveJIWPllG16M1p131QLT2Me/QjLzePE+Wjpgen9x5Js2EiFatshj6gmlaSSdlP8baRXn01XkD09NjZtiO/FfT5dHJ6VAw2HkvBd9gqDd9Apmq8zYpTB5oIKe+2pHFm2YC9c9PuKRoOw3hIMcOFfPP7iUP25NaqVlnMNkdciLMcN+ETuP+Vt6w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(966005)(316002)(4326008)(478600001)(4744005)(6666004)(66556008)(8676002)(103116003)(38100700001)(8936002)(186003)(110136005)(54906003)(36756003)(6486002)(16526019)(7416002)(26005)(86362001)(5660300002)(956004)(2616005)(66946007)(52116002)(2906002)(66476007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R0trM1F0ZTZmcVIydlpES1g2T1RHZVFmWGtkd0tVZVBrbFFpd3pDMHp3TDVt?=
 =?utf-8?B?VHIwY1d0bDRTUnplKzMxK1puUmFUVnA5VzZ5MW10b2ViRDRmQm00d1pyYjRN?=
 =?utf-8?B?cm9zNGZMUXZLMWlObzF6N0x0M2h2L2NRKzVIQVNoN095TUl4bGFZUEJRQ3ZK?=
 =?utf-8?B?QUcva3B3NXluUllrbHJCM05OSzFJQWJaSWxwbXJrbmZaUkIrWG84N3FsRU8w?=
 =?utf-8?B?V3Z1V3M3SE9CZHdkQXZ1MTRTOEFKMytlTHQvQWs2TUtZNnNRaFlHdTdpaWQ0?=
 =?utf-8?B?U0E5eFE4S2owWHJIY010ZUpKeEg1Sll0OWwwV3pidU5jbnBwL3U1WlQvR090?=
 =?utf-8?B?a3cvUVp2SlZIRCsrcDA4c2NiYUhMK0dyQ1F4a25SU1dsV2I2czVmRGdpY3B2?=
 =?utf-8?B?d3BKQm1CbitMMlhoME9oWDNpYktYYm44UVRBU2NPR0ozOFBWMTJkMFJLUTdq?=
 =?utf-8?B?N0p6eDVidmRmRml5SmM2ODRQbnhNV0I4cDBvWlN0SXlqb3BHMThvT3g0Q0dT?=
 =?utf-8?B?T0MxdlFRVnlNUmxpK1hseFBSeWZFck04NnN1RVloNXl2Y3VpeVBaN1AzTVZa?=
 =?utf-8?B?NTQ4MlBxb01aeGlWalVBMFRxT1NxbldYc3pacnlKT2QvMEtPKzF1M2QrYnVP?=
 =?utf-8?B?QmdzczNzUkpBbkd3MGtXSmlTMldlOTBSaWtzQ1lwYk42TUVwK1ZxWUdDUzNt?=
 =?utf-8?B?ZTR0N2lUcUcrTTVXMm5zWWdrUC9nblNqaEU1aVQxR25hVlM1QmZmZ1NJb3dQ?=
 =?utf-8?B?KytsbWV1dE5kMy92S2kzZlNuWk5NdWV1SG1aTVdaRXRWeUtySWdGT3Zvdkk2?=
 =?utf-8?B?bDEwellveDBNVFdFc21WQnlCWk0vTzQrQ3d4L3RZa2xpQzlXZjhXUk5XR3hY?=
 =?utf-8?B?NDluL1VTNFY2S1RzLzRZdDZEMFU5ZHN0REIva051UzkwcWJTT29iZ1ZaU0hH?=
 =?utf-8?B?NkZXNmFXN0pZR1RKKzhkSjYxQURjaFRtaEVqQTFIWmZlNDAwOWhPNEx2eTVE?=
 =?utf-8?B?QzNYZ1pKQmRuL01BaHhmS1ZpQ1lUeHVXZnhUVWZjSWVrMnJ1aXlhZ0V2c05j?=
 =?utf-8?B?b2J3L0ZFb0pUdVpyNnJyeGIwOHlTWGtRZW0xcHJJbDIwSzBBdk03K3pHdndJ?=
 =?utf-8?B?WEQzd0JJRGRGU25YUWQwOUNKelMySjg3NmwwK2FsM0NKdGhvd1ErQjZZaFVr?=
 =?utf-8?B?TDJHdzZjUG1NU1B6Y1lPSitKSFJUY2k0cnNkd3FjeCtKcE5yamM1MWJIQ1Iv?=
 =?utf-8?B?WWtsZytFTk5SbFdxU3M4UWVNdnMwYnAwOUF6ZVhBVnF6b1RSYzc1QUFVVkhY?=
 =?utf-8?B?Z2xlZ2d0WW9LVkNBWEdsckx3cGZhSFpoYk1SaHVvbFdHNEZ0VXVhaERvZmw3?=
 =?utf-8?B?ZWh4c1cvOFJSYnZPeVdLVXlOQ3EyTkFSVmdyclNzQ1MrV0pORlMzZHVwbHFE?=
 =?utf-8?B?V0tiTTlvdXYrd0RLTDBBc3ZaeXRlN3EvSlhMMk9sTHE5bUNYQ01mTTdncWE3?=
 =?utf-8?B?dHp4TitYb1RPeW14WHlWNk1WNXNsNDFkTEdidStKVkJ4eXFHNllnK3VFZHgy?=
 =?utf-8?B?My9lN1k4ZkMrNkprdngxakwxaFduaFNEVDl6Sk0rKzd4ZGxsZmhjcGVMM2Jn?=
 =?utf-8?B?NHN5enZxV2xuOGZ0c0lqbGc2cUdDeHlnNWU0NnV1cDV2aHg5ZExFRFh5NHNy?=
 =?utf-8?B?WjYzSCt0b3A3ZW5VMDVrcitMUU0vV21zb1Vmb0UzZDFiVFgzelJWbzZuUVpn?=
 =?utf-8?Q?jsumkU62mRQgEnFFI7GpEvRtpQavanbHvOGwyDq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e1b872-3471-4ceb-0bc4-08d8ea89a05f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:46:49.6709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92O/G59CSlMnYToaIvgc/sQNnk4el/eiJ1jQMFZUTl+IeKstpwRe4AhOPdLRf94bmYSy3NYJG9mKM2WkCBpBIZ0D2PypOhR3UeMp3krFEWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
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

On Fri, 12 Mar 2021 10:06:20 +0200, Adrian Hunter wrote:

> Add PCI ID and callbacks to support Intel LKF.
> 
> This includes the ability to use an ACPI device-specific method (DSM) to
> perform a UFS device reset.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: ufs-pci: Add support for Intel LKF
      https://git.kernel.org/mkp/scsi/c/b2c57925df1f

-- 
Martin K. Petersen	Oracle Linux Engineering
