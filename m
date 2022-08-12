Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98B0C3F6B0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 03:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbiHLDih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 23:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiHLDif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 23:38:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06FEA405D;
        Thu, 11 Aug 2022 20:38:34 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6BEb010972;
        Fri, 12 Aug 2022 03:38:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0usq/tNNi6uG6bNJjnj3EnTRXF+9tK7KA7p20QQiBF4=;
 b=bZfgAkebgRJgX8vf9HFotprY9S7frzAtCwBLNwiFRgE/XFlv/hbr6uZRd3xut64EHVMD
 jXxBs/gUSQv2M9JU+6uM3Behz/lRAgdGJ1iicrM8zkEeoU6X6S/xsUtFiS9ouCds+M+B
 El9CbM5QEWnaI+rdyaeZ9PaEf9CZH052ItNRzHNpIC0G1hTeInxtjZ2iJYkA6a9vhmwY
 rCEo+JFSQrcu2dfncHf9S3QMOzB3M6GhCPPYm6mynjrPFOWri0akZNBZAq1UeoROWcK+
 9iJgV0SJI30zaPgw9FPOe2pM1qHojQYZmdtQ0pREX9TkZ6lyC/vyHjb74+IwGy1hS9j4 ug== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqgp6mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 03:38:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0CtDr020434;
        Fri, 12 Aug 2022 03:38:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqk9qsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 03:38:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGcZilTuSkOd45DslMQdy3lHuU60RVM4YqGR3/mbBJWbD++Gm745nMS/E9TCC3wNwMnvr2wa1YcO2dOk2Lqqu8jKivCcRvrLRRpnVz9gFRCZx+c8nGggFiIXvsc5Am/zvzl6WRnUD/jrPM1RPN+i1ItfCg15kDHY7Sn6CDSCwdT/EI88HOISuDGz/3nMqsGgTFeu3gtYuYBqiaC1TV+3HBaGICUiom5z6760au78T764zhkvudrtNL9UEzEvgx1PZHXB9GzOwKh0VL1s2Cs0dRguiJx1krI5MVKXIkSErvILuRmMc3C26qnG+UiddmC7VSz9TtmIfxUzoZ/zExaUQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0usq/tNNi6uG6bNJjnj3EnTRXF+9tK7KA7p20QQiBF4=;
 b=cGintEw9RMukvYZqdqnoPNG0FCEuIV2HZrsgcz/MPoNO4GFBCV/CtyTIcegBQ9aVAXkuX2XFWIc5sKHU/rpTFBsKvxPtsq4GT5f91vSiOI3fu46pFaOe3F1UdllgjkOTdSAQaZsfH+aIFLC1VfUWNYAimm+QlYaOhTntio5CGZ6Zs88XI2brMi2kPchC2DBEqRkQoaHA+Ih+dlxAS3IOU3qkoWOZhJ5fjSO486Z6KM+XeB/E5CMo8u8eI6dIH3MlMjFImVXMxM2tdcCtaXhMEDffRgHqorqUJwxZbiPliMwQ8q5d7/U2E4AZQ/4Wc80sgsrQin2zymo7wpli2lH7zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0usq/tNNi6uG6bNJjnj3EnTRXF+9tK7KA7p20QQiBF4=;
 b=Io18cThxkKfXJUCYSCUz/APKMIYYckNBAHmZVWtNoLYSQU5tTV30Zpt8YiZTiuSu5TnsQrmKiGzhZ1VEiqXqC0kYm/s0g2GB4IK7fPe8JjYXOG5JLcJIPVdYfBCLi0otyfaL9fhOMVCuwnAkEA/JMqFnXlDdPO9vkRWcIOMB7zg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3659.namprd10.prod.outlook.com (2603:10b6:5:17c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Fri, 12 Aug 2022 03:38:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.025; Fri, 12 Aug 2022
 03:38:30 +0000
Message-ID: <99508f9b-46cb-b696-a5c4-3874b4d08355@oracle.com>
Date:   Thu, 11 Aug 2022 22:38:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 2/6] scsi: target: core: add list of opcodes for RSOC
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-3-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220718120117.4435-3-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:610:4c::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca8a98ad-5cdb-428b-0d65-08da7c141ff1
X-MS-TrafficTypeDiagnostic: DM6PR10MB3659:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h5VMShhi59XSN1aqbp0jzNUoJ+58LKGTuDaEPpm9hUJx4tix95YIoxE27K/1vzidUfojou5PaBC2FA8XBZh0kKHZ2hqXG4VhiIysZ2EnD3J58glB5TF8vz3eIAU/7FYrKN8NRUjl16oIk38PnNwtHW5JdVfmyxiYOGH5yfrtzP47cV2JKb7Ephqe3Vm6+2PNRz5ecOO5SX9TygJNYr/uPipnx4OtNDLvgU8F1HAhGEfSm2PpvqRKxqumQ2L9+aLgSUkqlhZhllQndd4FMnUilRenqPp3PlskP9xGBnHod7lBQje8EVjhaSAJ7CsttWIy+fOJ8VmSxuM4uxdmeJSYGPTaxlX7z4f4+kTg55GDwKLcZlWveL+H3QhORRO183DKd4vxawdccJtEX+jwvTndOThV+enYzL2vElMwM1Ep4xeOUTX6qkSsGwtfzNcHQwJK+N1xoOpePvND8wpa63kUDlVCF10DNHdkfcFgSnNYKlr0ef5HBQC9T3XsPZA14TzMjIJx8AEJXXVKUg2oGEfl8FzykpSRoINnu/jxn2kNIkbN1UBteyA2YadbYgvvnpe1fQc1g3ethCFMscdXC6QVx/jNMBNu7fSqa9KIfhLBPOuQ4DnPh2qm8O1vmnLvMGhmFpGhbtJDMHnMobSpFW8bv3es1/Cx7jtrW0JnT4ADXOhjsJ0h68NlYA4Y/wLF7MTfHt9Mzo1/nmofVs4z5QvJr6iUSbqFXUABVlaDpKI33V56KPvU79FCgG0eH44/4RyJwIEeBnUu2751l7DKh3vWYyPg2d1/qa4LnIX/7n2zDElVcrairTu0v5V0dsLcaPB5665R1QZqPnTG3xHhVpKLbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(346002)(136003)(396003)(376002)(478600001)(86362001)(36756003)(41300700001)(6486002)(2616005)(53546011)(6512007)(186003)(31686004)(110136005)(31696002)(26005)(5660300002)(6506007)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(8936002)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG1YQXV2bndPOFpHeUV3ZDQ4bTVad1dmOHZ1S2F1ZHlvY21obitiaVkxaW9j?=
 =?utf-8?B?WEMrL2pqVU5NRVpCVjlWWUU1YllHQnVkR0tvbHAvZFlRRjV0czhEeUdWdm5W?=
 =?utf-8?B?QnE4R2NkNVRIQWhvMUZvVFRhR3Q2a3Z4KytGZlBycUUyczQwb05LZWZZaHV4?=
 =?utf-8?B?VGRKNTE5TDdMcGd0Z0dQbTVJN25XMTN1V1ByVEJWU3IwUFVveU9UcDRvNUta?=
 =?utf-8?B?L1QzVEE2TXkzOUlCVjRHRm9zNWlCZldpUlp5YUJKUTFvSGdDMUNLZGJ5UFgr?=
 =?utf-8?B?ejM2RnZDYTVmMnQxNXgwNHRCeHlqT0czdjN0UjZKTVoxRitxWmFxeHdlbkJV?=
 =?utf-8?B?VTNYVmJ3UG5uOWRmTDlHb1JyZ093TE5vVlVvTFp4RExYQWZCbng0MUJ6a2R4?=
 =?utf-8?B?MWw1QUpNdU10OTU2dytOUm9JcDJNZWtLU2V4cTRTVGZWVktqOUNwekdmM2lh?=
 =?utf-8?B?b1o4bkxqTzJYWlBjNVh5VFZtbmZpeURUeUVrZE9mM240NWZzaW1WNjFlbGs4?=
 =?utf-8?B?ckUyTjlYbWVsRHFxZjd2SjVNVTVJeURCUlNYZ2J1aGZqYTc4RGgwclNEZFlQ?=
 =?utf-8?B?YWliSEN0STRMMTMySGFYL3JtTzlGRXJXcVRWV3VBZ3MzekNaUk9kRWtJZ1NH?=
 =?utf-8?B?NTdtbEk1MjBVdENRNGFzMVlldVlMd1RLK3ZtTEVtQktQaXQxWnlMU2pRblEr?=
 =?utf-8?B?WkJGM0N1amdwOXlGRzgzZVBQUDhFR0RuSlhROEIyb1ZpNWJJYlM1VERXd3l0?=
 =?utf-8?B?aURvOXZCYVQ0Ykk3dmdFaitVNVpkN0pIN1NEL2o0cU9sT1h0bjQzM0syaWFt?=
 =?utf-8?B?Zmg4K25SMUtpWTluQlpIS2VIb0dZdGx4b2hWajBxcE5wM1YxL28vTW9wR3Jn?=
 =?utf-8?B?ajE3OHovZUxuV2dTMkdiYmZicG90M1dTRUhRdmI0MjdMUDd4K2s5OWJBc3hl?=
 =?utf-8?B?T1VwQmxnL0hTQlVVOGw3WkVQZzdCM0tjUzZXOHphZmlKQTRITE5QN1RrMDk4?=
 =?utf-8?B?TWNKanBBRHZ6UFJKYkNkUUZJQjJ0KzN6MDI5TGRCeDdYdk5jQWJKTlp4ZXJk?=
 =?utf-8?B?WnNBQ09iRzk0UGlWZTZlbTBpc1VrNXhMVHFTYXo4K0g4Q0ZycVBTQlp0Tmxh?=
 =?utf-8?B?S1ZYQ05GR0RmQklmNzNpRkVRWTR4MFVGbytGTk4xL2JRUjlWVm9iSHN2Qmx4?=
 =?utf-8?B?QzZJdW5LZGl4SnlrTmVwWmp3RzNFcGdYT0l4clZ0bGtXQzRmbkFyVHROQUd0?=
 =?utf-8?B?Mk1nWFlCY216eitiNnUwbmVicEdwc3FZQ2VPWllleWduNE8ybG5TTDRXQXhG?=
 =?utf-8?B?ajUrR1NiYk9QTWYyaVZSek15NTlzejJ6MFRXNThrMWxKS0hnV2k1Y2xIUURv?=
 =?utf-8?B?Q1FCbm5nTSt6MkF2TWZLd2lmTFlHYlRSNllOTHQ1YmxORjV0MDl6VjVnaHdx?=
 =?utf-8?B?TGhhQWZwTXBGZ2YyVzdORTdMTyt4S3dJUTZpaE9mV0xaUjBPTS8rVkxVY3My?=
 =?utf-8?B?bzhOL0JucU40OTl1L0MyWmhFK2NudXdFWm9OQjRKU3M4MTllaEpuZnJ0RWhw?=
 =?utf-8?B?SjV2U0szRkxDVE5CVVZBOW81dUp5b0U0T3pnWHdnTmhBaWZvdEZRTmYrSUJh?=
 =?utf-8?B?dUZTUjdpQXNxRUF4TnZiOHV2bEJMN0hKODR3cC9RWFFPY3NwZ0pVOWFCSXUr?=
 =?utf-8?B?U2M3aU9yOTRVZFM1TFVrT0tlSXlVT2xlRmo3N0kvam4yR0RqbnhsQmp0eUVz?=
 =?utf-8?B?VU5ERW1FSFJBUFlxUCtCQWJOdDA5MHMxNlIwQ1ZZZTRaRytYY242bzJLZS92?=
 =?utf-8?B?NHlnTmNBaFdCK1VmaEtjazBDQmNFMTc4aVdnRnhWaFhjMjdBNDZRRXgyWkMx?=
 =?utf-8?B?MjgzWGFVQzBDNW40RUNXcGxkNzNDb3hNVDhtdmtDbXVMMWN0UGVqZmlldERF?=
 =?utf-8?B?QXZuOHJCMTN5a2NkQzhwMWZYc081ODJZQWVrT04rTXRhMEJETm5IdnNSYmJt?=
 =?utf-8?B?dVE0UjFEY2pkNzV6dVRORjA0WUZqdE5xTUFiODNBN3lTdU9hZFZFbENTVVc0?=
 =?utf-8?B?U0lDQTlpRDJSMVcrK0JrTHJ0VFJLdkR3L05IRWpNWEk4TUxBUUpESDl0RjI4?=
 =?utf-8?B?V0FOYWlZYzBIaGJ0Y3IvVkkrbWtWcjVsMDBaMHdvTkxmcmQxU0U3NkIyTXNy?=
 =?utf-8?B?bXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca8a98ad-5cdb-428b-0d65-08da7c141ff1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 03:38:30.4990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fhPSKFG+yWPX3Ln0TFQTOEQ5u0GxBqbAPliOfpC5yJhupdD+nooKHlT0c/V1aL/FNesi8OoRaqUnMiNGEQ4VFKTduY5m3VBwMT2UiYZLuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3659
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_02,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120009
X-Proofpoint-GUID: SUmxUUwFyd1v-O3IALRdhzMecf8X8y9T
X-Proofpoint-ORIG-GUID: SUmxUUwFyd1v-O3IALRdhzMecf8X8y9T
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/22 7:01 AM, Dmitry Bogdanov wrote:
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/target_core_spc.c | 595 +++++++++++++++++++++++++++++++
>  include/scsi/scsi_proto.h        |   3 +
>  2 files changed, 598 insertions(+)
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 4157f73977cf..506e28b14e5a 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c


> +static struct target_opcode_descriptor tcm_opcode_xdwriteread10 = {
> +	.support = SCSI_SUPPORT_FULL,
> +	.opcode = XDWRITEREAD_10,
> +	.cdb_size = 10,
> +	.usage_bits = {XDWRITEREAD_10, 0x18, 0xff, 0xff,
> +		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
> +		       0xff, SCSI_CONTROL_MASK},
> +};
> +
> +static struct target_opcode_descriptor tcm_opcode_xdwriteread32 = {
> +	.support = SCSI_SUPPORT_FULL,
> +	.serv_action_valid = 1,
> +	.opcode = VARIABLE_LENGTH_CMD,
> +	.service_action = XDWRITEREAD_32,
> +	.cdb_size = 32,
> +	.usage_bits = {VARIABLE_LENGTH_CMD, SCSI_CONTROL_MASK, 0x00, 0x00,
> +		       0x00, 0x00, SCSI_GROUP_NUMBER_MASK, 0x18,
> +		       0x00, XDWRITEREAD_32, 0x18, 0x00,
> +		       0xff, 0xff, 0xff, 0xff,
> +		       0xff, 0xff, 0xff, 0xff,
> +		       0x00, 0x00, 0x00, 0x00,
> +		       0x00, 0x00, 0x00, 0x00,
> +		       0xff, 0xff, 0xff, 0xff},
> +};
> +

I just removed these because they didn't work. I think the patch was added to
one of Martin's tree after you made this patch.
