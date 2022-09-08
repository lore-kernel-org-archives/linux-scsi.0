Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD71C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 16:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiIHQD3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 12:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiIHQD1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 12:03:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305B9E22B8
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 09:03:27 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288Fbc0H019678;
        Thu, 8 Sep 2022 16:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5SdfL+HpzBcznMliCtlOlXH3ZS9BMPHZGxqH2LPYg2k=;
 b=nW5YfBiG1Ipd6zHrDQXBxdS/80mwohFjWpaFyP2sUH9G0/zBpKbabSUkOExuBGpGmAjC
 iOx/lu66rytmJbPZumMR1wwItFbY3EOhoWzBlLEOv+0NYNLinP7YrU13/fjnm5by9gHB
 5PbbRdkKfOddc7BSxG9D7zplKiJIxm5U1LtWTCziP+HR5SMEDo/tPYZgSWAtTC7qAKAn
 XJTefkZY+FXbFRx7tu4GS0Rj1hnfYULWTYKhGoEbFGukVnMQ//1NQjdsgB1PM6w0zuqP
 FeD4MRC5MOn2AQ5nQMjmgQKPNJ+hLwlj6Ni1WXKjuxnwvfpyb8UFZi/ZuEKx3o+tO7yC lw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwbcc2r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Sep 2022 16:03:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 288FLMYP028912;
        Thu, 8 Sep 2022 16:03:06 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jf7v6thbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Sep 2022 16:03:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ae25ODsW1AVz93UhKc9MYOvuQHjaqwg0Jg7e1dS0/PJOxCSeezcv54meC3dpC+4j8Cnzzkf+oo7FD4roI55dnCI3ptiz9qnpM3t1Y2zwzLbcb4kVYFdy3ZCj8aancYxO2YMQGhF6b0u4sQYHRzAaQk5eTAt3GCzjbA0/UVmppOyiTnsN+BNeL+5yuTE/+QTKXMP7+xKh168aWK+IsEiwFH5ayevGp9Gj9kq2EKo11oxM+RH113Gx9zxc1UT8DH0st67mHppqnmBcwaTZj6HnqSncYwQyNIJRMKLkcLs1xPNk3CJf9qVlUVNcqsnV0QBmVWonevyO75ksUZb/8oJMnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SdfL+HpzBcznMliCtlOlXH3ZS9BMPHZGxqH2LPYg2k=;
 b=OnXWrtMxns30d+kFMTis7z8IC6iOzCPg6A57TX0GijccCQMmQY0aPUgwfTBeOLEPMOYVwgqoT00bwAxDeKyfuhEixZeZSM8qeoZKkYJ6o2eXPhUuMYBzSb96XMVl2WPgKLtEm46oCBdCBDQHltZNgpFdZlox4uitwbHC/vg0e+ZXJlpFgDWTvFQDVIK8Iy4q5GWKSsMuqoUzjlszXLe1z4wJl1toVk+Bu7fOnDI1nl0CvRNe4ozzODSxDCyZdhyFNB4IL4zVNHk2IURoczK6cc2+OuiXWWgceOekY07OfLaZP1VrTIBkF2Zf1CTGJfrX3rI9I52BKCPToxzwWcaCug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SdfL+HpzBcznMliCtlOlXH3ZS9BMPHZGxqH2LPYg2k=;
 b=Ra8XUhyWPufMEu3b+5WA2WehQiCW39nOWJEQyNh5M3tqUaKNP7mbQLAVMH6Y8qhTmg8ix39ojmA8T8weYOoJLxYVq/1/VV/MoYj2rfS7FbYISIoZBOLw5hLdOu1ZcFRUGenmJXueilnnpFCRjYGy5NTAAtCfx3QfWOcUV3v5tqA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB4920.namprd10.prod.outlook.com (2603:10b6:408:128::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Thu, 8 Sep
 2022 16:03:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 16:03:03 +0000
Message-ID: <1a530d46-03e3-0ec4-b633-3ebd2297a525@oracle.com>
Date:   Thu, 8 Sep 2022 11:03:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 2/2] scsi: core: Introduce a new list for SCSI proc
 directory entries
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220830210509.1919493-1-bvanassche@acm.org>
 <20220830210509.1919493-3-bvanassche@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220830210509.1919493-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0085.namprd04.prod.outlook.com
 (2603:10b6:610:74::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB4920:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bcfdce3-f219-4b1b-1bbe-08da91b39c12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAMBo4GYzGkKXQ9Ypv/wxsaV2DSrZtHcKwKuzYaTUAvGc6W0rZFYhK0Q7X4Qh2tYjaM8o/wEK32aoD/PMGxW+oRiWvJhi2HfcEYDRE7zZ+trsV0TRS89xLj8cEUc6SId3/0iFqoiObnn/tnHzqC09LGyTHjQ29iOqP4lL17gX1YpoL/hZS5SPtuRw6x+Z+fGKQuP+2HejiDL1NLnOGEh6R8jR6YA5HFqKws0PBo6UzjTRUT/wQaw1tOuW9k2Cf12oEkR1dixcK7yvBukmtk6xnQVtEEr4EK6ysybEeG8amXGSFgi9QEEEaiEnY1gyM0WCP4QcaMdC2L+NLNMCyBXwgJ7my0wdaukVYMpOss/j8UPKAQS1vhpzNdmPIEju1Xqni3hL4ClFmJzLNL+RU2xOQ1BWDt8MoMlK49d3+pqt0UhJ8ALsi1CAyoh3qiQCpv/iUbl4F85caUZFOlIpkan9+n8M90TZ2pjGNY2GKlgUj20qMMyN2896yujuRAFqN1MH6y7IBta/fr59fQYdLdpKCtfewgkneRA33WltmkMBIqk4w6LmuRlFt8uczba1ybZxIMx8EvoACnZpCqqDV+E+QTqLSuVR6B05GPaavSeQiw2+GclhucILPJT6ZjdEcaLJ4m7nRCd39XdYfTPXkhYW6Ch9t2qtpBEc50aSA4SdCHBVdubavOuPBMfnme63BI1GUrEN21nE8KBq4VeftU+yf/MgMNGuCbmhBjhnQ7i4anJr9yVaVTgEXON1RbKOI/CASTjWVYCTBtsBs2Uvz+vqtlvLriSVOJGxh8ZkLqbZ6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(376002)(39860400002)(366004)(54906003)(38100700002)(31686004)(36756003)(66476007)(66556008)(8936002)(8676002)(5660300002)(4326008)(186003)(66946007)(2616005)(41300700001)(6636002)(26005)(110136005)(316002)(31696002)(6506007)(86362001)(53546011)(6486002)(6512007)(2906002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3VXYkYwK1lOSlVhVjc5WTU1QnlWRkVwbVZZZTJ5VG1peW9wNS9mS2s3SE1y?=
 =?utf-8?B?Y2Nia2Nhd002bFplUTFUd2p4UUE4TU9JOFVRYVpMWmEwZ3FNcGlXTVRadVFW?=
 =?utf-8?B?Nlp3SmVZVHU4M2kzeXc5bDh4b3JncEd5TzlaTDRvWDluL01Ia0pIRmxIeENj?=
 =?utf-8?B?TDZYbVppZkNNaGVtUkllelVTbW1GcGpmeDBZQTgvdkd1cHhvUElKLzN0a1FS?=
 =?utf-8?B?UU96VjNCcGVtbGVrZmVEWEJ2U2tpWmt6VmFNa0NFMFdJS3VDYjZOR1dQVmtz?=
 =?utf-8?B?UUo5M2dVSDAvaDFLbmtsRGZ5UnZLZUtMN3NmU2xZZ2V6TkZCa3gxYW4rcXZ3?=
 =?utf-8?B?TEpGUmJMTDJFdFRqZGY3NGlyV2x5RFVhaGtKRy9GUG90L0h1UCs1cDJoall5?=
 =?utf-8?B?WFI2SkRqZ1F4ald0Z1BOTWpYUVlHWXlGYU1FWkw3cE15emNyM2wyWnFrMUt6?=
 =?utf-8?B?MjRKNXFrV2lObE9la2JZQ0ZTY0pGa3dhc2ZHRHczOWtHNGhYd1NGVEhKMHVm?=
 =?utf-8?B?ekRGcFhJZGlOMExIeGlLNHNMdEp6Q1BJQzAySzJEWWhoblBVWnNBYWdleitZ?=
 =?utf-8?B?amJSZDJ3a0lEOHdMNkMvbDZCeEdpSktDb2VkMmZvWGRFbzEzZWd4eW5yVEhN?=
 =?utf-8?B?VEhMSTlsdjFRZXhsSVFobHNkUXAvYklaOWxUZUVzSDd3aVZOOVpSRVc4L1lu?=
 =?utf-8?B?S3BVWTltTE9nN0NhN3dOM3diei9vMnF1RmkrNVF6cjMxYnRoOTRiN3oyOCta?=
 =?utf-8?B?Qlo3Sm5vVVZTMlBMN3oweko3RU80bVpibm9uSEkvTzUxWDBDQlkyb05BVFNl?=
 =?utf-8?B?dHF0T2RTL0V4c3NCNFBxM0QxUElxZG4wK3RqbldiV1hlalV0ZzNZSndQZDdL?=
 =?utf-8?B?M2xhd1dCWkQxa05tcDVqeU1JK3VqUE5ORlV5b1JsaExuTFpVRmFKWmYwTEtx?=
 =?utf-8?B?Z0YyaVlJUEQ5eG0xQlcwMTR2VHlOL1RWUS8wK1VralJBckUzQ0lMQ2ROMzM5?=
 =?utf-8?B?YXZCYzV3bnlVNlJybmlVRTBPejZaRzFDUnFhZXFIWEZsa3JrYzlFWlQ4ZE1r?=
 =?utf-8?B?azY3WHZNeVFTb3d1Rzl6MWNKOHVWR0JxakdOL3ZkbUVuanFwVHJBVVdTL2Uv?=
 =?utf-8?B?YUEyc2prb0gxOU50UHVGSW5jMmlXcndLcm5VSHRiaHRaMm5yU2YzdHk4V251?=
 =?utf-8?B?NEFkM3ZJc0R1ZE5tV2xUUEJidXNvU0JtTU1NV0U0cE9Jb2dab1djUFU4UDVk?=
 =?utf-8?B?eTZSeWhGd1NLZWdXWjQrR1VVY0svVkdUdnFaMG9JRHVMLzZ3a0Znc0pSTHpF?=
 =?utf-8?B?ZVBsaGtkdXh6WGt1NFQ1OEFzcFJnajdxVFN1clUxR0M3N2t5Yks3QnJFb2hj?=
 =?utf-8?B?WGZ4bCsraTdyR0E0S1l3NnZxditjRHF3OGpFZUZYNW9EbC9PdVFnZHJuSTZq?=
 =?utf-8?B?TGVnNlRDeFQwVGpOVTduSFp5UzBwZjNSUzBleXozazBzUTlyRVdnb08wQXE3?=
 =?utf-8?B?eG5IdytDSlZjYURYdDZXVTB1QWdSVURsTE5hd3NqVTBUdGpicW5VYi93U01D?=
 =?utf-8?B?VDExcCtpQmh0aHhEbVMwcjhMR3ZmS3QrcGU4d1JMWXhQM2VDc1VTMWFPS0k2?=
 =?utf-8?B?cnBqblkrR0pncGRDZE0rcEtBUFo0Z3NsYStjQ1p1K1ZDM3phWmV4d0ZTTU9y?=
 =?utf-8?B?TUo0cXVWNElWSE9DRHFFdWdkZmkxK1diYXl3ekVnckdwWjJEUlFlUDBkY1NI?=
 =?utf-8?B?elN5aGU4S240Z0htTTh5Q1JCWXhLVUFuZ01BOFRsWGd0MkFRTmdWaFhKVThS?=
 =?utf-8?B?SHRnTTVLbWxvQW1ISHNkMEJOQnpRWnM1dGtSYjdqWVVhRk5rRFVDQ25ZYkNn?=
 =?utf-8?B?QUZWeEJrbUdqMVBhTHB1QkNROC9YeDVEVy9wL3hIMloyd1Nlc0ZuelYzMUhQ?=
 =?utf-8?B?ZFFUN1M5SVJET2NtZW5ROVRUOEo0cDZGUXpaQ3VrNzlGUjNCbk9Hdm1PbERT?=
 =?utf-8?B?WGFmVzhpODVWanRKSG5ISnlkNmdnV2hYN2tQVThRbS9raHNvYzVsYUVjZStP?=
 =?utf-8?B?Y3lWTkFVeFBpRitrU0dTWTZaWUdySEVBajJ3Y0V6dGk1OTJDVUNDdU84WUxG?=
 =?utf-8?B?YzZOYXRSVlBLYjVWMnRudjd1R2pFL0lqaTY2M0luSmo0eXdEdThWM2FITVMv?=
 =?utf-8?B?NWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bcfdce3-f219-4b1b-1bbe-08da91b39c12
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:03:03.1358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+APiTXQMgprVBvsd1K1pN9Nmkz7GjN9XVU/XM/SyEaJV/nbvl0zDlFs1unn2zDazM7gI+NPO8R495cg5V+Uo8iIlD7Ga7CEFPR5BTo/dcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_10,2022-09-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209080058
X-Proofpoint-ORIG-GUID: 2XTaF3uHsbEfMnp0X5Wqkv8ItebatFHD
X-Proofpoint-GUID: 2XTaF3uHsbEfMnp0X5Wqkv8ItebatFHD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/30/22 4:05 PM, Bart Van Assche wrote:
> Instead of using scsi_host_template members to track the SCSI proc
> directory entries, track these entries in a list. This patch changes the
> time needed for looking up the proc dir pointer from O(1) into O(n). I
> think this is acceptable since the number of SCSI host adapter types per
> host is usually small (less than ten).
> 
> This patch has been tested by attaching two USB storage devices to a
> qemu host:
> 


>  }
> @@ -149,15 +214,17 @@ void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
>  void scsi_proc_host_add(struct Scsi_Host *shost)
>  {
>  	struct scsi_host_template *sht = shost->hostt;
> +	struct scsi_proc_entry *e;
>  	struct proc_dir_entry *p;
>  	char name[10];
>  
> -	if (!sht->proc_dir)


>   */
>  void scsi_proc_host_rm(struct Scsi_Host *shost)
>  {
> +	struct scsi_proc_entry *e;
>  	char name[10];
>  
> -	if (!shost->hostt->proc_dir)


Hey Bart, Would it better to replace those two checks with a

if (!sht->show_info)
	return;

like is done in scsi_proc_hostdir_add/scsi_proc_hostdir_rm? In those
hostdir functions if show_info is not set, you will not add an entry to
scsi_proc_list. So in the above functions if that callout is not set
you know there is no entry on &scsi_proc_list and don't need to grab the
global_host_template_mutex for those cases.

I can't really test but someone did say they had 1000s of scsi_hosts for
iscsi. I'm not really sure how big a deal it is since we wouldn't be
doing a lot of work with that mutex hold, but it seems like a simple and
nice change just in case.



