Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B048C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjGaOnw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjGaOnv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:43:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCF518E;
        Mon, 31 Jul 2023 07:43:49 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDTakw011544;
        Mon, 31 Jul 2023 14:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=mp8OVDLahkUW6qtRzsuXcSou+URTQTfbT95lvNy06ms=;
 b=R3xPtinneyyiw5126zqx+Ab8Ni7Ex8LFjbA9hXtPSFE2eyz6YeeOfMGOPc9Nfk7nJH1v
 wqinLZkp4hks6ZTVkNMmXuKhNEaqdODTjlVTKr7Z2EPTKtXQBYp5udhH3hAFp1/hc5f9
 dPz+bT7JQQt3AHhkwx/hzxqReCa/j02lcYMyZNLO5Icoo5EVVy9i6d5zbsLWa8DLJ35J
 k+0xax0ug/USQfI3U8df4qSmRIEYheU4j1ylRBYVM9HUCc8jet2OTYVql+OloRl7Y+xn
 aMEl9kTUS8XCPydEfezUpPPa8bGHkxO/SY8DQGuS0RcJdHNgtL6o0QlKrlVYwQJ9dRAo +A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4sj3trs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 14:43:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDbBXf008619;
        Mon, 31 Jul 2023 14:43:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7b6hub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 14:43:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJibBY9RnSe79xnnZYEwpw2N/CxvtKjsipDiiRDo2PEEmDpCtbXQ0mkOrwiqZur7WDg/WTVgSJ1fJXi9Qkcb6n8T5dZduFvaPyrQ6SGJazWWbZAoXP+YNNQsfKCJeB6iqFYA6alutqCxXoBN3+LwaAWPOBX3RjXGy4Ky5emn2o+WakRH/AgmG8ttMQtr2n/SgHVe/NBsgAHHUKPQQjuBF/ChPLVCUSgPTRUcWGdb0QpAhW4oe8cDZ2IZBBAzH0xXuoPZ/iyM1IkwmBL5IlJhkr0xJ4qOVO0Hgzsqa6so942tIYua0/juj6EK/khBc3AgOY9AeErY2uriERG4vA2fyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mp8OVDLahkUW6qtRzsuXcSou+URTQTfbT95lvNy06ms=;
 b=BIQOIom4cR5nuZqRalKs1nW2dDGzRiSsmAUGrxnmRC38hskYWq/guK7EEM3B0U9odHX/0bgrQm2EnfKWGW/vq7dyZiNOOLdzLCKGOIMagPNu3dTnJ8MEFjbv2CHTAb2F7uK0i8sz+nOEsxJPw16n5H0AN6w5rQOzC+Nm1MjjrwjOuGvd9BRMj7Ypm6e9SbtqOtM+AyNz1NELGJvHsqoApA21IY+UmhJBfgVy/WAF0Oy96967Ep4Htb1WOiavm4HHbKJPN9xJvnLd45OEwCsKKwCoHSHbOBnEwyFU1I+8T8+4w3ee9fiUEF5ozwiDZKDYzucyO2QG0bjPyrRRdDhXiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mp8OVDLahkUW6qtRzsuXcSou+URTQTfbT95lvNy06ms=;
 b=mGX9tbVd9yFP9zDvJAREyGWwtts89ccyPznZB8ReIcwsp76G2zwFd7cDUZDNR2TUad+9y7ZKWy1eDhmv8a0lWdHarmTj2syPGqaTdAfr1TPt6xeWo2frKWY7ApcwJWmiMXCptZM0bdH8UFluI1swtZBIAYogt/M3tIpCbTIb7B8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4523.namprd10.prod.outlook.com (2603:10b6:806:113::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Mon, 31 Jul
 2023 14:43:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6631.042; Mon, 31 Jul 2023
 14:43:12 +0000
Message-ID: <e0201a10-be39-e9c0-fb5e-cf06bfeac196@oracle.com>
Date:   Mon, 31 Jul 2023 15:43:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 07/10] ata,scsi: remove ata_sas_port_init()
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230731143432.58886-1-nks@flawful.org>
 <20230731143432.58886-8-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230731143432.58886-8-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0032.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: 954427c4-f38a-4f5f-7df6-08db91d47734
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHE2XyoChavC9f8AyQEUZVumTYU13on2Gw2M6eM+7wzHp2RrN+qllyIXm0u8uD186oZFGvqhx5kFCNQQQ79wNmhBsNy29JwbVq2XS8/poxz3uFx2bwIXtJv1PSE+rcHTPn4hv+a0/+wyZQZmMW/Of6Te/PKyiO6u5K2V1W1tB+rOJfnguKQKd9ofAaJv+GjY87XTjbVrPz0MTNdypcLofSIA+rinGyqizXIZtTh2A6Y1iJRDuU8w+zkMbKKROJQ40rTasCsQ22JpElIzRF5I6eYU9zGe8/BskD1Q/ZFC+igcZqUeVxRFAyT+KNfN3NOqIwGEULTMYClenuWtgAMF00AVwDhBh4c8uJK2vCx+2mM22D4yYwZBnJsU/NbvrONE2Q0Xt1YBfIr0xRg3udrHhtnR7FRSKnV3etv8XZlQqRMzNybQzTUpUzr5yVqK37BYtcumir3mWeyK1MnlFm9+Kip2KBvlvtk20HkaJAGMQ72BLaJrnArHADE3DFUzhvw7QynQWR1WvqNPyoKyOpCzO0bu3xf6sc3zwdWlhf79duoVzEQ5mF3bsxv8Ac+hgdKbVUAAozdYVEw+I0w7RS5QDLicv1zXB5xM8MWpdZKEL9FpXbagVXuJLqLo65uPNsBi6abQgP92Gsp5Rb+aWr2rhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(376002)(366004)(451199021)(2616005)(36756003)(38100700002)(6486002)(36916002)(2906002)(4744005)(186003)(5660300002)(86362001)(31686004)(6666004)(31696002)(316002)(66476007)(41300700001)(26005)(6506007)(8676002)(8936002)(6636002)(53546011)(4326008)(6512007)(66946007)(478600001)(66556008)(110136005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmZuQXBHaDQ1ck4wVVlGNzlGdTNjeElETm5JaW1HOVZ6U2ZVYkI4emRPc0s5?=
 =?utf-8?B?MTd5ak9uMDdvaTlDYzlxZmsrMGxGeFQxTHhWQXd6RHMyODUrN3JGVnZ3ZHp3?=
 =?utf-8?B?ME94ZS8xN1hNTXVIZW5PRmJPc2QyWFdqR0ZBbXZOQTVjN3I0R1FKTkkwT1lV?=
 =?utf-8?B?YmJmSEdmTDVWcDRFQVd3UUxXOW5IWktmWGZYb0JtMkN5dVBTM0ZkQ3FnejdH?=
 =?utf-8?B?RlN5TzZSQi9rMksvcDl1STUyVmtFOVoyaHU4VWpPVy9VckdaSThTMXR4Q1Ju?=
 =?utf-8?B?UDNZdXNWQm5wd3JIZmVqK25MaWxJdW0zeGVpemdPSlp2aUhLMUhaL3R3dW5u?=
 =?utf-8?B?Y0c1Qjh3QzQ0RlpWd1l4c2hiQUR1UGZiSWs3YVJMb1BncCs0V3JzSGUzL3BR?=
 =?utf-8?B?V2VOWmh5TGh0d0FXWG5HWDJUak1xUUh2bnV5U2dJMlhES0NhUm1mUFVDa1hB?=
 =?utf-8?B?Z1BWdzdRTG1VbDk1ZkJ5RnFQZUFsYStpZytiTXlJM2lQSDlWUmt3cU5sZXly?=
 =?utf-8?B?MzdhVzJIcEU1WGZCNHFaeGh0dnBnL0FlZDlPVFFMck0yekQzNEFzNndCL1lS?=
 =?utf-8?B?OVJQRld6MEFVVmZSSDMyYlUrQUFFTVlMeGYxMDVFd3RWNG91UkRRNHF2YzVQ?=
 =?utf-8?B?N0xoNHhnZ1oweXd0UkJDQlE1VnJzMndRVGkrNlB3Y3VCdHRndG1pUDVXT3Fm?=
 =?utf-8?B?TDJaY0pTS2hHc2xrUzUrVGhNZU81YWx1RVZ5b3pGeDU5NVN2VXE1TGt0aXIv?=
 =?utf-8?B?WlA4ZXRYY0JlUW5HdFR5UjVvaXVqejdUYVVXemR5RWpod2VvT0xjbW8vSllz?=
 =?utf-8?B?Y3d4eVhoV3RIa0ZEZyt5ZXMxbGVDSFJhZDh6MFRleXdvOUMrWVlST215Z21x?=
 =?utf-8?B?WE1FbEhFdG9OTjh6cTVEMFd6SG5RRDdlcGZaZXN5dCtZS3NmRjFLaEtIOWVS?=
 =?utf-8?B?MmtzcFozVTN5NCtpZ1hWN0VYZHRJZ3hXajhsRVlNMHdad2xuSUl3aTBQSmlP?=
 =?utf-8?B?NjhKWHVXdnpzZlZmRXdEbVlTU2tBbUhsNmRCRittSzNtRUJ6RzZBNXh0dFZH?=
 =?utf-8?B?ZlFxWG4rVVVyK3dZM0ZhRWdpam1memRYWXRVb1dOaERsVjhidjVDR3RVNWZq?=
 =?utf-8?B?aXI1WGJWWDVkaGxJVnIzU0o0ZmVWdEFqRW9TMEpQYVhCK1gvVHJaRGpHY25X?=
 =?utf-8?B?R3Z2TVJWRHY0UXp5c0xDcjMwOWFFUzRSM0xNSzREWnAwMVk3K3IrM2k5YjRu?=
 =?utf-8?B?ak5Yd3dVQVZlV1hlMUYzV1psOXZSaUQvaUt3Vm90ZU9MNmZqbDh1cnYweEtm?=
 =?utf-8?B?d2hMOVVGeGdkb2Qxd29BY3F2dWdWU3BOQXFJUFkxNk1DSUt4enkyZ0JNRmNR?=
 =?utf-8?B?b1JCZkpkOFpWREJwZ3o0OE41LzVqY29tdDhkazc3Z3lHQjM5Mmg2cnJQOWtO?=
 =?utf-8?B?cVVVbFRqUnNORnVscVVUb2xsOGJtbWkycFlxUDZIK3FyN1hzNXNPRUNaajQ1?=
 =?utf-8?B?MDUzTWx5R1BWSm1kOHJIbkxtWHRMTVVlcitmQW8xd3FYTlVjVDg4YXl3dHVP?=
 =?utf-8?B?ejRYR1BLeFRGK0RJN2NvNndkU29VQXFuTU9CSHR0cU1WZ3R6SFdML0FWK3RL?=
 =?utf-8?B?UTRjNXlmelRxK2RLdkhqdDdZWEFTeDZmOS9PekEwb1A5cTYva0hldkVaS0to?=
 =?utf-8?B?YXp2VjdtNkw4OE5iUnhTbDB3L1VuMUw2TVUzSU9VMnhpMk81c1NSVFdJRlFE?=
 =?utf-8?B?REVzTHd2MUF0TGp5WkJDaEEzVmhvbzZFY2hDeTdMZ0pXRVpVRUxxZ1ZUNEY0?=
 =?utf-8?B?dnpHWE5UZTNIMHkzTnFpb3FaRWdtQWpPTkoweCtpZTZGb0lnT09CWDJVRERB?=
 =?utf-8?B?U0ptbUxodUVTdkhESk53Nlo3TFNoNjRFaTZBaU5wUHdCTVBqR3JVeDBSTmZ6?=
 =?utf-8?B?dU44a1g4Yll0UU16VWJ1Ym1LTFcrQm5rNW1XelY2WHdwOG9sS1Y1MTBFTFRy?=
 =?utf-8?B?VWxUVjBneUE5QnppcHNIejlaQzZ1K0prRkx0Q1VOSTIvanZIQ2RzY3lOK0JR?=
 =?utf-8?B?dW4yTkVrM2daaEVBemtFOHVnUkJPUnQrQm1BL1FObjlXc0E0MWdtRWVwbW5s?=
 =?utf-8?B?RTdzb1dYUUZxckZVMDR4Y2kya2w0K3NSdkRiNWRvcjA1a2hGcnFHZXZFN1d0?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cDlZd2diNWVheklpZVlSVENIUVIyK09SOFBwelp6SEZzUW5ldFZHK25QWUxM?=
 =?utf-8?B?NElDVnV0MjlOR013V2pqNkNtOWEyTCtCSmZpWWp1VjFORXpheTFLcFBUNUtj?=
 =?utf-8?B?UGJ1MDk5U2w5WllBbUt4VXc4ai8zU1RxdmE4d2Z1emRaTnN0dmNMMVNCcjBs?=
 =?utf-8?B?SktaYnV3TnlXNlc5SWxNN0g3bWNvK01wVTY0a09vaE51S2h3bDhvaXlVd29S?=
 =?utf-8?B?eGMrRlRDZk9BcitvODB3NjE5M2Z3R241VmhkVkRhWEpVVHVIdG12VG5NeDFV?=
 =?utf-8?B?VFlnVlZxQzFZSDM4MGRSWEg0WmVqNTJReVQ1Yk4vc2Z3N2M4em9XR21NbU5V?=
 =?utf-8?B?VU5ZTXBNYzYyeFR6VEdNdzZpVVVqSkJtbmh2MmRPSldBaXlHdk1FRy9PcDR0?=
 =?utf-8?B?bG9iaUd5OERscE1MY0lHU1JlbXMrdGdLNWV3Q29nZXBCdElQeG8xZHRSY3Zl?=
 =?utf-8?B?R0V1dVFnWmxpNkdTa09zVTZxdTVYeHR0QmIrNUNpOEJTc1JNQU1IdHlNQ056?=
 =?utf-8?B?WEU3dndUYUJlNU04RXMyWDZEYzhYTGp6UUxMakIyY2FMQTNSQ3FmUG1LQjZo?=
 =?utf-8?B?VWc0NjhvcGg0U3N1ODlVRm9NelFNVWgvUS9IVUk0U20rL2ZDY3dseW1aVFRX?=
 =?utf-8?B?dkxZc0Rsd1BMU2pSNEIxbm9BekZ1S1hzTkh3OW9JV3FEK3RsYlFYaEVpa3Rl?=
 =?utf-8?B?cEZtT0xVYUNGdzFONC9XQm5kRnVreEtFT0pZejM1dzNxb243S0o2bmFUdk5I?=
 =?utf-8?B?ZktmZmdPOUlPbWtTTDIyWmJLVFM2dUlGVm9tRGNHaXJFNStJZTNrUmJSOTFG?=
 =?utf-8?B?bExVZjlDemRZKzR1eGZWWGNJK1pQYURLK0g5UkRJU21EQzNKNTFqSWFUU0Y2?=
 =?utf-8?B?WmsrZVVTclpOMTFqZm1GNmxvRXB5d0lidm0zTWdIalZNQ0lxaS9WSTVhUVZp?=
 =?utf-8?B?QTFicTJUNnBQRktneG9hREU0TmRneitXYSt4OHV0R1BrSUZ4aWplZmJab3RM?=
 =?utf-8?B?c1UrdzlJektCbWtaQmVNV2lLSjRodnV1K1dkOFd4azZ3VW0zV21vbzQrQ0dZ?=
 =?utf-8?B?dzdzYWxhQ2s5SmRNYnRaYzdnb2szM2VrVnh0NGczSUpLc0pHTVM3ZENzT0lY?=
 =?utf-8?B?R3pFNVlTK2o2aTk0b1YyRjVqOUNrOEVZbjR2VHFoTGNhbFJtR2hFZ3ZhWEl1?=
 =?utf-8?B?K2p1ZVU5elkrZWwxbEVlYkVOTTVqc0RaL203R0hGSk5CT1ZYL3pQeTM5MFdV?=
 =?utf-8?Q?dWW5ln8xy0hU1xF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 954427c4-f38a-4f5f-7df6-08db91d47734
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 14:43:12.4147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xT6zmpUimC2Z/qKYsH2TrAAUkJtaCbr3EvKybb0hNVX5DxD963MRBJWjw9pjq0HE/XVYAZzXTvGc3bBeaaenCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4523
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_07,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307310132
X-Proofpoint-GUID: 9NU5vUvbHxhX1ObsSIM9BWuKgkH-T4eE
X-Proofpoint-ORIG-GUID: 9NU5vUvbHxhX1ObsSIM9BWuKgkH-T4eE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/07/2023 15:34, Niklas Cassel wrote:
> From: Niklas Cassel<niklas.cassel@wdc.com>
> 
> ata_sas_port_init() now only contains a single initialization.
> 
> Move this single initialization to ata_sas_port_alloc(), since:
> 1) ata_sas_port_alloc() already initializes some of the struct members.
> 2) ata_sas_port_alloc() is only used by libsas.
> 
> Suggested-by: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>

thanks
Reviewed-by: John Garry <john.g.garry@oracle.com>
