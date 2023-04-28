Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583EFC77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 08:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345529AbjD1IJy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 04:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345549AbjD1IJw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 04:09:52 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7141FF1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 01:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1682669391; x=1714205391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TrJba1QYw3qS/r7VWAiZ1vTP8F8hzTT1Lc7i+gDxj8Y=;
  b=bOsWBFS9qKL6AnyWi6ry7Htlzp4YtoD1zDaKPc67pGkVhxSjFwRRhppL
   hBoJ7g43GXBXk741Prx9PuS0GBAp24PId5Wn/0aZf1uIdfpeDxO1sAzX4
   fKnfHvUvmeUbYOFR8rpE3lv6yYti4Cgk3NryvPPasO1gLuAasH9xk8cnP
   h/FED+bcLnzaHdGAr4jKeqb0HAAL0eAR3ZC3dCLGO+NEB1WZ6LRXB+ouo
   M8JU2BLMhj24eCAy2kBTFpjxOiOUnaETFwLrMF5D7cSGOVre0u17SMqsE
   rlNvUHd06XgiK0G0CiY6Zk31S8Sbx5LGu/gBsu1AMfuyuU83rg6A2Urp6
   g==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677513600"; 
   d="scan'208";a="229381970"
Received: from mail-sn1nam02lp2043.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.43])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2023 16:09:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGFUw9Yz+KdWs7f/4Cm47zL2JwI/1HhBwRL24BJxwx6szuhW1UmJ2IYc6KHVimrkhAw4JIijckROyAvnsVuf8eut66jzYcIChmwdQd/U29U6Q7s0SeEXIvL9nFzBd0HMLzbfwUNwP0vb2G96fHUygbDz6TglXR9mK6Fn4OWxBP/L9usloMUX8bzqaV6lfGdA63j9O76rFqGOYS3F8baNQv5qJEOjWSDxg+1JEA6bS2QY7kwEWnNiIh0VKB+WKlUnPm/6HFX9pxCwR9cRe+/wFiFRxVLO3HodHsWbrpL5Aw3EltdPl90ISqXaKC5uLhPqikOIAms4bBsWrmGDwvYqFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPhTWc/G6UfAAbnFht9rfwvvFE1I8EUMrFnPsqcFyA8=;
 b=iuHmZliH4sMbO9lnD4CM+0GIx8WO6FrlJOL0VXXuxOHUmsoPIF02N4D7a8y0OHw9AGF7UoLSgBsGkxTDDlkM7+I1G4iTEuXjWkOF3s5lu79h10kGnNs790+ST9sgWwrn90Njz0jC1joBBSi1YmOeRCZeY/tlR+oou79xgixmZzrbKGf5PDH76i49l2qWePY6J5zZ9dH+yhJfsxrHZGqh0mDTa0koNkmhdhztf1mKQxaHWVFAiG75SBWY+4g3R7uMZDoT+WdMdlUHWG6hPoXsuXOXvv516mtOvNyjxVsRrIo0sPvnEIXGRe7VajUF0AD8uvNALsdhbX0EjW03JH7pfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPhTWc/G6UfAAbnFht9rfwvvFE1I8EUMrFnPsqcFyA8=;
 b=WPorRmcvzjc+/u1PrNHcuTaF/ntbqjjfPWDNRTFhLAM++Rcv4J4wK6XQkI62ww+usG8qJFTiWARS8Pb+US9naQ7vcgos2neW8JosQz1hpkX7mSjR0jz9aGQkZkWkO5PsUtrW5uzc7Pc450ws6hqVvELpFdXiL1b5iSmsFAcojTo=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CH0PR04MB8052.namprd04.prod.outlook.com (2603:10b6:610:f0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 08:09:46 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fd:6db1:5165:2ade]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fd:6db1:5165:2ade%7]) with mapi id 15.20.6298.030; Fri, 28 Apr 2023
 08:09:46 +0000
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
        Changyuan Lyu <changyuanl@google.com>
Subject: Re: [PATCH 4/4] scsi: Trace SCSI sense data
Thread-Topic: [PATCH 4/4] scsi: Trace SCSI sense data
Thread-Index: AQHZeajLSvQtpzf8lky+3WrgPH7wew==
Date:   Fri, 28 Apr 2023 08:09:46 +0000
Message-ID: <ZEt/SD/GiqIo5aIm@x1-carbon>
References: <20230425233446.1231000-1-bvanassche@acm.org>
 <20230425233446.1231000-5-bvanassche@acm.org>
In-Reply-To: <20230425233446.1231000-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CH0PR04MB8052:EE_
x-ms-office365-filtering-correlation-id: 142248c3-dee5-470d-8295-08db47bfee33
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fT0FwU93wVbd1nmpdKsxeyxLpilZI60YjyorGGVqYjIzzbAknn+fA2/+etc3D2NKopenOEDRrf3vNhdfX+SP/AmoHNRIBpNhaiHYcsCg7cQcKIwEJEKvcYV6bxtmxSdhw7n5QWJs1nWlcgGdbPXJ6OTVz9nuFFUPCa4sEDTF6oCwsnrGju2ZJfs0ywadHKCGUWtEOZ8GI0LuLb3yu9AMeUNIwRzojaj60+UiaTtnwiOqipZci5dR95y7irwnlWhLLBfq/vK+EyIN4U+hArnL+GfwrB4VySlS1oZnAcjLDW+tZZtyInJjnvdXPUMKNVmebvKopyGoyvP+hue7hSwgmLAGY0makvq44WSjOQHYnXXiTNlX4Qbz2pHYqRybA1lhK5um0kRsaME1u1/mOrITmlo4E8FCTBObdb/1ut3kRwIFvmysoeov9zBPj/FuvIoreY5P8XqcRIoRFfMh4T1LIEdYyJkOmSARCsXtEQ9A0aTveCNizC7cbXqzQN+Pf9O1AXbLd+ozc09FFFu8fQ+s9YiIPTqpzrcpXR8YQvFb2jz8gyYKvoyS1MoCsKzFsv2CfumAl3b/6PjuqLgVyokZvfLOfOPyDuEw80M2TLgln7o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199021)(6512007)(478600001)(82960400001)(91956017)(122000001)(54906003)(186003)(33716001)(6486002)(9686003)(6506007)(26005)(71200400001)(966005)(83380400001)(2906002)(66446008)(76116006)(316002)(5660300002)(38070700005)(7416002)(66946007)(66476007)(6916009)(86362001)(38100700002)(66556008)(4326008)(64756008)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bMbYHcB1dnLkcFkgO7mGvImaKPeJfOm7Kv7f1d0f+a4UUsbzLtn44Y0ArFzM?=
 =?us-ascii?Q?AedmGh23p0U1tLt1IuztCOPSfitoi2vXgZq8Wc5M7bvekorVO+ONedM4QCXP?=
 =?us-ascii?Q?sXJkCNSQXYNaItk+Ar87zp0XToLuyDWCkUNwSlpr6FpDb4kid4hzOcyJvnok?=
 =?us-ascii?Q?76J5yGSbl7NdOjo1+KXjnJUma2Op1uadt1HkZMO01NZECZG5SwMc4WBnPzir?=
 =?us-ascii?Q?vlut5GRhN1bMMfU8qfGLsg2YpxCFH33hBznfhEE1wcCuX7c+mwdaTPubncZ2?=
 =?us-ascii?Q?IsMEOpgD0uX3QzecZ0AtHku7XKaqamsg9/+LiXZkgE/BYrHREwv5yk3H6m16?=
 =?us-ascii?Q?lyOueqdlc+JzPAlR2r3f6qWHZ3DBRmggTXmN6QTjtEGVWBPlLcb/U91oq9CQ?=
 =?us-ascii?Q?BdUbLZY8XQfnb+crZ3dlR718f+uuEudofeNsgJQud5V0CjsTZew0yIGSilhw?=
 =?us-ascii?Q?BqP1o8NE0kwfSwUauh5XPVZhchDMcGPK4gHyhvN2703NEV1/DkNrYs0LDDen?=
 =?us-ascii?Q?ILEKIL5WGIYYH8EN+N2Me3/UNNQ3AkrNUzZP7ADgwEJNqqmop2brwnxQuRCp?=
 =?us-ascii?Q?AIf0rx2AqGpPDrKCR65MTc4Ekabi7gTScX4YDi6N0auq8cXqZvqrx7jYHeeD?=
 =?us-ascii?Q?WIMSVySbREHn6t6SvTenKH9MW3DBQzt4LPJut83KWWXB7DJWJC4nlr3XB0vG?=
 =?us-ascii?Q?a3DF5fSlzp4hrMOokgkVxJsYbxibzJU1TpLxhGa5ktGQOSHI3SaZFaXWRcOi?=
 =?us-ascii?Q?C669iR34f6kQ2V5Kyu18ubTqsmCNtI7suI8K8MHyk0We0RiQnGtgiEZ4cCz4?=
 =?us-ascii?Q?WXg6lQVkCMOFTJCqickWOSgyaoeaojbiWMxCOa7Xgmlwoi4c6e8VZ80Lenro?=
 =?us-ascii?Q?u6f+WNvUZnBjIxcn/W6zpjAUqnqxUoWVqEG+2MskEJjnKk0CRGbUTi1JfbF2?=
 =?us-ascii?Q?VutCQIo8Ivj0NTTa0xIbd780FQKC8lK2PvLs5EsN8VSQyUcdMHdOkXXj1a+w?=
 =?us-ascii?Q?3/ZB7+bhqlkk5AX74DoC6pPrcFWTea9TzgraNj1+xEHm+e5MuvtPb8cZGnmy?=
 =?us-ascii?Q?V98MoBK+jO8cxUBaCHgD2HtkSm4MQqGptGfuTV3Fd/WcUZr9AFR8EeCJchKY?=
 =?us-ascii?Q?FA4D0pyEXAYcTw5avMH0h90pi6UIZU1rltPFrCnsIdbIkqJ53OjRi8L0vvLc?=
 =?us-ascii?Q?cBmmLzXcqK+C7RaeuQhbD11K08/bDT24Xp1OVcm32F7QnX8AnP9i6tz0/oBm?=
 =?us-ascii?Q?/D8Dp7iHRQeintCsNMqRbAccNWMi4vLK6be0CH7cwOrE4QVU4AVlxA/2TnxZ?=
 =?us-ascii?Q?mxenxZlmQMb+dVHPR7YPygcwbOYWP9uiZ/xDjtDn8eJqBVbBW80cTyfAUSnZ?=
 =?us-ascii?Q?JhagXy52jxQvVqfbi8HbUcPv3Kd3M5W1szyo8QAZRQGYvqLgMa4kfYuBjG54?=
 =?us-ascii?Q?cYZXTdWiyMShQioXIPKJUn03Umy7TxxobH8qNploR/NtXUc/XaO7MpxeBMuq?=
 =?us-ascii?Q?SYTro0Hw4pqFRJQ+LUvgU/jv7kX7lexWMAjOh5s+tBRNYcdQCIeuiwFC5/qg?=
 =?us-ascii?Q?z/mMcDKDIse3SkuKnYZYkniFGXMnbFOGQ5qHjVHiXaP9X6dnRRVCtxAbfkuv?=
 =?us-ascii?Q?Kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <665018A586D1834683511D363654F8B9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?PieTJXeEywv+maFtEZvOvgn7sCzGJnciL84wMyIihwobQxK3AlEhs+CBHIa8?=
 =?us-ascii?Q?LGJMDaYXRsVZ7qN9Cm7hndPIgYqO7m9UTsqk/apiUpLpjvbKl/CHEeIpnjp9?=
 =?us-ascii?Q?0kGBBPEoDSabrnE1vFnAfUuEWM6Ro7MQrMp5geTRoLo4ybDNWId4kImm5Bfj?=
 =?us-ascii?Q?DK0o6MzVuYbbOPwf0QltHnnyTJkP4xF4G+u1rV8ayHbranJltIZieMqSknNx?=
 =?us-ascii?Q?erNPgnCi6Sgb5l4Q6aTI87p6vd1a1uEulwrz4iA9J5vTfRt/puQQSefEVr73?=
 =?us-ascii?Q?XANbsRPiMQ1bh/SNXGfE7pkHVTNfweMTwGATN8eFmQGkcaDHIel0Zo6zJ7/H?=
 =?us-ascii?Q?/6hk4ux6ffYBehEbPg1645XSbZuQkPlWFqn38TCmPhq3aIuOQRhZaH7H6do3?=
 =?us-ascii?Q?XIUVQo176SzgNkz+swkBV0/wYGCkR11xdt0aAm3ZNpG7ugM8vFndi5WJ/DFn?=
 =?us-ascii?Q?GWkvXLYPRjNb/3hPeWTYjtWLJMGDxaI/9pUIsmAaeNor1OeI7dPNQApvhJWJ?=
 =?us-ascii?Q?TAzzjF0x7FVQLc+NoLh8h/fmBTrR0wV7T5er0BklHUDpwjAC67c43AkWbjAf?=
 =?us-ascii?Q?xdBjMzcMzng+8pBtjc42GGQmuf0wtw8/NLnj4w8bzY5kOn4uRIh5uj6Qar12?=
 =?us-ascii?Q?q2GgOa7e9ufXb8Y8ESzjgJZPf+MrtBLexnmre+q7bLjLfH5Y4/far6SDJ9gj?=
 =?us-ascii?Q?pEGI0LJC5KcuDI7db8EnZzxJzs2287H4LIoBT2LISFLu85q+zjjvAcHw0kbs?=
 =?us-ascii?Q?KqJ3Y4fO6Y5H1XHkgrGfnkHSbwfFNALk/tupWUDvWeFP1hvMpbw2rNeUkYjp?=
 =?us-ascii?Q?w0QYcj/FPqbOlc1Z90OZGGN2mRP8EAAevfe9WdWcJHV8a1+VgXfl2BTzBDof?=
 =?us-ascii?Q?qKs5myn7sZdOhkPAA3INuN7AlKIUz+7c+GV7v4er2Su6/6VhQtisVFmy6vSY?=
 =?us-ascii?Q?Bsqbma9UepO/Dl8Bzz/AlBEKmXkgmsyebKLsYHityfI=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142248c3-dee5-470d-8295-08db47bfee33
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 08:09:46.3304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d7B833/aSYMgGBPDh5DTAL1O4P0hVfJ8bvxPAfnOWWp8cFOVZt6Uu3igym1qspJ4Um0nBvVihHbs3X4V04siNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8052
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 25, 2023 at 04:34:46PM -0700, Bart Van Assche wrote:
> If a command fails, SCSI sense data is essential to determine why it
> failed. Hence make the SCSI sense data available in the ftrace output.
>=20
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/trace/events/scsi.h | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index a2c7befd451a..bb5f31504fbb 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -269,6 +269,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__field( unsigned int,	prot_sglen )
>  		__field( unsigned char,	prot_op )
>  		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
> +		__array(unsigned char,  sense_data, SCSI_SENSE_BUFFERSIZE)
>  	),
> =20
>  	TP_fast_assign(
> @@ -285,11 +286,13 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__entry->prot_sglen	=3D scsi_prot_sg_count(cmd);
>  		__entry->prot_op	=3D scsi_get_prot_op(cmd);
>  		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
> +		memcpy(__entry->sense_data, cmd->sense_buffer,
> +		       SCSI_SENSE_BUFFERSIZE);
>  	),
> =20
>  	TP_printk("host_no=3D%u channel=3D%u id=3D%u lun=3D%u data_sgl=3D%u pro=
t_sgl=3D%u " \
>  		  "prot_op=3D%s driver_tag=3D%d scheduler_tag=3D%d cmnd=3D(%s %s raw=
=3D%s) " \
> -		  "result=3D(driver=3D%s host=3D%s message=3D%s status=3D%s)",
> +		  "result=3D(driver=3D%s host=3D%s message=3D%s status=3D%s%s%s)",
>  		  __entry->host_no, __entry->channel, __entry->id,
>  		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>  		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
> @@ -299,7 +302,17 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		  "DRIVER_OK",
>  		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
>  		  "COMMAND_COMPLETE",
> -		  show_statusbyte_name(__entry->result & 0xff))
> +		  show_statusbyte_name(__entry->result & 0xff),
> +		  __entry->result & 0xff ? " sense_data=3D" : "",
> +		  __entry->result & 0xff ?
> +		  ({
> +			  unsigned int len =3D SCSI_SENSE_BUFFERSIZE;
> +
> +			  while (len && __entry->sense_data[len - 1] =3D=3D 0)
> +				  len--;
> +			  __print_hex(__entry->sense_data, len);

Hello Bart,

Do we really need to dump the whole sense buffer?

Shouldn't simply printing the SK, ASC, ASCQ be sufficient?

Yes, it is a bit annoying that there are two different formats.
But you could do the reverse of:
https://github.com/torvalds/linux/blob/v6.3/drivers/scsi/scsi_common.c#L241

Or, if the tracepoint is after scsi_normalize_sense() has been called,
you could simply use sshdr->sense_key, sshdr->asc and sshdr->ascq.


Kind regards,
Niklas=
