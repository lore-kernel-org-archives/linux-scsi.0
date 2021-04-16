Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA1BC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 15:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70228611AF
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 15:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343739AbhDPPYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 11:24:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47206 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbhDPPYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 11:24:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GFJJbn034617;
        Fri, 16 Apr 2021 15:23:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gL9DPbSKdVz0iMcXUbVgF7e+lebNoBpuKS825rvgmUE=;
 b=OoRr6YES2QlkZ/jLQ+HT5z65y2Ga2Py6HmMR5rr6xRZDwECwWbTcTJePu8F7xYmhYvms
 3f9Lrf9h0SzFRthTaItgsFIe4eeRZwdyhW1miDN1zs2zy2Y8A2uIu+k8ei745tN4Ic6x
 1KWMzWjunupMxzU570Ljw9apNbvVGx+hUHB21Xerr/W+jOtCEkh3/BCiC46JzQYskQtU
 TwWJIB9Yp/NvVHsV3l+VYPe6TNo8PdopH4yrZU3xg3HLkYjlK/RcCeCOh7mQLOSqezVD
 pp4VglJTHdJQsyHWelATu/WsSDEcul8Wn0uZb29HqltH0VaycSAubf/n/NG7l8oA0qgm TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nnsfgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 15:23:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GFKZ1h009838;
        Fri, 16 Apr 2021 15:23:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by userp3030.oracle.com with ESMTP id 37uny2tuyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 15:23:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMvLsYSSU80MMQECmxDgv0ziiWjX8YeORT1CAEpfGxQZcjUWZzmk3occsO8n4189I1U3PP74S5zjrbs6Zw7bb9bIad4Xg0Kaqn0S/PH8SGZAND0ZDXGCzyU7/8rq2DieOGHJr2KvUHhzk/BBtYihdUQQiqXxapdI1WFmQhKpX6VZRPKqxyq9Ri37vB2cnuJWOzFGUPbiabayA1GGLI/7BN30CCnXSzYGDGjmTpYRZdPlzbw4kSWFbDgk6BfRnDsL1Uj89r8SuUTk23A/J+sH5zqw+zBk8AqBNw5ZaAhPPDcimzwFd/tNmC4gbPGtQy2K3X/SDCgQo0NoQ7Jv0WdqkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gL9DPbSKdVz0iMcXUbVgF7e+lebNoBpuKS825rvgmUE=;
 b=dqd560sEG6ppBlVCd73B1Z8Bh3ue7/b/xHxMnMsVIw9+RZ3sgj2Q97s8UkOttsnhNyI7fnLobLF9ThXRBtHsVmolca+3YcuDzA93wuAq5FntQieFoMBD629HJhld9HNajZMaGnrcWBP7Ykwyan//hzpu21p/nKYTZQBRo2flmHEmBTO0RBnoAJ45eLeK5gVzh2bcKQTZuj+MG5LuXh8jFJr3Ux+hwVT+tWohh4WzdrIuSaSSriJRngkniDJ/p1q8+l5v/YDfIEwGEBqAmqCI0Y3Cqn5PD+2HVCxAMahx77V2MCT9nRr9pdAJQkMaWIh9NEmIboGgjc5Gxb7bNZqmkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gL9DPbSKdVz0iMcXUbVgF7e+lebNoBpuKS825rvgmUE=;
 b=Mh/dylb2zUUwz7krYkbDkxaXhogoVtsfAD1ZU/6tUzbV3/SRm2tVivERMjoPBD320HIbvWs5Vko3DRJdK6LIYwyl6gaJ9deKcEqmDP+wjt3E82j1zhXreZggsGmzsRBPwObPBjYcB8DbUrZh+2ycKSaZ6pQ9m5BQBk6rdxE0QR4=
Authentication-Results: lists.01.org; dkim=none (message not signed)
 header.d=none;lists.01.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4227.namprd10.prod.outlook.com (2603:10b6:a03:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 15:23:42 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 15:23:42 +0000
Subject: Re: [PATCH v3 09/17] scsi: qedi: fix race during abort timeouts
To:     kernel test robot <lkp@intel.com>, lduncan@suse.com,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     kbuild-all@lists.01.org
References: <20210416020440.259271-10-michael.christie@oracle.com>
 <202104161932.IKLfImK0-lkp@intel.com>
From:   michael.christie@oracle.com
Message-ID: <22d09c83-53d4-37a5-1490-e4c8b4fb34e5@oracle.com>
Date:   Fri, 16 Apr 2021 10:23:39 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <202104161932.IKLfImK0-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR1101CA0010.namprd11.prod.outlook.com
 (2603:10b6:4:4c::20) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM5PR1101CA0010.namprd11.prod.outlook.com (2603:10b6:4:4c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 15:23:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be5499c6-8718-4728-e373-08d900eb9e36
X-MS-TrafficTypeDiagnostic: BY5PR10MB4227:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB422706C20A768462C8BF6BB7F14C9@BY5PR10MB4227.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGuoMh/ejB1WuJFQpDYgng/wNwAj13ST8VA+I74p9EcD5m8HGfVExKoLsJQaQj0fW3z/SbbjIZ40vmaH3MdOO6HTCnmRcL+xtFjTROifGDCKr30IJ4Ie4o+mQeeiUJPhe8Nrqm9FBBuOSERxJ2udkMRhApHJi6SCtXfn7A6P/ddZHs8w6vKYOQU0GHzcYus15RouoTnVqWYxsvZgB+gd9JY4wzITzbfxLWRei34Tui5tevnZ0Y5v1W9gGxA0HrXzTJZOv69wFi8Sc1A6F1Erx9B7tXp2CPybQQV2Wzxt+eC/ngG/NjjZGFMRujMeHwa4xWr7gTMNvsogASIlL3Q+52quzX7t0LfGfEjYpZP8WHPX3rz+OyYGz51NfcnPjFjlc5JEy3bki8KxsS1mqH9FbgWqhTsOvS3BZ5KmAeXVFqeLdehW4gDQI1ik/d59EyijVUS4SU5J7WJf/NgVLcqf0PpYnWr/FXQ4dxAPD0heYeewUTx9eCg2VtPKawBIkp7kCzoWIOVC5ZurRPW6hn3eKq/RKpvGjweOYsUyABYD3NiN42pSdJvvnhk/XOBEM9o2eNvhvTwEPL1ly69R0U85l+tsrPvKLwCyU3F2IAVIizLhERIzTOQUh9s+VDalIG5avs5aYBo3k+Rr1/7hwyQwaSAVUP4AvNjyY4OY1xHOHn3hXI6PRYq6ChIjKrNU701pO0BooEak11LMxOiQGZb1O0hrNt0nVUqwHisP2JZz9g8oRcC1SvHCnD2qcJ+jJPcj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(39860400002)(346002)(366004)(186003)(16526019)(26005)(8676002)(8936002)(6706004)(86362001)(83380400001)(31696002)(16576012)(2616005)(6486002)(316002)(53546011)(31686004)(9686003)(956004)(966005)(508600001)(66556008)(66476007)(66946007)(38100700002)(5660300002)(2906002)(36756003)(4326008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?Iz488hN/ucVvCkPxXyRdueRUq0ZM0pZ3DyTutP1KaivL4YFgtq4eGoB3?=
 =?Windows-1252?Q?wSeVQluUiOA4z/7s4Nr+qU4ZhmryUZRU8MzpFhVOWxld22wKXv0Pxw+0?=
 =?Windows-1252?Q?auG7chNLMGZFNleSbsKCCBEXcalFsva9u96c0KfWZAB19HewUMcf8eYS?=
 =?Windows-1252?Q?b6ZONXxZzAyl81JjhBr1mns3yqTEnLY8R9GnGjniuxEZP00VAjBFg8Xu?=
 =?Windows-1252?Q?DkTZp2TxSZGb3a/635Yli8YCFQdhRqTLLvSGlQGFCxfLpaDWUBpkrnyM?=
 =?Windows-1252?Q?NGNJj52BOrWA1lLNZgAZPmOez4GpNidQ7ZJXjVt6JHVNLyLUnGjibiRx?=
 =?Windows-1252?Q?0RdVBB7esORIH39tCFDRxKwjUtTuV6aoaAIGkTaD3Wpfez9JTWnlts74?=
 =?Windows-1252?Q?ZkBQpqCPukj98q24MEJX8U8twQvXehDmmG9TRJ1SsleSdkIk16hlk9zN?=
 =?Windows-1252?Q?Jg73bCtDQ8QURgEWWwYpqNGz9Wlmpo1ZgYfb3CNlfP9ZyQYjd8tqYPih?=
 =?Windows-1252?Q?diFc5cGFK37lYcFlY0hKRZnDhuwdhHcMu2W4FRXfWPGGr+x+2zLBj0ba?=
 =?Windows-1252?Q?M+muCSoHyrW1VOj+cjhs8R8oS+2YR//wJqNzByweEkxRNerB2CRpZazi?=
 =?Windows-1252?Q?ajrmvlWiiGq8m1TlaMLYMHCBjzmzlHGHZc6TwWh6PhOwk/p6Lg5re3G2?=
 =?Windows-1252?Q?QEMwkKHoIybpKPaiiv7Xdod9bxo19NLxV7PIkq68Q/5dZ4s2ct0ze+Mu?=
 =?Windows-1252?Q?CuXHn+Y3h+hK/OobgAQWFP7CMD0E/3dT4rm9i5hI1MuGIgYatF39YUUn?=
 =?Windows-1252?Q?mpdkm2wMYy6YDMZM+AJj670n2FHNdyC96i8njoR79lSd7KEGA9n72YNE?=
 =?Windows-1252?Q?B27mhcuy5wiuC1w6FskQgoOm7ttyxV1aXLxWFIsPWGtGVhSSs2StPkRy?=
 =?Windows-1252?Q?5XKK/erMkC2QUxQu7hmFXpl/Uwzo1dwl8OYrcKo94cIj8BClH2GrSE5t?=
 =?Windows-1252?Q?Cp905andE3etEMgOYxLhBjzeNYlAAXKSkafmMLlhhp8uaYO9WoR+nQrW?=
 =?Windows-1252?Q?Q4qJQEj+4DyidKxJAhnxk6OzgUTdtzNOLPf53KMrPYrL7z7xPadd03FT?=
 =?Windows-1252?Q?6N9B8vHL7JvK4u2F1PxHQ5scXl5DLPZjw0ysp3OI7RLlGUT8MFwj10aF?=
 =?Windows-1252?Q?JwhSACUFNHrIMWgPAsT8Nc75OrLoO+uT1fWaKPxMWiLPYc5E37pE554x?=
 =?Windows-1252?Q?xXrog2ud33DR/AnobDL7NveKYhHZMD91WF9ZT3MEHit2DpH94T/TSLDF?=
 =?Windows-1252?Q?GNCdiTLRyU3MNvEhWyK+FPFgABs/RsVlNrImOmD+20peArvly2yum+NS?=
 =?Windows-1252?Q?XCgYcToGUtzWIPFSCyMoKAtFQv4arnCZnseSMHFQS78ykWzxILpMF+tL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be5499c6-8718-4728-e373-08d900eb9e36
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 15:23:42.3116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ooUiM+gPrJXCaXw9chFerAm30M5lnaISegAQcvhzFszojY/pIQRcrBOJkXb9S32q+snAEBadhhn6vSCXzgfYCCUdzjTDj4xvVR6wPcLo/W8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4227
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160113
X-Proofpoint-ORIG-GUID: 567dcZit_BMCnbTeUbfn7iKSo2Adh80V
X-Proofpoint-GUID: 567dcZit_BMCnbTeUbfn7iKSo2Adh80V
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/21 6:39 AM, kernel test robot wrote:
> Hi Mike,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on scsi/for-next]
> [also build test WARNING on next-20210415]
> [cannot apply to mkp-scsi/for-next rdma/for-next v5.12-rc7]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://urldefense.com/v3/__https://git-scm.com/docs/git-format-patch__;!!GqivPVa7Brio!K_yd3PgNpxVzRkCVNpUtU5QvHwf3ZeBn4YApf8XPaoGgBtPOUbOk2psKJy1r2IFRM6gm$ ]
> 
> url:    https://urldefense.com/v3/__https://github.com/0day-ci/linux/commits/Mike-Christie/libicsi-and-qedi-TMF-fixes/20210416-100636__;!!GqivPVa7Brio!K_yd3PgNpxVzRkCVNpUtU5QvHwf3ZeBn4YApf8XPaoGgBtPOUbOk2psKJy1r2ORa91HY$ 
> base:   https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git__;!!GqivPVa7Brio!K_yd3PgNpxVzRkCVNpUtU5QvHwf3ZeBn4YApf8XPaoGgBtPOUbOk2psKJy1r2KfCj7gr$  for-next
> config: alpha-randconfig-r016-20210416 (attached as .config)
> compiler: alpha-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://urldefense.com/v3/__https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross__;!!GqivPVa7Brio!K_yd3PgNpxVzRkCVNpUtU5QvHwf3ZeBn4YApf8XPaoGgBtPOUbOk2psKJy1r2CW-OqAH$  -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://urldefense.com/v3/__https://github.com/0day-ci/linux/commit/9d4a83c1316e3dad2bd5687563584509a3d6557c__;!!GqivPVa7Brio!K_yd3PgNpxVzRkCVNpUtU5QvHwf3ZeBn4YApf8XPaoGgBtPOUbOk2psKJy1r2PS1L82b$ 
>         git remote add linux-review https://urldefense.com/v3/__https://github.com/0day-ci/linux__;!!GqivPVa7Brio!K_yd3PgNpxVzRkCVNpUtU5QvHwf3ZeBn4YApf8XPaoGgBtPOUbOk2psKJy1r2PxZzIp1$ 
>         git fetch --no-tags linux-review Mike-Christie/libicsi-and-qedi-TMF-fixes/20210416-100636
>         git checkout 9d4a83c1316e3dad2bd5687563584509a3d6557c
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross W=1 ARCH=alpha 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/scsi/qedi/qedi_fw.c: In function 'qedi_process_cmd_cleanup_resp':
>>> drivers/scsi/qedi/qedi_fw.c:741:6: warning: variable 'rtid' set but not used [-Wunused-but-set-variable]
>      741 |  u32 rtid = 0;
>          |      ^~~~

Darn. I used W=12 and just missed it between 2 other old warnings I normally
ignore.

Will fix and resend when Lee reviews the core iscsi patches.
