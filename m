Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE55EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 00:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0EF460E97
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 00:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhJNAqd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 20:46:33 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:20366 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229496AbhJNAqd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 20:46:33 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19E0OsKo028250;
        Wed, 13 Oct 2021 17:44:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=IewcNTN/Cl/T3gYaG14cYnafxapw7RTwmDNB5AVn7DI=;
 b=VBluevwaUDC34UTaQpZtYmztU1YHYFQ/NfOmLuaCcm/dydcgPeYAyH6J7z7flX5gSj78
 BV0qXhKh2pi5EPVp43fUvmOS+AZwaBLQj/KeQBnx2dw6DytNZXkDvTcOHTrDLfJRByrJ
 uBXEZbn3kN5+eb9urCF6TedPyb7N/3BBVN4Zf8TjBVWQpPDkBrsxC5aFPy7xXamXTEKH
 OSUm8eVXGcnNWmWkJruU5Hi4U7d0YWo8kgLQHsExKP9Ox/9cvSbimWsji2h3IwG0K58v
 Ya7JNlQiaY/CocDtmvw9CpPBv8L1Oq+C/4NIZBxluRrAcGR4N3SrLlc9J29nj9DWZuTb 0w== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bnka498tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 17:44:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieXL9/FPrVVYM0bzgLXTttEHhvym0JsnPpDMuD9JSmhAvo5Mp1Zs4/4hxE78icf1Q0aBA+EWIPwssNdUMp7iZSC9NgTEHLY5aUfqKaEMIuVOTt41NxrlmvuW/JQJ2T0Gu/oMH89GSWaVJphcSNlRrl+hr+veKqhKS+CwqvDz1vh07lJo11MGCQzLUgDlT6tzZKNe3nNP22TEqttFjnZD25wCG7b0DxoX8EIZuUCyAQ1NzLHa5mz8FTbIkY7DzoYtBOtIdg5lOw4WuwYOLSef9Hh5y8+Z6pUMNhLXitvv1eZ1cSipo2+xE/8eemlKYonAVxBI2KPW3Hnt5akEaJKnfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IewcNTN/Cl/T3gYaG14cYnafxapw7RTwmDNB5AVn7DI=;
 b=oR6Zh5N2qe/gH58evB1rhHOB2XJnKGBdWl2/sgGk7AlSZEMZcfFmoofL5eCYF06McSBrWofVm+mV1DyBUMTufqtZYn44106CcP2osp+ClVNgJLkaLjHAQEcDFNFg6Knuf9prP30ERXB0wB6SW1LohSuDZcliDcIKEeEYWkxFa3IGQzn2EZIRtFKLZqlU9AQ5kTqkA8hxWJIYZz/hrer6wVPREYAzf0g9xJyc+Jap/uCYITEm+vUjnhVJAIp8AEM4tTb0bjOhjvruS/+a6Qo7x/VSVniUmgh11r0RekhVpSgKqiCsJ1fiE3oXuSots22IzOCxWwiRjaNt1blFAqygZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB2747.namprd11.prod.outlook.com (2603:10b6:5:c6::22) by
 DM6PR11MB3338.namprd11.prod.outlook.com (2603:10b6:5:9::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Thu, 14 Oct 2021 00:44:22 +0000
Received: from DM6PR11MB2747.namprd11.prod.outlook.com
 ([fe80::b431:e0f0:891a:f6ec]) by DM6PR11MB2747.namprd11.prod.outlook.com
 ([fe80::b431:e0f0:891a:f6ec%7]) with mapi id 15.20.4587.026; Thu, 14 Oct 2021
 00:44:22 +0000
Message-ID: <79269170-c390-5914-54b9-f562eb463505@windriver.com>
Date:   Thu, 14 Oct 2021 08:44:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH] scsi: smartpqi: Enable sas_address sys fs for SATA device
 type.
Content-Language: en-US
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        scott.benesh@microchip.com, don.brace@microchip.com,
        scott.teel@microchip.com, kevin.barnett@microchip.com,
        Murthy.Bhat@microchip.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yue.tao@windriver.com
References: <20211011024611.152626-1-jiping.ma2@windriver.com>
From:   "Ma, Jiping" <jiping.ma2@windriver.com>
In-Reply-To: <20211011024611.152626-1-jiping.ma2@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR0302CA0005.apcprd03.prod.outlook.com
 (2603:1096:202::15) To DM6PR11MB2747.namprd11.prod.outlook.com
 (2603:10b6:5:c6::22)
MIME-Version: 1.0
Received: from [192.168.0.108] (111.196.215.125) by HK2PR0302CA0005.apcprd03.prod.outlook.com (2603:1096:202::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.8 via Frontend Transport; Thu, 14 Oct 2021 00:44:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a01d404-35cf-4ff1-1124-08d98eabc34d
X-MS-TrafficTypeDiagnostic: DM6PR11MB3338:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB3338931ADE4C23C48C8040A1D8B89@DM6PR11MB3338.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:199;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zSEnIqEcbqEJox/t/U6Y7Kolk/re3ynnR8oBGVW9qkQb8kLyxzdpw0grsGw4JK4Nody4hxGFXiTvIYQR21FXHw6gaufcO6UJ3Gl9jxplKicyfC/1zuSeeLhlsfaOnAXzVncapYNy0GvwVDKzrevFBbzRB8LOowpzuldEeS7XsBXRaORfGxm48HRJDFgXJykbXNj7zYBxs4wOUz1WfJphNiRgY335c4x2De4po7/4Veo1k4hPQM65b183q15N3/5OwgbpEU1NVm1Ym3I+UiyorLytBTeq7QBGS9tzkQC8imXni9HPDOImJt4V68kel1GUb212KD3dkXonJqxT0U8K3Zs5cpTgXT9B3IAT2A8fcZ5RvWsYrKEugJwDgSSN16bwcagQdqjKC6mGNQcH3OX5/mLxMetiE/yS6DPDjT+ERxkkdBOkiy8GpGL5AXnxzxvudbef8VmjOdmssgu+Ys2tuXaY6dE6rYgwquW/8Dvyspgb4aovzUYTLxmVniRZOf2y3jyeZ33a+koLyFxc0thIMvfdl0zwMSr5+MEY/Au03/n/+u8IwuoBebFKDT5H/EYBpdlM+YIFgrkPiMR17X8FT5DvjJDQcgmffilbS2yVErMsHEiTaCLp391Zqrec/tugqLxPGU4o8PwPd9cyjxMyhRKlG9ZSdhViOhgBM8SjjbnAll6bkXz9Z1yAaRPXcYgOBMONQnIUAQWmx+R5xE+5MhwlkVMPSLL/jOa1/6F3TID7jwkDMZsE+s/Q+WP6utUrdbegB2ZxnLlL4bf04gtRLvDsGdpSxgCnrUlKxf1IapQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2747.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(956004)(6666004)(186003)(26005)(107886003)(8676002)(8936002)(66476007)(36756003)(38100700002)(66556008)(66946007)(38350700002)(2906002)(53546011)(6486002)(52116002)(508600001)(316002)(4326008)(86362001)(16576012)(31696002)(5660300002)(31686004)(13296009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVFsdXdDY2NEZ1lBSEJ3VXhHVENLVVdjNGtzNWptNEd3MG1vQ1o1QTlQMmtB?=
 =?utf-8?B?YXFURThjS3NJUjBCdjhEYmw3Y0lQNW1UOUxlcDFkSm96VlNsNHUwbmZxdWxw?=
 =?utf-8?B?cVFvelh4cEFMbXNQSHFaZDR6YS82b1BYVjFVWW9QNm4yejRsb0lrbExTa2py?=
 =?utf-8?B?bVhxNjFyT0xhZ2VzQUpUUlh4N1Z2QktCSlFpdUJobFhaUlhvVEpYOFFSdGFh?=
 =?utf-8?B?RmFtYktyYVYwUWh3QllKOHA0TW1XOHVUMTIvTmtITzBXMzM0V0lFU01CdjBS?=
 =?utf-8?B?d1ZOM2ZZcGw4QlF2OHZiajludG1TQS83VTlES0xUUEJ2UXNLL2psVzhvZ1JO?=
 =?utf-8?B?TUNORTF5Slk5dlBGMHZoU0tPWUltVTVZTHNLS1ZsaXdkL1hFT05GMjR2SXpN?=
 =?utf-8?B?SVdjTW9hQjY2djVqS1pEbXZhYnJZOFo3RVpaaUdVTWI3V3ZqeDF6cHVnaVdH?=
 =?utf-8?B?WkNDWTNUZjBSS3c2SWdtVHJnY1FuSjNkTXoxY28zbVJPZjJQZis4OTRTbFQw?=
 =?utf-8?B?MjdMWXptamNtdGxkMXE1MEdXb1dET05tM0NCMFltaXpIbWpyOTBGeEpUU01v?=
 =?utf-8?B?VWpZY3ZaM3kvKzhIczhrL2JNK0JYaXFXeG9VUFk3cW1UTVJJQy9OYU93eWtm?=
 =?utf-8?B?aXZHWkV4SU9CSzVDVmw5WS9TdWhHREU3TWlubkZ2QWVwZUV1aGhqVnJsdFIy?=
 =?utf-8?B?N3dzVk55aURiUU1zek5VVGZXQnl0VFMzekNDTU5wZFRvK1haYnhHbkp5akN0?=
 =?utf-8?B?VWtta3F0Q2loQmhwMlkrTHZ1S0NPaDc1blRUSkM1RVN6V3VPOXpKcEwwNi9W?=
 =?utf-8?B?WjdQaGpqUlIrOTdvRTZqRGw4VVBTaDFDdWNYVVFzc0tTS0tLazU5cC8zQkxC?=
 =?utf-8?B?azBDaGZPK2psQktPRVlmWVZ3WlBOY1llSHFTaHUraVJuOG5INXlJN2RlYkZr?=
 =?utf-8?B?N1Z4eitock5zNVhkcHlZelBUbWJiUHEyTWdrYjdERlVKY2dUamkza09hN1k5?=
 =?utf-8?B?cGFMZnk1UU5vMi9SakQzalBEbVlidnc1WkhFU3ZHVUJyRjRGMnRhWUNDY2sw?=
 =?utf-8?B?WEVXT3NJT3R1Snk5RCtUbE5pUjhtZklaQzlFUFZ1WCtVd2hhbEpnemhQZFZt?=
 =?utf-8?B?eG9RV3hqTDhzOGp4c3ZSMGdWTzFqcFZZUzBydG1hRWJxY0p4NHBIMjloeENa?=
 =?utf-8?B?eTlOTHNtenNBN0RsazBJaFNZUE5mdTBxM3V0dXk0NHJheXk5YzIvSFk3YTBo?=
 =?utf-8?B?Y2xkNksvaXZtTndzamRrdzlJN1U4UExycDZFRTlCek5oQ1RBbUIwOGcxTkNX?=
 =?utf-8?B?MFF6MThBMEJ1cFZjL2lPc1dKSkZkYkFhcUN5Tm5BZmV5b0I4Wk5mSnNmcXgw?=
 =?utf-8?B?aHF4em9WL2xYTkpHQWF5VkJabFRodGRwTEJ3S2ozL29Ud0c4MGd1M0hYV1dG?=
 =?utf-8?B?bTU5NnFCNTF1bktZQU9INnhJY0NFNDBlY0ZTaUZYZm1keUtLRzZ6U2MvYTNS?=
 =?utf-8?B?YzBzVG4yUFBiNmdOSFYrR01EUnhKSmNTVTAvRktyam5VbldSQ3Y4S1F2TnBF?=
 =?utf-8?B?MXJPOG8zTTRCaDFHbDE2VG1FQ3JKUUdEWU84RTluaGJZcUg0Z3RUTkhGWkhq?=
 =?utf-8?B?M2NpVTFzeWZ2K2tXOW9kUVFreEs4V2ZwUjRCbjlFUWQraWNiaE9KRVFHeGFh?=
 =?utf-8?B?TXJCMVlSMXgyVlhOcXpCQ1A5aEJISDY0Ymw3dW1QRDVrc2dLRmhXRGxGem9Q?=
 =?utf-8?Q?02P3uErKbYt5wdmi84Bb1nrPeuU/gd5iW4Q6WHj?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a01d404-35cf-4ff1-1124-08d98eabc34d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2747.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 00:44:22.0863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EMtVZBXWUnHL8yu1065iJyi4cRC7jv6F9qzD3GenBe13grNHM25te5ZH1sjZxywhKhhSd7LTC/kbH92mRAieO5PLoX2c8OFL6ax9LA+4YtQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3338
X-Proofpoint-ORIG-GUID: BmJvZgposyYBUU9oW_QIuJneejOOo2Pi
X-Proofpoint-GUID: BmJvZgposyYBUU9oW_QIuJneejOOo2Pi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_09,2021-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ping

Thanks,

Jiping

On 10/11/2021 10:46 AM, Jiping Ma wrote:
> Current version:
> /sys/devices/pci0000:36/0000:36:02.0/0000:3b:00.0/host0/scsi_host/host0$
> find -name sas_address -print -exec cat {} \;
> ./port-0:3/end_device-0:3/sas_device/end_device-0:3/sas_address
> 0x0000000000000000
> ./port-0:3/end_device-0:3/target0:0:2/0:0:2:0/sas_address
> cat: ./port-0:3/end_device-0:3/target0:0:2/0:0:2:0/sas_address:
> No such device
> ./port-0:1/end_device-0:1/target0:0:0/0:0:0:0/sas_address
> cat: ./port-0:1/end_device-0:1/target0:0:0/0:0:0:0/sas_address:
> No such device
> ./port-0:1/end_device-0:1/sas_device/end_device-0:1/sas_address
> 0x0000000000000000
> ./port-0:4/end_device-0:4/sas_device/end_device-0:4/sas_address
> 0x0000000000000000
> ./port-0:4/end_device-0:4/target0:0:3/0:0:3:0/sas_address
> cat: ./port-0:4/end_device-0:4/target0:0:3/0:0:3:0/sas_address:
> No such device
> ./port-0:2/end_device-0:2/sas_device/end_device-0:2/sas_address
> 0x0000000000000000
> ./port-0:2/end_device-0:2/target0:0:1/0:0:1:0/sas_address
> cat: ./port-0:2/end_device-0:2/target0:0:1/0:0:1:0/sas_address:
> No such device
>
> After patch applied:
> /sys/devices/pci0000:36/0000:36:02.0/0000:3b:00.0/host0/scsi_host/host0$
> find -name sas_address -print -exec cat {} \;
> ./port-0:3/end_device-0:3/sas_device/end_device-0:3/sas_address
> 0x31402ec001d92985
> ./port-0:3/end_device-0:3/target0:0:2/0:0:2:0/sas_address
> 0x31402ec001d92985
> ./port-0:1/end_device-0:1/target0:0:0/0:0:0:0/sas_address
> 0x31402ec001d92983
> ./port-0:1/end_device-0:1/sas_device/end_device-0:1/sas_address
> 0x31402ec001d92983
> ./port-0:4/end_device-0:4/sas_device/end_device-0:4/sas_address
> 0x31402ec001d92986
> ./port-0:4/end_device-0:4/target0:0:3/0:0:3:0/sas_address
> 0x31402ec001d92986
> ./port-0:2/end_device-0:2/sas_device/end_device-0:2/sas_address
> 0x31402ec001d92984
> ./port-0:2/end_device-0:2/target0:0:1/0:0:1:0/sas_address
> 0x31402ec001d92984
>
> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index ecb2af3f43ca..df16e0a27a41 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -2101,6 +2101,7 @@ static inline void pqi_mask_device(u8 *scsi3addr)
>   static inline bool pqi_is_device_with_sas_address(struct pqi_scsi_dev *device)
>   {
>   	switch (device->device_type) {
> +	case SA_DEVICE_TYPE_SATA:
>   	case SA_DEVICE_TYPE_SAS:
>   	case SA_DEVICE_TYPE_EXPANDER_SMP:
>   	case SA_DEVICE_TYPE_SES:
