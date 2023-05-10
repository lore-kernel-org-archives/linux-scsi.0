Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB94C7EE22
	for <linux-scsi@archiver.kernel.org>; Wed, 10 May 2023 14:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbjEJO31 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 10:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237489AbjEJO3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 10:29:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6C4A26C
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2023 07:29:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ADwqbi005106;
        Wed, 10 May 2023 14:29:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=EwJIaqv5y6LD15dteou43JNvsqNfhGgJ+B9cZmoYJAE=;
 b=VhHzANG2kKy+f4BEhMTAnyyxQuX0v3viBj9ujhZSHjcTBdYbmuWycHOkKzdXbXKH1giC
 pZA5JcdlzIgrFp8RZhs9d0sVW1btvZUW4e1iwhqrxinIgM6yRP8qnwampaBI/bfBjFxT
 kEyLP52x5SplXw2TmInFjCUIRrt/qXSfq5jkEf4fTUdSDcA5FA8cKQ0SdJHWg1VGRYwS
 /d9r/bh/WMMfmuPVeJH5AY5wwZz7AD6+pcTYdD4mbU4DDVjTVFPfx9WdK7+PhIv1X/W3
 64Lq7DZtsNI8O+fwVa8jBp7E0D/L/b1CubNruXLVGwuQvdLXfVHqsuwRcCNVab6L5yGD 5w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf7774rf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 14:29:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34ADgd35002163;
        Wed, 10 May 2023 14:29:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qf81fuwh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 14:29:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPe+1njmMt2JD5v6iTpQ0BuqsEvUM+hTK7cvBAsFOdkyqORt4Y6I+6rBguoBxNt9x4/13GzhDpFx3xtTeNoJBzbwjZv3xMShUqI2O0hLAotbQoayVjzWUxijqtfvr90b5/DDQIndRmS5bUu+sm3AYIuynFjcH13Q1jSraeu+379Q6IMdaqk2mF3ao9rDAyFec9TBnoCrMZB/Js1uRr+g6+ZsEPocSySsLU1w9x8ZE8FC5PqNU9IB/eHVq+9akCKHBPGmSruM5pjccNJ7aFqjj0wLhX7l7KBOw+uX2O6efbpWd/w60ITSqyTpwaG+DqLkN90A1umsEhMmGbYawl4vgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwJIaqv5y6LD15dteou43JNvsqNfhGgJ+B9cZmoYJAE=;
 b=nEL6tSnPpmcbRbSb7EemuE6d7g6N6VHwUaA0Af/fZZve5FJkz2t+sqhNJkGf3CAeihf3rmX3rcp2NQpekYtZ6kaSpE+S6EnMYiCX6n0YkQFHSGz/JS/NhJPMZv0s06nO5B/uigd5+dkOiMcCqVMY6cilOZXrbEnGSkHDh1HnrAudEsi8rEaiEDZHwX5dLYCmhuv/BmQdVTmmomJQ7ARdysXApyRhwBEpxp9Q6/Y7akhImvB8Cdrj3HzqlNqEg55sAL6oKIeAdCVQcjCrxdzMbXvnAJSNOKGUQO47MX7YP6KqlAKxDSZXPA0mPcxJTkNqkus0SkYm38eSlUC36ZU+rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwJIaqv5y6LD15dteou43JNvsqNfhGgJ+B9cZmoYJAE=;
 b=tbOrKUM5yHjkYCn3mhv7uhO3mfOQ90ilhncT2iAW28hqYrAt2xyA3rojR2U5zYaZCgqHjvbNtpwTgNwVu3GgN3vbKDl08EKVKT/z74dfocWUt5zGrn6kOShxyD00JbWZ/IzH41unlHlsUHiXJ6KdcNI5iLVZNTzbggIZxcUbeoQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4771.namprd10.prod.outlook.com (2603:10b6:303:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 14:29:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 14:29:13 +0000
To:     Brian Bunker <brian@purestorage.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Seamus Connor <sconnor@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH] scsi: sd: Avoid sending an INQUIRY if the page is not
 supported
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mt2cxo07.fsf@ca-mkp.ca.oracle.com>
References: <20230505204950.21645-1-brian@purestorage.com>
        <yq1h6sn10by.fsf@ca-mkp.ca.oracle.com>
        <81D851CF-423E-480C-80C1-F05CB67E5322@purestorage.com>
Date:   Wed, 10 May 2023 10:29:11 -0400
In-Reply-To: <81D851CF-423E-480C-80C1-F05CB67E5322@purestorage.com> (Brian
        Bunker's message of "Mon, 8 May 2023 09:04:28 -0700")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: DS7PR06CA0038.namprd06.prod.outlook.com
 (2603:10b6:8:54::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4771:EE_
X-MS-Office365-Filtering-Correlation-Id: edbe1160-1764-4abc-1e8e-08db5162ed87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iW6Hy41yOJuyrjvPk4XSx7AupmSTEQFfmHDix6f8KaJKQ9zBxX/9ZsbtEfE6eGT7AwJCTfG/NU9258JxoCqdQRPiHt9g99nNd03lfBJX90INxcZB7UFcMv0P5SDKuMi0ZZCUvWysttCoJabnF8y7eJnCNdWXO9muiEn6OtDgGKKW2auFKpMPUHhmzp+zSZmm0tmbUS10fiIuaq5WT553no4hcSCbZcJw9Iix1ojtgdr9tiXTxmcHBjPfzEaf+qR9RSF1aEhmjLoa+Mh9UEdCZ9CNSQSc/7aH5lGyG9or1iweneM2cfhGbnjikBC3sG6ClVZLJ1YwPF4GCJJuo5UBXsTQ43bbplnS40fSV9OTrn4nG9umuK1NzT4AvTTjZ5HPm/7NAttOyw5Z5nhFGR/GSCs0IUMjB3uMKJ43FswJZ99qhiuw0iVOqwBqKnAcGLTZbY1R6zh9r/VSuXRHjTl1lzi1nxW5i9SCnhhckTF3e4dDztJLeIRy9MmJJ+kuUYj+SJDnNoTgj9Ima/2IH0gnDyKCYU+tQ9MVKYLWyna4vrbJ34q3TIx94iWCafrlKmGg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199021)(36916002)(66476007)(6916009)(4326008)(478600001)(6486002)(66946007)(66556008)(316002)(54906003)(86362001)(83380400001)(26005)(6512007)(186003)(6506007)(5660300002)(2906002)(8936002)(8676002)(4744005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFJ3N2Y1U01jckw5ek4vUE5FMEdBNWl0OWUxT1llNFZ6YU9NRThob1Z0Y0JU?=
 =?utf-8?B?TGNWNlJTTkNlME51WjJGSU1vOStNcDJGM0hmV1N1NlFzcWtEQ3pmbG8rSG9Y?=
 =?utf-8?B?UVVQM0ZhTDJSV1hiOWdNdVVlQzUwb1F5K3RpNlgyc3E0ajZzaFVxUHZhTU9I?=
 =?utf-8?B?UW83MEdHaEViZy9NdVBrcU9EemdZZzcxd05CTFVSbC9wL3VGcHdJUmNOZU9H?=
 =?utf-8?B?T3crSWxzbDNRek5wbXpXcTJUR2FPNEpNSmVZajRQdHgyWm0yRFlyc016cUMy?=
 =?utf-8?B?NlNEMXk4ek5VaFVObUlKODJWbnFIL1Q4ZDJXb2c0SEFsQWkvdWR2L1RVbjdy?=
 =?utf-8?B?aFBDQ1Z5MHI1T1UwSlNkUWJSZFRFK0Z0VFVSMmtZeElUc0lFQlJlb0pSWk12?=
 =?utf-8?B?YTJ6TGFJcHNZY1ROakhRekhSTDVXMFBkelhSOUtaUjVvMXNRZU10NjRyUjZI?=
 =?utf-8?B?TW92ZHUxQnc0elJGMkJnUVU0UVA4Zm9ueXhBSHBMK1hTaHdYY0NIVHUvUzRX?=
 =?utf-8?B?OUN5cXRlZFBleUZTS1VpVEN0VkJzc3hNRmVQR3NXVXB1Z3RyczBiNjhXTjZJ?=
 =?utf-8?B?N1kzZmZqNzBQam9QeVdIcG00V3RiNnh6eEpYeFVScmU1U1UrRTMyM2JjemhJ?=
 =?utf-8?B?NHlWVGNHVGYxZDk4QWU0cFhNYWdjU2VtSUJiaDFQcnEyOGxOK0QrSm5sRXhG?=
 =?utf-8?B?ZGc4b0x3VTdmT3lmUDlSd3poSmRrbE1NYVVZUXVzUGl4aU9yeXJ4TjhZaFRS?=
 =?utf-8?B?dVlmM04vMWpLbDVMRmpTZUpQSXUrS2ZhV3hodGpkbVZlWEl6alJDQm1VT1k3?=
 =?utf-8?B?TXYxUDB2WnV6aVRwUUNaS2g3RzVtSHZNU0JFVVpWV2ozenZwbjdlM1lTM1hN?=
 =?utf-8?B?T2o4cGN2MUlZQzdBa3J4emlhMkRJV3JSSndBRXF3OCsyS2Z5ZG5VZGtNYzhr?=
 =?utf-8?B?b1huUVgrbWh4YUFNejBzVmVlNmN4d3JtOXdrL25CejZMZ2FyU0g0cUUrOFhL?=
 =?utf-8?B?Qjhxa0o1ZHFoK0xsbkt1c1dEZ3JISDJDUGxmSmxMdnVwUkZkS214K2JwOUFX?=
 =?utf-8?B?VFZsbjIrTXhMR2RJNEdKVnhrNTA5R3o5S2hwYm9QR09mU3d2dnVDVis1Q1Bk?=
 =?utf-8?B?T3YxVFFZbjRCSjgwQmxpNHY1TFB3NXhBOG9oVlJpbjEvdzR4c2VRQjR2N2k4?=
 =?utf-8?B?SmRlbVRaUVZZS0xGeXJad0FyRDRVckEyN3dCN2VETTFvaVAyS0d1cFVDRWFH?=
 =?utf-8?B?SHNDZ0h2cE1HVHZPcDhmUHBqTkVIMkdRS3Q3Q2ptZWUwSm5jYktzVmsxcTVK?=
 =?utf-8?B?dWprM2ZGRVBQNHdSbVYrdm9ZYlQ2YkFDSGRpZE5odTUrUUZrUXgzWkcxaE1h?=
 =?utf-8?B?ZTFlU3JaWGt6N2p6ekZSbnNLckRUaERqMWVZOG55TUZVbEZSS0I5T3ZsaDhV?=
 =?utf-8?B?Ny9KTWtrRGhteitQbUpib2k3R2owN01wUnV6SVJscXQyYVMxaDhIcEFCNytm?=
 =?utf-8?B?SjMxd3V6M0RxSmxTQWVHUERqZ0hnNy9GU3RrUmwwTGRwRUFvMzE4T1NieFBH?=
 =?utf-8?B?UXVSZFRmOXRCVnJaR2NldkluQmYyTy8yOE4wU0FvbjFkZnJ4clNrdHJ1dUhk?=
 =?utf-8?B?R0RPUGhubm5FZzdGcHlZTWVNNHViQ0ltSFBvVWZ2RXhzMTEvRzg1S2tudlNj?=
 =?utf-8?B?dGQwUXhwVjQzYXF4VHdsZ3FTeHNkelVTSGJBTUtNMENNbHhzbzZIa25PYjll?=
 =?utf-8?B?QjNXbjY1RXJxaGI1WkhsU0ozT2prSElDREcrQ05XUkVUb0k3aDRDU2FJZklP?=
 =?utf-8?B?WjNvUXRZL09lWGNyWjRUN21zd01UWGk4c2tYa1BhOG0ycEhFQ2pISVIybGFC?=
 =?utf-8?B?KzRTZkR3U1VzdXZCWC9zUENwdTNVQ1lHZjBkdDNvUXZaampNWkNRZmExbVgx?=
 =?utf-8?B?Ty9hSHZHYm9mUXoxMDBjemhEeCtKdmZEN0RGV0lIQ0ZnRjBuNHllK2xDVjE2?=
 =?utf-8?B?N3Fadkx2a0JyOUs0TStNVEEyMjU0MmxJd0NSelVzS0JVODRaMm1IZHYxM3p2?=
 =?utf-8?B?TTB4aHRBbG9STng3bDlKYzhhNWQ5SnQvdm55TGF0QytWN2R0aGxNUktDTnc0?=
 =?utf-8?B?Z3I5RWdqUWpLZ0RYV0FDWlBxSkE2OHExV0Q3cHVRejEva1l0WnJleEs2aVNZ?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: G2/AsLMQi0gw+U9UdLbOnQzY5ZPbDExM7Nu9AmNdKN4yofvxviS63Boea0zO4G7uO8Fdho3+P80DHO50B+tKLaM227F4bXkQpmhaRLvwLwqcS8Nh7UFl+JKnnbJ/XYhqVw2FV5x4yKobNQ5H4akNFK8OQtscc3ygqpOykO7l5aF73PP6kzELhV72pkLDL3M8lDjlRAB+y3lY9fbkWY0Qx+ehxmv8O0MJjoQSDt0JO5LTN29UqpBveGoHdoDPtYqynoeBnk4xhbk1KUtnKI9WAFxFZ4DQ/68yP15CjE/dQAZbcaFWzFT4qrmDZGQd/UPsStnqG/UxF3he9wnc58o4fcJGndSrSqrYHaIiKVKXaRVzjLpkMTOg0hVAyyp3ZgIWLmkU9sZZFzA9kWRhCheBtyFyuxvh8DL6lJJ4SBirY6jySd6r0PJGbzAfzMHiAYbCTpBm5Qrfd2sx4icBiIQOV/DHZQScuvfOqp25pOWc8vyGwbMdZc/GVN/Uc+ngvjmmli9PZmOPW3/mkG4gg8VBpnF+g1Tkz54vdKRbx1XkdG0Kblo1iY3L2i9QlqgoWs5a/g9kj9NXWAn/fzNy4v2G/3CFfzTFPu7GV2P8YcNG+GsSescKbyoqr7DH17Cq5qMbZOL+78oL9uZAD3jJhOK2EsmOKA6pYpChvlIetUX9t9HX7x2I7MQDCBY9ltIRqNXJR4g69B85185Cx/f7xEud4e3/DiWvde+epd+BOzgZBUDhCQ/MUNtkY5IPJJNSu3r/CuhLUHuyuEFVOR8kBCRirq5yXbNCaanLCa+7Q66I2bSpbiDJ1JvvtGlGpZb+73/T
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edbe1160-1764-4abc-1e8e-08db5162ed87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 14:29:13.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66b7pLPB/Nt95wxMhJS6l8eA0YDYFCm7gAL8cILsMTWPx19f47GJvH3tvhS1GTrarUOVu61S0TFg0KS0GoP464iUBcrQm1Ed7T3nHLiCt/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4771
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=676 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305100117
X-Proofpoint-GUID: 1D2iKWR5xB1WtE14V8T18iy3ReQfDYna
X-Proofpoint-ORIG-GUID: 1D2iKWR5xB1WtE14V8T18iy3ReQfDYna
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> Do they report nothing when VPD page 0 is requested or an incomplete
> list that doesn=E2=80=99t include this 0xb9?

Unfortunately both scenarios are relatively common.

>> What exactly is the problem you are experiencing wrt. your target
>> getting an inquiry for the CPR page?
>
> What happens for us is that our support and customers are used to
> looking for errors when they see a problem as you would expect. When
> we are logging VPD page 0xb9 not supported for every device every time
> a Linux host reboots

I suggest you stop logging errors in that case.

--=20
Martin K. Petersen	Oracle Linux Engineering
