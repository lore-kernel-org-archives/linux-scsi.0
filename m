Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F144CC7EE24
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jun 2023 08:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbjFBID2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jun 2023 04:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbjFBID1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2023 04:03:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAF4A3;
        Fri,  2 Jun 2023 01:03:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351Mt2Ag030617;
        Fri, 2 Jun 2023 08:03:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=SyS/VuV1w6jMCFBJJgp8Slx1zV6PIamcSXP1rZTVDJs=;
 b=1wueHXlrFtSWRdZNOO7t28NNEQA/Ivb7PYlRLWlo6vskyoHZf7q+eVvCO6RocIbF7N5q
 hpsmsyO64cmoLIAs2FrWGiZ3PP+1e1GeN0DlPrlIBAp+YldZP4oZgZ/n0HstSsbqu5nw
 PDuuc8+sJ9+C8EPchxyCG43mE2t9YqsKAYwI5k5cQmdg1QSgyBTV4KAT0UPcWhIG8hD5
 u/BS82jx4pDpzKeVXfE74/JqIvdfnB6ioYvEaVNPIayMz+N9wxu81Kz/M2RcVZLfAxZO
 xBtlPJl1IdMtUVjcPkw96L9pk6o4wa2tzqj0DolQbPTG+dwpqqpzm+g8QMt3iX6Iv+LP Iw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmete1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Jun 2023 08:03:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3525YPKN003698;
        Fri, 2 Jun 2023 08:03:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4yfwp6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Jun 2023 08:03:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lt7stKAo/AVtZfh76NZKwkxCsEKmh3M295I44pOXiNOWHsugEJ+bHNcs3yeH229BRnMfBo2pHpQ2TW8Ph88eSHZCHo4WaypuZNbBOUHPJVSpzY8Rtwx9nm9FDeF5z2KHnhzaDi/W+7ffDhFmUuh0MxalO7Xhtyl4wUkpUo2aLulmEqxsJyy2qJl9q8yLyAffV4X0cf8dzunumXfUG0YJ85W0NHmfiNx9fSa12KnBBhieqI+N8sHmQGWKfHMH9Sq1nphmUdSvueMxBY8cyO1GRbhjOvyYPIMA9iYIrCpRIago92auIUtySDrhBta+i16keJGI4G6Ntv7YR+yVJasrnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyS/VuV1w6jMCFBJJgp8Slx1zV6PIamcSXP1rZTVDJs=;
 b=nXp79GAHuDRwOr6QAqW220xuVBOaBUfmZC/kcSs4/vd0k0Zu1kti+hFuKMkxrAP8Z0qUgwazTrVQi1yah/NKHUmA+Eg7t1qxu2QoWZykAcKvZNSG+4KYhpu/M3oFxoFQXHcCyp0cF3W1fIX2ZvxQdWutX/ZlpGDCgRvXGCuNqLMQQ4g1n3tdrc7jSKymlzt0ySucl21aQ0cS9lJlb+Hw1f5w118/OELmTm17wMUI8z38AI0DhGTcbLL72CndccEN0LGcdhFL47KMkdNPMtzM8gHO3LZurievW0uncZzbZ4uv7LAP1eq1Gv9q7KTjyVvgJR4VIiI6xSSPDPXQnlFDsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyS/VuV1w6jMCFBJJgp8Slx1zV6PIamcSXP1rZTVDJs=;
 b=eK+x+hB98Wv+NDQkilEJ4iutfE67ssD6foXOzZPTvm5OHGSjyW7ZRAYOnVKssSsEdC11mSIAU7dx1CaGF9ZZCkL53Dd9LouStzo/CdFOxemMAWRQdwpyxYJqLahs9YxnVD3sGIAUu2BBd/DDPvUx08Lolukh9aiKXwbGTEDB+Fw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Fri, 2 Jun
 2023 08:02:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2%6]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 08:02:45 +0000
Message-ID: <cdc68c52-4320-1820-028d-c0af9dfe38c1@oracle.com>
Date:   Fri, 2 Jun 2023 09:02:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ata: libata-sata: Simplify ata_change_queue_depth()
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jason Yan <yanaijie@huawei.com>
References: <20230601222607.263024-1-dlemoal@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230601222607.263024-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0470.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a2c4212-c8df-4c99-a358-08db633fbfca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0soxHihhet5KlAHHuCmS7GDMJuPvjzjdVaE+Dka2Gv0v9HneqmMTcY5X4g/FNwsFzRLuE992DHUKRVq9bIXxm61D2scHLyjbZ2LhM1pprXP/1w7e7NQcd75zuwgeokunBOu0yxYEt1lq3ttQOuQ4P/wFe4PDTTCqfycP4Omp2WTSJKfHAYXLe5mwPEz5gUn0+H+QXlj0y2jZNN+LjgO852lJSCdFM1NuSgo/h9uvteHcULOErN7uWjRAKUK20WepgLlW/LYTH2yVPG3jD874V+aqss39H87rcj4s8AKo8DuJK5rVWi7t0ObaepSQWayrhHgXiNihnG/Dc8K5N+6qxJefYqA/lS81x7brAdHRz7cKCN0xZeAmSdP41dU4WUH7UE5TxMnrsRW1uqY+6uw6gQCTixorBn36bAuuOjpxUoh9Pf6Fes3xb+O6M2p5V2NwFfc5Zgh5p14a/LAQH2bH0eSCszVRGlbktY8SIPtOrnDsbG8w8lts8Cs1uVWlfT+oPVUNR9cxlqaPvlAouvk9r2+Dpr1+lE+eDfol4LkaK7YTvud0VWQIG/vIqlNf3Ph6NxvTK2WK8tb2lM1IRS+BTzu4kqMGSycWBifGWOL2fOJSXu9IGv/App7EW1B3jVLLbd2qBPpTPxkHPNLJq22mA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199021)(2906002)(186003)(6512007)(31686004)(53546011)(6506007)(5660300002)(2616005)(8936002)(8676002)(38100700002)(110136005)(26005)(83380400001)(478600001)(86362001)(966005)(36916002)(6636002)(31696002)(41300700001)(6486002)(66946007)(316002)(6666004)(4326008)(66556008)(66476007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SW1LRDdzUkcyYVVlblRSNXJsS1V5M1RKQnBZTTVGbWxwaHFEc1F5ekZsU0hy?=
 =?utf-8?B?RWNETGU5K21DeFNmbGN1T1ZkTHpxeUtaV3ZMV0U3L21Ic3JSNmJlOHNJaUl5?=
 =?utf-8?B?blJadlBzdnBqdHB6WndoM0wzenJjUkR6NnREOVo3Y3pzTG1BTHVVZ0tZZDB3?=
 =?utf-8?B?bE1ickd4UUQva2VBeEFvSVRTZDFIMHAzNWJOWnRTU1VBRFRINmUxcUhGSnMz?=
 =?utf-8?B?czF0Z25pc1JnZVlib1hvN29lay9xL282OGl1WlBFREhmQ2lJMlB3ZUMxcUVN?=
 =?utf-8?B?dlFLOXVDRGxuTnFNeXI4RWtWY05Md2paWE03OWxpRno5SXNwcWY5dXA0REli?=
 =?utf-8?B?RkgzT1owVkI2ZkZJcmJ5OGxmdG5jOVk3d29RKytJVER3LzE5R3diZ1JOYW1T?=
 =?utf-8?B?S2x6YTFBbUtVSUF6WVcxc3F5YXB3VjZjTm1HWS94MzRFZWhNK3hCSVduRDVk?=
 =?utf-8?B?b0hkcmpWSHlJM0dicTh3bm13Z1d3bUUrMFBVcVZha1FZZXU1MWZKWS81dDd3?=
 =?utf-8?B?eXVGT3FYV2xjOStqSSs1VnFsUGVxblREOUFjNU5NS0J1a0dkYStRN2xmbDB2?=
 =?utf-8?B?Tk92MzNyN3VlaTlkTll0MkFsTWw0aHJLL0R1Q3E1UlRONDlBSFBjT1R6dVU3?=
 =?utf-8?B?a2NvZndZMy8vWWJCM1VyT1NMbVdCRDZZNkdLdlJDdk9KWlQrS0p5MEZIYXo0?=
 =?utf-8?B?UHhWNnNYRDNqbEdJaHBpZEJhL29TSmcwQWg3ejBiWkx2VmFEaW1sTjVDMDhu?=
 =?utf-8?B?cFA2djU3WHE0YmluMTNEdWtMTFJpUFA5T2JrbTBzZVJUU2VNa016b0FKVCs5?=
 =?utf-8?B?bXNRQ3doVXpmdUR2TFlpenhpSDErcTY2SzRVZkpZUmZmOE1XdEo2aDZCdXUr?=
 =?utf-8?B?RWxSdkszUnRoNlR0eEFtZFprZHdzNnorMjh6QWtxZmJ4RkdIRWdZd0hIYUdn?=
 =?utf-8?B?Z2FxcGpMTFdBUGYwQlVacDlVckhDaFBDWGNFbkorbjFoUnNSUU45ampESGFS?=
 =?utf-8?B?TXd5RXkyeVZDeEVMQXNPdFBzcXIvRVUxSXYvQktpby94OEQyVVllU0tBL2tz?=
 =?utf-8?B?eTdwaXkrdjlOTVE0dFExUzN2NzZ0RVB3M21iVDlwSGRrTmEvRmlodC9aZzN0?=
 =?utf-8?B?elEyY0c0WkhPV0NHaVlDTWtqbkVEaWU0Uy9FMG03Q3lyOTcyZW9pUnlpNFg5?=
 =?utf-8?B?S0dVSWlhcmhNeldXWFJrNm4vUVFZMGRxOVRWMk1KeVh4YUI0Y24yemoxbkZk?=
 =?utf-8?B?OEZHUzAxMisvVUk0dWJWMTBUYXM3eEp4a0tqZzZBZzQ1WTVhd2ZNOUswUGVx?=
 =?utf-8?B?OEVvWWpMcXIyemRjK1c1V0VicWJIZTVkL29rZDhHdFVTcmFXbE1KRnJCLzhD?=
 =?utf-8?B?QUFweXpTOTR3MzZiMTkzWXdWaTBMSHFtVTNZMTRLb2JvUk9rWHZoZzZCeUdq?=
 =?utf-8?B?V3F4NDl0U3RCdzlnSWdIZGt1c0xnaVpjSEJtZkRXMk5xRVdtdjZMZXVVL1N4?=
 =?utf-8?B?Y1NIdVhyRXhxeGdadHhUckZDUmJyc1U4ZC9pK01ScVhiYkNHVlNrMW5YekVj?=
 =?utf-8?B?cm9veFdUVzdsU3E0NzR1OEJORmcvVmZtZHpEMVdSbFR1VFYrOXoxaCtPNE4v?=
 =?utf-8?B?QlFveFJOY2l2NlJERWdCb3ZDQ0FhYjlvZnFhVnhKdGlOa2luSU1DMFA0cmdw?=
 =?utf-8?B?ZmM3WXlOdnpaQ05jMzJBV2VMM3drWFVMZWJzK3hoL08yaFRsemxKR0tpK2dY?=
 =?utf-8?B?blpaQXV6d21Kd1N0c2srN2p5SmVrSmROQ280Y0w2WHlCSW9oNHc5bjVkRk1E?=
 =?utf-8?B?VGtmRmp2Sng5N2pETitialFYbkNIeGMwaTg0YmZ0UU91QkNFVWp1dEhSWU1o?=
 =?utf-8?B?bTJ4bWNnN1pzRjEzTUZ6NSt0STZBbEE3dUhVZXdBeWtIdmh3eEpqU2xuT3JN?=
 =?utf-8?B?MENva0trcjVITEdURDNPb2pxMDJ0UDVHZzNqTkFPalc1TUo5RWNxekw0bXZ3?=
 =?utf-8?B?YjgxcUFlaW90MHR3QWF6OE1JQmFVZk5xQ3hveFRlRU9rMmpucVdQZTAxNUNK?=
 =?utf-8?B?VDUzdkVIM25zVjlRUEM4WVJ6UjUxUlNJQXVaQ051ZStjdCtvUU00cGdWWThQ?=
 =?utf-8?Q?u97lDHrLat3fG5zJmH6UFsufz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tJy9JVgVS8gTg8xZQExHX4q7iQsohpKp6U/OFGTFT1aPN/CMCAg1M4egXCsncyusOjU3DbHVr6CDmqqeJfITnswWZ9n9Huk02mH5ms0QtTF3k/ErgesJevkCtS9nadIvyDNMV8ayvvGVxQK0R92M5m5TtYjP7Fdqo9e4nEm7YGIs7Lnhl79Kn8i+xypVPFs7x3vEBtts0/1rhVWyIHdTquxBSOfQ54QN/IpHdtQ2V2HlixQASoj4JI2HW4XlHzOLxTHj2cSY7kNN5rIRefotauityfuackI21ctbFnjhihQd9Z7pryd2ViN3r75zGVtbXsg86A9+XM6nI0QJAb0M4p/y3BGYsHDzWqRxVWtmtB5YqUpeoFJue/Ms+CczcKb98SItX4F657u4iBrkh519WLJZOC3aS4HHE64GLG2hQFQ/znvfDdKSlJ51gHPADUcdrVWVZ5XGwO7v1sIgYW/2b3zaauGPDTn2uzS2p6VmdgsY5vA90Oc4fxKlFI/ZReLawMKtIMjM6tT6F9Q+i+BQPZpRejw7HSsEjgZFzqGM3r7khr5dALvKI6CEX7DWvOuJ/FZK5v40LcBt7+jc1COtBBu661poPZO6IFuQ3NCjJaOmVsOkcR15u+An777yJfgN/oUp1cmJNefwQ0oXdEYkhfdDQbDOwznDaxMyQfmeinjlm0baD+tGI0lZgloWF5VoHs5nGJERHd+IjEjU0A+7U4PBbgQUc3UyHFtYoyBmShS9OZrvh6ybpb4Z7stCtlsBybIkOIYsoZ3AzLXJxuptWyJ1Gr+YwnVG8GjdFDoNkzOnXnWDi9BihQtyK8+E21Ha
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a2c4212-c8df-4c99-a358-08db633fbfca
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 08:02:45.7337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oc+KLn3yMpiw9TfmVvndbe9AGwM2+5dGMUanIKRA3cBI+JJeEmb9QaIPKNRKylgbWl247iPFv6uqrIzb5iZdVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_05,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020061
X-Proofpoint-ORIG-GUID: dt8WCi6g7ggVek80PN6nhXFq-ILZJOcR
X-Proofpoint-GUID: dt8WCi6g7ggVek80PN6nhXFq-ILZJOcR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/06/2023 23:26, Damien Le Moal wrote:
> Commit 141f3d6256e5 ("ata: libata-sata: Fix device queue depth control")
> added a struct ata_device argument to ata_change_queue_depth() to
> address problems with changing the queue depth of ATA devices managed
> through libsas. This was due to problems with ata_scsi_find_dev() which
> are now fixed with commit 7f875850f20a ("ata: libata-scsi: Use correct
> device no in ata_find_dev()").
> 
> Undo some of the changes of commit 141f3d6256e5: remove the added struct
> ata_device aregument and use again ata_scsi_find_dev() to find the
> target ATA device structure. While doing this, also make sure that
> ata_scsi_find_dev() is called with ap->lock held, as it should.
> 
> libsas and libata call sites of ata_change_queue_depth() are updated to
> match the modified function arguments.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks!

Just a reminder to all - I'm not asking anyone to fix it - we still have 
that funky libsas behaviour for attempting to set queue depth at 33:

https://lore.kernel.org/linux-scsi/db84e61a-1069-982a-5659-297fcffc14f4@huawei.com/

> ---
>   drivers/ata/libata-sata.c           | 19 ++++++++++---------
>   drivers/scsi/libsas/sas_scsi_host.c |  3 +--
>   include/linux/libata.h              |  4 ++--
>   3 files changed, 13 insertions(+), 13 deletions(-)
> 

...

> +			   int queue_depth)
>   {
> +	struct ata_device *dev;
>   	unsigned long flags;
>   
> -	if (!dev || !ata_dev_enabled(dev))
> -		return sdev->queue_depth;
> +	spin_lock_irqsave(ap->lock, flags);
>   
> -	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
> +	dev = ata_scsi_find_dev(ap, sdev);
> +	if (!dev || queue_depth < 1 || queue_depth == sdev->queue_depth) {
> +		spin_unlock_irqrestore(ap->lock, flags);
>   		return sdev->queue_depth;
> +	}
>   

>   	/* NCQ enabled? */
> -	spin_lock_irqsave(ap->lock, flags);
>   	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
>   	if (queue_depth == 1 || !ata_ncq_enabled(dev)) {

Apart from this change, should we call ata_ncq_supported() here (instead 
of ata_ncq_enabled())? ata_ncq_enabled() checks if ATA_DFLAG_NCQ_OFF is 
not set, which we have already ensured.

>   		dev->flags |= ATA_DFLAG_NCQ_OFF;
>   		queue_depth = 1;
>   	}
> +
