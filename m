Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B051C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAF7064E0C
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhA2TDt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:03:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50184 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbhA2TC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 14:02:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIx2iv074008;
        Fri, 29 Jan 2021 19:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=XIRqsC3MlSsoOL2G2BgQ7/mmOTLHN2jSV0G/JnMjEQ4=;
 b=x5UUncoBh1KHUXZlXpb2sBlHWun6CxotVpo0OnEUobhNRz4vyAsicDpDBMU7Tdasxt4g
 ywRcgn0+kC7rZ8lpd1XY1g0R2tC3CSai6ttrBiN0ISLwXQ8KhTTGKkFkqFhjJl+TSGmT
 ZchLGi0ElfDpPF58fmidpEc5+h0bQxTEXP2Lv7wQhS0fIpN1uz0x1wXRi7Y0V1bMCgqK
 XPzuUT3M+VRs0qaC6yskF404+cv/GwkAdR3sM9Mk+uGmgHrFPrgmv/n9n32KQTOzNpgu
 bWvzSnR/pyljVYjbhGE84/KFUGOVyEPE8TQjAP7p181mDYAbZf6puikV2w6TmTGkbZ08 zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cmf894mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ0Jkv014653;
        Fri, 29 Jan 2021 19:02:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 368wr2b6ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPLN0pUXmg9jbM08B8Fymkr/WooPnJkEK6rfXIKu6EhMjVVMra8EH9ksVzjovkQgwFiF1HYFTCpRU/O76DCWytB69amRcLo5GOyIndmmj9nd2HhT8nFwi+A+WZvYk7q4fG9tWZz4sZmr/bl3d8p36IC5v3PIrAl4Bn1TieP0ReLbC4VutAjZXFp36x2NjQhdY+HqFvqPaIvxu78H96cOPilUOlI08USKt0yiPP1eHCeWI4vclffgqtS/cK2hyBOdYgGzIwn3pfTKeY54lk1Ct7Rf6QlJmVsqdG67qQMBZh579e5Y7UNmzhJrVrlwkzZbEqqFHC1DhSjyv7UxnfbyeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIRqsC3MlSsoOL2G2BgQ7/mmOTLHN2jSV0G/JnMjEQ4=;
 b=gyAT3YX3rhQgiJrdqBEotG1Lt528uSr3EhZfo8pqBeEW7uPJK4geds5UOn+hZoRqRHWieQTofAS+5WIC3edA8v58GZNUpEGPaZsxcjnBvlHEQXqBvUW2aVeXBZEvFtw2/Sc4DkQ85NvMIhpgW3Jp8lI1wzRnFr7838xfNRJMzY0vCKKVUihJtEeiepMLVLTIa990fpHMvylAQDJYJCU4CbbEE4OsMDcNfeFH35u2d/TpJ+N80HrkmzBOLC0ujNrWpZ9JyCkCgY+h9SXD6YjLeROkOM7MYdpMQ511s3FaQx8WO58tIr3ENv3C+BnHfHpw+b7RKPRh9msD//WCaWLrDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIRqsC3MlSsoOL2G2BgQ7/mmOTLHN2jSV0G/JnMjEQ4=;
 b=TLzvaVquMMmckrROIKsXhTobdAs+S6bqKoseOZXXikw5bzHbq0306C5X4wmmwklFj9rRqN5uqbhSF2W9/CpQOXlF6gVV0CEvw2SvRXzg2J16TAzF0ffC24kxSXSWJM4oWm4q53u4fSJHzYmxjVKH/7Ynhvmg3KhRDSeAoNERHz4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 19:02:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 19:02:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        James Bottomley <James.Bottomley@steeleye.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: lpfc: Fix ancient double free
Date:   Fri, 29 Jan 2021 14:01:48 -0500
Message-Id: <161194526371.12948.12096807116592012381.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <YA6E8rO51hE56SVw@mwanda>
References: <YA6E8rO51hE56SVw@mwanda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:610:4c::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 19:01:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e7e6718-64ed-41aa-35ad-08d8c4885b20
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB467770F3CDD87199561036FE8EB99@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: agy+Y6vIdqJkvFEwtnB5U8Ms78b4NIoRFqjR0EpQq3RKtS0OibrH8+D/dcOqPwxX6ptdvDtGIl77mB/3/OlVihqK+/bX5bveQbmMZk5E7h2PWb2e3yClt7wNbYOXeXXsI54oQKos+njlAZBKtT9QEgcBAJnNzgWKFdI4lBvTT1l1c3NHZbbnKYnlid/jlXfuijgBiIGgVGGtMgrdvObfbm0qxrHOiga0fHhSAnYpZH4BQF/T00eusWUN5mCxUhy8NXaAKxvDvTOpFJa0lribIBoJOkygk4MtFCE866jxnULon/DEfpo7S5EPUfcuVU83nUXsf9S/jBZTsNv0rmFTyfMnPjPjFYcTAS+1iZEZLcMwCIKoySXrvEMsnYhISKAB7Cw0ILDH1FMOaztFO/eEoG19riAc1qCb7gjPFdGcVJw+VIUQorLBGKjZw5oFwtnEPY6s2Np9x5iKpZFBk6H5ySK8BNh+hnTHhwT7NSrEru9af5UwJe+wTPGzUEcE3l6UF3kGI+6O0LdvVstoWNqb0LE2DHzraq+wlzpbbrJHzKW07qPFGnFr01z/SAe/bRatxw1EQYGupL0sCPY4uC7fCwlltreOuHbpLStqL6JWDgA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(956004)(66476007)(2616005)(26005)(52116002)(66946007)(316002)(4744005)(103116003)(66556008)(5660300002)(16526019)(186003)(36756003)(7696005)(110136005)(478600001)(86362001)(54906003)(6486002)(2906002)(6666004)(966005)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T1hJdHBUUm9zNTZrZEo1WlQ5a0JtdUt3UTRPWXZYR3VheU9mcjNLZTg5V25L?=
 =?utf-8?B?SWdmYU4zOHpLVTlyZ2YraU53blBwOXBlMFU2V3FGNjBtWFQvTXR4RGhtZm8z?=
 =?utf-8?B?czN5aUo3UnNhcHUrRlp3T0ljdmRXbldlTWRsZ2F4QVJ0L0twWVlhK1lLVkZl?=
 =?utf-8?B?QU1NZ1o1TXdxNVJpY2ZCNTNrMmM2ZlNVVXQyWXJtb0tlUXpqSnMvVmNJbGVB?=
 =?utf-8?B?ZzgwY29HeWFuVFBFVVcxRVFGQWZFbVNzMnN2c2NTcnRjRVR1V1QzV1YwKzdW?=
 =?utf-8?B?eHNCUTVjUGI1czc1bFdkc2N6OE1pcU1zMEZhaUdRRGVjTzk4dUlRNHBISUJ3?=
 =?utf-8?B?T2NwcUJDRDRiQ0dYbVpkREp1aDdwTDlZQUZaZUkxMXVVc0RjSTNkV1NmQnAv?=
 =?utf-8?B?SUN0SFJ0Zll3aFkrWFFGUUtVeTc4NEhMVG5GR3FtL2NuS3Vyc1pMcHlHWFVV?=
 =?utf-8?B?Y1J0eFh6MVJYSzQxemF2Z09rUDB1TVFuMHJ5SlNhdU1sTC95WWI3citXcGNT?=
 =?utf-8?B?TzRXY1FDbHNKSm1GZi9FdXpEVlZpNHBmR3R1UzMzajB5dkl0RTlaa000Yy9J?=
 =?utf-8?B?TWNIR3oyZjd2ZFlTdG42OStpK3FrSGcyUlFubWZnalN3K1Y2Ris2SGpHWG5J?=
 =?utf-8?B?S1JMOWp4ZGRrN1N2ZS9NQ1RKVjhUc2hDQ1JmS0ZBZjNSYmNMOExlU21RQVh6?=
 =?utf-8?B?MllSbTBFallSdHQySHI4UjQ1WVVlanJmWGNhQnE3Q3BZbWV2TUJERFN3akpW?=
 =?utf-8?B?aTQyam8rRCtrRFNXODZBcEpJdTkwbEFNakdHK0FxNmtmYTJJYzhsUXM5MXJE?=
 =?utf-8?B?K2J2KzBBQzUva2lpVlRMSkdWWUhDR0JnelEydnpLWC9nRkhDaEgxSHQzNUdG?=
 =?utf-8?B?eHRqUDVkRGNlTTJFVkQwK1lZcTNsbjJ6RzMvbGJJQWxtVFRuYnVSdVNjdldn?=
 =?utf-8?B?b0h5ZlhacEJjSVJ1OG91dERjUTRiT2IrSmJKdkFqT2dWcGoyV200akh4aldw?=
 =?utf-8?B?eUxWTC94MTJGNHk2c245UkJRajVncTNOdXBobEVlTURrNFpuc3Y0dDZNT3R1?=
 =?utf-8?B?WVR2cW81My9NWE5OOVpMWVI2RVI5NEc2NCtpMjRPTWkrSXEyK0JicGtqQTMz?=
 =?utf-8?B?UkNQZlpzdTRlNzYzRC91ZE9QSmlRbElSNldCYkxTb0FnYnpvWEdyQlpRTmdX?=
 =?utf-8?B?TjQxN1hVSFVtYkE2czI2VmRJNUhLMXd1ZmxrK2d4TGtYN2w5SmJLS0YvRTQ2?=
 =?utf-8?B?bm1raElITHJXeHl6NTB0TC9JM2NDRDJJMWx6RlU0dWdmSnBoUVNnVEZwUUc4?=
 =?utf-8?B?WnNOR0MvZ1dacU5FT1BuVEtraW9iMjhjbEV2aXhid0lrOGdpTlZEOGdpOVA2?=
 =?utf-8?B?U0RtV2t0dmJLL0s0SDJGdW5UemJLeGY0Tk5xcDUzanZ0ZzVTbFdBV3QrY3My?=
 =?utf-8?Q?P02SxjOC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7e6718-64ed-41aa-35ad-08d8c4885b20
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:01:59.9226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9DnqeDCN5lIwqv5dYyJx6110AoDSTJkkMIfCHeA35tkvafKeT0k5ukznzHuKzHIao3OGohgSIaAHjG0VNbkZJzdapVktLPxqzJMm8JkLzEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=854 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 25 Jan 2021 11:44:34 +0300, Dan Carpenter wrote:

> The "pmb" pointer is freed at the start of the function and then freed
> again in the error handling code.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix ancient double free
      https://git.kernel.org/mkp/scsi/c/0be310979e5e

-- 
Martin K. Petersen	Oracle Linux Engineering
