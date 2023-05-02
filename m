Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7D4C77B7E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 May 2023 09:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbjEBJws (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 May 2023 05:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbjEBJwf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2023 05:52:35 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1745B4C28
        for <linux-scsi@vger.kernel.org>; Tue,  2 May 2023 02:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1683021151; x=1714557151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fdr6q0D25GFbGAK40gqz/VYwJdLXI7l7+CjWXohLkf0=;
  b=NxAFvJvPVsGUOIJBl/7V2wzkzziHxlt+CYOUmf+R3g4ye89dKyNYmybk
   UEuS4vKOny/S070Jp6Uvb3dpwlL/WI2QJYF9zDCMI9H1tg9bUin0WHEh9
   zWHFzugHcvUappIo0D6DIfTZD7e+Txt9s+Sn3l8kDvpXGS9+HfKKMZzj5
   wo7EkLQASBInsjSJYxwDEk95xYuNIrabIdj407HIdtUhRVAsaALpRmIJ4
   d399p6QPib/Ym76fJVSoyph+/Irz+uCm7e9fLHlGqWABBMrYpMgs7Fmyt
   Fsh4bFSIqrmE7RgDj+D3TMwa8q5XCGWnkrCpHr5AT1PROxNZc/lZCNq+8
   g==;
X-IronPort-AV: E=Sophos;i="5.99,243,1677513600"; 
   d="scan'208";a="234671433"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 02 May 2023 17:52:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cram7qL9ne1JV9QMDAMItt9mNR8G32HuKT7THa75si+SwtHFoS/Jn1tkF3Xgzcx5ldxyNJB2kMC46W9FxyTL09ahnblK0cOCIis+Y/mRyuktcwGW3wtyeapxNCw5d2HUP7aivxR1vF7yeS9liQnAI4rss5xMU57VEGBZWrlTRFQ/amPX/xcsp3z4IZJuPjogM8k0kcuM4ZYQyidk2bcDTE/w1mbnLW59tfyucTxnOFSTLVg59NHHTvimY3rs8nWb9h2kWkJQCmRw3QNs7MV1pBWweTSepwCtTy+Ls4yVh+0xXwcc3EcXL4OlMnMUC8hCtbv5lnuMFpM2u1zkY5TQWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBsJdgYLZGFywOdeZvhLzlzpCjQzRejPNINJxdDgnHI=;
 b=QWnSgWAfnhYW0IhkORogxn9cO0fyiT2lPslZ0sVDZ4e2T5qLgl53KRsu3gxNdSILcg7bNKf0Q//2KyokgwNVfDUuGrKkObaynZXI/+9LQhqcv2R+pJHFGuptOQtca4EeTvR9Aa50ibfu8yQDkOs7jElcGl0pYQxL089BStWbHrClCl2dRbJ5vIzeG0Ukiwtq7bgy+ENCpQxNjuFSkTJ6PEXVTLiYKh3zMcHZ8FaiU6/Dcew1qZKH5fKjZlgNrO8JE//VxjzUovi1bvhXaqbYAA/Tr6za+K7OR2lO0f5UhKfbn9b0I+GF5wOd32zS+e/+tt5jN04KwZWV3hCqU6PdEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBsJdgYLZGFywOdeZvhLzlzpCjQzRejPNINJxdDgnHI=;
 b=WzGDu6KxWBpcz3VjeQhqps59cfPSfHW8pxYYKtaE+IYguFj2dFhF8PCdEcbIwZXS5XXsULc3mU/IQbJeaG1MkW8x73/TIJU2bO2IhXr0NExhYrib9iHRn6cpxKoC4BtJQJOIxkVrPdw5t4ooH5D5glW3RX1H8DKQQ0wLvIrIlqQ=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB6962.namprd04.prod.outlook.com (2603:10b6:a03:221::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 09:52:27 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fd:6db1:5165:2ade]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fd:6db1:5165:2ade%7]) with mapi id 15.20.6298.030; Tue, 2 May 2023
 09:52:26 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 4/4] scsi: Trace SCSI sense data
Thread-Topic: [PATCH 4/4] scsi: Trace SCSI sense data
Thread-Index: AQHZeajLSvQtpzf8lky+3WrgPH7we69BDV+AgAW254A=
Date:   Tue, 2 May 2023 09:52:26 +0000
Message-ID: <ZFDdWY7LqLQL0nb6@x1-carbon>
References: <20230425233446.1231000-1-bvanassche@acm.org>
 <20230425233446.1231000-5-bvanassche@acm.org> <ZEt/SD/GiqIo5aIm@x1-carbon>
 <e859baeb-f7e7-9d58-bcfd-9b11115bdf0d@acm.org>
In-Reply-To: <e859baeb-f7e7-9d58-bcfd-9b11115bdf0d@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB6962:EE_
x-ms-office365-filtering-correlation-id: 308e1fe7-e370-4465-27c0-08db4af2efa2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A10wgi70l8oqPeCzm2kKJQ/KFapwCn6uV6mX1tHRlRpo1H24E3yE+ct8nQ5NvacbiiqYWSpwd90MZYRnI828NjjsMxX92vmMhslKUNHOZmH2mC3t9c0aDOZYmANpPeKxAhBnAk3l1g7v5XApbz6qEeWWAVqPZJL7LjZ96uuPbVMd0aQcUdEyhRGTytcKU1gUpqSS1a/YkJCA6kVPcmViEIMHnQMK087cR+tD4posP1iyEZFM8l0LyjoZnv1qWw3qYpGT3tLdIsQbbUaW40/V9qAlmnjjy1NuSk1UL3F0gRJnf9hF7Fxa9UoVifthkCFbF8+K9qpMl3pHJ51Cj6c9Q3+BMYPByJM6/FBVFpZ4mY5egunjfg3Oickvqidea6HM99AKq1fkr5f4j5ooYS3d1IzqkCHLq37aqxpk2bB3NGz+HHoTv2I/PBsdNDHRqUTjbV1QOJ1b6qxo1ketrzvx3ItJE4h9iGZNU4HkWgO33/wlzK07090ux/aiO10CZUDUJn3orgsbCVQdzyxqG6PDMdnHwUWIkosjZXnpTrdzLzsQAehFfI6Ok27FSs4zMilLKPr9G7y97xreAWmg38B/9LrbSUb6V2RdbiBTdos7eMc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199021)(6486002)(186003)(83380400001)(33716001)(53546011)(9686003)(6512007)(6506007)(26005)(966005)(54906003)(478600001)(66476007)(4326008)(6916009)(91956017)(66446008)(64756008)(76116006)(66556008)(66946007)(82960400001)(316002)(41300700001)(122000001)(71200400001)(38100700002)(8936002)(8676002)(5660300002)(7416002)(2906002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Iipp4QeJS51Gvv5aKgoMicXbgkI51k6uViLBdLqGhpTq49oCNQjCflYi4rqf?=
 =?us-ascii?Q?HZ3mj4R/LdnVGEsEYUkpE76rbwgmDPmqv+GbWYardcG8ZfLd2befHE3zEMGX?=
 =?us-ascii?Q?dMtpbt6LxTt1VTxwQWk/VyTatX3ozLqLSSqKzvZER75SLRppn/eaZtQuTWkc?=
 =?us-ascii?Q?qnOrHej3cD71yLGHujnXHiI+JKp6jFo/gAOq0jjc4xfdOzIDf4gohWFPtRdn?=
 =?us-ascii?Q?4QRqbG8JuqvPGBqOhhuW4qaS7adrAHGc2TdwaFjcaoi74gxneQnzLKKi17Wr?=
 =?us-ascii?Q?FW0d1FqsNVQDeUf2aT9X1jm7Uu3f3TRODMfgPg+efZMk4pxJ1xt+Xp4PQcm2?=
 =?us-ascii?Q?bOjuKmSUN5H22XRpGsx3I3YpOOZJW266m5pjX2Dw35fzqDVXu/WUkNdC0/8P?=
 =?us-ascii?Q?FCFpXD7tIZ/oIl7LvbmD0qN31lGnHNCLCS1je1f8YjTBveGNIxhh7PYsm0Ec?=
 =?us-ascii?Q?Kto/Rhc0b5bS520XPv2S7p3wEOT/pyFJ00xpXlmxVRu3Gyq903IYXdXtGS2/?=
 =?us-ascii?Q?gzJWpAIbndco+W9QnTTLJqx0ZjeMUGqYKXLj7fdnTGkLSb1tbJ1n/2wPbaDl?=
 =?us-ascii?Q?an60DFIz8vEkUqX+OvGqzvVcnV17ILceyFmk8FgxxD2anGp7ravTQV+PF2i0?=
 =?us-ascii?Q?K/V3GzeIaSt6LKI71tRAgsdWxMITjTxWmaxaCDlx8amVpC/lv8GH75xAiNBG?=
 =?us-ascii?Q?J/7aqlRoqUHigd/Cv9dMYJ2z9uIyYiiahqNU6NsqFUqMu2bGJL0NhNWUwwow?=
 =?us-ascii?Q?pr8+O7NCvOqJ+WwHtcSfLAWiH4Bf9awoKFRHFFNS6YfcEJCU+2VM68x1xtX0?=
 =?us-ascii?Q?lmIvvpUSkxbNdBhEtYx9vIRFrV9CrGp73zCdw5g1I3gZmSyNifXrK2epx21S?=
 =?us-ascii?Q?doYdh28N5Fr1WBrQ61ipLmlmv1/KVLUDQvku03+AvnzDsuDnm10v3dK8XZdY?=
 =?us-ascii?Q?iCc6DUxbF9s5OzFe8OvVJFecwKBNPzk+m5/YKOV+GJnLr9dZxlBEOV6zPZ0m?=
 =?us-ascii?Q?yR94++Tliny7uF4Ip8gM3e7VVH1NQNDRrbwJcP3cySyYaW9X2a8SurJp3aAd?=
 =?us-ascii?Q?hwjViFVjZSDoDhSoLWGNbZH+8vRYz3SY3wr9vbDSENGU26aezIjRWJbCrwy6?=
 =?us-ascii?Q?raKZyHcSjP3EjTQ5uagnZrLSVeoQbO9/W/ciMGL7GYARAop6S00noAB6CNpF?=
 =?us-ascii?Q?ZhiGN91A+DAtWUM/INjBH45psLFdEsowSq7EPAvqH0haE/CDG9Dde1jxdNWx?=
 =?us-ascii?Q?EOPX4akYJrqLkfVbobck2GRQi+UvPYuA4vm6dUHehPFYOlnrTX8GTp0kZSiF?=
 =?us-ascii?Q?exGBYzlBajsreJ9q6La5+EMhHCkWyrNjoBCBqdBLNVOe/PLTQL1tTGxlBdb+?=
 =?us-ascii?Q?QbThM736qZYHWlr8ORk5H3jv0ClBY0eVX4SHpZ4CMdLx0KZGIbiVIz+hZeQR?=
 =?us-ascii?Q?VGOTYn6Oi/VUZyX1w8MjhVJJLLEy4p3W2VOdOOBc4UhI1FP69oaeVt0dd22w?=
 =?us-ascii?Q?RnMvLPsByDPz8dOdAqVdAiaWxwBh6O02+Fcrm77QOkGu7jC0Qt7zagzo64zA?=
 =?us-ascii?Q?xWT3ONSKssfzmzZwx1ct6BhXu31YhTru1MX/ap5nXAoGiohIpPbMplvBNpaK?=
 =?us-ascii?Q?FA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5CB2E9E186EF544797924950E36018AF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?k+c3UWDjfvc86ecJCr2P42TXaSU/z+bMCV537I12VeG4U6gOn0tEShttRk/J?=
 =?us-ascii?Q?HsNEMelV6QKy5BypMzR1iwvvrq2QahGy11k3POpm6omMHAojUxVtklLKr9ik?=
 =?us-ascii?Q?wq4AujHFcsTJCCwXH9t8fpEI+jHAui6xEFoKztQHZN9BUOQSk2p4NHsj12CM?=
 =?us-ascii?Q?uPjnAQr+Vp8ZTVZt82fyx8TXStgWkYv3fGhwBl8ShAsCLTvModlQ9g52uKpG?=
 =?us-ascii?Q?nr6x6EYiWzFfOeirosgnl8nTyCH1tGgP/Kdbm1Hdzur4Gu9QxQxs/RGRHShd?=
 =?us-ascii?Q?JDfpLT716xEJvPhKvGCXF5rLo/NijCGeWEK1ReodSnmne2WgaG39DCybzvOF?=
 =?us-ascii?Q?VQOxxyTVYaMYkfzqJfJqLy0G+dh8TWbM3NoCfgQvKDnHt7plMo1PtbzKRecH?=
 =?us-ascii?Q?UaLjXtiAYbAdzrmYZz0ldJJfPBNKdG0WNFeHQxXKH48jPPaYSjo9DLosYUrg?=
 =?us-ascii?Q?8ibLSJoURbBiIjmco7khYn2RInHDz4Gf3RMrq1Y4e/mAcCNIXOYlia260Go8?=
 =?us-ascii?Q?I2b60F9kElxHkLufI2P2kL6lVRkEgtmWT30dF6WNSb1OhhgjnVvlI9PlFVYA?=
 =?us-ascii?Q?MwyuS4Wty8L7amoBps2Jf2NHQG/MJBHqAq42U6zihM5kVwnEK92QH04P7p1u?=
 =?us-ascii?Q?riJrDQ3NyaXZ/fsI4JAO0iuO4wERdyuezsA8MTg2+g5grmAzbxhPYyffZDbo?=
 =?us-ascii?Q?5/HLbPDueOre+AoW5JyZyJU7VdBavJVlA/DXv6imSlNRYtpnEIJFVyLxJhy+?=
 =?us-ascii?Q?f4kHUW1Qm/x5+ku4GaAFkzhwMu9WYfZJbCIjwPRGwhLYv9e30j4L1XX8u5sf?=
 =?us-ascii?Q?1MKfQNVikyMvhtYT/MKaActW1c4QkEk6ew7nwZLpJlnUDrogI8bANYvl1lxk?=
 =?us-ascii?Q?8QO7J8Fcm3bH72SAJC/NvEPTFXHZ5/4U0Fww0y9PQ66pLdb0SrsZhuoza8+a?=
 =?us-ascii?Q?9UzYrYufgcpYJfcU7DTnT62HeohvDpCgIK7xWExbvgo=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308e1fe7-e370-4465-27c0-08db4af2efa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2023 09:52:26.5939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LBy1+7dJkD+IWSt/BP22KK+tSfSy3FKQMURgRSv7CGEHeKuQE5vF0mt8ih080xNjswCN5nSwrkx4aixUkvlHtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6962
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 28, 2023 at 11:36:29AM -0700, Bart Van Assche wrote:
> On 4/28/23 01:09, Niklas Cassel wrote:
> > Do we really need to dump the whole sense buffer?
> >=20
> > Shouldn't simply printing the SK, ASC, ASCQ be sufficient?
> Hi Niklas,
>=20
> How about replacing patch 4/4 of this series with the patch below?
>=20
> Thanks,
>=20
> Bart.
>=20
>=20
>=20
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index 370ade0d4093..d4a27cd4040b 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -258,9 +258,14 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__field( unsigned int,	prot_sglen )
>  		__field( unsigned char,	prot_op )
>  		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
> +		__field( u8, sense_key )
> +		__field( u8, asc )
> +		__field( u8, ascq )
>  	),
>=20
>  	TP_fast_assign(
> +		struct scsi_sense_hdr sshdr;
> +
>  		__entry->host_no	=3D cmd->device->host->host_no;
>  		__entry->channel	=3D cmd->device->channel;
>  		__entry->id		=3D cmd->device->id;
> @@ -272,11 +277,21 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__entry->prot_sglen	=3D scsi_prot_sg_count(cmd);
>  		__entry->prot_op	=3D scsi_get_prot_op(cmd);
>  		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
> +		if (cmd->result & 0xff &&
> +		    scsi_command_normalize_sense(cmd, &sshdr)) {

Looks good to me, but considering that a command can be SAM_STAT_GOOD
(which is defined as 0x00), and still have sense data (e.g. CDL policy 0xD
timeout), perhaps you could use the same check as in:
https://lore.kernel.org/linux-ide/20230406113252.41211-1-nks@flawful.org/T/=
#me609b85c48b4048561662b0a4b1d102e19d7a13d

i.e., something like:
	if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
	    scsi_command_normalize_sense(cmd, &sshdr)) {

instead of cmd->result & 0xff.

(Yes, I know that the CDL series is not merged yet, but the point is that a
SCSI command can be SAM_STAT_GOOD and still have valid sense data.)


Kind regards,
Niklas


> +			__entry->sense_key =3D sshdr.sense_key;
> +			__entry->asc =3D sshdr.asc;
> +			__entry->ascq =3D sshdr.ascq;
> +		} else {
> +			__entry->sense_key =3D 0;
> +			__entry->asc =3D 0;
> +			__entry->ascq =3D 0;
> +		}
>  	),
>=20
>  	TP_printk("host_no=3D%u channel=3D%u id=3D%u lun=3D%u data_sgl=3D%u " \
>  		  "prot_sgl=3D%u prot_op=3D%s cmnd=3D(%s %s raw=3D%s) result=3D(driver=
=3D" \
> -		  "%s host=3D%s message=3D%s status=3D%s)",
> +		  "%s host=3D%s message=3D%s status=3D%s sense_key=3D%u asc=3D%#x ascq=
=3D%#x)",
>  		  __entry->host_no, __entry->channel, __entry->id,
>  		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>  		  show_prot_op_name(__entry->prot_op),
> @@ -286,7 +301,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		  "DRIVER_OK",
>  		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
>  		  "COMMAND_COMPLETE",
> -		  show_statusbyte_name(__entry->result & 0xff))
> +		  show_statusbyte_name(__entry->result & 0xff),
> +		  __entry->sense_key, __entry->asc, __entry->ascq)
>  );
>=20
>  DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
> =
