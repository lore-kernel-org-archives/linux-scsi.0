Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329B3C04A6A
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 11:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbjGYLOe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbjGYLOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 07:14:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEBC3582;
        Tue, 25 Jul 2023 04:13:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oY3n025599;
        Tue, 25 Jul 2023 11:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=G57mbI+UYUM5mkP80dNMeQqNLYeYXTa3t0OmiyPdB+g=;
 b=CwwZoIB9W41hbmbaHl22Llvszof2UDL6DHoVGZMA1qpBplya06zdmH7dct06HrX1CrLQ
 K65OCpky4ycfwD+scnPt01BrxfHGTi90i+8DEUsFeqcEfjNcKwYh+4grctlWIr68Pjg6
 RQjKBlPg1ja2ynak1LqsxhTb48ncmRub3tLI1wTx29uoJdGECOzwjP/01pJUxBs50ap2
 0qHxF/p/X7TegzBVH6zg/ES9WNsi8AXscwJq4eS/CilqCGKQycgDfkh3r4jBni32IZ+z
 9fmbGrABPoKCOM9e4MrBeRZ5/HpdFZSjefnzFH7USHN+ReMTdkf5nzSZnBcGnFVeYCu1 uw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07numruc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:13:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA91uI032680;
        Tue, 25 Jul 2023 11:13:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j4uv36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:13:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IC8vs5c7BLz/2beJ6iCsWEP9WXfnRdEIy0yewEArdq3mIxaUE+7Njs2cpbOMAfPA3sol9Ac+qjzfp0iwDyCfvqOp9/lG1doLsuXeDT5EMXv/GiyUNxgx97ms+5q1rTrymKiaM/OKXrakGVs6p9p4CDZ5sUahL8wO15GlqA/ysCVbgo5ZtB5YkChPFV+aNqjmNAZDPYRLmoAHFohs74rG5zWV5g/rFYgT1OKc0/p7ABq7Z6pLn8sKWry+qOspFvhxTxuo4lkAY/fgEc3H8//5JHLrJTkb7bhH5oGQXRAoD1GWHjUqtY9EYMQkL0MVFjCnQVpLwRICvuReCNw9kOA1sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G57mbI+UYUM5mkP80dNMeQqNLYeYXTa3t0OmiyPdB+g=;
 b=FZ2PELBndTdEBf6JM7U4OOF+ocuKkn4hporqX6d2RtXWPhhIsfqLGuuBPM5Jd3Bc6evulssSuFA98z5v09HCUDSQBQOEavVE5rlMki8M9qtJKr3ZSHV0GvTxXKzyQzmTHWFpv4I01Xal6AsmzidubNpKgS2F0d4YatokeRm3CRTTDjLdSGz8mIq78xLRjcedYVWfAmiNvVTuf5iVYFq9h6Naa72PnhnwX3okW63sIYsPPFSLwug4U/XyssWm+xwllDqGFxpp5ieNBGdrtHOA60AT64zvlczR1uN1ub9cGotnCl+ohLRFaaxey9DUvlfu4Y/dhXpgbcZxD2g72TcQig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G57mbI+UYUM5mkP80dNMeQqNLYeYXTa3t0OmiyPdB+g=;
 b=WO89qyeFzR8bcjYc+NPlblWUQkCZL8y1LIvQicgGx95c0uWehDdW1MT0NGwVhwRjNK70mXMEPjx0RAtMPu1HjyBcR8Id2aONIotLTp7/9t383pFOeBDXanWOvQ0AQpuH3LyO//f3SDLNqs6k4LepvQfTHNy66G1WdsVCNfq5tLY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7348.namprd10.prod.outlook.com (2603:10b6:8:eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 11:13:05 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 11:13:05 +0000
Message-ID: <2b5d2180-cd85-3a01-eae9-bef126f37ff7@oracle.com>
Date:   Tue, 25 Jul 2023 12:13:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 5/9] ata: inline ata_port_probe()
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-6-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230721163229.399676-6-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:208:be::44) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eb711fa-8ea4-4ac3-10be-08db8d001e47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rCEZBUyU8mAZz90uwkKdKW2Btg813l1uNE7pYjKmuB186Sn7c4oRKxWjTDEtkRXpVX2aD6G4XXqvCkSRkJNqeUrppnNj7Y+LIgZQd0FjZhKBkhdl0A7udeBbvWx0aureAfuiDFxNJT7DG6PWiNBRP3jORsAezBM27/crFeoZvgPXTxb8sZSi9b9mwuLJ+UW37PjkIOE8Zv8cAKdFk/P14KckHaxQKw93ug7Zl/OxQzbnYpnH7ZJfHrNGguxY0KosWYrM/gauC939cNT1gT09ygpjq9j2AjF7330AWou+m5+LlNSHNYX7SZeGO2VXYXpqJCa4wrTzT4yOpteEOZVtCVqigewfY/jh7esL6N/Sq+mJOzlGl2TxjdgaWqb6rVChDXjo9Nu1r1qjDESYVFI5NHtX8toRj05E54U+u29IGSh8ksfh7r6OMYJxXNyLF3Sdnkadmj+KkQIMMvAdZb02D9OexNxGZDSlkCvwc9oh1c21e3+wIHVeh1ARm2XjPbUQXl/x3H+CtxHmd0LhWI6sSyQGxLl7VxMtaKVlKB/f2K+zJ+x/CCZ0kv2BCmcVBrshGoNYlmYruGHJNqudUcMsLctM03EJ4ABCb6ZG6zxvAp2tzwV5QKaYJogtgUW9ytRuttIv+lXaYQfy37oe04im6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(31686004)(8676002)(8936002)(5660300002)(41300700001)(316002)(4326008)(54906003)(2906002)(66946007)(66556008)(66476007)(6486002)(36916002)(6666004)(186003)(26005)(53546011)(478600001)(110136005)(6512007)(4744005)(6506007)(31696002)(86362001)(36756003)(2616005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG1ONktyd05tVmlWRTloUkNIV2tWNnp2ckUyaTNacUlCSDRiS1IxaUg5dGxs?=
 =?utf-8?B?TFNqR1FwR2ZpcVlHb09UU254Vmx6Ymw2d05Dc3NSWVJ6TDYxWElIUDhwUkZQ?=
 =?utf-8?B?VmMwYTMwV2ZzRGJOZFl2MVY4WndsWDlsNmVHdjB6bzJiTGc0RkdwL1ZLcENj?=
 =?utf-8?B?T1l4NmY4UlkrZ2UyUmtyWjBUUHUrUlBVV0l2S3RTTHhZYUs5cFZjYURTb0pV?=
 =?utf-8?B?dWQ2ZlRnUzNNNDVJK284dlFVc2RGU0o4ZmNXTm1PdFFYc0VVSjF0TmVINWJp?=
 =?utf-8?B?T3lObjVDaUZ5QmpmMVNNYnl5V1hjSnVMYk9FS3dkYmZJU3NucXJSUWpxMGRv?=
 =?utf-8?B?bXBtZjFkcHJDL25YYllpUTFjQzBTM3VYZi92MmxCZ2V5SWNMMFp5K0hQSkY2?=
 =?utf-8?B?STgvbWYrNHYwa2VoUldUOG1qdW1LQlUxa2d3NFUwT0xSTENiNTQrWGl5ZVZu?=
 =?utf-8?B?MkdDVXdsZVhTQ25OMjE1aHoycUluVHp0MDVhV0o4YWdjd0I1OUc5SGxFTXI4?=
 =?utf-8?B?ZXNrUWRTenlxOGZpbFI4MjErVUFXZUZrY3ZYSjZpbWF3R1hWdVZlSUIwVERI?=
 =?utf-8?B?T01SeXRQTUF1ZC85V0dFcHFMSStjeHZ1QUZWc1dKd2dnZVRWZS95UTByYmRO?=
 =?utf-8?B?MUF2cks5YVF3dmhLVGttZmlkOHkydld6TGNjWk9SdlZwMmRySzlZOUVSTFl6?=
 =?utf-8?B?L3o5TUFNeVVKcy9IWVZ6VHloaXRrb2NpaGgyMDlpWmxPWm9KV0c3Uyt5ZjBp?=
 =?utf-8?B?OGtCWHVUYnA2NXd6OTJlTzU4MnR1MVBYUWtzNlJGTkFieDgrM1d4MDRoUExP?=
 =?utf-8?B?UXBLblY3UWRFNklhZmt1a09LTngvMUZZUE5LKysrdWtic3FhaTVBbG84Q3Z6?=
 =?utf-8?B?cjdIRmsrRzMyMVYxWEZQa04zM0J6WUkvRUgxbVV5RVc0L3IwN0RENXJtMHJI?=
 =?utf-8?B?NVcvRlYwRzMvc0tzTHRlL1JOU1Z5c3VXK1c1SC9KUC9MSkdWK0NJMWxWVnUz?=
 =?utf-8?B?ZW5RbkZPNjRwbXVES2doM0RHc3E0amtLaWt4bGx3MitXWmxmOHBIdTZIQXYx?=
 =?utf-8?B?bW1sSU5lWFlnZUVqT3RDeW5TWWxoY0V6aUF2bzBJclUrRDdtOTFXWlE5Lzhq?=
 =?utf-8?B?R0hkbnkyVDFUSmhPcjU3bkZvOFo2Sm9rMy9pL2xMU0dPekxWZ2NjTTdEUmFX?=
 =?utf-8?B?V2k0R0plbmVxbVpmbVd3V1U3V1dqaTBTQ053YjZpSmQzTjY3blNUcm53TUNM?=
 =?utf-8?B?U1BsOGxDa2VjS0ZidFMwUkNSNWcvY1VKd2p0MnN3eWFlbVNBTGJzbWlBWjh2?=
 =?utf-8?B?WC9jN21FVGVYVGNLL0VPMEpSazBnOHBZVVlpdnVDSWkvODVaLzdybnJESnFG?=
 =?utf-8?B?cVhNZHNwWDRvOWxmaGh0YnVVZFhtK29GbytzSFgwbHF4Z2tWUUhDZkR2eldn?=
 =?utf-8?B?enFlai9kY0VINkhuOVhmZ0R3enNZMzRhYnVhNEh6R0p4V0FuRnlUSTAyWkdi?=
 =?utf-8?B?Qkl0R1dRL3JINkptZXp6bzJJMXlxMHJMMDNia2EzRzJneHpBYUM2TzRyU0Na?=
 =?utf-8?B?M0NWM1EwRDVtMm5zaUphODI2YjRVR0gwcjJSck5KRzJDSnJNR3JVU0ttdy8x?=
 =?utf-8?B?Mld5cU1lZUxnbHZiWkVTWnRkaC81ek8zSElKV0xOcUU1NkZsSmhWOVZiVC9t?=
 =?utf-8?B?d0EwSDhJemNHMW5ZUnFvb1BTcEhweEpIZmJ0bHFQUDhkdWdSNkNrUG1qTUdP?=
 =?utf-8?B?bkJ1c0lCaWhmMFNpdmF0azF6aEZEZFozMFRkYjMyVnI2bjJDSTVjSGpldld6?=
 =?utf-8?B?S1BBbXZZbnI4eklTUHR5VDQwWGVRMHR3bEFVTCs0dWIxaGFMNUxuWDZ4ZnhQ?=
 =?utf-8?B?dUxwZytJbUx3T0ZxVlBuTGtOam9sNWxWSkJrcmFRRGFnUTJweGZvb3NBaERo?=
 =?utf-8?B?ZXhzQ0tzdjB3RGJ4RWw1ZUIvWXhxTHRqaHdzMThmVFlSTFh6YzBKbGlIdTlJ?=
 =?utf-8?B?c2ZPa1BnT2daeFBkTjl4bEpVaSt1QUhuQ0N1U090bm5wRHROWXJPS3NPNjhp?=
 =?utf-8?B?Zlk1WHRuUjI5MkZYMFJHcml4UmxiVVpBZzF3MXBiOWhOcUV3QXlTM0U4ZXhw?=
 =?utf-8?B?R1R0cUpGUm9mcEVzbUsyMUlQZHByMEJPaldXeEw2dmxhSzZZdWRjeGRhK3NC?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VhEA3IteGvSGEVu0I8nPZsEpnczYmVdOEw7gXUYTmsK78Vd1t0Oj0TEpyc7I9Uyj39G8MDlytlCIogl/G3s3S//2Wkrr6mNVEDOrrHYpdYhOu+iBtZFfkZfFFdUXXli0vdb11C+exckA1M9Bop/tGfBrcF538Ht8affG3AZ7lztRXquUvf0mObVftaAaLd3jk7f0DafOgzTaD3gGuxcpcHv9FvP2Ux4Cxd50k3b44nLCAxtwfYD33kAaEtfWkc9bxnbYVyI0Bafo6f/Zk+32EBoFZ/RTWHKUWSqfkeh02TYrsSAgtFQDKHHNHeYq1ja019r0zxbBSST5zFcW1qn2ypmxRVzKeHXpqelw61BCixf4yRW6LxqvklyB8rJXZYyRd+bFVBbJkvkzbCMms7NR83QvNS4a/Lql2pVuYDNG6/W/sBJIN47PVQhvKY10LEklizSxcxmUm/v1OWlDCem5D/wuv/mAfBAopCuVZfsPdsucK1TyNfOxWFApga2OFsAwFN8dSiHvYlX/zoDc6FG0cRYBmY43bF4WmnWuEJEFKyPA3stECGNBc02BH7hh6iruhMuyfJsFtiFn9JlS6vP1RncVVPHpX5bP6H9c9XAkG1jKZB3Ui2gpNl/iOVBZBDrq0N3R3tIczru2gGcHONmdmH64j2MlJBlrcYRWdJpMLbLWCRQ1E8zfwpTP5EQ3/pPZ6TnENt291umDhJaCGJvU5i5DFfDdmF3XMOcfXAlaMcNgWeaAb65uJRzHEDMEHCE0P0pWVqPn7NJR0u+gkWuDESeRBt1J1XXMpRb9+P8pwama4K9C1Kvi4ASGyiaIk+3K3vjGf+WV6Tgridx2SelRM0TtvXtmAfdILs/Bx2hcj99hhcMLLmAZFLXDBpq0qU/wxykcGlxgYyRk8DRHvMsyng/LsQAwwJ5MTak+CgaQw90=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb711fa-8ea4-4ac3-10be-08db8d001e47
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 11:13:05.3205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUQJi9bsfRrzCyyURFxu34tol0I+5NRFgP9j8ccKDVsCNHjxmuzLUWC6/4+XFK5EaXn9e0rODoh5cQIU3gzr2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7348
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250097
X-Proofpoint-ORIG-GUID: bFpRCzNq5x5wnZ6V1ZL6tiKKM63xoeQ6
X-Proofpoint-GUID: bFpRCzNq5x5wnZ6V1ZL6tiKKM63xoeQ6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 17:32, Niklas Cassel wrote:
> From: Hannes Reinecke<hare@suse.de>
> 
> Just used in one place.
> 
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>
> Reviewed-by: Jason Yan<yanaijie@huawei.com>


Reviewed-by: John Garry <john.g.garry@oracle.com>
