Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7D7C4338F
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Jul 2021 13:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9631860E09
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Jul 2021 13:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhGYMjw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Jul 2021 08:39:52 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:12433 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhGYMjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jul 2021 08:39:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627219222; x=1658755222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QILe7nH880Yfzlh0yxKjgUs5Swli9PcUvDBoAYO7lyg=;
  b=r8ElOnwLvo3VE5J07iOwfaUCl+hQSw0ovTl216SKC8zSLadX40jS5hrW
   siMaTWmd0A8HlKDAgO7eUlKRLFx4EKnTdi64x+ar0A2tu3bRqR6fH/8Ao
   Iw6z7z/IqBVQDnOkv3ESiN1U/wn+vFXCnMfNdo0zExbOxqzqbrZ0JFNx6
   tjkVv7wxpxgrOJ1LO0Lk1+1HKuAZmbwxBsSskAXXLHA2GbAd3+1tx2E3U
   2lffN+b8q57tbPj7NB/Z4aQlbCIjAH/Dl6NuozLxvSlc09/gqCWoPFsKa
   xADCafrGVTvWCj9BaA0pw3fn5tYhVKSpJHrEkauPSWutmRYTeSTV5uqe7
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,266,1620662400"; 
   d="scan'208";a="279268690"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2021 21:20:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O71CuiPoTIvN8TR03/8wEupGtMqMVzUpbKUin4xo7wJZkqBs5i1+wlBDrY4rTn1NAS+gPYPMbaDhGmxYAoqJLv0oTDAOETpR/gsiwV8d1acvZlsBZ7R3+Kh3FR3u17tsD1eVThubwNkpQUOZjRPvZI5RW6xxtOQzvIjzOxS6phi3B+8ZvuGrkXajCHPDR1I2HFUgX4C5+UhapIqk3EsLDLvG6sfZUSEEhiJ40QlZ4pu3RCgQ01r9BFJdys5oDuR3oJntGaaVK1txcNSwJZSy5dvo876py2lzrpCZH/RU+MEzUN+aQ2XqoWUXlwxqzkY6AJHBWAB+JQ6ovQAa354T7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Inv6yA6VnyAe7PryaiFHBqiTowtrRqUqbGEqh649pnE=;
 b=MMY5ZB71NDuPKTht/2Sy1milS2WKdPEjt62/Za/6ffhMVOQ7wZNUXTA35z5tooaoBhnnwq0Glupj8FT7VU2Bt1nt7r676vGynLLXf1N0gk+PHiNq3p1GD1c4sfFZcDgTPbJcqIQKTzLiL+FrHidyYZVEObAk4YZzhbI4vp7ujQvTeD8pm5bN2MNosF4io/HFml1ZMuXGrSyXgUPceE7emPAByfe2VSqMVokfNUuiRihV/QbSm9UoKA4S3fsQ6Sh9z0wIyx43N+qDY8fknenoJDF9cyVJ7O7kc+7GMFRj8N3O+3auUgJWakWzrqafg4JDt4fAwnnmcxEbP4+f6x+B4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Inv6yA6VnyAe7PryaiFHBqiTowtrRqUqbGEqh649pnE=;
 b=0E0aAgCJkdW4zX4vU8cvbvzda6ua9NGCIbbIBzJxWGXGeGDJX1UXOEGAnYz9fm8qCbC8VyyzBGIwnM5SI2skv7pmYuWQVe5Mmt6rARL4/ZbfIW4NZok/gqfE6SSnm7kovKiupm1SFYIGT3iA9SzvgiYO/T5QvYwKPn+JlCfsebs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4844.namprd04.prod.outlook.com (2603:10b6:5:1f::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.29; Sun, 25 Jul 2021 13:20:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4352.031; Sun, 25 Jul 2021
 13:20:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v3 09/18] scsi: ufs: Remove several wmb() calls
Thread-Topic: [PATCH v3 09/18] scsi: ufs: Remove several wmb() calls
Thread-Index: AQHXfqqiP0mxlZQv4EadUI/0R11BX6tTsb2A
Date:   Sun, 25 Jul 2021 13:20:19 +0000
Message-ID: <DM6PR04MB6575F9CC44AFA830C4442FB0FCE79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-10-bvanassche@acm.org>
In-Reply-To: <20210722033439.26550-10-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ce21ccd-65a8-4fc4-8584-08d94f6ef396
x-ms-traffictypediagnostic: DM6PR04MB4844:
x-microsoft-antispam-prvs: <DM6PR04MB48446ED42321BC4872267C61FCE79@DM6PR04MB4844.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +skclTMljtH7zjSVZFGYOJGo0sVvoes7jYx5uDaLR0ya7yGi+VEzvy19mGhmDmRlDxNbGp/d5SofmtJQL18qwr79Fuv4j23wblZDaqWR1F2yaKCcK+ODF0eIc8Qq+8EWw6hP0S5CMBaVA5qFtD81wfKX7dUnG06V4iEkwNvZiyhH5OpQZaL3KjRIWOecxn2ygF+ljpTVCRN8iuCfPjeoalft2s+10pUL9JPV29YARcbCQG8vvbf3IJBiSDVAJ01FPvL55OH8t5SEiW3biS7uCiENj9GlWbzHA8a+bCh+6px6v73iofh99uHaKc6NtfcemUls4yvX/I9LYAv8M5zcnSxmOgvcDWLDwrBCbsFm2NvmI97Jm8t53CXoNU8j/4lw2e2TKT4AGVXN0noVXBfqDGG8JNHprnCgQFpnIXE1F19hkk+CC6ceFcybuS3mEeyG3Xv6hI4x568gccsAdGlHfJB2XBGDZHOHjzzAdmn9Bo6/SvDRMBJ5lDs9hMtJmh6Yh0Yi05T0kMQ8YYaC6Utg9CHYDMm/7RcWfg1eOck+k2JT+Yf4KK75ufpZAVNtuk0MBTL9s496YAV3xrG92p2XrxOghd2fjeOH62TkAk/Wds9JcxPGrKY2gIQ/gO6cUVpwg+vcYO/rCdI6IyohwHELXTbxQf7I9TEolX9ll8y/05xOvx6ymOCdJewTS0N/ePz5JWB6aw8sKTc83SQLxDik7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(122000001)(33656002)(38100700002)(64756008)(66476007)(66946007)(66556008)(86362001)(52536014)(76116006)(5660300002)(7416002)(66446008)(26005)(2906002)(83380400001)(71200400001)(186003)(9686003)(4326008)(478600001)(110136005)(7696005)(316002)(8936002)(8676002)(54906003)(55016002)(6506007)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Iak4nxe47CWAM9je7A8tOx84PqMOGr0GhdY0mijXvZuaAqrlowYJV/0qV0PB?=
 =?us-ascii?Q?vZprHEeFSoVaZmNprxtO6tu/2UTHMSw8FRIA1qEYxTBDJvKlj/KOFinwOS8R?=
 =?us-ascii?Q?b+1fztAtEON8m/TdkyMlCCSJVeYOvDjF2i3Fwksnk9IAjWpBwRMh80YhD1VA?=
 =?us-ascii?Q?YhIOiwzz4xFzOXELuuPwkz+vZICF+nQfW3NatCrLbMbFnlmT6JdPIsic/lX8?=
 =?us-ascii?Q?rHB7sGM13gqgDgG2UjiQrE+4+FLRdbm25l6yFWLZDvXIj9y5uROG9cSaWxOo?=
 =?us-ascii?Q?QZM6o4iVOGyx5lxZieIugrCLmit0uL0HS8uv7GacCJg50ls/6mgeiwLqNB1I?=
 =?us-ascii?Q?OYkkomOa7+H89Mdmd2WZCvHxc+5kp7PkTmgJMRw8cbY8lDlFaR6d9XkfUdZU?=
 =?us-ascii?Q?vnmiIrUjAEp+9Ua5zuwpNartyrrhYGvnhWmMeCXbH+l9rTwWvsWTB9rIDsk3?=
 =?us-ascii?Q?rPeYXKhG/KsrxlIt1fasOcJ6paBKAIHc1oDuW68ptwyz3DexKZS42ZpdmMP4?=
 =?us-ascii?Q?S91M5bQkiOvLIFCT4gLtu3y+wZM7rne4JAu6vWqupWfijlMAgj1Ue/vugM9K?=
 =?us-ascii?Q?JKq84dXrrO2MV5KGK9VUxaUxsUwBEIhw7CWUMCzooQWX5evC7OZMWVQ0UbYa?=
 =?us-ascii?Q?phctSG+MRQvvvZUZwegvqTRNj5T0t0cUGeD78dwSXbDm56+OT4Yuu91dBuzM?=
 =?us-ascii?Q?x4MTSdV1mDKBiBkbuB+JuHlDN7qx4XyFKCGnU3D7uU5pWCc08AN+KtHl7OGU?=
 =?us-ascii?Q?PFq/qjs1B0JzVHpEyqR6qOjE9S1ZB8iF8pvSi3UZmnSsFfgeTTBcQ3iJ/b3T?=
 =?us-ascii?Q?s7JFbimC2JuhRBZgGI5167zOsWao2+3/G7ikrPsMnJtLBT5UOLpZQD61NJjv?=
 =?us-ascii?Q?g5GHK28WiGGf/VAjNtkXsPcDihzD5va1QWnOMp3+9/egzyxbNnk7m5YtPpFE?=
 =?us-ascii?Q?deI3Hw54PnpqNril6RQzePWwNaWg3SRMBwi10gKVhAuBKTBwkFzJZhUCL8s2?=
 =?us-ascii?Q?6Ee5Z3dFWbMcgGbxkVo0fc30Qh/jYTRVVGUd5/Imvipu/D0yaTq++RZgfhPa?=
 =?us-ascii?Q?ouEJxQZJ1r5m4Al3czTlARqqUKe2KpEGwJlpwGBaGc+NU5ywQA1X1BchAOfM?=
 =?us-ascii?Q?q5Fu8+j/Uy4if3dR1F8Q2IDq67dJmSlPwTC/5qGXViOQ2kodDQm64lbOBI3/?=
 =?us-ascii?Q?tNCSFteepaFHkb4F7FGJY6lk2wVguBOzjoog8UEhaRcqPDH6zRZdDNVc4YD+?=
 =?us-ascii?Q?sDsixTHGOjmJD3NkXlzTxZoShdSJrdSDggkDY48swnNFazrlVBB5JbXXeX3r?=
 =?us-ascii?Q?4QW9GPF5nYMFo0Xs3ooyFOHo?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce21ccd-65a8-4fc4-8584-08d94f6ef396
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2021 13:20:20.0106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8SFNeQxcoT3iWy/WDgV3VPvyhaummzGQ5nL1s1xTmhHSy9hCZ6RDoHyTmBLpkt543k2feRUcyy4yvFpbEY1zow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4844
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> From arch/arm/include/asm/io.h
>=20
>   #define __iowmb() wmb()
>   [ ... ]
>   #define writel(v,c) ({ __iowmb(); writel_relaxed(v,c); })
>=20
> From Documentation/memory-barriers.txt: "Note that, when using writel(),
> a
> prior wmb() is not needed to guarantee that the cache coherent memory
> writes have completed before writing to the MMIO region."
>=20
> In other words, calling wmb() before writel() is not necessary. Hence
> remove the wmb() calls that precede a writel() call. Remove the wmb()
> calls that precede a ufshcd_send_command() call since the latter function
> uses writel(). Remove the wmb() call from ufshcd_wait_for_dev_cmd()
> since the following chain of events guarantees that the CPU will see
> up-to-date LRB values:
> * UFS controller writes to host memory.
> * UFS controller posts completion interrupt after the memory writes from
>   the previous step are visible to the CPU.
> * complete(hba->dev_cmd.complete) is called from the UFS interrupt
> handler.
> * The wait_for_completion(hba->dev_cmd.complete) call in
>   ufshcd_wait_for_dev_cmd() returns.
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Avri altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufshcd.c | 11 -----------
>  1 file changed, 11 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f467630be7df..d1c3a984d803 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2769,8 +2769,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>                 ufshcd_release(hba);
>                 goto out;
>         }
> -       /* Make sure descriptors are ready before ringing the doorbell */
> -       wmb();
>=20
>         ufshcd_send_command(hba, tag);
>  out:
> @@ -2880,8 +2878,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba
> *hba,
>         time_left =3D wait_for_completion_timeout(hba->dev_cmd.complete,
>                         msecs_to_jiffies(max_timeout));
>=20
> -       /* Make sure descriptors are ready before ringing the doorbell */
> -       wmb();
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         hba->dev_cmd.complete =3D NULL;
>         if (likely(time_left)) {
> @@ -2960,8 +2956,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>         hba->dev_cmd.complete =3D &wait;
>=20
>         ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp-
> >ucd_req_ptr);
> -       /* Make sure descriptors are ready before ringing the doorbell */
> -       wmb();
>=20
>         ufshcd_send_command(hba, tag);
>         err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
> @@ -6521,9 +6515,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba
> *hba,
>         /* send command to the controller */
>         __set_bit(task_tag, &hba->outstanding_tasks);
>=20
> -       /* Make sure descriptors are ready before ringing the task doorbe=
ll */
> -       wmb();
> -
>         ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
>         /* Make sure that doorbell is committed immediately */
>         wmb();
> @@ -6695,8 +6686,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>         hba->dev_cmd.complete =3D &wait;
>=20
>         ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp-
> >ucd_req_ptr);
> -       /* Make sure descriptors are ready before ringing the doorbell */
> -       wmb();
>=20
>         ufshcd_send_command(hba, tag);
>         /*
