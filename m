Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BD2C74A5B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 03:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjCQDOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 23:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCQDNq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 23:13:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7EE9E309
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 20:12:13 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32H0daKZ026812;
        Fri, 17 Mar 2023 03:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ZrZnW74Pv6ZFTpAQpVdWxTVDPYhCVu2/+NMSjE2KTT4=;
 b=fUXBCsoFp0mJRezV+5aQoHNjKq3z2y2sHZFFY8LPGrITNkofxejpzcCW4jsMjee6x+Ga
 ntRiyO2JVFjprcECnHq7Bv07nvf2dVY01cGpv8UoTHZki7Queho9vO+PxqyUjZxKyEFi
 JdxkbO8hC2jyEaQTruE6k32Lac9DcJXXRjkiyWkcWtRAkiKQuN+zF/+9Pe3mz+V50UNJ
 SURJ5MYUG9nnIpubaT8MTKKrlsbxy3X3obpRSZe4tGbH+f/hj40tT9XfaWLMF9SisAGV
 sR9kLlF/r6cfeEMxgB15txHJPVNsnu3raPkM3qje2v9aLF/Rat1E0FQUt75Jh1DXgoeL 2g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29jxkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 03:11:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32H0QnKb020568;
        Fri, 17 Mar 2023 03:11:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq476tt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 03:11:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+Ql9Uic7iYzOlI6mWXG6EI7E5mfFDeI3NSN4bVyOVo1a32LCnq8aGI9bAyQz1nfsshG0DQMEGSt65UTnnpeqo6d6Nga15tc3KPQIoBhRlekfT0QeZZCWVr77wUn2VPINg/lphecJOVjsSKekHZGWtgOlddbDFWI2DzjF6Fdk8o5DzvFJreJZkk1UD3HVMupD8Y2oDGhJ5FHx9zkFoDAbj72JoqTqhi6sMCAifYL2BHoSdbeoQWrTWn63gGmIabAwb7O9iQPGKQp5lMvX4pedhTQ2JHZVFJWaNFMtAFWNrYu+QC8kMmy/3LHDhUte1wrqN3fJCcB+bbl7oHfbeCTlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrZnW74Pv6ZFTpAQpVdWxTVDPYhCVu2/+NMSjE2KTT4=;
 b=QrIL+hJQ3c2xVTEe9v0FTmF6+2o1S5HNps6EYbnQmL2Ikxvr87x78gDOnChF+00m/YVTHvCTZ15ZcEC6HDOLNLjvfso6fyvyXSb+eKkcDwR88rhQiQLQlSfLdMENkg7FDFeIsW5AmURG8RbybwS0MWrppDVLkFJaaT0kPQWUfsZ+R0cKra93fbxoEKZnSzd36JTJBImZPZwkBS6LdZQe4abDkBOdc4vrOPJa5FiOxoTRz5Bt6hj190NpKCe595Y5Xrlic8xiIZw7tGTizCeWDahZNFXEmabXp9ibvg5t4VDwlAw+2oDXGULmi+kPtgOITWN/jTQ5YGM6yDm2YU4TJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrZnW74Pv6ZFTpAQpVdWxTVDPYhCVu2/+NMSjE2KTT4=;
 b=z0ENmtAYOepgLUdNcSxIiU6xxDdo/htcucC8YaBlwfOWqwU+Tlpekoq8nH2eAkKGeOntDXp9KWUTzpyFJWQwHcwJRlfujWmtdI3Ar/QFl72A8IpD3le2d6EtS8P/+Z0PqKag1ggwO0Q6cUdS2RQBWuO40RZndjkvKiILcG56WSY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6955.namprd10.prod.outlook.com (2603:10b6:806:329::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Fri, 17 Mar
 2023 03:11:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 03:11:41 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Set the residual byte count
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y1nwxeak.fsf@ca-mkp.ca.oracle.com>
References: <20230314205844.313519-1-bvanassche@acm.org>
Date:   Thu, 16 Mar 2023 23:11:38 -0400
In-Reply-To: <20230314205844.313519-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 14 Mar 2023 13:58:35 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:806:21::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6955:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f30810f-99f1-404a-636d-08db26955433
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EV1Nqe5dVwqtl21MbxDT+LcwKCGDPq+yRjAt6sRXiooCyDdHBFXTqENZ3Y3cfj9+qRyvOoUOm1Pw3X9k1+QP3/Ev7IysXv6g0yjXXuAKvOIGK1GWj6fWd9h22qcY5DkyNpHqoJbcY5QQDLx9OlM/MEuoVglXKvM726JZWMp8Du5NO3xxomvBuVigtgUoMRx069ktGIs/0BbNRjh2TzfSH/vpQsbbi8mh4FjdRj+/Yru3vS8GLHHsMl2PJ9RRVk5fZqUWorZnOo+dJOQ+Tw+FedDdnSQJ52/wDao0jr7hpK9G/6HtAixe4bnoogM2eBqod4Y9j/sUsv5tD3+oAUJjq5WiUerYyyyzIK6+R9nMRi1YVjn6CoGkL+ETQoAbC6/YHYiTDbVtTwBUQjWnjzhgSbfs83TjgM2y87+3+OjYuzNhSzTMio3D/PibTcKDqJf1wg/ftoNmBJD0BeelNHrj3u3pU6507UK7zhCLqACHw6JuA6o8kx0wfGK1p8pvUNQ1H5xvWxos+dEpQzRF7zyDKwlTYgXO23mZBF6r9kM39p+sGCdn8V1Kx8lj/+4+UCJPHnb2Pq6M6amfQj1ONlXm4dwLeN4DYZpjh9SlLtrMphVtg3es1UbkKdpt141xzIdGR+UPnlhIZ8jW3lr5wyoYNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199018)(86362001)(6666004)(36916002)(26005)(6486002)(6506007)(66946007)(38100700002)(6512007)(66476007)(54906003)(478600001)(4326008)(186003)(316002)(8676002)(4744005)(5660300002)(8936002)(41300700001)(6916009)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D+Lh//OWEB/g5CP+cTSiHHWf4PjIENf/StVnm2SOQNumWc/wEnLZAeZd+9NB?=
 =?us-ascii?Q?sw+6cDP3lZYMLqnggssuEnpSCtqaI95dVW/PfHJsouVWy+UmbAbkPLcwozyz?=
 =?us-ascii?Q?sC5sqaIZTiXBPZFYjdmV11hFHoirq8hys5ciUeFNQWbyZ9dHzOAWS/oX63ps?=
 =?us-ascii?Q?I4y5Y7/w0dvJJjmxZPEWc35EBH7+M/pjnpPVeaWFnT394J9dAUlUcz7sn01o?=
 =?us-ascii?Q?qZr8dp9pLzx0nqzcSjrfN4zP8ej6YA0pvCwZbYNtbr7tJIYO4m6h4QYmyYUs?=
 =?us-ascii?Q?2OZOg6CawSr6MdTqEjsBcn2yb38t2Tf5xtCeM1UHGK5K/ADGWTvPw6pT6+Sg?=
 =?us-ascii?Q?T5i+uwwPsOxG6mrhOl7hVlvE5STt0g1xTO3U663gFhXkD2PV3SFo92Rm/APf?=
 =?us-ascii?Q?01Chp9kzI6QIMtw5WT/4iBcoCCYdysvqep07Xz49W0isXmeqevToHr4d0YeM?=
 =?us-ascii?Q?k0SddQzQAXtRJ+d7+YVB6NSXdffGYFHhWEtUglFAUWANiWWoGU8dJJHlLVi0?=
 =?us-ascii?Q?3J1eoClY3JZYpAMVWnl1gU4rmRiPmphoYsmDg5DBPcb9qVAvZ0srr9VyTf5I?=
 =?us-ascii?Q?Tv+VZwGLUVO5ZzN3G4kxNcqGrLW6oMifv+u7KNvnXp81mkTaEJm+Xrhzgmjx?=
 =?us-ascii?Q?jYu7hHMB2rF+axI7S6DAOeiPNDbnAh7MSQ5GCgl6r0L0nhG3GLS2w35KIDsS?=
 =?us-ascii?Q?TEFRVRHHlRsFvJjpdrkNqkLx9B3hl69PEda8TKEvURDHMBF54+/Fyxldz5W1?=
 =?us-ascii?Q?2ZDKNlFDJIaWPiq2O1SESMqv5yrMKvoAAen9B7EcK5pO/hkl6v4e5MM2weHI?=
 =?us-ascii?Q?XNyla7H4tx8swYTtQGgpautheW2vJbBGa/LOKCoKkIjzXcvWHaC0Lak/E5Ug?=
 =?us-ascii?Q?NZtVr5r9j/moeywcOpshD2P+XrjYXS80FYaqAKgP9LDZN3s/zVF4d4+xM85P?=
 =?us-ascii?Q?Ic+CgnOlSPiQYSrFO4k8/ZdeZXKei7fK0jE4CdbcfEnZC5TKc0SS/oYn80C7?=
 =?us-ascii?Q?+sW9U3aZnSBb4O/kXLsreWiuE4YnFl/zgLRT1sNt89mzB9iOOmdhlS5SeEkG?=
 =?us-ascii?Q?YZbowOriAHBPOuJjGqU5XZyH96pNt6cCixbRXjgJ6oPI+/TtvRc8qDBpVlsH?=
 =?us-ascii?Q?b/IoF3LykpiBcm9Mj/U9x5h1yAc6lSsf1MwY3d992j4m5Wq3B6CV7HTLr1kb?=
 =?us-ascii?Q?6CQgBH7yAVLJqu1sDr3VSXr/Yb6XrcXHb2XPVKtoY2X/k7j6Ap0laL4FCXkc?=
 =?us-ascii?Q?KgMgTRJkLtn4BEpOBlwIfvXB0HS+lX7Re4H2b18CGqae/KS7+2FWAcgoT3AR?=
 =?us-ascii?Q?PQIegB66HwK5AZDeoNN8B6unhUON4I7QmlUPe9/NpwvEgr3DucPrFibu2TfK?=
 =?us-ascii?Q?BFFBq2XJwFgHcZbEVkRXgRVeZssO66X1stSmStP87QS8YlRJjBRrEA+TnwaT?=
 =?us-ascii?Q?bMwdn03wkqWtRwttdirw2geFchgbNyRVhg8FVPdfw+k7R03ED9PNZ+FGy4NP?=
 =?us-ascii?Q?5+u0VWacE0LrXVHoKHnhrGB7odfL6pBg9xgnQXi7gIPMSlg8WZilPl6Cn4mh?=
 =?us-ascii?Q?b7AnH7fj2YOHihT7z4oVjrlIsIsvbJ6j+k7Sizs49msOLj3nKM3HCkLNSRdO?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Vcbjeop7vKM9CWjWMFIp/h+K5txdfvKpunSSYhNgmHJ/N6KfxV2xoTrCF6Re?=
 =?us-ascii?Q?RdYLM816C7Qe1Htsbj33dAWMpOgrVtaeC/ThunyO58M6Hd1Nr77l7mSpv2lM?=
 =?us-ascii?Q?cMNDRV00juQWqL/ECCpIRDs/q1Q15QWdXYRAxyhgTuiUcVCO/n0YXHVBEGPm?=
 =?us-ascii?Q?SURwzIeZQXbpQN+fEKoMAXu5jX90AaCauxVLXXzEuEJ6iXNa9SlAit+/2d2Q?=
 =?us-ascii?Q?0Vpk54WX1aiEknDOR1ICJwjIqsCvHyvhe25KSlJLjfGk8+GeHswYYFb82B7i?=
 =?us-ascii?Q?NXB5V8011qkdWEv0Y5KPHN3JCVcweLVoREPQjg+MJAbWgcTpHrir0IO5FdZG?=
 =?us-ascii?Q?dWOJyrwtbyE1vpuSxqk8/CZ7AgK0qADpc9lnRNbtPhCPKY4yfvdbHmpG3Hem?=
 =?us-ascii?Q?IJZJolWQLYOYT0pMUIbS/dTMdh32VQPzpgwHn4Oab/IbLEr3YfDhrG4RdbAu?=
 =?us-ascii?Q?y+enEpuB1fivrWMK66/McD90REPRJBHKNkMk97q1LOZ0E8VsiQnnbVXpTijT?=
 =?us-ascii?Q?a9HK5tlFbHXU32nhfmACCiVpZo5uarDO1zfjQZBGAohR3GwTgKYNhuZjMFyj?=
 =?us-ascii?Q?bQ0psx37h3JK1aiL0Muv4cVl7HVPinbeMr6czwYgGTYWgXwee78SKEoruQwo?=
 =?us-ascii?Q?oJZ7k1PxmfYcByihu0eD8eowqkOW0/Yj/rUMeG+1glWa+bMg0qu7RIajU4R/?=
 =?us-ascii?Q?v0OEixFzMhb/Fvs2e9fRny3c/qJWIsLt9rdzYPeBBRi2XiEVG5fyBwY2poKE?=
 =?us-ascii?Q?aCnHiR0Zs1ZZ1pYBcgZNLKpWzQdoF0jnkM7ZGKpoecJHgoeRTSVriJGtx76O?=
 =?us-ascii?Q?RG+h4/9OJ2QeS0JnFb17f8NGYW4wC3a2FBU8ZnllRdbrNFtVUlhgJ484aCbv?=
 =?us-ascii?Q?yCFDhKj+4hLHGAey3QuA89DuoRg2PtdDKiDla6NVNeHzIHwZk7fetJ7CWdwP?=
 =?us-ascii?Q?guHUg/1vgUi+DvlAmv9EsiWpU3UrYttiuo1TyHohuMQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f30810f-99f1-404a-636d-08db26955433
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 03:11:41.6142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mT5IQwZ2CwsoLDV0hmBlExYWYXbfc889cJdUonhWwYSb5rZiYCp9gWVcH1cNqFSM3Sahy01wrR7zS14q0shB6fNwhgEYIrE/XEKl/Naliik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6955
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_16,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=773 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303170017
X-Proofpoint-ORIG-GUID: fAmFKD69ZKG3yTQavl6AAq2_QV8Br_UA
X-Proofpoint-GUID: fAmFKD69ZKG3yTQavl6AAq2_QV8Br_UA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> It is important for the SCSI core to know the residual byte count.
> Hence, extract the residual byte count from the UFS response and pass
> it to the SCSI core. A few examples of the output of a debugging patch
> that has been applied on top of this patch:

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
