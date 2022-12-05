Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9F9C4321E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 08:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiLEI74 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 03:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiLEI7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 03:59:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A2C65FC
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 00:57:53 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B57OwdE008739;
        Mon, 5 Dec 2022 08:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=L/15RIYj9Bt2JQcts46q5Ht+8zIrmWu5kmklELOaD4w=;
 b=XwW8F3ufzJMTa4HpoCzfjKqYhzdBoIQVBcSNf39hK52csH8DvHoGxX+MYRY0L4wZ3pUi
 F4owlf+9lEEqfy4b4lM/+N09f6yYcbxhwRaQmxoabjYO38qt+iwU3nPSv5l5UMneTukn
 UsVYS1UzxSRBzMXyHPOMwDsBnTgMFr4qYofTKahynRJZRHQqL9bqzs+lrqC3/OSnfIIl
 0ozcx+OQTmgldF8u81nH5PNdYcfbZvYSV7c8yZdtyGusmizqaVajs9sJ8MU/5audhz9V
 ypbVb3Sy+oqIAdxRTJyhK74d8aIvtARiiuC9V5/c42OCyiHfxlrEpRmeoqlaqxY1Iybp fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ybgjxwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 08:57:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B571ane014956;
        Mon, 5 Dec 2022 08:57:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m8ucsb35x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 08:57:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J14ET0DLX6t6qGvSxbMdRWfdp4GyLwaRZX8T4LfiH/FfT8rmzIqervs/eZCZDMMMB/VWhPXaGP01mJdJ57P9FAwSZjvunV+hNwf+LC7c9VI0jjID8Cn3JqeOMFdxfemTwZNlCJuBzSj/wgWUpHAi8PCO/VEp1wQ5gp1OzyIiGXTmWwK5hvNBt5tbBz1JTTPCX7ohbJPkEQoOmIr12PBLe/Gg/0j8ykPMvkvnrIEonw8I21A472jh79h1e+PG31btkIusPojlUS9brehtpe0ZNdwUjHIrRhNsOgm4tI3jdSs7UKHE6m66AMof2kPrX0pRdUbjohiDYM6XSrKbVJFOCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/15RIYj9Bt2JQcts46q5Ht+8zIrmWu5kmklELOaD4w=;
 b=jc0JCiRumOdw/bpz9azH5AIZWlsGhDQgThgvug4mkPMSsXF19kNTok+0mlAWdGbkeAfmG29GWB/kwa+itK/lUFYcQYp5f9zxRvGbvM2JZ+vjEKE2BuGIfx2goFWxpPJg+sekz6um9lKIZ7mCqxJcvNzofMl30JKBpB4zlZlnCVg/9N51ky/11nVnh3o1RvNoc4sRmEQbTU9r9a/DNs41nUB2wI+2gmFY43jKRlCPEZvXc2XB65ifG/QkDp1ZNvVNsaUVyha6NPyK0gneIUIrmsqEWIwiDKE5zFgD+skXz9eNN5nDVc0pbr2UMZmk7DPUIHL2XvsiQcrqsSbsoQAsdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/15RIYj9Bt2JQcts46q5Ht+8zIrmWu5kmklELOaD4w=;
 b=A8PmMvgemUHWLmHYeBPc0jCoHKHQbXdEmbUOohaeTHcn43ZBhTKo0gJ6jr8GeFRIaOQhFVskE8J21OpctaPvp+7dvI4h15NWkAW8s57BkU0pnzIWgRZVLkvm4xDtwRNhMPjWpgFPE+nLMQCQruR76eY5SAlwLTKsaWlMfFc/v7A=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB6429.namprd10.prod.outlook.com (2603:10b6:a03:486::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 08:57:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%8]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 08:57:32 +0000
Message-ID: <8729c1c5-c306-1fdc-ff30-174740be97c4@oracle.com>
Date:   Mon, 5 Dec 2022 08:57:26 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/6] scsi: libsas: delete wrapper function
 sas_discover_end_dev()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-3-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221204081643.3835966-3-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0001.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e53241-0a4f-41ea-17cd-08dad69ebeb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n6gUynnES5xCIoTXzE85PQ5LnpNgogZ9q7HLYMsNzkit9k9IYmM6rKcUFzNBbG4Tu1+Dx3mCKLMbVpDCSA2l1ViJPAl+IoUKyF97CVFk6i2Rh7eQRuknOCAB9kJlG4ZrlVFdvpWffXUe5dkk0a9bGLkoU/h2puQzrPATLhm409ddh64EunQu3HPhYDYl+HSI3sDMIguGv/3w3aMUi0dCdGIL2tqVjIrcQmnRLVp38PhvSbvyOHKyh1RWhEZeuhuDVVKxsggA9aqqIgSu3qu6bWDl9ZEFkw2JIntz+tTIVxP2xzWEUiZKuVDKra4RGRJmqioYdeM9kV/zywlECgLKgG3Ocz9agMDGXF8s/zXcZuwF6xfXsXIPH5+5C+eIcVrNGPzyLsWU/TBE554gl/f4qI4h+ynMNZQudIsRYUccMTVydlSvn2qJSRoVFlmv01wJlxs5SwdSzYOQomdz2upWGHmn9apayussN4JzZNbYJE6GNi8KbX7By0lRUkUrb6qB9PpMLujsSLYOGsRj/e8tI6AzQUDb2JrPQ0Xh5HuP64V/x+0otxB7XenlfcsfQ07wPyjUn30Ho+AUdEW6E1ncvt1OcYw4qrF6Ctdmi4v9egylhHw14QDJ2McZMfhOd4dez0CwIHpQd5iTNQnpxTtqQFF4bknOkwuFzNRyikOu8QSgvPpcUzeigDaN7KeaQmpws6Y3WZseO6VXgQXOmpJDTzAtT6UJUqCzRnfjVliny38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(31686004)(83380400001)(6486002)(86362001)(31696002)(36916002)(478600001)(36756003)(38100700002)(2616005)(4326008)(8676002)(5660300002)(6506007)(6666004)(186003)(26005)(53546011)(2906002)(66946007)(6512007)(66476007)(66556008)(41300700001)(8936002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3h5S0o5cmFOMjdNUmo2WjRIaVNQbFZsQzUzT1JIa05IelhPSTBYcy9SdEVv?=
 =?utf-8?B?UXpDWmd6cE9CQ0w5cVZ6T09LOXVpT0xaODNuSjhIczE5QU8wOGg5VXlmQi9D?=
 =?utf-8?B?R00vVFpoNFk3S1RzV3dhblhoSkxpcGhINnFlQklCSHJPc1MrdTBJQ3BwL0hq?=
 =?utf-8?B?alRreXFPMjFsSkYxT3BhYUw2dWdzWjZMcklTQTRCeVlDM3hZZ0NWS1kzYUJi?=
 =?utf-8?B?UWFLYndjL2g5TG8zblFDU1pFUVJCZmJKTlRnNEI0K3c5YSs4V0VESDdkcG9S?=
 =?utf-8?B?dldoYmIralBaV090YmczZGhpeXNYUGFnK2ZZVjdoSFBmUTZFM0tCa01NMXZa?=
 =?utf-8?B?T1UrY09qdUtLaUw1am1RalBEOUlsN3NmaUd3SHlBNnQxaEZUQURibloxd2Y2?=
 =?utf-8?B?RXo3RDU4dHdrYmhIVTV5MXVPSXZpVWxSRjk2TmxGZ3dCQmhGYjFoVHFDbm1s?=
 =?utf-8?B?bGhTOHhlYUgzR0txNi8xUVF1OXNTcnBTU09tV0Z5WjRaYVVMay9SVFFhV0I0?=
 =?utf-8?B?TlhBR3MwYzNGQVk5ajRvYTYvczFxM2twKytOT00xKy83bURlYzRiRktzOHRC?=
 =?utf-8?B?bVVtOHdUVU1qWWVQR3A0VnNMMVlNQkNBSWg2NnZ2MmlHdk9vaDAxV0tScWp3?=
 =?utf-8?B?aWpxV2ZYUTREbHY1R2NYNndVbEtiSE4wT0tZQ1VKMllwSGxIN2lqQ1ZkQkND?=
 =?utf-8?B?alRmNTZiVTFrbyt0MDFPOUE3SXZnek4zSlBZTjE2UEY3emxjdHd2amZCU3RG?=
 =?utf-8?B?ZnZXb0dGVldFcitxbGdySExGeW44RjBvaFRXcWNWSVRmT2NzYVplRnpveXBX?=
 =?utf-8?B?YitCVHEvTXFoajZaR3VpOExCbjAyalAwSHhOek1YRmZJOHM3OTJtVVpIcWFT?=
 =?utf-8?B?L0hwQTVIaFA2aHp4YW5CNlhsOEJGcXJKeFhzSDA3TG4zZU5memFyaHNVeU1C?=
 =?utf-8?B?Y0FueGMybDZYYk14ZFFBS3R6VGlUOXl4LzJZTzNwOTltSFp0eDg3eUFmNDJu?=
 =?utf-8?B?ZzlpOTNiSHhuUWxiTi9Qd0ZmN3NQNC9LS2k0MDFJc2d2TkUvbmFad0wwaFMz?=
 =?utf-8?B?UWJHQVZ5QVhsL0lRaDZrTW1JcGU0cGYrbWZOaDBHbVluMFZndEViMFErU3Ri?=
 =?utf-8?B?YnpQUjdDWkNjQlYwSGVvbVRBZW9QMGdDRGpoWWZHY1ZQeGJxWWRpQTlWbFBF?=
 =?utf-8?B?UWg1ZjUxdi9ta2xWSytiWmhhbGhvdERObHRXQTBQQVowWktEbEd3TUt6a3oy?=
 =?utf-8?B?TW5GYnBKRUJrenlySytJeGJYSlhhY2plRnJWejZHczMxb1B3YU9JV2Mzd2lX?=
 =?utf-8?B?ZENwdFRNY1E5RGwzbzk2MFo2Uk8xaDhBM2ZQRWFSRExiTVFwVm1SZ2N1WTM0?=
 =?utf-8?B?R3F1ejQvTytUbkxUa3l3VTRFdHQrSlppa1drU3pPcXNaYThMN3RaZW81bUNw?=
 =?utf-8?B?R1dORDBHWURFR1FDVlh5bTdTL1lxR0FVVTdkRHgwNWdFczRuNWoycXFReFNj?=
 =?utf-8?B?ZU1ja1NvTUFCeHAySGdWRmI0dk9ZN3dCNGI1VFpCeG04NEFTRE41V0FBclRW?=
 =?utf-8?B?OHFJSU5BVnN1SE5uWFF2SCtrMzVtZVFDdHU2aVY2YzRaSytwTFJ0Y2FPaUNh?=
 =?utf-8?B?ZTAwMnZUektpc29hUnZFZWtCMDZzN2NGdENCSkpmYnB6U1RxVDE2VS9RV0dn?=
 =?utf-8?B?TXJFckR3aFhORGtkVHJaR0p6a2ZITklUV0VQMXAxVVIzYjZqdWhPcGFDdUpD?=
 =?utf-8?B?d1hxK0tRK01zVUZwdGdZUU1rWWFsSFF5OVhNTlp0aTB3dU84YjBEZDZSRmlP?=
 =?utf-8?B?RFBQSXFXMUd1OGkxUmg5aFU0d2FjZXNIN1RBNlU2cUpKWk5CUFV4TGRETjhi?=
 =?utf-8?B?RFVTdE1zZGNKa3N3aVdQdkUvYWtXTEVobUx4YlZxQUxpVTZCQVdFUnVtSlV4?=
 =?utf-8?B?YW9VS2w1Wnk5NDhpUndXTUEwZjFqV2kvSEJlTlpLcVlmMVArNjFqRHBKZVIy?=
 =?utf-8?B?T2k5aHFoZi9LTHpFOEhWTVJkUE1XRkc1TFFkM3hSTGxmZXZUWGtBRnM5UklR?=
 =?utf-8?B?VUgxcy9wQnR4dXcrUnByczZkM1NRZmxrUWV0eGlOSXV5Ky9xL0RXV3Jheld5?=
 =?utf-8?B?UnVOVEgxVDlkTXVHeHliaUpoSzRTRVRhbjdSUElxazVtTFNWdktueEhpaWVY?=
 =?utf-8?B?Umc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VDFqNlBUT2pOQ21GUzlwOGtiVjkvYjloeXVsT3JHQTVySmc0RkViT1QyN3Yz?=
 =?utf-8?B?aHpSM01ESWdQSm5rb2s3YjRwYkhzci9RSUJ4V3BTNmtSMkhVSTlkb1pHOFFD?=
 =?utf-8?B?TXphNGFlMUVVdUtKRXJhT1pYQTRia2p5YWxrZFJRcGY1cjQyaU1sM0p0Tzlw?=
 =?utf-8?B?OE0vTnlXWEYzakVwaVBRZ214cDRvcjZTMkt3L1RVZnBvektqcEdidFVLQ285?=
 =?utf-8?B?WlVHb0lYbTk3Q0VGcGpiUjIzR3hZMlBhaXFhQkF0amduSUtqVitDNE1Zc0tq?=
 =?utf-8?B?UzZDeWZ1Um1qdThST2Nyd1FkRm5BdGxXYVVjZkdHNEs5Y3RFeGs5czA5K2d3?=
 =?utf-8?B?V2pnbzhKTW1PS0ZOU1FlRnd4cjJrWXNpcnAvNlE4Tm5kUzhHeXhhN1FtY1lv?=
 =?utf-8?B?eXp4aFBOTU1taS9zdHc2cVhTK0RGZ1ZrVjZXMDFzM09KZ25rMFI5V1NobUlC?=
 =?utf-8?B?Z2NmUUQ2MWFXMk90bGpoMmlmVGkxL1NoM3V1Vy9VdWFjUXc2dUZDZ2t2R3pr?=
 =?utf-8?B?RDluSjRPRWNMczZGZWVSMGlwVytJSzQrZTlWOFJNT2pmZ2JqcEZUUTZQY0sw?=
 =?utf-8?B?M2dIQzNZKzZMeHV0UThrNVMyOGhITWo5T2RYTlNCZldjblF0Q25vL01YcE95?=
 =?utf-8?B?M1ZnVExsN0NmYm5uMHpSQTIrVGxuUzUxODlNYy8wWE9SS3JnWkpjMDBwR3Y3?=
 =?utf-8?B?Q3VPMC9HVFNBTmJaSDlDVmFsS0ZiQ3lWSzNoV0Y2WGZMek5FS21vQ09LellR?=
 =?utf-8?B?bUdKTVUrSFlZd0R3NlhOSGhQWXh0amhFWnRJRFRxRmQybXloOGMyak9KQjRk?=
 =?utf-8?B?S1dmdmNTVXoyZkRLM1lLeGx4T3IxUDV5Q0F4NURDZGJKUTZsUnNQUVg5NGpD?=
 =?utf-8?B?dTFBLzVVYXNBSE9Nd2UzWmt0N09vMFpiZi9FMTFqc1ZVVzhEK3IvS1lmeG81?=
 =?utf-8?B?WGUwVXNHWGtaUFgzcmRURHV0aFRCd21kMnIvc29VdzNKM09jeFR3cVRXcmV2?=
 =?utf-8?B?RExnY0VWOWxnVmtRL1BTZzJpZ0lRWlBiQThIYVFEUTFqM0lKVElwV0VvcVAv?=
 =?utf-8?B?aG1JUnZCajBiTm9KdUUrWVpUQUxnQitEcmcrM3BQMHpQRjFFVEorVDQ4azNQ?=
 =?utf-8?B?bnBzbE03eUlrTVpoR05RSUZxN0R4TVNNbnBQdjZUK1lDaDNKSEc4TkRiTVFB?=
 =?utf-8?B?R1BNUFg3bjdkQ1JLNzJsL3RSd2h3TkxTU2JzeDZ6KzdmVXkvWSt5N0tmYzAx?=
 =?utf-8?B?Nzl1RkJFRldrbGJqSHFYNkhlbW9PR2d5a094aVp4dU8xRE0zNkJ3QmpnRzZO?=
 =?utf-8?Q?FB3OWdgppk3Mw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e53241-0a4f-41ea-17cd-08dad69ebeb0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 08:57:32.0765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AeTtXWmC20FYg7XvYHDt5Y790lDfAyKC+Mzy/YQau+XInVW2H+nl1cSXXmAJ+W+edxMewJoG79fhO0UsMA2xhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6429
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212050070
X-Proofpoint-ORIG-GUID: TFrQ4vJt_gRVcYEcBT8x-tgKsdPRh-Sv
X-Proofpoint-GUID: TFrQ4vJt_gRVcYEcBT8x-tgKsdPRh-Sv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/12/2022 08:16, Jason Yan wrote:
> After commit 0558f33c06bb ("scsi: libsas: direct call probe and destruct")
> this function is only a wrapper of sas_notify_lldd_dev_found(). And the
> function name does not reflect the real purpose of this function now.

Why is this? Maybe add "dev_found" to the name could help.

> Remove it and call sas_notify_lldd_dev_found() directly. The log is also
> changed accordingly.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/libsas/sas_discover.c | 13 +------------
>   drivers/scsi/libsas/sas_expander.c |  4 ++--
>   include/scsi/libsas.h              |  1 -
>   3 files changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index d5bc1314c341..efc6bf95bb67 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -269,17 +269,6 @@ static void sas_resume_devices(struct work_struct *work)
>   	sas_resume_sata(port);
>   }
>   
> -/**
> - * sas_discover_end_dev - discover an end device (SSP, etc)
> - * @dev: pointer to domain device of interest
> - *
> - * See comment in sas_discover_sata().
> - */
> -int sas_discover_end_dev(struct domain_device *dev)
> -{
> -	return sas_notify_lldd_dev_found(dev);
> -}
> -
>   /* ---------- Device registration and unregistration ---------- */
>   
>   void sas_free_device(struct kref *kref)
> @@ -447,7 +436,7 @@ static void sas_discover_domain(struct work_struct *work)
>   
>   	switch (dev->dev_type) {
>   	case SAS_END_DEVICE:
> -		error = sas_discover_end_dev(dev);
> +		error = sas_notify_lldd_dev_found(dev);

For me, personally, I prefer consistent API name, like 
sas_discover_end_dev() and sas_discover_sata(), even if 
sas_discover_end_dev() is just a wrapper.

>   		break;
>   	case SAS_EDGE_EXPANDER_DEVICE:
>   	case SAS_FANOUT_EXPANDER_DEVICE:
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index a04cad620e93..aa8ea3b1f2e4 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -855,9 +855,9 @@ static struct domain_device *sas_ex_discover_end_dev(
>   
>   		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
>   
> -		res = sas_discover_end_dev(child);
> +		res = sas_notify_lldd_dev_found(child);
>   		if (res) {
> -			pr_notice("sas_discover_end_dev() for device %016llx at %016llx:%02d returned 0x%x\n",
> +			pr_notice("notify lldd for device %016llx at %016llx:%02d returned 0x%x\n",
>   				  SAS_ADDR(child->sas_addr),
>   				  SAS_ADDR(parent->sas_addr), phy_id, res);
>   			goto out_list_del;
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 1aee3d0ebbb2..87682390fb76 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -736,7 +736,6 @@ void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
>   void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
>   
>   int  sas_discover_sata(struct domain_device *);
> -int  sas_discover_end_dev(struct domain_device *);
>   
>   void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
>   

