Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA7AC38147
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 23:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjARXSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjARXR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 18:17:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE763A844
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 15:17:55 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILmnql006819;
        Wed, 18 Jan 2023 23:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=m6HHw+MJAYx66kdnj7UC7ZLTP2pO5ZCVbBPde2/KkaE=;
 b=q3SkwJZWc0q/EjkzWFKxY7fvrFhodkZyk0zfM4i7NMr+NGeysepRB9AHcMGBDPk8QLVD
 nyLweErlEvRrBsfiBS038PkwxN6OLg+ohLuZMeYazS8MnXPA+rB2qckpAW8l5zV2VuJY
 4CmVjFYpRtGErKDmyIEnSh37MNVg0cNJoKhM07bOxMaoCpPaSyJv21T1vAtc/f6C4wfl
 VazxFLXbQfpdX/IOFU/gDRnA+5HjBiyxKJ2AqGJwqZbNcmRhLI46WkycXnWhYDtyY8nv
 o9vEg6yrHlg1jVqsmlveehOGS6g83VsKku/KYawayyqYxHWInrosYRcoIiqgR7PR+bmn Tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3k6c8wvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 23:17:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30IMkDAA039609;
        Wed, 18 Jan 2023 23:17:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n6r2tmtrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 23:17:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1Jni1hQzNzUshtVCc+1Ip9bfv/66LBOi8BTw1wALtngSbjz9VhHcQxene+L7h17jccepuT+m1mK3tBp78kEn1y4PNdzHsOXQTt8IfAC1B0SExI48QJ5ID9C1sVzVUxbSpb+GDrk3ejmWxyoYWgxuQgZx7fiPoAvKG+HIyZfOKBuhirez2ml1zejRX/yBHiwC8Rm49KMHawEZ5vipD6m8Th9gAXi+MLr1lboRDEdkn1qEGb13F0s+pbBYJFz1lhVa3teCjTRk6MDlMP5iH2qpzdtevsf2ya6h6cjN6giD4Mo7w2C7SpZRwr4ILyPw01uXi7ILIintTKvjI88jQX0FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6HHw+MJAYx66kdnj7UC7ZLTP2pO5ZCVbBPde2/KkaE=;
 b=Y6DWbsmFG2JvevloH0hE3uhlFpRs1y1SgnMRvwkW77W0S+dKTHJgxnO5ygCn71AicUNNIVUpEg7cQPuVwKT03cCb2A4vVRevjfMUrGTXR6Uf9h7ajxSCBcKAGebXQxqAbmcKk6rNnAPzs9a1zqcl6vUky7SKkeT3dL4cqtTZdfNuro/WERQJ6bLpoCPHYNGrVK4BwnukbwPNWr2UJTORJ+lCkUoEHFHZfVT82lF3T2XgPM3vQ90o5OQU3PIJM/vr6Q6vmVyB1RN5J9HmZfEvVtOjnxsLCc6/Px6bjEKVs7Pisl0OutFZNdZr2y/mtXCrbRcWIQTPirQXgp2nYBY4Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6HHw+MJAYx66kdnj7UC7ZLTP2pO5ZCVbBPde2/KkaE=;
 b=gxwTe3ksF6JvzIoLewOlAImAuBTbEVp3he0KXtVmBqnJ+9m9vSZDe0tNnzbf7XtXf1qwTcFsrT5B7FSSroEp/vcXHw2r8vN59owjpC6rQyIBB3eOUsaK3rI6D/NUNmEe0eeGDUPzJtohZaws1x+dWr/32bczUp+qqq+Qz/gypzQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5334.namprd10.prod.outlook.com (2603:10b6:408:12f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 23:17:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 23:17:48 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH 1/1] scsi: cxlflash: Fix compile error due to incorrect
 scsi_execute_cmd use
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cz7bqvot.fsf@ca-mkp.ca.oracle.com>
References: <20230116211635.104999-1-michael.christie@oracle.com>
Date:   Wed, 18 Jan 2023 18:17:46 -0500
In-Reply-To: <20230116211635.104999-1-michael.christie@oracle.com> (Mike
        Christie's message of "Mon, 16 Jan 2023 15:16:35 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0219.namprd04.prod.outlook.com
 (2603:10b6:806:127::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5334:EE_
X-MS-Office365-Filtering-Correlation-Id: 83cba234-fdf1-4893-1f8f-08daf9aa36bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j3OXJPsH1L1IKcByny/5PaQ0jods4n613iFS1cBw/i3vrd/s49DMr/LE4ffajoNjU6SdQB3h9g8uTWk0eMLOkrLUVuAkZb6j5BJ1yeOu5X0zgm6+eHdHfStDl+/S3mmwaqTSZxlm4ZNWAdAP7XS9woGgQ10nkL4um0W/aLsYvtqh05HooGHchs33t2JlKmvo6tEy1T1pXEzA7GxZZOpIxJ06OxJlHKNaoQ6MmVLR/Rq/ERJEAoHZV/Tn/V8Mi8avitevMZN1VXOBmhN6/uwzMvjisxiknmS1jvxstrwV6dBV+ka2S5W3XQ6nnH237q9QPrVa6EYYADFnNmseA1yirwrN8kJvZhxhO4pilT/11Ho3Y8em/rzdtXooVomjJMNdxs80tABwDLoT/tz391u1b3P+HDfLGdc4DA+zgW2QUdgpOO6VKBzAt3HQ90dggfM+7Z2AvMmA334tOQLsz1j5mxHCBRLsINZc7Nzd+/dvOkJjZBbcQ/WhnFf4bMRQ1o6vTymzErWH9STpy8UkJi7BIghSYpGyLVRxEI/o9SNu4CU6CNPh5tqVm60z3yIhzSCjaVFJdEaXnENR7m0vOs5tO61Qowti10ZhOhBc5AFjPCj/GGT3K7jRbDpQDAVtYVWBCnXnTGZZafppkAhQ5BlFFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(6506007)(6486002)(6512007)(478600001)(186003)(26005)(66556008)(6636002)(8676002)(4326008)(66476007)(66946007)(316002)(5660300002)(8936002)(6862004)(41300700001)(2906002)(38100700002)(86362001)(36916002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dvyoeq6ZV8384bM+3FRw7ECGvjRa/QdzA63Tjy2E9qE4YZ5IuCQB8AaMlrSr?=
 =?us-ascii?Q?d8H7loIzSLWt73tm3BbLSPPLqk55GTsam4QgB9rDv4tbUBwYmZ7AVufa12lc?=
 =?us-ascii?Q?+7wXLBqXICzROZ+IPWmh9W7k+Q5E+AZ0W90MPH0AYabjSpk/NLPtzBJ5+k4H?=
 =?us-ascii?Q?edxJ27iiJXeuMgjvGuCwJhPglvj9aIrpeq3KSxdP50ezEgD1Qa6/qEuDrUuf?=
 =?us-ascii?Q?eoMS0dQXeuEaLepv7DDpXb1aCWuMPMB4soFZ15aHQMe23XrwmFfOr56ZmzcP?=
 =?us-ascii?Q?b1HvtJjljwCkaEj4y9xz6kD+yvdmJauEvt6tN4oqIhkVYyZV2XbzXUWDM9vl?=
 =?us-ascii?Q?nDCAmOzd/exx3vqRrEe1fT3b0m7FlfOwcPJ9t7dB34RCtfXWV753Xibe2ZJx?=
 =?us-ascii?Q?+lerL6FN05npm409QzctIYW0jprAB6Lab3mVjj9EqxwpCHPeIJmkuj0NILQI?=
 =?us-ascii?Q?kkeI7WJXAD4PrrEEmfkbLRMzcEZKUfTTmjXZ5BKcsGC7nhqwQJCYNqxac9P0?=
 =?us-ascii?Q?1hDNFXhMF181a+LxfM2N42ibRSgRzyqRHAraatt1pTrJOIy8iwuwRsLdn5QI?=
 =?us-ascii?Q?KR0G8t1lwx+7mZJ5L0CN1yhHPLZBtiqQNdqTda9lrdbGlL5aIlbAedk32Hrn?=
 =?us-ascii?Q?rpuMiEMMW+osZ7BA2ACKzu2nSASJXifUxapYzb4izUw8ayjJdYXKSgB//W9D?=
 =?us-ascii?Q?rnqISXPX0AcOIL6oAY69XK518/5qlKC7DmW+AUoMdzl2IbyCKxPWDdXFJvtz?=
 =?us-ascii?Q?iXtoc/5PL4VdUfVLEZgVDZD3g9QtOoxuG2n9c+ye8/6RbHN8ormr8WKsSiSD?=
 =?us-ascii?Q?onFfR8oEy36A5GsRTXylKZ98gDWtX3IFokC8uNPrrFKm7F9AxmkdCnOcNuJR?=
 =?us-ascii?Q?PoRkkuxpKrHbNGbRehTWH3D29AJl0ZaBXh1vF0zWtYqPz7PT0GJRvr5UH56G?=
 =?us-ascii?Q?UuXra6zVh/fgea++l/cVg4eFVnZctOO3diLJsn+bvkQmfJ8ylpUl8yvTQZWl?=
 =?us-ascii?Q?w61loYpsyXWZvFe2fhwfSsMK4MSdL8EQeyey3Sv3LdFL8LsHaLBLcdXycFPP?=
 =?us-ascii?Q?RquJpYQJRSUGDLULjD+2ljylDLJKRAK/hlNN+n4PpR89AjwDMVmcSJsZlXta?=
 =?us-ascii?Q?YvsjjorWMdZF34/rRVQwhK1cnhzNuZdjOpC2GNjPc2ZyxyoRz+k5siaU9JQ6?=
 =?us-ascii?Q?PucGHuY4daSvL0g96+EItHCFfq65k/OyrhfLOW70cqVWW8ZfPzJKSOUP4L+c?=
 =?us-ascii?Q?4sJmD9zjik/o27/tgqZZcdT85P6ft2KlnAx9G21qBL8kJYjW9Bf15FwuLqSK?=
 =?us-ascii?Q?IZvSmU1RmJNMtmWkpHuudrW3wwxx4ERjZ7bnJmw0yV/Yza0VVae8qrbNyBHe?=
 =?us-ascii?Q?BXMKWmybwk5QmUmETEu8hax7+auk7b93nLgObju3audUx84V8cWxfaWg4lL8?=
 =?us-ascii?Q?sJ11vwgTUkIugk3+cxumZvf0ZA1LtYWEeG0FsZwbRcO7Th5y7HIetobCvmVw?=
 =?us-ascii?Q?agId6klKKn9rLQ7bkbZTV7LTJjPbfKsNRVOxMRMeaZt1xS7rE2qZO14s9CRI?=
 =?us-ascii?Q?/tk+pPFpqhczn8YpY8ooj0qn/hGhkwTTeqRMEwkXyuz7xOvK2U66wNKO7/6w?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UnjgHhpkf++zc27fvCf2YE0nO2jTlPxhw8xQ0DlKCn0oFQQ+5C/r/sis7eIIRqmEgY9nTz6qlfbzDPKUsccskBDJmlzl5BB+ZwDEhLqyHO/CKHMr8KrEYTmKW96qB1I+DivqonjiqclhvoJZUMFlvdNCLQuXn4mzHop12ubUutCtPf7Slmmecil+SqtdQUwBTzwqOfiw/MHn5iTy0o7Qex1H9D+pawh8a9y+NcFIIFEArB2Ep9ulaxGLIaBmgynIXA9NsBNL7llg5veMw/3qJqaoclmcpQfOATprMpTAfhesrdSRKsghbxDihGlY8BhvqLmZEdmg9+OOSLzS7/Xujf3qrV9YzHRe8lpccmQI4B+oRgx/AlQhzfewZpX5qXFYmQcCFWlUSY08/L+xp0S1bwmQ56k0yI0+trxW8MasvW4X5cn0Hyyz89lyR8MBmq510QbZ7JAa2UY67H9L5QOZ9Kec53yzMZFwvPdv3wQ+iZ6F+7LjP+MN4ooUnbf3EDVnAmL6chvtsPQpThjReAe8ScVjZiRR3qwf7SzWOOL8lWvykLpa5WtRtpM4P1l0KCSH06Gc4+w4n6uRM0gSg1EZAM7gma2gflCvC+0y2SLhS1FUPtwx2ArmH4OBZuWQvi9rDIAyCFkMpZzq1ymWLk8BQUk6qKHaFkv8sxm8f/r8zEMAGHQfJL6iD65XbRXF/s+SSdOjsANoeFs1qaro2uY/WvaA/lQNHT//1VO2MrFCZzRfJ2zczTtpF6Bi555EgqKkAn26HQFw0NftvLnZDcvDaIynPwykZwP0o+KUw1ozKxc1ddnrpNcioDudoYRqwNlV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cba234-fdf1-4893-1f8f-08daf9aa36bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 23:17:48.6160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYlRvb+Km9oD5W2quHF5TatSdleDBFb7HMvmSOTohFqLUgASrWKj9WZ4I7Ebrae4ruE/VXkGrc2ZxHrCh6fZuax5nzRTh9TPbQOJWz5ANIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5334
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=669
 malwarescore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180194
X-Proofpoint-GUID: hBEQoWNzPPw7x4OYZ6SQxyEduKLPMO4v
X-Proofpoint-ORIG-GUID: hBEQoWNzPPw7x4OYZ6SQxyEduKLPMO4v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> scsi_execute_cmd takes a pointer to the scsi_exec_args struct. This fixes
> a compile error in cxlflash due to the driver passing in the
> scsi_exec_args struct.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
