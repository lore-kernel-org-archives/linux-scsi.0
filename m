Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F249C00528
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 10:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbjG0K3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 06:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbjG0K3E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 06:29:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E6019AD;
        Thu, 27 Jul 2023 03:28:59 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0snJG007781;
        Thu, 27 Jul 2023 10:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0mt5O/QEGh1Ii/Qx4N01U3u4Xt86gX/w9dnq5dJNuGs=;
 b=oDaN2JCPz2KSssdwTjvmNz91s8ApItATe5wsnS7wwxafQX8cAvFguih5NYj8U3wxSuDD
 j3M47DRNJm0A9L+rzpwqKj6fwh2ZfkAMhFgfqVeE+8x9B3XbhnFFPihN/TMFq0h+T5cl
 B9ZE8tmZARZcnSHNSgM087y+9xiKMCrFnWkeoOSfcOltd8cpDYLF7/6nYnaCxmbUUXgL
 wPeaoGEEC+hkaCNw2YtImUhhX3MPUo5Jyk1ixd5ghZ/b4v4IV7Mj650tsGY3N46FNcdA
 1SoG4z6YgyHEFzQTwAaf+M0R762K/HzFmhSpeQ+L5ZUzuI6lujGpLMGwJlPyG+SbiIwS cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07nusbxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 10:28:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R9CFPq030456;
        Thu, 27 Jul 2023 10:28:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05jdrpy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 10:28:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1qioyJVYcnvcX7LILKuqJWvGM39dz2TjEvJmd0oPH+XNVVSWXdJiSo/F3NNuHVscs3gr5vW2snrOHrVH5zHzccSih1vLb9xl+XK0O5lI2QP2rxJeBp4gDnJCsx/E3TBzvmsgiealVpN1rTbZTpq/UZrq7lQJBANaj0aut/nbxGJ50bwdOqXJXI0Acn5JSfYBaQMz1tQ/u/08CvL8vTZ/LZDDAZskCiBZWvVFMGMf/kvmMbRE+L4Nwxj6WmN3b3l77QTK1MxYociIwaRBy2vFZ2iwqyk2+W4VYBTZTo9reYTBwpwuXbfxnlSDaqa9pSOo8VeXa/F9BbFKgQ4slr0vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mt5O/QEGh1Ii/Qx4N01U3u4Xt86gX/w9dnq5dJNuGs=;
 b=GK59tBrirzm/3TRxQcinjbwE3pVl42V5G94qlg9ZLeah4ujq6dSX2fsoS6REaWPFVS1gZ9Gz0uoqZzWerTW3KbiSn/ehHKhCpk004Admtpvr0ylFWi6uTgJ5T0IjZsgXhx2fn9mIrG0mcBEfMyg6aHBephDWDH9H4wESCLulQgVnU/+vX6jjQcuoKSdUBR+BbSnX9Of/Pcb2DbJOzrOR0dBggJjsWIdaDewgTUuypjFwZU8DaW0uNnT4ROmCGau2Y5iRu9VKzWr7t1ZoK3pdjR2TeWtasDIFTPAMxQLF36zBJk6nbnrmxF6BoXT75aS/rSXvZbJcr77Wr+WUlc0NIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mt5O/QEGh1Ii/Qx4N01U3u4Xt86gX/w9dnq5dJNuGs=;
 b=FDJMLe31s/OQpKLJwyWXsxxedBJhpmRw1Iub7azsceJSci4HmDpXC2LkYplUeoakuSTiD+FABqZux9TsWRCSxFQ12waMud8s9BbF7MhFg57KkeaY33NEmcqlRUuXS44lAr/OvNjNAgaeYKs6QGgG1uBGttzJJ0z2Wn3OpXTEBgI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO6PR10MB5633.namprd10.prod.outlook.com (2603:10b6:303:148::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 10:28:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 10:28:35 +0000
Message-ID: <123dc4ca-88da-b2b1-44b2-791ea841572f@oracle.com>
Date:   Thu, 27 Jul 2023 11:28:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V2 5/9] scsi: hisi: take blk_mq_max_nr_hw_queues() into
 account for calculating io vectors
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-6-ming.lei@redhat.com>
 <07f84570-5307-df3c-99ab-a996bfcbf83a@oracle.com>
 <ZMHFQm2BpuGjjlTm@ovpn-8-16.pek2.redhat.com>
 <44b1bd30-426d-db85-4b52-4f079948e52a@oracle.com>
 <ZMI78klyiVUPFRZA@ovpn-8-16.pek2.redhat.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZMI78klyiVUPFRZA@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0055.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO6PR10MB5633:EE_
X-MS-Office365-Filtering-Correlation-Id: 39963211-ee12-40dc-1d82-08db8e8c3be9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: omxk6WoB7nPSWhGn8XvXUU67PNqLvHtQRLhOcCiOfcqFGx5GyWBSOx2ttoskjANea1xIaA0+p6aUg2v67B/dxjy6js0OpKSS3BASWySrFAo08asGdvf9iFbH4uHIogv6tQzL4eq2XxZ2A4Mh9ss0nEnkD1Y5KbopNIILuYEBasnWRz0ylQZUAsbR4p3Hh/+ZeamGvpKCOXeORCr4I2kkYH2XuU/RA7GwX8XY8a1dl2K1NwpcPsiUbKxRA1OQ5SeE2VVk//qIrfsV19G0GMB9JMKdcmiQUQIf+WnCS8QyZUFqHOGuZc6Ge2xWASCeuNX7KJnT8UpxJ/eICoTIzMid3w891HO3MDTQZQOBXpJhC3L6LZjscEDTOjprhgi5NRV4LSTkHvs+zwTk9jgDG5ZHIjtB2u3bc0pefyD7tyhrNb6VQVTbP7PZdKdn6DCK4lR5iR/0pt39Xv4Y0/tQwY1oM/2z7mTsBEnsX/vOMfCuB3Qomarl5BB1+5lLF3u9yeaJlZyuLxM3b/SVOq9vAKLESrIKI0axqfKLWAxAYZT/cznwjIRWuKaBDzVGctjPqTKxKdig4wQzxAlY9tuzsg+EkdpkgvTuc9iVTuKaa9uuiOEtdq0P1nYMK3DFT+hRAoqkUMSFFVtbuokZX1oq4pbFzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199021)(2906002)(36916002)(6666004)(6486002)(2616005)(38100700002)(36756003)(186003)(5660300002)(86362001)(83380400001)(31696002)(31686004)(41300700001)(8676002)(316002)(8936002)(26005)(6506007)(53546011)(66946007)(6512007)(4326008)(66476007)(66556008)(478600001)(6916009)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFNuR3ZPejk4QUJOSVM0MlRKRi9FZnZ1WDVZL3JpOWtLdjNSV0YxNWhpcXFs?=
 =?utf-8?B?T2c2K1U4SmNSRXg5a2dTVDZYaVQwRnU0dWxlVmJPYi8vdXNMRkxQaXdLdXdw?=
 =?utf-8?B?V3ZGTVZwcTVVcGoxQXlza0ZlenRrcTBjYzZDNnNuc3ZJTGRqdWtSMmhaa0JH?=
 =?utf-8?B?cEh2RC9ubUxrdHpRR2lxVjZ3a2tDWXI5UHFvZCsybTlkNkdrajdaNDJzVzl6?=
 =?utf-8?B?RDQ5bTdRWTl1UWNtMmNKUDZrRG40RWxjMWFEUFhTWExrQ3N3aDY3VmU4eURn?=
 =?utf-8?B?WEdjZjNZUE5GaHl5cVRvQmJiMXdCSE9IUktNVzBUdjcrWnFERi9Xc3VUMUMr?=
 =?utf-8?B?ZGxpeXQ4MFMwWFZ4dU4rbDlSZnNkc2paaGk1eU5CRWRRWFpSY1FlTEcrOFov?=
 =?utf-8?B?bHF0YklmVzV3RnZWc0N0S2NKdTJiRkZJb3lNUUdpZkREdytMdkJ1bCtOR1lG?=
 =?utf-8?B?WHdCU0ZUcXpyS3BqSVh4LzJoNEpRK1lFVTFJYllOemJTTEdRMHF4STJwUTdQ?=
 =?utf-8?B?THArZWlOZk50alBIdk9PbHBNRko2dmVjYUlLZFNHT1owYzVweHlTeTdMZng3?=
 =?utf-8?B?bFlDM3RhK1dwdXFZQjJlMEZIYUVnaGVwZzVBWVJXL1o5R0lBdFYrUnlWQW40?=
 =?utf-8?B?S3JqM1AzT2lCaGhDR3pYWmx0Y0VuT2wvcEFOZGw4Mis3YXRiS2dlWCt4NFZD?=
 =?utf-8?B?L2VSME85SFRTSU1heUZQVFJvcnYyY1ZmZTErQnZ4NDVTelBVTWR2YUhDYTFk?=
 =?utf-8?B?b25zUVFWQml1MTRmd3k1Y1UxSGlkc3JDYnVRQUlLT1d0MmJxK0tuWFhxNW9Z?=
 =?utf-8?B?ckoybzNSalUxazRUWUpScHFuNE8xdmE1N1NLWHBWUFBNZnJ3S25nZXBuVytQ?=
 =?utf-8?B?VFdsdlcvSnRFcTJURDFYWWF3UXVtWktLQUZQdGpYcDc0cFFGTVFuamU5cnU4?=
 =?utf-8?B?azZBL2p4MWJ2emRxWHdOT2lMb3AxL2ZBMmZLOVhTTkNqVlhRNjUveCtnS2lt?=
 =?utf-8?B?Q0lVTzJMcTFObkV6VHh6VFg5QXlXeVVCbFozMFNNVEF1ZUFUL2Y5QUc3aWFF?=
 =?utf-8?B?VDZEb1ppaXE5eFdEL0o1ckVDT05CcFRxNzlZcWNuQlFSR2MvcUtLeFNiYTRV?=
 =?utf-8?B?RWtrbU5sb3B3Z1kyT2laWEx1RVVkMlF3UjF3U2ptMG5rbk1XYWRyVDZycnZv?=
 =?utf-8?B?K0NYSm4rTVRoSjFWRjVBNzYrZHdxdlRqVTh4bWJBMTIxc2ZVM3VNQTBrczh2?=
 =?utf-8?B?R014VGZpNERsK3JFZmlCdmhQZ0p5VlJHOXV6aEs2eWkvUFlHNnFCcmRCOW8y?=
 =?utf-8?B?L3pwc3N3QVZLVkFjajUrUzdWc3MweVBXRjJBajdQR0RPNGUxc3pvaGh1cGRZ?=
 =?utf-8?B?eDRVMkpaRkRic0lFK256djlJYXdyMFBFUlRJbCtVY0J1Y0FYWjNVMmNPWVFs?=
 =?utf-8?B?cUpUT1lCSlZBRE5sbjN2T3ZveXQ4WEtWSnhSbi9hbG82dWMrNXJuMno4b21v?=
 =?utf-8?B?cVIyOUZMYWV6OWR0U2Y1NjBIUi9zTWQ1TEtPNjFaT1M3ZTlJYVpsSmJBamd3?=
 =?utf-8?B?SU9XVzFlUDhhcHVPei94ZDUyTXpnR1VvL2NCNlN5V2MrR2JFRkZYSStGZGdm?=
 =?utf-8?B?WndCbjVhQlU2Q3UyeU1Xd1NncGQ4WEdnMXg2Y1pFRVREUU10Nmt6UytzNDJx?=
 =?utf-8?B?U0plSkhKS3F5cVZGWTN4MCtNWTcvUUVMYytuUlNEb0hzSWdvcG5jeXNmbW44?=
 =?utf-8?B?WWQzN0JYRHkvdTFJOWNyNU1nUlNacmhNalF3ZFR0VHdkOEtWcHI3RG5FeE9K?=
 =?utf-8?B?bVhNQmcwd3R1QzF1MjFOdzA2RjhzVlZTU3I4YjZSbHlpOThlSExSNDdIN2o5?=
 =?utf-8?B?YkxjUmdZandjcFB0Z3ZmQXpHZnd2NHYxclZqc3Y4b2JkZ2RwOVU1YVpKdnZ3?=
 =?utf-8?B?anFSN0t3TFM5SXZKWWE3OWppbVRjSXdxSzRMYTMzL3ZCb2tERjI4aGVCdlRE?=
 =?utf-8?B?T3RWbzZLQ0VGSjdJdVVXdU5YV21zcHAzSFhlR0pvNEVaaVRmV3h1ZitIMXcy?=
 =?utf-8?B?eSsrdCszNFZkRnNVQUNsVlNMQ08wbHQyelVBaEYzV09HL3ZNM2hjaVdGSVVt?=
 =?utf-8?B?U3Q2ZmQ5YmZhcnFHWHJZY1RnTE4wUEFza3BJWmJlS2Z6ckVkVHIvL3hNYlEz?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?R1hBSzU4OFUrd2JPQ21DZEJsRmtmZk1BelJtT01BdFNsRGtxNzlrd2pLZ1Zl?=
 =?utf-8?B?ZUVpaG1ySUNGSVZTVi9uTWozNkpvOStpbThvZXJEazV1NTF4SGFvRjFZQnZE?=
 =?utf-8?B?VWZuTml2bzJXc3I4M09zMmg4M0Izbjkzc1hmSEU5RE0yNnpmM0dXOWExU1Fj?=
 =?utf-8?B?dzRBNWlRdm9GMTdvMDBPaHBrN21uZWdOdHlSYzJOdDc5S3l2TVl4QkpZSEEy?=
 =?utf-8?B?cEJpd1RjSm1ISEYwSStkdXhabE1uOUNmVndaVlQ4b2d5Z29FQUUyRlNEZjVZ?=
 =?utf-8?B?ZU90cC9UU1ArdDBDK2xRUlZXS0pyT1Q0b2p1Tk9CVW1xVXFmMUFKbjBjRHlY?=
 =?utf-8?B?YjVCWENXOXljMVlhRGxQOVlCcUV0eVpmZVh3NUMxMkNWZHBEbm5RWmFiVHVk?=
 =?utf-8?B?MmEwclo5N2E0MlBQeTV4YytQZnZ2dG1rWk1UU1BqSjRyRUtORlFkUkp3RXAz?=
 =?utf-8?B?bGxsaVdPSkxWWU1McEx5QkZzenBSY2JiQ0hBa1RIc2FmOEdFOXVmZWxldWxh?=
 =?utf-8?B?ZCtPcnRJbXNFRnhlVlJLY0dMR3VuL0FMdU9QN1dCMHJmTGNZMVNCc2JCRnI2?=
 =?utf-8?B?dlZBS1pLRzJWUGdZbHlud2FtUXo1eW1VdExMQzE3a2dnN1UvditROVoyVklD?=
 =?utf-8?B?QUxRWHJ2VnpNQllxUEY4TFJDUEoydnBkZkJOL2tra1FINWM3ZEx0YUphSzFL?=
 =?utf-8?B?eWpvSWJKYS9jaFlJenJlMW5od0tnSVZndFlqRS9mcVVRQ2EwVHlPYVRWdmxy?=
 =?utf-8?B?blpkbUY0NmVUd0ozQmIvcjdkWEVRajdFUlg4dWJ6Z2NRSkNpN2hOQ1YwUW05?=
 =?utf-8?B?N3N1bDFZS2V3UXNYWjU4d3MxdjlFTHZXSmpreFNXbjZxK252YWtmRjZYZEE5?=
 =?utf-8?B?TlBWYThMQ0srcXNFK0psV0swdnh1VlZGZXBwZTJXVHlJOVJCV2tXRjlRMmtD?=
 =?utf-8?B?R093Tk91Tm9wUnZyYzhUSmYvZHFmWlJDbVp6ai9wYU5WbmpUUnFZRXd0VWYz?=
 =?utf-8?B?TWd4dmIzSU1mSFM3QitwbmtndVdxekVtQm9NWGgyU3Z0OUF0RHRndHQ4ZDlY?=
 =?utf-8?B?QUxjMzRiRmtRK2IwbnBuZlNldithbGt2MGFKQ09lUkRpT2R5ZTZXL056UVFC?=
 =?utf-8?B?MVJZUTdUOURMMEdBNkhXZHh4UFY3eHNiZlpCVWZackpaNitBcWI2bUlScnJW?=
 =?utf-8?B?RGtUVUYyS2ttWE90WXBjZVlaZjhGb1A4b2NPS3AyaHdkRVRjcEZKVWxpTU9q?=
 =?utf-8?B?QmlUZ2lxWnpYVnBjVzFocjlMRTg5NVVKRGxvWHIyM1dTUFUwWXQzeGtpVzEx?=
 =?utf-8?Q?XpYLcuumFehboi6yQSXyMwVaGSqTvvnPRs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39963211-ee12-40dc-1d82-08db8e8c3be9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 10:28:35.6869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJwYW6iONAt/QS9mszvrS+pFK4x6TYsIGu9lIUoE0efdoZwwmPjsWItXHCIlLUyt4z1paydmfAsva1hTAmJXHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_06,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270094
X-Proofpoint-ORIG-GUID: lxI1_BoDFzKtZc80eIolpH9rBmVH25Lk
X-Proofpoint-GUID: lxI1_BoDFzKtZc80eIolpH9rBmVH25Lk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/07/2023 10:42, Ming Lei wrote:
>>>>> hisi_sas_v3_hw.c
>>>>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>>>>> @@ -2550,6 +2550,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
>>>>>     	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
>>>>> +	if (hisi_hba->cq_nvecs > scsi_max_nr_hw_queues())
>>>>> +		hisi_hba->cq_nvecs = scsi_max_nr_hw_queues();
>>>>> +
>>>>>     	shost->nr_hw_queues = hisi_hba->cq_nvecs + hisi_hba->iopoll_q_cnt;
>>>> For other drivers you limit the max MSI vectors which we try to allocate
>>>> according to scsi_max_nr_hw_queues(), but here you continue to alloc the
>>>> same max vectors but then limit the driver's completion queue count. Why not
>>>> limit the max MSI vectors also here?
>> Ah, checking again, I think that this driver always allocates maximum
>> possible MSI due to arm interrupt controller driver bug - see comment at top
>> of function interrupt_preinit_v3_hw(). IIRC, there was a problem if we
>> remove and re-insert the device driver that the GIC ITS fails to allocate
>> MSI unless all MSI were previously allocated.
> My question is actually why hisi_hba->iopoll_q_cnt is subtracted from
> allocated vectors since io poll queues does_not_  use msi vector.
> 

It is subtracted as superfluous vectors were allocated.

As I mentioned, I think that the driver is forced to allocate all 32 MSI 
vectors, even though it really needs max of 32 - iopoll_q_cnt, i.e. we 
don't need an MSI vector for a HW queue assigned to polling. Then, since 
it gets 16x MSI for cq vectors, it subtracts iopoll_q_cnt to give the 
desired count in cq_nvecs.

> So it isn't related with driver's msi vector allocation bug, is it?

My deduction is this is how this currently "works" for non-zero iopoll 
queues:
- allocate max MSI of 32, which gives 32 vectors including 16 cq 
vectors. That then gives:
    - cq_nvecs = 16 - iopoll_q_cnt
    - shost->nr_hw_queues = 16
    - 16x MSI cq vectors were spread over all CPUs

- in hisi_sas_map_queues()
    - HCTX_TYPE_DEFAULT qmap->nr_queues = 16 - iopoll_q_cnt, and for 
blk_mq_pci_map_queues() we setup affinity for 16 - iopoll_q_cnt hw 
queues. This looks broken, as we originally spread 16x vectors over all 
CPUs, but now only setup mappings for (16 - iopoll_q_cnt) vectors, whose 
affinity would spread a subset of CPUs. And then qmap->mq_map[] for 
other CPUs is not set at all.

Thanks,
John
