Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3A4C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 02:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiGSCXi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 22:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGSCXh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 22:23:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4881233E20
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 19:23:37 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IKqKf0032487;
        Tue, 19 Jul 2022 02:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=F4DGAJ9RjU7KYLvoufIl3HNFzsGZpSwBy5WnAfvygbU=;
 b=r/nHbMlNYZrTRMeBFLzZTbpDOyBUYNKc6wa1mkO2mc9rQZZLvUdTrPXUcrNeRDGwtYSm
 BYp3fOaB4c7c32oULGGRA+PFJtn0NN09peaP+47VY+gJUfzQeqH+pGTUZ6WNUgB0oj8e
 EjUU+7FqTEzOpoq0rDug9PFe0Iubg7gcKydoUMnFiSQxSS5rO9RM1/gcmlHJc75wvDXW
 Z057N5Opp4r5h8C8F5BUkuY1e3KB6olTj6Ygq6xgEOfut/J91vYCt8Sxa5qRjyZLokkp
 NudCQ/tkarHTKg/JD+AeGlTBw4iVtaZ0yaBHXyiGe+//S9Nj6YpAygtxT6bw4hiCY+g1 DQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkx0vyk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:23:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J10l2K006362;
        Tue, 19 Jul 2022 02:23:34 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1gg1wgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:23:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhMne1vnMRJmwIMQZZJAJLINBw7bpYmHlYzFnwd0ChhKlqEzjuSFgSnZSsBz87X5SU6AXk++DvQ5iLZhucwN30OoDrJdwzAiyHOyEpQhNcuGhmNElO6B9GV2WbTWBaSAKXxpmFH6m6F0oTEONTyNz9w23MtfzfqoGAVGI4Feg5XBio7ph7wVhnpgrOpLkHBaE5/of2vn5fgCF/eZkpNQyEOibqQDfZgEfIVRSZzTPCh/exaXGKkFVQYABY8VaPqeikOida+cLLCnJF905vJKoRpBlKZjVdxYdVnBzqucN/qlfih7FFNn8FHqK+Oz6bTx9IP/XniVWc5TqobqH4A9AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4DGAJ9RjU7KYLvoufIl3HNFzsGZpSwBy5WnAfvygbU=;
 b=HT74af4KClrG7R6fxMemruNr6TS7/c/vfDIvVnp3YgEXgQN4W8ZHWYHTQRTtgb5kIPZjQqxNUWf2V/7z1gY0qgbyMd/7BSNR7lMvkjNug495JjYWH+IAJdAb2FWZCzRvuBBtRUNRGWRVRuH9qvK7PyZrb0m0WgW0YcMzljooifD72OyUwny7jLJXSc94wlEOKf3HuhBQKElNNk++JPk88nvr5DcPtsMWByMXYABT3Uy7Crd1tjQIOzwasM1nVbzf1Bn+SXU2qOkjpaf1lYNhvOlS+4nZTNoJnhqfEPNb1ST+oTji51lr+WGKuwjLMIUDHIX8ugp2SXpQpNp5PB+JWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4DGAJ9RjU7KYLvoufIl3HNFzsGZpSwBy5WnAfvygbU=;
 b=QIJbalu6E1HPL3Wy13KYI0HIqLyrHe+lihA8M669dTswAFERcj96ZRPaBpuQujKcbicqx+p7HKQNPlLYfbE800F0cdB9BlqnhoiVAVGoKm8lvLwofYgli9TB8cx5jBfoGWNpWQImKUz1Z7iE5CESz6AR6mqFkXAmG50sm0F6Zak=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6233.namprd10.prod.outlook.com (2603:10b6:208:38c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Tue, 19 Jul
 2022 02:23:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 02:23:32 +0000
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: Re: regression next-20220714: mkfs.ext4 on multipath device over
 scsi disks causes 'lifelock' in block layer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1edyhrgpi.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <20220302053559.32147-11-martin.petersen@oracle.com>
        <YtWPoZISMLxHA/vu@t480-pf1aa2c2.fritz.box>
Date:   Mon, 18 Jul 2022 22:23:26 -0400
In-Reply-To: <YtWPoZISMLxHA/vu@t480-pf1aa2c2.fritz.box> (Benjamin Block's
        message of "Mon, 18 Jul 2022 16:51:45 +0000")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5783af5b-c8ae-4341-2f4a-08da692dacec
X-MS-TrafficTypeDiagnostic: BL3PR10MB6233:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8xoNQ+sRMjlKHm3NLCIo2sjD5keF2pKmd59SZsW6MksgfAtZ6t40+lGQxecSegDJSUnF3hqZzJdXphehwaj9/dTcTkxHR7zNMC8/fFD4v0AIG+KuFkJ5KPFj/CVaji725Ew55VhYdiyxG5pI3RwLB5/UNbZU+wMhZF6jFTkyQUerhchOcvVumQO+mU8DeBUAN+EU+rYv2Fvqhtj1p01CSeClpAeGHpjDHFf5bc6e8Sbjs2csDREsbiiBVECJU7MOZeuoK5Z63gMtKEEzXFfU+u+HAmbCheZ94qTdU4/NHGZZvlB2aL6S88VfEmYMQul4hbCCgYPRBtxyLhUhYTvPFYRDSlTRtKMHTAlNmqszReRYBWEAS/vMPdA2K4/fDofiq1RjOmdyeEC7dEBq1KwgW/GeqGGX2zK2v9q+RJeZGdViIrMwoyF1+pbCktMtezZFrJvG5BzVHouqoVqMfd2XzdCT+okjI/2HYuXtCQVyQ6whU31hYKVZ9jpENEW5eeLK8oKaAPP03N6Tfajnj/snU7vnJabaAUx+DlVTE0XYfrWI8uzpl68xClLa3Y8XE28fTdxrhJwanyeVjcnZZttQAmRhhvgt1ueGxoZa7fcrQrp7oo0prcz2ScBKGXCPY396J0m2AKfnazU2VZ9ji9+vjL28qx5Nv0sxxt0f3Ajogq0mU1Iw4TMUfhX5tN6+gpG1bpjSwFRb40YTaAub7RMdwF2CgZ0Z2t5CeT/aidRhF7KYj/rMHj896FUZSHialq7C01gc/sn7lDwEhFSbwGY8X4/ZqvfwGcjvVdkMTSaFdF8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(39860400002)(136003)(52116002)(5660300002)(6506007)(316002)(8936002)(26005)(86362001)(38100700002)(38350700002)(36916002)(6916009)(6512007)(8676002)(186003)(4326008)(83380400001)(6666004)(4744005)(2906002)(66946007)(478600001)(6486002)(66556008)(54906003)(41300700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFM0dlFoZlFTdkJydEcxcUpIZHBXMjJRUVhxeGNuMzgvSElzekdWa1VqcW50?=
 =?utf-8?B?cEZnazBBMHpOQmJtOHJSWFRvZkRxb09YT2xsdHJVWEpTWDVzcDNMV0ZsUWpL?=
 =?utf-8?B?UkFaeU5DQUpEYzFkQ3ozMFY5QzA0U3RtakM2TWYxOWs1cUo2ckJqNHdsTEdU?=
 =?utf-8?B?MlhZZ2JSdVFBWU5kejVnQmVLS2hYVFZkS2ZkQzZDMEY2Z3k3SEFuUmhyNktj?=
 =?utf-8?B?MUF2ZGdpU21kcGhkMHZyMFZ0SGY4NGZ4NUhKTkdXeEt0elRLSVg0dzYyRFJi?=
 =?utf-8?B?VE9lL0lTMGo1eW1kTFZOeEdDaFhvTUNuVXpSTW53U09QbjlJS3JiWXZGOXZj?=
 =?utf-8?B?Vm9HQWRhbmwvU05oamtqRlJJdWpIV3RJNm8zUmh5TEg4Z3Z3MW9CSGoxNDhh?=
 =?utf-8?B?aFFMWFhHa1Q2N3lsMGhIc2V2WUlUd0xhMlF3dkFIRlJQMmE0UnB2aU5rWmlS?=
 =?utf-8?B?aEtNVVVpdVUzV0RWQXZ2RzBJYXptSlNvZHdkSHFFZ2ZhQWVnZEgzL2pxa3ZR?=
 =?utf-8?B?U0Z2cXAyL2NZQndOOHlma2xLQURiblByTExENnBUU1g1Sm1ZREplOHVKVEh6?=
 =?utf-8?B?ZnY5bVNMMUt6ZU5GeDRjcmtsVVVEWElsUmF0djlJZWp2TFlQVXBmQW9ORmVR?=
 =?utf-8?B?UW1DdEdIUHBFWVpudkptUTlybktIMjUwN0thb1d2K0ZIeGdCWkFrdnJDc00y?=
 =?utf-8?B?cHdJY3BRRFFzYzlEczVNMHFwTExsQmk3ZXMyeVc5RW5ZTjBRSDBFS1ZjS2Fi?=
 =?utf-8?B?cGVSQXorQjh0TmVMQnY3eWtFTGdCdzAwWHNVVitCYkR5OWxCc1U0QUc3S3NX?=
 =?utf-8?B?bWxXNTM1VEFYYVdvQnpybS9XZmpiT0dhOGxYM3lxYktLNGZqZW5KQmRLdHNH?=
 =?utf-8?B?TkR2a2hYNjBjR2xQclovYXZyWStNekwzbEZ3WGxxaXNGM2h2eVpzeXIycDdF?=
 =?utf-8?B?OW5OOFVPWUVYcmh2eFBaZml0MlJDU09ZUTdsRktUMlU3RWRDeVByTldEaVFJ?=
 =?utf-8?B?MlkxYmx1M2MxTXlBTTJITmM1UHpvQ1FDR3JObFpOQ0VzYXVZZWptYlowc01B?=
 =?utf-8?B?dUZPSXcvR3EyVktwL1JUSHFrOU5tVGRDNEMrRmdjUy9qVDZRdDZsc0lqU05F?=
 =?utf-8?B?REhmNG9obmNRMncvTld4YlBqSXNKdE5TVFJ0dGN0c0Z2dTZLb0JwN0laNVhU?=
 =?utf-8?B?cUg5UEcvVkd5VlIybmxGUllXQzlRdmZ3aTlHZVpOZTNiNXNid1RLVVZZMnR1?=
 =?utf-8?B?T1o5UzRKV0VDNzJvaEtmQ3ZCWEZhM2VjUWdtTG5KWjIyRzd2Y3BEZmE2dWN6?=
 =?utf-8?B?ZWJVQ3BMWm5Nb09sZkRyb1dKMWtxYnRPMk5ZS2hKc0gxdUlYU2o3OFMzNlFM?=
 =?utf-8?B?N3N4aXJ0Tkt4NzJ4ZmxUMlRUN1kydGV3bUxDbDY0ekNpRkx3RHoxRUdwUkF4?=
 =?utf-8?B?SXFtWDRZTTRrV1ZHbzd5eVF5OUZQdG1YTTAvbzM3WTNoZXRNbWJ4ckRCNVNa?=
 =?utf-8?B?ajNlZUVJeVEyZjlnK2RiZy9Fem1FOXZBZC9ucmpyTDdqZFRwM1dudXdyTG5p?=
 =?utf-8?B?T29IVXFwK2xjbGlMaE12b280ekg1ZnQ4U0FtVTRxSTF4SEtjbk1GZitxTEJv?=
 =?utf-8?B?SkZ1RENsWEhiVHU4RHpiWWhBUThscEw3M2lPZW1mMEhsb1JnSzZSbG5nZ1JU?=
 =?utf-8?B?OVI3YTg1aXhZYmtDeWN0NzNZSFpKZzVlc2V0ZUluR0xudS80UE5lbjN2SjJo?=
 =?utf-8?B?Vm9zcVJXR0V0VUFLTmdnU2M0Syt3cGF3MTkyWS9hMkZzNE9mTyt1bzZwYUU4?=
 =?utf-8?B?TzlhUWV0S1lsM1E4ZXlONWF2Zi9BTG9sQ1FLT2tGWUZacE95SC9hN3h0Tmd0?=
 =?utf-8?B?cGkxMWtFeTg0ZFYzUis0cUwxVlVUU0NsOUMvWFpzTWU1cnZqd0FTSExWa1Vw?=
 =?utf-8?B?UFB2Y3JUQzZUTmZrU3V6WEdpMDJNZ0M2Zzk4ZFR1VnFreHJLVjNCOXN1Z3VR?=
 =?utf-8?B?THFxdXhoRXVFYlkvQnZNQlN3RVAvM21DVUdDR0dvMVhpNUtxeFpUaU9kby91?=
 =?utf-8?B?TzR4aWFmSEdvTDdkNkg2bHlSTVZxWi9BNW5XNFkvSERDRElheUhLcmJWUjV4?=
 =?utf-8?B?ODl4QUszMWkzTXg2Tjc5dCtPS2ZxQ3pRU29uV0JhTldGdlRlL0ovUmZhN1ZU?=
 =?utf-8?B?T2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5783af5b-c8ae-4341-2f4a-08da692dacec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 02:23:32.3512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNZOCBJ4R4E6dLrCW3nmNO3MyVxDDcIiFbka0lln5bfxDyKbh0HHB7Fp9b1UkHF5sE/TiK4lI8TCAm5BFZhrJwC5BxvBhZo/orSKA1d/OCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6233
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=962 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190007
X-Proofpoint-GUID: 707iEZqbVx1UOTJyP3UP_uzo8wfvhWZW
X-Proofpoint-ORIG-GUID: 707iEZqbVx1UOTJyP3UP_uzo8wfvhWZW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Benjamin,

>   # lsblk -D /dev/sda /dev/sde
>   NAME        DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
>   sda                0        1G       4G         0
>   =E2=94=94=E2=94=80mpathc           0        1G       4G         0
>     =E2=94=94=E2=94=80mpathc1        0        1G       4G         0
>   sde                0        1G       4G         0
>   =E2=94=94=E2=94=80mpathc           0        1G       4G         0
>     =E2=94=94=E2=94=80mpathc1        0        1G       4G         0

>   # lsblk -S /dev/sda /dev/sde
>   NAME HCTL             TYPE VENDOR   MODEL    REV SERIAL      TRAN
>   sda  0:0:0:1079787648 disk IBM      2107900 1060 75DL241805C fc
>   sde  1:0:0:1079787648 disk IBM      2107900 1060 75DL241805C fc
>
> Any idea why this is happening? In case you need more details, this
> reproduces very reliably here.

Are the reported discard limits different on kernels predating that
commit?

Please send the output of:

# grep . /sys/block/sdN/queue/discard_* /sys/block/sdN/device/scsi_disk/*/*=
_mode
# sg_readcap -l /dev/sdN
# sg_vpg -p bl /dev/sdN
# sg_vpg -p lbpv /dev/sdN

Ideally (for the grep) before and after the offending commit.

Thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
