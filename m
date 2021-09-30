Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC1BC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6042461A10
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351463AbhI3SZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:25:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18950 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351422AbhI3SZ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:25:28 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UHQHHs019365;
        Thu, 30 Sep 2021 18:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9KiyxLlHxUVpcZ4Nulg2PAUFqwl5aZzPzLct3UA6mfs=;
 b=QsG1gUycKrnzResEG73LhvedrUSJxlOU12ZfgNUc3ChjLAG3MjQu99XCs3ghLOzM5vPo
 YKOTwsmGcBy4v/i+RNPRAegHoz/BkbisSRqqUB2sF+0Y94mbNDgygN1PLqwcxXqubQk3
 hA1cgJEX4eWbfCnrc5a2fmKGNxLWFSEai40+D/FzIS2L2YhbFQFr+F9+WvcnvohCmZ/q
 CamnA6MVjcdsRTJtMjUod6cPG8/rnAI39qK05nnurUyAc6/9uw5lUd1l8tpMF6RbKdHu
 aC7Ulq4mrEngM+aN1RlrbfcARD26lEAJI9y6gWw0Qpt/3bZHBUZZXgBiRCPZelya8hz/ NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bde3caege-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:23:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIEWnn099622;
        Thu, 30 Sep 2021 18:23:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3030.oracle.com with ESMTP id 3bc3bn1j2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:23:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AawUAD6ejs7zktbYLKZN3pnR2rKIS+jIlKix30VoXLpT0j5LajQaJut6lNyU3LVG9qigYdSut3+sjEqst9/PkSPmwvDmz6fHG7pnaShX32YAqb+Xi/4L92sT7gXiMR22EkascMG0Hwrs74OryDEH6NMY1veSTt+nlo15xTsaIqzexLdsFYNrVhKrLKTqZ7t128eJk1/+JZlIZvPdIxTnQH4FFg9OtrgRYjIFn+nEcppUum7PGBRm8WJPtXvI4jGfncKr/1D+JMRUfrE6Bb/ZMwxLwM06/GDZcrnp1ibxo4WfR4OTcrHu+GSL79pO1QpxQ225+IMQIYQf4bFdoqtfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9KiyxLlHxUVpcZ4Nulg2PAUFqwl5aZzPzLct3UA6mfs=;
 b=jYiq4uj907X4Kstf/O34u3lVVXbcAp5ubfkl/cS7f9OnCEQqZei9s3fTB5CRFcyUVUVVRa8yaoGPStxLxPAJzYh4o4u6lLjxilFyOxSUZYTVkmQqSTd/ThtRyS7etYxVSc9E6rTtSgJbd7y4oO4LgxVKMKV00AJxi1UpQuwNOTZQIf5xvKxPRzmJnCslviwAWABISfhQe1BAWO5S0pD2xmw5kYgwy1MpiQChmTc+fwgPiFe6rz+0/8eZhWOFYo3GIXF9cJAeeI7ObzHeCO8SdmPZsO6GWgvF2uWN+4pk+yXIGnZgU/S2IOanahc4xOQBM+Nsnv4IdybEChw/OK6UUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KiyxLlHxUVpcZ4Nulg2PAUFqwl5aZzPzLct3UA6mfs=;
 b=Q+PhsA7SU2KQKYatbCKZm+zdqd6EOxWPrOCo3XTXbQjjKCXiKxpNBd+FX4GhwZYhrxpTaqx/T5TS55EtZZOG4b1I+LQYRUs2VS07HIIzWA2jJR2KVX0sAq0B0WzVjK6Ja+olPY0WDMumATY7w7hjzwr6q7/8nu1CWWIn+EOcZUw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO6PR10MB5539.namprd10.prod.outlook.com (2603:10b6:303:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 30 Sep
 2021 18:23:17 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:23:17 +0000
Subject: Re: [smartpqi updates PATCH V2 05/11] smartpqi: add tur check for
 sanitize operation
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210928235442.201875-1-don.brace@microchip.com>
 <20210928235442.201875-6-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <ac3f4d4b-b1f2-dfa0-f042-d158ee8b0e95@oracle.com>
Date:   Thu, 30 Sep 2021 13:23:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-6-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:208:32b::31) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by BLAPR03CA0026.namprd03.prod.outlook.com (2603:10b6:208:32b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 18:23:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efd145da-6e27-4301-720c-08d9843f5fcd
X-MS-TrafficTypeDiagnostic: CO6PR10MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5539AF057E3BBAAD13B0DDBFC7AA9@CO6PR10MB5539.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wcSSMYDzaaLRBrJ/tCPMFEeSrL8LF3YZTfpgwUEQwW0kUCO+Xpu3UAsX6ApfAcVPlFY6Gd8WdsAg6g3DKX1zWTr6womJVxbbQg33SlFR78plAJX0VWoN6nKGNpgwm2hQg3oK0O0twq5jI91fWqLP9qZxfRx4e64RN1Ec29VdxXoPqX9m2k3bgEGZZu921yF4iimwdUvcSH9TNCz42Rx7ingVjX2aPWCh+2jFbjFZ2pB/ZA69TyEpovX24Jz0LbNfyXvACCqOK8YomlYn+lTic0kEc8EO4aU/TgnvSphzKILV0/5ZnI03JwLJAgYJ7kSOuyqAiN8GqxANfkIgGYk2lK68hHJ53ZnNhyhMe5FzcbCIm+nDRa7WfrTPF/Q5yuAsdqThsSrXFkVypz8lEIxh5an2nd8GpnI/Opsz69O5heli7KnuazuRx7Nf46YRdwUwozwzkWNqlIOyq6wjUBgxvGotV7RlaXg45gTarTz8sc1l5eKagHXZDhmZqXD3zlGtCVDT9y2a8Bu2YgBBzRtBizGNdSqMzxqNjYeKV5IltfusANQ+U8BdVc0bZXPG4hHHeAQIfhCdFhN/FPsuLkgSC88iPK7/f4PToqj9Fnzar8gohmhVP+WPAwUBwuWC+0AwtOAe7A98R7vmXdihkQtnZUbW2tek8u91yiLct0wZtkr5Y3ti7J4GUB+5/gnvcmGfYsBPkxSdiCkNHWfnu0yKnsyukSoRKflnMc0upx1HmpJajL4g4Aics90fDlbsBoyoeGV0XaAapzjnUfKOJH3RcmDelXNL86xmDVFFDXaZgXg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(8676002)(966005)(2616005)(956004)(31696002)(7416002)(86362001)(6506007)(53546011)(8936002)(26005)(186003)(2906002)(36756003)(6486002)(38100700002)(31686004)(5660300002)(316002)(9686003)(6512007)(66946007)(66556008)(66476007)(508600001)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0dZdHhLNkg5QjFadkwxTVI0RXdRZllYRExYZkhRMlRGVTlXSUU1dkloQ0hl?=
 =?utf-8?B?SzZmM3pzVlZsaHN4bTV0K1Y3NnhrSkdwb2Rab2JERlJpaGlDaUVHT2ZibGxB?=
 =?utf-8?B?RGdJdHVHbDd2ckhabGFSVzAvK2l2RFQ0VWNlUWdVbFdXdlo1VzFqYS9tcHNw?=
 =?utf-8?B?bGdxTTdLWjNVaXJiU24rS2lDbFlVYkhQeHM1Q0hRUk8wbFpIOVRYaVlmSW1B?=
 =?utf-8?B?SmRoeGFkdmFKQkorc1RLb2lzSmJ6VmdJZ0UvWnFJb3JodEdCNEhVeVZqSzJ4?=
 =?utf-8?B?dGJrbVhxeHJ6RE40eHpNNUtKeXVYQmhkVitKSGRyL3NzTVV2bi9QdndXS284?=
 =?utf-8?B?RGpkYmJtR2RKRTE5cWdJUzdUR3lFb2w0UEEyK1hTTGk3czEwUEtIaWdFYWRh?=
 =?utf-8?B?Slh4dWtlYndHcEcyVE01TVorbER0aFR2MG5qS3FBYUZCQXJhVFdhSVFXa29h?=
 =?utf-8?B?NGU1VEFIUWFGd1NBOVV5WTAzYWsrTENxc2hBWXRPY1ozbUpBd21VaHhPRnlh?=
 =?utf-8?B?bS9GcDJPdSs4T0FiWVp3azZPSjZoUGhsVVBTVHpqdzFNZW1ub1pUd2lWZldK?=
 =?utf-8?B?TitKMDVXcUQ1ZEtyVnNGWmdYYjVEcVVtWkt3NDEyTHh3RjJHbVZpT2JUSzlt?=
 =?utf-8?B?UnZKKzAyNmQrS1BRVngrQlZVNEh5bC91SjlhT3ZiWlNnUStWTWZoalJNY0hX?=
 =?utf-8?B?SHkrOGxOMDJRWUZhaEphMlI1enl5RXpOc0JDWGZWSm41YURjYjEvTVgrcXBZ?=
 =?utf-8?B?ZXVPSFZ4RjR4M1FKd1VrYVQyUTNGYmxod2ZGY2I3WlJLL2E1YjlobkxSb0lx?=
 =?utf-8?B?Q3luSEtjVmVOYWVsaEN3SkJrUEUrNmkzR3lUdTQvZEt0N1NQUGJMUDMwNGU1?=
 =?utf-8?B?ODJWZG41RlJMVWlQRlVReUt0YnQzVVJnMWswYSsydkdjNVVDUDUrNi9NalE5?=
 =?utf-8?B?QlVCWC8xWTg4cWlzYmFhdkY0dlU1ZDJkU0hsTjdXd0d1aDFMK2Z1b0J1NjI4?=
 =?utf-8?B?QmRzNFpuOGRySUFsYk9XR2N5SEhzMkZrVE5Jb2tSMVc0TTBwU1NLd0ZSc2da?=
 =?utf-8?B?VXVYOTZCVmZqREovcjRzcmJmck9JdEFqN0QvUTRyWVFqWUhBTTF1bXlqUW1W?=
 =?utf-8?B?OGNka0R0RGtyV1NtNWZyRFB5d25ORjVaSzR4TzVGcnh4UEZaNFo2RkdTSkxp?=
 =?utf-8?B?OUF6VWVaTVlnV1UwU0NsS2xKcUltTm1ZVHJVQm5hM0l2OStxWEJMUGUvdmtR?=
 =?utf-8?B?dTNpMFlGNmhOY040a1BET0xUT1B2N0NTOE9nNFRGdGZDZmgvVHF4b3phSmNI?=
 =?utf-8?B?aUUyQ1hIT1JYd2xWMEdDNFFvaXdaVmxDa2VkVnJFQU03WmkwR1pYbUZCV0lh?=
 =?utf-8?B?dkRNdHRaNW85dzBUVEp5NEMwdy8yZU1qRnpDblh6Um01eDVuUFg1S09tRWIr?=
 =?utf-8?B?WDBnT0JrYnpDQVROTzlVTG43ZDVXT0w1Sk5aN3VLT0tZN1d6T3I2dnVQS2NW?=
 =?utf-8?B?bzBQRC9ZM1ZlbVhyZnplaU11L25KZ2Fha0Q0V1JMSUhielVuYkVCd3NBL1dz?=
 =?utf-8?B?Z1BYcmN2N0grS0ZSNzdOWW1MUDdRN2F1MVJmVXNLRjhISExaU3dIaUF6V1h4?=
 =?utf-8?B?Mm91OFQ2Q1h1a1JHZ1ZqbSttait0ZTRhTkZ3cDBsSHBjUjVXVCtxem5ZeUNM?=
 =?utf-8?B?OFB1RFZIOVRocmJCcjlMbDcwZE5vd2M3RFRlbEZSTlVoT01TUkdiRUlOMEhy?=
 =?utf-8?Q?yrf1Y61lE5sg4dD7PHE8i86xbP7hzcFhPAGDgoM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd145da-6e27-4301-720c-08d9843f5fcd
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:23:17.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZ3cvrsWhHX3zXLDQGQGIJ4t5vd0aDFOxENBLx1k3bDdAW2+vvdb4vcQ0VvcJTOVw00hUxgVO1F3k8XdOeXQZ3DbQkURodYDTvcn23ITQUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5539
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300112
X-Proofpoint-GUID: 3PnH6ow0D4s445K1CSAWmci2JSf2U0VS
X-Proofpoint-ORIG-GUID: 3PnH6ow0D4s445K1CSAWmci2JSf2U0VS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> Add in a TUR to HBA disks and do not present them to the OS if
> 0x02/0x04/0x1b (sanitize in progress) is returned.
> 
> During boot-up, some OSes appear to hang when there are one or
> more disks undergoing sanitize.
> 
> According to SCSI SBC4 specification
> section 4.11.2 Commands allowed during sanitize,
> some SCSI commands are permitted, but read/write operations are not.
> 
> When the OS attempts to read the disk partition table a
> CHECK CONDITION ASC 0x04 ASCQ 0x1b is returned which causes the OS
> to retry the read until sanitize has completed. This can take hours.
> 
> Note: According to document HPE Smart Storage Administrator User Guide
> Link: https://support.hpe.com/hpesc/public/docDisplay?docLocale=en_US&docId=c03909334
> 
> During the sanitize erase operation, the drive is unusable.
> I.E.
>        The expected behavior for sanitize is the that disk remains
>        offline even after sanitize has completed. The customer is
>        expected to re-enable the disk using the management utility.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---

Acked-by: John Donnelly <john.p.donnelly@oracle.com>


>   drivers/scsi/smartpqi/smartpqi_init.c | 87 +++++++++++++++++++++++++++
>   1 file changed, 87 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 01330fd67500..838274d8fadf 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -555,6 +555,10 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
>   	cdb = request->cdb;
>   
>   	switch (cmd) {
> +	case TEST_UNIT_READY:
> +		request->data_direction = SOP_READ_FLAG;
> +		cdb[0] = TEST_UNIT_READY;
> +		break;
>   	case INQUIRY:
>   		request->data_direction = SOP_READ_FLAG;
>   		cdb[0] = INQUIRY;
> @@ -1575,6 +1579,85 @@ static int pqi_get_logical_device_info(struct pqi_ctrl_info *ctrl_info,
>   	return rc;
>   }
>   
> +/*
> + * Prevent adding drive to OS for some corner cases such as a drive
> + * undergoing a sanitize operation. Some OSes will continue to poll
> + * the drive until the sanitize completes, which can take hours,
> + * resulting in long bootup delays. Commands such as TUR, READ_CAP
> + * are allowed, but READ/WRITE cause check condition. So the OS
> + * cannot check/read the partition table.
> + * Note: devices that have completed sanitize must be re-enabled
> + *       using the management utility.
> + */
> +static bool pqi_keep_device_offline(struct pqi_ctrl_info *ctrl_info,
> +	struct pqi_scsi_dev *device)
> +{
> +	u8 scsi_status;
> +	int rc;
> +	enum dma_data_direction dir;
> +	char *buffer;
> +	int buffer_length = 64;
> +	size_t sense_data_length;
> +	struct scsi_sense_hdr sshdr;
> +	struct pqi_raid_path_request request;
> +	struct pqi_raid_error_info error_info;
> +	bool offline = false; /* Assume keep online */
> +
> +	/* Do not check controllers. */
> +	if (pqi_is_hba_lunid(device->scsi3addr))
> +		return false;
> +
> +	/* Do not check LVs. */
> +	if (pqi_is_logical_device(device))
> +		return false;
> +
> +	buffer = kmalloc(buffer_length, GFP_KERNEL);
> +	if (!buffer)
> +		return false; /* Assume not offline */
> +
> +	/* Check for SANITIZE in progress using TUR */
> +	rc = pqi_build_raid_path_request(ctrl_info, &request,
> +		TEST_UNIT_READY, RAID_CTLR_LUNID, buffer,
> +		buffer_length, 0, &dir);
> +	if (rc)
> +		goto out; /* Assume not offline */
> +
> +	memcpy(request.lun_number, device->scsi3addr, sizeof(request.lun_number));
> +
> +	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, &error_info);
> +
> +	if (rc)
> +		goto out; /* Assume not offline */
> +
> +	scsi_status = error_info.status;
> +	sense_data_length = get_unaligned_le16(&error_info.sense_data_length);
> +	if (sense_data_length == 0)
> +		sense_data_length =
> +			get_unaligned_le16(&error_info.response_data_length);
> +	if (sense_data_length) {
> +		if (sense_data_length > sizeof(error_info.data))
> +			sense_data_length = sizeof(error_info.data);
> +
> +		/*
> +		 * Check for sanitize in progress: asc:0x04, ascq: 0x1b
> +		 */
> +		if (scsi_status == SAM_STAT_CHECK_CONDITION &&
> +			scsi_normalize_sense(error_info.data,
> +				sense_data_length, &sshdr) &&
> +				sshdr.sense_key == NOT_READY &&
> +				sshdr.asc == 0x04 &&
> +				sshdr.ascq == 0x1b) {
> +			device->device_offline = true;
> +			offline = true;
> +			goto out; /* Keep device offline */
> +		}
> +	}
> +
> +out:
> +	kfree(buffer);
> +	return offline;
> +}
> +
>   static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
>   	struct pqi_scsi_dev *device,
>   	struct bmic_identify_physical_device *id_phys)
> @@ -2296,6 +2379,10 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   		if (!pqi_is_supported_device(device))
>   			continue;
>   
> +		/* Do not present disks that the OS cannot fully probe */
> +		if (pqi_keep_device_offline(ctrl_info, device))
> +			continue;
> +
>   		/* Gather information about the device. */
>   		rc = pqi_get_device_info(ctrl_info, device, id_phys);
>   		if (rc == -ENOMEM) {
> 

