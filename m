Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D86C6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 00:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbjCPACo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 20:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjCPACi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 20:02:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95140241C2;
        Wed, 15 Mar 2023 17:02:11 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FMnXhs001277;
        Thu, 16 Mar 2023 00:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5mtUAPQ1zWqCpDNH68uSNzN9grCP6PeVohPBxnJxWug=;
 b=ONsKQz+0o7vb36Bikl8W2B8I4NKWGaERu9Q7Nu/yIUIem/E1vfvbJCl8efdDGucBKLoy
 lq19mEW3OPTzDIWrbVvrjc3ie31exmMK48lDTcBAg65SvtG6oiCTp5Qy9jmLMR+Y4Ale
 Ergbw0PaLmyOjx7OqzYPIW5jpZb/TpePNmPNN8RC1dXljv/m1iqc3gUVjT+7tGwEeMYg
 zLfoBXkfuWdyXadCFhVx82RzIz1NCGjTINN4arTKcmBDuv1FqEZYXbu5atoLc9D0O7eY
 5yL83+x9YYX7sZ+oYb5DMwS/HFCJK0MVHY/I4ek06YXJFQCS4/8wSWAwEZERge16jkhh tQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbp4m85uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 00:02:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FMwjpE035932;
        Thu, 16 Mar 2023 00:02:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq9nsjdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 00:02:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lt/YxiHzFDAGRPAFtYIgsv3/i4uorEsJoHqsBtCAPuhipf8ZdoHNqr/8oXXLqr5YWNf/ewTobRvHWYbTf3a8LxQA2dKUofC/cmR2bBqgLh8orPDt4vtoHLu8/n+ZE7IgMJnPk0P7gVroYWVgVcle3gWJl31MVy8WQFfuZD2LMjHljMLn9ScZLVSrtliKp0gtSU9ItdljN2nzqps/19BnNyHe0RZDcNdG6YR7UjXEJahRoTEaUtWBY1xScHf+nVEaYbTyR13ILL89BJMrFWQP+Ol+njQs09f3klsGmJrYZv5WG9jItaZ7YJdd5J2LOlm8SGa/j3rpbjmspwzZBgLxDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mtUAPQ1zWqCpDNH68uSNzN9grCP6PeVohPBxnJxWug=;
 b=QCliYR7hpeDNzT5btqDSZCgd92118apd+lLj3TPaXBFjTR5DDKntd1dJ/SiL7DlDsSWm2Y3t/Po7wi3+Uijru8HJqIVfCxMNwXWdfmqQJCvandMJKLf4Dzrg7EkBr+VI9BP5U5cpr3y9y3i2Muy1xOiQJTLdxe+SN0nx2EB7HEravKM7eRDo0vfEaVR3rneCZ5dCNpcy/CgK/cmk8oi2/pCtkMOcPNIOuj0A7/jclU3F48t8GQfzgSuHRuKYFLM9iJb0T5XzpQxTvkMCOkBcfr4+T1xM9oKYvfJUCBwAi4CkgiE0i+EkqbP2nhxVpx4uv/qQA4Yl+B5xCTHkCSDMIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mtUAPQ1zWqCpDNH68uSNzN9grCP6PeVohPBxnJxWug=;
 b=d2Wq/CZloWZDZ8a9Ayvf7b1mJYFiNmQJrs5/PnP7OwFKPcfHr94JJDpP0biGXJ56/Z42xqE7htmx8dkd0xaUGLzY5NGEZ2zqEoIp/XJoS6cc4rCgvhmlDO1Oie+EWMRynKOU6zt94AItx3F2TvzjczspXd7pVJ0q4GA6L+TxnhA=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 00:01:58 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::dddb:e861:6afe:915b]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::dddb:e861:6afe:915b%12]) with mapi id 15.20.6178.029; Thu, 16 Mar
 2023 00:01:58 +0000
Message-ID: <2567ca3b-8b2c-4c12-19bb-a4817c8f81d3@oracle.com>
Date:   Wed, 15 Mar 2023 19:01:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH 07/18] scsi: target: Treat CMD_T_FABRIC_STOP like
 CMD_T_STOP
From:   michael.christie@oracle.com
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-8-michael.christie@oracle.com>
 <20230315104757.GA30859@yadro.com>
 <e39fe3dc-2d77-64bb-09c5-dc165f9fbb74@oracle.com>
Content-Language: en-US
In-Reply-To: <e39fe3dc-2d77-64bb-09c5-dc165f9fbb74@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:5:190::23) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: d9832ce1-899e-4d8d-77b9-08db25b1a948
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zPX42ATrovqCyYFigc99Y4wqQifcHUxD0mWIH76PthgSVvhRDD8FQ2WeFmhDKOWx3rcrzfJXCVbv82BN+yCaMXIKExdVHNdfChynab1suRzsxwCRwcHlhOq14NfwQF/236ReX9cE5InpoFP51l9uINJvcUMxI7clHw+HT0mssi8b//3MNeO/8aqYxZWLf+0J7OmAXZw8SpPVxZGhTdsLMR1wfm5easN1xYMxQizS50c4PrbKa1XlznjEPC4N7cruXKq/W8qfgUTgzUvwB+oTt9cBWGfBY/mXPTpIWecxOFZNybskCtt6gv0LFOAhZ5JkH1ra3heVQFg4S9ewcSnIptoYkJmxjg9lqHBiaIl9+NJotjr2qJ5tihanZdPXApfHCQOjl3tpQ4vybE6Sg/+isgyTH1LBj0GOlBqXGMhZL908ditYTKm7FdshagCNCgd76xziAqPOxYF/DMDGYhYlfBM+3aZClSno34AG4EmV2WScMn5kZcj/ACBrPQqIi1pqOuQTXINpHpQotZKtHSyGgbWlFzwVsHyLiY2oX8s/9JVbIqEfEW5gOP+cm/18Tvs5lvV6scpB9wdEADGr9gtWv/AgAcvfO7Ez1XTF+9CMiE0llvpV+adDJdY5tTSwM3nlK/tvev2qoWXEv9vPpp2aMPbytpH/p8teXrM74cv/tCzz2teQ5ZQsrg7EtVJi27gjFbjk2kmwAekqiqM8fx1/cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(6486002)(2906002)(86362001)(31696002)(38100700002)(6506007)(6512007)(26005)(36756003)(53546011)(2616005)(9686003)(41300700001)(316002)(5660300002)(478600001)(6916009)(8676002)(66476007)(8936002)(4326008)(66556008)(66946007)(31686004)(186003)(4744005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmEySEx3YjlVbjB3SlRsRHJmYlpOV2FHb29waDhxZThobjhWMDMwRy8ycXFF?=
 =?utf-8?B?MTFOV3FtcDRXUEdVeUs0bjIzZUEzR1p3NzZObGdJZVF0K3A4SmNxb1Z6QktK?=
 =?utf-8?B?ZzhFTVpkZzNlc3djNFZHemlMbDlVZDNwdzM5N28rekxHbnNVOXRUWEl4ZTZI?=
 =?utf-8?B?VW9CNkRLOEltKy9jcC8zVzRiK1VGcWw1Y09mR0tRanlqY3ptbi93OHRENGZO?=
 =?utf-8?B?Z0NpTG5MUTRxeGFwL3EvZmNqeDJqazdKNWdXOVBzc3pXLzhPSTArZjV4UitT?=
 =?utf-8?B?OVlDaFZ1TWEvS1J4Tk1VeWM4cnJQK3NtVnJyUTRnMWtFTGN5S3gxQlBKMVY5?=
 =?utf-8?B?NitDMkxZamFGWjJaTkJOc05rNnk2RE9qbzdTaUlubG15UGY0U0taYitzaE03?=
 =?utf-8?B?amZUS2ovWTlWMFA1MkdybTVPdzZXVU96bzlFL3VTWXI4OU5WamdKdmdsTFFD?=
 =?utf-8?B?SFV3emExWHdZM2FTTGdtaU5GYTk0Z0ZobDZIZU5rNUg1dElyd3JtclJXYnNP?=
 =?utf-8?B?S0VGWDNDU0RsdG9pb2kwMmlEdjFkTlE5N0VwR20zeEJSRWQ2dUNMbUdwNDE3?=
 =?utf-8?B?R2FPQTNiK1hNTUovV0pwckx5ckVZUnJJUHI2YlBIcFMrSCtNREV4WWt4VmhO?=
 =?utf-8?B?bmcySkRnSUpHZysxNS9lOGNHRmY1Vjc5aUI0MXBGaStySDZvejdnMkFiS0Vn?=
 =?utf-8?B?L1NMUno1d0RaSkJmaG9mb3NsbjNmUndIQVYzNUdEcEhpTEFCcHg3ZERLVDdt?=
 =?utf-8?B?d283bFMxQjQ3M01LNjNMZisxUXl1VE4ydE9XNGNQdU1UUDNQbXp4QWdKMTVQ?=
 =?utf-8?B?REJ4V2ZGVmhld2dvM1ZNdjhFK3JkU2ZVbm1LZ1FCeW9vSXFaclFrMXJWaWJt?=
 =?utf-8?B?dmVjcVQ1VDdrZnJMTDhBS2ZHbUhFZFY1NU1Ca2NNTDRnaXNiVjBLYmtVQjFZ?=
 =?utf-8?B?WXE0UkVyZ1FITGJINTlhNXhZby90Qzh1dEMrb3dDYjJHbEJJTWtOalgzTjFZ?=
 =?utf-8?B?RzN4MVRTYS9kdGV6VGxuVk9SVEtyQlJ3NHBWZWIwM0VKZVN2M2RLL0NwWGc0?=
 =?utf-8?B?Nm9IVjMrK1BlUUN0VHJFLzFqRU5rZmpvTndaN3ZIeWVXZFY3RzFvWWo3MnJF?=
 =?utf-8?B?SDNia0QzeTVnR0ZTRGF3K05VU0pFNTNkaEx4M0dpL2lKOFNyaitjY1lrTkVk?=
 =?utf-8?B?Ym42SHB0L0k4aVpsNmVuWXlkaWwxcXJiVFZkYjgrSXZ5YzBhUUdyU2w2VEFO?=
 =?utf-8?B?eC9WSy9IMkRZWjNWd1d5NExqZlpHL1BCYTFFQWdiTHMxRGY5YVFGWWQ1ZlR0?=
 =?utf-8?B?cjNLNVY4WDNJVlB0WUlTUW1mczVOYnlZV3FmU3Fpa1FKNG0wZVBiaW1UQmJS?=
 =?utf-8?B?eVJKOHZ1MzBidG9YdXd5M2VyMUo3UTE4eGdYWVlrMFVnUGlSNTFmNFJsbVpw?=
 =?utf-8?B?TnFKTTZOYUNPMVZESUpSdUw4bDJLTFJJbzBHN3UrQTRMS0l4MzdVbFE0SVN5?=
 =?utf-8?B?MXJheTBnN0ZJc0ZVK3BwMDFGUlNOb0dyUXAvRUx6TjhVTmpWWjBFalFudmVJ?=
 =?utf-8?B?ck5YclE3UldhdVFjMk16MDkwT1Bwc0Q5MGFML25wN1Y3K2FmZ0xFc1FJdlhP?=
 =?utf-8?B?YzJxOHJiZEJxdGZFWS9Iekg1L0NuOGVvZ010QmdiWEZtL3BXUm5zU1E0YmJK?=
 =?utf-8?B?RE9LU2ZDcEZ4VXVhUzFSUHRnbzJvdUJHejNOSXMybFhBYVM3MXU1S3V6emkz?=
 =?utf-8?B?MG5mSjBCRnFGYVRFQmVkYll6RDZqQUdoeWZUak9hOEQ5eXNnZmpiYWNYR0RK?=
 =?utf-8?B?aVkya1dBNXZJSmlGTno3NFZVZGlTZjBuYnZkWGdYLzNkdFNEUjRlb1p6c3Yz?=
 =?utf-8?B?MlpCdklZVlk4WDJjYXhMbzV1VUFZcUUwNVIrYk9RQVpPWlgvZnZaK04rUmN6?=
 =?utf-8?B?V1BGUWdZYW1QelVkeGkzWTlPWThMN3lnbGk5NVRFdDV4SFJaVmFtRktOZXRm?=
 =?utf-8?B?d2FDWDc1L1NsNEQwNmJBNlcvUm95UEFVeFBuekJpRWlTcHBCUUxRcGszK255?=
 =?utf-8?B?b1NSSmg5VmFibWxVSElUNThlL3p6WCtSYjRBbit6NlUwM0ljYXI1UE9vUG1l?=
 =?utf-8?B?dDlYSm15YVhBR2lWRjJIdDE3T3NiOGZCck9qUVBwM2pEUTQwM1F5S25iYTFh?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: isFYu3rdL8KfdS3+xQVoHZAmeQI0TbCmDqSNVc3LmPyKMvpVm3HjgukOj7/6k7A7yNbvSKaCojcP2AZnOwcoSNu3vf4SEO5zO4rN6ECLIJ+Y0TU4SNN9HhUM2H//8K+rI32rUE5IzhXF14RNK6N2yak2UlmvWbpTq0v4hSgvRcDdrgPulzNlIKT+zjObiFYci5Rf+I6soo6mNpn6/xhESlstESi9QZJLIrBBeRkLO3ZQNLXaIrCH1Oa8+sPNPOv3Nfip1YN2tvxtlYprjYAKEKZxRxr1K+lu3xQPZ535WwtHcgDFIboNDodWrAI9JrEN8Ft8Gj9g9pQU0e80hkWCPCqKZcBhQkO1omEUMZaqMdbM43qG5Z7tTlHZkV5vSK+5qpPJijT7nDIg4o2NddR6tQ8z5Ev15HHVWK8/bqw01AOYqWH78ILMcnxz/RwcIrnp9SIvYdT76KfOsCheSDSDrJrSX6VlFUaL0RuusoAPgFJY7bbtyDXDA13aIcqRKpkfbFZWs0+KRgJkBcefiTUOu2fqgh7LA1pUzDFQjOzAO712mkKEmi6eCzam5LGBtENqjLmUF2sWyaC/i7shtaTrT2pv0KU/S2OxXRMzVcb2gyMOYtyMAUP9HOE+uZnN1w4zlPGAQESEb8IrQz0fh8iHDWYyt+12VsNRf4JQn0V/eF9FJMrERtq9YvsLyh8sXh9ClIylEpOyMHCD3HVjd3S9rpC46CABJDHlsme+pnCMo2XqYvk0SKi2w+FfbxXqUfac4W7yZCkSCJGc4tNfFA+jvmS0MVHg2Aoo6eKS20i/sGjUwyE0Z+G6bD09xcwAG/SKkBb+lzaRWUXCzkQ3+xH6PPahcvV13z0xXFpxUrLURYXwyIkOwM3sCKr8WFr+xBZJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9832ce1-899e-4d8d-77b9-08db25b1a948
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 00:01:58.4313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t9BEKYKUdeROylRoQNDfH1RYOO1OQrNfRrNjpkdU/p+9S6DenEwrQtk3Vxu/KfjuYyQImOiYnPKDYw9rM5MVAs0vJ6dyMEdiyKtwh/Ed9yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_12,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=892
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303150196
X-Proofpoint-GUID: AcS35wNHv5DIWXVyN755liCdOun64vlN
X-Proofpoint-ORIG-GUID: AcS35wNHv5DIWXVyN755liCdOun64vlN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/23 5:54 PM, Mike Christie wrote:
> However, are you saying that just adding the check is putting it on LIO core?
> If so, we can always call check_stop_free in transport_cmd_check_stop_to_fabric.
> The fabric driver's release_cmd then has to figure out what needs to be cleaned
> up then. I can make that work. It's more complicated than just what I wrote
> because of how isert handles failed cmds and tmrs, but it's doable.

I missed the point of your mail before. CMD_T_STOP sucks so don't replicate it
with another bit :) Agree with that :)

I'll work on a patch like I described above.
