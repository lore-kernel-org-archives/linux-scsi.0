Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4A5EB64DA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 02:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjGFCfi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jul 2023 22:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjGFCfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2023 22:35:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381741B6
        for <linux-scsi@vger.kernel.org>; Wed,  5 Jul 2023 19:35:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3662U2jh028457;
        Thu, 6 Jul 2023 02:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=eA4EmH0W1rg+d36gnImXr9ycd2Pl5HxJLaV/EyUeAVo=;
 b=ntugIQdBliVTHuo14IZrYVnTxdoHuCdoGAkbvkLnhUO9/OGgyTJHprDWtw7o5f8tozgx
 WfegsN/8UqYmCwZTtvMUIlOtpKQFWIOkbGteIpunWh6orgWCrFCg8k6/Hfa0inhgKq+Q
 B6+XRot4xoAsPvqc24wO2kcxgXUKMxvNsbyfU7P7ooMb6SiQJF9KaqZIhQiYGjhtUMdh
 ATjKpki7Yr7pMdeP3SG0IwLabaJFfFJt2xgQ93vhOqjLnFlcmSuSRav5wqeLJJ5dm0aw
 z2QCMoxBYj7VlnvhJWuRC5RjaMsqKozN88wM9OLq+9mHCDHmWZDGUOsii1dwzD8oMjWS ug== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rnm5981kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 02:35:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3662XPmA024415;
        Thu, 6 Jul 2023 02:35:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rjak6uuwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 02:35:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeY1HacLzZ7VzmsCFGLxSd112LRSZAZUh1u/bekJOVAw4RV3QvSUt0zS6U0xdCqekqNULlcRt5aaPqFVQ3FA9NMxeIGHp7ao/9ivp3Lqjl2IffN0YMRRwhnUroHmlIDt2d26GNCvJyVFKN6MT0s8rU9PNlKTeunKFX0VuXX3npSeBUyJHYeuV5qNeMv/NyED1xh22/jBzQAU33mIP7EZc49Sk8XYjM30EP24vuSpAFmC5nh7swiE5H9RXnaUv3IJvuEmb4lm7YpEKPLw0l1vL1Y9W5mvF8hWmHjOOxrKslCxkWY4ZTDfCmaAK2SZsPOCeh3yODbe+rtz+WWrb50eVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eA4EmH0W1rg+d36gnImXr9ycd2Pl5HxJLaV/EyUeAVo=;
 b=QsMX6ZqwQeCoUQTUTSd/ZiSRtOPSOifRywLp+pBzzatuPVGIgK+t5Jo+lTy5ufDJ/7//e8T7Xn1lgamjyxFOFFUxGjwgy+uA/xx5lkHCp3oM5dJJX4dJ6L5MROblpUQPfZx05OD9J+G+lvB3Gzyse+U90WHsa0TOe8d6svvRplKiZBf0PV6zoCN++BBpA3nIxoAxxSQLusjBaQXLV3raK2EvcPXbsnU7cYZ12xdHWGbOkjgFmIdiEGn+QMrCn1ilJtNUGcxMhnenPpKcChq3zZW5IenrWDbQt3L0pSGSqtVlrlecVJXHhmuB9x+LHU0Hs3IV6+aiBu85dlNS20WAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eA4EmH0W1rg+d36gnImXr9ycd2Pl5HxJLaV/EyUeAVo=;
 b=dJKCwfk6yXRjOIhQSxFEHiQjwdX8O5ICoV+Pg2h/yHQLMmsgIcczRuvQrN3YWKd3WsaT6ll/N6/jwgVSG0fzJyZ0v2ETakVaHoSimj4LMDr8MgowJqDLEa8sgcErdCzoByRA1Y5TbRlTUrE/sicGZedY2aaEWnpcQge8jwPq+0g=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by SJ0PR10MB5858.namprd10.prod.outlook.com (2603:10b6:a03:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Thu, 6 Jul
 2023 02:35:30 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb%7]) with mapi id 15.20.6544.024; Thu, 6 Jul 2023
 02:35:30 +0000
To:     Laurence Oberman <loberman@redhat.com>
Cc:     linux-scsi@vger.kernel.org, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, djeffery@redhat.com,
        emilne@redhat.com, jpittman@redhat.com
Subject: Re: [PATCH] scsi: qla2xxx avoid a panic due to BUG() if a
 WRITE_SAME command  is sent to a device that has no protection
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0plkc4x.fsf@ca-mkp.ca.oracle.com>
References: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
Date:   Wed, 05 Jul 2023 22:35:27 -0400
In-Reply-To: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
        (Laurence Oberman's message of "Wed, 28 Jun 2023 07:34:11 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0194.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::19) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|SJ0PR10MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 46063371-642f-48cf-f134-08db7dc9aa3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uSMP7v7A8Oju58B0+o/KiOWUeRQ2wkOJV0y8pXfttja+nzQENEKHQO3o1EXa6FkGRbKLWKMwGgCSwkzvY7pprrIPr/wEm92ej7wk0T+qTCw4wr7hLDfAiRwMgdjFdnSdvyogXEOUPLXbM0zlzkoNuc6S/I+Ib030hBwT0YV1Wa2vXsR1VDIEWbDZgM9YQ6q8rj5nkKMk6/mLkR+OH6OBfcELCqYexTu+FfH2qEQ3jJfTfMIdmguqKBrF0Pg2XVGsY/OCMMQj+MiHMlrs7pCBb23SwkhyhKbzzLoukx5UPMTeaFBcDl9dscSV4Jr8jOlWDueehcMBV9N8tjgI+aHtm1SLb+3yXcMdxvUPsyafiNR/Yp0KMuhEP2rVMcfna/tBZHSy6anD2vPZomsaaLTDcOqbcb2WRCJoKV31nMSzErPSntbAcLVo0PJ9iYNZu8BqSf6KGKWxwfAhKSl9HE1uVAfn8iWN6CKkiW48YtHGYDJfzKssEeKVGuGzAFKbLd83kS1wYN9DtzpUMSQ2EXA6WX3AZzFI32YTKzI5zFQhovK+kv0wJYXyr6Q4sHL/LUnK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199021)(6512007)(6506007)(66556008)(316002)(38100700002)(66476007)(66946007)(6916009)(83380400001)(186003)(4326008)(26005)(478600001)(8936002)(8676002)(86362001)(6486002)(5660300002)(2906002)(36916002)(4744005)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cUcgDbGRIFAcDqD4cj9YsDTv+qztmk+Tv9b/a5ZljamxLo4xjDjAnb/MPbsm?=
 =?us-ascii?Q?wXfj+ZgZATQoEyyjspWS4EdRhuw7dez0QQclXuYkGRydgAYNOGLh1oeRwBLl?=
 =?us-ascii?Q?i4wjQdQgVghf0uU5Sewi4Fqc8lOxPQdR5W+kQQjzFX/vR8j1DLcphPyhoMVz?=
 =?us-ascii?Q?6/LBJsfLQCEndu+PMQXljkovFHnFS7kdj+O1V/4p+ZBILs4mpgoBgX5/mdad?=
 =?us-ascii?Q?gX8Ihwy2P7shInzTaixeYOjpqqU3EIn2bieBp8uDI9oJ/eRp8pMQ8lVEsvmb?=
 =?us-ascii?Q?hEGoMR+87rDYGavGUKYRzRcgsYACyd7GdEDmru/lJUOVFsWBB5orYa51fIcc?=
 =?us-ascii?Q?s9bLS4v+6EmWqF/YrsN7fwoZ8xqCPdd85vXFCmaAos1l3zbBB65IwTuW7fkk?=
 =?us-ascii?Q?1cZ3QI7Wf6fgu6GssTsjVmXlOWogCUAlU8fsC0YgKMLxmNz/Fg55H2sNg4y9?=
 =?us-ascii?Q?ZHAMXEkuaGpxbRhVGGadJx+N+zDWT4Bin1WVTNfgIYX2ddNZuLLDy+VtAH6B?=
 =?us-ascii?Q?sVlM6vfGjAbkK4gei6hG7pgEnVQsy0IZBRShVdfItTKwRZZ7yVWnwHF1bXsT?=
 =?us-ascii?Q?rrna7RkCx1O02zRQOJPrVy4qXlQVC7E9Z5veVIPrQwEG2+eqrOIpQ4MVd1AI?=
 =?us-ascii?Q?vtkr04/2u+xzteotywVqYxtcry4TPv8oTIRLC95tbBHSUsTdVe0xySrbTASQ?=
 =?us-ascii?Q?ky5qI7M7/iepOT/xwIKrERgWrPSrilpUC0H8lwu7axSaYvByTpkcwSUjdhjH?=
 =?us-ascii?Q?FZMWkdJbMEYrPHCG/3RthBylYurzSwccapCFOVkE4Cw3EBGRufTagatB9Vvt?=
 =?us-ascii?Q?KUEkjSwGv2tH2geQppDQF3ytC48xf+caBOYL0gA8SvWlmhlluexI+qDq8K3e?=
 =?us-ascii?Q?+BJsX8pjDa+OcJPQ41d9t6QdYwRO4OozCd2rQZAMQN++Gy2w2LciXe/6OYPi?=
 =?us-ascii?Q?pUHE06RFzs5u3S43f6E3Jxi8M6LW4venE9aZah2QSMWTzWeUGKSL2X2YT5zl?=
 =?us-ascii?Q?HG+uhVcHoM+y8Eo7CHi64sNUv/924n8pdUAuPTx3PJGnE2hnWzWSTIe1d5H5?=
 =?us-ascii?Q?tBUmkz0VjoFXsgWZP3BNvaqIxF9NrP410guAdcphb7HNbrPUvPbcczx1csBD?=
 =?us-ascii?Q?HJoHkytWpE+tqJkO92Vo23oTuqiL+GuBWNK0c5FbIXB07BTfDiwxtoxsRlmV?=
 =?us-ascii?Q?FsMNJEM6k0aKMSth+CBnS7jMXXFCN+8C8iuj8VkPCjaCs/yZYTOu3TlGT27f?=
 =?us-ascii?Q?Aqsknj2e5kua0eQuTmipkF3Y6NPFKAUlHEnsDd/R6ZovViqaSWYNhDlXnFoZ?=
 =?us-ascii?Q?4SMfPSRPHHuzoev5mv3IzSbXSXE1sSETVxrTNlpB22oiNxi3MsfGfSCNQA5T?=
 =?us-ascii?Q?oGzst4JAuSGNcz731S8daeElUx8lWvd+kvLc0/th7+w5nOd7RfPTyTP71Zq8?=
 =?us-ascii?Q?M7pZlmZCvBPzkn3m4IMLYuwzBNJkmb9LW85kK0tTGBfLqiRMPRLvN2hlEdUB?=
 =?us-ascii?Q?oI9Q/p/R1+mWEeiGHM3uFLZn9Jzm2QnCIVr+5hH+rfkBeJQ+Oon2brD6PwRq?=
 =?us-ascii?Q?AqqRoCCd6Xx7x4gCFyYHsUJ4dySgkP9NbQNV4/0R/7DH/54kJdlNnyGuG4Dl?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3S9vwxh9Pt8ONpFNMYYc2Co5J8jFM/FGBJUhZYF3LwJ8LbT0ybvbsiBBLnrcaH2HfFLVubXZg2Xncc3MSM5hoXXX5dMr9pNQ8vf7uva8Mjq94RY/lUC5qxdXHR10y4f2usdRd5wCcy3w//2lKrPX+y6lCVWbI3vunUWblcJ22olUG5xpRZcOqmOK/FA+ryz+lG5DWzEt49oIsOUFKB/XzuHyxJOxOb2GSxYCO2WSVYcu+aBGSPcjIg352d4QE9AFUc0Qcuf6rheBNV59D569CgurvWsPehOn/I6L6Vkv1A47bHL0goTS0d89xl2gtlkq6CS01iSjpGuIALROWAJT/0WvIycZmfVTfUecX+R8OShw5+EE35H+Te2d/M1kYbZUWCs9htsxTMqY5EQq1NdtLPkdEW/1OTB7RXhhsBooHhavgy4aygjyVlCFV3b986CKpdKXmN1GgDdQ0sR7cWudFP3NVB7QPiMeSIhswhaNWqpKW6yv2wA+a1kKcarmM9XWP5OyECzhNax4/csNApRR2TWYCw1ljfoU0zGjO0dx3NHE/tlj0M3OkQ8LVjo4iMWhiZK0Evf41TuH8LronBVsdZswOyQzONegeFTS9S3M4uhzqSsO3KkXHFOcxvTiHJoiR5IWUwLFPLX1/jAIUNKQE+MbbmGSuURDPcrtC4AANZUNDJzNOtK6ovXvZcwimSAe5e7T4D6EfReU7AL3J3URq8oeK9PBpdasJ4xgAf6K7BG8A3EqIxSDb/KZYda5ZsbBAuVi48PzrRsDdWAsR45lPvlV3L1kXdzwUdl6k4jWz5ZNYWqtbvQMjPCGu12MWIGZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46063371-642f-48cf-f134-08db7dc9aa3f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 02:35:30.2329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78QBTSPDqkSyvHLbPOvohLSouZYEFAUPmNCQkTBF+BDY1TxdCC4N2N83KTTy+8mAVaXXF9pa21PuXB6rbhvoVmMpwAdxly0nmgbS3KIVleY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-05_11,2023-07-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=604 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307060021
X-Proofpoint-ORIG-GUID: kBkP4wK_emXYM9LL69yWPE6MhVLEhZqT
X-Proofpoint-GUID: kBkP4wK_emXYM9LL69yWPE6MhVLEhZqT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Laurence,

> In the current code, If a device does not have protection, qla2xx will
> land up defaulting to a BUG() and will panic the system when
> sg_write_same is sent.This is because SCSI_PROT_NORMAL is matched and
> falls through to the BUG() call. The write_same command to a device
> without protection is not handled safely.

I would like to understand why the driver PI code path was chosen for a
SCSI_PROT_NORMAL cmnd. That doesn't seem right.

> +	case SCSI_PROT_NORMAL:
> +		total_bytes = data_bytes;
> +		break;
>  	case SCSI_PROT_READ_INSERT:
>  	case SCSI_PROT_WRITE_STRIP:
>  		total_bytes = data_bytes;

All this transfer size wrangling in the driver should be removed and
replaced with a call to scsi_transfer_length() which takes the PI size
into account.

-- 
Martin K. Petersen	Oracle Linux Engineering
