Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01BBC07E94
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 12:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87964610C7
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 12:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhFDM6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 08:58:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45836 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhFDM6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 08:58:05 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Cngbf020580;
        Fri, 4 Jun 2021 12:56:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dRrucjQRR7jZU25y+A5OSG02xctV5D39iNAN4U2CTRo=;
 b=sdTiopMrmJ/aVK0cSwIYqqyvFEPNVAUogIBcLca26ktT1Z/bRSfVwWZEADn6XxD/mmef
 Yjc8KlMBODPYSUwOxiNFgF8XoEBtpgfi8P8ZjAfpznCc3g33hDI/+c33o5KnJ0Hsvijs
 T7eMQ2hwDIjV7al9/RzYZWWB5lOxJK7XohlkAxVvcMGFKHzfsHiiP5VxpBLp7UW6C5b3
 FNwCubgDcRVaydUJX1NffAmRhKH7kDr8CFfI4O7PnzMOONHX3cyjtaJsa706QKsRUR7/
 r4+gYgL8SghRJXnxU+k0ipA913vP+aa69AF+wUmjVaJ59cDzBtLUMz46DHRBCxXl1nbT Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38ub4cwxw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 12:56:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154CnaKd045469;
        Fri, 4 Jun 2021 12:56:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 38xyn3h1vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 12:56:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1BHs6PgeZuteJGysnka9c5hu45MAM9f2YJEWjG+E7w6/rtGrFZAiWYdLvcFTXxR4kUdXS1IgCSeyt00Zhe+nMIIwwz/etW9ITTbd7MMzuwSI+XPoXe6wLcXnceUhcPXX59zsSJV5biKbnl/Hy2pacpXguWs7Ag+p1xfDIyaCTdECzvTgBflrN6zY4GFD9/6rU1WlSJTq+/1efIsTJijw1eTZFRIZQWfhCsvDF+4qkMqX4BpUCepopfRY3RQC2BCmd/b/9ryCwpsInhE13V5L15UIM11rJ3iPUtchuJIVKcMUdAxfxIwZQQ2unAkuvbmo/beQrXaaMungdCG7bI63w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRrucjQRR7jZU25y+A5OSG02xctV5D39iNAN4U2CTRo=;
 b=ZRIXtddycuhzKihnKyngSSWJAtoNjb04TRCBudn34m3htsUOU/z/6u4okE4ZejKxodCjXmK7Th0G2AzEiZbc0Y2zS/wLo4uimW0FCH+zaV6ujITNbP8OEJl6cbUwd4DkFjCO0kYpnUUNrOk4P+Us08bScA6LEMPRa0utPUMKr1b1MBaxstuU6uTSV/Z2Wa7B4H6ATIZw0RPHyFmDkuoPj5knMOWQLQ758g3L+vj1KvXZH2udPhJXzmIy15ZA4IHNt2alckO3q0K2ULMuLeVkPlOWmAoFnhYABTDuQ1xy7PLnhOmctyMlRHi3cFfCW2Ijx6RA7534m61G11B33rASuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRrucjQRR7jZU25y+A5OSG02xctV5D39iNAN4U2CTRo=;
 b=B4qDA1uTiC4YZDjep5TaJy+kywxxU1ccEmC/88O0du8hvqAqccxiK2Noo4wTQ9jLcxPmQhU2Zxj7f9+fqJAyi4I9yXFm5ZNb0UoJcHGbfI9Efn5qIpiVkRqhPre7g51Sl8CzYZG++Qz0+9WmgeCq5oJwgl9C0O6IIQtuH3ku1DE=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2720.namprd10.prod.outlook.com (2603:10b6:805:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 12:56:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 12:56:15 +0000
Subject: Re: [PATCH v2 06/10] qla2xxx: Add authentication pass + fail bsg's
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-7-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <a42b4a32-26a4-2d87-fcc0-c1e626602007@oracle.com>
Date:   Fri, 4 Jun 2021 07:56:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210531070545.32072-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SA0PR11CA0047.namprd11.prod.outlook.com
 (2603:10b6:806:d0::22) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SA0PR11CA0047.namprd11.prod.outlook.com (2603:10b6:806:d0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Fri, 4 Jun 2021 12:56:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 648fa54a-c6d8-4699-999c-08d927582318
X-MS-TrafficTypeDiagnostic: SN6PR10MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB27202E79C6CF007D9A92A0B2E63B9@SN6PR10MB2720.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:159;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: krnrEMeLUJU99U2hl6mVKpgTgIfa6RnG9JImGcjajuLMXvO1aikVQQF369P9Jej1T4u6aK1M4OTkTGDizEfSgbQbrieF7zwRANd6QbeqtSUY97Q+pHuAmqVWZVoLISzuKYwn4cpwFBF9Kg19cPVK4J9JpjYiN5CcnoeCXpORbZV9JxTCuMI3Qn3LcbG0EujnhvEKccbVVQqTfGjAK36/fHytM85yplllxZlx2CbAVnLwPO1AYl0JrpSZ7gL7y8nKUqm90ihB9c/AZbqUqqHNkx84KCtQF77WQp/Etydf4g1gDljhKYPcYVNJlZUR73BmkQMf0de+UCJGKMLcT3hQ3UJU9+4MUyWSMfbsyflpJfGAtDUCmM5DjYf08/A1utdTk7IlGu9sLGGQd+zUaSyI7sOG/EvISOHXprpiyfVl8SyiK0syvlbFABsx+VujxTnYRFwPdDLzmxZmKnnRYhTT7S07KdsYr0yowT9J1BxSdNs4AULAHyXxT4wWZG8k7NfHDg6fqsh9Cq9NZW6tpCb5EKwv8x2YakTDpID9fErdWCsMurYaPiwoC4s645itS2QeeBg7vFL2+TL0jG2Rm7hBYZLvuoJ9C2TdYMI/eYzDnxci6C6HeISoFMzmFVmd4YBwoUDuH4pmIMS8qh/IyinvUvevrfl99PhLpIP8Q49ZeXikrNyNTZTsPCajyVdsdoMT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(366004)(136003)(31696002)(86362001)(2906002)(66476007)(66946007)(66556008)(16576012)(6636002)(44832011)(30864003)(478600001)(31686004)(956004)(186003)(16526019)(2616005)(316002)(5660300002)(36756003)(8676002)(6486002)(38100700002)(36916002)(83380400001)(8936002)(26005)(53546011)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M21tSzNBWHlmVFpRMU0xV1AyME5uS0VFcEJNTUtpWWlGcUN1UFU4NzB3MXht?=
 =?utf-8?B?aTk5SG1ablZQa3FMMkp1elQvdGZDcVEzWlVKeWJSaFlhcGtJZW9qZVoyc1Qr?=
 =?utf-8?B?TmNxUGJtR253dTBZeFQ2WU1WMXBmN3dJVEhOWkhEYncrR3dQZXA1SXA0VUpX?=
 =?utf-8?B?NGFHRGRMRVhXemV6VmlXdWcvREdVMFdRRjBBNzQvV3BmMWh3ODh3Z1o2SE5k?=
 =?utf-8?B?b2lsc1N0dVJtMmtJZjBKUHREOUxPSzl4bFlsbUJkU1lKbWw1a0xiUG84bFZ0?=
 =?utf-8?B?NFRMLzVCVGJWR2M1M1ltQlBsMzNRTENpQjZFYjRtb2l0QTc0N1BuZEpWZXFY?=
 =?utf-8?B?UE01enhVbnl0VXJzNHBTckVRTU1lSzlCYW9TNXN0UWwzV0pSS0M4LzdCR09l?=
 =?utf-8?B?RXZLZDdFU1RTSHByWXdkRTdURkdZakhMYitkMjQrcm40YUZKeXhoOXo0Z2hH?=
 =?utf-8?B?ZU5lNW16S3N3RTJ3Yy95N0kzVDlXUk1yTU0zaW1WRUxYbkZ3ZTVLUi9uN3VX?=
 =?utf-8?B?Umtmdm1qbTVyQUx4SDA0eGtKcUR6TVhueXZhSDhDb1Y1a0VCL0Yxc0JRU2ho?=
 =?utf-8?B?S3dnUit6UHJBL1d0WWl0OTFnUGh2WnYxOXBIQmViQmZrajhMcDdXRHRENnI1?=
 =?utf-8?B?cUJkRXlOUk5Ybk9jL3B4eXVQTjBiMFB1ZHE1OWRGV21vZ1JQa05SbWM1NVc5?=
 =?utf-8?B?U0tRM3hGemNGbWRrRGFpcTQvVlA3ZUdNTkJkVXpzT0xQVExUQlZJaTZBaVd4?=
 =?utf-8?B?N0J3RzZUT0ZrckMrUVg0UjB1T3JpbFV5QllNdzBYVEtHZGRENUY5ZVZEUEFU?=
 =?utf-8?B?V21Qd01VaENrR1FIeStVSDFwaHhmNndzaWluOENIdWIxREFJVC9HUy9VV2hZ?=
 =?utf-8?B?a3h6dmV2bU1jL2tjNEpYNHBhREIraEhKWVNWTXF5THNYOEFjZmQ4dHlpUVZq?=
 =?utf-8?B?ejF0em9CR1E4MnZ2K3Fra0ZUSVY3MDBtak5JZnppWVV2ZUdIUXVlMy9KVkNj?=
 =?utf-8?B?b3hObm1Fd3RBdDZ4Q0pBQyt1U1ZOY1RQbXpNWE8xSnBiVkZtOGNZdWE5K1Bj?=
 =?utf-8?B?ZjkxNVpmWTNZTUJUbnMrSlY4eVU1UHNVZUFBV1FBdTcxYXdqcDQvMS9LS3I5?=
 =?utf-8?B?am42aUkzdDB6anM4M3FiVmJGU2pFdzVNWXJvNzRNc0FkMTE5MGtQYkJKdDMz?=
 =?utf-8?B?SlJSbGRSMDNYdGdJWjhpR2FVeEhqYXFiRzJmdDRTOXZ3K01vajM1d2VSS0h1?=
 =?utf-8?B?b2pzRzVVM3ZkbnFsbnNZaFVpUk44M1I0VjE1R1ZaOUR3eXRqSWVULzhPbER4?=
 =?utf-8?B?anZyaGVUNjE0SnQvQURHUnM0KzFZemlTZURCU0FyK0pjQ2xtQmc2ZXVQSFZ5?=
 =?utf-8?B?TXVlbTRBNlpOYnBCTlgwRlFvM3NUeUdWSjZVaE1hT3dmTjYrUVZNalVsbFYy?=
 =?utf-8?B?bkttOWE2SUM1dEU4Y2tZZWRSOW02MTB5OVdkazl0bnVJMHR0QkZhUGRQRnM4?=
 =?utf-8?B?ZVdyNVdIZjVkR1A4RFNaL1pHVDJzWEtnUk1IT0JrRFRlaGtQd2tIZlBFb0x4?=
 =?utf-8?B?Rjg0a2k5NDhHMjJtUGE3eVBjNjUvRUpOTkE3Ujk2UGVhMnA0MHpXeGthK1U3?=
 =?utf-8?B?VUJSaE1Nc2xuZEhWZjJFTmhmNDkvaHpBQkJ5NjRoZ1pHMXczQ0NpQVlEaXAz?=
 =?utf-8?B?L0dRL2xONXdobXlja3hBR1FKeS9kR01Ndm1JdkFRb1FKcDJBb0dEQkxwOHRU?=
 =?utf-8?Q?OMGhoWEtKUIJ6EMwgT8iWPeV0yLErbqBfdSen6c?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 648fa54a-c6d8-4699-999c-08d927582318
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 12:56:15.0423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39YyGNxu2VHokzPlZO6elojjDNHc6LEP4radMblgzAQbcwCycLAQEUmpM1YvgoCsiomBW0GpLzlvhEB26SrPnaocLjQXKT5GjodWNH0mqw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2720
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040101
X-Proofpoint-GUID: BAhHzNSd0kLIEiroKyUAWBGN6pk6-qot
X-Proofpoint-ORIG-GUID: BAhHzNSd0kLIEiroKyUAWBGN6pk6-qot
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040101
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
> On completion of the authentication process, the authentication
> application will notify driver on whether it is successful or not.
> 
> If success, application will use the QL_VND_SC_AUTH_OK BSG call
> to tell driver to proceed to the PRLI phase.
> 
> If fail, application will use the QL_VND_SC_AUTH_FAIL bsg call
> to tell driver to tear down the connection and retry. In
> the case where an existing session is active, the re-key
> process can fail. The session tear down ensure data is not
> further compromise.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_edif.c | 214 ++++++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_gbl.h  |   1 +
>   drivers/scsi/qla2xxx/qla_init.c |   3 +-
>   3 files changed, 216 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index 4c5cc99bdbd4..c86d64512702 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -661,6 +661,214 @@ qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>   	return rval;
>   }
>   
> +static int
> +qla_edif_app_chk_sa_update(scsi_qla_host_t *vha, fc_port_t *fcport,
> +		struct app_plogi_reply *appplogireply)
> +{
> +	int	ret = 0;
> +
> +	if (!(fcport->edif.rx_sa_set && fcport->edif.tx_sa_set)) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911e,
> +		    "%s: wwpn %8phC Both SA indexes has not been SET TX %d, RX %d.\n",
> +		    __func__, fcport->port_name, fcport->edif.tx_sa_set,
> +		    fcport->edif.rx_sa_set);
> +		appplogireply->prli_status = 0;
> +		ret = 1;
> +	} else  {
> +		ql_dbg(ql_dbg_edif, vha, 0x911e,
> +		    "%s wwpn %8phC Both SA(s) updated.\n", __func__,
> +		    fcport->port_name);
> +		fcport->edif.rx_sa_set = fcport->edif.tx_sa_set = 0;
> +		fcport->edif.rx_sa_pending = fcport->edif.tx_sa_pending = 0;
> +		appplogireply->prli_status = 1;
> +	}
> +	return ret;
> +}
> +
> +/*
> + * event that the app has approved plogi to complete (e.g., finish
> + * up with prli
> + */
> +static int
> +qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t			rval = 0;
> +	struct auth_complete_cmd appplogiok;
> +	struct app_plogi_reply	appplogireply = {0};
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	fc_port_t		*fcport = NULL;
> +	port_id_t		portid = {0};
> +	/* port_id_t		portid = {0x10100}; */
> +	/* int i; */

remove debug code

> +
> +	/* ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app auth ok\n", __func__); */
> +
move to verbose bit or remove this

> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &appplogiok,
> +	    sizeof(struct auth_complete_cmd));
> +
> +	switch (appplogiok.type) {
> +	case PL_TYPE_WWPN:
> +		fcport = qla2x00_find_fcport_by_wwpn(vha,
> +		    appplogiok.u.wwpn, 0);
> +		if (!fcport)
> +			ql_dbg(ql_dbg_edif, vha, 0x911d,
> +			    "%s wwpn lookup failed: %8phC\n",
> +			    __func__, appplogiok.u.wwpn);
> +		break;
> +	case PL_TYPE_DID:
> +		fcport = qla2x00_find_fcport_by_pid(vha, &appplogiok.u.d_id);
> +		if (!fcport)
> +			ql_dbg(ql_dbg_edif, vha, 0x911d,
> +			    "%s d_id lookup failed: %x\n", __func__,
> +			    portid.b24);
> +		break;
> +	default:
> +		ql_dbg(ql_dbg_edif, vha, 0x911d,
> +		    "%s undefined type: %x\n", __func__,
> +		    appplogiok.type);
> +		break;
> +	}
> +
> +	if (!fcport) {
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		goto errstate_exit;
> +	}
> +
> +	/* TODO: edif: Kill prli timer... */
> +
> +	/*
> +	 * if port is online then this is a REKEY operation
> +	 * Only do sa update checking
> +	 */
> +	if (atomic_read(&fcport->state) == FCS_ONLINE) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911d,
> +		    "%s Skipping PRLI complete based on rekey\n", __func__);
> +		appplogireply.prli_status = 1;
> +		SET_DID_STATUS(bsg_reply->result, DID_OK);
> +		qla_edif_app_chk_sa_update(vha, fcport, &appplogireply);
> +		goto errstate_exit;
> +	}
> +
> +	/* make sure in AUTH_PENDING or else reject */
> +	if (fcport->disc_state != DSC_LOGIN_AUTH_PEND) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911e,
> +		    "%s wwpn %8phC is not in auth pending state (%x)\n",
> +		    __func__, fcport->port_name, fcport->disc_state);
> +		/* SET_DID_STATUS(bsg_reply->result, DID_ERROR); */

remove debug code

> +		/* App can't fix us - initaitor will retry */
> +		SET_DID_STATUS(bsg_reply->result, DID_OK);
> +		appplogireply.prli_status = 0;
> +		goto errstate_exit;
> +	}
> +
> +	SET_DID_STATUS(bsg_reply->result, DID_OK);
> +	appplogireply.prli_status = 1;
> +	if (!(fcport->edif.rx_sa_set && fcport->edif.tx_sa_set)) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911e,
> +		    "%s: wwpn %8phC Both SA indexes has not been SET TX %d, RX %d.\n",
> +		    __func__, fcport->port_name, fcport->edif.tx_sa_set,
> +		    fcport->edif.rx_sa_set);
> +		SET_DID_STATUS(bsg_reply->result, DID_OK);
> +		appplogireply.prli_status = 0;
> +		goto errstate_exit;
> +
> +	} else {
> +		ql_dbg(ql_dbg_edif, vha, 0x911e,
> +		    "%s wwpn %8phC Both SA(s) updated.\n", __func__,
> +		    fcport->port_name);
> +		fcport->edif.rx_sa_set = fcport->edif.tx_sa_set = 0;
> +		fcport->edif.rx_sa_pending = fcport->edif.tx_sa_pending = 0;
> +	}

add newline here

> +	/* qla_edif_app_chk_sa_update(vha, fcport, &appplogireply); */
> +	/*
> +	 * TODO: edif: check this - discovery state changed by prli work?
> +	 * TODO: Can't call this for target mode
> +	 */
> +	if (qla_ini_mode_enabled(vha)) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911e,
> +		    "%s AUTH complete - RESUME with prli for wwpn %8phC\n",
> +		    __func__, fcport->port_name);
> +		qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 1);
> +		/* qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_PEND); */
> +		qla24xx_post_prli_work(vha, fcport);
> +	}
> +
> +errstate_exit:
> +

remove empty line

> +	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +	    bsg_job->reply_payload.sg_cnt, &appplogireply,
> +	    sizeof(struct app_plogi_reply));
> +
> +	return rval;
> +}
> +
> +/*
> + * event that the app has failed the plogi. logout the device (tbd)
> + */
> +static int
> +qla_edif_app_authfail(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t			rval = 0;
> +	struct auth_complete_cmd appplogifail;
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	fc_port_t		*fcport = NULL;
> +	port_id_t		portid = {0};
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app auth fail\n", __func__);
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &appplogifail,
> +	    sizeof(struct auth_complete_cmd));
> +
> +	/*
> +	 * TODO: edif: app has failed this plogi. Inform driver to
> +	 * take any action (if any).
> +	 */
> +	switch (appplogifail.type) {
> +	case PL_TYPE_WWPN:
> +		fcport = qla2x00_find_fcport_by_wwpn(vha,
> +		    appplogifail.u.wwpn, 0);
> +		SET_DID_STATUS(bsg_reply->result, DID_OK);
> +		break;
> +	case PL_TYPE_DID:
> +		fcport = qla2x00_find_fcport_by_pid(vha, &appplogifail.u.d_id);
> +		if (!fcport)
> +			ql_dbg(ql_dbg_edif, vha, 0x911d,
> +			    "%s d_id lookup failed: %x\n", __func__,
> +			    portid.b24);
> +		SET_DID_STATUS(bsg_reply->result, DID_OK);
> +		break;
> +	default:
> +		ql_dbg(ql_dbg_edif, vha, 0x911e,
> +		    "%s undefined type: %x\n", __func__,
> +		    appplogifail.type);
> +		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		rval = -1;
> +		break;
> +	}
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d,
> +	    "%s fcport is 0x%p\n", __func__, fcport);
> +
> +	if (fcport) {
> +		/* set/reset edif values and flags */
> +		ql_dbg(ql_dbg_edif, vha, 0x911e,
> +		    "%s reset the auth process - %8phC, loopid=%x portid=%06x.\n",
> +		    __func__, fcport->port_name, fcport->loop_id,
> +		    fcport->d_id.b24);
> +
> +		if (qla_ini_mode_enabled(fcport->vha)) {
> +			fcport->send_els_logo = 1;
> +			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
> +		}
> +	}
> +
> +	return rval;
> +}
> +
>   /*
>    * event that the app needs fc port info (either all or individual d_id)
>    */
> @@ -887,6 +1095,12 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
>   	case QL_VND_SC_APP_STOP:
>   		rval = qla_edif_app_stop(vha, bsg_job);
>   		break;
> +	case QL_VND_SC_AUTH_OK:
> +		rval = qla_edif_app_authok(vha, bsg_job);
> +		break;
> +	case QL_VND_SC_AUTH_FAIL:
> +		rval = qla_edif_app_authfail(vha, bsg_job);
> +		break;
>   	case QL_VND_SC_GET_FCINFO:
>   		rval = qla_edif_app_getfcinfo(vha, bsg_job);
>   		break;
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index f4a98d92c4b3..236eb610b5be 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -12,6 +12,7 @@
>    * Global Function Prototypes in qla_init.c source file.
>    */
>   extern int qla2x00_initialize_adapter(scsi_qla_host_t *);
> +extern int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport);
>   
>   extern int qla2100_pci_config(struct scsi_qla_host *);
>   extern int qla2300_pci_config(struct scsi_qla_host *);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 97da4ebadc33..bd528c249aa7 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -34,7 +34,6 @@ static int qla2x00_restart_isp(scsi_qla_host_t *);
>   static struct qla_chip_state_84xx *qla84xx_get_chip(struct scsi_qla_host *);
>   static int qla84xx_init_chip(scsi_qla_host_t *);
>   static int qla25xx_init_queues(struct qla_hw_data *);
> -static int qla24xx_post_prli_work(struct scsi_qla_host*, fc_port_t *);
>   static void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha,
>   				      struct event_arg *ea);
>   static void qla24xx_handle_prli_done_event(struct scsi_qla_host *,
> @@ -1191,7 +1190,7 @@ static void qla24xx_async_gpdb_sp_done(srb_t *sp, int res)
>   	sp->free(sp);
>   }
>   
> -static int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
> +int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
>   {
>   	struct qla_work_evt *e;
>   
> 

Other than small nits, code looks good

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
