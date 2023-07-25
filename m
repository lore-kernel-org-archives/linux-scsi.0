Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF9DC0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 15:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbjGYPWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 11:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjGYPWj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 11:22:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAAEE2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 08:22:37 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oVpQ008403;
        Tue, 25 Jul 2023 15:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=gE8xgtXvOxreodRftQFEqKyUnSJciyWPFQrCvTvVnVw=;
 b=sJkYcqV52opfNEUo4ZTVQpovRhw3bzEfMMa/9gawyutRmHp6Fitv8+YFLz2JpVmSrTIN
 Pw2Wukl1kRiHODcot6w/UE7kKUR7GEKRSx4k9GHrV+xOtKeUK6rsP95NcJRPkcWuXPCU
 Zuapjg8hKOrRwu6nXzlv/skKnj2H4da4vYbXx2E4oMj55K7SwSxr4y6+dUlPaN59gWnj
 okfYDjVRSzD7ltDTwZtaKlqMSXrWX9S3tbNXPc4Mnyoxq5NvbGZA5tWjatPLNTTN+8lw
 nMPUMNm6pJoe317AI3qaVgkP/FzxPmSx001eqRZb5MHDeE+3gKiWTKmDH3wZi0Xd5sKN Sg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d5c64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 15:22:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PEpXT8030428;
        Tue, 25 Jul 2023 15:22:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05jb6v01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 15:22:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nICPCAPGWx6GRXvYDeuy0I6wlJkdQehIpm/jEGrTkgEyRJ0thCMVsBNMhfDMmYg9Vy6IvY9n3PY9TmShwdrvR08QpRZIutXPhzm1/NzcGINfQkHY44T1w6xK6ea8sgalrjQ0Kc576YxTWR3xQW49RcLx8QCiGZOlymzZvFOwGUzbWrFfVxHHEVIldcZSK+/CKcnBH5pFVe80CA1iBOSbQJH3f/THsMN3YE8VtiHgZ/97i93rEfurEdIjnjku5uV1GN3lwL70FcXXRbuLb7VYUj96xr5VzoDufeuvcldw0XD3CojYV+5VQfJktmFGRnrXbwYHop6QbCjfpp8H4qNi/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gE8xgtXvOxreodRftQFEqKyUnSJciyWPFQrCvTvVnVw=;
 b=GarHpnLUr1Be9dQmf1APdAhYcpzg8O6jJZRKFCvXsG25rBgEX8Kms1ENvk4lbpEkbd6e4jX2qPRMSxfajytUHX6ZjmMb48CVOba37aqRtzqIuZQxxrIisDj30ztUqMKC90zvt0yiBCOONhIjX2c5JUwbSdzXbLgqBgGbl7J9cFBmYG4fBmNKBUvWQmQqYG7wfnmpmnTS2xMONVBmQmko5V2Fy1L8breD5+bcfeV8WCKFBS5njUkhJHbPC5hwZvCBOC2UEkhUfI07BdMj5i/zXfJ57h5HmhZN8Lz7mydCwC2+qPi6d3RxcYEY8X0mAD3oI+6J0iYvtj24wWEO7zTHAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gE8xgtXvOxreodRftQFEqKyUnSJciyWPFQrCvTvVnVw=;
 b=Wdi/nlYQtNvYJiM5Zertnwbe4ncCjr7cP5tpD2h/nPanVTI8+7vfRCH9vituj4CLcUUgENWAD2UbK9s1OGV4ZzbCLmwzmHF5FLu9l7rVoSYTRzFbxeNDp+XEVvnuZdqnP+ZpnqAlPjWpubPG2eSK9CxDQ5JyQzdkl1YBtmn3apA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY8PR10MB6467.namprd10.prod.outlook.com (2603:10b6:930:61::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Tue, 25 Jul
 2023 15:22:27 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6609.032; Tue, 25 Jul 2023
 15:22:27 +0000
Message-ID: <db9d595e-1d20-e83b-64ac-7afc3840c7ec@oracle.com>
Date:   Tue, 25 Jul 2023 10:22:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 13/33] scsi: rdac: Fix sshdr use
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-14-michael.christie@oracle.com>
 <f0822be9-c4be-5e3a-c260-2a97999a0e3d@oracle.com>
 <aef4186b-fde1-cf3f-c491-f2747f08f426@oracle.com>
 <e4b26cdb-9ef8-1633-86c6-81f2aa270d69@oracle.com>
 <e593026d-f803-ebcd-f9dc-3b2758432817@oracle.com>
 <256da235-24b6-4242-b245-afc818e11214@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <256da235-24b6-4242-b245-afc818e11214@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:5:18f::27) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY8PR10MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c11cb1b-2285-4a9f-ee47-08db8d22f440
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TKgZM9ayF/47F4Hy2wv8h3JKmkvbRjpSkPKzeZSehJaBb5xSvN9Kyb8H1YwIgAdpTQlVECbTLjg1bqZxBsgQMt3bS1SgieiZQb4o6Trcwa8cugEut4EVgeHwShSBukXv44h8QZJzdsggulTymthb3u4os2gTPjpWx80lX20tLvJidusaZbeyUp3mxdaVPdk1FHx3/SRFIrDJk5eCzISsiSK1HVNKKs+sqO+a3kAAMC75KpdCJxmXYQG48yY79BssTSoRx06xg3BJr2nPTiZv1cEjWa7F08z1IJszY65X9jjIqyX3KY5A340xtmfMBM4UVOmnfUA+6Kejo9nlIfPd+X6WkgXuq5xjXUAA2jYLawpVlpn6PibzpgIn7DNo28yzMHnIwQkeLnlc/yFD0/zXbFn0gvTJiQ5nSh6I3X1VaNPzblDCKfKRUgxCL0Xy5fKtCbyzKo6fqwrJ85I6eF2kH1f/2Kpdm+1/Lg9iOvEXddKC56TRDxJYLa+yKASIY76JDpqEJzoENcd7AUa2lzyLwtOD4mdZPcE6FHQM8FWdcR9DIcMukzI9ao4o3CTddUzufGda+yM1VkffYPt4R5USIY3JqgUI1E3PQdfnOzSrtYVpZURQsfo2c5BW2QfeHikZqcv4eW7aNGlLaP9Skd8FHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199021)(5660300002)(316002)(41300700001)(8676002)(31686004)(8936002)(2906002)(66476007)(66556008)(66946007)(53546011)(6506007)(26005)(38100700002)(31696002)(6512007)(86362001)(478600001)(6486002)(2616005)(186003)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OC84WGErNk1qZUVBWnZhQ0VqbjBYMDY1blRRb1Vob0RORnFZczI5Z1J1SVlk?=
 =?utf-8?B?M2JKMlRycXVFMUs4ZFA3TDA2UUZaWFB6K2tWTGtxNTlBRHNOd0s5NlA4WXlP?=
 =?utf-8?B?bWNXSDVHN1VhY3RUeXRUVWM5RHU4Q3pHWk5MeHRyUHJ1bW1kVFIrQUc2WGdJ?=
 =?utf-8?B?dW9Ob0hIaHM0cHdKOUQ3RllBZm50UFp6L1E1ZWU0WW9rMk5PVUpmZmRDYlJj?=
 =?utf-8?B?V1lvbEZLYnEyeXM0SUQ1UTd3VkpJTDFIOHA3UnNTbkZ0akNETXN1Zm9HUjFx?=
 =?utf-8?B?d2U3VXB6elErUCt3NVVxbW5DMFZjRDg0R0xsOXFRVy9pSFBRU3JmcVcwNTRW?=
 =?utf-8?B?VE8ybkFvS3QyMi93QlhJSjQyN2JQVk94TlNvQzNrQ3J1bGFxR0ljU2M2ancr?=
 =?utf-8?B?aElrQWdLeXhzUFAxNVFFaEx6eTgvd1lsdTZtN21oREg4elNHdGpsWmwzM2cy?=
 =?utf-8?B?QnJhbmJyS0F3RnhOWVMvdldLYm9MOVljcDkxMzRuZUV0YmVZZUV5RHg1ZlhI?=
 =?utf-8?B?WHBIYis0YTVYL04rNzlnUEQzbDRuUy9CR2hraEpWQmtORmVQSzJSaEN5V0M2?=
 =?utf-8?B?b3NrYUx1a2d0QzBUQ2Urc1JIbm1NbWhYL0pJSlV0VW9VMlJDYURYcUdRSVdR?=
 =?utf-8?B?Ykw3bU0vSG5Xd0M5NnRzRXVCL2d1a3JQT2oxemRvYk9DeFU0QUd3ZUNMRWtz?=
 =?utf-8?B?OE8zdUxyZzcwQkNqU3EyWkpyQ0V1RlBRT0NOcldWUVE0bk1ocXg3ZWxCRUx5?=
 =?utf-8?B?ZE9jZXllU2hnU0c0dEpaZVlycSttajZET0k2MFB4S2EvdVhXYnowYis5STVV?=
 =?utf-8?B?ME1VejJ0d3hEMFdxKzZlSTVzUVYwdW1xb1psaTlBTDg4VmVCWmZXU2ZHQ29H?=
 =?utf-8?B?ODVrK2tTcWZKdHVQOFVxdmE0K3JBSXNXRVZZMHdNWVBXWWl4TGgvYWpUNkEr?=
 =?utf-8?B?UTdPakpZcmlrOHp0eFFkT0JQUFAxZVhPSWIzdmIvVVJxS21ZbFZWYmViSE01?=
 =?utf-8?B?ZVpwalhzQ0RJY01CRXppUk11VEdLam9OSUcwRUJqVGUxR09DRjJCZTN0bzl1?=
 =?utf-8?B?NnV6aXRIQm9zM044OUJhZkY0SUU2eHBHeGhyQjdYSURBUThnNU0zTktxUXVu?=
 =?utf-8?B?QXdmTHBDNFJzUlg3ME5Ja3ZLOFppRC82ekZKSmZpTSswSGROb0pOY3VFZ2Jq?=
 =?utf-8?B?T3BJMFpBMHJUalVoYld0THQxNUFxeXpqd2J6c2cyUjcwcEdzSFBid210TEZr?=
 =?utf-8?B?NWJOR1VJSC92Y05HSHVuNnNqUDZKVmI2Q3Z0TmdxZzI5aHQ0NzR2RTRBZVBj?=
 =?utf-8?B?cG0rNHA0d3RzQzdPMmdXV1RPOS9jZXN6RGh0VTFhbHdvYm5YQkowQkV6SWtD?=
 =?utf-8?B?SVBUSVRSNU5mT3NacUovRmRTRWFxLzQ1S3l4TERwODZoUzhpYm92VXppc1h4?=
 =?utf-8?B?RzFzYWNId2M5REZKck5xOHh2V1R0LzFDbHB1SDJocjhvU1NVclpwR3RnZjA4?=
 =?utf-8?B?QkJXMjJ2bG0vWDFhUW1zRGRSM3d3bVA3STZQWU9ML2NHU2tjdUt0RzcvRzQ1?=
 =?utf-8?B?cFRLWTczdUcyRE1Db0t4Nmd3WmZGMmJFSy9yTWxCUURPaUpveHQyOGx5SEE3?=
 =?utf-8?B?bnZ3MWJxWEhHWWxDZ0tTVjBaQ245OHgyMkJkcmlyOHB6aEZHMk9oSlh3QzdV?=
 =?utf-8?B?YUZWSk91ZEtSbmdOQ1NxaGZUSGYrT2NFbHhwd1l6NTdIYllicGMwQUJQbUlr?=
 =?utf-8?B?WEVJMlE0ZW5YekVrTTRxT3FLdFZRN29pOHVhc2JOajZJcjA2bkp5aFdCL29X?=
 =?utf-8?B?czlldlB6R0pJamlqU3NqTHhGNW85TnpRaWV1dWo0NmJtTHBVY1VYYjQ3Ymcr?=
 =?utf-8?B?U1kwb3llYWZyNmVPQlNLelRaWlB6WDJmSXRDNmJFaW5jMHpzby9Cc1ZDeUZp?=
 =?utf-8?B?Z2lHenUvVTlVVDVVczFMazdjOE9UNXZnK0tOUmY5Ym56S1ZWMWZFeXBlblNO?=
 =?utf-8?B?VzhKcWtsSDVWK2hEME1mRUpPem5jQVovTDVadGg0Y0lJWlU0RmtJVVV1M2tS?=
 =?utf-8?B?Y3c4VGhnTDc3VVI4K0xUaUhpZ1l3QkNqbHVOZmQyWVhpdm1iZXVGalQrcVFM?=
 =?utf-8?B?QUczZXI0SGx1encvajZEYjdSRTNzbkgxN0VaQVord09qQi9hRWlhOXFOczhC?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gRr1saEbXqnHV7nvbGihW0qcn0LC4h6X+yv53ZsDQmAujvBR1G5PUPfeCStNwKlUwn0W0H/savkaFqc7Y81qfyRSbWqccKBQYURfJwXQ0m3YfadqclLsjiGrCkR/sKHKfwiDhqenNrpsRwfmEyHuFu9cDatlZxK5H3aQTix7NHJeHigpK76/NqEZzTQZO/8VMgpJDXlXclgNDrB6RjVA9VTi5J7TVjSjWqKR0ivcgVkZsuJDAUy41/wLAp8WYRICqu8hHH0oS+lXyFMX9fBVZJl9aVBiOga9gmSUqehsjGk8ligvOTAuL4vlfC/WUQpeOmF/vjrmv6O2hLnWr2jhYfQk4QdxwMvs4dCujKV6bXubSTPlzdKMSraK/c1pOAcvTH1svJi8HTV91THVpMgxo97yTULu2e8IS421gF0+i2FUjVkHtln/hWxr4QcImX0SBEHRNJ+8he1ZVcoZlt9qECGgu9LMeSDG594EVBUtlBnmHboA/6auo3q2deBf1AT0KIdWtUO2xnm+yMbHWLko49uR8zYa/cBjMEzXYjewAqj5aNPVOGbdwW8WbNeVLxuscEi5kn304PFu6H9aVcMIF0MJYy8E5fZaoJVeMxIrV9Uq7tFUiRIiATHOATbR8JcdyNe5JXyQJvBslaFrWf2H5t1kom5At8y/WnjaZQgp3BVg5YJO3Yy7LKN+uqsy51LYzYH9DEU0utt0DfwFLTUamMxsylNpT1BIsRBVwx5P6pLZLpwrp0RcVvI/rczn+i2VM9SFN5cqydP5PkmAJTYbYsHaKguv/UzF81GeY02u24gvMGMbZumq3d9jqpQNuRqjdJQkYxG8Ue0ZONel8N4JT5EdLwYITE5Cps21vJb4XFA7C1fmt12Hl/tTwpBQukBN
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c11cb1b-2285-4a9f-ee47-08db8d22f440
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 15:22:27.1520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1av/oq1T6fZ1nlerT7V2PIBPX+4kd1arj+6t83M6DfVPEhewsUbnLS5cgY+zN0qcYE1kSgb+2xiwpxonDkkJvnpeG0kQjayxBcwEpBeDo5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_08,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307250135
X-Proofpoint-ORIG-GUID: HdCuYTmpBHKROuGWgFEIxcVi_oBsjKWd
X-Proofpoint-GUID: HdCuYTmpBHKROuGWgFEIxcVi_oBsjKWd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/25/23 02:59, John Garry wrote:
> On 22/07/2023 18:10, Mike Christie wrote:
>>>>> As I see, err is initially set to SCSI_DH_OK when declared. Then if we need to retry and 2nd call to scsi_execute_cmd() passes, such that rc == 0, then err still holds the old value. This seems same as pre-existing behaviour - is this proper?
>>>> I guess this has been working by accident.
>>>>
>>>> When that happens we end up returning one of the retryable error codes
>>>> to dm-multipath. It will then recall us, and before we re-run this
>>>> function we will run check_ownership and see that the last call worked.
>>>>
> 
> Hi Mike,
> 
>>> I'd suggest that we fix this up as a prep patch, if you don't mind.
>>>
>> Do you mean just change the description of this patch to reflect it fixes the
>> second bug? It already is a prep patch. The second rdac patch is built over it.
> 
> AFAICS, this patch does not fix the bug where @err may hold a stale value. However this broken code goes away later in the series.
> 

Ah shoot, you're right. I should have stayed on vacation one more day :)

>> stable can take the sshdr fix patches without the API change ones if they want.
>>
>> I just put the sshdr one next to the API change one, so reviewers wouldn't
>> have to jump back and forth between the front and back of the patchset.
>>
>> Do you mean move all the sshd hdr patches to a separate patchset?
> No, I was just suggesting that we fix the broken code also in a separate patch in this series, like:
> 

Got it. I'll add that patch to the series.

