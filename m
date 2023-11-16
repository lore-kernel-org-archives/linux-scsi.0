Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939F7C197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 16:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjKPQoi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 11:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbjKPQog (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 11:44:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9921AD63
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 08:44:32 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGGXkNU005851;
        Thu, 16 Nov 2023 16:44:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=JpmiHR46zz83itkkuV3e7T2iZGxyak/P7JeLvBkbeGA=;
 b=dZhAhyQ6KTQHRygSfCVbuAoK89RRJNsc2eABjHW8sjQY7Sc0hea15V9dnEUNYJans86r
 kyP4dNyUjJZwn0aVaVmQVWSTw6aQVVAbvnf6iU9S1KdSzH7iJaXWCyhv8Bffp8gGVFXk
 zScXS4iGsm8wFz3qHxvivdy/wnJtmNwCbJoOB99Rr3ZwbGtBg8uOz+SNocgJFKNlC+zw
 wq7mIlgCPt6yuIyr5rc5EC1eGVJzguYLgR6SPT72bZwXPgta58Fr/6JoutxwZHz/Q9TX
 awPnePyL2VpYPgbxfwYtmpLd1hFv62b5fbwSHlfZTA3FsKrHToaxGzJLqMJU7S2a204E lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2na3hth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 16:44:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGGOPeg038299;
        Thu, 16 Nov 2023 16:44:24 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxq0w233-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 16:44:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lik2NJZfQVokSWl/w9hY3Am3y+X6t5RtWF/IKMTmdITP1darzopuKvEunaDuDyZ5u2DAam0G0PAMgXfIgtmpM+U2LfO/jwSKKi2ZIPdklR60CQmfAcBkjKc5xuQYsK/M4of4yYfxUkZReG/WxKaFGp0i4kPryCj0Sqn9C9GgrBTjMOjTPrtAxsZEVqixw7ijOXSAFCxfEBDb2XZw0+8hjMUAzioNyDqn7hhQwUz2d69gqsw2I3lNiQ2p3cM1ksHzXG1jW+gxF2wUAebnCm6yf8z4+jnM/8nmvI3B58bEiDMQ+qtaraHe82Uf4sEEA5WX4dWaud4Rr4AzdkbzrEwIsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpmiHR46zz83itkkuV3e7T2iZGxyak/P7JeLvBkbeGA=;
 b=nt+HcMvEp4vyAiahBe2NHSftQHfyq/UFxJjw2tzez7RAjrQW7t0Xya4LmnIYxQ7g/HayolnapqPwiqAP+qIMZKvMa1jGjC+S+uj6BkmqtF13lICu0z1QEpHUGf41kmDWwtEDXnwjUZqDYntgAla9/Jovwz4VdlIX1O4JHnzJe0kf5Kwpz+ebVxpQ9EpixZj+0p910D4aJIc103PBPqZmonYQtZwNk9tP3IXUT4zGH32zTSfdn7casCVWKBB9IHkU5ZW78yB/JNrVp+GVdw/uZgkXYITpib0aERLDdPxT917b8GU0Q1OtEzPAVXq9IBd+QswWPMzkgJ1KkpzCR4YHOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpmiHR46zz83itkkuV3e7T2iZGxyak/P7JeLvBkbeGA=;
 b=nLM1jL612QoEGoyWpRv5CYCfNjkIwmVdhvAoVvfwHqPnc+kW/RhnYzzDaxU05NHJ5HdyO+oTAJdunJ8XhlrqLoQcoxFjvkq+MiS6rH2IaGIH6tfM/+nuOKi5BTJp5MZSCJfSgM0lXHsNqHkDJzO44HCbP6UhD6v3g+gaFcglOLg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BN0PR10MB5159.namprd10.prod.outlook.com (2603:10b6:408:116::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Thu, 16 Nov
 2023 16:44:22 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.7002.019; Thu, 16 Nov 2023
 16:44:22 +0000
Message-ID: <c1fb5565-2d78-41d4-a422-5c7520f9cddb@oracle.com>
Date:   Thu, 16 Nov 2023 10:44:20 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/20] scsi: Have scsi-ml retry sd_spinup_disk errors
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, mwilck@suse.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
 <20231114013750.76609-7-michael.christie@oracle.com>
 <063ff49f-82ef-4ca8-a384-3a7815d2273e@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <063ff49f-82ef-4ca8-a384-3a7815d2273e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR06CA0034.namprd06.prod.outlook.com
 (2603:10b6:5:120::47) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BN0PR10MB5159:EE_
X-MS-Office365-Filtering-Correlation-Id: e1dba5dd-e2de-4b83-93d5-08dbe6c348df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +oel58SlX3iTBZOOssfkzujEx6Z1JeukTl9qQlD7x9a9I+DGgIcmMHjZbX75xmIVvEu/HK0PrjAAxw1ouOl7TWTDkH+QbCl3C1zwn6SQ5/XlnXFcQJjd+V5MO3y+E1AvzFpPToOhSrZTPqMf5c+/fqHnxmg6ureibh8oTWGE8MQK1y4YqFWMpde+QFMeBXhHKpD+gyM4wdRtnma9oW32Gsuy/Wxfyn6CscbWvdFWiWcuUEA6BXHg2N/RYpwyGWBaIR4hkgsHTiGfkkD0Lnee+r55SuFaVBiityZQoOUsAtYdEKi71IFHQ8UlJ/qYJ0xlyas8MyZOO2clNU7mBljCxqKiB3vPQt3YQa332MCRhMpqnTahcRp3yFRPPMJPSJRGXR3p3x0KSoei6v3/rGyi03QOgkm9cwXz7bqLBjh6zNS7I783yZcdPuvP6UtcVySjNobiU5kSYD8i/PcmPZQpFh8smSOfUcbpBaKKxbany2Xe3TPsbPIC6Y3g5/kkIG6kF5kQmOfPYlHfG/49dNykhIcDegGSXjrnrI07k3Imp6nl18rWR6rzBAsQ+HNyLHgTLdHK+arDIFd1vrLIjfWVQrKxSz9J3rhfI18VidgK38OOr7jHoMNyiUWGZaSIXOdhYXHsos7aKTEpUOnPdMxvNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39860400002)(376002)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(31686004)(38100700002)(83380400001)(2616005)(26005)(53546011)(6512007)(6506007)(86362001)(31696002)(66946007)(66476007)(478600001)(66556008)(6486002)(316002)(8936002)(8676002)(2906002)(5660300002)(41300700001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlhiR2JtUmZyMU1uZFlZem1YdFRUUVoxU202c243d25CNXVmc1dLRWt2Smls?=
 =?utf-8?B?Z1Z3TDZjTE9EZ3FkNDJ3aHFrWmdNajkvV0hFenZJUlNRTm9FNm5PdW1rSGdr?=
 =?utf-8?B?MndXQVlNaklxOEFYREFYYysrdEJzSzF6d0MzOVVWWjk3T3Y0LzJReDNDeklQ?=
 =?utf-8?B?UytENEFFYWptVWp4YTU0OVBPTG1JcGpTeFF1UWdPN0pqMU1qRWdkOWZSbjFP?=
 =?utf-8?B?eDNEYnVxajErc0NmUytScEVGQTkrSTFkdXdLSDBtRzloZDhRdXFmZUd2VnlI?=
 =?utf-8?B?bHBYQklXSVNCQlhzU29oWklmWWYyd0s4S21oZSt2dUhzSlBVZ0dKM1E3REZG?=
 =?utf-8?B?M3pmc3ZYUzZ0MTdrL2JlVE9XQ1U1K2wrcE1Ga1hxMFhkUVVQY0Z2T0NxR1hx?=
 =?utf-8?B?VlN1WEtSa2VBMnlOR05ZM0FEbGpVTU5DdE9jcTdFMVlPT1UxekpDRk9MdCtJ?=
 =?utf-8?B?TWR3bUVOaEtlVnhHVk5UcTNQcHJwQzFhV0JmUnExaUlpemErRW9IWW5lRHZV?=
 =?utf-8?B?UGM2Nzl2N3FwOUxFU2xqUitMQVdRRkJrc1I1S2E0aTJFRGwvaE5zOEdDTmgz?=
 =?utf-8?B?QmJPVGtZb2cxWExMRENMOE41Mk9sSG5ZUkNuR3BwU2wyTGlabmhVdEIwOVpT?=
 =?utf-8?B?bVdEUE51NDNHUWZQSWEzdEt0NnNMOXFlZkp6MlZJOGRPc3ErUStkQzU2cEp1?=
 =?utf-8?B?bmtjdWtremx0LzBjUlVKaFdwdm9CakM1SlhiQ3hKbzQ1TCtDWkZTNW85aHhR?=
 =?utf-8?B?ZEJXZWQzcjdzOTNtWm5nQ2twblNDbC9UUUhsSXRHSkd6RUcxTVRWZlBTUmEy?=
 =?utf-8?B?RlRQRXBMMmlHUm54M1FXSTBaVDJ1ZW5oUlhFOFBaR2dpVzE0eXd0T2tBQnJO?=
 =?utf-8?B?eXVEd2ZGelhkeVJYK08xVFBlTk1LWDBXNHBIY1BGZlRNN0dNWlUxd3BiYjJl?=
 =?utf-8?B?WUdGbU5qeVI4V20yYVNURW52ZGZvU0dZajhRMGw0ZzhlbHg0cE9GQnY3QlBx?=
 =?utf-8?B?ZW00ei9vWDlPTmFieldsb2ZOam1kRTJNYVo0c0w3Ni9idjRMTUxGL3dHYTlS?=
 =?utf-8?B?cVNXN3l0cWU3NzVRYWFNZmVvN3dITGNzQ3FGb2U3QlBNZTFUYU9FVExxcTRm?=
 =?utf-8?B?U2NMKzJFMlhlSGx5MWZxeFhXMDZ5TkFGQjllRFR0VE04K1pJNlNjVWlmOHlK?=
 =?utf-8?B?ZTYvZlNyNnFIZXZuMnVjMWlGaXJYQnExalVxZys1L04rZWJ3cEM0bWFkT0xN?=
 =?utf-8?B?TjZNRlB6Y3lZQklDR2VzRmN3QTQrZDFEeDVhbUNoK2FSZ3Q1YjUzUDQ1RFNO?=
 =?utf-8?B?YVh4RVErLytqUmpQUWp1WmdDOVJVSFdhYUhwTWk5b3Y1bU1HVU9keVJVY21N?=
 =?utf-8?B?VFlrUzI1YkphYjdzTU1iaHJhNzI3VWY0TEhYczFzbW9CTWdYaG1DcjcrS1VE?=
 =?utf-8?B?a0Y5dllJS1l6WU1ldnpDcWM4QVNVQXY2SlRIc3ZJM1VpWi9uSExySm5ocXho?=
 =?utf-8?B?b3g3RDNhREZuSHRVMjlkWjdRdVRZVFZhSFFSS0QwZ1pjWUhjRWpCQi9IdTh4?=
 =?utf-8?B?TjVOZVhydnB6Z29DR0xWQ1pVRWZXYytMUEhpbCtIWUh1a3phQ2lsUVV4SzE5?=
 =?utf-8?B?ekh0MUMyd3Z1RHJac0o4T1ZFN3dMSFVYdTVZRUJjVUF5R2JPMllXdU9QaFZ0?=
 =?utf-8?B?YVMrVkZQWVdSYzY5UngvWWZqV3U2TDZtU1JuVFVFdnFqVGJZMFplTEgxRnBo?=
 =?utf-8?B?NytsQWlQdU5SWE10azVoUjFQWlVyQncxTHFORGFQcGlzN1JnZno5cDVmMi9n?=
 =?utf-8?B?UEgyY0trN0doREpoNXpoTGp1VTVNaUY3Q0JDNGRvMVNWRkN1OFd3UzE2ckVQ?=
 =?utf-8?B?Z1J4N3NsV2pzQlk3V1FaazBnYkw0d0FhdlFoM0ZoZVp3dmVXOVhMd0EyTUJ5?=
 =?utf-8?B?WGFDdmZFM3N3WW5KdUtGT2p1Y2FUVnhwa3NwUE5YMGI0eGpjZ2hLNllBWjRL?=
 =?utf-8?B?eDJOUkFYRTlWNFNVWVRaeG04UHN4T0JxSHhKVGRUUDRocWR4eWdVY0Zsb0lj?=
 =?utf-8?B?VkZ5bURRa3dxemZ0QVM0MEFWTHdleEhPVWlnZUt4VFZRMU5jVDM0QVZJUHRI?=
 =?utf-8?B?S1B5UXVzZFlZN1MwbXkzTTFxcERlZU5QWG1NeFF4NHFRUmI4VHFRQ2o3SDdT?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: k7IwEFxn55tAzxH/qyzvk6TnUJKUTho1bGsHUOfG7R5iWwRkNzzQeh+hrD03OGqIoTx79FQF+qLcJhUD7JQY2dGoQSq8n57siFbL9XJBYV3SUNmnPM5r1SKwdxpZ2UOFJYxr/9wn5KJRu83qNgWf3yO+gfGHdY96uA79OsdEmc+uT1MnOHKwQC97mIrEKfW8UCYIh0se7O+0tViHnWoHW364DWQM3qsjVu4+ZkZPec4vTKVhJJ/cm3uF/lHjfu+6xRylzXLzbUnF+YVKTcFdKwjOedpdunHSbxII1hJ2Uh19L/GovU8lgegTiaRlASSqnE2JEQHeP68vhJZtwVgGuSwra4o5pTJnRRDKpGgcE3uF9UIMtp80v3uEeH3AAXCVb80iDSCFxzT4T55FXWdQFlNJD2EhwIT+dY7g3qWZvTnUAotmzB7iPm9/nnD1cYfeevme/2tOHB/NL3rfazyN7n6IUymGmfmC2ylvLBTrsqtzrd5JBSQwx4XfTB+m+3XVp4Pp8L7N9DguueYGrhvUF7I52ShJJ0+N5KfPqnrJY0dwzzp+zXMr5GViJGThDtA+Rz7qy75zflEKN92XaI7xyR7zAAttnP5TFrcw4NDh0Csbwuc6z8V4Bkv+5FL5SEdZu/Q2vVfN7DXlNMK4wRWa4UP/ij/jHJbnemJJBMynh8/QVBh4alMbcWpL//Mda7SyA5wA1ALyf8jb2Z486JMX5aKyIMxVNMBWJUR2IgNYE9R53A6iCYQIB53KDIDi6VrSjVYeico+5+sREIyfDyUmEChKvNMEobefuSV1nXlFD4Z4IOEJC63xzHsb11JSBsbRSEai2pjkt3TWVEWzg9BBz2mMIuvnVHkBDU03JufQwRbkzaybvsd4yX/5UoX9/Td+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1dba5dd-e2de-4b83-93d5-08dbe6c348df
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 16:44:21.9905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LdnlEwDBY/H2CjZREzhMNn3NLv0vV9sy/r9uZXRaWgsV1EYtVN/GLxii3UCI0N3T3VohWESN+oq5yJifu9fQ7ZCHFpE2g064eqOPFc3N1Lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_17,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311160131
X-Proofpoint-GUID: QvsVwpNgXkZe8xPNLEKn2BWdSOfogu0p
X-Proofpoint-ORIG-GUID: QvsVwpNgXkZe8xPNLEKn2BWdSOfogu0p
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/23 6:13 AM, John Garry wrote:
> On 14/11/2023 01:37, Mike Christie wrote:
> 
> Hi Mike,
> 
>> This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
>> we retried specifically on a UA and also if scsi_status_is_good returned
>> failed which would happen for all check conditions. In this patch we use
>> SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
>> when scsi_status_is_good returns false and there is status. This will
>> cover all CCs including UAs so there is no explicit failures arrary entry
> 
> /s/arrary/array/
> 
>> for UAs.
> 
> But the first failure_defs member is for UNIT_ATTENTION, below, right?
> 

I should not have written "on a UA" above. We want to retry every UA
except that first entries in that array.

This first and second entry says if we see it then fail. However, if
it's not that specific failure value, then the last entry
SCMD_FAILURE_STAT_ANY kicks in and scsi_execute_cmd will retry.

It's so for this chunk:

-			the_result = scsi_execute_cmd(sdkp->device, cmd,
-						      REQ_OP_DRV_IN, NULL, 0,
-						      SD_TIMEOUT,
-						      sdkp->max_retries,
-						      &exec_args);
 
-			if (the_result > 0) {
-				/*
-				 * If the drive has indicated to us that it
-				 * doesn't have any media in it, don't bother
-				 * with any more polling.
-				 */
-				if (media_not_present(sdkp, &sshdr)) {
-					if (media_was_present)
-						sd_printk(KERN_NOTICE, sdkp,
-							  "Media removed, stopped polling\n");
-					return;
-				}

we will not retry if we get media_not_present but then retry here:

-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));



>> +    struct scsi_failure failure_defs[] = {
>> +        /* Do not retry Medium Not Present */
>> +        {
>> +            .sense = UNIT_ATTENTION,
>> +            .asc = 0x3A,
>> +            .ascq = SCMD_FAILURE_ASCQ_ANY,
>> +            .result = SAM_STAT_CHECK_CONDITION,
>> +        },
>> +        {
>> +            .sense = NOT_READY,
>> +            .asc = 0x3A,
>> +            .ascq = SCMD_FAILURE_ASCQ_ANY,
>> +            .result = SAM_STAT_CHECK_CONDITION,
>> +        },
>> +        /* Retry when scsi_status_is_good would return false 3 times */
>> +        {
>> +            .result = SCMD_FAILURE_STAT_ANY,
>> +            .allowed = 3,
>> +        },
>> +        {}
> 

