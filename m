Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9CDCCA47A
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jun 2022 16:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiFSQim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jun 2022 12:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbiFSQiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2022 12:38:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABFDCE34;
        Sun, 19 Jun 2022 09:38:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25JEU3Pq014639;
        Sun, 19 Jun 2022 16:38:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=k5+OxDlhDUwTElDFv4vlBbSFrT0tkibbKkgZRgnOtKA=;
 b=tr16xjiIPYeq1JeXKpr58DgHhfwjCpHX2knpxCk5R75qcvDUGArcB3m9qL2an9NdMi3n
 PawaeEYfat1F+0P6ALDVxRd0kv5PdxMNSApKsVpRN4vJJZ3iotcfYv+qPYSBhBlFZicA
 /EkV9BJNYGNLPcl4IniOsfRQ8jbquByTGFzvhpVU5JcuT6ZSHwqvo+Ddw1kE13Y0gg2j
 Hy3EYowvEm8qPop20RF6dV++QoU6e0DpGUprSwjEqkSNlta7gIxcKRqfTUrzSoNU50VO
 Z+tUWsNkrAxxMVErDlMvDOVHWV7Se677DWPgQi1PRlPah7CEQEFUax3jK7OSwfvQXyf0 fA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs78tskpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Jun 2022 16:38:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25JGUY0c009195;
        Sun, 19 Jun 2022 16:38:17 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gs551my2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Jun 2022 16:38:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAGHbYIgo7ig3F9wHrcvk5MxMntBgwbUk24QZJFvFmzO4TsbB2/FYy0tfy69evFrtm4wGeZT0d0Sqd88M+RzNz5nI0xf5eXIb0E85TG440ksskB6OqRiu2LRIrKa3FW/ROWl9h0akvoB8m/xQIs/Jy7ijeE9f3OixdQ1ti+Tp7BmmDyviwRLGXoIrPkuHXjUtdxtnAm+o2pjARGyClkJa4TDCFGrBhHP2ds35vf3boQP1XYDgqfuTpW5wrWHWYPECaOkY9CI+jIwW+F8IhiwJPWdUVvvsBUhp6Wt86u3nhViuFFQTW19PHelNlKrpbWL8HMdpbs5ndYBNfKKQoZoDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5+OxDlhDUwTElDFv4vlBbSFrT0tkibbKkgZRgnOtKA=;
 b=jgosBlwJGHI7iQvSP3j5On1ikCLSg3rpdfVeM9gxrKRFBs1zV56anmhlo4G3MYkK4hiqJEf9GvKKMm714GvlS4hr4EEarPAAbcT36MwRowVg/DNZklmFN7Xm7BfP+kiZRUiPPyE/ZSDS36IWvdPrnorMt3luyt791Q8H0SJUif4xT4YE8n0IDm5IcAF5+q4eTwSQ8oQMphsTSLNThnta1kpH1S+05bVOCx5VW931CQDTJiNCzRmtcSOEWF3Ze+n7Hgar9jdGdJ/8t3AxAzuSZnT8JZfVBPHiiJoBxuEMcX1vBNJtfazTGlO/4BssL047YhgJahktM27d180KRF0OQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5+OxDlhDUwTElDFv4vlBbSFrT0tkibbKkgZRgnOtKA=;
 b=t3s3J0mASWFvRRprDgcZ+JwCEAvdpkhao9T0klJ5OiditTo+eXOjZjTwfc1y3sO2XvTKS3ZqkP0D94Y+rG5yhLlyPbrfqLOXeptQKiX1cWYPYOtj5Ymy+AJAMeCmXQvraMoq+ELSTxzSA5tVd7w2xB1mXfXIjYCFYlL3mXrYwVc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4710.namprd10.prod.outlook.com (2603:10b6:510:3e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 16:38:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5353.018; Sun, 19 Jun 2022
 16:38:15 +0000
Message-ID: <f0b4571e-559a-18c9-d1cc-35f66a588779@oracle.com>
Date:   Sun, 19 Jun 2022 11:38:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH 2/4] scsi: target: Fix WRITE_SAME NDOB handling in file
Content-Language: en-US
From:   michael.christie@oracle.com
To:     Christoph Hellwig <hch@infradead.org>
Cc:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220617030440.116427-1-michael.christie@oracle.com>
 <20220617030440.116427-3-michael.christie@oracle.com>
 <Yq7BU8EpZZh+C1QB@infradead.org>
 <5f6d0dac-5eb2-ee02-3786-bfb83be5a3f7@oracle.com>
In-Reply-To: <5f6d0dac-5eb2-ee02-3786-bfb83be5a3f7@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR10CA0016.namprd10.prod.outlook.com (2603:10b6:4:2::26)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e7852e9-3107-4426-8056-08da52121b64
X-MS-TrafficTypeDiagnostic: PH0PR10MB4710:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB47108A9CA4A4C81EA501D596F1B19@PH0PR10MB4710.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LXe61xL9osi7K1cWxZgYxkCHPIIniqemV3zDxPY9AJH1Ose+nVtPz0UFMjOy9OoxtvgaEFdYEpqFn9Gd8ouQoBZcfJEcKhD1biHGcSpxKcYD5EHuGhiEVJuIlxjN8gZuWEG+6jBaMUJp8JgpMdRTmELoM/I9cbCTwieVazqJFiwaUqvwKqBqy5o1YUGGQD+mt+4j8JHTJ4d1C/7pXkzPI95OZgdZuns2Wmgh/RJ1XkYj9JsgYzte60PerZbpMycOcl5dmyh1wnL9DCTfsprsJDZLBlQ90IdGREzJMZpIisGCsZYowgfeh5zkGPopZJf2iOe8ZR6uZRAL5+tjXLgfv6DbzXPPCpycj51xEbt23gfNw6pILPjCU8HQQXFH0pwMzpnCi2VZQgN2mTuEL/d/AwEon4W3wRWAiCC7Pt7x23DcVvfdBe0OKUH0Z/yIefOkk03pJMITiIB7u8dwVQ/Osqs/3pdH2VXpPOeQIEmntAXT4BnT+6hpAQmMhmVXJr+sYLson4vv7pkIibFUE7BqtPWBW2LuOiroV2c8JlaLB7qZ445QUePwSQvWkgYES71Cbboi8IJ537zOzRr0mpr5fXKzSsRJNiDhje5Rrx5yaVoa+Bh+9m4CWEb2C1irTuOLtAj8qTTMUzl4hojwqadJccod8OfXnzQHJ7krftr0DOhSylOBCgxRsRO8WqcMeKsn3e/Ua/94XXVC+gsU+n3W0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6916009)(53546011)(8936002)(498600001)(83380400001)(6506007)(6512007)(4744005)(86362001)(2906002)(66556008)(8676002)(6666004)(6486002)(66476007)(38100700002)(36756003)(316002)(66946007)(4326008)(31696002)(2616005)(5660300002)(186003)(31686004)(9686003)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bE1HeEtxeG83ZHZuSXFHNlo5T0hjcUoxeUJEV09TRm5aL3NnMytsNCt1N2E3?=
 =?utf-8?B?aXh2L0RJSjNyd1MzUEdhenVMalFuanA4eS9CN1FCcHhrUGlpM1NrMXlGekd0?=
 =?utf-8?B?TXRRZXNyK3RSSUx6RG1uM3FKWEphai9PR0pTODJmL09aYmh1a2VINEF4Qmk4?=
 =?utf-8?B?c1pTQTJnQjgwYnRheERnZVhWdzFSWWZLVHBvVnNJaTNrdkI5MnlEdFg2NGVy?=
 =?utf-8?B?U0lVcEZHT3hWWHhHbklLaXNNdDlaYk5jVFVNVGtYc3d3OEpvZ1VSWXlnOHF1?=
 =?utf-8?B?Q2RlakE0bnlhUC81U1c0YmJSQm5sdXJIMWMyK05vOGlKRW1ocGxDeGNIRnhK?=
 =?utf-8?B?SmkzdkdHT2hUT2hOVTRFR1RWeXFJUWhpdFduTFVpUnh5bks2QUFxaGgxaVJv?=
 =?utf-8?B?OFQvQ2pKU1pLNFg2SS8rUlRtRnovUlU1R3V2KzRmeUdzVGgzQURWb0x3NGNj?=
 =?utf-8?B?dmIyTWIvOUZYVG1sNHZRRkNrdWpsL2J3VkF2Y0pXT2szSEpTbDVqSzd2c1Ur?=
 =?utf-8?B?M0paQmY1TEhxQkZuTmZFZWdKQ2c5VGd4cVhCMktpV3NvcnlpbjluM3YwWG9M?=
 =?utf-8?B?cWJTUkorb05XMzNYMWVkeHV3M0tnb2EvUCtZdll6Y1l0YnVpejVVem5YUy9s?=
 =?utf-8?B?UTNQdHpKRlhFaC9QVTJVL0MwV1Nxbm1QckQ1VTZ5QmpxRFFBZE8ydmNzRkJ6?=
 =?utf-8?B?TkxPMWRGWFAyRTZDdVpuVDJ0dEhTUjBzN1pkaWh6QWdhZTk2WlhUUGFBNnIv?=
 =?utf-8?B?dGZWWjRvSlFJN3lLRmFwQXZDTU4ya25xekszSW5YSkFiVXlnSHlmbHV0bkFG?=
 =?utf-8?B?NDBldEVpRG9XSnZPZVQ0VzBnY3A2UGR2dEFScGtBQ2N0RFB3S1lMVmRaSzQr?=
 =?utf-8?B?eGxWMlZ3OXVHbXE0RDV1VmxGMkRDVHY1bmpQTXovaVVMYnVJakczNlc5YW1r?=
 =?utf-8?B?TUVzck5RZ0xjUzREQVdMaXZ5RVprYUJmVW9VcmIrSzNxajJDSkNaSkVzM210?=
 =?utf-8?B?T3dYVjRGOVB5eVh6VXN4SkQxdEtXUW02VDNEaFpoT0tKNzFVTGowSktCRlds?=
 =?utf-8?B?YjIwSk9hTnZ1eE1nTklnblFtWGlWR2krSlRwTzNDVW5rU2ZjSXhScHpSazZX?=
 =?utf-8?B?NVgzTU5zMUJ2OXZmTThaT3dBU0dMcytubDhHK29RczNWT3JTN2t2Vi91OVhL?=
 =?utf-8?B?U2RhYWlGREpZeWlKczNIc0s2Vm8ybzlIMGl6VW1WNVlTa0lWMlNPWlFZdkxz?=
 =?utf-8?B?NVdwTzBJSnhvYUZxUEIwVGo4TnloSENVQndhMmlUZFlzMnpiL1l6RkNEZ09u?=
 =?utf-8?B?cDNiMFlIQWNWUy9PYjFNK1FhUzZhZjdNb0dSeEI2OXEzdytiY2ZRdmN6L3R4?=
 =?utf-8?B?VTRLSFlsSmU1NDdSdkYrUWdrSEhnUlJnOUJNV2ZPU0FmNmFWclU3RHlzZWlO?=
 =?utf-8?B?eW1sYldreVNpRTRTaFUrdmFUK3JhR2pzbVVmaXE5U1hFd1JDcUVMNWg3RDZ0?=
 =?utf-8?B?Y21ycm9KaW1hd0FuZVlNV1Bxd2JUWHJnRGY4M043ZndzTXZaMExDZmxDY0hY?=
 =?utf-8?B?QnZ3bkJoQ2Yxci81ZVZ1MUtyaWN0dGxVeHVWNlV2TkZTd3EyZGQzdWNUVFp1?=
 =?utf-8?B?L0c2VGowVkVDbDJtTnk2L1d3cHVJUU9KY2VwNS8yZ0ZqUEx0UUhoa200OGkx?=
 =?utf-8?B?d0t6R1ZiYnB0MDA1aWtVekZKdTJpSnVLWjg4U29UK2M0QzR1bFpFa0JhQ29P?=
 =?utf-8?B?QWhPWWk2WGg5Ulo2Z3BKTW40RE1wK1FFc3FjVjJUUXJlMXdFNURqQlc0aDQ2?=
 =?utf-8?B?L3hYZkliVjhWK0pWZ0s1Nk9yeXRGWXFkVkMrWklNRFV1MGxHS3A2Y3VDWVJh?=
 =?utf-8?B?VzFvanpCVGhCWnBYamlwWFJ0TjNHMHFRQ2hTZS9EUDI5ZU50dWloeTZOWkJn?=
 =?utf-8?B?Y0Qrc3F1a3M2dFZLQXNUS1lDL0o0enBwNFlwZFZsVysxOGFERHZqRzNvYitv?=
 =?utf-8?B?aXluclNhTUM4c3NSYTZ5ekV5eDZRbWk5NlVKK1V6Si95L0tlUm01YzFpTDBE?=
 =?utf-8?B?TG1uZWcxZDRXUzZna1ZNV1VLZ0VobDA0blN6eUVFV09xVkVzL2FLQVpHdytz?=
 =?utf-8?B?dStQcHJGRGN5Z0d3ZFlQWGVidlh1STVma1dLSHFJMXBmUkNFb3VLSlRyVkRI?=
 =?utf-8?B?ZGpRWWtNN2dNSjVPWURTM1VNcnZrNGlMM09aMHBXOWNaN1dPRXVuaHdDWFFG?=
 =?utf-8?B?YmxhSy9ldmxzYVU4bXNMTUZvNGxRQWtVKzFvdHB0VGNyYkhZSkIyUU5pMldZ?=
 =?utf-8?B?dk1VSHIyNzRCaGpZdklLZlBlRlV0Q1VuVE9ESTlzN1VGRWRxZ1BNck5ycE1W?=
 =?utf-8?Q?OrflITuluoIUjtt8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7852e9-3107-4426-8056-08da52121b64
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 16:38:15.0212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIQyFtuBBVYMz4Cc6LyuDWYJ+grZmfmt6TA82tuR2keky4+C0H8KebbiJ4N0A6IEVv+0OKgIAXeKEsBSt9AVCFsuAdHPy/+lNjlOfngnQc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4710
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-19_08:2022-06-17,2022-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206190081
X-Proofpoint-GUID: OvUlO17E6c2ExRgA2AVdWCOTTcDm-_nE
X-Proofpoint-ORIG-GUID: OvUlO17E6c2ExRgA2AVdWCOTTcDm-_nE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/19/22 11:26 AM, michael.christie@oracle.com wrote:
> On 6/19/22 1:25 AM, Christoph Hellwig wrote:
>> On Thu, Jun 16, 2022 at 10:04:37PM -0500, Mike Christie wrote:
>>> If NDOB is set we don't have a buffer. We will then crash when trying to
>>> access the t_data_sg. This has us allocate a page to use for the data
>>> buffer that gets passed to vfs_iter_write.
>>
>> But only due to the last patch, so this should be reordered before
>> that.
> 
> I didn't get that part. You can hit this bug with what is upstream right
> now. You don't need patch 4.
> 

I see you meant the patch before this one :)

Without patch 1, you still hit the crash. In the current code, we print error,
call the execute_cmd callout, then for file and iblock crash because there is
no sg and we assume there always will be one.
