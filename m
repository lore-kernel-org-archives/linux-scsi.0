Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A99C3DA6F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 02:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbjHYChC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 22:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242100AbjHYCgm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 22:36:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A2A2683
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 19:36:10 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37P2OWWn009080;
        Fri, 25 Aug 2023 02:35:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=akt9THTvmwJqbbott0bXhApR6aRRWMks3GLcZ2uyT1w=;
 b=EZMjdUjVmKWuDelqIqUM6z8CAtwhZD+zUPuh+hZcO6xnjgEqLDq3u2nupHQ9a6vleBNX
 Gu4poOcePumZW9POvDwJ2vN4jbZ1sK3qIzYH32THUS0JujcRUV5Z1oj2QThpjp9/FlrH
 0fFVq2C2lS6qCC9t8tBdFA8zdv+bp5na5R+oQmmkOHvZWK1Cq2RUbqt/fblTaLCKLcFX
 vTQV8PQ3wNA5Ip84k2xOOp/amlAhKZUfmH6Dbro3ATUh7+zlCmKpE/a1w2XLdXqLeLcw
 dmQimfier4E1lECEQVEAjxAeQgkXcsw3KWtEAxnsTaiLV+oX0WqwtzdtnYgpD4rMZ4Oe sg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1ytwfn4-24
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 02:35:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37ONp1rq000941;
        Fri, 25 Aug 2023 02:19:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yu8xcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 02:19:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7uTmc4vHDIHNQMhvpdpYsvF0JBMhhRa5NqX9+KHZwWcRbIN2/c297R7FZCju8QYQLSqTjIIo6ZOQi/QjVDExCfBCAX3TwLFQx++hjTF/4qTyXW3Qzrm/+lEnoBZA2QFewuPbnx9Dyljoy9BM6CTr0/Q14iyviUpgemsRKRozHvQCr4DWBdXQbCLMJW9wLutTYoXzKr/xd3vC3cfI5/fbfy1uaM7HEmf0Yzvc1FUNKRilgrklRzR1dPRfIDoffxhZsvokZ1EV9DVarHlX6ZGVorbx19rC99iq+y69Tmpna9ejfA05LY4jH49bZMCEXpN9ClHZtTHcf3OJp52ccBIdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akt9THTvmwJqbbott0bXhApR6aRRWMks3GLcZ2uyT1w=;
 b=EeXnjvSrcGVcF+g72BaY71XSOpxflWfwytLeWymVF7V0/QmkTymCRENoWXTNI38U/9FT9CaMNl/Pxxh6465EURd2jqxuDk/OH1nKR+1xcCaDgJuIR/2gZttYNuEo/n1JEM29VgcBusAI2ToCCAuqMDNzb++oRR/crwEaa2A6Tm6teSeWAiGiy4taj3OmQ6TirPm/dxS4Cgy3i+DpqXVP8GJVUE8BItJkj+rDN89X9fRwdtFv/uIEYhW50vONVRV0ptP+9rFM0P+Pu2cEClAqcc49dmqZfdcA5qQx0ONVEHEtG53yS5aQ9uXlqFOD5iYXjgNYmeU+J6MqTvo4xvUPbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akt9THTvmwJqbbott0bXhApR6aRRWMks3GLcZ2uyT1w=;
 b=DFaLqJ4XU/MzGYX9tENtqzLDB6C2GYep0QufL8vIiCoyIIvsFy1j0oZp47MSTDX9m8h0Evk2BKFb8OLaViRUjJAR5vorua7H1T5phQ0PERXUG+iNg4LU5gQ09uYVpvOQ0UyBkARDFn7J5QbzxjyFgbzfCRX9OZ80scAYEwSR9/E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4381.namprd10.prod.outlook.com (2603:10b6:208:1d3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 02:19:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 02:19:52 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: sd: Remove the number of forward declarations
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8d327as.fsf@ca-mkp.ca.oracle.com>
References: <20230823210628.523244-1-bvanassche@acm.org>
Date:   Thu, 24 Aug 2023 22:19:50 -0400
In-Reply-To: <20230823210628.523244-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 23 Aug 2023 14:06:28 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0035.prod.exchangelabs.com (2603:10b6:805:b6::48)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4381:EE_
X-MS-Office365-Filtering-Correlation-Id: e631a26d-15ad-4e0b-1941-08dba511c413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7XYIugfl3Cyzhqw60b81fsNnVSnGyPI4N8o6ulwrIuEq6/hDk9l1l1iBrCb04c68nArmKF9XV8dIucA8LNwOksbNyHQB3oLZHoJ9fEXmNtkHCfy9mHorNOhbQbDG7+gL8s1lR6gMNNKInY1RmdMHRY6U/oacjG257FKJbUZPloAksEcLlXwiWRxh9HvWnxNpULMwijRev5OM8RZP5GvQQuv3Cugu8jAiwV4bfVDR0T1vuZFaWCtog5RGOV1f5zaf8uuRP5otxd1CB822/yzv3COxVlxDKPMyHTmfGdoHWDSroF41jRJBl2z5QUVhezDxQ4MJilm4N6quB3U1+WMHNewu9l5F6e1eC4hl4CqDjGia29hW+X7cWkgSBrOiXTAQHOaBVgT6My7e4oWC+T54gl+Hgot640RraXSJUoxmrvnt/yQD+IDBoKFNi0/d3JO5G97nZd+7LpOPlhcWUAeXta3w7XdZBq1mNy0W9UxgVwljHp7msabGEBnSC1eAmcDHujxa+mLsRpjMeABt2SpPad/vcO4MkNftKe0JkoQVXizgI7FLtS28zs266KYrxcQ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(186009)(1800799009)(451199024)(558084003)(5660300002)(8676002)(8936002)(4326008)(26005)(38100700002)(66556008)(66946007)(54906003)(6916009)(66476007)(316002)(478600001)(41300700001)(6506007)(6512007)(2906002)(86362001)(36916002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cHT3WovA/A7xq3gDyFG9sqEFwsFr3DQM1LNqNXUUXSiZAXJ8i7h8gi0fmjTR?=
 =?us-ascii?Q?jHmrmoBHhkmRP2bw7UVSzeBKGj6sPcWvdDpDVRCkNvV5Y0/U9Z0jeyeiOU4x?=
 =?us-ascii?Q?2QzHYRSLMNyRXvBY0slj77WQgU39Dc/OGvsJrOoOGGCH0n23rDB77pQhB0Y7?=
 =?us-ascii?Q?wbzxTF3FZChCbnoJM/Ja4c/A8ebOYaZziaL1KFi9PVqTfzfbX/CPq4yzQPIW?=
 =?us-ascii?Q?l1g06YyfH/WAtmr4yiZHNXNeLz52/MBtyGiKFLvX5hkAHY+/rkcIkF6ZgKQQ?=
 =?us-ascii?Q?J0x97GvjhdRej29l2EJ6M01RnqTKo5TN2BYFsnybrWnzeYjVFlHoQrBE4UyU?=
 =?us-ascii?Q?3Nr6GW9MxL21+UJ62PlBY2Tn6tl8ZPC/NKqH7es28A4QmmMu0HG74BWa7aQu?=
 =?us-ascii?Q?w3Z17FlKFBbgzFpX/PhDiy4JvduKxfR9qpL5xY4TMjEDWZ9jpTVQeNJDfioF?=
 =?us-ascii?Q?brAxLYmoRhToh1PdYsWHPT2E6vTfOqGpjDQKkJni69SwcaXlYyQAlLNnQEi9?=
 =?us-ascii?Q?hMoSEcYW9DpGoa7kZZucb2T95v1J2Lrl44JrkqNFdH0KknC0FPW6fS3gYqOP?=
 =?us-ascii?Q?BCtNJaH2wd0Tu9F7VxcY488VYJ6Vcq4bqIRL2Z1AGyEj+Ylqc7ZJVgkDn2eX?=
 =?us-ascii?Q?FxBKdYpmmq1WudDSOCMHt1bwfc37NvCHgmOSk7xsJAiUutBoISaFj14rZD2P?=
 =?us-ascii?Q?IfTgZnlSb2wj0apMlJww5PjQKIJWR26HWU/SMIHudM6SYXehuJkSnEo1zER/?=
 =?us-ascii?Q?UZfE5CbAroHlGXZMbX/RjwmcTLz478BtVNb9w7KTLPpONDSQtpaBo6zgi7tm?=
 =?us-ascii?Q?iUt4QxADtngc2HxMMByyQZVPILO9EPNVWuOInCZvDJEjcaCwizHJhOLPTJrw?=
 =?us-ascii?Q?mpynz8u7tLNbI//35lmcTC8XLS027XjCUeZH0ysMxP8R5on7FD3p7z/5nXqG?=
 =?us-ascii?Q?ZSSLV3Sfbc8To9QoEJhUf/uafiyFUr+D6zpp5Mn8e8PX1PQH1M3Y6kJwlur4?=
 =?us-ascii?Q?gOEHWqUgC177zOFpRQ4tprfejb7R2Ykr7kyIsf1jvLtsFZwNRSnm/SzJ2QMW?=
 =?us-ascii?Q?Wtedx5HLgXfv3kKoHOlc8Y+ewU7qZd2u36VlX4RnmSNSHYqtYuSAUAsfY4s/?=
 =?us-ascii?Q?nB0vJ/hI/Km83WpD8lujK9RgjwwK+70VelDCoYu40CUbsC+T5Yf3LBLQiLJY?=
 =?us-ascii?Q?TrcLUFrx9k3yfnxziKfOhejMcZ+WZDoQFH2+yerNvcoP2C+H+DfhLLYZ5hY6?=
 =?us-ascii?Q?kyTqktBcQulEyDAPpUBpZLPK5Db85TL0rk4WA03YNGyDX2OJK26AIw3295YA?=
 =?us-ascii?Q?kwPiKq1zeZTijFCTtAWEhNr+f+M4MbuwJC0QAnE6V7mVBuZ4xRdwM1LNcbbF?=
 =?us-ascii?Q?Qzf0II4ROaWguEUbaHpgaj8Ps8uaryxgrd2N5y1yNRSa6C4oEOAaVT2QrBel?=
 =?us-ascii?Q?+Dd+mBkXu1Vsh5/AfB+FSOVqOQ81M4h7A2L0merAxbNglbLHLswO0+f1sxBN?=
 =?us-ascii?Q?R5K9iPQlKoUfCaLICwYs9kjyFQ7qA7/l44IkslxHfwHniUNsM0rz3z+dEPY4?=
 =?us-ascii?Q?xOUwVTfXS63IreRnjHFeLhYplAa5jze7N4ATyYgmtbyq1WRU+Ox15PcO86PK?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mex13dwWbFmtTKJLfgB+bBj0CrJ6x1aSDYZURJJeyX1dAgHiqQJOPhcVS52vXJeT66T/UcIi6aDHZPYpk8HeUVWHpjUXVzbmAC2tY6w5XGRvryGdU/FzyNIjmJjxxf8GtGfE3AsLfx/kwCHfzHaKGj1KxnkayOf8/hY+zEe2/QnCZfq6KdrA8enZ8ClncgLgAT5yVIaNgydR471JiMmlER21cSR3pAPr+eJSjbiT8WO/J5tO5uxwoeYs/ogSiScph9frvzCnaOXhS0nvHBaLLTrjEM2zc+cUV4efx+7DF+GzRIOlwS0gXi66pDgGdP/D8oYM3mGWjD9xw/vuFnJ08Imyo+nx2cDs0wlgi/M9/OMCNbKRdvzSn/QdAR1ZqS25t2zxnxzJPMK3o+iOeM/dmYPcuiNlfYy5abJX+0g06sUaCwOCPOi2SIbQ6q/kOqOhg28iT/l9P4gjApQMSkJTsvGGKWpVG98oLmuMFBpdXZl5KpCPQHRMY9DyddtHbX7WaC23o2JR1nqbpbh3Q/np5Kd9u5APpkNZ/u83RyOcmphf+yWFRhtj9yYQmHohmd2BPNI0Z1CYH1K2LJKk78YaKpS3tWY1ZHjUWYcQu3pKF1MON3gLxQ2LJ4FyypBelCmG2E3aMWQ66PUXKoq50p6KQ7uEMbvct5CS1iwyClIGpTr7Jju//jXTPJoJmAeSBkVyYg8Kc6wRIcqw1WL4DfNHaTZu9vxURKroEJ8z0wcgzBpp6VQWOVPNzmOxD8c4whaYBAW9OfjrtGb69aBKm34EJnabrgpFRylSqsjoUm8y7LZUQmOWV8ZeUfd1RcMYLvqP
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e631a26d-15ad-4e0b-1941-08dba511c413
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 02:19:52.6972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmMT8Olgbbkln1jAgl2uJxQ2qXsnE7aV8NnjF0v6w1aQiQFuYf8bDPk8mGFMJvWkCtl9I5NtjPAEAlNuJXoRlY0pRO5fVorZEYg0z3KtyRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4381
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=967
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308250016
X-Proofpoint-ORIG-GUID: W5_bxxMNGWN_Zc_OYustMYV8bqUcLygm
X-Proofpoint-GUID: W5_bxxMNGWN_Zc_OYustMYV8bqUcLygm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Move the sd_pm_ops and sd_template data structures to just above
> init_sd() such that the number of forward function declarations can be
> reduced.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
