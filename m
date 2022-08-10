Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43894C25B07
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 17:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiHJRHC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Aug 2022 13:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbiHJRHB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2022 13:07:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A40661D51
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 10:06:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AG8tpR003753;
        Wed, 10 Aug 2022 17:06:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=v4jl6MckoE0ZNMoThSgQw1LmvUMQYKG7rEE7q43Osn0=;
 b=IJKIpkofGDr3zFveELDrlTsFASq7mZMd37+M4xzoMEqmvnCBMxMrNJY5sHKYgr75VWMs
 LX0NNcFS5n62Ba23BVfJjULac2VosHE5//Oinqt3Z6/hv1woRMpc4cElXz6Hh3AgrBnx
 TeSOw9Dt65HbGP0f1ovs8SvyLS+koABMQTVLpfyd8uNa47mi1LxBzBPBPJilqDMtg5Ie
 qufjpW1rsgqryIti2jyjLarClyEbgQw2yZOIdhqk42WCJm/Zuq/q1FuC2gMgI8oahKrj
 BA8JWf5XS+gRYwt7ZzuOrQ3PSh/Nv80GrO3mZBCdpRBE+400aDgs7aMExjdzAOED6Diy Ug== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbjn1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 17:06:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27AEwGKs015464;
        Wed, 10 Aug 2022 17:06:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqjat4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 17:06:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHtBHc82m0wtW3b/F2Vyh6447ShzB8H6PHi6D9Y0otNqeGXbi1dVyhfGgu+DiLba3sYHd64LX9mY6UBp8HxeqpdhTA6tQdJR+g4BqFsavlrDwkrttV1ZAGOxlD3wDkYUsBetylTQo03ndDdzEI/nIvtBO5Y1J+0+QshR647CoF/lQgwTLlx8QdV8peE9FSvV1JPl0+H6r6+W/RYHM5ZnTreiLOhYVK31ET+BOcBCHM1wAft7b1gRyAyy0yIqEN8tq3xmBGkpFj2ZXpvV1Qv6WpSCmlhC5I1zPbwQEgpYeIMCvQAh5NgyZiEjxHa7kG9IGUBHXl/E9y9Czj6DIDM+Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4jl6MckoE0ZNMoThSgQw1LmvUMQYKG7rEE7q43Osn0=;
 b=E4Cw+ZnYrXthLFHUnR6I/lEUtc1lNITQuNX6HnRAYjPdg9YiH/+VGdmYIlTcrwo8uIQK4OOj7OLiGnvkV5aHGVqtm2NZYJ38DfTXr9yyGZsK3mCFtLfMczpOuciwuEe3YKuq8tC7vBXA6KnfrTxw8N1Wi8on6BPsGWhknHxrsBePKdqtUZVyaBkio+TD1ovxW3Omiw/YhDaNSYMW8uRe+bk9111gQGxsAo23+htv6Dn2IG5FSmjzK2A6Z10wZXmhsqB75E/uc2uOyFRx74HIZ7JXMFe8MryCLGwVWS4o28pZJZid1C3H7CE5L/6n00/Oh0VXOIGi2CNRk0dUHy06yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4jl6MckoE0ZNMoThSgQw1LmvUMQYKG7rEE7q43Osn0=;
 b=vF1M3wzm02OIA2ze3JGO1XCLPQSIam44YslHAFcnBcAKSxibOvlAkpABFZHhjCOV2ZiHEafzA9tbFO0h8yIfLn/R7+mZoGzmyP76+5Y4O8kZlV14MEjVFNbe418a+dAbhTINkgoNdccFg7hro7aoYZSwEKnMvrgasto7gfXDnfE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5804.namprd10.prod.outlook.com (2603:10b6:a03:428::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 17:06:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 17:06:43 +0000
Message-ID: <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com>
Date:   Wed, 10 Aug 2022 12:06:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 3/4] scsi: Internally retry scsi_execute commands
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Hannes Reinecke <Hannes.Reinecke@suse.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
 <20220810034155.20744-4-michael.christie@oracle.com>
 <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR05CA0033.namprd05.prod.outlook.com (2603:10b6:610::46)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2d9e35a-1498-4636-50b0-08da7af2b2fe
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5804:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0ow7zpG3USL+W2AAoEeTF1pnkRRKiDavljPc3mW3ve2yw1lghSeQnf32NKYq38g60wC5LGVFkNncTFIaf70P9cAPgD5gzCqtbJT6+PH3JEyKafkBrAKmxkV/JEL5Gy5QmzZB9gKQH71yPpzERtRBmEFpEzZvgSh3ap+uEfp3MQ/khK9g8i/FnNKzHgOoTLW99Yf64YyVNQI+xhWbDBbqC5RjweMGlLiSqO8Wn7caTql0+3DRQx3qgExpisDiN3MwM2ZwWffvrE5qCp05eNfZ2KAemBnKpGPNTwKIT8nCaj56GRk0ZKxuRPB2Y8MSv6HaekQyHMF4VHqE9ku3XgBWJaRyA0wLiTfs7b1ouDSbajAdVw0QBQrxfYjQBc4GXtDekUAh9kpMwtRLVwphihlCne3iLN6bVTuIMFM22wk4O5U+2/5sBmNdgcQ/dfmaYcSz4j2v+RnKaTXOqnb3L/apE7+YEIWO9M/sEZgKF+XIceEgaTPCDU0StNrYAPMHPC2vIdfJIcIbAYk0PsgOrnWy9erq3TZdL4EfwCDDgcCvCM1buS6dWUl4jH1Io2po+FF17mCjxSxtddGrcJCs5WOs5vR3yB5s112bHTV3EhFpJTyZwLknVl0Mmw14j3S8c6U1gMiGWRpMixOisH1Che/1JMfWJcYuw/oE3mq8c3hF0WB3pszRIxJmoZT3HOSdxaQ7yLyjZgTVfz2dhjw3kpua3URrozKdJZXm7hYdQ17TKI1rVdP3gxBgRgvHE7e7Q53tkNyrFS3jgBm+W1Mow3kgWURx/UrTAYQzX+mrp3Zwy6etPSQhD9ICdbsCusLmDUTiNVUXngBwL8mWHlGHgYWTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39860400002)(396003)(346002)(376002)(6486002)(2906002)(478600001)(41300700001)(31696002)(86362001)(36756003)(31686004)(316002)(2616005)(38100700002)(83380400001)(6506007)(6512007)(186003)(53546011)(4326008)(8936002)(8676002)(66946007)(5660300002)(66476007)(66556008)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDJhcWRHN0dTYWlnZG5Kd3VXd1JnOExwL2hCYWI5QzdKMUhCWkVlTjVEZWNh?=
 =?utf-8?B?UlEwWldLRWtNRldIdnhuVERLZFc4RkxtL0lUWVN2OHBlZEhIakdTaGZUV2xh?=
 =?utf-8?B?RjFhL1FIN0ZqR2xWS3JzajV4TmVuTityRUIzWHJKWmRxSFBDZHhZM1NacVhW?=
 =?utf-8?B?dE9POWt0RTArcW1aY2cyeW0xVERWbUIwdm9aamNKMHc3dEpxdUk5YTJwYWFS?=
 =?utf-8?B?V090MFI4MDM5bHpRdkdUWDVoaTFpWVI0NVdJOU1sd1B1S084YTR2M2JUMzdN?=
 =?utf-8?B?eENPWHFxa1lyV0IxYnBXS1hmRVJsNTBJOEVReCtKNVJqQXdLTlUzOTdDREl1?=
 =?utf-8?B?YXV5UXpEZ0ZBM0MyOC9XOEVpdzFPWkM0cmRWMGh0dll3Y2w5b3FJQ1FmWm5i?=
 =?utf-8?B?VjNLL1BCcGhlMHdGTURiRXgvUWU0RkJUTEJCUGJxOWZEQ1JwUll2blFPSXd1?=
 =?utf-8?B?TEZrOUx3dkdnLzl6K1I2c1dsSDBOL2h1TGlUR2hoeDNsZzdBcEJVdVNLMHp2?=
 =?utf-8?B?TXZDMXdlbmxiTFVpQ3NYbk40cXRRVkwwTmM0YXRYbFcxUnY1MlVIZWFlZDMz?=
 =?utf-8?B?SWhFTUFsdUswMTNUK21aU1BERUtDMTIxcml1N1hyeGRKcXpzMHJCY3U4L0dZ?=
 =?utf-8?B?dVA3SFRvT0ovdlZYVGpoWWhEMDhFTzJhYk9PK253dmkvbnlpZU5wYS9UR2Y3?=
 =?utf-8?B?bW54RUlBRXA3SWVjWXlXblgzckh6TEw0RHd1N3owRWUwMGtReWc4M0N4NDFl?=
 =?utf-8?B?Zk5kTE5XMm5kU3N4RmxSVWhWYUxBRm43OFE3d1RmTzAwbnBDL0hFcDdWYjdF?=
 =?utf-8?B?dVlUV09uaDQ4dE1wa0cycXJrYy82NDRFL05DRDFubVNBWlczcUNHaTlMUUla?=
 =?utf-8?B?WGoyUjBzUUtxTlNXU3JQUHVkTS9TZmdPVWc5Wko0VXdsOTF0cE83ejRnU2VC?=
 =?utf-8?B?QU01am9DOWorbzJrenBXdWZRSWdDL2RweERwcGZ2RDN2SVZIMlVhejQra25N?=
 =?utf-8?B?MmxUOWtPdTFsdXhLNGJLL0RyK0E5d1ZCRHp6U0pLSmdUeEc4Y3A5SUNZWkpE?=
 =?utf-8?B?MjljM2xIWW1ObVFyVUd3THhQdndRbVhCTWg5ZUtNY2xRalBVTVE2Wnh2NTUx?=
 =?utf-8?B?UmlLZXJYemNhTXcxVHBzTFZ2OHk5NVNVcGRHV2NvcEUyQzhNRVpoQWdmdWI0?=
 =?utf-8?B?cXJjeXdRRm9EeUFSb0R6L3FwRENSb2dsdTY2OVh6Q3pqb3ArbWZHQXZLcFd0?=
 =?utf-8?B?ZW44ZFV0K29pZXkzZFNBYVloME4xbnJVL3g2czluYXNMWjBuWDJubnhxZEFF?=
 =?utf-8?B?am93alJtNS9wMytGY2FuZjdza0pvTldESy8wek5iVEF1dFJ3ZXNMMkFQeUd2?=
 =?utf-8?B?T0J0eUtsZnI0REMrdVFDVnFtbWluekptOGJqQUZQVUI4WkJSYjhObFFSY09S?=
 =?utf-8?B?WTZ2dlN0U0xNTC9QTXo1ZXN4dm9NbExiNHVYaXN6M3VXc1VVdVRqTGFIeHUv?=
 =?utf-8?B?eXRGMDFCNUIxS1U1QUdyOEZTT0hVMVZNbWloQzNmeVVyZGF5TllnUFJ5WGdn?=
 =?utf-8?B?MmtZMkg1bTNJNFZGTU1lRDBpMXRZc2c1MzIxdkRhU1RMWkxoUGd4b25HR3pR?=
 =?utf-8?B?VXRoT0xYSG1Cd1BCSjY2VUUwcm9aemdWT0JoNkhOSENBcXVENUwxclhXTWxl?=
 =?utf-8?B?NUJMTUdQY09xdXYvZTlPaDhaU0NjVjRYSjJVa2tSTXR2KzJxelhxcXg0bHNj?=
 =?utf-8?B?eFB3TXZiZjluT0I4VlpCTTFtQXYxdVlZWURhZ0Q4WENWU0laSnZZeWo5d1JU?=
 =?utf-8?B?NXdLMkg5WXhzUVFPVnVLU1IxVndQUTJsT1prZVBkSHZvVEJuQ1EwWFN5Wlhk?=
 =?utf-8?B?RU9JaXdUS1p6L1dORGNseFRBOTdZeVYzTkYxS0JGcDk5VnVSNVVPSUczeENy?=
 =?utf-8?B?ZEV0T253d2RkWTk0QVVPRlNEUVc5UkNOUlpucDE2NDdwaXBHMTZ6TTk1ZU81?=
 =?utf-8?B?czNvUnlNc0tsTG9LazNlM2h6RWF4TjBHS05vNUtKSFVQRk82dTJHbWNPRVJo?=
 =?utf-8?B?dWRZT2piQk12N08yZlkzeWhUZGlaV3lDVnhvYm13UUpLWHBDZ0dFcEU3QWxs?=
 =?utf-8?B?S1hkaFBGVWJ6Sm9pQ1pnamo5bUpWWjc2czNmY2Y0TEhGdFl3bXZOSUcxZ09l?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?a1k2OTdJZjU3ZEo2WTdzd0YxQTNxRUw2czVTODhidGx2cDdaQk9tMDdqZGlJ?=
 =?utf-8?B?UWtKN0h6Rkoxc0RFU0xYSk4yZElxeUZ0WG93MUNzZDJCVHByV3hOSDM0Q3E1?=
 =?utf-8?B?ZVNaN3E5SnNKUW9pclVGNDJmSGlHSHFUS0xiTmxJeGVHVXZ4YjZYNEx2VDNS?=
 =?utf-8?B?bGUyRTdKaHlLMWd3MVdlUFkrdEJWaWMxQjNPazA0bjc1bHV6YmdDS1VUeFM3?=
 =?utf-8?B?a1BadDdFUUJTQ2UzeVlEU3RNMmVTaUZyWW0zTXJJbkRaemJtWm8wU2J5MzVJ?=
 =?utf-8?B?eXFWTm5tNjZzdXk2bWpzQjEzbkxFaFBLZU9XakI2UmFRQnNCejBxS1BBdFdm?=
 =?utf-8?B?Wnh5THIvaHZKcXFOK3lFSEtoOVo1REFuSHZSUVBOM0RUZ1VZa2tJMHlWQXN0?=
 =?utf-8?B?TGU4cXlWcjl0Q1ZKcW9YQ1pyTkdnejlRbi94WGdYalNoRURJemg4NUYyNjA5?=
 =?utf-8?B?NVMyT2hoMFFEb1ZJNzQyaHNXVDM0SWJ4UHZham4zYnZVWm05TDRJVzhLa1BJ?=
 =?utf-8?B?WG9JaXB6NTh1UE83d3dWa3JNZUtmQXpnNE1PWEFjbEpKVS9QMVQvUjhJZVAz?=
 =?utf-8?B?M0E0aDVsUkFvY0p0Z08xcnBUc2hjc3VtT29VcXVMcTFpakNjUUJBYStLeW42?=
 =?utf-8?B?S0x5azE0UzdFSW1ZdnA2WWFES1dvbDRHRUlDSlNueHQwOFIrMlpOangwcjdz?=
 =?utf-8?B?QzhETEd3dnZvK0tLM1dzYmdwMFVXSXY4YUl4TW9pRHp5MGZTRHFWYnB4MmVB?=
 =?utf-8?B?ZTFqcmNNbTUvNmdMbEZyaDBEQi8zOWo3ZmJpRFgrM3RNMXFoRm5WUmZIYUVi?=
 =?utf-8?B?NlU1VXlkYmFBdkZ1UlBHR2NMYVBoM1FuZUJxVUdUanBtVHBFbHlrdmloUFIw?=
 =?utf-8?B?TmdUbkNqbFBHWXgyWmJFV0FGR3AyZGtGMEtCRnByRnJ5R1l6T0ROSk9Kd05r?=
 =?utf-8?B?RzVOTjRnTkJLNHh1Umx5WEZKbWE4dzdaVjk0RVNleFRiQVpnbGFUMUdkS0Np?=
 =?utf-8?B?d255SWMxU1N2dVhTdXgrOFFYc3E5bDNMdGV5cmdqOHpKRVdaRnhwbkhSbVZI?=
 =?utf-8?B?S2Zkclc4d3dzazJvWFZEa3ZTNzQyTGh3cmUvdWhFZUFLeTVneXlSZWNKQjJm?=
 =?utf-8?B?cTZ6d2c0elptNlRTZzluekRBWGROUVZYblBJQjB1WXgrcnRCUnRUaENNeEw1?=
 =?utf-8?B?VzR2TU5wYys3UTdIVGtKUzhkd1hrUG91U3ZWK2FWNkVUS2s1N203b0dUSi94?=
 =?utf-8?B?Ujdxb2NjaVpQdjRJd2RER2dZakk4Mm03WmxnaXFIWFBDU1J1ZmRaOFgwMnVP?=
 =?utf-8?Q?wVuEV8AG473ubOdGyQ6nzWI3W9a6dGtd/o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d9e35a-1498-4636-50b0-08da7af2b2fe
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 17:06:43.1594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILlx4DAIxdQNGzd6aFgk/Pr7ku9gxKY9XXpd3lGYEkQay7r+hGcd5y5m06Jez4cFEdqC/DbSJd7esQ3ooRcNubb9TaWGEc9tXMQ0xUflCuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5804
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_10,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100052
X-Proofpoint-GUID: L5SE7EWB3WWaVHHh9t1btMae51jcz1E7
X-Proofpoint-ORIG-GUID: L5SE7EWB3WWaVHHh9t1btMae51jcz1E7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/22 5:46 AM, Martin Wilck wrote:
> Hi Mike,
> 
> On Tue, 2022-08-09 at 22:41 -0500, Mike Christie wrote:
>> In several places like LU setup and pr_ops we will hit the noretry
>> code
>> path because we do not retry any passthrough commands that hit device
>> errors even though scsi-ml thinks the command is retryable.
>>
>> This has us only fast fail commands that hit device errors that have
>> been
>> submitted through the block layer directly and not via scsi_execute.
>> This
>> allows SG IO and other users to continue to get fast failures and all
>> device errors returned to them, and scsi_execute users will get their
>> retries they had requested.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> Thanks a lot. I like the general approach, but I am concerned that by
> treating every command sent by scsi_execute() or scsi_execute_req() as
> a retryable command, we may break some callers, or at least modify
> their semantics in unexpected ways. For example, spi_execute(),
> scsi_probe_lun(), scsi_report_lun_scan() currently retry only on UA.
> With this change, these commands will be retried in additional cases,
> without the caller noticing (see 949bf797595fc ("[SCSI] fix command
> retries in spi_transport class"). It isn't obvious to me that this is
> correct in all affected cases. 
Let's make sure we are on the same page, because I might agree with you.
But for possible solutions we need to agree what this patch actually changes.

We currently have 3 places we get retries from:

1. scsi_decide_disposition - For passthrough commands the patch only changes
the behavior when scsi_decide_disposition gets NEED_RETRY, retries < allowed,
and REQ_FAILFAST_DEV is not set.

It's really specific and not as general as I think you thought it was.

2. scsi_io_completion - Passthrough commands are never retried here.

3. scsi_execute users driving retries.

For your examples above:
 
- The scan/probe functions ask for 3 retries and so with patch1 we will now
get 3 x 3 retries for errors that hit #1.

So I agree this is really wrong for DID_TIME_OUT.

- There is no behavior change for spi because it uses REQ_FAILFAST_DEV.

> 
> Note that the retry logic of the mid level may change depending on the
> installed device handler. For example, ALUA devices will endlessly
> retry UA with ASC=29, which some callers explicitly look for.

There is no behavior change with my patch for ASC=29 case, because it
uses ADD_TO_MLQUEUE and we don't run scsi_noretry_cmd for that error.

It could change how 0x04/0x0a is handled because it uses NEEDS_RETRY.
However, scsi_dh_alua uses REQ_FAILFAST_DEV so we do not retry in
scsi_noretry_cmd like before.


> 
> I believe we need to review all callers that have their own retry loop
> and /or error handling logic. This includes sd_spinup_disk(),
> sd_sync_cache(), scsi_test_unit_ready(). SCSI device handlers treat
> some sense keys in special ways, or may retry commands on another
> member of a port group (see alua_rtpg()).

There is no change in behavior for the alua one but agree with the general
comment.

> 
> DID_TIME_OUT is a general concern - no current caller of scsi_execute()
> expects timed-out commands to be retried, and doing so has the
> potential of slowing down operations a lot. I am aware that my recent
> patch changed exactly this for scsi_probe_lun(), but doing the same
> thing for every scsi_execute() invocation sounds at least somewhat
> dangerous.

Agree this patch is wrong:
- With patch1 that fixes scsi_cmnd->allowed we can end up with N and M
DID_TIME_OUT retries and that can get crazy. So agree with that.

- For the general idea of do we always want to retry DID_TIME_OUT, I can
I also see your point.

- After reading your mail and thinking about patch 4, I was thinking that
this is wrong for patch 4 as well. For the pr_ops case we want the opposite
of what you were mentioning in here. I actually want scsi-ml to retry
all UAs for me or allow me to retry all UAs and not just handle the specific
PGR related ones.

I'm not sure where to go from here:

1. Just have the callers drive extra retries like we do now.

I guess I've come around and are ok with this.

With patch1, scsi_cmnd->allowed and scsi_execute works for me, so my
previous comment about scsi_probe_lun needing to retry that case does
not apply since scsi-ml will do it for me.

I do think we need to retry your case in other places though.

2. Instead of trying to make it general for all scsi_execute_users, we can
add SCMD bits for specific cases like DID_TIME_OUT or a SCMD bit that tells
scsi_noretry_cmd to not always fail passthrough commands just because they
are passthrough. It would work the opposite of the FASTFAIL bits where instead
of failing fast, we retry.

I think because the cases scsi_noretry_cmd is used for are really specific cases
(scsi_decide_disposition sees NEEDS_RETRY, retries < allowed, and REQ_FAILFAST_DEV
is not set) that might not be very useful. I'm not sure we want to add a bunch of
cases specific to scsi_execute callers to scsi_check_sense? I don't think we do.


