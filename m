Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220B6EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 08:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjGTI2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 04:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjGTI2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 04:28:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41F71A8;
        Thu, 20 Jul 2023 01:28:17 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36K3NxJt001236;
        Thu, 20 Jul 2023 08:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=FQMQ9Ghh6pUk8VaULPWxi45a1T1PDWgVnvuW9Og6TVg=;
 b=OsiJdJ4dUS0e65ZGPMV28jpX3jIHTdAeuTj9Xssn7WsAdzUHewVqcb37swbCzzX/G2mw
 IT3dxay4MF5245rJUiSha1fAqvDHUrE8DzjuwDRBDbRI7C7jNo9RXbLpbGNw32DJLv4G
 E/75cuTqib1Fu09HERZS7FyLW6kaNARZG5Q2uR1PUbvcHNK7fzyhJGjghtxzCWCKkowf
 Jw2B2FIyUHj3L6k4fv/ic3AWxhl4PuXwnK2PQhcLFb7invPTmfv5mSvlwQMw3mClSmnS
 l5LrxQPg4HKJGNaEMcrgyUEi4SQIYq3uz/RnTU1cNAWMRjeb/24NQHVoXmVj37tF8Z4+ ow== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88saph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 08:28:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36K7oA3l023866;
        Thu, 20 Jul 2023 08:27:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw8jex0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 08:27:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akkKGkxpyZIRxmEIwtqqIO1IqDjFlKFCV48s7sC/Y1Csl2O2/JViJ+7CKkxL0+c/fCvjBiC4cVaDDw2IqGtVvPL/N4kaZ92MChFEzsUAe2SEb/GNHaWC84Y5m7TW7TzAROSBpfvf2sooM8SnD1D42ME2U0ce0cVQkD9LxrB3GymOoK/4kCxZnZDHSnecIq+nvYfH/wuu3io5zNKx1/9a5reiCJjFGYgqLVrwE6MbeFl6qewDNZgi5bbULM3yS4/+vVw0KDyEUzj0HrAH15Di0DTxATNMwCkv9Gfh/X7HC6v3U1CyqmtgnRLkbt1nhBz1ELZdg4fIcKMZ7DxTBiX4mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQMQ9Ghh6pUk8VaULPWxi45a1T1PDWgVnvuW9Og6TVg=;
 b=nB9wT0XRx6BTHDjZH8q61BHiYaXBXPXnfQetK9adSjJb+fbS7SV2c9bsDK2poQY68Ra6/5iv8J0oNz4BwW94J4cB6mOIs8Dk2OOxowGRBEKlkDxGb8Oe6g0nRmHsftz5shEVeuGDO3tQxgIbSf+lrFsPknucpCDpSqaVbztCoM5rLUcANxEcP6RC7Ha7iNtFbDY9S7lL9rZUj59w+L1fyc5vg8cHiaCj+yVNGUkf23onJ2krl86Y5PGu0sqCfr0fAYKtx26Bd6xjAlOwex/XQ84uCTeVFICjIUb7VieE33J5M8mHP6uIsqjbdEvI6QkO49TLnzyBQoB05cdo6A+x3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQMQ9Ghh6pUk8VaULPWxi45a1T1PDWgVnvuW9Og6TVg=;
 b=jPT5IwBTLNGD3swzLdJEKmIroJijVixVVJfqQMQbW3OJ+YhPDBRgKnnrFY9+Ho0M+xycQrACf7fC9C61e1kFJeCDaqkAoT5L5rXP9StO/Ttl3eUu85eST1cBVjPwNhr9UaEGxBkuBkQ4u0h9lh8Nz57VbagNtqiWL08YJam17us=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA3PR10MB6970.namprd10.prod.outlook.com (2603:10b6:806:315::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Thu, 20 Jul
 2023 08:27:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Thu, 20 Jul 2023
 08:27:57 +0000
Message-ID: <9beb180c-b762-a227-bf5a-48ffcdb7dfd7@oracle.com>
Date:   Thu, 20 Jul 2023 09:27:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 6/8] ata,scsi: cleanup ata_port_probe()
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-7-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230720004257.307031-7-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P250CA0004.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA3PR10MB6970:EE_
X-MS-Office365-Filtering-Correlation-Id: 13370494-02c8-42e0-430d-08db88fb38b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gH2ZniWrPi10KvQvwDmhYCKYN4mRGCKIWK0iyPF+CcxxDZZ9voHZ3wznuInqxgRYZIEHqj6K+LZolnA1LI3B/megtqzzuw+xnza9/gyH+2H+zr//Er1pAXE8mtxMSmzVQTb06XSrHIY8CE4EqMroKWI4zZfENjNiO+3wRUybTBySvBFifcJ7BTI4/l4vv3GY46bmCjSyNAy7sBP6g8wuII+cEIdEbks5md2WQxCBmh23QH9ykEcscBBBanZBeURbR75hXlKcIt507YgnRx72xezsNn7mIWUvs8gGimJ9h0Ba1NR+obeszlIi+Mcd8BR+WmOkjnCrsvGBpD9TZL0WOcKeyA/3Eo7kfr6u04XDErcHKrEnbLhTyy1D7G5sZBkMTrbWyOqrRtEFw33A7JDb4v9z9kyEQx7d3+gTDh0fPNcL9i7FsWVW+RXO8BCigV95SzNFfWVxgmPpA1KyRNDKieUYGRQNGlvoa/F8R2DZgBhh4pRT2RXxOr8NbGqQR+Rr6OmsL8s+AbDZdPIrJcBV5eV80FptE4TDco0bKRWQYDYJp2L4sy1aYeVmZxYzpWygyBF7SCtJYErq2CkRNKnQmJNjX+VmwUDSzUoHv0NVqefe8skl+myY2VumK5vDT8TIW3qwr6v/GWD08Lo2A4DZpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199021)(6666004)(36916002)(6486002)(478600001)(54906003)(110136005)(6512007)(186003)(6506007)(4326008)(2906002)(53546011)(26005)(41300700001)(66556008)(5660300002)(8676002)(8936002)(66946007)(66476007)(4744005)(6636002)(38100700002)(316002)(31696002)(36756003)(2616005)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0ZYK0NZbCs3aXFJU0I4N2thZ3FUWkZEOUVJUnhCVDdGKzFDcHZ1VUlwSTdJ?=
 =?utf-8?B?aDRtUENWOUI2NG9VUU1jT3hqYy9vcDA0L0N6ZVY2emtpV1F0YjVIZDZFeFYx?=
 =?utf-8?B?WjJNUERQbVJ3YWZxRDQxTFFaT2ZiazBJS2wrU2NUTit5K1YyTnBOV0dNTkdH?=
 =?utf-8?B?YVFVMWg1c1doTUpuMkF4S1RIbHl1OExMU1FXZFpadVByclRWd0FMTWl0ay84?=
 =?utf-8?B?bE0vMUxxdlR5TWRIMGZaOGZQcWVITDFvQmpNVlFVNEsxUUhGWURrQ3NLbmpz?=
 =?utf-8?B?cFFkaWd1N3pSbUU3eWhEbUE2V0t4VHNJOEoyT2g4NVdtUUp4dkNya09DRHMy?=
 =?utf-8?B?V1ZTSHVOWVNTelU2bFpJTGRObDgrcEptaUJhdXVJaldWK1FESUcxV3N3Y05s?=
 =?utf-8?B?ZmVTTGI3VU9GWlNpbEh3M01pTlpMbW4vTGRUY0FON1ZkTmFXT2tOSU50RHJJ?=
 =?utf-8?B?V1VhdzBsNmp2ekI0enpuZFoyTkRUSlowZkxnVHpzNVpmWUFjUUc5VS80WWc5?=
 =?utf-8?B?RDR2R1IrcEhtV2dlSHp6YjNwSE9JQitvNjlUMFpUN1pnRDI5WjRIQy9vR3Zv?=
 =?utf-8?B?UVJFQy9RaE52bkc2eERTQVFHcFJHMmdvQmtUMDFCOEZTanZHbEZTVS8wSjBJ?=
 =?utf-8?B?Qy9ocTc5MDBuQXRBeGloV1VXRy9PTTZqbVZTV1BaTE9EL29xbmhjamU3aHhJ?=
 =?utf-8?B?aVU1UXFCcERpWG9vK1JLU1JiNnBtaWR2cGp3RWdZMTZOVEVENVFjQzJqNUxQ?=
 =?utf-8?B?Yk81UUdKOVhsNTB4dDlMVXNGaFNmTXZrWTBQakpqNlBuNWh1YU1kUExZWkpJ?=
 =?utf-8?B?enpZanVnOU9wcytvRktqNHN2ZnpLN3dubUJlc3FYT1hoazBCNDIzTkp3NHdP?=
 =?utf-8?B?ZEVYQmRML01teWxyZks0UVNxS2FMa2lnUkc0ZFNXUDFJK2UvUHAvVlVXZ0h6?=
 =?utf-8?B?ei9qalBONkdqMzhqaCswQjQxRFhPQlhSUlFabHZ2TmZLR0FmcW9yamdwWUNM?=
 =?utf-8?B?RTBTRk1BYi9ndS9ZYVVxOWQybFdRNmF0NzNWT3NPZ0NaNkZKWWRiZDM5eks2?=
 =?utf-8?B?T1dDa2JxZkIxZlQzSzhTWWtOcTV6djRIZHVFSWUyaldxWjM4aUlPVkNBQVNy?=
 =?utf-8?B?RW1iaFJ3aG5pMFE4R0g1Ym1SaUxCUlBocUFzemc5TC9IQVRkeC8wbExDT2xy?=
 =?utf-8?B?RVJKNE5xVG1yWTdzTGxkMmN2NUpGeDZLZUxTSFlHb2NQc3IyVTFuWlFlWnEy?=
 =?utf-8?B?Q0ExalNhVVh3WFYyWTBIbFBob2tSWng2K0RiK0s2TDM4OTVRZVhVUDhXMytQ?=
 =?utf-8?B?M2labFB5TU9TeDk5dUplOUlyNUxGNlBwK1F4a01welp1RU1FbmIyelVZc0ND?=
 =?utf-8?B?VFgyU1J6Qlg0SUZVekVRTCt6WVlyNU9mbGRFMk9qaE94T0pnV3dFUGxFRGVX?=
 =?utf-8?B?QnhjZWt2dmdFcnBaalVBWHAweUNVNm5Keisvc3dNa3MrSDU4QncrWldWM1RL?=
 =?utf-8?B?M3ZjUysyTCtKZFRoYkh6ZVBFZGd2a0lkelJEQUFqTm1pZ0thRkVoM1NGOWVP?=
 =?utf-8?B?K3ByeDg2bmUzOUNKakpmT0lYQzUxcGR4WnpjNXVXR2hpUVVjVjRoRlpMejlp?=
 =?utf-8?B?RTR6SEV0MkEvelA0TGtYUzBBemcyejJXY0o3Z1JUMWJIQ3J5ZkE1OFR3WkRS?=
 =?utf-8?B?UUthc1AxcXNGaE1ZM1p2Yzk0N3RFYUZHbG40SWZQc2doSVM2d0VCRjVqbGpW?=
 =?utf-8?B?blZSR1NaWHJ2UVVqbitobkJXdVBZWGZ3eHhHUlhMVE1SMjR2dUV5Qmt1NVJt?=
 =?utf-8?B?QVNQNUNLM2NraFhXRmZad2ttaVZLVnNKS1lOMVN3ZTRyUnQ0NFNieU9pM0Fr?=
 =?utf-8?B?MVhJTGN3a0ZyKzZkYW5CUlFDMm5nMHBqNmNiUmJWSUdlMEhNdGdYUTBYQ1NV?=
 =?utf-8?B?TTdoK3dhS2tKa0hSWmRaN29nSFU2Zzd3eitUb0xuWkdVR1FXM1ZNZVo1bHJu?=
 =?utf-8?B?Z2JuWi9kVXFhMTNUeTNOUDVVcnhjUWR3T2ppUFlnNHFPdFJnMWFIM0ZBUGpz?=
 =?utf-8?B?TnJjU3IvSThkU2tJbUFpYzNOQm5DRUtzZXdyNjFmdGovaTVhVjVMU2dhS2NY?=
 =?utf-8?B?Y1ROS1YyTElTSlFkMDRDSisrRFI0NnRiRlE0YWwrdkNNbVMyeFlMWkJMcjlO?=
 =?utf-8?B?VXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?N0hIdTdzWkhycjZmV1FvT1ZJS0JMTm9HaDZQcVV5SmZOdE1JV0YwMTNDbFEr?=
 =?utf-8?B?ZDBJelhBREYyU0txTTEzb3I3VlFnM29rYVd6bGo2bDZDdmJjakJNSC9zeXc5?=
 =?utf-8?B?Mm5MNlIwYnB4NE9WUlpaZjVzbzRraUNWQ3N6eGhJZC94ZzZYSjlndjhFUGsr?=
 =?utf-8?B?S0VROFRJUHA4UXRMcXVjWGxqcm5IcmN4emM3dUVKSWxmSHdySG5IeFBpd2VZ?=
 =?utf-8?B?SER4cGs1dFdaQys1dWd0MnZsRUpPNVNCVXNHb005ZkZkUFFpaWU2YVhndjh2?=
 =?utf-8?B?akU3V1kxTy9IY25jZnMvU3UwUGUxTWRQbm42aVpvNjlFU2dkUDUzeFQ1SkJW?=
 =?utf-8?B?d3ZFaXQvNk5CRVZ4N05mdUd4Y2ZBUVVxUU9xZXVBM25iQktBeVFRaVJib2tt?=
 =?utf-8?B?b1c1OCswT1o0SmtneWZDVFJjY3hsVThOTUw2OHJ3MkRndVk4bkc2eDB2NmhK?=
 =?utf-8?B?anN1dU5LTys2VFBBZHBzZzBZUHhWQWFCQldRQUdDbGFOWmNISkRFZndGZTBJ?=
 =?utf-8?B?YzlNQVBVT0NoUDZ1Y3lGQkhTcE42bFVhYUd4OU5hZlUyRWFRM3NGTFdoTk0w?=
 =?utf-8?B?T1NHbUNXWUZOMWFnNmZ3Nmc4N1N3VzRBM0Evb1VYYXVNcDMrUWhUaXU2c2h5?=
 =?utf-8?B?R0tNZCsyNmpnRExLVE44K2gyNDZQMDdiMU9rQlVVREtJTzZwMjJCazM4TCtF?=
 =?utf-8?B?cGdKcGJKcG1hbS9BVXplYzZuMzh1MDdzdXVPMTF2aUdQZmVzeDBqbjdXRUdj?=
 =?utf-8?B?TFBSZUQ5blBCTDlteVZXdnNFS2REQm8rTnZIV3ljRXJoRTlaMlNUa1lQb0xH?=
 =?utf-8?B?WmZyUUt0SUpiSmNsSUtLMmlmRm1DTkVxWWRZWFp1STFiN3R6dm9CL3JBQ2Zy?=
 =?utf-8?B?Rk9adHhXV3VFb3FKZ0huK1ZwWnExYVVFanhKUEgzZUxLdHNpeEtIN2tWMG9v?=
 =?utf-8?B?ZU8vY2ZRVXBYWWgwc0w0VjBZZUlSaTZMcUhvdTg4cGN5cUhsa3czZEQwUnBP?=
 =?utf-8?B?VnpjOGVjajRQVWV4Q2liODRnZWRtU3pYWE5md282Rk9yeklSU09DamkyazF5?=
 =?utf-8?B?VjVOZFdIVkM2THFMelpNdCtjS3pZSG5JR2JxQWZ2WVd3Wmh6d2hEVXdublJG?=
 =?utf-8?B?OU8xbHNDSHUvUWJXKzA5STUvRXZFcDlROW5RVXhHemtKMnFVbDhjMXdhL01v?=
 =?utf-8?B?QVJNRHJGb1haS3JsVi9GTkp3YU1XM21PUktFbUJwQTNkLzV1L08zeVU4QjVr?=
 =?utf-8?B?VnRhNUo3aFZZdWRCaEc3SHBHNkpYTkZhbDNqK3J4V0pWM256QT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13370494-02c8-42e0-430d-08db88fb38b8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 08:27:57.4880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rt3w2pcL79Dsl/QsOasVaBnrxsL2qopNiW0Nl2nbb9uTNVpHwgExc+ohv4JLqEUrOWxooJ7Vo6+GNmhd1S6FaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6970
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-20_02,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=861 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307200069
X-Proofpoint-GUID: uHhzLw556OASWDI7PyggT4sWEYF0hKpd
X-Proofpoint-ORIG-GUID: uHhzLw556OASWDI7PyggT4sWEYF0hKpd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/07/2023 01:42, Niklas Cassel wrote:
> From: Hannes Reinecke<hare@suse.de>
> 
> Rename __ata_port_probe() to ata_port_probe() and drop the wrapper
> ata_sas_async_probe().


It is confusing that the previous patch is "inline ata_port_probe" - 
from that I would expect it to be gone, but here is it back again :)

> 
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>

