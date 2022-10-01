Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD9DC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Oct 2022 09:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJAJXG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJAJXB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2022 05:23:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EAE16F872
        for <linux-scsi@vger.kernel.org>; Sat,  1 Oct 2022 02:22:58 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2912rf07008260;
        Sat, 1 Oct 2022 09:22:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=RCAIorK38GCntLk01wfr9cH1y/zuXzQ5FLsr5XARMlQ=;
 b=uBbhbcWmFSUu3mywIdE0OQozcSCMf2yu7W/ZwTxphJzRrCNPiA8aMCsjFT7aVtnf3Ib4
 WOKZifeuv9U4QShaOn+I+dENwgf8lLGKbYIR6hRasHxdIeBGbuPux0ML3Zj+63EZx+XF
 KvCgi3g2AiRu9zRkdIl32DtFtS5loEaA9QoQxo9dY2LgqDW3Gf3nRLn6ym8cHTpbBX+E
 zh0pMz+f9XyY0kqxvP+guk2uWk8gd09T6TZpNp+L3V+DhKlNnISwKGYnM1NP0bn7bqj9
 AdYNNT+3GKXHzVLoI+4nv/VJzpFa7MubjbFl2FSO3b7xSvhQbeQi6u3nRiLdfd3M+VHV OQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5t8dbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:22:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2918hCUe033837;
        Sat, 1 Oct 2022 09:22:50 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc01nq86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:22:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWE0PTbPr9j5yPT4kYNmt9rGCfVulSDq9pMYEH7I8qs9dtk+eptT/VtHhMEDAwydtSu+tTfSDupe9CKmkGoF8hQldgtrhS6uo/1vUEc1AyZYpXsr7hPZb5Ro/dCa7K7yyFdZNsdtGqBlXVDwQjgvhDccPIMC7UkaNGd7DEkG18T0/oeAmOJGXypvyFLkhCWL6qteGOr4UXeml+yq6Upi8TZnAt7CE+doy/VJWGRqh2x2LWb1pXvS1caXpNrOH2/r+jMrfS5oOWyOEYlTk3Z3UOWT8ad7QkkpxWiQEMy3f+h1RGM+KvnE56URmgGJqF9e86y2lHXdylJLDdr6sDVyjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCAIorK38GCntLk01wfr9cH1y/zuXzQ5FLsr5XARMlQ=;
 b=lg1acUkCiD+yEN0S/RglqqgnazfcQ2JKxt3Fq0v2YqlZe/XDs28e6YDJkPYKMpLW5Rd8vIKHXqHk8nsm0u7VehKrcjeyrgkpoAAbdCbGH5H6Vi70NMTZiIaKy9IkbX9aKlGZX8oY6PRz0lnj5mhBCwrfTn2bDe9JDnHkDd+six91js1mLFGLzCNGQmdxIW/lMxFxKSrRaCPO7lhRBaT4hNvJfFOPdHLi8M+JZ4YTh/9z1XDGdih6hmt8VsD5mz9xRX6lT5IW1yd2tN9NSQIwiIcGj91wju38a9ZFhLIUHrJ+5LyEBq9bGAclV3ZD70rEeoEkolsyteNFL58J9WS3bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCAIorK38GCntLk01wfr9cH1y/zuXzQ5FLsr5XARMlQ=;
 b=cXNncdKRSdIxnS+ZeMzmj4956hP7iD1kfGy9YdvbL4++rH5gFiKG998q3MnZ0NVC4yRX8fbwhIX7FS/RkFLooA7937S0NZX1Gx2NnQVaUl/DStKOO9zV/HFMFL/kBXiCKA8nHPpSs+6ln7GvvDsPJa87SeU7ZnAdys1qRHkKS7M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4409.namprd10.prod.outlook.com (2603:10b6:806:11a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:22:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5676.023; Sat, 1 Oct 2022
 09:22:42 +0000
To:     Guixin Liu <kanie@linux.alibaba.com>
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] scsi: megaraid_sas: some bug fixes and cod cleanup
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lepzlwz5.fsf@ca-mkp.ca.oracle.com>
References: <1663145283-4872-1-git-send-email-kanie@linux.alibaba.com>
Date:   Sat, 01 Oct 2022 05:22:40 -0400
In-Reply-To: <1663145283-4872-1-git-send-email-kanie@linux.alibaba.com>
        (Guixin Liu's message of "Wed, 14 Sep 2022 16:47:58 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:806:d2::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4409:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ce7d6c-9e67-497d-462e-08daa38e7e44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fiiUHLXOQXPbOd/RM3xD7mC2/LVAawHg8pUN2XwMS9/WflIqD9Tn2mew49vP5GECqZk+7Pm07csPGBwkKL/YlFPzE29lH7rVhTFVFxfXdGn+yORantKOoPiUsrrttyB/nPlGYc4F5OS3EOu+zRPcR8GXPHgSWlBIrcD7YI4EwJWHWlhVD14ECq+NuH6sTxHIFOQON1r9KAJDHdUuDuFqImV8jI67Z9oJzsLPJabx4C52Bt4ThhO1mJv5SJgtyMlUmbs0rQiwb/lsOKMRVTZC1U5PZdM0k/aYyjYLXTKaW59cXO5LrHiV7Jcn8jPVYhyQ14/PyyXc7S5FDezCTuS9dFZCwwc4pTOQ3BTjs/IY2OPTNHuXy6ilEVZffQRtTNc7OlOJs/vHU8+jFRdoKhA6k+lD/cWsMJwTI22xqaYo++oEYAFlyWkmkGsq26Opmk+/Ajbn9qs6kC2u5kG7mhYicEMrnlOHjB+UoGTXpJaYYh7XI8Kz+bq5ISyBIAhqetuhsbiOaWOxDy9/+/PkILuLSp9QhjKrNru9jZ//aRsmVR9eGg8SCWK0lBtLpFPg/tBFK6zX7eBvmcDOdCEGmDLEhqIpD4xT3US3V2KKHP9WzTAcroui3KnTwCOilmJvgupUYCWDasWK8t1Nm7stZpGiy3MjzFefDV9cO1ikrqbbDsSn1Gva30cuM3Cyqfo06z/03idb2R4Yhjgc43Zi16a33Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199015)(8676002)(316002)(478600001)(6916009)(2906002)(4326008)(6486002)(86362001)(41300700001)(38100700002)(6506007)(36916002)(8936002)(5660300002)(4744005)(6512007)(26005)(186003)(66476007)(66946007)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EK/WNCKm/1TXMJE0jej3wKttPUO6eZflAaQVpNLe3jpLrfg1T8azGZ/bJMye?=
 =?us-ascii?Q?I6SSpEKaJ7hLWbX7Mz1NMkyhQYSCiHLvJzZavEc2hK3ALoL+Tj2rX4nRCxhm?=
 =?us-ascii?Q?ilvj5DXzbPXGPUMv2G/BvnVB89jfcONJ6T1+Kdko2DyZ8MhkopcD2nBwrAnS?=
 =?us-ascii?Q?7CokghUbLwIQFdH9kxKuRJDAvn3jOgNLXqpHGPYo+QbcNe9EcyeMi0S+d2N2?=
 =?us-ascii?Q?lVL7r+RZGDUI6vtXbq/OS3MujKOe9bJjWg7+gsBFAeE7ZtubadELBXacBBic?=
 =?us-ascii?Q?Z6jcZTuPnopKer3eI92tjs/atn51xMq9nRvi/vFFKCxAj/+IT528EYCJUCpN?=
 =?us-ascii?Q?1JIvH/HJHyOE+E5obWQ7QpR9yxNLOZ6HE6gVF9+2PizuHAbiXy9HerKp2ZJM?=
 =?us-ascii?Q?3j01vKoEpxvRqWz99FjkZkmbwJNgg/GvMikE4B3dD9i4w5wMgTEDjx+u2tGY?=
 =?us-ascii?Q?G0aTwarS0QpmsAI3SjvBshfeSscvihg3tkcsV2KSDZQELRrEuTfSlSsAz5aM?=
 =?us-ascii?Q?rO3mokQT/661TCA8OGI/adhuWd9QNlxmxamu0L5h6lhEwr4yemr0cPmS609F?=
 =?us-ascii?Q?q3rndb3AGPW3CslzQNZDbLOiQDh3wIPq57uf/93vAgcEuJ/iuRA1yWIj8rYT?=
 =?us-ascii?Q?ZApeA+uiqB4Yf5OyAgjw9xezcZZdPqkpK+UuE+GeEy4KVvz/Qcek2QYyiYpn?=
 =?us-ascii?Q?rGJiLnHhHT9BnMirGpr4s2+kOomNQfi+7A3hjWoAt1wI9nOGKdh0mTtj62ln?=
 =?us-ascii?Q?MxQVHgB/ZaS4TKSbuRoaboOtG3qTkZAmIphABWZoYM2jU8DD2Rih97RKD5ZR?=
 =?us-ascii?Q?UejJgFU0VkSQXFnWm3kuQK6ERPMLgc6bPwrJqmXGthcSnrykG4LrbpLchEn1?=
 =?us-ascii?Q?ZIp2NcwiGn4VONsxt96JrsGdy8NjxOLURWh4iulbNjmh5CSmRRY+0/Dll42E?=
 =?us-ascii?Q?E5mUkXnu9kzo+xWg1bUsv74i/7TIk+mqNbOMReoFslM5ZQxxwPxMDKV+OlAC?=
 =?us-ascii?Q?GJc/keAEZv+OvyLpQ111V/ZcZ7EmA9c4ww0inINnb6attrxiozK8+phr077r?=
 =?us-ascii?Q?1gomYICeTaX17fpKiRuTga4lefiFYhOdjwnn9rS0CW1DD8WZt28SELYf/kAO?=
 =?us-ascii?Q?UKcxa/mfChSB0ZBWHvGnoimQ8VZ03jQlTFOX8Q/vJtt7NnAfjsY14LO+PkVS?=
 =?us-ascii?Q?2Ar9SuUQbgDV9AGg4iBv1YiyiQD3UHva4RJ1f0WTFfY2UuvIXOEbIbWRtEiO?=
 =?us-ascii?Q?gi7oZjg6WfYPDm70vTfkEA4WmI23YY/X6RweHZZLYrT3YO1SVqkPsyHgsTk/?=
 =?us-ascii?Q?opPVG2D2tNyxPyEOdK4URrRpDVLlaZCxek0fUGhjNGIqtAA+KSd89ruiL5rL?=
 =?us-ascii?Q?LtwnQ05O8aoC1g/B+Xb5oxFTPbmleo74qBbzByshqUpT2XZtxM9znaoPSM8j?=
 =?us-ascii?Q?WACdI/S1ctykG+jh7jACOhZ6rcK9zz0hHE3nUdvxYX/tS+7Ju4n7mykbcNcp?=
 =?us-ascii?Q?njQGzRdliQirV1dotA9cNgZ0p3OyxkgL7tna1OHGGDKJNF+jmtYN5A3gvxE2?=
 =?us-ascii?Q?I/CFTEvzu5v2rjuffFH4xLtVmT2y2z9nWO+EEexhKh3Rq8Yd/H+Clfx12eFn?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ce7d6c-9e67-497d-462e-08daa38e7e44
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:22:42.8536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILGjosqHz8BSYoXw4/uzVS4AfhbhlDbJjiLazZGIzGNRErxt6Vm2JzrwPuLKYaCeyXuXalmt62tFiMBgIIA0zQ2Ujk6mzeTjsD9Z8SRFv8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4409
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=945 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210010058
X-Proofpoint-ORIG-GUID: YnF865IxC1uxjdluGvoRRMDIA596EG7K
X-Proofpoint-GUID: YnF865IxC1uxjdluGvoRRMDIA596EG7K
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guixin,

> Guixin Liu (5):
>   scsi: megaraid_sas: correct the parameter of scsi_device_lookup
>   scsi: megaraid_sas: correct an error message
>   scsi: megaraid_sas: simplify the megasas_update_device_list
>   scsi: megaraid_sas: remove unnecessary memset
>   scsi: megaraid_sas: move megasas_dbg_lvl init to megasas_init

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
