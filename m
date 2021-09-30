Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2726C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9646461A10
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351574AbhI3S0j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:26:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18000 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348612AbhI3S0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:26:39 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UIIDb8018050;
        Thu, 30 Sep 2021 18:24:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=j07yjTIMWPfsgUPQ2qEW+I1HYcS/ZihAQFeDkM1lnMk=;
 b=psAqJRkXBZ87vlFYTLtv7vgqliL+e4zVGAb+UPLkp2gDMIjUYruYkkkPs75dzP1xhT1o
 rRZ54hXuxaccp2fSPzbrw6cjGq+K+b8duvl74nvM9pdMIvMvIDRh8/RMj6MWgSJ2AOv5
 QdWjLWX3PVeG9ua4gWhIZpMBB97IpP7K3n9gPgn+Vp71iSCQyUs4qf7C3sob28CgvFzx
 fs7WsTlIWhDbwEwwsr/lq9Ji5UVw/TFUA0W5o/78cal6IARUg8trH7FZU7N9qqL3HfrO
 FxRfVGfKU1niYLCCo3EWwlon7/JsPn8DLIyfbkyUsI7vqmQir3i28/xPqMpjHGyNI52F JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdcquaw6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:24:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIGH8n135659;
        Thu, 30 Sep 2021 18:24:39 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by userp3020.oracle.com with ESMTP id 3bc3cgb4wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:24:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qhoov9kGvvbD4VCkfwh282oTyx9V0NVhyqGZ3RDjD9q66yt5W7tIn9UqEWc3m5NvX2EeDk5gCCExST4oF4iJfSBkbWgq8CJ/YU/R3lz8uqu3gWfwF1LqpxdiGzHLrhW4u6oVKd3fqS9Jov5uHVg/0gmHXfJyd6kbg7vuS4Fp+PZ+cozNCGplGri/WyDOHVSRCdvDxIYryWk1J3qGKLBiWHATaTrCMY+aq8hwz1aORCKyKrIE72BMrDG00EexQphjtEuRkqnO7ivkeNYsglp0Cj+ssnaj133oYivBvxAyB+kWb6hj/7e8Z7ZXNOsfS7I8G7asa7A/3AJTxWekdaUHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=j07yjTIMWPfsgUPQ2qEW+I1HYcS/ZihAQFeDkM1lnMk=;
 b=ANu/i/u94VwsEwRrOE8FXxs6VYgRIVDBFQNF0dGfSh7b0xTeN2jTelPAAsLSlZM5+ujaM6NXV7UkQFVHK8MuoiwH1YjvFP1rTi/Gw9sC5MEdrKHK898hs9AoWwFDDhAKUdGoUqq5HbsoqmSZg+Fp+zUIc+WeznpLfRg0Z+NKv4CIi8b3l3wqvsjTZrST4BwO764bOuvZYCsKo3DYV+n31fSt3bYeA2Tt7KyVmjOm/LSpCDtf2NgL5E88wcQlQ2bslJozkMzdvSjc3pseoH4/xSCeh5dxK6G8gT1mfoitJ3FgMvbLk6hYZCbP9kTFw5neescYsz31GBCnyrDTdyfV4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j07yjTIMWPfsgUPQ2qEW+I1HYcS/ZihAQFeDkM1lnMk=;
 b=YW4xpo9fJlEFLbCzFmU8gfDmDII24pdLetw5SahjqWK20vU1TP7qj7YDOuFaSRxGM0ICOaIzFMZ7LVeBEfexEBz2wI+EEQ9bwpvHIMBJFDtVC5YhbDeIUwNAogrKuXmwEQD/VWNherJbZvMi+pynO/LkG0q+wloKK7t+5GpZVwo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR10MB2032.namprd10.prod.outlook.com (2603:10b6:300:10b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 18:24:36 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:24:36 +0000
Subject: Re: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate device
 nodes for tape changers
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
 <20210928235442.201875-10-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <30179417-5aef-5055-c6ee-6aca0d5985c3@oracle.com>
Date:   Thu, 30 Sep 2021 13:24:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-10-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:806:130::35) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by SA0PR13CA0030.namprd13.prod.outlook.com (2603:10b6:806:130::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.8 via Frontend Transport; Thu, 30 Sep 2021 18:24:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76746dff-b0b9-4597-5abd-08d9843f8f07
X-MS-TrafficTypeDiagnostic: MWHPR10MB2032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB203243E3C78710BE92749451C7AA9@MWHPR10MB2032.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kTDXpY6sjrzMWPu0+Sq4xEbSkDWOJG6xu1EIiKEEzXccI4ZRZrknEqiTqjrYp93vehtCA3SuKYozgIRxZQa2XHvHvfPDUapHOQXBjk8OcplwJU5ldpPyITbN57W5GM7o/ipuyXZ/IBolaS385ppSKZs1VwzuxnsAcFSGO5sTVE5IjTQuESFbUGgKHj/3IpPIBVGTTnKNGRXld8alYq20U+1Wk+qvw9ah1uouxvQSoWCsxkf3DcFE/R9MxaBVJAnw3PdL1xJjZLyemI9dIdpmtfjQURmusItvjLxHW9Mcx3DrbBhKNm7Bz0PjzSViGF0EQlLNMa6Kybu1wUw1PmWLx6XC7nJVWiWyWOMhzCCXXWHP4KKLZgN2G7y3juv1nuq7G8RQq+wJSib0ECS4jjQu0jSYAOY43tPOSrZUPUzWjkBUUHz48GSTBEH/Rkw7E3Z1vUv4ccB9/JwMP70PFbIloQjHbe3mjyIJyeJLxhf+RdnpJiH+4R9lX2/mJruy/581Ly7TpC7pdYkWT3o7GWSwBXp073aYInY1z3TIaVVkOyqNBp2bFTAvuvpqelkt2VlpbuJhl7wf3rThWhOxLuYQYajto+jO463wyTyp3i0mOH+wGeUd37w9+1uJUgeZg7cbefbRk0FZIOtN62BWOwsElhbbshYUUgziyefG7G5mKQj67Jxvtw1HrqTsKyShYJh3itkxfun+CW26OaECE2T01Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(8936002)(66476007)(83380400001)(508600001)(66556008)(6506007)(26005)(53546011)(2906002)(8676002)(9686003)(86362001)(6512007)(5660300002)(31686004)(316002)(36756003)(31696002)(38100700002)(7416002)(2616005)(956004)(4326008)(6486002)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnU5UkY2aDFqUldvdnVzWDZBdFg0SmxJMVlQTGJHeEtrTDlsV3pvUlhpM24r?=
 =?utf-8?B?WTRCSDhCZ2hzNWYrTXluMk81T1hwRlgwSnBqdjFvYjZOSldzVjV1N0loK2tX?=
 =?utf-8?B?K0hRSTJ5dUN1bnBvOWQ4bXVFQ3l1Uzc2TlQ5d2FIZkFMRVZlV0U4RW52TjhF?=
 =?utf-8?B?bnhEbjcrWFYwOEhCNmtXVHREK3hyb3VyeHdBMjlBNlgxN3lGZVA4OVZCR2N0?=
 =?utf-8?B?NVo1ODFEbzE4RW9HdkE4dXFVWlJZME9IUm9BOTlEbkl0aXVQNmMxYTJSSnhp?=
 =?utf-8?B?Nm1IYXg5aXhXN0tsQ0ljM2paeWxCdGcydkV0cG1jcDIvazdYRGNTSDF2M2Q0?=
 =?utf-8?B?b2szQ2ZTME52bk8vY1ZTKzBjQ3Mvdk5wTVNSa25NZC9WV2lzeGRzaDBmM3k4?=
 =?utf-8?B?WmJpL0d6R0dDYjRWcWVhSm9kVUtHelNYVGFqY2hMdXZaV05nQWF2by93RGZu?=
 =?utf-8?B?RCt4Yk1kU0tVb01yRTVNU08zaDRSb0JpT0tFUi9mTmhwVDl2UjBXekdDZlFO?=
 =?utf-8?B?Z3lDK05FMTNrOElnT1ZkVHJ2eXk4UVhma3dzTVNOQi9CVDljRVBBNlNkbVpi?=
 =?utf-8?B?RnJIdHpXQ2h2STNBM2NqK2pmaWVuVFRENWlkanM4N2xZRFVJKytGYzRzTWNN?=
 =?utf-8?B?Z1B0NVhLZm1RaC9vZkZFOVFrK2lmdEUwUnFGeG1MemlpRmUvcUM4aFhsSkdO?=
 =?utf-8?B?cklZeTExejNkUmYwOVFLNkFJc2xIT3NrZGJ4V1FNbTNLWkJudkpGaDVJQU9J?=
 =?utf-8?B?S2t6dHI4MStpeEtkU3VsUnNJNGV1RDhZamRrTVV2eVZmemRrZTUwWnFXZG9p?=
 =?utf-8?B?SVFrRFRHL1dIRFVuaXJtS1dlUUFzTWxTV2lVanErZlVVYzdMSEhxZWRkUlpr?=
 =?utf-8?B?MXR1UW5ZVTIvbkNMaXlFdnkrTEswY3BtNTcyM0dmSEprSzgvN2hEYVo3dVZa?=
 =?utf-8?B?SkRNNEZXcVd3RnJDNlM3YjFrVTZIOHNSVnViM3VtSjY4VVJKUkhkdEtscktN?=
 =?utf-8?B?S2U1UXZMWm5oMVM3dUlxcGcvQ0kySVFOTWpxditqZkk0NkVZc1d1QkNiVkt5?=
 =?utf-8?B?RkZpZCtONTM3cWJZVFg5Y0tla21namFyM2FVMDVYb0NTTmM3bnp3Uk5jZjhz?=
 =?utf-8?B?RmVIODRhSUc2czR4d0FMeU9oZkxqNmpjTG5PNGh0Z3pIRFBlUUFvYzhQdUpa?=
 =?utf-8?B?cnpWK001QTJpSEFGVmhQd0Jsa29UWDd1TjR1d0hkZzRvVFkrc0tnWHRBVlUy?=
 =?utf-8?B?T2RSbnVLWnQwNFU4b1RFME1ldER4d2dBVE9XNEFYSEdMd3ljNGFJZ0RuUWY1?=
 =?utf-8?B?MlVkTnVDMjlYRnhkVWdaLzlSRVFjM0FZQm9HeWJnc2p5YXUyYURtcUk4V3ZN?=
 =?utf-8?B?TkxqRy93ZHZYZDRvRjl3UU5MQVNKbnJYcmZ3NnVJQkF4VnZMYndlZmRWSk45?=
 =?utf-8?B?ZnVWMEthc2VwenU0QTZUOCtjMXlTRWFNaWVjdk5hVXFuL0RWSjZNWTlyTzBG?=
 =?utf-8?B?dnNwWmF2bFlIRUNRZkRwTWVwSjJOZ1UxdFdtWG5HOHg4bFZkQ2t0VFNWbHh6?=
 =?utf-8?B?OUs5RXo4Q3FYOW9CTEJqR25zbDBuVmxjR0NrQ1FSU1BGaEdHMU0wb2VMZ0p5?=
 =?utf-8?B?a0ZNNTd5b0h2eU11L0JYMm1FYTJJQ1V6dTZzSmpQZDVuQnlTNERGbGphWndh?=
 =?utf-8?B?UUVZcytCbzJPVDAzeU43QXdCdmExWFpyNzJiQ2gzZURHM1RETG1PSFA4cFlV?=
 =?utf-8?Q?7ptsgQ/iTNE5P0u9YBX6/PwiIWU+M/BKxL5iT+U?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76746dff-b0b9-4597-5abd-08d9843f8f07
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:24:36.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePo+WthlEOrj9/R5I2pL2hkHwOZcFBuumeGNj2rcRRu2Ap81BxP7W9MhuUDNXeRJyd515bAUuYhsawjCWCdF98nyT6CGB4uP3ndkSqc6ESY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2032
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300112
X-Proofpoint-GUID: ZWTNv8sA27PR1O4fXmYcdSqQGCbQB2wV
X-Proofpoint-ORIG-GUID: ZWTNv8sA27PR1O4fXmYcdSqQGCbQB2wV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> Stop the OS from re-discovering multiple LUNs for
> tape drive and medium changer.
> 
> Duplicate device nodes for Ultrium tape drive and
> medium changer are being created.
> 
> The Ultrium tape drive is a multi-LUN SCSI target.
> It presents a LUN for the tape drive and a 2nd
> LUN for the medium changer.
> Our controller FW lists both LUNs in the RPL
> results.
> 
> As a result, the smartpqi driver exposes both
> devices to the OS. Then the OS does its normal
> device discovery via the SCSI REPORT LUNS command,
> which causes it to re-discover both devices a 2nd time,
> which results in the duplicate device nodes.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Acked-by: John Donnelly <john.p.donnelly@oracle.com>



> ---
>   drivers/scsi/smartpqi/smartpqi.h      |  1 +
>   drivers/scsi/smartpqi/smartpqi_init.c | 23 +++++++++++++++++++----
>   2 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
> index c439583a4ca5..aac88ac0a0b7 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -1106,6 +1106,7 @@ struct pqi_scsi_dev {
>   	u8	keep_device : 1;
>   	u8	volume_offline : 1;
>   	u8	rescan : 1;
> +	u8	ignore_device : 1;
>   	bool	aio_enabled;		/* only valid for physical disks */
>   	bool	in_remove;
>   	bool	device_offline;
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index c28eb7ea4a24..8be116992cb0 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -6297,9 +6297,13 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
>   		rphy = target_to_rphy(starget);
>   		device = pqi_find_device_by_sas_rphy(ctrl_info, rphy);
>   		if (device) {
> -			device->target = sdev_id(sdev);
> -			device->lun = sdev->lun;
> -			device->target_lun_valid = true;
> +			if (device->target_lun_valid) {
> +				device->ignore_device = true;
> +			} else {
> +				device->target = sdev_id(sdev);
> +				device->lun = sdev->lun;
> +				device->target_lun_valid = true;
> +			}
>   		}
>   	} else {
>   		device = pqi_find_scsi_dev(ctrl_info, sdev_channel(sdev),
> @@ -6336,14 +6340,25 @@ static int pqi_map_queues(struct Scsi_Host *shost)
>   					ctrl_info->pci_dev, 0);
>   }
>   
> +static inline bool pqi_is_tape_changer_device(struct pqi_scsi_dev *device)
> +{
> +	return device->devtype == TYPE_TAPE || device->devtype == TYPE_MEDIUM_CHANGER;
> +}
> +
>   static int pqi_slave_configure(struct scsi_device *sdev)
>   {
> +	int rc = 0;
>   	struct pqi_scsi_dev *device;
>   
>   	device = sdev->hostdata;
>   	device->devtype = sdev->type;
>   
> -	return 0;
> +	if (pqi_is_tape_changer_device(device) && device->ignore_device) {
> +		rc = -ENXIO;
> +		device->ignore_device = false;
> +	}
> +
> +	return rc;
>   }
>   
>   static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
> 

