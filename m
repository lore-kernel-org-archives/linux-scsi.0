Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195BCC07E98
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 05:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD56613DA
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 05:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhGEFyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 01:54:03 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8716 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhGEFyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 01:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625464287; x=1657000287;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PoJs6MwGXxypggBl17p7m0ec3cBNEjQ42acyklYLwaA=;
  b=pJyRI/MoAFjAqjiUCh7wa3EJhU9wc2sbxoTvLqvhpkuIDlYlZVEzv8Ph
   IfPNYVNq3ojwrWT3k98u3jrK+NJUnXQaIsxaWA0EWaZhMEwnozPfddZlD
   j+5kGYcNMf2TJKh5OdTc4f/tEE4iDX5V1n0u/Qi3Ql23lwFdbqZc/DRLf
   D7vMxU+zkOrG6v7aoTLsbi2F5DCSHdlldb5njkWNkqPsmnK1OSkDpWjJo
   zWW+iwoRYZ+KDY+863zK1BOqIwz38oXhPfcdzJCg8AUKbsV/pQRqRaHmL
   L16fHF46iSTkXqtuAxX4/1VQPraEmzuKJjVIZSInBl63hDWueoDXVhqug
   g==;
IronPort-SDR: 1Cwa+1Ln/HNT+7fBVKVWlouEiUCw2Uzes/yjUax1mPsjadq8+V83lAyOtSuVV/yPIiDrSSL9rn
 KbkgNeXwMOhZMiXPWY1a/koB0wFY9kZ+LSfqi12Dd9S7Qe/rPXJL3qNtlTkhNPjIKMjkDFC8bH
 um8ROJo0PHGWCdTeQapvldStvAJxwbDOclc7jQ9Vu+1az+JJGZE2eA5n7YTD/yus7kJh6HNlkE
 h8ddTiIFZcbmbKwjROCOWagdMIT3CcE9mOhtNDMFHw1m+JAsZ47nLiALyQ3tGfs/10MAvtRYOr
 1AA=
X-IronPort-AV: E=Sophos;i="5.83,325,1616428800"; 
   d="scan'208";a="172949986"
Received: from mail-bn8nam08lp2044.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.44])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2021 13:51:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ki2V8UD7BMCtnmkFrB77+mrca6CxKC8p84Lmjh0dkuuYn3DNKrjnmB94JO24RjmpIWQpt0NLYUYguAObgGboeJWPfXtsHFjr/sQ5XEwOsYfMmqigAxqWzoeq+YxaSboMkW6OjfY4COzNXKTYnZQIZ+FQpKWc3L5HzOffGQ9jRLSh4NhrOfFztgV0YO7pLmJUPh6Xop0DP0iU0y2sgmHD0Z6wSoHlLTPsasM1qhmPUk2b24ql3BmoXw+geywk8m7l0xev3L9Ks1vdDgyJ8q0Na1W5YI5cW+r+jrJ6w6lgf7XkHGbvx/NZ5VS7qfWwyIkt1hIpZ84hFSZQAPWzNcBySg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEPSnBqBEztFq3Wlb6cpKm2EPxb4xiFTQac4jfuihv8=;
 b=J6IV+mFVm+aY8PgaACgvnxtdW4+JH8+JL0XoyKBzolDi9uKzrRom88q/SMn3UzVYY3IB7uoLGhYmUFFjDi4tk9g6Ll22NwmXdlO/0K38RbJ1Lu8ajY4C9GGVB1SZ3IvhR7Xt68etslA8okyt1m4WfbGqG7PFEaj4gjrBzOee6jWuqCtvZCr+DnAoCr8ENzcPWQSSosxOdSmjQQS9gpejqFA1Gw0VAiGB+NYlvKTL4r+jIOzkGndvBYggGVUieHnYVPaBAxoj0aVbGY+klGfXU7U6zjclVXvg65Ae+USfSZta45jaMYuuMJCAApx43rYs9a4bYzM/uFtN+inmB4xTjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEPSnBqBEztFq3Wlb6cpKm2EPxb4xiFTQac4jfuihv8=;
 b=lZbsaK+OtWnesAm4OKrK0GL0bBdKHJ7BSXapLM40ncIbrpaRlSDHYJpjBc8o8oIO9Jy1rE5Z+QwZFXoyC79993HFT4ZnSIjc4RGmSh0A52rg7Ts3l5pGvbAZ8qN5whZnOpA0XzBbiNlOvBh/Aw526JbTnprOsY8Gfh4TPICW1II=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0267.namprd04.prod.outlook.com (2603:10b6:3:6f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.21; Mon, 5 Jul 2021 05:51:23 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 05:51:23 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: RE: [PATCH 01/21] Fix the documentation of the scsi_execute() time
 parameter
Thread-Topic: [PATCH 01/21] Fix the documentation of the scsi_execute() time
 parameter
Thread-Index: AQHXbr3TrsypMbrrdUSzat34IRa8sasz5enw
Date:   Mon, 5 Jul 2021 05:51:22 +0000
Message-ID: <DM6PR04MB65757AE4497490A268F4A70CFC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-2-bvanassche@acm.org>
In-Reply-To: <20210701211224.17070-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26eb6c3b-0bee-421d-dd48-08d93f78eba4
x-ms-traffictypediagnostic: DM5PR04MB0267:
x-microsoft-antispam-prvs: <DM5PR04MB0267396007D6C1286722785FFC1C9@DM5PR04MB0267.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1k4InmUdEX4hHbOy2YJtSmfrW7zsZ7dd1CQT3I1Glm6KM3NytduQALKM5Ukn49R4he29/FY6hmcd9CRF2tyyYMuhg2n67box9smH/nRgbPm7v9WL6jtYw3Ju+XlCDMUUr4d8XN9b06oPyrTSX2XIkfvrdZ5bxDyoOcbXbfiHijzUalxTva+GP5Y6N6oRv5nXOr4i/RdDJ2XISnibhkaKSvc1wT89wf7nqlpqhwC8TYFEjl9mDbV1B2+j5yWu8PBor/7Q/sLJaao3/FCYJfS4fV1zK0fpfouCE1lCwsmAlP1bUW6oOaM/N6R8E9pI9wab1SIkp6KsN+/g9sUsOcXfLDNU312A0IYgt0bDEtglw0f2XUbqo1gdkfNjDzEWsuP9w1VYN7bVyz4bWiXOUy4xsxCRrEibmI3dlXN7gf9ILVlAjGQmVVC1Yv2P3V1MZdGwx2UG/bMl8KfA/YIbPO7lzyiJtJ/9KxGjtxsvAOMiWVypRO/ohNwa2hPemYKW+wQBAk4PsfkviPRktL4U9SDQgG2vKwmbUsiC6IbZVL0hTxbp8I+PTs83mCOm5jhNVHVGtP/F2ngl3ZAjmbhm/ip6FX1EdVCWeXCweU8TKfyfgxX3h8dp3wasSfMjZVtEF8Qeq7wzschQBhbLBB9OTnfgKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(55016002)(110136005)(33656002)(8676002)(8936002)(316002)(186003)(7696005)(71200400001)(76116006)(66556008)(38100700002)(66446008)(122000001)(66476007)(26005)(64756008)(6506007)(54906003)(66946007)(478600001)(9686003)(5660300002)(83380400001)(52536014)(86362001)(4326008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hhYcE4ltAOdgDjScJoLK6p9GTN5O0OlqAmPCQBdor7sqR2VUh34iv8fnehu1?=
 =?us-ascii?Q?uEthn3FcY+bRe0QAPANkdjYZEa6ahmXXptmYx3jnwtAqZcidKPkfElP4AeLi?=
 =?us-ascii?Q?F7obuS9x8HqEh46VLtg3oozT07MvfYo4OROmDTRtr5xZfx3/KU91XqIErwoy?=
 =?us-ascii?Q?gPRmfl9btlQUJmGxxfQDOKTFRGE24PbCnN6kDqnrQoWiyWekLiL7Iekjo1Jk?=
 =?us-ascii?Q?jLtGYrsVnLRmQEko+G4Yco3jr7HEe/vSJf4CpyzYe+/tuiLXBpNaiKGZMywv?=
 =?us-ascii?Q?zxSSh5BgJ3kvPCzc7Nf4dMQRAUyLlumh95a9HyoZKvvN4g/6jb8U4yiJiTNV?=
 =?us-ascii?Q?ZBMiZEY2jUYJy0Yn3bVLGpOZq48Lfdr7hIsqJSD0o0yF+ug/p2sfWP8dDDlW?=
 =?us-ascii?Q?2NFjRQOq+fgkw4xhWiNZqPX1eTlPkdw/iPee5YN2uRg/YnH2vlRMkPS3c30B?=
 =?us-ascii?Q?xUHejl42ZBSf2kdlO+Tk7IVMF1DJtB0pcLXerYDSJ4QTk4f7+dewuujlcdtg?=
 =?us-ascii?Q?zZrUZqECoNwapqX8/ybCwC6llskble4WMV9JC6+DZHFWiRXjRubbc4XprK/N?=
 =?us-ascii?Q?kARn8S+pxGxqdztxyrqwEG6ykzQ1bz50iY+dJupsDowlvB+Vr7+677Xm7uVE?=
 =?us-ascii?Q?P15vEDpi3niPtrBwPs+x9lGlTardwnJDZsrOG3jOMfLcKtIE02v3nBcGly8Z?=
 =?us-ascii?Q?ZAIWIfBp2y3rPYqsaaoHc++JJbVMhHtz11yCPY7W+O3htwkrRwYOwnXNTJ9J?=
 =?us-ascii?Q?zWMff+U7/RdYkGlriNRaD7Doi0JKv6mfKbRFLi5lLH5eyXzD4nw4Sh5ENQ8G?=
 =?us-ascii?Q?FK3f+OCNU+ADD9ddldxDEvVEaVsGlYkv0FybsifGjTeZ6I2brJuUktf8VYg5?=
 =?us-ascii?Q?1pvGUJMO2NScBTEcyqidWq4KrKwUPrJcn0QDXiAUzWgeKFUEGBtcQBVdsIoQ?=
 =?us-ascii?Q?ZBE/T59zq4kjo1QdRzngykWOkoIfBKse0fe8NYgAv73m+xlin0KgKbkfV8lm?=
 =?us-ascii?Q?LYiAMulQ851LCsVQy3PTC9nkQyiySf+eRIfePffUoDJ/Q3fCQTeqdJDeW7SS?=
 =?us-ascii?Q?wfY3+pfggSVvFf4TdEpn/bpPFgQ1W9MDdQzhUfRz3erg8+kDyYqKheOP8OOi?=
 =?us-ascii?Q?Xkj0mrJhwJkBhlbytr3kMILsCGED6MdEd+6mkZHynifVD8q1mm+ak8aTLsV0?=
 =?us-ascii?Q?FAMyVAhKzm48JVxXtvHcL3nkvXxV6/aH7TDWTUr9brRC900UsiAkf4GRERSu?=
 =?us-ascii?Q?b0QsY8/yOWXecYdLawHARl1AugsuDilpkr2f1/mZJOBB5/xXzFwubebZmR3V?=
 =?us-ascii?Q?5pMcGdGuciiDYYGZ0ATrHtak?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26eb6c3b-0bee-421d-dd48-08d93f78eba4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 05:51:23.0656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1IBaC7VSjIgu5Eno7TUY2Ctvl+9rpOJygISJz+ObV6wqChsS9jbK7s4z16HspVROpY89sg+wCuuj0Q3yMQZ7hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0267
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> The unit of the scsi_execute() timeout parameter is 1/HZ seconds instead =
of
> one second, just like the timeouts used in the block layer. Fix the
> documentation header above the definition of the scsi_execute() macro.
>=20
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.garry@huawei.com>
> Fixes: "[SCSI] use scatter lists for all block pc requests and simplify h=
w
> handlers" # v2.6.16.28
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7184f93dfe15..4b56e06faa5e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -194,7 +194,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int
> reason)
>   * @bufflen:   len of buffer
>   * @sense:     optional sense buffer
>   * @sshdr:     optional decoded sense header
> - * @timeout:   request timeout in seconds
> + * @timeout:   request timeout in HZ
>   * @retries:   number of times to retry request
>   * @flags:     flags for ->cmd_flags
>   * @rq_flags:  flags for ->rq_flags
