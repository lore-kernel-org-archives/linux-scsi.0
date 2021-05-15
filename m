Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19C5C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 22:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8672E61369
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 22:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhEOWQm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 May 2021 18:16:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58126 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbhEOWQG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2021 18:16:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FMEoY9093529;
        Sat, 15 May 2021 22:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nuJhLA6xPh1RSUzhHfkPpmkzsUEl22/sCq+i2Er+uUA=;
 b=hu/l2ISiN9IVJBAmPBcGNuMaJRPv3SED1rbUOLWgKRaSWtBIdRGGPsgU0qeoeFWY9MhP
 /FTZ1BdJaCxC1Ibnqi+BKTTdFXoXySDA+T2Nb3srKt6WtXyp+p7C2RRLUVj5PHruhBaz
 pW52MUPOvRouub55mCfZ/U3S8ZpC9CAXJbbGIVJwf8Z6pv37TX2DwoGjciWGo5hIvIsZ
 kodFVRK4Z+rpMiTgrFHqzxKHHN4u6SX3pB1/vWPgELCp7qOPfc5tgcYTK3RXi5QmmK8j
 qohTAa+bDvDhNg0gILoEaxxYokZWnnemo3UA2JKYE3yvioj4OEJWLITmPqK4SS5ZOfIj /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38j5qr0rkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 22:14:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FM6Y8A033122;
        Sat, 15 May 2021 22:14:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 38j5mjqnef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 22:14:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MctwPDtmJ2KmBbypxxHQCpbXFwqjf8ts2DLMPwLuap6FOGzQgishvjs8QEPx642Jbrw26eb1kTP2loTtWw+ShYT3sG6w1s9w+QTekvPksBLTHF1h27TAb1hOiaOExEOfBzlHV+UrAVhb3VscXIcYbm/aloygRsYazgcOSKcqBBhNZWWLBpj/zxqnLW1H41w3yc+nlZZ51BWMJUUJVV7LC7YOR8TKIyZ/F+SAlTKpCDKsqBwO4wLY2yufE/6kpjwXhsJ3ETkbh4KD17hA/Ig2BLZh09zzv19Q9ORSQ8hk00g7iWZt90vjMjVRl1A//u2AkJgTHEvv+WMnYX4+Vfk6jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuJhLA6xPh1RSUzhHfkPpmkzsUEl22/sCq+i2Er+uUA=;
 b=Ocq4m7zO3HzS7BRm0chdbKSOyWuNEuoYmSrOJkg3Mj50WjQUyvTMuG4R7z2KhmPYpacwaAgKVToETtQ0m4JtPUixZV74q1AqnaiaagihqqwW5vrSDwVUJdNj4xhiTQpYo3mW+QeXwYxS7EVxTled2oGw9eBcwcI8j83XGed7Z73DjXAZ4pMhs3+bB6VuE/j+w9Sv81Ve8gj5qAwmDurPLTUGS+MaPc315wpMEQAo9HfZkWoDYP+1rJwtysveq8dXUniEYpQTaFWK2nxXQKSXdkceWley5DTPMJoJPoOUbLZ1LXNmFowTimd8f5Bnu7/p048lPmC1WvH9sbMrWqrIkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuJhLA6xPh1RSUzhHfkPpmkzsUEl22/sCq+i2Er+uUA=;
 b=zJngvvukln43Euj9t2BOrpDrYI7Y6U0IFmZKvwMacdrUO/ovWjMY9sOJzKiqfsDwf3CtzhhqmFUhau/fc9LeO+zTQNyHiJJDeGA5FncrAi4NToab/wgkXXdKC2+JxyTB2w1VF50M0AU1htuzJXRJyoNtZAkk1WH5U7bdAdG14GE=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4583.namprd10.prod.outlook.com (2603:10b6:510:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 22:14:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.031; Sat, 15 May 2021
 22:14:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] qedf: Added NULL pointer checks in qedf_update_link_speed().
Date:   Sat, 15 May 2021 18:14:41 -0400
Message-Id: <162111686570.18985.11322586554420465578.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512072533.23618-1-jhasan@marvell.com>
References: <20210512072533.23618-1-jhasan@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:805:de::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR05CA0011.namprd05.prod.outlook.com (2603:10b6:805:de::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 22:14:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cb39569-fed6-4652-d82d-08d917eed955
X-MS-TrafficTypeDiagnostic: PH0PR10MB4583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB458372CF821F842BF52A33DE8E2F9@PH0PR10MB4583.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52YgmcYTz2OO5e2rl2tvnvjLsKbMOhIuygd3t1fxtygHKavKjHUvfmTxXVB4DQ6nyx3/PhBYKfnTDTZ8HY08VNTx+87EUohbDoZbGb6umFSUW5Aow6Asng13aDEcZUL08EChV6WndK3/8D/V0MSHGCvVvvF4Aqe0m4hqQOMONN57Kbwrvpizj31AUnMn39SbcuAPll/BLMncDSfQVqdNpFBkO5DJddqJ9R8ZNQJFUGpipPszWIzfLTpWf//GW8ZtIsYCo2zgo7bCLwkgXt7cHULLzN4bAdULqNqtsAxVPQp7TBB1TGu5T5A3SLoUiD75pjBJFVRKg3pzU3kgnDMPNL2jOkVKFoixV33CPoX1fcsvEeer6fdFTy2cmRIW+OopaLwzDm7AKQshm1yELjScOyu0SfQ/Tfoa7Sqy/ZKu7QgzZ7a9ncr7SGcXfZH9sPyFuQBq9yhlzLFlQFMkx6+tCM1xtyyKGQ5ZDWitWyhRd0SCDlg2uo+JwFKgpiwbqh/mw/cscr2OYKIPd3jrswkxm/LrJT7sjQOmAGoNtO+lBn8DoMMX8rwQrJYqJ/rhwcCjR3BJimc7Fn4p+UydmHpNCEiTAhQ+MZh2JF5Fa2NqcC9fyBhCX/1TDCa0pWHgBZd2wsFZIZRTGrtpaZaQOj0RGISFR7wZxHGOi4FfzhVxsYTBoplzXdTKWWf6/gjF7xe5wzWnBrQkcFpWuQFd3oiSNbtGSfEPM7fS9Zb7qdiHvw+GeB7cVHT2Mw7n9KTZkaDHtL8S+iFJ8Eztrk7JSVnnGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(136003)(346002)(366004)(8936002)(83380400001)(2906002)(478600001)(7696005)(66556008)(6916009)(36756003)(966005)(66476007)(8676002)(5660300002)(4326008)(38100700002)(316002)(6666004)(956004)(2616005)(186003)(16526019)(66946007)(26005)(38350700002)(86362001)(6486002)(103116003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cDZ4NnFHdXNIYWFNcktYZThTbVRMUjdvMVFSMytwQXppd1RXU2tXazhlTzJG?=
 =?utf-8?B?VVl5VGxNMGtCSzk1TmluRVFmMnhKQU9zMVN3M3czcXdyOXdHQ1JFRndRYitW?=
 =?utf-8?B?SWJqY0NlRXVqREtJc0lLZ0xESGE2Nm9rOERZT0tsR1N6aDB5Z05WdFg0a3FS?=
 =?utf-8?B?Rk5panhJZUJHd09LbW1NTnBlNlRWMUZESXFZRnRXOVl4TnpmMTFYUVluMEE5?=
 =?utf-8?B?NUZERERNYXoxUVNBZjliVHlIN3dmRC9IcUFOMjd4VWMyUVlGcWpKdTJUUW1X?=
 =?utf-8?B?L0o1bjUvQWxKZkRxMTlRcWZmSXdjVm5NTUF2b1R6aHVDVXVLVjNVL1BvYnh2?=
 =?utf-8?B?U0J2L2p5WkpRYlRvR0FpVXk0VXFJOW5iUVBiM0tQVXFWdGZDNnczMEYyZVZw?=
 =?utf-8?B?R3B3d05YQ2FZa2swaXMyenhjd2hVWEtCTU1SYW5zRXhmaE50YzJHVmNlL0po?=
 =?utf-8?B?RVJENjZFZmNuMnhBN0txbUpiQzM2YXQrdnJGL2hHTmhiRGdHWk11L1JYZ2U3?=
 =?utf-8?B?SGxSM0pKMWNVOTRvRE8yTUl3aCtad3ZzVWs2bkF6Q21rbS9GU2NjYjF3bEdi?=
 =?utf-8?B?aXFUS1J2VkZoMEFuaUZCRW9Wa0hHSVN6UDBZSXI4b2xBQklFSWppZDhtR21i?=
 =?utf-8?B?T3hpMWNIZG1EZDBTWEFwOFpheWhqUnBVOUcvRnROL3hhd2hKYjRVOWlGVmdV?=
 =?utf-8?B?VlpKbGNGYmdlR1VFakV1SjNDbGFnL3hLc0RFTmd0eGE4bXdVRGZ0YS9iMXBX?=
 =?utf-8?B?aGZhOUZDVnh5ZjdHSmZkNVQrOU5jN3c1aHZ6QmRSNEplOGxnOFBlV3VodUNn?=
 =?utf-8?B?TnJjbzZtcEdYLzNTVERkRytCNzBEdzR6ZEhiNkp1czRuVW53T2JraW90Sk5r?=
 =?utf-8?B?RGtUMlVLbGh4a2lzQ1ROR2pETzFDR2VOTlpwYnErZEdvTzFNaEpTWENtWUxq?=
 =?utf-8?B?bjVmbnM2NTN1ckFMdEJZcnJackZoaTZwZXFPSFNwY3pTNVdxdThTY1F1elFM?=
 =?utf-8?B?dWpLOGNQQ01vVWl2UU5tVVBRZm9uMWxhL2tsb2hmOW43dy95SGxXenY5eWx6?=
 =?utf-8?B?M3FaSFFjSStQZy80aEQxeVpaejFBUExQZG4xN1AwSnlOUUNpTkRxOXVOczdO?=
 =?utf-8?B?YXNlT25kN1JCVHBDT1BQMFZHYU9wUnJETjFjbjkrOHNNdzhPakt3MTFoRDEw?=
 =?utf-8?B?eHRnK0h3dFdrVTNtR3NraW9oYU9qYTU0ZXV3QUVwc3J3TWtXSVp3M2R5bTR4?=
 =?utf-8?B?bmEyZi8zM1Foa0xYSVVIQ2hFNjVkV0wvTm1IbFRvWno4QllmSUJ2SVNsdGtU?=
 =?utf-8?B?dHR0d0JsaGxBUmVsWUp2T3BRMzNRdENrZnB0VXBtTWltb3crOGtQU1JyMkhk?=
 =?utf-8?B?TWJaN1Y3L2s5TlZsZ2lvdjVCdXVaNS9VbVJtZ0hJM0l5VHBYNkgvQkNXb3Qy?=
 =?utf-8?B?VEozbUNaSHZlSGQ3bjV1Yyt0bDRJdC94TXFsZXNyY00rN21NbmpzWHF4YkJz?=
 =?utf-8?B?bFNPR3llaUR4U1NpMW56YjNaakNiQUVoa3RPWHJjRGduLzUyT0w4dkVGWUhh?=
 =?utf-8?B?a3JLVThrODNNSWUwVFVwZWdnUGFURlhWdFh1RVdiSVNaeDkyS0Z2R3djQ2xt?=
 =?utf-8?B?Z040cWNtWVdrd0FXclNMdk1RdzZacFREUHdja3ZCdTVpd0V2bmlWdXUzOXlD?=
 =?utf-8?B?ZHNwTGFSL21VSWtoZ0ZpeUNKUjJxQ0ZER0txUE5uTklQcFErU1E4M3hydjRS?=
 =?utf-8?Q?C95cBu2nI+8CjLiN9RLbPibIDf8KLPJB2H030Xk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb39569-fed6-4652-d82d-08d917eed955
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 22:14:46.7594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWDIRUllP6i9jFrUeD3Y0sdksSTk7g1kPnxRMjMs7Jv47qOPJtvU7u1gSDUwWhq2yVZ0A0xd4JQ4j3deGbJG0FBX3w9xDrCHX3MyDGUnNwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4583
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=935
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150169
X-Proofpoint-GUID: F0HVMwAq6hQms7MibJu6CRHB9As8iwpQ
X-Proofpoint-ORIG-GUID: F0HVMwAq6hQms7MibJu6CRHB9As8iwpQ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150170
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 12 May 2021 00:25:33 -0700, Javed Hasan wrote:

>  Issue :- BUG: unable to handle kernel NULL pointer dereference at 000000000000003c
>  On installation of RHEL-8.3.0-20200820.n.0 distro below stack
>  was generating on error.
> 
>  [   14.042059] Call Trace:
>  [   14.042061]  <IRQ>
>  [   14.042068]  qedf_link_update+0x144/0x1f0 [qedf]
>  [   14.042117]  qed_link_update+0x5c/0x80 [qed]
>  [   14.042135]  qed_mcp_handle_link_change+0x2d2/0x410 [qed]
>  [   14.042155]  ? qed_set_ptt+0x70/0x80 [qed]
>  [   14.042170]  ? qed_set_ptt+0x70/0x80 [qed]
>  [   14.042186]  ? qed_rd+0x13/0x40 [qed]
>  [   14.042205]  qed_mcp_handle_events+0x437/0x690 [qed]
>  [   14.042221]  ? qed_set_ptt+0x70/0x80 [qed]
>  [   14.042239]  qed_int_sp_dpc+0x3a6/0x3e0 [qed]
>  [   14.042245]  tasklet_action_common.isra.14+0x5a/0x100
>  [   14.042250]  __do_softirq+0xe4/0x2f8
>  [   14.042253]  irq_exit+0xf7/0x100
>  [   14.042255]  do_IRQ+0x7f/0xd0
>  [   14.042257]  common_interrupt+0xf/0xf
>  [   14.042259]  </IRQ>
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] qedf: Added NULL pointer checks in qedf_update_link_speed().
      https://git.kernel.org/mkp/scsi/c/73578af92a0f

-- 
Martin K. Petersen	Oracle Linux Engineering
