Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91088C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 16:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E8B4611C4
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 16:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245022AbhIQQ73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 12:59:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52058 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244793AbhIQQ71 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 12:59:27 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HFwqD6027356;
        Fri, 17 Sep 2021 16:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LlqFqRhpLHpNXHb5UjXynsmn7xjz+W8YPOo35/156Mg=;
 b=Pj/ZZ+hxIs1w6eGEWnDSEIjFesz37ThtdkKFKOMVmQYG8EHmuK3+mHvS/5AYqP0+VcIm
 CsMy4sqiJXMlefA084ozjNUOTaK6acWs9pG6QpYleW0/LvpgKTXQkuf6LwLNi6tPSQ1j
 sPcwp/O4Cx3TcH8dcy/chSq/9LgYvYShGCnudAzjFCkgNRGUsexFzXJtxRxn/9g/Zg7f
 hDaOreaKzJ7RG+tIZgrgL2jD3yp3mhUJFaZeb1toWjimOkMA3ZKuWqskELabKkcXFJjD
 vVXjpBItoVG2lsLmdo+9lrzNKAfAUFh931V9Q+pe7e3boK8Gj1fp13vllkpYU/kfHhET bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LlqFqRhpLHpNXHb5UjXynsmn7xjz+W8YPOo35/156Mg=;
 b=Mlh6Cktf3XCOVnLyj2da6e6xJkpSZGYVy/YmyW6VfsZRrFV0sgY5FZJA1R/a0j/NLKww
 RPEtS00kzkJKUStOvmIDF6KNyCDeDVfhM2VGdclDQUQ0XgOgKuH7Tg5591CtelBCkeNQ
 RjevPtwRvAcwjsbW+LZggAbfE51FYkMr/PRyuYepyr+PmRee5Dafmd0xigorntak4U/q
 0plzivgah9a1twpSwQ+piMme9eA41h5MKezPXBfvQ/0cnet0D+Bg+yP8OoB/2GWcOvHg
 fm4VFZ3ojASZBoRFBTfJ0tlgxWnP+0pIbCtR42lJiXRIngux5/0Rj3O/0y9241LgHAdQ nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b4qv9hkfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 16:58:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18HGuafM112330;
        Fri, 17 Sep 2021 16:58:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3020.oracle.com with ESMTP id 3b0m9b3smq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 16:58:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrWhazv+sur4qjVIigflCqB0BJHJ5JyOjbJaR8NdWg0W1sDDQ48nP8WB5M/q0yFGQJ2f3WqnSRbFaycOtFCvaZ6/dv/FU0xVI8aGUUcDE/+MYO/BZ5KjA0baryAaX0mWfa9oGTcisrxUC0UAY9lo8JTrvGuEwThMqkkZwo9VxWPWMeaFTS/DdXj9jZ6HzGuey3BBTL6hAnbGR8DUMyETMNHpE12tJilZVmKb0NbaCXsuB3LG2FP1Xdx/DxGXMrx/w0quBWKtzMjFqSOMv9xvtLLznPFIIlaMU3atpbNvfD5zp2mkv0MfvRNTzs/r3U0B9n6x6cmxzvwq0L0vuKXQAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=LlqFqRhpLHpNXHb5UjXynsmn7xjz+W8YPOo35/156Mg=;
 b=KIpumGOpOWKkTQuHuQFuwWqx0jqLQu+/yPVFKxMOCJayYsLBKjpAMlg6fRS/1O26qeoDk99qXwBXgpX+0PWS12kI55SzOT2MZhsaZmdlbnd72v4NIIE2wNJgbCtQX5nIRDiaFTILAf1MgIXZ9bV2bkDD84S+96ZKBaL3Bsa5x5IiyXU8BCM2GKE179cdzq0OU04XliK7Yy+UHM/kg2+8LPeGNDaj/Wv/JBkA9ZB0DW6wMY8JWxsEXMVWWKKyXdSym+OevhzHXyzf3kT+y9S1dGyH9B7s/MrKozBNeTDRVhgkkUD9x4EnE6hObuLzMlx/QHb3W2gLpiSTfo6SYqSOLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlqFqRhpLHpNXHb5UjXynsmn7xjz+W8YPOo35/156Mg=;
 b=FHTkZgK6vsooreUY1z8h0UpSnoEKhKS4ZpDD5uUYgcBJbpzTnmUPHqrId8Q8dmqmDfW6UdHZh0c+YuxDSCMqr2jtu6doVV3lum84Zlo3qas/VzVQlyYgmdLluexzRNG9N3iKhHy0Dy1cWYKug/voUhbkC3pdh+P1GzQX2+KVc6A=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB5598.namprd10.prod.outlook.com (2603:10b6:a03:3d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 16:58:01 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701%6]) with mapi id 15.20.4523.014; Fri, 17 Sep 2021
 16:58:01 +0000
Subject: Re: [PATCH v3] target: core: remove from tmr_list at lun unlink
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210915141719.1484-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <40b321b4-76bd-8eb4-84bd-c7378ad2bbc7@oracle.com>
Date:   Fri, 17 Sep 2021 11:57:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210915141719.1484-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0111.namprd07.prod.outlook.com
 (2603:10b6:4:ae::40) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM5PR07CA0111.namprd07.prod.outlook.com (2603:10b6:4:ae::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 16:58:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7b6c37b-3c96-472e-4ef9-08d979fc4f25
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5598:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5598572AA8737B1B021ADEF3F1DD9@SJ0PR10MB5598.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1AA701uhyvDb2iYJeWJMrktC3GBpuwxN3BP0QegA0Xx3zQw2KQ3DENC47NGXQAO/Lef+gsgsXgEwsNoaYtKpRsu/Bfn6FxhSwKw8RhyqySOc+pylV8YO+uiDlIwyUwqZVfiFhJvIFUR4IM5qpCPeD2qPBn9kQl8Go8wKbCt7EDknZSq5jm6TytzFP8sQSGSB12m/3OPfSBjT5lwah1h5RFhvT7NJ0AUvIy+EZBqqCz7MdWCfcMykYfqyGJ47Xwbp8HPsq+pWjAIOu3d3+xBQGx6eWs3hWoFeZr1HMIHOt2OSKPm1H+eJ/pcI9tKNFdO0jP+7ZTf/nCi3yVC7Tzp6cuuI+ygwKnoLckz8gaFPS+nUi+r0wGn6lXkyV80+mBs20OdjXMMY0v6vbBS3BIi7+Z6J0HBgNl43J9q2f20d/5I2PV4tHZM3E0pLWtissdSeeo+L3E4q0AB9PPvz6kFCtRwfI1TPqNumgSW9GsEcNPaXZMt9zznlXACnSsJ7bB5skhT/j61azULaoVtuJIdno2yE3IWM7MGc3Tu6vCaBkBq/MCOG70XlVTRG8COHTsfdjmI+MvQgbOt+4jclFcgOoYHbXLIX9KghDZ2oyAZe2dyHKHJBtRgncbZ8lJJJ1sU6kiPa1LPg8mkW26GIuoPPlVKpSOPxfWDkKq+w5sfiBNqBMHX8EO0WJQBlqb3SYxkoSPqtoFSDAJCOlErSwyqJjOU/+cJNizq/ykrERPHxfOLcy+ZIuIIqLHdBebYrTptumwHnNJI8E1N6/MeXdyRp+uJ34dxRpIxZbwZjkW96i9sSDEVw7JcM1B/0LrQVoVuMCekWqhwDJOqHeNKQoWIrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(6706004)(508600001)(6486002)(2906002)(36756003)(54906003)(38100700002)(31696002)(4326008)(316002)(16576012)(53546011)(956004)(2616005)(86362001)(966005)(186003)(26005)(5660300002)(8936002)(66476007)(66946007)(8676002)(66556008)(83380400001)(31686004)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmdtSDlvM0JWcUpIbW8xMVRmMnFtbUI3S1NDUzFjQ1NtdXdlcERYWS9zRVlz?=
 =?utf-8?B?eWNCVktxVDdqOEJjWW1jL2QxSm00REtWZjI4TS9jMDBqNnZpOW1yVWU0YmVH?=
 =?utf-8?B?YjZXUFAxdmN1ckpPb3BpMW5ta01TRzBKRFRuK0xTN0xzNDJJZ1loMGFDaEZ5?=
 =?utf-8?B?OFh4aEpIYXVDZWpFb3dvZWRwYko0b1p3ZXQ1S1ZTT2dvc2JsMkxHWEh1SzhK?=
 =?utf-8?B?UEg3eDRzZCtsMWdXQlFkSHdWZjlvZU9PMWpZRWNmT1h5dEVTWU1nTzNKN0NP?=
 =?utf-8?B?RDU3OEVjQmFJWHl4NURpTklILzFDWEU5Wm9xLzBPRy8xTG56MmpzTFZQTUw4?=
 =?utf-8?B?QVYwMXBkUzJ4Wks1MEVTVGJRYnRGRlhLSE80VGJaNXpURnNxd2NiWEZHeHBq?=
 =?utf-8?B?SW54U1NvVDUxdG9PQURjbU91Y1gzaS9tMTRlTHVralRiZkdLdHhDaXpOekZ6?=
 =?utf-8?B?NEp6dkxjL2YzVFFwTXorQTl5ZDU3RURtZk9LWlU2bC9zTTVXL1hrZEd2M2Fr?=
 =?utf-8?B?cndZdThZYURWRVVBRVdMMTFocE8wMTVHdlRUVms3MDd6U3FWWGovcHVIbTZp?=
 =?utf-8?B?NmpLWEdoQUtKakcrSjMvNzJvSlcyTno0SXFGVDBnSjd3TksybkVKYlhXS2JT?=
 =?utf-8?B?Vzk3dzYwck5mYnUvMVQ0NUQyTXNkUzhHY0lTY2crdVRjVDY1YlcxMHhRNkQ3?=
 =?utf-8?B?RFVlNnBsTHBHMzZDNmlmVDhqNFg2VkQwZkRVbk1PNC9lTDg1YXZabW1TUXpF?=
 =?utf-8?B?NDN4VzByTDBLOHo0Y3VIRzRKWkxpMGNoZFEzeTZiOUc2cDIrUjc1RnJWc0Vk?=
 =?utf-8?B?U0lCTzVib05RYUYwVnBVdUZIMkh0RkJXcVB6b0V3SEg2TnVGTnM5MlZrZ2Fi?=
 =?utf-8?B?ZHhNQjZzZ1g3ZzJxNm11NXNNNkdpWmg5dEFIcy9mU1BKM0ViSmREdVJXbW9L?=
 =?utf-8?B?YjNPRzM5L1ZTNnZBRWtTUXE0TnNLejl1UjlRcmo3THFmRm1IdVBWRDdSdTVa?=
 =?utf-8?B?cWdNZFo0alFBTlNIL2FEM3F6SUpWTnN1VUlwL1hFMlFNNnVveERVOG5oSE9K?=
 =?utf-8?B?THpSRllrelg2QnlqamZGUTZWc2pnWWZlZVdoK3prNnlmQml1ZzVXQXRsOEJB?=
 =?utf-8?B?RkJDem0wT0xrMS8yY3RqQnhKays1OGFIYlZHTlluWVp6QTJhbkJvRjRXazFt?=
 =?utf-8?B?T0NGTGg1OEJnSVRLTWwxOUxiZExXdUpTNFVvZWtwZkFlcmhMMGZEMkI1Mnlh?=
 =?utf-8?B?Z2pRdzlyWVQ3cmVDQkxYOTZkQ29Ed21wUk0wWHJuc042d2hwenE0R0NBcy9m?=
 =?utf-8?B?bXdFVEJaMEwycWppRC9rQzRjbTIwcDE0akxWeXIyMkVzRmh1czRaODR3UlRK?=
 =?utf-8?B?em1zTW8rYXhkMGo3MVdKMHN6V3BLOXBXbmQxd3p6N1UxcjJpbzZnVU9sM3Nm?=
 =?utf-8?B?TFVuMjNVZ2RDR1hacW9iaGRWNGdIUDJJRURhREhmYnlETHBDb1JLdkNPTVY3?=
 =?utf-8?B?TEcvR0FjaHdzaEhhaFR4Z3RxSThZYUE0clRNenFtaEI3ZTNaL0wzTFVGNkxP?=
 =?utf-8?B?N2xaM1dqZnN5aXM1aVBHcHdHWGo5VVk2OXdHcVdNM3pNZUhnOUpVdnZDR0Fp?=
 =?utf-8?B?ZDVPZU03eXVyaVh6QlNtaDcyRGdQQW55MzhFM2xRSU4xcjBBTkEraWV0QkdO?=
 =?utf-8?B?cW9VNm9HdUpZOFpLTVBGNkdmY3hYcGljSWlTa1RLSDJsTStveDU4VnlibFFG?=
 =?utf-8?Q?olies72U6WsMME9cWDxoJXYUKBMTnD7ZteoXfb/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b6c37b-3c96-472e-4ef9-08d979fc4f25
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 16:58:01.8119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wYuOPS2AFPb7zqxP9zcLLr3/jWhOOvvAKlCQh8QBM/26GGKeTfwCEuj7XHLgMmEQQagAeflB9fk0CO2L0MOtBYEc2Ln2rnbekKl00Zvdtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5598
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10110 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109170104
X-Proofpoint-ORIG-GUID: xzSsgJy8jWrtJL0QPZ80_Q2MWHoFq6Tn
X-Proofpoint-GUID: xzSsgJy8jWrtJL0QPZ80_Q2MWHoFq6Tn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/21 9:17 AM, Dmitry Bogdanov wrote:
> Currently TMF commands are removed from de_device.dev_tmf_list at
> the very end of se_cmd lifecycle. But se_lun unlinks from se_cmd
> up on a command status (response) is queued in transport layer.
> It means that LUN and backend device can be deleted meantime and at
> the moment of repsonse completion a panic is occured:
> 
> target_tmr_work()
> 	cmd->se_tfo->queue_tm_rsp(cmd); // send abort_rsp to a wire
> 	transport_lun_remove_cmd(cmd) // unlink se_cmd from se_lun
> - // - // - // -
> <<<--- lun remove
> <<<--- core backend device remove
> - // - // - // -
> qlt_handle_abts_completion()
>   tfo->free_mcmd()
>     transport_generic_free_cmd()
>       target_put_sess_cmd()
>         core_tmr_release_req() {
>           if (dev) { // backend device, can not be null
>             spin_lock_irqsave(&dev->se_tmr_lock, flags); //<<<--- CRASH
> 
> Call Trace:
> NIP [c000000000e1683c] _raw_spin_lock_irqsave+0x2c/0xc0
> LR [c00800000e433338] core_tmr_release_req+0x40/0xa0 [target_core_mod]
> Call Trace:
> (unreliable)
> 0x0
> target_put_sess_cmd+0x2a0/0x370 [target_core_mod]
> transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
> tcm_qla2xxx_complete_mcmd+0x28/0x50 [tcm_qla2xxx]
> process_one_work+0x2c4/0x5c0
> worker_thread+0x88/0x690
> 
> For FC protocol it is a race condition, but for iSCSI protocol it is
> easyly reproduced by manual sending iSCSI commands:
> - Send some SCSI sommand
> - Send Abort of that command over iSCSI
> - Remove LUN on target
> - Send next iSCSI command to acknowledge the Abort_Response
> - target panics
> 
> There is no sense to keep the command in tmr_list until response
> completion, so move the removal from tmr_list from the response
> completion to the response queueing when lun is unlinked.
> Move the removal from state list too as it is a subject to the same
> race condition.
> 
> Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> 
> ---
> v3:
>  remove iscsi fix as not related to the issue
>  avoid double removal from tmr_list
> v2:
>  fix stuck in tmr list in error case
> 
> The issue exists from the very begining.
> I uploaded a scapy script that helps to reproduce the issue at
> https://gist.github.com/logost/cb93df41dd2432454324449b390403c4
> ---
>  drivers/target/target_core_tmr.c       | 10 +--------
>  drivers/target/target_core_transport.c | 30 ++++++++++++++++++++------
>  2 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index e7fcbc09f9db..84ae2fe456ec 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -50,15 +50,6 @@ EXPORT_SYMBOL(core_tmr_alloc_req);
>  
>  void core_tmr_release_req(struct se_tmr_req *tmr)
>  {
> -	struct se_device *dev = tmr->tmr_dev;
> -	unsigned long flags;
> -
> -	if (dev) {
> -		spin_lock_irqsave(&dev->se_tmr_lock, flags);
> -		list_del_init(&tmr->tmr_list);
> -		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
> -	}
> -
>  	kfree(tmr);
>  }
>  
> @@ -234,6 +225,7 @@ static void core_tmr_drain_tmr_list(
>  		}
>  
>  		list_move_tail(&tmr_p->tmr_list, &drain_tmr_list);
> +		tmr_p->tmr_dev = NULL;

Is this patch now adding a way to hit:

if (!tmr->tmr_dev)
	WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) < 0);                      

in core_tmr_abort_task?

You have the abort and lun reset works running on different CPUs.
The lun reset hits the above code first and clears tmr_dev.
The abort then hits the tmr->tmr_dev check and tries to do
transport_lookup_tmr_lun.

For the case where the lun is not removed, it looks like
transport_lookup_tmr_lun will add the tmr to the dev_tmr_list
but it would also be on the drain_tmr_list above so we would
hit list corruption.

For the case where the lun is getting removed, percpu_ref_tryget_live
would fail in transport_lookup_tmr_lun and we hit the WARN_ON_ONCE.
I think though with your patch, we would be ok and don't want
the WARN_ON_ONCE, right? The lun reset would just wait for the
abort. When it completes the abort and reset complete as expected.
