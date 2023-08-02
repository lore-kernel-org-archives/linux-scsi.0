Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA47C04A6A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 16:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjHBQgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbjHBQgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 12:36:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2DD2685
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 09:36:03 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372FYMtg011745;
        Wed, 2 Aug 2023 16:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=4mD1mRd1xjK1g/nCbhyxiN4/nMvrxzNey4RjySt8Enk=;
 b=kR+aYOeKo4KzNvkddnnQy7sLuwhSXbbtG2mLD3feuDmSMC5Nan+czrgWDjRqDar21zPD
 qbUbj0i1drIVbNbUAFhLiRuSGB1aDFWzb0vMbRfv41SiupbiTFHPW1dJybcjeULcmK0X
 ljqkV1a6ldGy86ySw9U6GI2ru7+h24OMF/HWMiBOOgP/hzEVuudRZSzztrGsjtUaNDiH
 IwrOYlgfVLdCg4D+BftyBna3PRiueAvNy4dckiUhFJFQ0olCdlT1uKt7uandiAsGDr70
 7LtdqKISxi3taCLnRHs170Vo302Qq5dspbLuSIg0rTBM2s/kicfo/8JpeMx+VnGh7ATx dA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4tnbfr76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 16:34:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372GTglR006568;
        Wed, 2 Aug 2023 16:34:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s786p43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 16:34:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MiSgfegcxeVLQIpy4sp0IYwcEzrtnu/AoUL5F4+cf6rePMXppFI4D1j4A9KRTTORL7Lm/FxWvMeU3fI2RClh+abLaknhSnfe8GGZ7QJ2aJF7TwMCbpsoLBdEfKw6pEJjSPTWxXDDpLyN1wWaHUsCUBqKYd0btBNFhfPeiF3fPsL6zB5YtXoRtTTj6nVrIv+LorBB2fyjbWuCzx8stX8QBOBgcbF5Vjx3wXY9/5LVCtMT2uNbCxHH8H6zTP51v/oSV/DdDu+Qwxfj4pOf3zWV9jkuN/7VUnFbHr2zgkg1Yy4xyG7t5vlFQIuJAtm0cnHI/u+mgJrW9CLx3Ng3LPD9fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mD1mRd1xjK1g/nCbhyxiN4/nMvrxzNey4RjySt8Enk=;
 b=Umcg4dvQrkB4q1oeTT+aKBMD20Zhyk2uCliek2Xd/85M8ArzbdRPbIn92si82hcKJT1D/vlId3rNkjOVOcLdjSAK0dqYwMBHN+4a1DV0cb4FDT59IumFLUw3fgnCIDyoLdotHE5r1JyzP4EpX7SPkrZN9I29KUnOWBxyp9wGBqNL+qvxtgNqlLXipW2Y2b5EebUrv9HYud/+h218SlGAA0OhrtNhSVOOiAthsXHNzP1ETdERWLV6c5TTrJv+NdP3sY403MYwbwz3ZsZmGROBjlU19A2xvXjGKRgk/cOi55XlYPaQVJCcB1BzdDtaCgwxxBMNsu/UCYeWcrDZqfuCvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4mD1mRd1xjK1g/nCbhyxiN4/nMvrxzNey4RjySt8Enk=;
 b=hOUsBFis2gywtRrANXXpwpVmz7AWsynFkvVjfXz+mzHXcV0JR4+N5dTz5kYUhU4wDrOjocagVUbyHBJgeFJsvZ5G2M/HsmCeD3EKezoyqrp5h2kQwADMHiDLHSkSBmgYBw6wveYCMIyiujwdB0R8JEorXsoOsWq9gTjHGC0y+D8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.19; Wed, 2 Aug
 2023 16:34:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 16:34:56 +0000
Message-ID: <f99f03e8-6a12-0a04-a9e4-35bac12b4971@oracle.com>
Date:   Wed, 2 Aug 2023 17:34:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH -next v2] scsi: core: fix error handling for dev_set_name
To:     Zhu Wang <wangzhu9@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, kay.sievers@vrfy.org, gregkh@suse.de,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        bvanassche@acm.org
References: <20230802031010.14340-1-wangzhu9@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230802031010.14340-1-wangzhu9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0003.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: a9f4c91e-f1d8-4dee-66c8-08db9376682c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ukIw8x/L1A4ncfV1KZhnyJ+khGYU/wWp0JdhLJrzY7SNMim2QklfoEUHfKdcGYd2QLzFneknf8LD2tixsdNxnhYVOW6I1EiVzcCx5t0l5qaPPyQ4IrY9OFFoVMdsxPffJHznhoHR+mAXifg1sUq8FtpIBQVHp3ylfftg6PXze9MLP42dyJLwCjfpQrbPeuEU1JhwBenyYQkz+NXeNHTuGMdjXS2B4cKB6g+w0irFaMR37wvsgTn3hQlBh34XjPG8pjDSXTg3giWoo7mChu7FvBzziM/eRdB5WPL3ezSji7eIo6jMv9UEiduk6HfeIsXiy6m1dGr9pkn4xODLgFeRJ2T1LtWpH1kalSQb6c/cB+JN6gns5sptpATcMvphnN2igkEmaUKiLPGMOwTGKsevU2g/Z8Q1B9jaDera1v30JquzVgWLrRulbwLWrPmD4hPJc8qLocOKkClya9/ZGl2LyetpiJv5JcniH3979a7eelN9cpOAqA1Z/5RdHuT7iZge7exQ8NnQzyScMfdOA9g4cdxZCRgSrTy7/qQRu8V3V7yIinMnHSsj9NBcmLktkzjcapfsYYC0W2eCMCgMe3dM+9AhPFHSu1msWhGWu8XYdqdMRRcn1CcOimRvcvnIxZb+dfpAqETKg0yLMAZxp0312Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(36756003)(478600001)(86362001)(31696002)(6512007)(6666004)(36916002)(6486002)(8676002)(8936002)(41300700001)(316002)(5660300002)(31686004)(66556008)(66476007)(83380400001)(2906002)(38100700002)(66946007)(26005)(6506007)(2616005)(186003)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3plNDhmcU5PdTBKRXhxV0pFSjRBVnhVbUNFSlZDL0ZzdHI1aGZEUExDemFk?=
 =?utf-8?B?ODJQbUdqbmVQa3hQVFJjNml6THNtWVJKSzQ3VGkvcDJaYlhuSThONWtTanJ1?=
 =?utf-8?B?OEMyNmdMWk0xRmV4OE5abDNMbFA0YWg3MTRrc08zVDhicG9zbW00L2FQRS9z?=
 =?utf-8?B?dTh4UDl3STRZbDZXazE2SGo3aEhGS1dEL3cxQ0JNdDhhVXRUVE9pbVJydDVo?=
 =?utf-8?B?eGNtaWxwS2kzVkVmWXdjUXBKNEdUSUlZdUZNU0ZITlRFdzluUXJsNDBZUHVH?=
 =?utf-8?B?bngvV3N3cWlHTDRFdkM0aG5oYmhoYWp4TFNMRkY4NTI4TTZOamhHYlBSR290?=
 =?utf-8?B?T0k2VWl2WENhU2ZtZENRSFFpTVRhQy9WdGJDRGdJNW0xSHlKRnFJc1ovaWs0?=
 =?utf-8?B?bVNFMjUvQjlYdlJIY3lKSXJEYUxTUHE3elFFeVQvSHdrM0JWSVppWVZzUDRX?=
 =?utf-8?B?OE5idDcrQUFvOVV3WFdwRlRCU1VvN3pGeUExTTROb0F1Q3h2c2Ewb09KdmtP?=
 =?utf-8?B?WmJnVG56S2M0WXRuWmxrQmRQajRvdVBsYUdTOWIwejhmaG40R29FOE15MTE1?=
 =?utf-8?B?SUZ2WDlzWTZGVFdiQmxjdVdyR29uWlNpRS9iZkZlVFEwbTQ5TmdhWCtocnFB?=
 =?utf-8?B?VExUWlVGQlNQMmRIazJrKzVjL3piTXZRUURrZ3hQNFNVNS9PMS9YOStDOUlq?=
 =?utf-8?B?QllvajJjc0NYNnNJSDdWZnliUXBjRFhwSFppOFlLNzNGK1FEbkdMdG5OTk9L?=
 =?utf-8?B?WHVrQkFxVGc2OFdTQ2ptM0l4MzNkSFJGT2hLK1dvNkhqK0RXU2JDVkZWSWM2?=
 =?utf-8?B?b1hBVDZSYU9wWlhnaGVKSFdBT2o1YThIZExwdU9ZUUlDQWx3QmVPeXcrZ0NY?=
 =?utf-8?B?N0duR2VZMzl2Tk4yTW03SWlheUVJTGhhOGQwT3Yvd21sajhTSk15WXFKOVEw?=
 =?utf-8?B?ZTBFYlhSMkZ6aWhsbERNOGdtTDBkelZCdHV0ZWNsUnhBWlpaeThWTXVIUVJl?=
 =?utf-8?B?cm41eFNQZDZha0VCYlF5Y1lWN1gyUEdzNUFQS1lOeFVxdzRxWnZCTkVhOG9q?=
 =?utf-8?B?VG9PdUlRZVBBR2xPcVFyYUNqOTFTUGtoanpLaDEzM3kzVFA5dzlwWGViUVVM?=
 =?utf-8?B?bXZCNXgyZHY0VjlpYWc3cEQyVnZkSkMyZjV5SlJpZE91Z3JqR0hXeW83RUw2?=
 =?utf-8?B?QVZRb2pvbUNoVHNMOWlFdUVIWG04eFpkY1h5dTRlVmgxdHZ5d1pJa0ZIYkdK?=
 =?utf-8?B?QjQxdDE0K0YybXRscVVJM25pV25lc1EyZ3FIdDNBNnA4eE5nckJ6NHp6czVT?=
 =?utf-8?B?cjlLS3M2OW5vbkY3RS95L2RLemgvU2ZQa1JXUU5qUUR4b212UndSaGttSzRt?=
 =?utf-8?B?dHRBR0lJUkN6WnVXVG1MVHpqamRFSks1YWp6Z0JhSTh4QzJranAvS2s0R3Vm?=
 =?utf-8?B?V1NTSWs3alRpdnNuaEF3b2IwTVZRallWb1d3VDdDV0ZLdFZOL0t2cTc2anpD?=
 =?utf-8?B?LzFNR2dwZ09XRTEvbTUxNFhqN1RoalhxUEtKQTliWXNIaFhvUDJ3OXRGdjly?=
 =?utf-8?B?Z21aZHhQS052RXYvNldKRXZGL2V3c1hNLy9tdVlsZUhPUmM3NENyRzU1blVy?=
 =?utf-8?B?cnUxejJKQUxNQnNoQ015c2lucEFlZkE5VFZzR0t0UEZzOEhld3dUTk1NWmEy?=
 =?utf-8?B?ZU91YzN0VlpLb1VHNFgzQSsrQStBQ3hFMk1SU2lBcDdZV0tuWitRZ3BaRnJ5?=
 =?utf-8?B?L24rd3JPWkJhS1NxbjBVaHlTMFpnTHhQMGpVSWFWTjZBNndMeW1SdTFJbmxD?=
 =?utf-8?B?NTJRTDBybTJjbERMOXM3NC83VVVoemptQlZwTzRLdE8zQ1V6aWRyZExUSE5n?=
 =?utf-8?B?WUtkL05YMHFib0luLzZzOFJzeUt3N0krUGJWT2RkdUxpSlBJS3FKQ2pNTi9j?=
 =?utf-8?B?ZGJFblYxQzYzeWYyeWVyczRYVEZ1Wi9nYzRQa1RpYzd3WW94SUtQeWxkMHgw?=
 =?utf-8?B?S3NveDdLS0Y1NlhkMy9SUVhuZzFQMkxta1VyNURwOUZESmxuUGNueWRENUNl?=
 =?utf-8?B?MER0U2RMVEUrZUpVdnVuYTFHTFdzUSs2RUNqRndlczlocEh3bEhpY1A1dFhh?=
 =?utf-8?Q?ff3kPiFjoMuLPb6rJN/6Y89xN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?QUtDS2ZOcGl3Z0JOTCtBSXZlbXhYcjVES0VNV3lXWkNHMVIyaDc3RUlVc29K?=
 =?utf-8?B?NWloUmxGeTkyMUFtQUJaUE5aOWlFRWxjOTA4eEFGY005S2ttYjJkTm54eG4y?=
 =?utf-8?B?Vk5pSmtIZlFuWlQvTURzNmpQR0NkRjV2SmdDeStza1puUEJCWlZZd0FQUnRP?=
 =?utf-8?B?YTFBUEFMNGRobHhuQjBJOGhJSXUwQVVMbHQ5K2Q0akRuUWJ3WXk5dDN5TDk2?=
 =?utf-8?B?Y2ZiWTVsYVNFUCtSdGt1R1NLMlNSWmlBYTZ1WnB4bjF2cTYwZEtiZDY0Tlhz?=
 =?utf-8?B?eVlXUzhRcWpiK1h3aEtmV0o4OGIxUGxKS3FEWU11U2JNZlhzdGExckVzeFhT?=
 =?utf-8?B?bTJCZHpZMkR3QjZSS3VKYUtVOG1nam1hV3pyVG5wZUFWODMzaWc3dmR2K09i?=
 =?utf-8?B?ZVN2VnpLU24rVFNvNm1JejRLRXZISnFvMG81a3p6OW4va25GY0hRUlpJclFR?=
 =?utf-8?B?K3AvbHA4TDNPMUt4ZHQ5N3ZQc3lXdEdxT09uaHdEN1pHNDVlQ2U4VU42OW10?=
 =?utf-8?B?ZXlzUWRuRks3cTIzaHlTVWUyZW5oQi92SDBSN3pmb1lLd3Y4TVFTK05kaVpq?=
 =?utf-8?B?VmoxTmh2dlFhSDFDMlpqUzlMNld1VGJzNVdxZ1lxNmIwS1BuS1F0RUZ4L2Jq?=
 =?utf-8?B?Y2xtd2hYdGVUUDc4MWdTRVB3VWRrMjhlWHR4S2MrVno5Unhab3FEaHQ5UXFz?=
 =?utf-8?B?Q3c3NTlrVG9xMUF5ckp6bDcyTWVqRGhKMjJIajh0dm9oTi9SOHlTVCtSK2JX?=
 =?utf-8?B?NWZJWlY5SkIwbHQybnNFS2pPMndpVEF0WWdRdWFTTkdEMFJBclFYMXJiYlRW?=
 =?utf-8?B?a3hzOVpSdk80aGg4YUVpcEF3Unc3bDl2bGRyWGJYdi9lUUdxN3dIREVaYzVl?=
 =?utf-8?B?VEhweTZtWE9tR3F5Y2xyc0c3NVdlRDcvUGRTd2ZOM3JUbERtNmZUL1IrdjYw?=
 =?utf-8?B?ZzFrMmoxSWFSVGtRSERNbDJ0STQ1eEJ4bkxkamN1Z25obTBRREpIWkx4aEZq?=
 =?utf-8?B?ZTdQTzhhaXVQdmRFdm40b2FxS1NrNEY2ZjhXNnV0a2hhcGpkdldaWDd5SWV2?=
 =?utf-8?B?NnYrT0h2U0FBeWNmQVNtd0RDZEduQ0VoM1FyMjJ6Y1p3T2NmSDZXZjFZSHgv?=
 =?utf-8?B?TmxRby81T0hjSHNnckNlL0xBUVNPVzBETTV6R092NHdkdU44aFNYYStzenc2?=
 =?utf-8?B?SjRsWmk3TTMxKy9tTXJpbjZCSXprcjdPWTA3aHloUGEwQmVSTWF2Z1J1a1hT?=
 =?utf-8?Q?l454kCP6jIahQNB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f4c91e-f1d8-4dee-66c8-08db9376682c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 16:34:56.8169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9eqeU7McptkPfEwB/3pqe/jb57fdoQz1UWqPUqd8cnjpUauh23q2RyFOM8mHw0rze0fd8VtFkGIhV6LLLguPQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_12,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020146
X-Proofpoint-ORIG-GUID: zGd4TXZf8j48oDmCr5oG5mfR_pTBzDO-
X-Proofpoint-GUID: zGd4TXZf8j48oDmCr5oG5mfR_pTBzDO-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/08/2023 04:10, Zhu Wang wrote:
> The driver do not handle the possible returning error of dev_set_name,
> if it returned fail, some operations should be rollback or there may be
> possible memory leak. 

What memory are we possibly leaking? Please explain how.

> We use put_device to free the device and use kfree
> to free the memory in the error handle path.

Much of the core driver code in drivers/base - where dev_set_name() 
lives - does not check the return code. Why is SCSI special?

I'd say that the core driver code should be fixed up first in terms of 
usage, and then the rest.

BTW, as I see, dev_set_name() only fails for a small memory alloc 
failure. If memory alloc failure like this occurs, then things are not 
going to work properly anyway. Just not having the device name set 
should not make things worse.

> 
> Fixes: 71610f55fa4d ("[SCSI] struct device - replace bus_id with dev_name(), dev_set_name()")
> Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 
> ---
> Changes in v2:
> - Add put_device(parent) in the error path.
> ---
>   drivers/scsi/scsi_scan.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index aa13feb17c62..de7e503bfcab 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -509,7 +509,14 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
>   	device_initialize(dev);
>   	kref_init(&starget->reap_ref);
>   	dev->parent = get_device(parent);
> -	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
> +	error = dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
> +	if (error) {
> +		dev_err(dev, "%s: dev_set_name failed, error %d\n", __func__, error);

Ironically dev_err() is used, but the dev name could not be set. And 
this dev has no init_name. So how does the print look in practice?

> +		put_device(parent);
> +		put_device(dev);
> +		kfree(starget);
> +		return NULL;
> +	}
>   	dev->bus = &scsi_bus_type;
>   	dev->type = &scsi_target_type;
>   	scsi_enable_async_suspend(dev);

Thanks,
John

