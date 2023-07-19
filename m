Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DAAEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 14:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjGSOox (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 10:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbjGSOoq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 10:44:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0809A1726
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 07:44:26 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JCxJ4C004367;
        Wed, 19 Jul 2023 14:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vBSvsxGMavkSaiZHoTRLDObjsBdoIVuG8vJnswikalw=;
 b=haGu5BTtVTGbHCBOPsEnmykCyTWVAGDssoWndygzAstwqWRlf+Ge2CYizXDCX8qgSyFc
 1Rd4HVyUFF7XYmGUvpgIKZYwTFdWEa4+H2HP9a7hMTzeb/41yvxEIH0XCfkXHB3H2fes
 b3IpTBjoQN9Phidp+/tYms4UIO1C99HzYlnbNvVjxKUIC6SPUfNiZiKp0fjroqS3Gax5
 eW6xYVGJ6h977JWU9Bbqhpc8Tf6pRgwKYFYjbjXoPiqhYNMQHDnCCA/Hzne+RCEv/Y+c
 9ClmG08kNnUmMO0RWq75dk4V2XleX+Tm4NALslMH7ykE7zkWI9cEg2G5mlUIQBLqRMX1 jw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run787hb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 14:43:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36JDSnNm017337;
        Wed, 19 Jul 2023 14:43:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw6x0k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 14:43:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/xfWhN3T9HSA2TpPJh3TXwyIzDjs6rxbtk8BGF1kkK+NCLgM+o0qdEE1WqdbR2y/B93rTANSS/rMzoW164GDdaUTmX+tKQLIqujtkxoypI/YMlVOY6J3CVE54WRYi2IcLTaOTo3eEGXbz9XPhh34KEGYwxPWBtn7l0K5B9TnG3xzuLrSrsmpuHZtCghPRl58fSIn4QmhZvl9XdNCjsTDU/91C/DF1vQ5h8AocZujVKpeOPSQKu3h+3bFEw2JMMBi7aS1Nzxi6PeP/u6+YGT5CtMj5AKOSb03HoY2jz1mwzA1xfirRofjLkeHAfiUeUDYkxqw1SJPf+fzbvbF27jtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBSvsxGMavkSaiZHoTRLDObjsBdoIVuG8vJnswikalw=;
 b=JrkE8R9yBoSCzUPObkjWZh+0XMu1Djip0jjVAoM4qAnOtivb+maJE+lIvUnWWekyJ0SdBpPaxWJ0ynlyUFwE/SaYavw4lmKqBSw1hoHv/Y8QkZlITsHrRt3msj6QzFzW3eqvphPB3pEYrjNtR3seFY/9f4/0Vdq7ecW+1EnHZUndFeogh7XOeR/S/hlYXcyDni0jXPBDdqEvEuUeDD3car3bociuNbKsFYW6vG2/h/jv778VCPWN1cgw257af6/Wtgm7H3KuPEvA+zZJdTmUvI1F3ufpJSZUM0MpUeEVBlhP+ZEgz38j9b3L+M3qx4QJ6wU1pBzcJkkpQESfmiOkbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBSvsxGMavkSaiZHoTRLDObjsBdoIVuG8vJnswikalw=;
 b=Pk5w3itzDp1vcttJLZEfiTBOvVPCns38vIZlOirlXA4JFqE7MTH4OwHAyysk6OveSG1eEr8+p78zwUClxrJxQnATuTlvAUQh3L0lgtgnY5CEnXkQp+k5U/a+ui3aYXlCwgcOg5APtPgTeC+wZ3b5KXOzspeQLgKCnqLEOVnrbOg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7203.namprd10.prod.outlook.com (2603:10b6:8:f5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.23; Wed, 19 Jul 2023 14:43:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Wed, 19 Jul 2023
 14:43:31 +0000
Message-ID: <ec03b83a-80bd-8f4a-f8e6-3fac94fd390e@oracle.com>
Date:   Wed, 19 Jul 2023 15:43:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 16/33] scsi: spi: Have scsi-ml retry spi_execute
 errors
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-17-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-17-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0024.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7203:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c3392be-5b9a-4cef-c6b1-08db88668564
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PIhHwrad/kudp2edDjX0ekGDCiVXC++qAEgORkSN55qoCYtggIBVNbwchqb1SRRCNx9134rOWB9XxWUwlWSp7Va4zgAtkaMM/YlalKQ63wVnRsoOWtwUg0MgeMUdKPKQt9ZLicExyovjsUj45LxvC7Una8VxobXM/I/gEgHEcN+Q4AC/RhE8hGkPZJVIEAhMaoayImeFuBn6Q0qM7/M0pV6SaAhFGHL7hKBmni8W1UiTz6balxt8tR4aAH7nmC3tuz7wjF9hOW5/S95fvRrQQg/Q2/tDtKfEJB7wPl6tTi+YLvnPlHjQ+WTpdX7FHzAP+1fTVp2JfmfXn1ZC/3f8zUFf76tqAcGLEpZU18gMVivl9OhWaDpTHI44aLLVQ9MTAx0w9xLe+f/F80JjldOXSQR7SahB2p+0s0pXL9Yt80jj0KikHSOlne9lIxb5DYE2mIrgffwL5GnUvsUC1QZp8TKjx0a/h3P9qpZmK7Qboz5g0iKyFE2qFWwreJAM13V9cUqVIuyaSuOjZ8uN6Hy+FEGElazBBouHc9n/WT8/GtyZdxN7dN0qO0UnI+AKOTcz3tI0UEEDTdhMi2+FkG/rq9oo/mUDxdep06Z+vb8J3L67sXolbnrM/9MOeAC5BkRRJPSJLQreKXoj/DwuZDhS2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(376002)(366004)(451199021)(6666004)(6486002)(36916002)(478600001)(8676002)(2906002)(36756003)(8936002)(5660300002)(31696002)(86362001)(66476007)(66556008)(38100700002)(66946007)(41300700001)(316002)(31686004)(26005)(6506007)(53546011)(186003)(83380400001)(2616005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkNOc3NyUC8rdFNBa1RLWkRsTGtmYWpJbTNFQThJSWJCanJ3d1RDbmlkYStD?=
 =?utf-8?B?cm1KeDZZekI3SUdZMnFYY2kvN1JLS1pzeDRQZVdLdFVSbzNyZTFEMzNnaFJM?=
 =?utf-8?B?aWtTUHZSTEdrR0xDa2lFZGFlSTlXNUxUdWZGS094SmxONkw3S2ZRQ1Ntelp1?=
 =?utf-8?B?WG1NaUY2Mkdna2tRc1ZwUkNIL09WbW1tQXJzeWI2dlZpM3dNbWg2cXcrRkRa?=
 =?utf-8?B?YzRLaFBGZUlhb2tkRFFmYmpRTUNScEo3VVJ4WXc1QXl0ZjU2QmQ1MDEwRFV6?=
 =?utf-8?B?ekVQQkJ6UnJyNlJFWEl6VEgyYU9tcHhMdFRlYjlPeDNnYiswZ3hWLytIdHRG?=
 =?utf-8?B?Tm9vMXgrVUkzbTRJTnpJUG9ma1ZEK0pORlMrMGRxdUhrQXhqYnpuc0Z5RUJ5?=
 =?utf-8?B?NEJmSFVSS2JTMUwxNk5KQ0FkcEZSRU1TWXlZaC9uZUZoWFNFbno1N0FDRENq?=
 =?utf-8?B?dUpNSmhaeTZSTHN6Z3J1akRjK0xsbWRmR2lBUElCaTlmR3dBTU1ZakdrUUNC?=
 =?utf-8?B?cnlQaDNVeWs2clA3RW9tZzZqNkVrVjgyaTE2dWJTYzc1bkYvb3hBVXVGZW1X?=
 =?utf-8?B?SzNWYXlUT1NHb1UzWHhBcjYyMHMwQzBjWEUwb3dqQXNVWXBpQW14OHFZRUJJ?=
 =?utf-8?B?WXRMRm5FU1NPdHhyYVhDWGpKZWM5QWpPekJ6M3Y0Uk8zNjR5bTRwaFBNQTRK?=
 =?utf-8?B?TkwvRC9WZVFRWGsxbVpGWVhZNHRqaGlXTWhCR1pNZXR0U1g2QWkyL3N1Q3ZC?=
 =?utf-8?B?VUlmV0s3NTBqWThRcUZoemR5QjBOY3RSUHA2dHprTXNoZGh6U0lJcmhSeW9u?=
 =?utf-8?B?VjNhOWpnMWMrMEFveVVzU2dOcGxBN2k1UmdSTGJMR0FSNkxieWpwV1hwaThn?=
 =?utf-8?B?eWhJNmNpdGtuL2MwYTA3SGMvRjJwZ1luamFlK3dZUXVFMXBNdTRXdEpmRjhw?=
 =?utf-8?B?NWFhQW56QktlUWZzUnJKVTY4dnpNQTVrTXk4bXBNeXZHWlQvTERMMERGQWF2?=
 =?utf-8?B?QVE2TmNTVEkramlCYnNkWEVUYlFNRHd2b1RJVjEyVnpIR0s2VHdwTUJnVndX?=
 =?utf-8?B?blZPSHA5QkJoMmxhUXBRTlNlTFRzVFlPenZiKzZ4aTY5NnNjekdndGRoTEky?=
 =?utf-8?B?SWIxOTlpd0FrMDlYTHgvSjBnaU5XZFFwc0dqNmd3VmhjSHZRZXdVcUNjamJM?=
 =?utf-8?B?STkySVF3YVNnVTFrcFg3dE54RkFSTmJJSElRbkltbUt3QnZvY3pFTm53b3ZX?=
 =?utf-8?B?OUE5MENacnd4d3RaVEJlY2FmczZCQlR4YlU2WHZ3Mm9aUjFMRGcxcy8vRnFh?=
 =?utf-8?B?Mm9QQWxUbUo4Y2gwcmFORUVCNHc3UlNJbGd6RDR1WSt0YzZ6b0ZiOUxGcmcx?=
 =?utf-8?B?a1pObHhvVWZ2dWpDOERqNmFuY2cyT3JvMW10UWNvcnBqdnQ1b2FaemsxQkJu?=
 =?utf-8?B?SnhRSUVnb0NpWHg5bUFVRDF2QkhsMGZ3VkxjNXFRY1ZEM3p3cUo5WDBRR2lV?=
 =?utf-8?B?S3FqMERuMEhwRjZhRmwraHNPbEl5OUdXTFRIK29YYm5HL05WOVVkeWlPaTlN?=
 =?utf-8?B?T1ZQYzBFR0lwVk03Z0RSc0kwbC9BS25rUnNCeGRvbjVDdkY4aDQyYy9lMDRi?=
 =?utf-8?B?MCtpc0VaSFBCanN6ZWpIRUFXSjlNR0JQeWtUUExSdVBiZWxkVGNJZmNMbk1W?=
 =?utf-8?B?aWgra01ERzkzblRscmhLOCtVVGw3bkdIbklja0J1c1VrYm8zeTR0OFpTNlVC?=
 =?utf-8?B?ZEFFVnk3Q2lkT010NTdZTzhRTkszNTZrc1BiWXdGRzZUUkpQbnFwT2liU1Bk?=
 =?utf-8?B?T1F6YkVoVmxOL0ZWZkdXQ1g4YmtUaVI5V2xCWVA1WmFZYW1OYUhZenBWRGht?=
 =?utf-8?B?d2E5TnNMWWJQaktTWUtwSFdsbkxySWVjeXUvY1ZoSUYvbWYzYWV6UHVPa0NB?=
 =?utf-8?B?aFZBWE9xcTN2emhHUTQ4Rm5hbFhEelFJOW0rWEpsa1NudFVRWFNySDQ1c2U3?=
 =?utf-8?B?YWlMMk5qYjdxWlVHa0ZWYnhsVHFMSU9wcitLd3dtbzU4Ym0rdHRGb2VPNm5V?=
 =?utf-8?B?ZEcveEl1RUhKMS9DaStuWGRiTGJHeVcrdlZVYjkrUmJsc2VHdlRaSmQxb084?=
 =?utf-8?Q?L7IiOBOxpg0AQf+mpwGUjipIl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HxJVmbOX+ZE76vNi5AHWzirID7uMOGf8EgpCn2hH9eNgZkqWIvpe4jrjDjLg/0qbyxacqAP6cPwdhjNhR6ppWBpJetSHjwkPtuniOtA/NtCq/DBd3ZNyuLyHZyZdYl9+VvkovbBbZy0FeyC/3A3R8jo2R/85uUoIeGzpJpyV6KfSpCubFZy6ZtuKDqPvoXdKWerLc1uNvrBPwc976dZiftLMFWcdhZ6XaIxLNy68QqrwSaR4cL66QZyodXtswRBz1RAYberpEal83tM0njo1ERJi+GMAFdq1eS2xTlTC4WSAUXdb3DSk4D9M3Cx48QWaLbIvq78PKXGK+ERSq1u1ojp6nR1E0aJVwSDQBLi5/g8PmeHuomXQhMTjajXCKl4YBk/shF/jEQKowYq/pMgvfHnBGoighBqDrORDGaGpVq2/CV89OEJBZLZa5sncaRNdQOz/64qHzEkL3AL4R1KhxX7CcIb8aONRhKGfbPWTi4po4QSLjec1O+zdXBjAF2ogPLCZD8dyaqvysvT6IWIWbqJTOcmLJcJVzoVI1lcg4Z/kAoPzHHlLgEtuQJRaOQE3odbpaez2hJ6exXlQ/GW5SO3IZ5p/6re0/+ObDozt1Z3PMclycN8dDsCgMzHv2Reiw5pj6h0vfAQzEw1pmpDEFsFW02NuZwOP/BVXal8ZkvAPAMJ4nLulRZxUD1Usyzqk0IF3OAlgEO2XkjzI3Dbv70AP8R//TlW/FmV4yOrvn2EpFem5Vv4whHY+Wul0doKtmBc3kxIWlznWY4B68Rpk0AouRU/HvEOResgTI/kv4u+bYePar/mmFj6QcGSSGqg2g0Z+cPLJA0vwTpZA22Clwfyit01BSPx3BSmTZ1KWbSTAUHhNXQ4byP9smycU8ayQ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3392be-5b9a-4cef-c6b1-08db88668564
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2023 14:43:31.1405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/XGyKYsRPPabHcKDGpHYhAwuIhf6jtlhkGyRofS/kqwnRpLQLXvXTJaICDw6PIxOozRR02M5/ngg3a6xihdxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_10,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307190132
X-Proofpoint-ORIG-GUID: NxFnSWgINzrY7cSk7cazrc67fQSG54v7
X-Proofpoint-GUID: NxFnSWgINzrY7cSk7cazrc67fQSG54v7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> This has spi_execute have scsi-ml retry errors instead of driving them.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Just a comment on a comment, below.
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_transport_spi.c | 35 ++++++++++++++++---------------
>   1 file changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
> index f668c1c0a98f..b2f5c1d2b451 100644
> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -108,29 +108,30 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd, >   		       enum req_op op, void *buffer, unsigned int bufflen,
>   		       struct scsi_sense_hdr *sshdr)
>   {
> -	int i, result;
> -	struct scsi_sense_hdr sshdr_tmp;
>   	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
>   			REQ_FAILFAST_DRIVER;
> +	struct scsi_failure failures[] = {
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = SCMD_FAILURE_ASC_ANY,
> +			.ascq = SCMD_FAILURE_ASCQ_ANY,
> +			.allowed = DV_RETRIES,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{}
> +	};
>   	const struct scsi_exec_args exec_args = {
>   		.req_flags = BLK_MQ_REQ_PM,
> -		.sshdr = sshdr ? : &sshdr_tmp,
> +		.sshdr = sshdr,
> +		.failures = failures,
>   	};
>   
> -	sshdr = exec_args.sshdr;
> -
> -	for(i = 0; i < DV_RETRIES; i++) {
> -		/*
> -		 * The purpose of the RQF_PM flag below is to bypass the
> -		 * SDEV_QUIESCE state.
> -		 */
> -		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
> -					  DV_TIMEOUT, 1, &exec_args);
> -		if (result < 0 || !scsi_sense_valid(sshdr) ||
> -		    sshdr->sense_key != UNIT_ATTENTION)
> -			break;
> -	}
> -	return result;
> +	/*
> +	 * The purpose of the RQF_PM flag below is to bypass the
> +	 * SDEV_QUIESCE state.
> +	 */

I guess that this comment has been misplaced since we switched to using 
scsi_exec_args

> +	return scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, DV_TIMEOUT, 1,
> +				&exec_args);



