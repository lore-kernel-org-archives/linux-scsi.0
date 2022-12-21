Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1A5C3DA6E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 00:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiLUARK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Dec 2022 19:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbiLUAQ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2022 19:16:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1095F1F62D;
        Tue, 20 Dec 2022 16:16:08 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BL0Eb5h013939;
        Wed, 21 Dec 2022 00:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=WXHto1kJPwqN9kmczl41Ru7ehDtNkvH8m4KI67goLW8=;
 b=HUCEWxFTzNC3DgEy7/lNu3ROzuBPwY6coVt0P7QcfcIKhGZn7jkVOOpgJ10jVxZEjUeL
 r/fuWahcwpo0uJKcFLh4ILu1xxhE2pI8CRy3Qbtc+RBmypPXWQ0C65UyHQKeJTiL9nzF
 0tJhowg+6lMtH+3p28ESOg3jxs0nglKY/3PB7B6dzPUslXmqmz9/0/FeRXHy0qLm6FC2
 WZJRuhvRocxCqXrTMIFAJl2lCboIiNlR0vfGuLG8gyyu2+r52ZN1prBD/aj01CPKy6Zp
 tqiCidKBvYK1kPt1h+3hOi8s19HwnBWJeOcq3pcyAxJrB9DKxW/KFk5pEFgrShC57Lih ug== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tmydmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 00:15:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BL00H6p027654;
        Wed, 21 Dec 2022 00:15:57 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh475uf3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 00:15:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrTSXqOxzD9outOVVIG6THpB9LwiR6nNX5CnZ+9/d/Pg6UEeVTUCkiKSDMr81LnDOHUtfCcDjSuQeB15yAOtzUraI5Nz+++zl44RARgMN8poEYRAsqgF6Syc44bpIS3NvyaJ0GcTmhNuPxXFkV/eXHs+SdCcyxZqEVOyAsUBAgJlbGP67xXmLSzefVk9Mjdx73ThRItMgRL1GxUFxrilfiv1j+B5G5CGvompiS68P3789OYC2HILFQ0VN4ufd0Lw7Yqg12Z81SIiyQm6aSZkdEjUmIWW+0NtGicPmv52NbPGmWZ7yyyI8KO1nfZgidH+TozPdR0mnX5LW15Q4/89lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXHto1kJPwqN9kmczl41Ru7ehDtNkvH8m4KI67goLW8=;
 b=YSLhGLr09xn0yC9wWWWi5IoOzNbxZO+Thzu2t1eJAqXmZQ+W+FvSMIK0HySoiDLxNm5tioFvxdBw6UMV3M+Kgky410kXqWCmgKsocFYV0hE/8k1TyB+ls+pkAU9IRqFxaihOoRR4sr0+M2Sr0U7bObmIBqq8YOZ/cuzKOgsp8ojhp/q4IU+CO2SsqQsLD4fIlNG2H8hRfgTue8KbknQhaUOJ6bZWsEHiWBBZA6iwy2X0NgqCiJJiYCMZ+gbXg25lzcXXOwTswQDZuFDjzEGaWaSNgMgwEUh98AxdO4ccpe4W2M4ybrwUssnRi+FZvod/swU6xQQ9R/LBUgnm8OTIrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXHto1kJPwqN9kmczl41Ru7ehDtNkvH8m4KI67goLW8=;
 b=oPniXoooRSINRa9c9Z3LUuNFfVfrBrJrcowbLj7KwqOdvTd9OEulSN7dD+1X3CSxX1g2cqcV2UpELWD9DjgzRSBwC32LxPDv9TniSW0WXF6egRHxpd4kNiozmznYtBzRGOTPSSpQOUclRVNF1k/PqTFrtuHjoyV49YB0R09co4k=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB7274.namprd10.prod.outlook.com (2603:10b6:208:40f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Wed, 21 Dec 2022 00:15:55 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 00:15:55 +0000
Message-ID: <8e97531d-da78-6599-26c2-631d7a73c48e@oracle.com>
Date:   Tue, 20 Dec 2022 18:15:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 5/5] scsi: target: core: Add RTPI attribute for target
 port
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>
References: <20221202121139.28180-1-d.bogdanov@yadro.com>
 <20221202121139.28180-6-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221202121139.28180-6-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:610:33::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: 82013e2d-b1d8-4b10-8e2a-08dae2e886ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8++9eAxyu/f/0HoNT5X4C2xZXqwP/NFrFfCmcgiZ+lB8v5QlwzY7RqQuL2Mf2R5BhzfG7pgd82oTFBEcp7517E2zOLVxPcX9bHfKHIalqsGrgkIT8eBMlJwE60HQB8tYwkiuxTvroJbaLN2sDr6IDtnII8OFPR2lXaBcwn1fNNrwj4NFXZLPDqWlrkKWfCrxsRQBFOwtLbqEe+0Nm1oPiMOA5TcS/Tab/7TULh+lylIzqQiPLNJJDtoTaoy2f8cW/SUh6Ww+J6EYGfCtUOV0eLwjKb3pkCM7MarmQ3vVeoVTPx3vnB4P4eYh6x744QdB+j9gzptK2kcV7Ruw4/n+boZJwSXNWTQpzis/Cmz/1vr9L8C5aj3mfUdIeaMvyrp9cDnixCC6EE0Cc0/OpouVvNKDKnYTlBg+t1OlBJ+UIebB/qgO6WE7yhi04Lb2ALnBBsyvDXT48FouRwE8ei94JIA6bys2YQyCI8+xjTZ6aQ1YmPa0BrAWQlKsXBIHJ/h3QTS2cBJzl++v/8Atw12PMbD5x/+Q1DjswrFdyyW/6X+fhJIsgeIrb/ntm544AyudN2USxEsFIdQNFtrGumCcfXHQMoNTOgSeZ3xOwU7bxA/09zX22Vm2E41T1emWhAu3G43bcZE+SlTSN3M6pw6ZFldkn2W1mGTajMPrXV184KGfTaL0yPJB4g+2Bzo1mBE3D+9Rm9pEsANuJ0k446erTuXPCCiQ8Jc1wMF4YomsDak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(396003)(366004)(376002)(451199015)(54906003)(53546011)(6506007)(316002)(6486002)(478600001)(38100700002)(4326008)(8676002)(110136005)(36756003)(2616005)(66476007)(86362001)(31696002)(66946007)(66556008)(4744005)(83380400001)(5660300002)(8936002)(2906002)(26005)(31686004)(41300700001)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFZRbW5nUEhXc01QVDVnbnIrallXMWc1MTlpdGN6ODZuUVJXeUZyVkxydVVq?=
 =?utf-8?B?S1RiKzROVDlzelYrNWtBMU5WM0N5anhJTFp5TUlRUmxHMEhKaFZ2Y2FLRWUy?=
 =?utf-8?B?TGJXYUhzOVd4eENhTFhvVmhuNTRvQk9vQ2RmdzJOYlZHWWszU3c3eFhhZ0ww?=
 =?utf-8?B?dGcvQW5OakR4Z3UyRzVobktkN2h4RnROa2F5SUhNb3ZYMGJmUkw5MXhFQnBp?=
 =?utf-8?B?cTArYWFBb1B4U0JNUVBqb0xrb2dVOUorT3cxUDVJU1lBL1ptVHR1MUNvZndt?=
 =?utf-8?B?QkxhRW1zMkVpOXZQMlF0UVdCeEhrbVNNM3B4eE9nZHZCR0FjbnJsSVdMK1Z2?=
 =?utf-8?B?L1hTSitWZVVHSVE3VEI5QUNIaUtReXRWTm93WXZnM05tdGR4VU9RN2x3WW81?=
 =?utf-8?B?Ly9wdTZaSjZ0aVRCZUJabm9BZy93b1pYWC9wdC9xcjE4UTk5Mk1TQy9RaVpM?=
 =?utf-8?B?NHQ4SUJJcTVTU2ZPSWMvRWM0Q1E4Rko1Y241bEE5TnY3YnNLVm8xaHJTM0Qv?=
 =?utf-8?B?bCt5ZHZkTEhYQkhaYnN6cmVvcHhzb0p1MmV6eEhpcDRNaFBHM3BsUGczbUpS?=
 =?utf-8?B?b1VVL3RsRVc2RDdnMTllaFNWQWRKM1pYNlZWUUZIeDk2blZRemVod0Z1U21F?=
 =?utf-8?B?TzZzNmN5cWhNa0tOSE5RYmVNOUVGbnNIV3NpNzNubDlWZW5rNmlLL0RTZWhv?=
 =?utf-8?B?eTBZRWlFNVR1Zml5aVgvcWREaGJLSTNGUmRUQTY3WERFbzdhOS9nVjVLNVNy?=
 =?utf-8?B?MnY5VkJKYXR1U2JpcWlJd2UvY1NqdUtXdmc3emtEZEkxZmU5b2licnhnSmNT?=
 =?utf-8?B?YzA1VVR2cDdSKzlQNkVyK3VGOHZidGM2VjNIWUMxM0hDanNQYWZ3TWZoMitM?=
 =?utf-8?B?S2VzMUtHN0pNMmtKamsxNjA4VS9BMDhWUWxCYkVlM25rUGpkQ1FXT1Excm1n?=
 =?utf-8?B?N2c3UDBiYW1FOVl4aW5IV1VaZUxGR3pwYzhqOUtSM1dOV1d4bFlNdzFyUUdE?=
 =?utf-8?B?ZTFtYmxNczlONXlYV09hOFFidEtZNmpvQis5cVc3R0VydFhweXh5Vll3SVBx?=
 =?utf-8?B?cGxJUHVqMmdpUHBPbXZiRURQNzU0eE5CWEh3T3RTWnNvdUxNemtvdjhVdER4?=
 =?utf-8?B?ajA4U0ZWblFMYTJUYUhIYzlobWwraXFvc0ZsRndrZ0NUWEU4OEpVR0ZDV0Qy?=
 =?utf-8?B?RWp1R0VWY01EUzl6MUxHb3RjNDl2NG96NDBQYWc5RE9jbUdrOWFNRVZkUVZa?=
 =?utf-8?B?dUNSRDNiQVpHQjd0YmYrMVZkWkRvSTlCWC90UnhHaFRSSEtyREdiQUg3cVoy?=
 =?utf-8?B?Y0ljZk1FcEt0bGwvSWdnUmE4Yi8rWitDdmxCUnZSSGJMS016bkRCZFoyVVVH?=
 =?utf-8?B?TVpkZHVBV2hZYnIxRFN5ZlZuUE9CUE9lYWJzV09CNmx6enlQbTU0Tjk0c2lu?=
 =?utf-8?B?RnpKWXpmOXM2dEJhQzhzeWFCRDVWV0VZZzREdUY0ck1lUjNLcmFpY1ZLak5D?=
 =?utf-8?B?dkp4bWp2dVZOVTlyS2JpaDJCWjRjbTRaamw1WE5JT0JJSEkzeGtVMlRoUWo0?=
 =?utf-8?B?bEdlRmNmL2RiUEpYR1FuUldBcStVMGRuZUlNOVZRbHVkNEM3cyt5S1dLRVI1?=
 =?utf-8?B?ZGk2d1lRVVZSN1dsTGswZGVvWUI0MUxhdkRGNVQrSmxndGZxSlpuTlhxOVJy?=
 =?utf-8?B?THJwSkxiOFpFR3UyVzkwNG1VbHlHSXRleHllSC8vMzdyVkNHUzBqRFo0aDNN?=
 =?utf-8?B?Q0w0eDVJakNoZUhEcTIzQTRhbmlxaURjRStxbVA2a25xd1ltSW5taE5JVHNI?=
 =?utf-8?B?d05TeUpzYVQxZjRPSjNSRzE1cVUrSWgvRzFwbU1QMkJDOXd6MnQyWDNSY25x?=
 =?utf-8?B?WEFNejZxWDhEc013TUxiRGZ1ekkwb3NsWXpPVmJDS1RVaTJheVRYVW96dUtH?=
 =?utf-8?B?S0hWeVBlSVdlb0M3cU15TFhWVzJvMG9rTkpFV0plNUVrakxKS2RrRnBSUVNB?=
 =?utf-8?B?WHNzaE03em5CUFZGRFp1QXQzdzJSRFR0dno4ejhrakw1OFpKV0t1aGJ3eHFp?=
 =?utf-8?B?T1ZqTDJ3ZEZ6VjJEMFdsOUtnRkdEQWFYN3V5UDE2TlhzMXV3SzJkdTRQWEZQ?=
 =?utf-8?B?VjM2NW1laFJIRWtSTUJMbkZrakl3WkJuNW1KU0tOQVdYcVVXa28vSUphS25S?=
 =?utf-8?B?WVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82013e2d-b1d8-4b10-8e2a-08dae2e886ed
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 00:15:55.2695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZNcOHTz5965SDWfZ8+m44hLr/M0F6vmkjgkjxkkO1+66IXEjBUUm4pjdDuDXWRoJTnLSpbPUd0hoXoRBUKWL5pg8ggNLCl1+xbUilLZURU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7274
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200200
X-Proofpoint-ORIG-GUID: pvZuth-HmrQwQTZCQZ0Tofxie_4GW2Ho
X-Proofpoint-GUID: pvZuth-HmrQwQTZCQZ0Tofxie_4GW2Ho
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/2/22 6:11 AM, Dmitry Bogdanov wrote:
> RELATIVE TARGET PORT IDENTIFIER can be read and configured via configfs:
> $ echo 0x10 > $TARGET/tpgt_N/attrib/rtpi
> 

Hey Dimitry, I think your idea to place this on the tpgt_n is nicer
because you can more easily set it and there is already code for
that type of thing.

