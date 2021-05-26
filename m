Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE49C2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 03:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C75E6142B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 03:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhEZDlj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 23:41:39 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44796 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbhEZDli (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 23:41:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q3cukk158696;
        Wed, 26 May 2021 03:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=udhIWh8DHQcGIMQio9uuRJSzdNGgAS76rEIGgkzPHXM=;
 b=tCuWkqBDdWogx1VhDatJXburcRgqS0gtfVWWGKte0fWj0d5IVMECpSeVZ7VsJvc+M44l
 6axFNRy46aXnZKk/eGboXPJF9YHcrjcZWSARr8I3wZ20tKs2kt65fqv0WPthpozdfYx+
 hfNsHQ0wslZEonymPb5ctMQI02FmEZECkhiFvP9CEzqH9wiAdeFk+1/GnFGruyRxTi2x
 yV40/MmPuA9Yo3dKKFBj8naGbFOHsiSnmyAKGg00pNcL/RntWhhTMW1WoGRC8Yqsr6K7
 a56kO3smkwijw7n/pkjTWQW9pnunR1AxZZjEf9litt/hdscapwx0TxBz33pHMFvDywzl 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38pqfcfsqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 03:40:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q3e52c125329;
        Wed, 26 May 2021 03:40:05 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by aserp3030.oracle.com with ESMTP id 38pr0cc56k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 03:40:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DqGtj3mYQmyuxpRWZEzfUoJqzt804ZFzpBNsByCzzOYA+fTNay9GFgJ552UrBv4XK26xSAQygb3O6jvSbOxEm2MhRr0+S9+HsCtXLDbsSrFbqZyWpNgSOu95MtSqPM0xw3nAiXByT0hWxo8GcAZlRhRHPOsCuVTIxq1B7YhcYjPn1b/2rO+EDubtGJQgQTJvoJUSU7JKe92c/VdrnXz1aok36wdz2gD4Ni8SDTzv5g+gow1XBE6Okfb2f13tbSBDfHApcAzIMLpms4Ebk8z/Ns9bMSWhQgJ05dvKYTsDwiV+afXB8GyClAPDebVa51LQfLlwN+zzB5Os/0kIr0M7tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udhIWh8DHQcGIMQio9uuRJSzdNGgAS76rEIGgkzPHXM=;
 b=XTM5zLtmNyrOxwzjs2XKnOpaC9ERf4eucScwetLl3576SL21KwmLuAK83vK2WpS4SpiW7sAnMocjFsd0gjqL8FbIWbrJ8xQMBNU1HW0K2f62K0AiIoDYNbvEkyGrnnP6U48IB/loyFRLc61zADxRPa52AkDVjcP5h/OeF8Hisr2WGmo8t1LOWusrdwh4GaCvJH/bb10kGFvli1U5UiJT8Xes6S5sV4lT4WNM1H3swiy2a8T3Mj/dagVVQn3tQSTnWnBq5tiEq9jt4hbGRiGgmXFdDkiKDtSb8HQjoDSJKbdiChr3ijcwUm5tWQBE+/l4SVX8+cjgZ3RYMZZb/Mxn+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udhIWh8DHQcGIMQio9uuRJSzdNGgAS76rEIGgkzPHXM=;
 b=byhv8+ZLIzL3oe0sUGJFHe+oyk/ctPuYWHgheWFv2E5wHQzARNszlStpiH22lf8IHobiX9K35RQK2XB0F4fwBbeLp0l1mfYqdbvXGkMvwLu+CSAIkacbQ3MfgVQGo+BwoNuWAx90zJwz79kYZhrbiY8yz2ulMcbMw/5qeeo+ekI=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Wed, 26 May
 2021 03:39:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 03:39:53 +0000
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [Patch 0/3] Gracefully handle FW faults during HBA initialization
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnrmw4cf.fsf@ca-mkp.ca.oracle.com>
References: <20210518051625.1596742-1-suganath-prabu.subramani@broadcom.com>
Date:   Tue, 25 May 2021 23:39:50 -0400
In-Reply-To: <20210518051625.1596742-1-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Tue, 18 May 2021 10:46:22 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0142.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0142.namprd13.prod.outlook.com (2603:10b6:a03:2c6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Wed, 26 May 2021 03:39:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd9bd335-d6a1-428b-95b6-08d91ff7ec4a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46626A16124F9C06981216BB8E249@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPIYAHCU4go5YdlPHrildi4HDbLNC9LCZrhFxPA4sFiaOEP3CLv5ckOnequC2bAPWn5HuR8nDD/4E8jOJssaMYIngI3hHYXlzT5vJqg1jJdTm7vxzKvoOTIEfbD5uFL5ZpB4S5EoAJ4R5BLxsULCWGm57Xb77Tq4k2dkEbMuY24ywt3xN/QY2ZNs4ezUt0Nlj0ZwTeFKUPt1ipn4I0Q1JnK3x4p1Ag6hd4DljcYFhE30i7b3ChbIPAK2+Jwb7po2GkEzsqXrxfF3fZzYQqa6rGV6Kc3YlFolG+hzLvpXf4vIIg6jch2Cjd4iVymXXIX3h6gU8+flyff03q7aKiZDH/qBMPJxZ6PEIty8vUFqC/wSD0GSBwMNQzPVFzouYVYCCSMe8mmEkCBZIwoeisIq0nqL/b6PT2IdfHR6wNntP67A5K2AJCysnmVyiOIioF2zrJot5r/Zkm2yaazcHws7eID9Nox5T+AMCWOpYfuJLdc1YwzgFFF3qRtdS6WR9OG2I6dhKirppEQitQbi1Ovru8K6yvd47+pDhwvDQXTZASxj9eUGRbTVKouE19nl9T9ZK0Nh7UXvxwhGpSLnkDiTg5Tk1DAUCpnvsqL/sTVZLGlXLAi4jZ3SpHUWw/IRCqHs6lDLUyEoDJ/8s3nBHkD0CiQdG+nwsxG7yvCpJ2oX280=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(136003)(376002)(316002)(8676002)(36916002)(186003)(8936002)(66946007)(38350700002)(4326008)(7696005)(38100700002)(478600001)(26005)(16526019)(956004)(52116002)(5660300002)(2906002)(55016002)(66476007)(86362001)(4744005)(6916009)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mL8+SzaRf/TrFhBNfVEBDkA+8O7rcL06dWB700l5xzRVB7zw9NmWdPY5I9Ic?=
 =?us-ascii?Q?6rlreUuV4JKXtzi0Rcgd5rSXFPrxpbv01XOj6MgGlYrscNubhOLf+eCJAwm8?=
 =?us-ascii?Q?w8ma1GzELV9tf45Xmp5Fn5WAtHjnFyfe4UBoU9Em/T4NNW9buFNgStnIaIav?=
 =?us-ascii?Q?vUYlXs2oBoHfp35ZXrtT9PiV7lGafeKq0xVkQPtt/FjflfkmGC7QP54Tb7uk?=
 =?us-ascii?Q?Nv0P2EJi9lO7zzIJXpiMxUKCfdh26EHi5iCqrxqVNqrWsqa0AGkqwKwmcsuR?=
 =?us-ascii?Q?7hh1zsUC8z0/KPUUc9oPkBTNUSBUuqL4rW9czmUBabb8eNpqNtB8I0aSE1t9?=
 =?us-ascii?Q?BZqO7xUEyXDgzimSUG9RmtqPjA8qMVmQr/D4wE2EP06SSw4zlGaJQIf04P7g?=
 =?us-ascii?Q?OdpnRNEUaKXifZveqkcL1BHyGEetnYMUw5tfvpm8fiHEMLKHSlrJ0+Cxe6S3?=
 =?us-ascii?Q?RQUqIv2rOOwTa9XMEeaoH+pBl8+DB1wZyPXayTC8WN2JO4ik79idlU681C+R?=
 =?us-ascii?Q?ppFeR0J0fOAzP++iFn7gpaNToUOCtiMtl+/6CY6zN+z7UJrv1CRqXQF841LY?=
 =?us-ascii?Q?haxpr2Pe8rcIKhy2rOxFrCPkskWupZa3D6+HE9VnBGPPG7xBZ4oNeEk3y4W8?=
 =?us-ascii?Q?rVXUjrldyQNofGVLUTTMpf90EwFgb08PnXk7DQmqVTbo7iFzu9ro/R3XOQPK?=
 =?us-ascii?Q?Z+OrkJxnakMeeWgzB/3LD3fSuCgh7zdSBLHUK6cItFVLm1HVIvdpZ3EVetmD?=
 =?us-ascii?Q?1q7A4+MI2wer9jNIqNXwJtJOuR/uK2pCDnKgyk0tQFlO76hMvI2WjnkBYCAw?=
 =?us-ascii?Q?dxQbECHyaNvLL0FWYHKh3Xg+XHAzSqP2hlBCl1z0G+UNcohN3nF3aFM2sX7m?=
 =?us-ascii?Q?Klc3BYIam1+pXwSypFNF7xWa5xY6t5psdPsLMWPZqPHqG3J14Px1VkTofEa4?=
 =?us-ascii?Q?0Y6tdOOi227A2ektR9K7zl9KAvyZNwlY7rRvdbN8Kc4a/7BSK3ZhV/kXT97m?=
 =?us-ascii?Q?qtpz3rOkhRFd696EkhJ7lvilKBDKNVS+T6y0iHBa3MXUjV6UsfgswFLxtb5z?=
 =?us-ascii?Q?geG4umsoaZIo1uCrKlmJ7O8PnZFYzxMvpD3sxTlC0nxcGdm/F72MoaxTxYcu?=
 =?us-ascii?Q?LgLbYfKY5uUfphH0U4HUusscOf3Diezxtja4Qk+8e2RMAy1hVb1HPOssbXx+?=
 =?us-ascii?Q?kgNuAZhwPQo7Kb92+NJXk2cqModPL2BEpzNquTaNWa3jrQyMQDs+PLKyLiLD?=
 =?us-ascii?Q?NdHuAtiIh+8gzgsVhvQCZN9HrMcvtj7DIpIfvx6UvwB16cSJvxPeRQGXE5Td?=
 =?us-ascii?Q?X2W4k/V4M/Ii3cnqXmCPOdyV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9bd335-d6a1-428b-95b6-08d91ff7ec4a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 03:39:53.2644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ze0lND9hvtHpv8VtGw49YvrLRf3XnHd5Ope5zx63Cvq9p+jCM4Svy3JJcg52A0yKLd4P/scKp9Ue7qvLaCpjm9FE3igMuicQG4ClwecsHRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=935 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260022
X-Proofpoint-ORIG-GUID: BmZYrBQwCMJjR72WYQ0gykXW9BJe3c27
X-Proofpoint-GUID: BmZYrBQwCMJjR72WYQ0gykXW9BJe3c27
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Suganath,

> During IOC initialization driver may observe some firmware faults.
> Currently the driver is not handling the firmware faults gracefully,
> most of the time the driver is terminating the IOC initialization
> without trying to recover the IOC from the fault. Instead of terminating
> the IOC initialization, driver has to try to recover the IOC at least
> for one time before terminating the IOC initialization.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
