Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456BEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 16:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24B0261269
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 16:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhJEQGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 12:06:13 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62960 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231513AbhJEQGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 12:06:12 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195FB2aS023948;
        Tue, 5 Oct 2021 16:04:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8vfgu+jGf5dnO5J6Uscfy3Aib2Br/XVPSnrdAQUStxI=;
 b=QFLhMq6dU7/h4+L0xdYidXBHWtCluckkTo0/uFCzvMOU90Glo+fCaakgiaLbZR1SpHWs
 qVZ+p0mrl6iiSn5X6R+MY0662QQGdTzUnHaqPL1sEVCxL8FcJEQ1mk6zdF33aE1kF5mR
 czMiPDZAS9owEqkw4QmPFbHv76dxQtNkNq+3DpzTjGysSxVGk7Qds0ZAe94D01b0urAb
 YDBy6BXTQ13PkScLRlOFWvcvcP66b9LI8DElboPhVBhYJ3IZWbJmPORON3QqRsgdalU9
 96muPHwsusndVbZTQppk6muyFMFxQCCrIALaUdgicDodzDDKX2tmFNT+Hmmos+C9AUG7 uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43gr64c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 16:04:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 195FsgHC161120;
        Tue, 5 Oct 2021 16:04:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3030.oracle.com with ESMTP id 3bf0s6q9qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 16:04:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi2FvhAJg8OwdJmdJQPWaZwWqLAP7o7HXug6rEPo/r9PNovn3I2jA8B9WniU8IeI3Ll1XnI1wgeIasMEuLi61PVDWc0U0+UNZyM/cJQLPC1VgGxyrjp/+ChmqEfG/KGVqJMdMoOhLamcAayVjbrWs9TWvLzMR37ajE+cj1RBhGSkIWU5TlnFujji3FEzCqtaHV3Hj28v6tQg38OnxVPRzwTH+Id1rXfMuggPAP1dLU5l9KwQdSHK+vI8YNtmRW5wt+6YYWbUcf4GEuIcEilURpKmBCXRfE6IdDHtLe476bvVMtUhj5drhZtIkXp2g4n5/Ujnwkdnzmhpz9ptdhOxpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vfgu+jGf5dnO5J6Uscfy3Aib2Br/XVPSnrdAQUStxI=;
 b=gayzeXb8nO0YeYBnOQ51s55Oml4MwGXXl4tPfC8ne+tphcWCzACwIstxC92VS4xOcpqyYcpGV68QTCLZAgmGB3Mmsxz3r6EDmJ1O2vK3UGqPklNMsK0Z4JVgXoPQbIOKYtaaaNpNAFT1T781hYSL4ZA/zwzXVUddwoTMfAPq4B+NNUAC5KjKx9uLvjDZNaq203Ve4pTe+zWjktJlhVTJ4lCRYSP5usta/wYQyJWGrT0OC66coriyGv44Uq1ZQxjejmhXZwoy0yNlNosGyHfnU6HNLaK96y58myWZ9O6iSUFvWOzaaFUi5DM65vE0rA9Ohzg0+UG23WPlHvbDmShjAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vfgu+jGf5dnO5J6Uscfy3Aib2Br/XVPSnrdAQUStxI=;
 b=IFPnYKc1Kgh8qj5RYJnK8i62tjFLaKT4MhLp2rK/goep4GZuQVSGl1DpizqQ+Akzj3RXUfMIwy83balauVjXq0/Jc8E6kuijOjLUHotFMokg8vFg+OGc/4ffy/tJU9NqH4x5sjAqm8tWA6GBVeOlaGjYg4MyBouBD6wSB2PVDHE=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.15; Tue, 5 Oct 2021 16:04:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 16:04:12 +0000
Subject: Re: [PATCH 3/3] target: iscsi: control authentication per ACL
To:     Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20210914100314.492-1-d.bogdanov@yadro.com>
 <20210914100314.492-4-d.bogdanov@yadro.com>
 <2f65a5a4-6296-cd72-b143-1053665fd4b3@oracle.com>
 <380d7926b0b6401fbf6c8e3dac4eb9b3@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <27949fe2-ef29-adc7-ab77-bed4f14cd783@oracle.com>
Date:   Tue, 5 Oct 2021 11:04:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <380d7926b0b6401fbf6c8e3dac4eb9b3@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:5:333::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR03CA0094.namprd03.prod.outlook.com (2603:10b6:5:333::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 5 Oct 2021 16:04:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac652f9a-1dd0-4268-93d0-08d98819c570
X-MS-TrafficTypeDiagnostic: DM6PR10MB3148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3148204C79869AA11727534CF1AF9@DM6PR10MB3148.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lzJ5Fb/gczcI2HNy0IESXqZQtzTlubVn1JC2KZCE/CQ5rY+WeCsk/P1wYW3n2P/ovAoutfK/8I2rkAwdvLXAKJxfF4VvEiw1B8wcObdd8gDDHnazN+RwNZTPIaRzg46o3+I8K8Xk16nezd9pZeakXZ5c2Z6G7ol4OG5+RCd5zZC/ib1mQlO3uQdgNWmEduzJs9SIVGgX2aiRbaEpYQweVH4sn/3gOczEHWLuT7QynxWCmRhqXaxCNOL3yMgdDEzC5j8CYRdgkSo0t8PhFbkvzHLq8MQPqKAezHaeNWZa9PdaLp188u6E43ObH5oUkrOrfqZEaBlxPXVvYPjH3rMJHAduvrKcoS1JXXAYMK1r0j904egBpIIzNkRVNFjowYFLyjYVfr8Mxr7nD1PjWJXk2CwDAyyHgvVlGHnBDFBYGZa6WumYrBfQxqqfajtAcKpQvnqbLFJoUXFJnWYYCYDqZUXIQcxdrMFERwq3MXdlyg5mVg0iTP7GjIgDtlVnTfd5lHnHecmsTy2rBz2oVvtWaMSDAQzuQ7CMPooDx6QXY5VRF8fEFdbtWIcWijXI+7aFbknAweZWh0knIGrU5PLcN1oe3l0z46/qcHg1AQitjrCCMF/nelDalE4YGy2Q+TdSsvFvI0xncV2DOYgszbbg3HWZf9oVCA82BCiT4T1OqSZKwWu/GA2p9B3oD6KJAlOUX/unFgZ0WRXdOBoS6tVHqLJfEHIw8d8SweWnNb7Ie6sZ5l0sg6PXetx7FUxkcAVk+w0KapDJtzn1PQO8ahsCAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(16576012)(2616005)(316002)(508600001)(86362001)(31696002)(4326008)(110136005)(54906003)(38100700002)(956004)(31686004)(5660300002)(83380400001)(53546011)(66476007)(66556008)(66946007)(6706004)(36756003)(2906002)(8676002)(8936002)(6486002)(186003)(26005)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHl5R094MlN5dHc1Vkp4aTNlUDFhMFNQWUxEbldnRlRic05DeDlXc3dwT1hX?=
 =?utf-8?B?dDQ0SEFvd1NKUEZZdkNlTXEwaUNCVWlNelQrZGVqeHp2MWJIdXI5cW0wWk4y?=
 =?utf-8?B?QzdoUUs5UjE0TmZjUUVBSVBZVmpCcE1vOVNqUGF5ZjZuNnowUWp2UkpMdFUv?=
 =?utf-8?B?ZGdOMDVNTFhkUEhCc0Jrb0dSMUdlcGdnT2FtY09GNDVGNHR2NjVPT21adWxR?=
 =?utf-8?B?SW1iZlhVUFlxK2JJYU5Dem9FQWJhaHh6b3lmMDBJSERSWGxnNysvS29PSVNP?=
 =?utf-8?B?eGRYV0FMdG5OT3JNOFAzZmE2akhKemFIOW10eGpVNGZQckZJdndiZVp5OWIy?=
 =?utf-8?B?OVZRZDZmWE0zYVhWeVhoYVMvc3I0eWdEOEphb3JLNVhYK3JyK3dLVWY4enJN?=
 =?utf-8?B?eWd4MXFFY0ozQ1k5NjI2NG5ITVhFUmNtSk5CZW9nODUzc1JrM1ZqeE9hR3BH?=
 =?utf-8?B?OFhpRmZkWGJDelluMERmeDkveEdxVzVwUFNvWi9sbXgwaGxYZ213bUJqNWFM?=
 =?utf-8?B?cHpBeVViZ2FCakFVS3gwM2hkNkxMNjZzMGE1a3BGYWRzL1NhTm5tbDNLT1R0?=
 =?utf-8?B?alArbTZ5V1drcUVsVVM4M0tqK1BNOG5tdHd4bGF2alRSd2R0angrQytBVEVW?=
 =?utf-8?B?SW1vWGZhdElJc1NBY1dKbHpNOHRQK2J2QlExa1U2RXkrN0d6cURXNStMdERY?=
 =?utf-8?B?TmpHT1VBdTFyanF0Nnk0amhFTndDdmlXNUcvd3ZNS09WYWFjbTNpWm4vSUk1?=
 =?utf-8?B?bnQ2UFRsRmlQZFBiWFloTUk0dVRlOWp1bDdqcTdEL1ZSN3prQk5PaS9ZYkhR?=
 =?utf-8?B?Rk04MGQ5VzB5Q3dxNzJEcE03TGlOR0MyZ0dUV3hrQ0lPYzd0SmVUN1pLMTd5?=
 =?utf-8?B?VzVCZE4wTjgwRStlMW5UbC9UTEo1aUFUVzM0RXE5VXVHNkNkbXg0ZlZWRkxw?=
 =?utf-8?B?NC9vZUZDSlFpZWJVNTRIejIySmd4ZER5Q25taTBicHFOem1zTTVLTjA4aThU?=
 =?utf-8?B?Smd6ekI5UFUxNGtudHZ0Q2Nkd1c4TU4yMEdCcHVQWjYzMjIydkZ0WnFTd3hi?=
 =?utf-8?B?N3dlSHU4MXlwSGZQN1B6SCtMY0VrdlJQUXcwSXJoTFpOd2tnS1E5enIwcHp6?=
 =?utf-8?B?d05LZm9ud0JsTTlyMW5KbDR1b3JtTGN2VWNXcjZoYWF1bUtnWEpHejdyWXph?=
 =?utf-8?B?QXI5VkNsVGdGNGQ3QXdQU3lKMEc0NTJQaXI4QUx2dTE4QjJaMVVHOUJwejls?=
 =?utf-8?B?QUJ3Qks3cU5BVmZtKzVJSFl4aGZEcjl4WWF2UjdkaTFBUWgveVd5QUF3cjFM?=
 =?utf-8?B?MHF5c3dZQVl0K25vZzZQREQ5ZGFKMDJBSlZaZHh4TWtDSnhwYkIzSTRiZTE0?=
 =?utf-8?B?TFB4MDJpQjV6SHZKaE03ZjZtTnVId3RyaWZEOWxRMGw0a2hoblcxb091WnlG?=
 =?utf-8?B?cVlaUGg1aGxIVWRIMmdxTndHeEZSYzhSM2ZUMmNtL2hxN2d1QlFYZTJoL25u?=
 =?utf-8?B?VWpkWWN1MlZldmIyMXFqTkJlelBhMTMrVkk5UXJEVUxVbERwVVRweDBVYWxU?=
 =?utf-8?B?RVdNMWl5K3FtYWVuZk9zOWIrRWJROUhZeEFNRDdCVWpJZFZNc3hWcjlQdm5Y?=
 =?utf-8?B?WjdESXNDSkdNcXNmci9qT0UzeWJTSEpFWGNOejBGR2RmbUtPNmJHQTJzc1hP?=
 =?utf-8?B?bTB3UU43ZitQanBHaVVTc2dydzdGaGtqck5pM2pZS0J2Y1VxbUltNzZZcnZN?=
 =?utf-8?Q?99M7zgL9M+s+vAxdiMimZR09oQg3fLhlH0jlJPg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac652f9a-1dd0-4268-93d0-08d98819c570
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 16:04:12.0563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRHzawK6n+Zn2FXnl8UNgDyadVPi/cc2sYNmBfoYHLk7NWqrMkYrzFwxixHd2IPICwYOgLHPd5K08kSI/aKoGgZmEXsCdiBc9mbRoXnvsK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3148
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050095
X-Proofpoint-GUID: smJ6h-ZHag0Sd8n1GVeKlDdXGuBckkMu
X-Proofpoint-ORIG-GUID: smJ6h-ZHag0Sd8n1GVeKlDdXGuBckkMu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/21 2:56 AM, Dmitriy Bogdanov wrote:
> Hi Mike,
> 
>>> Add acls/{ACL}/attrib/authentication attribute that controls authentication
>>> for the particular ACL. By default, this attribute inherits a value of
>>> authentication attribute of the target port group to keep backward
>>> compatibility.
>>>
>>> authentication attribute has 3 states:
>>>  "0" - authentication is turned off for this ACL
>>>  "1" - authentication is required for this ACL
>>>  "" - authentication is inherited from TPG
>>
>>
>> Why the empty string for this value? Maybe 2 or -1?
> That was design decision by logic that since that attribute has a precedence 
> to clear that precedence we must clear the attribute, i.e. set to the empty value.
> 
>>>
>>> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
>>> Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
>>> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>> ---
>>>  drivers/target/iscsi/iscsi_target_configfs.c  | 41 +++++++++++++++++++
>>>  drivers/target/iscsi/iscsi_target_nego.c      |  8 +++-
>>>  .../target/iscsi/iscsi_target_nodeattrib.c    |  1 +
>>>  include/target/iscsi/iscsi_target_core.h      |  2 +
>>>  4 files changed, 51 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
>>> index e3750b64cc0c..2d70de342408 100644
>>> --- a/drivers/target/iscsi/iscsi_target_configfs.c
>>> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
>>> @@ -314,6 +314,46 @@ ISCSI_NACL_ATTR(random_datain_pdu_offsets);
>>>  ISCSI_NACL_ATTR(random_datain_seq_offsets);
>>>  ISCSI_NACL_ATTR(random_r2t_offsets);
>>>  
>>> +static ssize_t iscsi_nacl_attrib_authentication_show(struct config_item *item,
>>> +		char *page)
>>> +{
>>> +	struct se_node_acl *se_nacl = attrib_to_nacl(item);
>>> +	struct iscsi_node_acl *nacl = to_iscsi_nacl(se_nacl);
>>> +
>>> +	if (nacl->node_attrib.authentication == NA_AUTHENTICATION_INHERITED) {
>>> +		struct iscsi_portal_group *tpg = to_iscsi_tpg(se_nacl->se_tpg);
>>> +
>>> +		return sprintf(page, "%u (inherited)\n",
>>> +				tpg->tpg_attrib.authentication);
>>
>>
>> I think we want a value of -1 or 2 for inherited then here it should print
>> that value.
> 
> We decided to hide the internal value from userspace and represent it similar to
> tpg.authentication to have the same handling there.

I'm not sure what you meant by representing it similar to tpg.authentication. That
attrib, and I think every attrib, prints 1 value.

The problem with above is that this works by accident for rtslib based apps which
read in the attribs, stores them, then on restore writes them to the kernel. On the
read/save stage we get "0 (inherited)". Then on the restore stage we try to write
that back to the kernel and get an error. rtslib/targetcli just spits out an error
and ignores it, so it still works since the kernel used the default. We don't
really want the error spit out and I don't think we want it to work by accident like
this.


