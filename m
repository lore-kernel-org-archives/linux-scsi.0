Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B1FC00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 03:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbiHLDnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 23:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiHLDnN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 23:43:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEB94E85C;
        Thu, 11 Aug 2022 20:43:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6hVw023129;
        Fri, 12 Aug 2022 03:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=a64kF+++J9XY/l+JRr0HzcioibHU46VdoYCy+UA3MDA=;
 b=TouS1wld2fv5n0CcTD0Wfg5lYcOPLAf2tPQDcO5NnfOt23mtf7aH5D57oXIQRXWR4eCq
 YXamybgL3JgMqCbqtRBVd3/crqClkX0mq9DXdxPEWI6c20j+3S2HNZKabx2T3FY5JuDu
 mepWj7azCzZygZdUu2iDMA8YXKnND1n8x+WNxH26V2F0zH/U/wY2uUTyq/sb0XE7ykHc
 5IZLBo9WxUX9KiRWgiuqkhW1zJlH6x8P8Z+vEd/j8mciXP2H7JKF2kho+a0JjJmJxAsM
 vFeBEMIoglgJOFMGzPq2+x1j7Wl3Dz/gpD8iJf2YsxUB9hxfbbu7o19yIx0LB2DUP9mr 0A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqj6a9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 03:43:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0FFlk004987;
        Fri, 12 Aug 2022 03:43:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqk9ree-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 03:43:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fl6ikO9S5zs4Qn0s5IO5JlaNIjbjw7m7qMcM5vEpGWmNE0siYcLAzBREATCd6stn93RdThwEHvUSOmJ9oqOY32p0Iz2+Og3xlKBp6xme03Gqo8e7omQFhxBvRuw8mFzdV7NFmytYdxoDzE+d4Oi+p9+XFU05gyd+CBjV12DrGvVNe6+J0OjTlJ+KZ/zHlOLMOUGgmugvOANjnSbanbHF+9s0SsHXtJ67RgTvCJJjLRuvm0nFhDJHr1gNAhXqnCT8AVNbwJxapSmZxg/YlPoV1jm75O/6LMFp0gRJgNYBGc+qnTuyC5IsR8g6jSu/RlI0EFzcbHSfel8BL6oZi0sNAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a64kF+++J9XY/l+JRr0HzcioibHU46VdoYCy+UA3MDA=;
 b=LFpBjBlr6wHIQoKij/Ndc2+G5KfN4guv6+ALwyVmIoGNMRqItfPHQVEJ91p2m4Sry/fziub8Ot4pqlC7mCmCVRz03GBdok6WoQ4whbWvvpr7CDGwPHBAgYC1QOxjoNPVEjLoYCuFsGKY1DXlkkXwzqv4r0FNhGgz7moMbQgQqUH7uf69iEdqQQXP8MfBinhOlhcCdFju7bKazqMqBnCl08dM0QWDhJ2wBRy0+1LJU/DMWwCiF5ADTt8lBhv/w/IfUW+uwS5xN371SXC/S9UzEhTGke8x1u/ttNEGe2ZhWqzDTxUPztuvzX6LCbttYoRmnjWENrShL5dFMOXIc3RH/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a64kF+++J9XY/l+JRr0HzcioibHU46VdoYCy+UA3MDA=;
 b=ziPWyWhw/G2mTVo4qRruH/+Z1Qbpo4DmK06lXz2s8KQuXT0eteFFmeEXMlXDEJD0hy6mOwx4owA5pq+zFeZGCy0Ojsm2Fd44a0XFQQyOqtFh9zsDAaudu6ziNgDJZMbbBFSeMZKEDmL4YCzA0r2E7Mr+/2YsCrNJ9LUbnuD88BU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4171.namprd10.prod.outlook.com (2603:10b6:5:21f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Fri, 12 Aug 2022 03:43:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.025; Fri, 12 Aug 2022
 03:43:07 +0000
Message-ID: <1f72d08c-10e3-e625-0c19-e666fb70e5bb@oracle.com>
Date:   Thu, 11 Aug 2022 22:43:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 3/6] scsi: target: core: dynamic opcode support in RSOC
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-4-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220718120117.4435-4-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0031.namprd05.prod.outlook.com (2603:10b6:610::44)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40df8db5-fba7-4da7-f593-08da7c14c53c
X-MS-TrafficTypeDiagnostic: DM6PR10MB4171:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: do1ZZtPpMyntNzxmdk0pBAxrJXn0Pj9AR5Vqp89AAVuU88NV3ijrDk5qlVaLLxZYgTWCKnwdBgIVv1wL0CZgqzbszyYi6TXY5ayOaHYeGWi7RDLembdD1HZN9lsvxPXUJumNWsOW3TiZnE76aoavBM8TBvFKH/7nWqGXZX1pSnqzFD/UUIWRYZWqe7HCZyYdRqV5xa2B9LpR/Y6NCselTqlCfQMcX9+HYjYcVNbv4dctJJJZNeoFX4qtjAc+eprZd43Y/1NKpxf+4gU9sZaSg+I8UmlTGuENV2hnWAsMvw7G0qnoWQl3G4oNSnl/ZxVPwrCciP+lFQtqBJQZPjbkOJnLW7ibWHm9oTs2mgLDPq4L0MDAqLz12AbUJ+HMQnxi4g/t3HT1oeSvZmrnVK0j9+1MC7BkFwrFjN2esqjaQhHL0bSlfRMb7tMeRbXa8TYHe7OFSSxG+cGHt31rcBfBCTp02IXxREfq4PwdCa9mqR02UBGSYxkAZRAwCVc7UB3gvAcvLVXrJfYSVmIi3K1PR1UTVv9mQk5HZnHteV8fwAZVe30pZJb4QkSWydtUPFkFfRXI0EtuO1Ltk+WzvHYGBydjueziRIpfYmRu2E/4iKA8aIF1SgiIRcyZgmenreK8dPvfy+YvSQie4wmOij73uZBStUbuS4l1h89WtmigP1tD3RzMbpftUtZb+u5iOnd+5lSel09cfku0zx6/Lzn1SM3WhVxiX9yhmzSHiIqAkpeOc2fg5TmKFUn9Uj5QAw76+3ravaRUy+dmm5WV3k6v6JZ+/ZSrvyYQfb+7lqptZY1nIdwrAnE0wv8TV8Av91IGCVK79FlRlHeVrOzZiRqB+fcy5m6uhQPEhZyuRlunRqGBEQllztOfJAGlNm2tVk2y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(39860400002)(366004)(376002)(53546011)(26005)(6512007)(36756003)(41300700001)(5660300002)(2906002)(6506007)(478600001)(31686004)(6486002)(66556008)(38100700002)(66476007)(8936002)(66946007)(83380400001)(8676002)(2616005)(86362001)(110136005)(31696002)(4326008)(316002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEpneFBDOWIyWVVXeWl6UjdVZlpKUzZWZWI5a1RNSTI2aEdiRCt0dGNjUUFu?=
 =?utf-8?B?VEMrc2NROWo2eFd0RDM3dG9aODZiRWdnTk1kUnVSOHZWK3gzMFZtbDBMM3NO?=
 =?utf-8?B?Sk5WQVdXV1hJZFlFWWdvZ2lSM0VVWCtCRzcyM1pHWVUvSXdMT0dyZUM4WFlr?=
 =?utf-8?B?MXhhOFB4OVZUWWF4WjEzZzE3cVowK0tBcmxYM3ZnT1V2dHcrVGpxYmN0TUFT?=
 =?utf-8?B?YkRTVithdi9pWVBHd09HbHBkMzh3R1dERUVGUzlhSWNwQnBLNmt3SGZkS0dw?=
 =?utf-8?B?anltby9taWhUU2ZFVTNuYXo3MWJaZlg4R2lVcUExSVBvZFBLcnV3VnhaVUl2?=
 =?utf-8?B?cm1RaXZLOUM0SlF1Z2hSb0JZYk5xTkRKd1pvVm4xbjJRNUpQUDNDWGh4UCs0?=
 =?utf-8?B?WWYxeSszMXhvOHE5cW1ORTZuWUhIZTVUVlZYd3JLTmlHZlduUWlCb0RreFQr?=
 =?utf-8?B?Vmg1MldFMzBiNDF0R3R6MlpEakVKSTJCT0wyR09zbnNsYTBOVTN2Z1FHNHJ5?=
 =?utf-8?B?bG5SNTBaalNFTEJtTWJoOThpTjYybkEwMEt3Nmt0K3RBTWJEeHNaRHdiNnE1?=
 =?utf-8?B?OXBtUkcyZlhpRFFpc3B0dkpuNVJqRUxOak5VYjFYTVFuTGRmNXFWVUdxM3Fn?=
 =?utf-8?B?N2ZoZ2d4RFdDY0pkeUNCa3lCaHFTMmc2Q0ZxNHFEejVyaG95NUdNVHk3VXZE?=
 =?utf-8?B?Y3FlQTNBU3NoTld3dE83aGk1Z250Y1g2M0FTK2dLNUhQKzR5UUdxcVN4RFIv?=
 =?utf-8?B?bFd2aFZuNkZFYk94eHd1OEdmSzZ0czJzSEw1ak85Q2lMeGNZQzFQcllRRDEr?=
 =?utf-8?B?SElXeVZ0cEE4RkxyRUNrbjZ4UTFhTHAvR2RCMFFqaVh5ZG1wUkNuTlppZm16?=
 =?utf-8?B?ZTUvNlh5ejkraFBQckhNbGpOa3lWdUVhd2UzMGtzd2lHNGtPTEloMUZsaFpD?=
 =?utf-8?B?QUExTHB2dkUrSXc2NUFqUDNEb0J6R3RJK083VHdqT3hZaysxQ21TK1lXQXlp?=
 =?utf-8?B?YTdLQ0pYR0lDRHFyMEZtM0ZZNW5pbUViS3ExT01LMkRQRm01ajd5eVBLbTY2?=
 =?utf-8?B?b1Z0MG1qeWdCNGFuNXVOWUo0MjhRVUg1UWdsVHpPM1VRNkpIYi85eGhSSThD?=
 =?utf-8?B?eXZlTzllT0psRStyZW0xM3ZmdDN2Q3pKQ0JQSVQzVXJKY0hlWHdLa2M0NXAz?=
 =?utf-8?B?c0VaKzlYdFNaZVZVeS9xN21wZW5KbVFJeE4wYnc0NjVHV29ZeHNncDB5T0N0?=
 =?utf-8?B?Rit2VmRRNTEra2NYN1ZwWC9wVGh1ek9SMzkrTk5OdlBDeWFMbGhucHpNMDFp?=
 =?utf-8?B?T0hFbWdybjZGbjdFUFo4QXFhaEEwUUdqOUsvempkUEcvalJGcFREc0wxZjBa?=
 =?utf-8?B?RDJDZzFmT1psS3lMdkk0L056UUw5cDJwV0h3SHZWK25aeEt4M0Y1Sm5jeHp1?=
 =?utf-8?B?ZVRKKzdIS005Snd6T1h4Q2JybDJRcEpQQm4zbkZwL25aYW50dStnWmZiVEFo?=
 =?utf-8?B?dnB4UlQ4Zkx3Uis2YTg4dFUvUGgzb1BSVWpjQno5ZXhLSUU3SFJqbXU2M000?=
 =?utf-8?B?Q0JmVG42SWc1bEtLb1FHeUYrT3hCNGtRYUVHU09jdUsvdVg4anl2dUg1cmMw?=
 =?utf-8?B?ZU8zSGRLVWtFQURScjk5ZitPaWNvaUIyampDN09zU1AxREhNMWk5QjY1S0pX?=
 =?utf-8?B?ZFNvREVzaDl5Nkx0b0VkZDRsSkp1ZFZXMUlkQXN0MndOUGErOXBJWU1xZmlt?=
 =?utf-8?B?S0xxQk1JUGhLK1M3Nk5SbXV4UmVwaXpEajU3aHZlOFQ3eHhmQmRCTjBrK0dL?=
 =?utf-8?B?MWtrZ3pTU2s2QjMraU5WZWMybWc1YTRUdTZKTmhTQlYvMEh5NVYzVDJ6UkZD?=
 =?utf-8?B?WTRzT01MWmN6a1pEcWZ6dk5nYldXUzFxTnY1WGhLWHpMK3ZVa1AzZWwrYjdQ?=
 =?utf-8?B?UjFKT0VQMUdkZjlQN0JzdWVON2JPbGJUeGd3NThYT1N1Y0JMSE9MRXB0aDdp?=
 =?utf-8?B?WjBvcVRNSm4yN2FJV1QwekFHR2NFTkVHVUo2TFFaM004QVAwQjFYTWJMMVBz?=
 =?utf-8?B?WERYdmNORXdCV05ROEZod21xVDV0YVhSQnZlbnFjRXJEc1k2Tko2cmdPQlhO?=
 =?utf-8?B?TFJnSGg5OFBvVUFqcDVFMFV6WjdkVllwVE8wMlVydC81cGZtSm9leXIza0hj?=
 =?utf-8?B?VlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40df8db5-fba7-4da7-f593-08da7c14c53c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 03:43:07.8049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrK2qYJJBsf9aa9Jp2eJGuiJ4sql6HwvgNhC8pkuoR19zR492+kNNZpYSfndFbnsopjZjokilojWKUjz+m7/qzvEfMXT1tS/vfr9AZQ35a0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4171
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_02,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120009
X-Proofpoint-ORIG-GUID: _I8godeSUBnpN79Q8vFWOS7a9EvXGJC_
X-Proofpoint-GUID: _I8godeSUBnpN79Q8vFWOS7a9EvXGJC_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/22 7:01 AM, Dmitry Bogdanov wrote:
> Report supported opcodes depending on a dynamic device configuration
> 
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/target_core_spc.c  | 118 ++++++++++++++++++++++++++++--
>  include/target/target_core_base.h |   1 +
>  2 files changed, 114 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 506e28b14e5a..cf516136b933 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -1424,6 +1424,13 @@ static struct target_opcode_descriptor tcm_opcode_xdwriteread32 = {
>  		       0xff, 0xff, 0xff, 0xff},
>  };
>  
> +static bool tcm_is_ws_enabled(struct se_cmd *cmd)
> +{
> +	struct se_device *dev = cmd->se_dev;
> +
> +	return dev->dev_attrib.emulate_tpws;
> +}
> +
>  static struct target_opcode_descriptor tcm_opcode_write_same32 = {
>  	.support = SCSI_SUPPORT_FULL,
>  	.serv_action_valid = 1,
> @@ -1438,8 +1445,16 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
>  		       0x00, 0x00, 0x00, 0x00,
>  		       0x00, 0x00, 0x00, 0x00,
>  		       0xff, 0xff, 0xff, 0xff},
> +	.enabled = tcm_is_ws_enabled,
>  };

I'm not sure what's incorrect. I think your patch is correct but the write
same code is wrong.

If emulate_tpws is 0, we will still execute the command. We actually only fail
with TCM_UNSUPPORTED_SCSI_OPCODE if it's a WRITE_SAME with the UNMAP bit = 1
and emulate_tpws=0.

If it's just a normal WRITE_SAME we maybe go by if by max_write_same_len is
greater than zero? Maybe that was a mistake and sbc_setup_write_same needs
a emulate_tpws check.



>  static struct target_opcode_descriptor tcm_opcode_sync_cache = {
> @@ -1502,6 +1533,14 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
>  		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
>  };
>  
> +static bool tcm_is_unmap_enabled(struct se_cmd *cmd)
> +{
> +	struct sbc_ops *ops = cmd->protocol_data;
> +	struct se_device *dev = cmd->se_dev;
> +
> +	return ops->execute_unmap  && dev->dev_attrib.emulate_tpu;
> +}

Just a trivial nit. You had an extra space there.

