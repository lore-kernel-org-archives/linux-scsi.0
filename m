Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5246BC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Dec 2022 18:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiLWSnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Dec 2022 13:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiLWSnm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2022 13:43:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490151EEE6
        for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2022 10:43:41 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BNEEEQr012283;
        Fri, 23 Dec 2022 18:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=TVIeladgouxnkEG4XmKneWP1j4tX0prAbWTH7hQlqeM=;
 b=sxzJkTRmRkYUX+KYmZ3xC70C21Njh1/F80zPxfGzfeeVXIr69HY+7c2Dwp9LjG3NEjGl
 ZbqfelM1A8sCJv3Y/WWlTCjaCdsfyLe++02f4xO1ECIZamUOgmzVsVPjaaGK+pGSukWx
 8F1qCoQJm81FpmyWNHZPIpRNjsHTcZFlXurXpnHzAEeTzVVuzYGDbPtviAe8QLbVIKH6
 9ri8J6vsWrZeMBLhHLyaAjmTvd34YfiPSslP4KQFydJ5SR+CLj3FkcpST7xvK26VpfD+
 z3iX3ZQDi1p2Vj1MWuJfNXeJdf/o9tkZ8pOH2CRHG+h0AdPvnY+YLaxUOwg6Gfw6vY1K 1A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tnpt70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Dec 2022 18:43:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BNHemA6038467;
        Fri, 23 Dec 2022 18:43:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh479gafn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Dec 2022 18:43:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM4OGBf+jdzohpf9KHr01kK1BWhVLIUNnoOQ8ZHH5J13PGFHBivuTW/YMx5dFuG3/iNVAXDVaieUe/GSxenyfmPUmgvQov9osMJ2eEc0loEusjMMjYULj6XqeMSIz9lVpDNj/Py2LtJotOpFa0lLoNKLJrc7WFPFMKzb2BHlrTAU6ibqE96mJzoe3AHlZApjAbzrkqan5oJIti5daIsiB4xj6AE66xDOmiSEdUphXp7zlywTPRjPwfARANTE7r+I8s0/8jR5f57aYpYHxlP027go6sLzz2vPxcN57rU2NPpCqY6POqhmqXRVi5aiJmhROcvNfNGsfizMEQh8vDo9KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVIeladgouxnkEG4XmKneWP1j4tX0prAbWTH7hQlqeM=;
 b=myGgFYL5g/qwrAzgDQ5bwf6DM5jkG41GPAbCZ4Z+/Q7FeZ5ph/E1ti+TfJ1rVjp584+yWoxIMAJWhBEqSwDZdDi/SHHQeUKZtapmi3PYq3WViEsIJRj0EfeJwvse7xVtK22dgv9lfwcmKnIObIdJBmNQBozTwY0vGjDkqW0P8W3WcMzu2Gw60sME9a/rvrONZJNBH2xtalbEK3D2eNeeF9Dkskk8nE74Qa9cknt/LF85JRzUd8C4J3PDgQYtfx2CFUR3XlTXUCf61jrY/2go3c675esYrxBjyQ3AyC0gm7v8y6eXzJOlMAuBXszQiLiN+pHS0q+NVihfdK1liTgpfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVIeladgouxnkEG4XmKneWP1j4tX0prAbWTH7hQlqeM=;
 b=QK3xMxd3MVQSrfOxuVqtrjubIyRtsyEH2h68GN197M0Tkhbv5mv+RUCHukIaNhO4ykgFcFWtWYRjZiTEP4T3aK+zznh4rM/kYSdbDQjnHC5iELOlGXx1IHTf2D8wuHqS2+Y/XqmSHRT2PvfIVoVMPl+/mjQ6nDALeX7xsMBegSU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB5987.namprd10.prod.outlook.com (2603:10b6:930:29::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.13; Fri, 23 Dec 2022 18:43:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.013; Fri, 23 Dec 2022
 18:43:29 +0000
Message-ID: <58558cf2-5e2e-4c4c-36d4-461b37f3f563@oracle.com>
Date:   Fri, 23 Dec 2022 12:43:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v3 12/15] scsi: virtio_scsi: Convert to scsi_execute_cmd
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221214235001.57267-1-michael.christie@oracle.com>
 <20221214235001.57267-13-michael.christie@oracle.com>
 <20221215081540.GG3308@lst.de>
 <0771d185-107a-e3fa-aa61-9dbd1da36a61@oracle.com>
 <20221223155727.GA30763@lst.de>
From:   michael.christie@oracle.com
In-Reply-To: <20221223155727.GA30763@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:5:bc::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB5987:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bb27aee-3919-4cfe-9596-08dae51595a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LVkymbVo0yV42wP3Wgs/TAxbvZFbDBsgMzodByDJ560KT2vE0zo5NepsFw8qj9hhQTeWTzrrsf/wSo+aOeOgOd3EeJED2qLMZcSvOrGtc+GPrUel2Vggc+m0m5rEioNjmEVt34MOuNehmUlqkjptEKidBtYBFViav54andgu7CRGg7CGEZs+lnhv4cFVDD09v/yg+LFh7qFfU/hdl4BOZ0/t7Gq5zvD9q2+1ych4BNfZbDNImjgnklJGXGn/73f/vgZidFMjXvmxWp8h19cCJ3LQ0MEtPR1NCu9dt433uaZyMt/Y/c7OPnlcOt5lB+rC9+CBikbG8e5TFy4r8rNVGYIxCtkW81w54BkRvcv+2HWiRMc1Abu7WDYm8texfKeFmChD1E+c1CsMX6LGACoN4fLWWqiSmwXIaAUG+ewhYWughg+PWWrQ1lcX2VOXQB5KbNxnD3qBUQbZs9YiB7SeKG+rNOT+poPTSXQS/JTb+yybz5tXsn3f7O2vV4zdMYOLB0yEo50+ObdE0bM4iuY2Orxl3VzwfwIrsyJZglerWkdl8P7KsmRO8nmPFCYUIdheJMNKMPaTFx7D+7t9zPnJsflINzy5PoSlrg676ttXJNgFMqwZ5FtBVthgzQs25N/h4H1ZPnk/7oMJ8lHLgpq1e4vR/4AKfKsTwbjLVNaDsNQA9TFPSuo3FgjSWP3kfILBvI/TRZwnSwGwS1fIdjgRGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199015)(8676002)(4326008)(66476007)(8936002)(6506007)(41300700001)(31686004)(66556008)(5660300002)(66946007)(6916009)(2906002)(316002)(36756003)(31696002)(478600001)(86362001)(966005)(6486002)(186003)(6512007)(9686003)(26005)(38100700002)(53546011)(6666004)(2616005)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkVVL3FaZk11eEhIWHE0U3c0dnNrRGUwcDlTUXhnREp0NkZrMERjbU4vNWZN?=
 =?utf-8?B?WVFZcHlzdjFUYlo4T2U0Vk5acldXeHVXS0o5Y05qUFlDdGVqcXpyTHFiNVdC?=
 =?utf-8?B?VEd6dGxpOHcwY2xQMG5rQ2VaL1lCQzQzQ0d6R0VMNlBwSEp6aUdmYkJXNUJV?=
 =?utf-8?B?Z1N5VStkWXlzUTliT3llbmV6dXhxUk9MUGtpcEFMbDVpTG1zWVZyTlY4ZlZ6?=
 =?utf-8?B?ckg3ZDExWU0xWXBJd0k1djVPSkRseml6RncvNkdzN1B6MVVtLzdjeEYyKy9r?=
 =?utf-8?B?RzlOVUJwYXpQNUFYSnBvVEptcFV4U2RmeHdSSGc5bnR5SE5aUVhNdUYrNWQx?=
 =?utf-8?B?dTJzM2hudjgwRy8vdi8vQi94YnVaSXByUTRMcFIxc0VFaEJFZFA5OTZvaEVh?=
 =?utf-8?B?M2d5ZTdFNWJydVZ6MkIwaTM3K3dCUXZjNm1oVklIYmZGR2FMTjJES0tQT3VO?=
 =?utf-8?B?OGFjVC9qUzNSRmFGYzBKUnd2SG83a3pEMXVOVjVoT3FnM2FpMG9YeUg1UG9w?=
 =?utf-8?B?ZmRodkxnZVVaUk5SNTVRNTM3dWx1RDVoeXJjcXNpSkswTE9yclNKOG5QSk9p?=
 =?utf-8?B?WjFmaVVJL2NUMStUK0szTmZVMWd4RGl1cjQ0WG9PTlVNS25rZXpaV1JxMTVh?=
 =?utf-8?B?OW1GWVhOVDB2ay9DR3RoRjhmWHBnREhXMGNxNlJLVUhXRDFOQkFySDg1ci9u?=
 =?utf-8?B?RUwrWkFsZ0Fid21GNmdEcEhwcjBieng2VnJVN05LUnU1UElMblU3d1JJQnpo?=
 =?utf-8?B?SVRsUDJrbkZyNjQxLzRGd1hWd2pPMExkNTQ5R2U0UStGbGpENnZQR1NDSjlE?=
 =?utf-8?B?S1RpUGxrSldUd1BxUmpqeDR4cVNJdW1tTWV6M0dRSDZDeGFWNkFuUjJHL296?=
 =?utf-8?B?T2hsTjZON3dzVzVtZndlMTZWdnJGbzlpV3Q4d09nRVg4b0Jhd3VYNk0ralZX?=
 =?utf-8?B?cXlOSjdwYzk5UXBEZXRFVVNUa1d1V05xRm9MK3dMTktoNkxLS0xDYjBia01u?=
 =?utf-8?B?aGJ0WEJTVW9lU1JhSEFVV1ZKQlZwOWhoTG5hQW1TQVlzNjNvUWxzaTJFRXh6?=
 =?utf-8?B?ekFjOElYVmJQQWhzWUN0TWlXOVJtdXY1ejlraGkrUFU3a2c4WDBOSFlQZFUy?=
 =?utf-8?B?VzROaUtmWEdud2diQU1QTXpPNTdpM1oxcGFVbDNWY3hSZDE0SnlRZ0dZQSs5?=
 =?utf-8?B?aDNoZ0l6bzJKcnIyWjF6cFhxVnNiS1h2YmFJZERYQ3RRNzY3Zk8wbGxFMEFK?=
 =?utf-8?B?VTk2VUlmeEZ2SzFoZXFHTm9XUGFNK1FkcGpRUmJSMVdsRHdkSDErNHZiY2lk?=
 =?utf-8?B?U2RGa01sakJtVGNDSUYvNzNiR0oySkQ1SlZteG4vRGN3bEtkWUt3VlFRakNJ?=
 =?utf-8?B?OUYyeFpOeW9Da05GQ1BLT1BjdGhYY2Y3V0NlanlnbTlZOUtsZlNXazd2aGkw?=
 =?utf-8?B?WUp4d2Fob3lEMkxGdWxKU3BSd1JpTmcwby90Z3lPYnlab1RCS1hsdk5sSXZh?=
 =?utf-8?B?U21PWjF4enp1OFdyS2RmRmxNdm52aGwxa2UxWGorMFhMdlJGaUY0OVJ6QkZJ?=
 =?utf-8?B?aUtMb1B3dEM1MjVkaEpzQTN3RTQrOHhlTm8reGFhUTRBMXp4V3N2TGtjemE5?=
 =?utf-8?B?VHFxc085RHpnSTZ1bDVWYWRzRTZ3dlJrNlZMbXRtNEMvTlVzd1NvUGhIdEpJ?=
 =?utf-8?B?bTNuZDhJdTcyNmVOS05OUG1YR1kzM2ljczZsNnlHQnphVFF1Smt3SVRCVTVu?=
 =?utf-8?B?QVppLzI5Y2dMdEkwa3k2K2JwQVYzSkV5NVhVdjAzUTl5MVBzZFpYOS9lbGJD?=
 =?utf-8?B?bUZJYUlQanJnd05zWDdROHVQS3RZWitrMFZoRVN1WXNQWnVMR1IrZmRWejYx?=
 =?utf-8?B?ZElSWXVlM0NIZGxvdktBdEg2N0l0VXFTRytTYk8wcFZTbjFJUmhtMXp0aHJO?=
 =?utf-8?B?UjN5NklJZEJTSnRLandwbW1CUlUrbzRUTnhJYjN1YkhTS2x6UnRGeEU4VjVx?=
 =?utf-8?B?YThTcVdHNVFHL1ZoOFlyejVnTkZnV1U0bHZ6clFLTTY1SEIySXZ6b2N0cTQ3?=
 =?utf-8?B?dFpFaERVVnJxdG9jazdiM2pFejlOaWxUdEN6TjJreG5rRFZQUUZVUXpRdTNI?=
 =?utf-8?B?WUFYTTlrUldXK3Z1ZXRORFM1bktyN3IzVERySkMrMWhNSGRMTTRIRjgzNCt1?=
 =?utf-8?B?Ymc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb27aee-3919-4cfe-9596-08dae51595a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 18:43:29.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: woGLGscQ4lDAZ8Pc1luublX9o69To0e72aWyG+yxirBMM11gL3pigUhNvZ5SsG5OHlAiyy2azmnikqmCnJohVUc7AvRKUzXbyi5/nsJyt0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-23_06,2022-12-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212230156
X-Proofpoint-ORIG-GUID: eP4fwRyvC8CD_wgZbt15naA9f6d1VvnC
X-Proofpoint-GUID: eP4fwRyvC8CD_wgZbt15naA9f6d1VvnC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/23/22 9:57 AM, Christoph Hellwig wrote:
> On Sun, Dec 18, 2022 at 03:40:48PM -0600, Mike Christie wrote:
>> It looks like a hack around scsi_scan_host not removing devices.
>> Going forward, it looks like we can remove the inquiry code by having
>> scsi_scan_host be able to remove devices that are no longer returned.
> 
> Yes, that's the place to do it.  I can see arguments for and against
> that, but doing it from and LLDD (and including sd.h in the LLDD
> implementation!) just doesn't make sense.
> 
>> I was thinking to handle the DID_BAD_TARGET use case above and this type
>> of issue:
>>
>> https://lore.kernel.org/linux-scsi/CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com/
>>
>> maybe we want to have a driver level BLIST like:
> 
> Maybe instead of a blist we just need better way to communicate
> this rather than abusing DID_BAD_TARGET?

Yeah, after I sent the blist email I looked into qemu and the DID_BAD_TARGET uses
more and we can do more what you are thinking.

I'm going to do:

0. qemu only uses VIRTIO_SCSI_S_BAD_TARGET (this gets converted to DID_BAD_TARGET)
when the device does not exist, or if you are using a sg device and it returns
DID_BAD_TARGET.

1. Most driver uses of DID_BAD_TARGET are when the device is missing, disconnected,
timedout, or the bus:target_id:LUN value was not supported by the driver. So I was going
to rename DID_BAD_TARGET to DID_INVALID_DEVICE/DID_DEVICE_INACCESSIBLE for those cases.

2. Create a new DID_ error code for the other use cases where the driver meant that the
target did something incorrect/invalid like send a invalid response.

In the scan code then we know if we got a DID_INVALID_DEVICE the device is not there
anymore so we can remove it.
