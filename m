Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0F8CA0ECE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 09:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbjILJUs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 05:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbjILJUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 05:20:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6352D55;
        Tue, 12 Sep 2023 02:19:55 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38C7swEj015114;
        Tue, 12 Sep 2023 09:19:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=GI6MDcqWluz7XDFF6lelncWZqwcQRbcrVdAA/jut/uI=;
 b=f3mEbgIVyQwPwTHYq/kTCbM6LOmX5Hokp+7PghwNbLLIEICJUx5dptE0AoFH7jGDHlh0
 PXzibGMnV8nLGvK6afzvtEaFd656fuwlBTKjAkC3VSP1zTzG1cWfEs/ueenzkGQi0uW4
 M0uZEcbJCnyYf+V16kZwdHgy7G9/KaSwtn++pdYCeBFuaBnhohy3z8mTcJTLaGPMo0Nk
 GyrpZB5CSvJt/HHJmnW33820pNZlETBpvKaH++Ljok9FPrx99DCPbqSepTlkZ9x2nBuK
 Aa7N00s66uUuRi+h81cAiy8ANT8lZvwrVS+QkXzKVPMkZNpCsh0nv6QYd5XSwHODAQ9R KQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1hy8bhw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 09:19:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38C8mMsf007733;
        Tue, 12 Sep 2023 09:19:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f55fun6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 09:19:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvZvjVkkKQPdB4kkzNXPGyrcHgxXJbMU8CyNzyTgSy7uqWP2U8wzkfGJ+mPvPidYXmri0W98B6ZYPR/T2aL0jUAVssVh5a5l2DT2eNJuMNB4AL4c3gOE3IE0MkbyO6ZIkaMPDDRYc7vLVTmifBCtJ0nntYnQlNhGS8U8G/rV9cEu5AXovPyF1D771J07A/hUcSkOY+kGPTz9WDJkP0/Z0ilLWiDqYG/KM1E5fRhe8HmBy+fQAFMyiqb+TGRXxDO9g0FY4H4qzJhuEwsAffM9kb9eX31y1VZ9HIt7IYdPGCMpTDl/EhOH0CN8HJlP6AdBX6vXxhiAfFvLPdbnz8R2HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GI6MDcqWluz7XDFF6lelncWZqwcQRbcrVdAA/jut/uI=;
 b=NYE3W5G8mf2+Wc0nyX2XLYFj4bjEv2aziGqX9wQ18R4346N4l3qcohpqwta0+Mg3QJn08SDEsL0DpFVZiuPsB7YR2R12tPfxTl4baF0WvVglYqBljljqBevRjK0FAdK2pgCtnUiPDocZwPswqdWmAqKhLpFfwV9ImVhjs0/27g/GL31X0wIoR1M+qbj+39msnvmA3HIfFJ5+ND3CpSpKC5wau3JQm+GP68U1JEcBouXxiUV5cd0Q1Y2c6OcLOaCddZLb+XP+EtTEmm0cyV8R+8B0KGG6ssfOpfmUrIx2SN/8tWXTynhz2MAk3zHDYFbWHpmpNIXO3UpeF62i9yq+ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GI6MDcqWluz7XDFF6lelncWZqwcQRbcrVdAA/jut/uI=;
 b=sWTn6U62HafwdeKLDqK/eSla4/0Vdc1vKoGFC7PqVBxFYXl5aC3NQg6tygge5wONxSqCmg00tJ1CCbqpdPaRQwKOPz7PKIOgEZYuGExgOrddtn9WAW5jFW1bz6PJoCe0B4Lz2d0A5ays6MMjcBwq20Qe1AepULzBZITnKK8a6Jc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7778.namprd10.prod.outlook.com (2603:10b6:610:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Tue, 12 Sep
 2023 09:19:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6768.036; Tue, 12 Sep 2023
 09:19:29 +0000
Message-ID: <120275ea-e688-eb13-2596-014e9390a5b2@oracle.com>
Date:   Tue, 12 Sep 2023 10:19:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 03/19] ata: libata-scsi: link ata port and scsi device
To:     Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        chenxiang66@hisilicon.com
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-4-dlemoal@kernel.org>
 <e8ca70d1-9c88-4a80-83e4-a65f4bbe6b72@suse.de>
 <8874a3d5-355e-c354-fd85-0dfa7ab77b54@kernel.org>
 <5825b4b9-0bc8-4c27-d576-070c7113e1f8@oracle.com>
 <f56e4e80-1905-0dcd-fb59-aaba7a9f8adb@kernel.org>
 <764fa7a6-109f-0ea5-5d25-3e39874e9c8a@oracle.com>
 <b3af36cd-a126-24ac-739c-5d1a192c2b2b@kernel.org>
 <bb89fdf9-7f7a-c7ee-7295-edbb4563dd2a@oracle.com>
 <7f690cc0-cfc1-8e31-debe-baac032d97da@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <7f690cc0-cfc1-8e31-debe-baac032d97da@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0635.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7778:EE_
X-MS-Office365-Filtering-Correlation-Id: be311da8-3738-4f73-5b22-08dbb3715e10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fN3wvf6W4Wm0bbVguV5rsLMgwdjIUpHlnA76q9N5lHUZP9lovbAT/sv72MRIzx4BBPJjCVSzLzSpyD2EFjPhRlqatpecIxx+MtOt3qHLaYjf9v5uqVuX5fAsxaC1nqVJb3GKZJlR6XeNkz/Mbi9BaVPe0AQ/cfD3qIX4NgERhbRw9nlVSIb1egJcwhDeu4Zh5BBh+rN64WFWM+eTf3Y/DvRk5S/fronPx8ZKRtC5I3ixe7D1hdrzqLUlOe/6uN3ka0HZRTSorEkURuF7f2wLn37lxAWPZOszQKD9dhZOvXBTndGI8BCuAnLDtQYOHkT4iZ1h0UAUKnwG7JG/XNTOwX5iRiCsmXvZSRlc5fwbQKLOS+G01dFnnOdNABeGAMEmuuO+Mm5UxoIo3sEgVR00ZLQid/fk9bTQxhkmc8l9upA+YU/hdTIBmzprF/fFbJlnFnnhxZ0myPPD2lUXMaPmCcndA0/CjRPsMNNe/2+hQl2cCHDmOgNNlU8WsyDLejOaJNhaJ59EmMPiHWPeFUTo+NzsSxd1ppt3l1h1CMA05q9RzQ8ETJzwOnrltWR8bTstXY2YVoRK15sIwGewsK5KQQ1Z0B6rU23L5KclRS302x1BJqU6STIFsDQICCrY9d1umihHWx7poqK0p2ocVh8AnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199024)(1800799009)(186009)(36756003)(38100700002)(83380400001)(2906002)(110136005)(54906003)(53546011)(66476007)(66556008)(66946007)(316002)(31696002)(31686004)(6486002)(6512007)(36916002)(86362001)(478600001)(6666004)(2616005)(26005)(6506007)(4326008)(8676002)(8936002)(5660300002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0g4MWZWbGJjdHM4ZkhycXhaQkQ0VS9hRFNlb1dkRGllNklCb1JWZWJ3ZzVt?=
 =?utf-8?B?RXVyUUpFa3VPZWxXbWxOOGMrZGRjeGorSHJmeC9YRURMQ3ljU000OWtZdnZt?=
 =?utf-8?B?MjVBbXpuRVZKaU1Pem1yQ3JUNU52Vzl5bE50aytnSDc1MEorc0FpWlJEaVRx?=
 =?utf-8?B?dUxkUmQwZjkvSEJBdTBSUWhuVnJCd1RxZzllem1VMHhJK1gweWRUdWRmRVlM?=
 =?utf-8?B?aGRaNHlGZ21wQU5zZlhjbXhuRTlyTTJheTNJL2kveVJSamZiVGgxQTdBOFlO?=
 =?utf-8?B?OCtxWXlsUWxVQ1YxSGh2dTNDZHZ6ODFhWWZ2dUtsRGh5MFVRdnFKVHBEQ2hl?=
 =?utf-8?B?ck16ZW84Z1RLSHZhSlcrTWI5SlFDR1BCbXc1a1RCWDlBYjRJS1JMdTFlZ1Nr?=
 =?utf-8?B?RnNLc2JjZFExQ0E3TVlRRHpKeDMrOXluQk1JSGdubTNpdjNVSmlQLytQejhU?=
 =?utf-8?B?Nk84S0pPSmQ3Nkx4eVBramsyczN5MllROUc1amFnckd6VUgxS2JRdnppWnhN?=
 =?utf-8?B?bEhyT091ZHJyQTZObTIzdnM2cVhBWVJybUR0RDBVR0pnTDZrZ1RyOFFQWi9m?=
 =?utf-8?B?N011bk9IOVZTWkF3WEFTV2R2d1JaY0NtUDBIa3pOb2xrZVMvSGRFeWtGTWZT?=
 =?utf-8?B?d1ZwNThxVGdBZG83YkVleXBkdzhoeXlNV2JXOWVxUmZsOHJBZlJCa2Q5R3VR?=
 =?utf-8?B?aGVHRWxBSm5FMzQxZzY5TnRIUFJpakFIRld4Q3pqSm1pMm81bXVJaHFvUEFI?=
 =?utf-8?B?M2J3L0d1b3BxN1kxTXRHT2tvWWxFTk12SllaOUt1bWt3dnNYQWxMU2Eyd3gx?=
 =?utf-8?B?OHBValY5eXcxQW9vU0UxWEI4NjZsQWZtYnRKdzF5V0h2RGQ1Qm9namtnUUJL?=
 =?utf-8?B?Y1BhaHB0MFRlMnhWbTZHSVBRZThVZndSUFNwdzdpZ01OOU9Pa0pmUkVVSzRp?=
 =?utf-8?B?YnZ2T2FZa1dKd0pvRUNHNVc4WjdVeGdPdVhyUWpNdjh4TWVpUFh2YlRBVzBn?=
 =?utf-8?B?dWdZUnNRYlp2YThZQVk5N0JWWFpNMk5paWJucWtxa0l6b3NKK0ZTenJHUWli?=
 =?utf-8?B?UGpqMFVPaVNEN3IvNnpWSVpab0V5cVhJWWV4N0tLQmdydDVndGpBVzBQRHAw?=
 =?utf-8?B?bXkvM094N0h3WU5PcEJia21NK2FFL1NkbUdnM24zUkQ1THJ4MWFPcTRUZ1N0?=
 =?utf-8?B?SEVzQnZja2FtZHdRcWtQcGR0dFZSV1UyWTFKQVREMkh1blltMVFXYVQxSm1q?=
 =?utf-8?B?V255UzNyUFpBb0ZFOGZIMG8xNko0L0p5SVB4NDVJNXp5Zkg3ZUwzYzFiVDh1?=
 =?utf-8?B?YnNYWVgwb0Vhb3lneTVYV3NKTjR6N0J1ZVRHYUVqNXpNK1NKMDk0eU5DbnlZ?=
 =?utf-8?B?T2RRa29tOGltNUxFYWYwL2t3Vk9xNTh4ZHY3cThvSnpBOGovb3VWazI5SXdR?=
 =?utf-8?B?aTBVZ05PZCtQa2YzUEZNOUlDYmNjRUFMWnJJajVyOHZiOUlPQ0txVzMvYncx?=
 =?utf-8?B?cEhacEkvRFE0WWNISUNudllPWXVkYm5nVDNwcWFtSVJ2K1FBdVJ1dnlpWTJz?=
 =?utf-8?B?UERuQTZSdVpGZC9kWVB0WjY2YkQwMjJKVmlFeWl4blJvaXFPQ01SREZkNUpM?=
 =?utf-8?B?VkQ0ekI0QnBDY0pObll3alFnemNHQzdSbVIzUWpHM3N4ZnZmS2xtYkc2TVZy?=
 =?utf-8?B?d21qNXViMzhybXF1dG1QYXc3eStKcGc2cC95MWRSUmc3QUNTK3F5ZlpOdUdY?=
 =?utf-8?B?NFRNQXZBSXBUZWE2bm1vVHRXTG05ajVHN1BvOTAvSXc4Y3dEaGVWYkMvTTBC?=
 =?utf-8?B?ajhjcXA0QnpjMk1YZWlDV2M4WXFhbUFEVU5ZWUtkc0FvbVZYbGoreUNnR1Bu?=
 =?utf-8?B?ekc0cDJkMGpiUmZCR2JsVkthVnM1aDRoSEw1aXo1cDlSMGV5Mk1zdzRlVmMv?=
 =?utf-8?B?dG8wV0Y3aEZmNTdQcXZoWjFEekJJY3pFY0lndHFMeU9DQmQyRkVLZ0ZheUlq?=
 =?utf-8?B?dFJtZWRIbXRFbVpQVWNXc0RvL3RLTDhacVJYYnN2dnZvZFpmdGhQNFF5V21W?=
 =?utf-8?B?SlQ5d003QVp5S3h4dFQrK2xPeU1yOXVZb1Z0Q1VXYmtNd0VxS3N0cnl5ZUVZ?=
 =?utf-8?B?ZUhCZ1RhenFFWmllV1F2RmlwRGUwOEx0MDkyb0c2THpDblpSZDYwVDBaTnNt?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?a2tnNWRrQmltWEFBRHlzZVdGTG90K0FDWnZ6NVFpRnd2UHdSZll5M1ZMVmZR?=
 =?utf-8?B?THZ3VlZsNXM3UUlIVHRxd3BTazlJY2o4ZllZc0hHQzRJaWoxdUVrME41MUZX?=
 =?utf-8?B?VDBsZlcySjRYRzMzMEhUNUxvSUpnNHp4TUd0M0lxaDR3VU9TT2NyUkZuaTh5?=
 =?utf-8?B?eURzbVh3Ni93ZHZlUmVPMXY2aEFtdTh0ODBFNnFTTFhSQ1dnb3RYZGRCbS9q?=
 =?utf-8?B?UkZSc05NUklFdzFtZSs0eWtNV09Sc0FBZnRmbHZ0dm9QSG1aWmhZcEwxbnF2?=
 =?utf-8?B?ZkpibmhNNFdzelZZWmZUSUtCZzFvYjNSVFRNRE4wQ1VmSlpUb3k5aTFmQmlG?=
 =?utf-8?B?Yy9LM2kwMHdDU1BEajJiMzZ2UVdYTzBYZVppdXFNNlNmbTY0dTJlcS9yYldK?=
 =?utf-8?B?Nk5uMC94b1RoZGQyWXdxWXI3SENlSlNnczlxYjFiWEFSMCtwTHY5d3JibzJ6?=
 =?utf-8?B?QnV0MkdiMzRJYzJicmF1NkVOUEkxWndOV25ueWRWUm5JMTAxNWlCeGNtYWxW?=
 =?utf-8?B?QmVEYmw0S3lJaDF2OWNYNno5Vko3Y1BSVnVIRWNWdDN2KzNJdkNRZzRLL3Z6?=
 =?utf-8?B?dFU4MDhUZUZxekFGWjNGSGFzckFGc3ZWTDJCVm1WUm9MRCtQZ08yamwzb0JH?=
 =?utf-8?B?MmpkMkZ4ZDQyMHJXKzdFelNvMlNqZzVuZXRHblByNHBsV1hZME4yQkpXcVBF?=
 =?utf-8?B?Y0xHdFRocGRCS3c1ejlOZVVJQjFWSTF3MVJtdGNDTjdaaDZ3TGZ2OENoVmVz?=
 =?utf-8?B?R05UcG1sSG5RRzNyaVc1SkZCb0ZOME41R0JXQzV2OE9LMGF0QllQNTZpeXAr?=
 =?utf-8?B?ZnhGcWdGMUtpOHBzUzFwbDdxYlVTSHBWTUdrV3JzeE04RzU2WUdqN3hOczZT?=
 =?utf-8?B?Q0htMEpQblpBTVpYc3dpd2RVTEhjb0ZBcnJOdmdVNTFmai9udnJxVnNiTEQ4?=
 =?utf-8?B?dDBNclNsTFh6THQzMktyYldBNlZpbkV4ZlhmTC9RcW4xeGc0M2VYRWdaaUFR?=
 =?utf-8?B?TVdnYmYwdkVJZndFRVFiYU9SczRNVW5Da2NVdm9vdnBSM2dGZGxhMFY5aWta?=
 =?utf-8?B?V1BrbDlpYUFzdSsvZTdoNUNNb1RNSTI3RVkxODlQd1YxdnE2dXQyYytGQ0Mw?=
 =?utf-8?B?T1dTQ0hOT0VhdllWMU5CdDVSdUkvUWdMRzJSbCtSS1pwNmJHMUNtZStWZXBV?=
 =?utf-8?B?eUlhb1k3eHlMVzZ0ZFVKR1AyQXY2VWc5dzRuK0VzSmlLNTd0eTZ1b1VLVysx?=
 =?utf-8?B?Vjh2akpzczNYdDZCbVJ4TktuMHRZUHpCNEQ1VnZaTTlJWkE2QzhEZjJyWGZi?=
 =?utf-8?Q?VQ0zntWOW3wWI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be311da8-3738-4f73-5b22-08dbb3715e10
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 09:19:29.5852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zgg0lf3on9TFd6ha5hxAiVL6WTTqWXBVn5UTQaa2degdPTqwohAhd7E/x+ZzCXeK8GPTkEkUKJYtjmxhJ9gHHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7778
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-12_06,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=936 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309120079
X-Proofpoint-GUID: JUqnGN_PvCP1p-PvE2V5vZ4bmjCh7jbR
X-Proofpoint-ORIG-GUID: JUqnGN_PvCP1p-PvE2V5vZ4bmjCh7jbR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+

On 12/09/2023 10:00, Damien Le Moal wrote:
>>> +int sas_ata_slave_configure(struct scsi_device *sdev)
>>> +{
>>> +       struct domain_device *dev = sdev_to_domain_dev(sdev);
>>> +       struct ata_port *ap = dev->sata_dev.ap;
>>> +       struct device *sdev_dev = &sdev->sdev_gendev;
>>> +       struct device_link *link;
>>> +
>>> +       ata_sas_slave_configure(sdev, ap);
>>> +
>>> +       link = device_link_add(sdev_dev, &ap->tdev,
>>> +                              DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
>> I am not sure what is the point of this. For libsas/pm8001 driver, there
>> is no ata_port -> .. -> host dev link, right? If so, it just seems that
>> you are are adding a dependency to a device (&ap->tdev) which has no
>> dependency to a real device itself.
> For libata, the point is to have PM order suspend resume operations correctly:
> suspend: scsi dev first, then ata_port
> resume: ata_port first then scsi dev
> 
> Strictly speaking, we should do that with ata_dev and scsi dev, but libata PM
> operations are defined for ata_port, not ata_dev.
> 
> For libsas, the PM operations come from scsi, so scsi bus operations for
> devices. And given that:
> 1) we should already have the dev chain:
> hba dev -> scsi host ->scsi target -> scsi dev

That would seem right, since scsi_add_host() is passed the host dev and 
the ancestry would be created naturally, but for hisi_sas a link was 
still required. Let me check why that is again ...

> 2) libsas does its own ata PM control when suspending & resuming the HBA (if I
> understand things correctly)
> 
> we should thus not need anything special for libsas. ata devices suspend/resume
> will be done in the right order without an extra link. I do not really
> understand why hisi_sas need to create that link. If it is indeed needed, then
> we probably should have it created always by libsas generic code...

Thanks,
John
