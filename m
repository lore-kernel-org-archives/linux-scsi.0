Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDD1C77B75
	for <linux-scsi@archiver.kernel.org>; Fri, 19 May 2023 09:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjESJhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 May 2023 05:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjESJgv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2023 05:36:51 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A39E171F
        for <linux-scsi@vger.kernel.org>; Fri, 19 May 2023 02:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684488986; x=1716024986;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=K+sGWdY45hWcmd0BuYPV/9dZjenkOhrhGFvOTdQ7KSg=;
  b=gbsPfSkiC7Xv1fIkbfd9PWWHsPPV+Hs+hI15prWmBl+g1FOxfdkmS0Y2
   xWDuVHSzXCc4+1lhFCzMbroM0lrYtEHW8BN5kcKy9auBzj4mRsxaQ54uD
   4Fb1/6yABI2MATNGVtzVOel4KbkMqXtTvROcJvuaMWSMWdIKflt62dfFT
   67S0e4cKl1gHCIDyRPtwalxUoBb2STkLkU6iLhE5cZBYKZQyQ37MrsZKG
   9PAEzeasbmHPXigvCbc1kAoH8rbyPe0garpk2DjPypXBgRUDHzCcJ7YC8
   S6xceNbwqSs/+1Z6fN6Sv1cph7zholyeC/zoWWqGhGTa1m5wpH8FOOcfL
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,176,1681142400"; 
   d="scan'208";a="229338994"
Received: from mail-bn8nam04lp2041.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2023 17:35:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBx032n3M+r5Lbg3w9Wp3E7SB9vRqTxBK/neBQjP84BKzQadobCy98p4OQ+u8tZqH2iphmjRVD7j4BYxdVXSPwQv680bms4phtmLi1TfItCn0as4jojuiWUBK7oUkR1cqoT4MmFzqT6YYnftRJw0NgFhQcNO0c29onovrTLue+TNsQrj/bbbUZZyk5wXWNmaDgzkmVZD8LSxLlP4J+gMd158vCUdyKwjpZ7Bk74wvUMJeFpgvml166/1yuYRVwnSR8I7fDxU9pE1cvAfG6mXulK8qllZsf4uBTi89RX5NF3tkOQ0dFqWYmO+PcJDvHyvRIVx0auQFe2SRTMg614Ztw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2a/JMn5Z/AAKMGnF87eIBocKtqzrywb0vpwCHKPGUA=;
 b=PlKDtCV+oxv9ufOh6XZ/+8HyjY+tp5s8+NIMFGQZ6L66s2liHTGICNvQfXkf+xpgQ88Mq+VTgEMG4SkmOa81iT7z4C4b0lQNsv9hNfQxXcytCfXvjmh5LZGN+wgVH9UbTTo7dgS807QqiJG3ILcpobgYjxrJmUm7q6+bCyOdZUmg5MLKpwB/Sn0FIAw4wg8c8znLOTYwxDPkKQ2tHZi/U8MtedL8ZSCRAyBHQfA90yRxHMBS4BLsiS42NKa0iB5PyvUPKr2vklreutNTjoqUe26zKtCSme2j5UUyq9IckML82QJ3fMijBY9QRTfjuPcmKYWGe1T98t9R3zKUT78cEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2a/JMn5Z/AAKMGnF87eIBocKtqzrywb0vpwCHKPGUA=;
 b=QLraRrDB2OfaKQwp7fcO13d64P1DfY/mEmMqaklLnThkdfyKOJ1fmVixcSLXtVJIIwDagxIhbm3wiUPV+oUFzFGTPF4riD8EWTR9YbfD/otuiM2JNa3WJVXXmD9fhQ0Af5yn03VHEc0vKQTsZ8CQa/+YZFGRu7n0g+clv/3F3yM=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SN7PR04MB8737.namprd04.prod.outlook.com (2603:10b6:806:2e3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Fri, 19 May
 2023 09:35:26 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6411.019; Fri, 19 May 2023
 09:35:26 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v4 2/3] scsi: core: Trace SCSI sense data
Thread-Topic: [PATCH v4 2/3] scsi: core: Trace SCSI sense data
Thread-Index: AQHZib9xDOTGqReCdUiIL7sDV3WXAa9hVvUA
Date:   Fri, 19 May 2023 09:35:26 +0000
Message-ID: <ZGdC2DNi3zgS+WVN@x1-carbon>
References: <20230518193159.1166304-1-bvanassche@acm.org>
 <20230518193159.1166304-3-bvanassche@acm.org>
In-Reply-To: <20230518193159.1166304-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SN7PR04MB8737:EE_
x-ms-office365-filtering-correlation-id: 11efa719-7aaa-4402-fe92-08db584c6064
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oumwoY74yAumQRNqFzwZQF+Noxd14jyTAYeiiET6Z401ziv39sTpJEf83j8OJSuP59By1R27XxCCFEUNHpKmIsf06aJDi/Ss/1by9/pTzzWw+DbBNVDq7Cxyd+GraFuJTVQGvA9tnVgtAWojMTgZCPUdiDKMgorHDNv2qNQ3gnjtudoEjHUKB1FoWIK7NhBTYb7o3YJG0YoCiPAWU0kJIz6ebj6cGjJmIfuT04lwDOXrLxCPAmjl3BrooD5vA7cxtzdoCWr1dU9AEGrnEgZei8j1u3J6zGRzSmMIfMnggC7894jg+XaykAn3mY+AJfsCFhq3mjOp0xPX7m9+o2w+jgeN2n+Fu5wXYA+uCpikicLXAbIi72m4tPxqHqTNsdgdODXExSGdXFPmbnPRLLUj/PlVmwoIIyD2ch8oSkZUBcejt75cUYXV1KEGjWel4tBaE7eQ7VZHZpuvZ8+E0zOjFWIrqrK/2JpsVh4ZQKLO76Im17LavagzesMNerwhNTw+6BHt2Yf8Q1C6FlhIDEFhXlLysiY0mRUdS3hVwNTyOhIELSUdKXRhixhQ7S8pFNMa6DyOUXvBizf/HXmxYkpJP/fvO59WL24Ds4gdqe+Uuc64mAfpSVDFf2tSZWMestFlAfCQzAExz6NcmpPtETcTOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(66556008)(478600001)(66446008)(66946007)(6916009)(4326008)(91956017)(64756008)(66476007)(6486002)(86362001)(316002)(54906003)(76116006)(71200400001)(9686003)(83380400001)(6506007)(186003)(6512007)(26005)(33716001)(8936002)(122000001)(2906002)(8676002)(82960400001)(5660300002)(38100700002)(38070700005)(41300700001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FSThzdd4Elw0iO6eBWDnS/QyUY1a9cpyzloHjPyTJwAIEnDi8JbWLENye0cm?=
 =?us-ascii?Q?fLrsDMEVpk2OiTroOC3NbdkOHzvxahqXiCYaMY9lMjcp8v7eN94S+gbKktfl?=
 =?us-ascii?Q?LVSjSe4V5D2f3VBB1R/fmTCeMRtXf8UHQPdK+vOw1JplutB3QLOyv+L3p8G8?=
 =?us-ascii?Q?yEGbwtsnUXb5mJsa4b0cGFKBQXISMqCKtTwmHS1kX5fjAkUQprYEHfn9v2hC?=
 =?us-ascii?Q?fkVTvgsvLVAdGtLotPc6P2kXU8uIA+cwPuluCE+9D1tmv/WzOxRu8k6yKGLn?=
 =?us-ascii?Q?kX1BmzRc+mqoZdIw3QGijO8l6XrumldeyUfobhttkvnMveOBamhVBxLZhQkv?=
 =?us-ascii?Q?UY3pXUZBpamqDrgaFF3TVjecYy8wr4lwgKMrhNA6Zqhdt80iXvgMaOTerKuo?=
 =?us-ascii?Q?g++f7Q0nH5TTdQPxSpEz4p/jw3NB2jGTiU5gA+CBkMs4Ttp8YfXlocrwIP1N?=
 =?us-ascii?Q?3uGkt4GsUlWAHaNGXSH64By0F3dpkgpoTj+w64ZOrTq4KvO67kSvKkzzOPx4?=
 =?us-ascii?Q?Z/2yHC/GYuHWoZo7eWrZInsBsiIICtOajJovY/P18jgDQtFOU6wsC955lp0y?=
 =?us-ascii?Q?aDZ0Lig80cEv681/3fhBCmnRIwlfmLeD6oq7x+OaJswwlUjXnhyD25txr3Zk?=
 =?us-ascii?Q?GO9wgyeikAwpauRS6g+ZXeUz3EoiJLL8C7mvJQevCOBfB02Sw/+tXK9OYqRw?=
 =?us-ascii?Q?MtgVfj0CR50Am9K6NFj2Rv0Qm3jrkGMv2hKqSlIkWeGkdsVaMV5tis5xTBKR?=
 =?us-ascii?Q?gldPVI8lzWZa20BYE42A66tB/W4myDLV7kz2imXqZT69t1kzd4elufsftCQY?=
 =?us-ascii?Q?3+b7PtH0PIU4gq9ivZf4JyPnTgGhskLzHeiMbZoSods29GdNgVgDq5eSI79i?=
 =?us-ascii?Q?DXeDmHXeBaJuXqHS2q9UwJrCXgcgYDpfF23ukOm3isQwpuPGAxulvoMSwtKh?=
 =?us-ascii?Q?fqJLo+/hfF/vuj7yhHnSqzXCxOqFHOYHYrcvnSAygXoQuOXDlEQjfMelCgYA?=
 =?us-ascii?Q?WwMAii+351CDPAOeTO4+xUTESLVNOdpVig38mFl/TVOB2g4hETqda9OB09me?=
 =?us-ascii?Q?lc2dyWh9wDRSJtQRAw5Rc0+A5eLO0TvGQ1AZoR0CVXApGkqRWVhsLY5xvo0E?=
 =?us-ascii?Q?eXVJAOIDJntA57sXxas6+TvsQF87BLU2l0hXDnfgj6xG/kur3T6OSnVR2lEZ?=
 =?us-ascii?Q?9rpX/bi+/U4UvW4aDW8HdnwxEoahUVUJ4O2HXQm2be89ddRqinu0DouqTXmK?=
 =?us-ascii?Q?ADRteQvK2SmJOZwJj+4lRgKtna6JC0//MZAlMgSBywfRNzJPIl/KKo4YFhIi?=
 =?us-ascii?Q?xSh7wi9DmLIl2GTPUQvYXYhBM2e1E3mZQRLJGZSFQ8VoxjyYX9OG3HTjDX5f?=
 =?us-ascii?Q?ReyIA++SRZ8q1VR08qrihZm2sCh6R8FcVgnXcI7I1uoLvL8QpJBQWrE0Iu/W?=
 =?us-ascii?Q?PcokD6rubblOi4N3TtJt6XTadB9VDEjqOrEbvTFAohOGggZYNF3hsOuwPA0o?=
 =?us-ascii?Q?ZpXFA+7kQYusNUm7L2QA34qeFi3nz3yu5WQKRYGkF26UGW7ENBrucIDcPG1s?=
 =?us-ascii?Q?sY3k2CPnlKkWr6/7285IzL9aP1QoWUyFAitvZmX7NTakO/DGSBsw4zO5+46o?=
 =?us-ascii?Q?jw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B93B0DD46855840BFB1F772E5BA3B7D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XasCAW3njn48oMg088mC0T3fK4A0D8BIc3E6f1vgRU5t9ENlBwnYtmaHmjLfmtOhoBofALVPI/Vt/XHHE/+aizN+txQEsRE1MDlUcmM1I8aJpZMereE1oB5JGLrDCZflvHHYcxFxEPOf0YjjKw2k7u75tjndzpRAmAMm4pGTl2UWFpZtt/Rwo9XKSzDiXjbdCvGSvyGHQslwU58MEQe9LLZQO1t5zuoigS0y91L258E1tfuhQXEL4vY//uyjfzKl8q6nEMW0uC7xZT7CP5ngCWUuLJWM5tajyg3VeTo28e/zrUEl2lu26QkOOo8mu+RDLqP6rh7NWdUUa24n9gQUsRSR8gJIVx4q0zxY49MCD4FLecw/xgbsZxUuMfZp7dSIL9O7D9eUW1uOwR72oeOjFGn1flAcJqJ1os2grunMgPioXS2kaThbV9wisr+GK+odJYW3KUKOthfmf6MJSRZ8WRhGL1mbgB3IY2yT62bybCLsI1QYqHp9IeJiyUQ1fATPBVVH1SzNZZTpdi2rqQgi+yDF7BzXasu9Z8BAVcir6TsPtPhXpHJ8RBXqVumyMBjSvXnz8HO9kiVb/F5pcDosjclnBeOI7NeLPEvugTzTlfQC95zH+B59aEAjTAFw8+PuSYdOMg5cBEfa6Uq4/gv/eyT1o5ttBZ2iiN4vsDQBLYJ7Sc+sKfW4hQ48CEZwnIlpJcEK3E7D+9eWlV3xDWCvqsme30JONlVzw6ORvw8GPhiMo1AidmDFB5oWDC/3UBZAKJSPOLc0bgk3d5A9leJltXayjiSbtFdvw5ITc9TY8oRPTrtmnRuxMDcU5hxSDGDDO70aaT0RAJGUXTI9Qt6s28qbOk6Br2XGoOz3wk6j3GtddCjJP0GgsZWne49HockbEHJuh75mYf3TR6NtZraH+Q==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11efa719-7aaa-4402-fe92-08db584c6064
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 09:35:26.0524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l2Devuthh/752NfAGgy7Sk2/RQOJNcD0vAUDjAcpSfiqHbQBw6bS0JSRYGBVHggbHeQcFQ5XGbBwctCVkpeDZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8737
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 18, 2023 at 12:31:58PM -0700, Bart Van Assche wrote:
> If a command fails, SCSI sense data is essential to determine why it
> failed. Hence make the sense key, ASC and ASCQ codes available in the
> ftrace output.
>=20
> Cc: Niklas Cassel <niklas.cassel@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/trace/events/scsi.h | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index a2c7befd451a..8e2d9b1b0e77 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -269,9 +269,14 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__field( unsigned int,	prot_sglen )
>  		__field( unsigned char,	prot_op )
>  		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
> +		__field( u8, sense_key )
> +		__field( u8, asc )
> +		__field( u8, ascq )
>  	),
> =20
>  	TP_fast_assign(
> +		struct scsi_sense_hdr sshdr;
> +
>  		__entry->host_no	=3D cmd->device->host->host_no;
>  		__entry->channel	=3D cmd->device->channel;
>  		__entry->id		=3D cmd->device->id;
> @@ -285,11 +290,22 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__entry->prot_sglen	=3D scsi_prot_sg_count(cmd);
>  		__entry->prot_op	=3D scsi_get_prot_op(cmd);
>  		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
> +		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
> +		    scsi_command_normalize_sense(cmd, &sshdr)) {
> +			__entry->sense_key =3D sshdr.sense_key;
> +			__entry->asc =3D sshdr.asc;
> +			__entry->ascq =3D sshdr.ascq;
> +		} else {
> +			__entry->sense_key =3D 0;
> +			__entry->asc =3D 0;
> +			__entry->ascq =3D 0;
> +		}
>  	),
> =20
>  	TP_printk("host_no=3D%u channel=3D%u id=3D%u lun=3D%u data_sgl=3D%u pro=
t_sgl=3D%u " \
>  		  "prot_op=3D%s driver_tag=3D%d scheduler_tag=3D%d cmnd=3D(%s %s raw=
=3D%s) " \
> -		  "result=3D(driver=3D%s host=3D%s message=3D%s status=3D%s)",
> +		  "result=3D(driver=3D%s host=3D%s message=3D%s status=3D%s) "
> +		  "sense=3D(key=3D%#x asc=3D%#x ascq=3D%#x)",
>  		  __entry->host_no, __entry->channel, __entry->id,
>  		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>  		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
> @@ -299,7 +315,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		  "DRIVER_OK",
>  		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
>  		  "COMMAND_COMPLETE",
> -		  show_statusbyte_name(__entry->result & 0xff))
> +		  show_statusbyte_name(__entry->result & 0xff),
> +		  __entry->sense_key, __entry->asc, __entry->ascq)
>  );
> =20
>  DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
