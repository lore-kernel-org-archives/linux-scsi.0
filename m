Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EECC47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 18:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D793613D7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 18:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFCShG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 14:37:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCShG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 14:37:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153IOUJG013264;
        Thu, 3 Jun 2021 18:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=x/ZCsS/kzLTuuHsSoP1iT8cWra+OEHjoa8xhrqHJAmg=;
 b=tTyzuxpvJvhDlvVFYz6mCB9yikSg54SGSb394o5lDkWW+8brL5x3IIAJBCqGq56rdGtm
 pDaV/XY0D082tbfRzc2WbFLYsj3bi5ZCC/dS7EwIFE8B/Xx6/UmDLEXOHEg8xJI5OIz9
 93i0b2IRLPkCZ5jhcrXcMHX4Yly87b2tbOJQEwmawHnM5DAOlWDi3SUOlmrMHA79UE6s
 pMLIJ7+x5sp3Inizbuwl7VClO90RPz8Q0JcRKaCi7ddRtcwSv0GyB7jhPHzaZ7goa1Bs
 KHI2cs7iAD/clS1R/UBIWb2e+0zIHXEQl9CmkJ9z79Suys8jsTQzw9KVwrR+dYqSi4kC iA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38udjmv53x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 18:35:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153IQk0c152176;
        Thu, 3 Jun 2021 18:35:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 38x1be57b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 18:35:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akTa3o+4OpEOh0XbRbuvSmKYJQy3dJ6smj3WpQovbP5OyQeXPFwUvXl4i/7pRkjIc3M7HX5FTVyH9Pb7sJ2uYygr+N0nzPYqQaTJmJHYjG0hINpdKVor0sMlq7qyklHCZrtn5F1cjltWHBD6ELZmoUl+97jfJGWz6Zk14X1EX4J7iqy3au9SP67/xt7GaA0ZA8uHAG6eLEdPVu74klGYRfJLi7ukWiBP/exKq7PP6Tj8+M5VGRltqSXit3kNx8nLg8l5c4qWNfUIOjMdourAfZjOjT1AuzRzUbk4eew5LUf0KpyyNUmeP6PEcRte9a5ZCzgv2LwDgcrsiAP1UR/isA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/ZCsS/kzLTuuHsSoP1iT8cWra+OEHjoa8xhrqHJAmg=;
 b=RT6BgD4vfAPPCN9LemNUzNTyMlT36jYZk8259OM4WTsg3Rd72E9YSZqld8SkYaADWG9+BwdaAqBAaALw5Sz6CRr/T8Id4jfXX9PHMSFU/C5zWxh/+B5D+q8OQ8SYb1V2GUqOkMPiTP4CbDr4HP7dh+dctqKpULoRTre1+I1Mcv10NHE071YsV2icJmTLE+CBTxCg2QTpH3/0mSJzJBMMyu6nrOtDEwQ3YarnvA0/t+j6nBU4WvTjyGK84MAecUgoK+EpPleTJD0eUtv69Lq73FQWxxt3KXFFXYYBUef4x5YvIKtNaghkatNRS2thD/rQWiIsQ6XGsNczkIM9+Gg3RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/ZCsS/kzLTuuHsSoP1iT8cWra+OEHjoa8xhrqHJAmg=;
 b=uGcPpPNjYZJ0puxtt0h3E9ONEyGoU80r7TJX5VxF2kCcjUb6kge5e39aUPc1XjwBFOUkdO9SqC1CwqwK4XXV4O7yLz/fJB3YdmuuXHPwq9gXwzHnPewdlQqI5cH8/UzirV1/C8tAX3WUd7eK6+Ubc2J6r/+bds2h3uI0OETDmog=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2909.namprd10.prod.outlook.com (2603:10b6:805:d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Thu, 3 Jun
 2021 18:35:16 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 18:35:16 +0000
Subject: Re: [PATCH v2 02/10] qla2xxx: Add getfcinfo and statistic bsg's
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-3-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <9d265473-0e14-eeb8-d5ce-558daf8b2ffa@oracle.com>
Date:   Thu, 3 Jun 2021 13:35:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210531070545.32072-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SA9PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:806:21::20) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SA9PR13CA0015.namprd13.prod.outlook.com (2603:10b6:806:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Thu, 3 Jun 2021 18:35:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 164a7aec-fddb-406b-85b3-08d926be54fb
X-MS-TrafficTypeDiagnostic: SN6PR10MB2909:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2909FA00EA24D820ADF5E0CFE63C9@SN6PR10MB2909.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:242;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kGvZlCEDvZs6wyrJ/yLqYQkAEH0Mg6sJ8QtVjuDG4E8g6buvq23sghazWsFYIYQz13DxokdpUYXMr73a5mhbLU0ymprF8QuxE0RlbtW+nOKsDKtF+Wlbbe0uddsfogwgsuoyWwHXt/U/DaxDt01w9/oHFENosuIbz8ITHDyXNHBw70Oyk0tt+efHLAgdHmT2BDvSTZxmQzFEk+vOXl0bowEHnHbl16MH+CPDHreUS+ov6eaDGs2N0CNkQg9UUe9w2cBa8oOR0pfmG5nWE4dpOTmjwM6nnGl8KBw4ti46ek6Tw0xRWGe+Ew5nNA19jtA/Fo1Ls8c/gnZOPPB/GwcozMqdxdwjQOxnuIf07WiR3WSQq2trGkYb3ZsfpjXKObY0NECjJMJyWjUffUR9uchBPQtss9VQ2wxvH60OKw/Ircj7GgNM2xh08/I98gyoot7xNhi+Exe43ErdZ84D4YGe6ngrelk3KVWQIxWIcirEsDd3YWyUxFQkQ5RaWFGEqcbY9i7DvFv5WDU+Hqx3TsxHOzPDvGyhjllbr4BdQ0uFGAem76zq5r5DZMhHVd57CVu4J0urpEhI4tah3ZPzmfi38BRQEjyCvpfTEpzVbDqKsdmfqWjV9twpWZ8rt2gfnhHXpXGp/oyYD/UwFc+RtXMnnL3IsrYy3a/IHNMBF3nkuIQiy/LcVxy3sTEGCphE2NSX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(136003)(396003)(376002)(6636002)(66556008)(66476007)(66946007)(16526019)(2906002)(83380400001)(186003)(86362001)(31686004)(36916002)(4326008)(31696002)(44832011)(8936002)(36756003)(5660300002)(26005)(53546011)(2616005)(8676002)(956004)(6486002)(38100700002)(478600001)(316002)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TllwZmEyTWMwZnlseFhuNDlTdXpmUTZCSXhidkhJVmd4TllGT3hrYmRRUWJr?=
 =?utf-8?B?ckdEWUpnRHRRQzNDV1BXbW9JRG1lWnoyTDlIbU5uQlR6c2lyM1ZMaFdERytQ?=
 =?utf-8?B?M1YwOTMxUjRnN09YWmNWUVdHRG95bDVTN3JVUzhjS2lXYnlVa3ZPQ3M5OU02?=
 =?utf-8?B?akJ4anNlT3NNR3p0Z2JOdTl2ZVV0R01haXpPK3hSRTl6RENVUUVlTmhOU2tl?=
 =?utf-8?B?M1QyeHNhMGRQUnM3dE1WeFdKaWFacGJJV0hGaHBtanhGUnpvd2F6aThONnMv?=
 =?utf-8?B?M1FRUkxIRjFLdHY5YWtVZzhlczdOSWZJZ2gvZGsyUjZldGtNek1XOHYwUkhw?=
 =?utf-8?B?ZDdHdFBERGV1M1NjbHoxd2QyR0M1STZPNlRWUVY3Y2ZFWG80VEI4V3VXdnBR?=
 =?utf-8?B?dVFGQUlqUDNORVh5UnBYRis4aGNkWGJJdW5FMCtmVmhvNnNDcmsxbUFBM0hh?=
 =?utf-8?B?RElTRG1adTloM05ESHVyOEtXUmpRQTZKTys1eG05OFloODROTUd3NzlhUUV0?=
 =?utf-8?B?YTczTjJ4OTJpR05iZ2hNaXhpVnJWZUs0aGVnR2FWbTlpL3RSUXd6dFM2Um10?=
 =?utf-8?B?Vk5zMDI5MEtzeFBjOFNPRjB4Mkt5Q21CVUk4WGlsUFV1SWgwVDBZUE9wQW1J?=
 =?utf-8?B?cWU5U2Q0ZTRRY1ZEOVFmNURiNWh0dWs1TzRML0NVN0sxT2NLbXNTTVBtUHh4?=
 =?utf-8?B?cXZuT2k0UmlQTmR3bXZ0NU9xVTRUcTkwcVEremlScVc3N2FMNnl3MEZCNzN1?=
 =?utf-8?B?UmxTRGlCc3NQNlhoRjF3dGdieTRuUlYreUxKRzJUcHBGZ25lRnNoT05sZVRk?=
 =?utf-8?B?ME5CdGQyRFhlRkgzcTFnakJlVVNMWWpEK3Rmai8wWjF4TmtCSEFiNkdTK0lD?=
 =?utf-8?B?SnJUR0hXM2JUYlFtSDNDTkVSWGVLTk9qb096WUc5RElUaCtIM2ZMcTF3czVO?=
 =?utf-8?B?UVppcnZ1dEdLSWduR3BuSGNVbnczdzhxcmFWbVpHaTZFaHJnR3hMN0tWOWUr?=
 =?utf-8?B?Nm9salAvdTdIdTdJLytXWWN4aWE1Q1FBaVpiVCtVVGdRbXJsbHJmWTVJM0hO?=
 =?utf-8?B?SHJQWGdyMlQwZHRjUWdGZERlcDZvTGNTZWdBUXJUcmpFcUR3cjA3UG94eDc4?=
 =?utf-8?B?Z05aYmZsUStOYXVDMi9VR2pGNHlWcWEvdHgweUlBNzlZem9qZU5OTCtFOVlB?=
 =?utf-8?B?ZVRualR5RExPWE9ONzFsKys4cE8vM3hVMmJzNzJ0MzRRczNhWTFiZkRoSit3?=
 =?utf-8?B?UzJHdGVkNDZLejhTMzhrVW5yZlRYWTZNbjBkREMrWHRibmpLQ0VQTUFNM2Ni?=
 =?utf-8?B?YmVNRVFwQmZjbE9CcllrNFhzOW4yL0QyMlNuMXJXUkRkK2ZlbFBtUGd0TkVL?=
 =?utf-8?B?b2hpUVJ1MERiTDU5NlhFWkhGZkhwL2hmc1lic1labkZzUHpPc2xNYnh3QWNt?=
 =?utf-8?B?em9sNHE4V0ZxQUFwUjZFdDd2a1c1enArQjVWZFp6WGJLTGUxK2l6THM1UTgz?=
 =?utf-8?B?ZEI4dkRPWjNlNHFhQkczb3ZFcm5mVS9XbG96YnN5VkorSHdVd25mSW56UEty?=
 =?utf-8?B?M0VTWlRGR1BFNXM1VmlJZHp1eElWclNvalN5d3NpLzFmeWRoNzF0MzBtR0RD?=
 =?utf-8?B?bjVTbVpkc3kwUzIwSDM4MGFUeUp5czZIejJOamxjVmN6QWxZQk9yd2s2NDVn?=
 =?utf-8?B?VXJkcFBaMEVsSXlEUDBDbzdhR09vQ1dMMCtMOWxmYjJtZndPTFZGaVJNSjhW?=
 =?utf-8?Q?M801ASj6dKwlvUIu3BYYdbE8JVKqNJjM7OfswOj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164a7aec-fddb-406b-85b3-08d926be54fb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 18:35:16.2216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjOrnKmZy7w+K+DM6iIi55NFPGCBxYaXiUfxpOQS9b3B+JF1wnPjL5G5zjr3kQYVEPdD4aDKCaaumviRTdKY33EYeQqnxNm/MGIo2qmtEGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2909
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030124
X-Proofpoint-GUID: C6ClWkqssZXOmpdAzxmtAxwciIY3pSOW
X-Proofpoint-ORIG-GUID: C6ClWkqssZXOmpdAzxmtAxwciIY3pSOW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030124
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/31/21 2:05 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Latest FC adapter from Marvell has the ability to encrypt
> data in flight (EDIF) feature. This feature require an
> application (ex: ipsec, etc) to act as an authenticator.
> 
> This patch add 2 new BSG calls:
> QL_VND_SC_GET_FCINFO: Application from time to time can request
> for a list of all FC ports or a single device that support
> secure connection. If driver sees a new or old device has
> came onto the switch, this call is used to check for the WWPN.
> 
> QL_VND_SC_GET_STATS: Application request for various statistic
> count of each FC port.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  |   2 +
>   drivers/scsi/qla2xxx/qla_edif.c | 182 ++++++++++++++++++++++++++++++++
>   2 files changed, 184 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index ac3b9b39d741..9c921381d020 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2574,6 +2574,8 @@ typedef struct fc_port {
>   		uint16_t	app_started:1;
>   		uint16_t	secured_login:1;
>   		uint16_t	app_sess_online:1;
> +		uint16_t	rekey_cnt;	// num of times rekeyed
> +		uint8_t		auth_state;	/* cureent auth state */
>   		uint32_t	tx_rekey_cnt;
>   		uint32_t	rx_rekey_cnt;
>   		// delayed rx delete data structure list

seems like widespread issue during this patch series.. please fix comments

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index 38d79ef2e700..fd39232fa68d 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -258,6 +258,182 @@ qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>   	return rval;
>   }
>   
> +/*
> + * event that the app needs fc port info (either all or individual d_id)
> + */
> +static int
> +qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t			rval = 0;
> +	int32_t			num_cnt = 1;
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	struct app_pinfo_req	app_req;
> +	struct app_pinfo_reply	*app_reply;
> +	port_id_t		tdid;
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app get fcinfo\n", __func__);
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &app_req,
> +	    sizeof(struct app_pinfo_req));
> +
> +	num_cnt =  app_req.num_ports;	/* num of ports alloc'd by app */

extra space after "="

> +	app_reply = kzalloc((sizeof(struct app_pinfo_reply) +
> +	    sizeof(struct app_pinfo) * num_cnt), GFP_KERNEL);
> +	if (!app_reply) {
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		rval = -1;
> +	} else {
> +		struct fc_port	*fcport = NULL, *tf;
> +		uint32_t	pcnt = 0;
> +
> +		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> +			if (!(fcport->flags & FCF_FCSP_DEVICE))
> +				continue;
> +
> +			tdid = app_req.remote_pid;
> +
> +			ql_dbg(ql_dbg_edif, vha, 0x2058,
> +			    "APP request entry - portid=%02x%02x%02x.\n",
> +			    tdid.b.domain, tdid.b.area, tdid.b.al_pa);

port id can be printed as %06x and tdid.b24

> +
> +			/* Ran out of space */
> +			if (pcnt > app_req.num_ports)
> +				break;
> +
> +			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
> +				continue;
> +
> +			app_reply->ports[pcnt].remote_type =
> +				VND_CMD_RTYPE_UNKNOWN;
> +			if (fcport->port_type & (FCT_NVME_TARGET | FCT_TARGET))
> +				app_reply->ports[pcnt].remote_type |=
> +					VND_CMD_RTYPE_TARGET;
> +			if (fcport->port_type & (FCT_NVME_INITIATOR | FCT_INITIATOR))
> +				app_reply->ports[pcnt].remote_type |=
> +					VND_CMD_RTYPE_INITIATOR;
> +
> +			app_reply->ports[pcnt].remote_pid = fcport->d_id;
> +
> +			ql_dbg(ql_dbg_edif, vha, 0x2058,
> +	"Found FC_SP fcport - nn %8phN pn %8phN pcnt %d portid=%02x%02x%02x.\n",

fix indentation and port id can be printed as "%06x" with fcport->d_id.b24

> +			    fcport->node_name, fcport->port_name, pcnt,
> +			    fcport->d_id.b.domain, fcport->d_id.b.area,
> +			    fcport->d_id.b.al_pa);
> +
> +			switch (fcport->edif.auth_state) {
> +			case VND_CMD_AUTH_STATE_ELS_RCVD:
> +				if (fcport->disc_state == DSC_LOGIN_AUTH_PEND) {
> +					fcport->edif.auth_state = VND_CMD_AUTH_STATE_NEEDED;
> +					app_reply->ports[pcnt].auth_state =
> +						VND_CMD_AUTH_STATE_NEEDED;
> +				} else {
> +					app_reply->ports[pcnt].auth_state =
> +						VND_CMD_AUTH_STATE_ELS_RCVD;
> +				}
> +				break;
> +			default:
> +				app_reply->ports[pcnt].auth_state = fcport->edif.auth_state;
> +				break;
> +			}
> +
> +			memcpy(app_reply->ports[pcnt].remote_wwpn,
> +			    fcport->port_name, 8);
> +
> +			app_reply->ports[pcnt].remote_state =
> +				(atomic_read(&fcport->state) ==
> +				    FCS_ONLINE ? 1 : 0);
> +
> +			pcnt++;
> +
> +			if (tdid.b24 != 0)
> +				break;  /* found the one req'd */
> +		}
> +		app_reply->port_count = pcnt;
> +		SET_DID_STATUS(bsg_reply->result, DID_OK);
> +	}
> +
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +	    bsg_job->reply_payload.sg_cnt, app_reply,
> +	    sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) * num_cnt);
> +
> +	kfree(app_reply);
> +
> +	return rval;
> +}
> +
> +/*
> + * return edif stats (TBD) to app
> + */
> +static int32_t
> +qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t			rval = 0;
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	uint32_t ret_size, size;
> +
> +	struct app_sinfo_req	app_req;
> +	struct app_stats_reply	*app_reply;
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &app_req,
> +	    sizeof(struct app_sinfo_req));
> +	if (app_req.num_ports == 0) {
> +		ql_dbg(ql_dbg_async, vha, 0x911d,
> +		   "%s app did not indicate number of ports to return\n",
> +		    __func__);
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		rval = -1;
> +	}
> +
> +	size = sizeof(struct app_stats_reply) +
> +	    (sizeof(struct app_sinfo) * app_req.num_ports);
> +
> +	if (size > bsg_job->reply_payload.payload_len)
> +		ret_size = bsg_job->reply_payload.payload_len;
> +	else
> +		ret_size = size;
> +
> +	app_reply = kzalloc(size, GFP_KERNEL);
> +	if (!app_reply) {
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		rval = -1;
> +	} else {
> +		struct fc_port	*fcport = NULL, *tf;
> +		uint32_t	pcnt = 0;
> +
> +		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> +			if (fcport->edif.enable) {
> +				if (pcnt > app_req.num_ports)
> +					break;
> +
> +				app_reply->elem[pcnt].rekey_count =
> +				    fcport->edif.rekey_cnt;
> +				app_reply->elem[pcnt].tx_bytes =
> +				    fcport->edif.tx_bytes;
> +				app_reply->elem[pcnt].rx_bytes =
> +				    fcport->edif.rx_bytes;
> +
> +				memcpy(app_reply->elem[pcnt].remote_wwpn,
> +				    fcport->port_name, 8);
> +
> +				pcnt++;
> +			}
> +		}
> +		app_reply->elem_count = pcnt;
> +		SET_DID_STATUS(bsg_reply->result, DID_OK);
> +	}
> +
> +	bsg_reply->reply_payload_rcv_len =
> +	    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +	       bsg_job->reply_payload.sg_cnt, app_reply, ret_size);
> +
> +	kfree(app_reply);
> +
> +	return rval;
> +}
> +
>   int32_t
>   qla_edif_app_mgmt(struct bsg_job *bsg_job)
>   {
> @@ -304,6 +480,12 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
>   	case QL_VND_SC_APP_STOP:
>   		rval = qla_edif_app_stop(vha, bsg_job);
>   		break;
> +	case QL_VND_SC_GET_FCINFO:
> +		rval = qla_edif_app_getfcinfo(vha, bsg_job);
> +		break;
> +	case QL_VND_SC_GET_STATS:
> +		rval = qla_edif_app_getstats(vha, bsg_job);
> +		break;
>   	default:
>   		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s unknown cmd=%x\n",
>   		    __func__,
> 

-- 
Himanshu Madhani                                Oracle Linux Engineering
