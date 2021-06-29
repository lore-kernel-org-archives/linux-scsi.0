Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D9DC11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 22:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1AFC61D70
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 22:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhF2WEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 18:04:54 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33720 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232398AbhF2WEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 18:04:49 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TM1wMf022920;
        Tue, 29 Jun 2021 22:02:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gSxC7LZ/bZ5q+5odlfehpxKPIjf7UnxBGjfMrWIDjGM=;
 b=LuUlAtOYnGTqV6emhhCJRDgZE2+8mbAOMQ0k+9TfejL0DzOPmC8giLpLXUfRS+UmfFRL
 cyMufEXuGtTySxqz8tq6VlG3DbWS6CLabrbmd5pv8BgDlKJwBIk7rsT50oFcglxaKru1
 9/Exj+z+KUxXsS7IrWIQT3FtUb5BcGYbS1JASeP3DnSB7rwjxneHsiYLT77NCndvnabr
 aqwDgKZYofCNDpfXpekPlWT3ofsH4AvDOhdfgYwGSVo/Nq1hhwlzsaY9NsJB+5aHGTrz
 7iWnAU5rZYbc6xql0oXNZc/TWF8fGumlkPrRRMEXobNiwqGxETBceBghSehI7NmfksJy Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39fpu2jkqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 22:02:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TLtgZw108038;
        Tue, 29 Jun 2021 22:02:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3030.oracle.com with ESMTP id 39dsbyv7k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 22:02:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMpSYmPuSyKPIl3uwa7DE3SjoQ6gBgNYxo0wLIZWj44WuraYHIlwYgjDcGoiFL1NA5tAcUnhfh79n+8wXtJsCNkth2kmN35LqGio/Ugdj2Umu7ZmVtbnGtGxS4byPGcf+bKkLc2TelzhD58VOQ6stI6lM0Jpw9/jO/cHZ0HfIPsEuNf71EzMRrkkXL1l3pqYYTDr0b6heaN0OeTQmXIs7CP4LKGLHaVKLcIFyhg5QFZYwP/fMMGHYpkG3FtINeATeM7b8T15s+vY77GBA2oWseA6oCjLCp9TqrtitVIirpi18jbIPsEgsqIzgJZAyV30P1IMoAEKC9vp1eZ0WzaGsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSxC7LZ/bZ5q+5odlfehpxKPIjf7UnxBGjfMrWIDjGM=;
 b=hcGA1Nb7WLr+CrSwI+Faoi8UYOrofWEoIk+6cfoSgq/CgvglTBLPoaSfZ3JsbmRKb41l5tVzIWZmZsbwLsWBTxEYHIPfTvjbQcTu5jEqfhFBwGd97dHE4ldEByboUsH84yBSRsyB5ExVNgTEM0PPP+i0SwVZyHCsxPpp+Vnf4hd6FLAfC6jvxhc5+92hqRLtUUg0PnscVqvNJ9mvFMdd++rEhLpIAjj6VlmKMbA7eQucyHZduTA4/BYYqIrMnO1V/yahxTvhr2f9mIQ9Uls2Dbr1blq/NuHAaIrPIN+zrQLCd0EFjjZ/2gNaQ37BMWOETALEyemW+x1ar4/QB1w4HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSxC7LZ/bZ5q+5odlfehpxKPIjf7UnxBGjfMrWIDjGM=;
 b=UrKxR1SLmc3I2tVw9X/aZ54DdXJrxC4YcE2xhhA2fSIUAgCTDuvcRYishmIbHBTIZcRAAmUmwDy+vUneuDyarDPWD2mEM2sFfh+x17AyDebfq6hQUJ1JotX2i+ZW6Ay1EL0RMuohNeuJ6gHUIwNqaxfbfJR59ZFhUKWQJZBDxlw=
Authentication-Results: mail.ustc.edu.cn; dkim=none (message not signed)
 header.d=none;mail.ustc.edu.cn; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Tue, 29 Jun
 2021 22:02:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 22:02:10 +0000
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH] scsi: be2iscsi: Fix a use after free in beiscsi_if_clr_ip
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r8kibzu.fsf@ca-mkp.ca.oracle.com>
References: <20210524095039.9033-1-lyl2019@mail.ustc.edu.cn>
Date:   Tue, 29 Jun 2021 18:02:08 -0400
In-Reply-To: <20210524095039.9033-1-lyl2019@mail.ustc.edu.cn> (Lv Yunlong's
        message of "Mon, 24 May 2021 02:50:39 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Tue, 29 Jun 2021 22:02:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a2061f3-ee81-4c91-2c76-08d93b498b04
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB552962D144EA7192198B5C408E029@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3jhzeL+zjG8fc5z/KygujLnX1s7SzmaGLZT5Bbyboya9C/FkHK0BhZbAMPKBPYMFMVXezBpSKiWwj/VCe0FOars2WmOBei6r3GQI7DV8NgcW7G+DZvMvqwRbZVgotpjQcX6SrwvxxaN3XD9pNBFij8POfXy4io4YqfT2buoEl5GF17ObOROfyvgPn0CJrWk+hwVDaE3In3LOuRWh1A4H2JKIrxEMC21VFW8SSjPU7REQz81IPAIowgl74SWT0MrYSo1SwKJ5OHTFPNZ0a6zVsC9kTaiJuuP1HUQ1+kAKv48X0n0EpyBZEy+UKMJyaLYUxeMgS727jv+JOiNUJu3lGoiLCW3nmqYIgBY5PH5ipu3L6mCly34+bfxLhsHwrU9zWt1oyzFiVh4tWyoZTn2Tq/SSDUwZA5s04A7gpCHqe3OBZi8v8JV/6xCcrLN7viEV6j0aJ7BSQEuSlfG1nlIpyPb4ukBIhcQWJUbVlhf1zXKaaNAuP3i7kBbRt8g43hCjxDWnSm5vhNx7sTbCrAal7B7iX946q1UXTmk/ngSmEYxXA5ij6kn8aRYLVWFDesjkmS0M7KTAPV+506xEEOQYjHmQxFGOF1VcbTQ++hmLv9+NGFAol1ZBW1zJzyam9U+rioVYlacytD55G/TwL+nINc7zGXl4JjRAMuN01/4OVVDaiwymeHZSkr535k6WiqRuEKoYAoVfW09sAGltZKzSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(39860400002)(396003)(2906002)(316002)(4326008)(8676002)(66556008)(8936002)(52116002)(7696005)(107886003)(66476007)(66946007)(36916002)(478600001)(86362001)(38100700002)(38350700002)(6916009)(186003)(16526019)(55016002)(956004)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8O15a+T6lFRprLH4PdVTGERZjQnGg4hEO9g6hT27GE1j+0entCqgfsF+2ROE?=
 =?us-ascii?Q?HlDvt+ORwbMLgVhNoB4X1Bwkx/6nFj+XXdZWMWfXIOtI4u6OMOtU1zDdUVwF?=
 =?us-ascii?Q?KxNR4+SyTFVUxqiZjWi2uIn2epREhW22gTl4ysCHLtrjJUKnrFhnPW5bMQfQ?=
 =?us-ascii?Q?hsrZRDy13SefUJBIPTyaD5u3NFxTUpTx6OFpABGiNf3RIj+GHUfm7EwzK0be?=
 =?us-ascii?Q?MpGKCd6eg3mPArVgJZDUHuv57L0qRW7333vHgnjK150Rx0UsylhoEr48uj36?=
 =?us-ascii?Q?P+eT7oSTjMXrkHQmLHR8nZ2GfvDZX877iu1d0aIWnwVRKLsxr1ONWcSqV5sD?=
 =?us-ascii?Q?AWdXHaRKEluC08/ryEJ/GXSignMTMSbLywnDsFit70ptdatlpzI8Rmxw0CEp?=
 =?us-ascii?Q?NFm+wpqVShfcKMtTBvcEZwaWW71uCiYA7I7O2PbqKqEkCmw7VF2LkxXCvh3N?=
 =?us-ascii?Q?tugL4N6Vr6+Z8zj6f3G9R0K1MnMEJ8gsYHLxcVZnFBlzYGmVljhh5SVuVLpz?=
 =?us-ascii?Q?gIe0qYLDUY0LnrITdPgZ8BL7ItGN49hjUhtO08ff/jpfgQ0mHl5zZ7P3z8pJ?=
 =?us-ascii?Q?Y/Zp5sgF0PVBgxYcTWWy319LOySc/RzVud5LIuzAsa+jczvTRceMGBVCwYlj?=
 =?us-ascii?Q?a5DY9TVEuJhupKd4l3JBdewzZonN2wqLBzkj3cHeqrb6/71dyMEBgVxuOzMx?=
 =?us-ascii?Q?ONpGbYX3jBzhxVSQXSYq3gr4dvbbObIIQX7USr8bAKoxHpDpZ8Cz6ILu06Hx?=
 =?us-ascii?Q?8ltpQEPQUqPC7U5nO427HrVAJimMXDQ68YFMyTzTyWTAPdz0ztxvB0R8NlZx?=
 =?us-ascii?Q?Bap9FLq90Qi4556GnIag+weAmaLSMJBbEfBf3455ogqlv92MsZXZ4C9BNxq5?=
 =?us-ascii?Q?uYbImN/A/846HK2nBnCylav6l5WFGO9fMZSBt+J9zQbaM3P+kjjaznZsL2Xg?=
 =?us-ascii?Q?EQ/6C8It5ir5VoQWe9lCA4nOUUzdE7E3IePOOPPaTQYcia56QHL0FiYaM++P?=
 =?us-ascii?Q?nxhv7w9xj68zMxcZZQ2efeW9Unm46j1H7iLbuc5FizfQCMqvUZRyJQPxGl0u?=
 =?us-ascii?Q?PmJzFms4RIS2mBIuRBl9FC4/jeRwi0czyTvp3r19t0sW8gDcCqea/1NoCQcH?=
 =?us-ascii?Q?78zhxSnNEPVgJPR7FCGVo1/dKVpOWSZ59WQPn/dmkxtj042ls/Nw2cdlsmYn?=
 =?us-ascii?Q?vCRu7XSpZAzViGd0fRw2LaTjOoalRXDpTNKHLV0r62PKYFAwmQwL0VqHB8GG?=
 =?us-ascii?Q?wqHk7Fh/dlxTUv/uTylSCEkHg/1GCSVVDoJPOl9vik0ux1CPjf5O0R7X9Eg8?=
 =?us-ascii?Q?j+4zQTqudoeh99zpfVbxuupI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a2061f3-ee81-4c91-2c76-08d93b498b04
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 22:02:10.2634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0RTYY+NVR/MSy1BQBqAFX5/JYoDwvlHsG+ysZDJcDpHS7gaFOksMZ4pn2vJVlcLU+71obQz+kLXswQyTbrfnoLIGn+UQOjWwokfAOg10tfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10030 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290135
X-Proofpoint-GUID: W_SQpGxNk_fgcKAcU_7F1_0O91Za-9_d
X-Proofpoint-ORIG-GUID: W_SQpGxNk_fgcKAcU_7F1_0O91Za-9_d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lv,

> In the free_cmd error path of callee beiscsi_exec_nemb_cmd(),
> nonemb_cmd->va is freed by dma_free_coherent().  As req =
> nonemb_cmd.va, we can see that the freed nonemb_cmd.va is still
> dereferenced and used by req->ip_params.ip_record.status.

> My patch uses status to replace req->ip_params.ip_record.status to
> avoid the uaf.

This status is captured prior to executing the command so it doesn't
actually reflect whether the operation was successful (which I believe
was the intent).

Some of the callers of beiscsi_exec_nemb_cmd() pass a response buffer
and a response length as the two last arguments. Since
beiscsi_exec_nemb_cmd() frees the command before returning, passing a
response buffer seems to be the only way to get meaningful data out.

I am not sure whether the OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR
operation returns something useful from the controller. As far as I can
tell not all operations have a response buffer defined.

My recommendation would be to add a response buffer and try to decipher
what comes back from the firmware. Also, beiscsi_if_set_ip() appears to
have the same problem as beiscsi_if_clr_ip().

-- 
Martin K. Petersen	Oracle Linux Engineering
