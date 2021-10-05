Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D38C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 676F46136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhJEEgt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:36:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47094 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229659AbhJEEgs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:36:48 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1952oRL8024407;
        Tue, 5 Oct 2021 04:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NIJaX7jy6rkk1VkyNNPFE87YCB09uRcn8t6MMa2rgpI=;
 b=AWTAyI33sO+asplM2ZWST8D2It+Hc22tsOMc4o6Kun0KyYUNtcNzVzGrck1+6s0IhPGq
 49SWZ+1Q8ixhUHCI0lu4Dejzb6KVoneoVckC8jvFBrmBpPr5f2oH9T0o7btMQo95fKzX
 0Hnt+eE9U/8xengTOdZAZRfiJ8/22gZFB/14QHBpgx56RQpys2+dqAdWydI9vMnNUQhf
 i/CklJvBBhPUS/dWHVvO+vxVI/HkcN4nE9LAWNDiEn/IYlBJxfOYtzv7oa7UHpDLiGri
 boTOvkhtOugly/wD70YGkVptDCYgn5ATjhJwABxgjaGqtFLvTDGPnE6hpeC+ne+6S/gK Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg454chmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UJMe054346;
        Tue, 5 Oct 2021 04:34:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hvq-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZzPiG6TD7X042d7DqmmU41jslWYJgx6vXxedWqaSXmVteRuo/aVsrTy61eYrCrgYak3fbMXIkNVo1XuFBYm17RgyjJS8O8H8I8n5ot8L3sS6RleCME0a6rnlja/tsweGgPdyMR0Osgc02/8wLNtZnS4R2d+Ed6t5H9mrR4OA4b9T8AEWDXPvAfBi34KGpYwNpGx2MZNMNJkDD3kmwUUPh0BSvzAn8Gik8nUSLodqID5+GUBKl0EvfQ9JKkCn5vvQiQvD0aJVAY0iXhSyltElcWy9+CZqCmcb/mluQG65IGIXP5HTHbBXuDGLFD0y1yERAEXqmJ5j5Lh/XV3+6j57g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NIJaX7jy6rkk1VkyNNPFE87YCB09uRcn8t6MMa2rgpI=;
 b=kx7NKdwvRsfBaYUEEzm/227eMaRJGoSPE27HeT2gs2a8cKxDYSgwmrucnaNFiE5jbe5RGB/RZnqOLgoZcV16PuNkjLIew7vcO3zAcT49oHqlVDO2peRXGh9s/j9MIEoQzR3Qg0T6BHDzg61DtBGapkghpKNmaMrXLloqu83qrrR5ra83XOceVkP7xy3j1PQSwmA3TJtxFRTVtqke5jRhaJuzA3puSxSzNZhihHSHkZQ3u9pG8EKLQ2BPfKo5+Ll7BL9n42zP3Qu7KyXKPnpNGTYPRf/HuiaLl7+mJOMhYiCrF7AOPp3Lh2Yxrr9BXxG/kLbjFWNztKCI/huI4ENSrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIJaX7jy6rkk1VkyNNPFE87YCB09uRcn8t6MMa2rgpI=;
 b=AAYtehTpbCq6fqlLmHK4XCfJNZWQHEzl2G2QrFM3cphtS0fbkVZ8axRu0VKq42HZuzDcb1nAJ6w8esm3EULeGrdY2pxO7oGT0InFm3w/mcrmpoB+mBzlDu7ZI2A2S2KUpUWANDpS6aVLqdRmkJFD3DiDhx6Qe6XZqsTL14DbBe0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1950.namprd10.prod.outlook.com (2603:10b6:300:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 04:34:53 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nigel Kirkland <nkirkland2304@gmail.com>
Subject: Re: [PATCH] lpfc: Add support for optional pldv handling
Date:   Tue,  5 Oct 2021 00:34:36 -0400
Message-Id: <163340840530.12126.3880818621804732521.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210927183518.22130-1-jsmart2021@gmail.com>
References: <20210927183518.22130-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9589882f-df5d-44cd-468b-08d987b97996
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB19501308D973F72DB9B8E4F58EAF9@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /bdLnuadABkRdA9/XM/jhyo18guhiMEjFacN3ZQ3hiTdNy0MKibNCMPm7kTBvfn72u5grVGRotsZFGduwKzrn6MRn1liMVr6IFTZ+MGo22GARknf61fjTVyPqy7W5Zj3wnyyB8ygjc7/a58G9fkENZOBltETJ8uSVSGHtHUo1L98xhqeidX7Y1N7N9Ee/QhX6FBVsal5oGjwTEsRP7z5FtFf5mbgjMgkPxbuQAnfvLCqP7vap1BBrrPEgCEIumuivbaNb82gg7SfLPt1awNyI06HiIFXI8IFR+8GUl2/d0ygHwoQI1XWwh0YFKcsHqWxbvyml77TCy0+R9ixYS9Rh8vAO0KPJPArTqvs9j7wcXR3W/DUuJ5sH3qR5O3E/1BlJ46VicVVCPproUI5sxsawYW9nAitoar0oHOSUmYQVwq2//xzef7i7K3O7fPLzwsUyfiotpVWgQrL4CWrxhAIo78k7lBBowfZNMvKkYAh7ZoHcSKV12zl7uzdB+1Q6byoCcw5zSDzeMu7ItV8ugrIzGzgR7b44zlBEcuFRWXnj8J4PW5REQoPAfaHoTiiAqGRTB/qbpxzKzu7lL5WROvW6j9VXo09fWeXHI7K3YBGgjhcur9QHp1Yo77FHDAOTXyubIWHm2hy4feyHZm9C7cUdL9XVRytGOKPrWLePlm0MdMBxBQMkBhreQRLiBNj7OOddOI4NhqVVDZSex5jGgDaQ+kanYu6aSDt8YC85P6MBJ5Vs/AoVSUb5ylSsiuwgfEcgU1cWu6dJzvgarP1/0pOog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(6666004)(956004)(5660300002)(6486002)(36756003)(4744005)(38350700002)(186003)(26005)(8936002)(8676002)(66556008)(66476007)(103116003)(316002)(54906003)(7696005)(86362001)(4326008)(2906002)(966005)(508600001)(6916009)(66946007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUtSbUdtNHRQcUJvK2VHNGUzVkc3ZDJoaHh2WEorYWVocjhIVVRiVU1kUWJv?=
 =?utf-8?B?MUlVaGl0OTI1cWtnTGlEV0w5RzVzVjdVTktxQW1EcWlYWThQTnFia24rKzBl?=
 =?utf-8?B?TFJqMk5EYkxCYkYzdzlTaEt2bUVPdkVMMnlEY2ZHNzY4Mi9ueTZWaGJ0eXc4?=
 =?utf-8?B?WG5XT0FsVU5NZTlxVFYySG9KYkZFRkZ1ajR0TGFhZ080dEd3bXd3R0xzRE45?=
 =?utf-8?B?N2lRa1cvZldSZGNFWUgzQjVUQkdhYi9hRlQwbzE2Rko1SURhNGYweExzSGdl?=
 =?utf-8?B?ckZmUmgzZHJDWG9zOEpNNjNSRkJyVktQVlpLSXpJakpJMWZ4T0Y5SDVQd2lJ?=
 =?utf-8?B?bWtmR1lmRnFNZ0M2U2twbmNKR3ZuY0tYMW1sZUtBNzdiZXVpWmVJQ1ptL0xM?=
 =?utf-8?B?bHExbkF1T09XbzFDR05kNlNTay95b0lrY2xxVlhzQTVxdWxXSTdnUlhyT051?=
 =?utf-8?B?U1VYT21LSTVod0NjTkRkdVZPT29keTFnZkZxdjZKVE1YSi84OG5KRU9OY2Zn?=
 =?utf-8?B?Q09nU3JQUnRmTWc2ajdrV2grclJucjVoMDA2a0praktEcUgybzYyUi82Y3lv?=
 =?utf-8?B?YkFCelF1bllNRUx4VEF2UG5PYVZnU0JwS0tjelc0TnBaQzBOZERaYk5CZGFT?=
 =?utf-8?B?Si9vL0I2NTNNaTdabGJmV3VGQURMQUMxc21SZGVNTnQxRXpUUDk4dGw5b0dK?=
 =?utf-8?B?b3pkSWc5bitwRUEveVVhUnJzQm1pbnVHUUNvc1BKQU1DSUoxR0pZRzFxT21o?=
 =?utf-8?B?TUIwRmRUS3F0cU5hTmJ5ZWxDUng0K1ArbnNyOWlzNW5RampNbGh1bmV0UUlD?=
 =?utf-8?B?WUx3Rmt3Q3BCSHVVOXNWeGN0c0FaUHRMK2JNZzB5N29PV3JQMi9Md3c1SE4y?=
 =?utf-8?B?WkpjT1lSSVVOUmlTOVhkR3JMMHU5Q3l4MTgrYzdkeWlsdlZmN3M1cTVndHlJ?=
 =?utf-8?B?dmMvd1NDUWZxWjFPT25zUDdleDBoUmI5N3NabFBpVXJpeUgrZncwVjdwYXVV?=
 =?utf-8?B?Rkl3UThiU1NIclhPWUI4a2w2RlhBV1BXM3lGaTE1eVNFZzg2aTFvVHVXN3g4?=
 =?utf-8?B?K04yM1ZFamI0cWI5VElIczViQVp6R2FiaXdTQTRRcDY0SjVHUDhhWnBzN2lW?=
 =?utf-8?B?TkVlZXk4andEbTBDaGppc2tBdVlmVnZEY3ZYRFJGN0M3SlNMdUpiL1NOMVp5?=
 =?utf-8?B?RUZrOWkwSVRscFVjRWZZYXMvWHlnTmI4VnA4U0xRTGxGZ3J2UlV3OUlsMUN0?=
 =?utf-8?B?cTlhN3o4UWRCa1VZd3dxVi9Na2lMaUQ2cC9jaEJEcXliZ0x0SzNjU1llcFdt?=
 =?utf-8?B?NXN0NEdvNThuMjZqVUlmZjlPclVudEgrT3Bqbmc4TEdrdXBNWWxKUEEzODZC?=
 =?utf-8?B?alBQdzBpTWtuYS96c1NqdGF4MU5DVjJXUFhQUGx1aW5zTW9LcVh4WnRzbU1F?=
 =?utf-8?B?Ly9TMEgrQ3QzU0xHQ04vOFpoN1A2VFRjMWl3QVVmbUVYRHRFN0dPeFFjWUl5?=
 =?utf-8?B?VDlPMzBxN3NJeWxMRkRMWUp4SlBwSG9KTmxTbnNBeEFTZnB6VHI3SXkrUUxy?=
 =?utf-8?B?M1NTMEtpN3AwdUlURmRPOXRzTmZWcXprOStjTTFSWEg3NjQvU1llV01DcHMx?=
 =?utf-8?B?Wkx3SEZ0Q2RKRDhPd3pXeUU1ZlpzdVFkWml3S3R6dVZqdEZUZkNGMkRmZ3Zt?=
 =?utf-8?B?dkN4cE9pL2UzY2xmQzh1eXIyRVNnS3lZUGhMYUhVTGhtNHBHQUpPeUEzNk1B?=
 =?utf-8?Q?BsvQ7keCCjfWi65NysJ5jeNI2Qou7Ng8HbozjAl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9589882f-df5d-44cd-468b-08d987b97996
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:53.0636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phM+t4X7oKW+S+0RrYT6PcCggAvbfNUW2sDyJzM7KVtW8scIgH6caUf2EfGpxOpP0WnEsDKKJPAjMRfhR2aureZlztKV55YjXbQed9oCNW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=984 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-GUID: vHFpnPOWxZXTzVsLE9p18KMkQXtmyz_o
X-Proofpoint-ORIG-GUID: vHFpnPOWxZXTzVsLE9p18KMkQXtmyz_o
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Sep 2021 11:35:18 -0700, James Smart wrote:

> At adapter attachment or SLI port initialization, read the SLIPORT_STATUS
> register to check for pldv_enable. If found, the driver will perform a
> PCIe configuration space write when attaching to an SLI port instance
> that is an LPe32000 series adapter.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] lpfc: Add support for optional pldv handling
      https://git.kernel.org/mkp/scsi/c/a5b141a895b5

-- 
Martin K. Petersen	Oracle Linux Engineering
