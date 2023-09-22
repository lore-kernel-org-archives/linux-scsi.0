Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637D2E7D0B9
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 06:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjIVGbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 02:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjIVGbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 02:31:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53932FB
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 23:31:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIspRl008336;
        Fri, 22 Sep 2023 06:31:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=AgsJQID+/cY5OBrI4j4ObUjO3OhyddR3KvKv4JIREgY=;
 b=SXTwLG7gZ7YeIW2q0tiUMTlRE7TntdiMeC6jcBhs21XgpKU5Xc92bn6Ri0OUniVdYhPB
 SJyU0aZnLYJekE/hVxMAus0VyCd+QqIg5I+Nlol9iDMIReqV/EH8BzaxYzRkJfI65XoO
 Vd+Omddvjz181X5J0MsI7H4z90NNfMgY07B+XFFRv9xH/34BAe3e3i189KgHe7N9Abpx
 cRYg5b1qygnIMfgW1MQ7XJ+s9UiuSFuB2gCgrRx8OQ6LLGBDvTVGsSAQgOCHq68sjhYK
 ZtNIXAj7rOT3BO7bugZRRf8FOa98yNbSRQQ7IN5y4jjKgVMLPBvCnS++6XwqAO8WIczE iA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsvry27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 06:31:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38M65m7c029947;
        Fri, 22 Sep 2023 06:31:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhcastf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 06:31:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iedT0l+QUhLCnBTzWEM6i+bqc4aZqLDqcwi9E6xBA6Gf189+UI88Nj+luDWOqe5hLo2Lkq5/v2eY1Jyz3pfrxnwQiDTP8v3CpTfZwloV9T5X4y61T06Ow2pV2XAcw/8VW1qGdeQCJBRE90nipA+pgR7VZh/C2Gg7frub51EdAiocc2Msi2N/wgbKaErSESGkpFG8sxohp8LK06tk1wfS44wQ/rMP93NDQ23sWY3Wd+OIYwTdHhxbJvz9gn0hrncpjoO78R9/wi+2Vx43UPU9zHJHsoX+YBR3LhGyz24R/PBMkszj37fNJfrCeTe9R3v6koLNPzQZqqNDIIrpPv+rgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AgsJQID+/cY5OBrI4j4ObUjO3OhyddR3KvKv4JIREgY=;
 b=Ps3+/idZn3sQBXVWK1kFYPDN9KtMniRRaPujzz375Dzrki0jkwgKskmBXrAOSxcUU/7AB0gZ1o58aH0G50pgDgI+qwIcbwNIS/9Bv7knFOFGDo0d42m5n2t42AJuAEot3AkibU26JR7z9FhXDJF4BBojEzaHFHELPpMvINd+gjT4Rk0jNZsqQZb4PibNMgj/FX/Q9FXj0cNfyh4OJcm9hcC9La0E1KZ757CdeVeFjzv08x3QpzD3zyarAkAAW2iPy++l0SBh7MLenJVP913gfQ/UOJZsR91s39Tpp7Fd7Fbmh2fMV/578Fvgywfr5BNlgnOlklj8/+8nr6SL0cC/sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgsJQID+/cY5OBrI4j4ObUjO3OhyddR3KvKv4JIREgY=;
 b=lEn1SiDilJ6S+eeGnCcoeowQVqm5Gt5jxVMUEpHkGzBMjEVKpUHpYwqexenPIkz4C19Biku2sZaqXPKVvbvMNsps4jeC0WVO465Jbu0eqdDkJEzrlND41uVhSX0gT5nsvLejoDXbzxOfFaTmL5is1qRoprLyJxwf5ihYOI942H4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7184.namprd10.prod.outlook.com (2603:10b6:208:409::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 06:31:21 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 06:31:21 +0000
Message-ID: <37d8db34-a945-4304-f95e-2b9f4e60191f@oracle.com>
Date:   Fri, 22 Sep 2023 07:31:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 1/4] scsi: ufs: Remove request tag range checks
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, daejun7.park@samsung.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230921192335.676924-1-bvanassche@acm.org>
 <20230921192335.676924-2-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230921192335.676924-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0102.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7184:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c55f35-a455-4184-08b1-08dbbb358941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hiJV64aFtYNFoNXx8NHRYRbptWuiNJK7xHKJHtsiLnPtcSJplcw0dYSgiL8lFVxJi31EBz/8zpKfx+fKhmYQY77Hvayoib7u/lSdSfYGBH/21MgaV8CB8ceFeWAWgR50jg/XePIN0XomSaHRBYVRAOyve+MdvR+m2+5MFQfK48zcgKwHeh1XJyo9oWuORQx0j+IzxTyDbxMytmrhJi4kd3X8W+4GPQ4Vauoxn9PziNuXAZT4j1LWfusafTtoSGLPinIbwp5kc632ak7i2G5U31urqYiV9AifDHypbdMzPeE0sBmpQ7LEig2/HxrNO53elSyjRp+/a98cnuezgVK1ScVufmCp3OtIBMLoCZwkbw0KcSjzSqhEjrRueZUBqLinSEN2dzXJU4abY1bqK/aepW2Q81gtoLWlJg1SmbdKGYnqhhp7XTJf2AwS50qdPgU2LvufEzLG09vSDpRh7GlXTr+KMJ8Q6HxK5eGHMVMrrM78R7UhF3lv55eYzRhNoiWyYmpfBLn1enPQ9Kp4lTDfDP6TmgvAKiECUYWrFDSOzaIsZSdlY3wVcrNs571bjH4HGJd33WbX/qEVOs/4Vo8NB7nz1v/zv179OwyFIjOZ73yzZejE9v1DOSO/Xc/GSW7n1nsD4I21DFlTu5xhUDzqyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(376002)(136003)(366004)(1800799009)(451199024)(186009)(26005)(53546011)(6512007)(2616005)(6666004)(6486002)(6506007)(36916002)(36756003)(41300700001)(6636002)(316002)(54906003)(66946007)(66556008)(66476007)(110136005)(7416002)(2906002)(4744005)(86362001)(31696002)(31686004)(8936002)(8676002)(4326008)(5660300002)(478600001)(38100700002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzhOSE5OZlRrQW0zNXdScEREWjI5YXpyazRtNVIzUU9qTFdndDFsUjR6Y0pt?=
 =?utf-8?B?NjNhU2VQVjN1YkNEcG1BcDlSeUllSnBiZzRWNDA1bmxPQk01OThqVHp1V3Fx?=
 =?utf-8?B?akVmNjgyUHpJaDJLOUUyVzZSTVNXQlViNXhsUlJKdzJBKzhIbEhlbCs1OTdt?=
 =?utf-8?B?Q09UR3RseXVoaW54dHF5Q29oNUYvdGNhb0xGL3YycWg1SFVvR1krRFZMd2V5?=
 =?utf-8?B?YUtMRTRaeDFqZjRpcUVmN1lmeFFFRjVscW9nSGw2eTVSZ3U0R0hzdjR3L2tO?=
 =?utf-8?B?RzdWWTlPZWxYbGlDblgvdHNSazdGUjJkOU1FZDZsZi94d2IzMmttdW1WZDVq?=
 =?utf-8?B?RjhzYVo0YVJ5V0d4K1luWXgwOURQMTE1K0h4TmpmbmxleE9VSUc4WDNJaVhU?=
 =?utf-8?B?di80bFdWRUp3aCt5OFREYThBZXlyb2cwZVc4czBJVDdmTkhUV09HVWljZjd6?=
 =?utf-8?B?MEJTczkzL0JmMjlqODlwKzVRMEtodURnLzBnNHVNWStyZSthS2gzZUkzNm5s?=
 =?utf-8?B?UEozUXh2ZjhqZURyMDlIVisxVnBITHo0MHpYTDRnZVM4bXM3cmFwbFVOYy9h?=
 =?utf-8?B?d21oRGh3V1dxUGRJbDlXVkhRQm1VS08wRlA5UlZFdjA2WVk4U001SnUxNEta?=
 =?utf-8?B?bVdMRXIwUE02SEdyaFg4WjBjTlAwRytkeG9ONWMzMWhaK245cVdXTDBqZ1Iw?=
 =?utf-8?B?K0NnMTlHZDUwS3NWM0Z2ZVJRNnd5RlB6R1l6QUtVaXoyZEc4RCsxOG9COURj?=
 =?utf-8?B?WWIydXRpTHY0Qm1YQzd4VWR6VlRodm8yK3dXOXNsZENTcmUrU2VNNFhSYTU3?=
 =?utf-8?B?MWMyVXkvc2s2K3Y2Rks3ajFlNmhmZVIvanF1T1lxQlFSM095R1hqUm9aYVdv?=
 =?utf-8?B?ekZzdk5nZHdFNnhOcE1tMFM5QnEzUFlkU1l1TFA2LzZFRkdyajJubFZpMjJY?=
 =?utf-8?B?ckkvVkJOdTRqQ2NxWTZDeHpWcFhKUEZpdXpEaHJ0b1lDUVIrS043d2FoMlow?=
 =?utf-8?B?UWZJZXVQRWlXc2U5RWliM25LRmIvQ0lKNCtCeVIrZjlJNTNaR25GWUJYeVli?=
 =?utf-8?B?SVBxTEhRMVRRSkJwN3I1UHhTeW5qVWxKdUp3cCtRaUdpTE5UaEk2WjM0L3Br?=
 =?utf-8?B?anBVZU1kV1JQZWdoQjVHODBmVlcxMG40M3RJOG1yNlVHYlI4dm8zYmNsL0VI?=
 =?utf-8?B?MW1qbEltT2lSUDJMcHdrck9MZlFtK1dNRzlTWTJ6cWpyVjBZVzNFaVMvaXVx?=
 =?utf-8?B?OURVaXFrVEVVSEgxeXZyT2U4bTJ1RXNPK3hmdlRXTzNycVF1TjE3czZGL3d5?=
 =?utf-8?B?bzJVMW5nK09lYjByZ1dickxiQ2IyZXB6OVNXbmJseXdxRFY3cWFlWXFkbmNG?=
 =?utf-8?B?MkU2M0EwMnRvbjFUSnJxNkhrTjMyeEpZemx1U0N4SFpNSk5ZMmlDdTJTQWJK?=
 =?utf-8?B?TGpteE5wWGQrYkJsRmJZYWxuWDhpVXlVK01kbmwvQyt4UUpic3RONjYwdm51?=
 =?utf-8?B?aXFyNWpKbkdxYkpnMm9sWlRFczdRcEl3Sy8wRjI0NGxCM041U1hZR1dxSHN0?=
 =?utf-8?B?TE4wUTR4M3VMUm5qTXRIRDdJZ0t2N2tXSFU5SUUzd1ZxY0tvYlpGQk1MS3Bi?=
 =?utf-8?B?dGF4M3JvajQ4c0RxbUhDSkQ4N2dFVjlDTXBKK2Z2R2luMzUrSXJ2V1daYXQw?=
 =?utf-8?B?bTlmMnUvMzBkWHNtbVBQZGVTTng5VlAzcGZSVktnZ2N0ZUl2YUh5MUlJYmtM?=
 =?utf-8?B?ZVRYVEd0MUlvQWdUZ1F3RHFJN0RjWStqZnRQWmgweVlZeUlGMHJXb2xHVlZn?=
 =?utf-8?B?ckRJNlh4dmYrZi8xc0ZmTlk0dHhjdjBoVm5BMnpOdU9GeWYvZjFyUTYwd3BG?=
 =?utf-8?B?Y09VYVBSTDc0SzNMWFJobmZObkQ3Z3d1YWNTOC9nK0pmRmF5WmNIdlJvLzhF?=
 =?utf-8?B?ajFPMjdaNWdYaFhnTDZXOUJDWmtEMEhwRTBEc0Q2UXkxc3I0ckJlMkVkTlB5?=
 =?utf-8?B?VmFxVjB3c21tOVhwUjcwUUVFWXZyMTF2ZlVEOEVveEVXWVU4K0IwOWhaTVY4?=
 =?utf-8?B?bjl2OGEwajRuc1Y0QVZWcVNrd3g1TXFENDFhcFEwRmFQNmduaFFDS2JJU25M?=
 =?utf-8?Q?OhtSD+lvEZTgkiHL8Me4xi5IA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TW40OWExWHJyTWN3eDhMQWRtREdVTitzbm4xV2szc2M1TUs2V2tHdXNHUnl0?=
 =?utf-8?B?YVhnREZyTDU2VEtVMHZxcXRHYzlSZEpmdE9TeklTdUZSTDZRMW85TTZYbjI0?=
 =?utf-8?B?VTN5RmJLaTZYS0E5T0hkdkVqY3JkR05QTnk5S0hHcGovVDJWRVYzdUFUZ2hK?=
 =?utf-8?B?Sk1KZGdiejQ5R3FqVTNhQ1BONkliNFhpcEJqZllaRXBoYzNPbG0vMkRPSkxy?=
 =?utf-8?B?ZHNpQ25PcFhkeGVJYko5QWNSUjRxWjN1ZzBiZ3BKRXdzNjZiY0lsQTBMSEN4?=
 =?utf-8?B?Rmx1dlJacXJPb0xaeS9UMVp0V2xmYUlSbGFWRXRzM3FNTjJGcElPZkJDRVNt?=
 =?utf-8?B?Q2Z6UmY0KzJ6UnBzcDdjallLZks5YUVEY1FrdmRqUTdMR1FvekhsUC9HRCsx?=
 =?utf-8?B?ak9CSDhwSzBSTE1BQmhaazI1dDNCYmpqV0E4UGhKdmFua3hZemIrMjd0ZThj?=
 =?utf-8?B?cXhYSXBhYmlFMmdSQXJxTXB0a3J2SHdIcXd0U1NISVFkOTRNSXhtWjVJTmNk?=
 =?utf-8?B?VVBObVZoVnh3Q2lONXVyWlZuWTJzSkNkVEtmN0twSi9qZzROaDN5ZFdkSCty?=
 =?utf-8?B?Y1VtWFRGTlZ4Z0hwOGxTTFpOREZTRlRPTWY4YkZnNkdSUnF3eTFNMklyR2d5?=
 =?utf-8?B?T0NJeVJsbXRpYTdFcnhldmpPSzRjRWY2U3FYVk1WMm9oSVpNSTQxWGlCUUlF?=
 =?utf-8?B?QkxwalZkdXJ0aUpPSEVTNVpZeVIwV2pMT0t6RDZmcENqemVFcng2bEZUK2ZO?=
 =?utf-8?B?d3hkcWhnY2RwMWVobGFlMTU1dFdxem1kb0Z5UFMvMERJQ3Urc0lPcGZiZ3Vo?=
 =?utf-8?B?amUwRkVUNElDTERHSG5VdmFzb3IzL1JLODJ5L1NtMElReU0yWHlHZ0JxY0M4?=
 =?utf-8?B?MGYzWlJmTk9HUFN5QzRZK053SEVObG9zbjFXQThsNmhjYjdyOWQxd1VzNUtx?=
 =?utf-8?B?QWRxZjA0b2lJQTZmUDVDOVFLUTk1QmRMaTczQy8zc29NeWtKU2lKQVB0RmJV?=
 =?utf-8?B?eCtCa2trSkpJVnVDbmtoeUk1a2t2MnBrZ1NGQmdYbGlzTGNXMzVSVlppVUdM?=
 =?utf-8?B?ZGRZTzVWZElXZHU2NjQ4emNpSEZDQk9tR2Q0ZWlaY2FjdGI1UUw4MHB0Q3lr?=
 =?utf-8?B?Mm5sK2dOejJSOVpSbTh3RUdQT2M1WkNmSTB5N2QwWWw3cDZFYitxd2F6RUZU?=
 =?utf-8?B?ejA4NStXa0xISFo3SmpsWGF6MndhVFdocVp0TWI0T0V4YVdsVEVGYUNsaWRP?=
 =?utf-8?B?akFDcFFRSlFsaFg0NTNzblNPWXVNd1dHY3phbG0xY1RTZWRQQ0hvR3d2eWFq?=
 =?utf-8?Q?TLuCmbpT5LENzNxAfWtqfsm2DnKKFgC6z2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c55f35-a455-4184-08b1-08dbbb358941
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 06:31:21.6204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mchK7rC42T63TgYoM3a70z8PC16yaDRWIssHsvHBCb0W91ksGHJdW3rD/qOoP/wU+eW8ABK/GJUHHLdKvTINzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_04,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220054
X-Proofpoint-ORIG-GUID: X2afOQ5KKi6cj8fg6K7AP2uEYApdRsPI
X-Proofpoint-GUID: X2afOQ5KKi6cj8fg6K7AP2uEYApdRsPI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/09/2023 20:22, Bart Van Assche wrote:
> The block layer core guarantees that tag numbers are in the expected
> range. Hence remove the statements that check this. This patch suppresses
> Coverity warnings about left shifts with a negative right hand operand.
> The following commit originally introduced request tag range checks:
> 14497328b6a6 ("scsi: ufs: verify command tag validity").
> 
> Cc:daejun7.park@samsung.com
> Cc: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Feel free to add:
Reviewed-by: John Garry <john.g.garry@oracle.com>
