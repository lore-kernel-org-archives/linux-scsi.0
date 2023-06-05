Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E58C7EE2C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 13:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjFENte (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 09:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjFENtc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 09:49:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BBFE5;
        Mon,  5 Jun 2023 06:49:30 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355BuNX9006746;
        Mon, 5 Jun 2023 12:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=j0YOcYNqyitLPDpVBI6mdJtqlxcs8GABd+J/3a1gzpQ=;
 b=Y4ibLBVVm/Odl6gerg6cdtcsEZXM4suT1BDxIvzyUvEEY0MIZJOb04lUs27BmS7RZGvB
 C4XY3r+9WSzFfLDpo7zDOpJ97I+IhDN1f3fsE816sVsgXcooAX5yOQplnBifER34TbPx
 JxFvIlaByx4qS7JYydBrD7zm2FV/H4MPN4MKAACWJ3myMTwdsfZi8ItQfX1bw13rVLgO
 xbKQwIWYNOAhHDy07YeB0/4JdSZaf318kc4HdpZTdQlPRdXXtYKgafk0MKKsHwJ8dskH
 ejbskEAAlNAWNxAHrua5zptdT+yKsqKd4Ik8HCjGl3YzMpr+9Rwoy4ip9KPWfgteRsji TQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2n2taj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 12:33:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 355CNAYo020196;
        Mon, 5 Jun 2023 12:33:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tsw5mbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 12:33:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noIxpthJihmfeDmBS4rPCGKDUPec4Zx1an8g4BWlg2ZIETAOwV7sWI2aedEHk1sh+PW+3wXs0rki1Svk0kroS76d6CSC5zcjC83yp9fqDEOBwY8bt0+APi0doymBYY5nKksFenEeujIi79/Gozud4DFZ6MNLNleaRUMRdeuDNPJVDiQ0/tOXlcnjDVsATpyzycrrtbRuwfDdQ5hBbLqNN2yoDWBWHtoHuuEtibrkhmIvF7lfuLpUgT2SLDwvDlC+WFldz+zCUkMWiXmQVlkT1y+VHOlgPuVrz4fL08qc5JdRiRHI1erYkBMj4xBUaV/VqxKiBmHxY8MDwlhPsaMN/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0YOcYNqyitLPDpVBI6mdJtqlxcs8GABd+J/3a1gzpQ=;
 b=ak073qgLJnWsvjH9RxOcYYheGsmpf+HntrW/pp/wiPVjd6Wro7UkU9YJ9cWc0bz4LQX3Nm0nQSEYj0KoY08zQAR+WwN4CX4mttn2Xt+ejNivOP//tFT1WuW/YQK5MsiRSIB4j/D8gQlOliOrQarKfqSHEB68wF0vDbQQ99/oLXxNZZ4sLcmde3Unjd7q4TAY+z99ms9WTeF2GFZ86ZLONcVdETieTbQQCjCWlHsd9oylexjwQgtx6imojTODlq62C3HUoeL8SKeaVxoczQchtjJqhHBy1Y79PEIs6BvWqMUxA9mlooxxfNWyXRnFNL1WspDivaqOLquPajakivMoOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0YOcYNqyitLPDpVBI6mdJtqlxcs8GABd+J/3a1gzpQ=;
 b=T152NFSdpo5RMf5wkEzBMN69hn8PggzDMpCnV2UChWGgkMnfb5aMnP7hvRqwr9Fo1C8K95+QuzZcNy8m9TBiJHlD2DytIQRHvCSu3UnX5CWQfxHDJSUiQ5xbLv0ypaLwahs4MApf3v9KAVCF49JpszDxIw5FSSKKVDnNtaQ2Tx4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB5596.namprd10.prod.outlook.com (2603:10b6:510:f8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Mon, 5 Jun
 2023 12:32:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 12:32:46 +0000
Message-ID: <fe63bba6-5a9f-ec6d-1d52-6377bf984b27@oracle.com>
Date:   Mon, 5 Jun 2023 13:32:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/3] ata: libata-scsi: Use ata_ncq_supported in
 ata_scsi_dev_config()
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jason Yan <yanaijie@huawei.com>
References: <20230605105244.1045490-1-dlemoal@kernel.org>
 <20230605105244.1045490-4-dlemoal@kernel.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230605105244.1045490-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0610.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB5596:EE_
X-MS-Office365-Filtering-Correlation-Id: a770b912-d8bf-474f-4574-08db65c0f72e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmA/ayS6eXdkunYHga+HLHs3tpUw+X48wWb1r2dba1Iot4Y0wZ2NuCI08MGEEtjCnXm+npGHren3b9HLrTeNVM8Ci4hrpblnuz9NNG4MZndc8zW+zg1OCNX8imFDA4oBRDC2xmcPBxIgNNJNQ8jAW6POK/cyVvpJZbVX4ItmZ2Sxf75QKK1mV1FAHW8txjgrT6OqzC5fc9Fl4iUVbeoFcn5KL80zfT9YxUkE6uAbxs7nDy470po9blLyoZ3lk/1ubVpp11hSK9yoIwMHxHDCCUfYMaRJBSvBS9qR4Z03lpTLTUX2tHDn6Epmu6aW7AHZQqPLoQa5Z2/G+nM+d65TF99TuIVtmpvwK6y+kyZ0IQjoa/06TQjidsovquhSDMgsaaUL2b39k3rpOCTaLAVmC/FcAHiXQImhJxpdkFD/1V3CB8qJy1pd4zYKA8LkuUewbNMMqUa0DXBZ5pjR9+7m9ADejo7y8s5rSaHweaOpWLiY8wWGsivXfcJ6TU8QPuIE1tzC+0WPU/xS6Rkt5P00EHumtT/+UQ9eOmD75+hsPcUO57CMxBTd1h8Rc+kq8SnVRfqG5dJ8v2jrvkQOLaK/Bu3xmvZBHvqU0ALY1EhwBwFcw51yCfgCrEkcafqc3Y/fsXVfrLFx7JInCyzg5OkD8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199021)(53546011)(26005)(6512007)(2616005)(6506007)(38100700002)(41300700001)(31686004)(36916002)(6486002)(6666004)(186003)(478600001)(110136005)(4326008)(6636002)(66476007)(66556008)(66946007)(316002)(5660300002)(8936002)(8676002)(31696002)(4744005)(2906002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnozS2ZlaGQ2ck5RcWpjWEJ6MUM3TEkybjlnNE5OeVROYW5sdHdtT2Z0bmZO?=
 =?utf-8?B?TjFpVllqaFEvYnhBajIxRUplWVFiYTZFemN6VnlybFFaNW1iTm1KVVVEaEJG?=
 =?utf-8?B?Wi8wS1djMFU2TERrRld3bW93eitKM0I0U2xzREo5VG94akRjd3VZQVdjcjBD?=
 =?utf-8?B?Zjk3cUFxTFJsVU8yVUVGUWw3SGppR0ZXcUUraTlscjNraFd5KzlXT3dzV1Zo?=
 =?utf-8?B?VzRNVWZNRlFTR1pqZnArQjNXUDhhZm5YeGU5T3pZN3lCK3R5ZUZvZVhacnVZ?=
 =?utf-8?B?ZXVwakxRN3hCa1c2cmRrME4xVFVuMmZTeHJSM2RoMEprdCtnQlJ6dDFQUm5B?=
 =?utf-8?B?WDUvZHR0K1lsRGk1ek05Umg4N0tIbTE5dW5aejAwdzNzcW00ZURMSEtoditM?=
 =?utf-8?B?ZlpXSFJZOTk5RG9pL2Q2SnpLQkk5M2wxNDZmR2JWWWxRVm1tdElwQjZPZjRF?=
 =?utf-8?B?am1Udm5TTkpTSXlKQUhyUjdHVDBkVFFYQ2NBOUpqQ0xqSjdtVHdwcEZMVjND?=
 =?utf-8?B?REdhUHJjWHJGNWxkbjZOVUpwVkpDZ29oRW1xSk9KWmVPeDg5THVWVFpaLzFP?=
 =?utf-8?B?K3dIMmNoNlRJelBNVnB5RWRPN0FMUlVKamxCWHREbitCODFSaVFENDhqQ3Rj?=
 =?utf-8?B?bDc2NFNDQUU0aU5rdDh4SUp2S0JDQTdPMFNBTDBSMGJPeHZOczdqT1Y5RmdO?=
 =?utf-8?B?U2FVRmxGVGpjek0vM0liRUwwbllHWW9FUkdidW41aERyaG5vb2NBbE5Ya0lZ?=
 =?utf-8?B?NjVxSDN2b0pBRmNMZXBoRGVwODJhWVlGNWVHSjNIQUxjRnRHS1dmaGJGU0hT?=
 =?utf-8?B?dUJUY2hsYjd3TEJwMGxuc0NUdjhXT3V1bUxYemdFeVFiZjBZa3p2RU9ndGZa?=
 =?utf-8?B?SnRaNW5xUW5xb2N3dUtRalZyY3k2TGxaeDJUUWlqNXdjR0tKQzBaY0YrU01p?=
 =?utf-8?B?VG1ieDBBZUJ3ck9yNnJRR0VzQWZydGZDSDZodWtOZGtjWEVJSncydksrWVhI?=
 =?utf-8?B?OVhjVzRFU2M2enFiQmx3Y2Z3eUNnWEpFU0FBK0I3TmtOMWtwa2RqeWkvZzFL?=
 =?utf-8?B?bDdoVHhFMDQremw5bUZSRkpRUlFEVDlCQ01YNHpRRk9tTlVvcWRBT3BSQXRH?=
 =?utf-8?B?M1hScDZIcmdTWExNM2xBaDNMYng1R0crSUIyNHBHUnFEWDR5NWJqTHR0T1Y3?=
 =?utf-8?B?dWdxZDNON1lvOCsvTWNzeTJhakZJamNQc2tYYUl0aTd5ckhINmcrMnlSUTJO?=
 =?utf-8?B?MzI4MGVNeVREaFVYUjh5MFZ3ZkRDb29vV3Jsc001djdMWmVyVFZhRXh4TG5w?=
 =?utf-8?B?Mkd6bGdOTm5LaURzb3NCWGl4Y1BJb3VoNXpFbEs4L2w0YWlGUXJBTFBmUWg2?=
 =?utf-8?B?WndkVGZZVG8rSTRENDRxTmh3YkdJNFZyVXMvUzNOYng4elRFeXBMUDdjRUdC?=
 =?utf-8?B?UEp4Nk55SmlCaHA4d0pRL3ljV01XMHozR054NythbitIUi8rYlQwTDBNRXpz?=
 =?utf-8?B?V3NzYmxnQlg1V3NpMFdpeTRjbFQ4SFBLa3dQY2RPdlZlVVh6bnFvclBxUlNY?=
 =?utf-8?B?bmE4Y29QbVNpSldSZ2RXRzZrcXEvQk1RMjgzcW85WUw2TDF0MVJ6U3FTZDVY?=
 =?utf-8?B?azJzRVExUUp4Q1JCOEVpYXpVcEFLN2pZQUY0MzdqQktKWHBQT3VxWmJIOXRV?=
 =?utf-8?B?L1RTUUhhU2xTNHdEQ3VPYTV3T2VzOWlYNUloUmNoMHZDMUdFY2UyUEYwWUNW?=
 =?utf-8?B?L2x3QlpDaUJhL3hQcGVMVzV3Nko0UlIwRUpwbFVMczE0NGt6di9tcnd0Uk5C?=
 =?utf-8?B?bGNiWFpBNXhQU1hQYnNHbXd2WDBDVE9HUHVKenRObFdOS0xDNTFza0Z3UUlB?=
 =?utf-8?B?bHNMTmk1N3huSksrVWJvMjQ3b0pyUFIxRTdEQnBmVHU2ZmRyMTNCdm1WUnBu?=
 =?utf-8?B?OVhRVldmOXk2UjFMTDVnaXBzKzk5ckdXSURXSURJcXNhSWhpc3Y2cC9Ja1pv?=
 =?utf-8?B?dzJ6aWlxeWxRaE8wek14d0U1UmkzeGYxbkZXTDZoTDNRSzVQUHlRa1puYWkz?=
 =?utf-8?B?VFpzcFZsQVg3V3IzQkpWYnZueFJ5eEtPbURuY1Y4NVhudXBzcmJmQ3AvQlNl?=
 =?utf-8?B?eDZSRVJ5cEw4L2U0dW1VZ2Q2YnZld211TUl2alFTUU4yallLYUE0RVhKVElk?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Wa/4BOrpqvFmojKdGHlPdM9p7yL5HgM+pvGaiMUNIeihV/we90gTtoLZvIj5eBIjMTUsZ6QlUJRWt/6pMZadqGqG0nT2jTrvmX+OmzviqEiRo/lb4JAGdauXfyBBemQjrVqhITAIgPi8AO63yFglaP+qEiGtRKSWo3aY0ufKBxQQ6ynyz4GWe0xyhnabGG5Agpth7nqwwJjJxHAhRo/9L8sAybkRggc+F145Nie7Eqw+PUpQzJbRn2TfjyBGVaXBJO93p5tsXypj3M2TXLzQz2sEa3bphBUuK75Q5ckB9kggJh47uLnN+I3SShWVXd9bdndrbRinKNqgif7rLIaTxFk5oc9O7kH9CuLxnXR03aU3UqOjco21Z73b9sh3AUCX2xBJTVNtOQjY7HWke8Ir7yZB8HF/41yUUmTnhHD7OfQzKUgdtYkT3+dOz+95jnzEmfdITuCrQljhj9kwIo4cCIWWx3NWMYVIZm1e1dADDS74yFeey5cKlIMNCrXub/et2Jw3DaDdb3sWPCsl+fGLa23W0MyFiYL0luQMEvR80bgTu/iXU4sGXhMNzIe3xfAT4Wp2nbYTgIdz8uu6vbXBx6wHEs4QgyNYqpXrRUlNoKgxBjw/MGZLjT3U2eJ7gVzHS7c9fjkGtQ6Ei4NVt7a5t4hNyrcBZUYSBMhsITHQNn7nXvreQ10t4G5RPB05esmQeILvtBGy5qbfZ9VLru8cakBCXLHl/xu+N6Z+bfrStwx2A540Y99OBX7a3woejUCKiXcazGLY8C9Jb+A+kr2H9OLVBzVKb1KVWCDT6bCVmPgK14aHZH6FWetD/Mm2sJ5i
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a770b912-d8bf-474f-4574-08db65c0f72e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 12:32:46.0694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZUQL2kv0s+z3RT96Lkb2M+IepQJyelwcMfNJ4p6rouQ0x1l1knzBgkvY/leyxpNLO5YY+ym7NZfAr+GvrZFhSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5596
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050110
X-Proofpoint-GUID: 679KpZnuMBByP7T-zqIiXpbFwfbpBqvQ
X-Proofpoint-ORIG-GUID: 679KpZnuMBByP7T-zqIiXpbFwfbpBqvQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/06/2023 11:52, Damien Le Moal wrote:
> In ata_scsi_dev_config(), instead of hard-coding the test to check if
> an ATA device supports NCQ by looking at the ATA_DFLAG_NCQ flag, use
> ata_ncq_supported().
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
