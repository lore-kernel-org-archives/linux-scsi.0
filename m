Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C03FC433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 17:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E2F64F5D
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 17:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhBCRNf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 12:13:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50786 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhBCRNd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 12:13:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113H8wGe082822;
        Wed, 3 Feb 2021 17:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=J5V6i0IkASYCc8dGq37N3jOEjFcwCZS5bmnuaQae9qc=;
 b=FUAkXhguWSxopDutQmF1vYW+yKjIO8+nobOJOq4wRRg1Buc+S857hR4wSd+1Lb4aCpEi
 zkmm8iGKXMPXnI/XHQdI1dX2hax51BjYlK5MN70Mhw8ktvJL+aoJBhPEnXdybafaNHoH
 oo69d6DMGRJW1Gsjmugb3isRjrFia+5hwmfwjDTgUjgu6mE4oBuTJCKgBeiLs4+/jLkJ
 HRMWnDCIAzdUNHWtGtjw94aIBIH3SqV1lYg2pjB8NPHgwwV/4PJ7a9ST1BM+WPwixHp7
 9wEs6OFucIs6lly143dH3cxZ4x11cqnLWJBfNoGbuYbMfiUT0drSXD22SaXo8qktIN+q vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36cydm15y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 17:12:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113H5ZnW129723;
        Wed, 3 Feb 2021 17:10:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 36dh1r6cjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 17:10:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNzno3UOBvKN7GUtYlrvcA74a9+96kyBJIIlfu7mJSf0VzhT6JnHQ6M8A9bvxMQoSnqAj2yA853abBVlMAFaxXRCnpZnM3u1weUStrmQHwTVdEw/Bw343pI+PzAGn5cSqPGV1iAIBkRhNB4ttfFBIhxJTcHkQLGouHclrSWPCkUxO5ZNYdaMg7BigC9jGSSXZkHml6XqfiHC3ZV7OCE2bmNT8/To2BuWXyjRXDHNWs926yPt5tAwow/FGDTL7/ILJXeNvkjMoj1B7xHKK3/w63UqQEZ9b45/U3TvOPNPGxR3lAP4P+tKZsp/dsyHyH/Dv7AaBx66N2YcYaOhmRissA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5V6i0IkASYCc8dGq37N3jOEjFcwCZS5bmnuaQae9qc=;
 b=dx/1vM7GTAI4BiL5zpvTNDqRNqPQbmxSJiGUWrbH7WSZ5YSS8Z7i1ml7jl86i6PrsQrrxCZdSJub1wQsK8KuqOzJMWMl/mObmRw61mee8mgtTnY2vj189/E45Feafgz8aG5M+EtA9VlwM4Y7wqRNkfe490xs9qx+QIjipyQYvuYOrVuV7PZYHTu+sNpE6swp1s1EtjNNOt3rWt9m8TP7EOI6D2ESoqDwB8rgLuGl0jnqCZZQr/LTCQZIjyV1juCfKhIY2WgmGHMFs3xsGe90+or0TUz5Clb5GdrzaNDAa13gEEdu72yDvXqFOaSaJ2ASPX2Q36RdJAdsJNV29bQQ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5V6i0IkASYCc8dGq37N3jOEjFcwCZS5bmnuaQae9qc=;
 b=sUOU4fiLUfHpNy0Wr4HcpuM78z9iFcRzae3CMSKl1Bxg4l0/Q6wOzZLYt4Te1R35PM2iy6Pd9apnp/AAS3yRzM/r7fnDLchsjReFq1I6cBtyscTg/nlNMS1Ec+zE+jaRSkwyUocMcYMeRmoRq+ghkHeb0oi7E6EbCss1hFGpfIs=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN6PR1001MB2388.namprd10.prod.outlook.com (2603:10b6:405:2c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Wed, 3 Feb
 2021 17:10:29 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 17:10:29 +0000
Subject: Re: [PATCH 2/9] libiscsi: drop taskqueuelock
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lkp@intel.com, kbuild-all@lists.01.org, lutianxiong@huawei.com,
        linfeilong@huawei.com, liuzhiqiang26@huawei.com,
        haowenchao@huawei.com
References: <20210203101942.GU2696@kadam>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <c32c814b-20fb-c10a-1ace-26a7e07327e3@oracle.com>
Date:   Wed, 3 Feb 2021 11:10:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210203101942.GU2696@kadam>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR11CA0013.namprd11.prod.outlook.com
 (2603:10b6:610:54::23) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR11CA0013.namprd11.prod.outlook.com (2603:10b6:610:54::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 17:10:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70d2b022-83a4-4742-ec79-08d8c8669b11
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2388:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR1001MB23881136AB9A24F34D906FA5F1B49@BN6PR1001MB2388.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQ55JhqCalS7+Z4NW18i4+5kWbfu3kefcxGDa+ZH8HIGsMqb/IVi2cMIuLFSNaYL8K2fzZAZs/Y1J4jJ4rDmFvxsII1cop7S8hwCg5ngTAsj59agZ3GjQR6sntqzfjwNbOVo8/j0MNiCAxm9TFI1NQ2ZjPg6N62UI7ZyKjRoswUgiJo5AtPUceQEvrSBdk+4FTA91SZji7G7SU20tq9QDHLmVWTw6fHQUQxNw+JkmhE5WmeMZzVeG6mhqGjp3luVUZFzOJU0Hk0CiLE70vrDpgMyVBGHufXjyGsFrgJ9J9tbgGmUyyEIEK47nz4E94mXeuNXJ1skE6CG+Q9xtA/Lnlmpgs2eCslJOqpNLxcdhyWwRkuBmhpuNEQTUz23O0NtEQpr3sz3rq/PrpoxAtFxBA/YXWoBn3kc5NPl9D1cwJV2fXEdMRKZZfe3XopWOa0rlRRRMT4agGkMXDCAMUvLU78Ryk0IHoF9FtNFNJm/9D0SEGUbsKr6kFBB3XRQYbkB15la6r9nUX/4YFRQXJlFTFhtbjGMwHv6ufJGvlylrTB1kX4M2a1jz1qmzM23k2ru539Yixx4E9qKcmgtPVFtA1Nt3bf1PFJyEbQDZQOtaMlBtofWtptEkVVb18t/pTy2ZCGs/FVbZ7autFCto3fmdBOr/W0iOrdOYzifn04EHRRlYxYDquwsMuhuuGIsMbxZpF8aBSzJCqNMh0aA+3Gd+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(396003)(366004)(4326008)(6706004)(2906002)(2616005)(36756003)(6486002)(86362001)(8936002)(26005)(956004)(186003)(53546011)(31696002)(5660300002)(66946007)(8676002)(478600001)(66476007)(16576012)(7416002)(31686004)(966005)(83380400001)(66556008)(16526019)(316002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?FFcHMTnC8hFX6vJ+/zVPxZgvLVIqbRRLEe24cP+vuGOgSm/iIrY0uxt9?=
 =?Windows-1252?Q?y7CKNEQdhCnX5dGRx2MHmPlOECCB8gt2QVTD7uCoCBdBbRerSo+ZquHW?=
 =?Windows-1252?Q?S3IYLYkRzE2RoRK64Gk2f4xNRLl+wAwFtLYVhva+TQkusdq56qCq+FUq?=
 =?Windows-1252?Q?XPOz74bRe/CFRbjy+KwHOiyncFwtPDE3Ow78qHFZoTyyyqgZHT/ymD+v?=
 =?Windows-1252?Q?44li3PG0/fx8tNV7nKhVe0c2AGAlcVeGc7krazQXQ940k29K7QhM7x9d?=
 =?Windows-1252?Q?41+lwNP33ma+T1qC4mRvYyCeJS1QeQRDis7xUy6tLLFt900PotTCRoCO?=
 =?Windows-1252?Q?iIVQWsiCN/zp26h6GwgXt9ip12J7axOp19Ajgi5t17VtxToGWVorKKha?=
 =?Windows-1252?Q?GCOohko3iKEIzRSldW8td12ABe/jRrlbo3c6ERBOr5z93qKKGOctlFmW?=
 =?Windows-1252?Q?rp+dofKoo1/M18vvzRzEKtUJk898CDzlHyvlDTKREfHydYxeaCZGdwaI?=
 =?Windows-1252?Q?HadiJapK1iKGSD+mNNFg3Z2eZ0wYUhSSgVu6PbCM0EBMMRAzA74x44uO?=
 =?Windows-1252?Q?2JhTUp508WWdHDTYuCTTZzeNSfiBLoGbsndKvedZqp2Gy+l1eS4+YQwQ?=
 =?Windows-1252?Q?8d2dM+qUGws6EtAyM/jmaSzXbMkpm3oIjHfe2o1zMU6GVcP0cMpvvqOf?=
 =?Windows-1252?Q?vJqH2TOgbk4co+79geR3YVNM8qbjENWENSKZF8hpPbxqTcXkMMiAZH3E?=
 =?Windows-1252?Q?u4aPGsDdjsmKRhlXrbCcyitHyVdeKpT9tED1FBHXA094BnucUGMReQnL?=
 =?Windows-1252?Q?iZH/8WewMEexUchD6weEpXnYEjuwrzt58DLgEStcmj+2/Bt6PrG9YTyO?=
 =?Windows-1252?Q?OFMk9EzZD+ZPVqR2YR++GCuDByIy6IE7b11AFr1aqjsa6KykcIeaz26O?=
 =?Windows-1252?Q?EArbZjk4naCQ4ncErZ3T/QmVfR53kTIaqeirrRP9eh06UIpRHZQZEfR9?=
 =?Windows-1252?Q?6MA4S++pkPUvoD6DSNl9UO3dmbyLkWMwr5ss1zQx9QLXB1LBu4JcCUfR?=
 =?Windows-1252?Q?bKNMIDCZSdRhnLEMT3x5i1ekPrCv2Y7LW2YEV+yNbjQ63oLWOixel0+f?=
 =?Windows-1252?Q?LV+EjaGPaowiIYSkqZ9V6Y/p?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d2b022-83a4-4742-ec79-08d8c8669b11
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 17:10:28.9176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKdYgGpI07tAGiLA14k8AhopLDu8gd98wwfwHZnp1XSG5q32+QafIflMyXnK2cVovca43ijEwTviUJKmiXdmrQerZIebNKXKi1S1w035rPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2388
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/21 4:19 AM, Dan Carpenter wrote:
> Hi Mike,
> 
> url:    https://github.com/0day-ci/linux/commits/Mike-Christie/iscsi-fixes-and-cleanups/20210203-122757
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: i386-randconfig-m021-20210202 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> drivers/scsi/libiscsi_tcp.c:586 iscsi_tcp_r2t_rsp() warn: variable dereferenced before check 'task->sc' (see line 547)
> 
> vim +586 drivers/scsi/libiscsi_tcp.c
> 
> f7dbf0662a0167 Mike Christie     2021-02-02  529  static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
> a081c13e39b5c1 Mike Christie     2008-12-02  530  {
> a081c13e39b5c1 Mike Christie     2008-12-02  531  	struct iscsi_session *session = conn->session;
> f7dbf0662a0167 Mike Christie     2021-02-02  532  	struct iscsi_tcp_task *tcp_task;
> f7dbf0662a0167 Mike Christie     2021-02-02  533  	struct iscsi_tcp_conn *tcp_conn;
> f7dbf0662a0167 Mike Christie     2021-02-02  534  	struct iscsi_r2t_rsp *rhdr;
> a081c13e39b5c1 Mike Christie     2008-12-02  535  	struct iscsi_r2t_info *r2t;
> f7dbf0662a0167 Mike Christie     2021-02-02  536  	struct iscsi_task *task;
> 5d0fddd0a72d30 Shlomo Pongratz   2014-02-07  537  	u32 data_length;
> 5d0fddd0a72d30 Shlomo Pongratz   2014-02-07  538  	u32 data_offset;
> f7dbf0662a0167 Mike Christie     2021-02-02  539  	int r2tsn;
> a081c13e39b5c1 Mike Christie     2008-12-02  540  	int rc;
> a081c13e39b5c1 Mike Christie     2008-12-02  541  
> f7dbf0662a0167 Mike Christie     2021-02-02  542  	spin_lock(&session->back_lock);
> f7dbf0662a0167 Mike Christie     2021-02-02  543  	task = iscsi_itt_to_ctask(conn, hdr->itt);
> f7dbf0662a0167 Mike Christie     2021-02-02  544  	if (!task) {
> f7dbf0662a0167 Mike Christie     2021-02-02  545  		spin_unlock(&session->back_lock);
> f7dbf0662a0167 Mike Christie     2021-02-02  546  		return ISCSI_ERR_BAD_ITT;
> f7dbf0662a0167 Mike Christie     2021-02-02 @547  	} else if (task->sc->sc_data_direction != DMA_TO_DEVICE) {
>                                                                    ^^^^^^^^
> New unchecked dereference.

I see the issue. iscsi_itt_ctask checks task->sc and if NULL returns NULL.
However, below in this function there is now a not needed task->sc check.
The checker saw that and thinks the above line could be a invalid access.

I'll fix the patch by removing the old check since it's confusing code
that's also not needed since it's done for us now.

