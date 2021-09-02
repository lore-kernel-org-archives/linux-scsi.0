Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F546C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 23:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A20660E74
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 23:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346004AbhIBX7N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:59:13 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:43776 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243538AbhIBX7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 19:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1630627092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eORnII1p6ybdZX010DWyf9E/n3GKWgpyLl3LJKm2bU4=;
        b=nJO5kNyGhrOc2s1tTjIzw1AkH2CtP+B8GEbvpWtVLmcrey9MFhbQM6ukt/GuwRpjCNERQ6
        0BILiCsqdgN6tMjhJUqEZwOyQxjQuBK71n+Cw8onPRHus2n29m/gx2eQG0Iuj7ko0ENzfq
        8H5bIfDghEwPnQqfyzlY0KhR3yxPq+I=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-1-F5XEtpihOmKhtdn_-mqiIw-1;
 Fri, 03 Sep 2021 01:58:11 +0200
X-MC-Unique: F5XEtpihOmKhtdn_-mqiIw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTlxENPhZ5De3grrgrYruzjEDyFGb8GoZ0ab5HaIcFt/fCjW/yDQqumlUmXVE6VMerkUMbi/yQI9TPpzi27KynVXUFfqt96og38oPv5QPQTqCQx6yxiZzXLx2v+2bCXVoPQkLFWuw3exbW5OJeUqTxBZQ7waFA/PeWXHyl5sCNlj3tFbC5+nvn89OG0GooL2pgHqFHgcylx49OcJOBgo6PseRXqbfAEPWtXmJZhl/WO6zmd3LlRDnMvMwhnqn4/VRkjY0g22nGRFkgwhgFK4Z4IveznKWeGTWV/3W4Hp1X+bCj3cj4Chi+8wrrmkrxHxCzh2I0OYcLCVPVthY/ME3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rrKFuDMgSPTwieDtLGyFGEzItYFqmnpMM5jrDMheh+8=;
 b=cejSLHp7svdSWghfqFcPKcOoQsmkO7YSMeOvLsRFn0qXzyh87sfg+mAj7QKunFcpNCS8vHmgwHISsv/FplAncqnk7+gi1cKZ1niEphr62XsMQJTiB31+YcDWmA9s73gNwdCHtpZaWWHWk9c6jtcAq5WHl8jllBozlSEm/BWPzPVXQy6QiX03zWU1o2XX68ZWu9pnwvpk25qogDLTlXzA1BZcGaURTNUhUCMh4GcuEa62UFJVzOw0I76HNcrkgJw20d8k67y8+W0OCi7+iifBFGU8NH7GnqftnRyVR3PdWD6srlDm1ppc0pfhv8P6NSYSwhiBaGcUG25PR3XxHAuGhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4375.eurprd04.prod.outlook.com (2603:10a6:20b:20::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Thu, 2 Sep
 2021 23:58:10 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::2d7c:6469:ec6a:b3ce]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::2d7c:6469:ec6a:b3ce%5]) with mapi id 15.20.4436.027; Thu, 2 Sep 2021
 23:58:09 +0000
Subject: Re: [PATCH -next] scsi: iscsi: Adjuest iface sysfs attr detection
To:     Baokun Li <libaokun1@huawei.com>, cleech@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC:     patchwork@huawei.com, yukuai3@huawei.com
References: <20210901085336.2264295-1-libaokun1@huawei.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <91d4e2a7-0a10-ef7b-37b1-3ef884a3c3c0@suse.com>
Date:   Thu, 2 Sep 2021 16:58:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210901085336.2264295-1-libaokun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PR3P193CA0048.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::23) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P193CA0048.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21 via Frontend Transport; Thu, 2 Sep 2021 23:58:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc414b07-334d-4da8-cce7-08d96e6d8412
X-MS-TrafficTypeDiagnostic: AM6PR04MB4375:
X-Microsoft-Antispam-PRVS: <AM6PR04MB437535007873A1129B584E10DACE9@AM6PR04MB4375.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yfud2sEam3forLd6vRTrTyjc+LfodoFCJSWTlHN6LKITdHmOTCZmCLuE88fteGz+UxA8tWxWuB62JrCjqoJlkfdELWA+stvqwvuhr9s2vKM75f8FHJsNJiqnXqiadxNz2SVd7mkyL7uagu0hIGoFv52jowoQlB3udB1Ku85FwqTLTff1YHosvt23t1ai78ylGT4IlMxufvMK7UfZ85u+6Mq422QUIOknVBU0wnQ1akpYhaps2uDs3+4beeiwUkv2aBcAmQLbb+HfslKoS7sZkkx1nTPfu+mMqzF87TJSIoZiJvnImaHTwBTtxF1SQwKJVbF8dwR1XRj333Gin1uK0s+r3VUQXZGQgnzoO/5tbqkDUL1c02dn3m/2syomL7zQACHz1gQ/0px8Hyspl7KY5gMGcRSywL+GMQ8JsF3UeAJNTJkXIBT2xP07byji2ZUTtsjB3A2WKMt9SST0epRK73rdIJ5kVGV65rDFPCrgb5Uzo1qhnJwyUaTLh8LvsH02z5eVRMl+b5Xl5QJWiRbH9fa8hB5VeyL/hYUlp2w/FHBYYgiObn6ZFiw70shszt3fQpZkdHVH470CTRmDqaG2KBQqVa3u40MD1/cGTcxn8LLZ6vixLJaVq9ur8sxFyDu7Z0nFFX4WdR1Ubdnqlp10DLAaBLTvyeyRbcDuTd9pt/1xAPdEWNHhiFFszuIH+8Qvsw/s7tF/lcoea98FElHcg0kNXfjsJgULPaUmbCcxZS8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(136003)(39850400004)(376002)(66476007)(66556008)(8936002)(38100700002)(83380400001)(66946007)(26005)(186003)(316002)(16576012)(36756003)(53546011)(2906002)(4326008)(478600001)(6666004)(956004)(2616005)(86362001)(6486002)(31686004)(31696002)(5660300002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dKqY2sSw+VxnoL+OIAOv0aZVSoGAtZYmH2zgW2k5HL9Z3HJjaYtlUZz16bnZ?=
 =?us-ascii?Q?geAlwI2qwH6sBUcmCklXCH4hsO1VOSlJXkAuZY1C9is6HZvsAAkHVTOXrwVt?=
 =?us-ascii?Q?zoQ4eWlrsw5wHnHLgZZsaGX67m2SKIxPdxy5oIzd81ge8hA8dF7e2TMhFNwj?=
 =?us-ascii?Q?TRc19ariDiKDp4mQoWze8JHBvJqlijnXTC2/gO9JaEUuSPmoDmAp6KvQ5W6i?=
 =?us-ascii?Q?OIlZYP7Fkv0fB2rpN8GdbsjhRWCzHQQSRX+Rq8BCtFH48H6wqgZ2tdoNXQzO?=
 =?us-ascii?Q?nWZCahoAZSNAhqI9OUvnGLY7xNVPxipqaHKbpsylh2Qf+HJQvovbP1wa0bfQ?=
 =?us-ascii?Q?VzaPqRm+7NyqnHrY6hKQf6bAXAImdBrUUrJIsxCBIMSM8s87gpvjbAbqCsGf?=
 =?us-ascii?Q?uf4Npqyjfg7IssS2CCvTgzQ0uYo7FDf3y9LSsgFUyyxg43XG3LUnmdBi9JLL?=
 =?us-ascii?Q?8aBNrQ/p12c8ktlt3BxhEMPAigH9dhLEDS4Ax733n/N0ZW72uU4i29Kv6yFp?=
 =?us-ascii?Q?78vys8OBQXIgQqXJmp7I9OlewOmPUhfoAbJe1DzShapzRyi3HON5ro4Dbj+S?=
 =?us-ascii?Q?46ArMHYZcHKm99KZX+YGc7oHXWq9nO184f0RncBFPqVD93RPxFJbvOJDDECp?=
 =?us-ascii?Q?+YOhkfz2eiiSUFslUMWqCt0MY04j2dV5KlwI7q5aMl5hgUGDYvi7OA1vPwEW?=
 =?us-ascii?Q?RFfhZAyfJDDrtM4vaJ56Ubx8mhw08Z/WRy6X4l5jkCKUz6okqQj2cmwcCvLk?=
 =?us-ascii?Q?Mo3zJdZQS5oyfR+uN+4gn8nPK+XMRCsuRdaHhQ/H/YuNsd+ytmelVx0U46JG?=
 =?us-ascii?Q?Txb7AurppMVbVdELsFEVoRzeucujMaQMRltXTWTChKduEbb+7nBJn6rutvE5?=
 =?us-ascii?Q?2dogPMGX32leXxN9OtT9K/mcLEvkpAltNv9HCWb/m75RJfaJQxEqUm0L3CVa?=
 =?us-ascii?Q?Edg9sNx3S8jiXMAMZCxqulnz480kVppSWD5QChGImDHtTtexnqeu3TGXiE9c?=
 =?us-ascii?Q?lWdxmEs2RQ9f7HuxLdMik2n+9CoDdNp7b0qaLir+bfJYXG3/kdfbGXNnnXXX?=
 =?us-ascii?Q?i1QR6/WAaa7SDqrXIzvL+2rFB6Cst6S2O0wxq6XSRxMaT+eB4xHyTFjM1baq?=
 =?us-ascii?Q?Ux+NM5eyJeJNM1ifvymHA0z3fGLpB/5d1oaa5aQyfXlJIvEWsA2hJEhFBgQD?=
 =?us-ascii?Q?TI4SxuCXRwuvUdVbCMuoosL9vtdudRe9TlPuXJ4V38cW5fhWMG+qTJ1AK9vY?=
 =?us-ascii?Q?vr5RV6BZ7gxO255lPAVLy57nmeO1MqAt1Ey3Da8pmsuS0RpYYZDn5RCcLekW?=
 =?us-ascii?Q?OTNUu8Fz/NKOQ9nCXUsYg6iA?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc414b07-334d-4da8-cce7-08d96e6d8412
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 23:58:09.8019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cnhihunOPXn/n+P71MXDzwAGHzwbBrg3fL8JfsnjzAMBIUEooX9cbS7VUrqtvMfy2wZiSciyGNT+IxCF3Nwdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4375
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/21 1:53 AM, Baokun Li wrote:
> ISCSI_NET_PARAM_IFACE_ENABLE belongs to enum iscsi_net_param instead of
> iscsi_iface_param=EF=BC=8Cso move it to ISCSI_NET_PARAM. Otherwise, when =
we call
> into the driver we might not match and return that we don't want attr
> visible in sysfs. Found in code review.
>=20
> Fixes: e746f3451ec7 ("scsi: iscsi: Fix iface sysfs attr detection")
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tran=
sport_iscsi.c
> index d8b05d8b5470..58027207f08d 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -441,9 +441,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kob=
ject *kobj,
>  	struct iscsi_transport *t =3D iface->transport;
>  	int param =3D -1;
> =20
> -	if (attr =3D=3D &dev_attr_iface_enabled.attr)
> -		param =3D ISCSI_NET_PARAM_IFACE_ENABLE;
> -	else if (attr =3D=3D &dev_attr_iface_def_taskmgmt_tmo.attr)
> +	if (attr =3D=3D &dev_attr_iface_def_taskmgmt_tmo.attr)
>  		param =3D ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO;
>  	else if (attr =3D=3D &dev_attr_iface_header_digest.attr)
>  		param =3D ISCSI_IFACE_PARAM_HDRDGST_EN;
> @@ -483,7 +481,9 @@ static umode_t iscsi_iface_attr_is_visible(struct kob=
ject *kobj,
>  	if (param !=3D -1)
>  		return t->attr_is_visible(ISCSI_IFACE_PARAM, param);
> =20
> -	if (attr =3D=3D &dev_attr_iface_vlan_id.attr)
> +	if (attr =3D=3D &dev_attr_iface_enabled.attr)
> +		param =3D ISCSI_NET_PARAM_IFACE_ENABLE;
> +	else if (attr =3D=3D &dev_attr_iface_vlan_id.attr)
>  		param =3D ISCSI_NET_PARAM_VLAN_ID;
>  	else if (attr =3D=3D &dev_attr_iface_vlan_priority.attr)
>  		param =3D ISCSI_NET_PARAM_VLAN_PRIORITY;
>=20

Reviewed-by: Lee Duncan <lduncan@suse.com>

