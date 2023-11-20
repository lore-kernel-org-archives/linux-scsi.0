Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBC8C197A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 22:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjKTW1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 17:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjKTW1W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 17:27:22 -0500
Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF7F97
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 14:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=7690; q=dns/txt; s=iport;
  t=1700519238; x=1701728838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t4Cn0+Iw1wE+AADQAGZpzjE6aCys1gR8X8FDxwkIlSM=;
  b=mJRFrN5ern2ueroWHiZS+A9RlccdE05Kqj13IlRVbalGqmvPbfOK+nP4
   SgB/Sp6YWRsRcytm2+MQ0Ew4puRCWcECZOPiMPyVplHmBl5fqynH/JcPK
   D3+DA+LxW/64UTp7tVq2tcCxpto7aS0omsAFlV2TTdD1LsNtjMOlbw2dY
   s=;
X-CSE-ConnectionGUID: hW7SKVUkQ2GVurRoGUH9hQ==
X-CSE-MsgGUID: AnxxAt13TK2kxxhg0/OvQg==
X-IPAS-Result: =?us-ascii?q?A0ADAAC73FtlmJRdJa1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBFgUBAQEBCwGBZlJ4WzxIhFKDTAOETl+GQYIiA51+FIERA?=
 =?us-ascii?q?1YPAQEBDQEBRAQBAYUGAhaHEgImNAkOAQICAgEBAQEDAgMBAQEBAQEBAgEBB?=
 =?us-ascii?q?QEBAQIBBwQUAQEBAQEBAQEeGQUOECeFaA2GRQEBAQEDEhEEDQwBATcBDwIBC?=
 =?us-ascii?q?A4KAgImAgICMBUQAgQBDQUIGoJegl8DAaEEAYFAAoooen8zgQGCCQEBBgQFs?=
 =?us-ascii?q?m4JgRouAYgMAYFQhAmENScbgg2BFUKCaD6CYQKBQgUbFYNEOYIvgVSHUQcyg?=
 =?us-ascii?q?iKDKSmDPj4qiikJdgRDcBsDBwN/DysHBC0bBwYJFC0jBlEEKCEJExI+BIFfg?=
 =?us-ascii?q?VEKgQI/Dw4RgkAiAgc2NhlIglsVDDRKdhAqBBQXgREEagUWEx43ERIFEg0DC?=
 =?us-ascii?q?HQdAhEjPAMFAwQzChINCyEFFEIDQgZJCwMCGgUDAwSBNgUNHgIQGgYMJwMDE?=
 =?us-ascii?q?k0CEBQDOwMDBgMLMQMwVUQMTwNrHzYJPA8MHwIbHg0nJQIyQgMRBRICFgMkF?=
 =?us-ascii?q?gQ2EQkLKwMvBjoCExgDRB1AAwttPTUUGwUEOylZBaF9gUAsNIJ1kh8Jgx9Jj?=
 =?us-ascii?q?x6fFgqEDaE/F6oFh26QUiCifw2EfwIEAgQFAg4BAQaBYzqBW3AVgyJSGQ+OI?=
 =?us-ascii?q?AwNCYNWj3l2OwIHCwEBAwmKYQEB?=
IronPort-PHdr: A9a23:ojYeAxW4VyRPpOJMZBXkXHyoLFzV8K0yAWYlg6HPw5pHdqClupP6M
 1OavLNmjUTCWsPQ7PcXw+bVsqW1QWUb+t7Bq3ENdpVQSgUIwdsbhQ0uAcOJSAX7IffmYjZ8H
 ZFqX15+9Hb9Ok9QS47lf1OHmnSp9nYJHwnncw98J+D7AInX2se+zfyz/5TQSw5JnzG6J7h1K
 Ub+oQDYrMJDmYJ5Me5x0k7Qv3JScuJKxGVlbV6ShEP64cG9vdZvpi9RoPkmscVHVM3H
IronPort-Data: A9a23:AGfmqK3g90GxvVOHoPbD5dxxkn2cJEfYwER7XKvMYLTBsI5bpzwOm
 GRMUWCFb/mLM2umKNolbYjk9k0H6sDUy9A2TgJt3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ1yFjmE4E71btANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXV5
 bsen+WFYAX+gmcuajpOg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauG4ycbjG
 o4vZJnglo/o109F5uGNy94XQWVWKlLmBjViv1INM0SUbreukQRpukozHKJ0hU66EFxllfgpo
 DlGncTYpQvEosQglcxFOyS0HR2SMoVGx+D8AkaCsvXJ4HPbaUHr7MhOXUEPaNhwFuZfWQmi9
 NQCIzwLKxuEne/zmej9Qeh3jcNlJ87uVG8dkig/lneCUrB3GtaaH/WiCdxwhF/cguhNFOzCZ
 s4QahJkbQ/LZFtEPVJ/5JcWxbvy1iWlKGUEwL6TjYMx83j60FUq7Ju3M8rFetPSAuJLp0nN8
 woq+EyiX0lFb4bAodafyVqoh+nSjWbgU5kTPKO3++Qsg1CJwGEXThoMWjOGTeKRkEWyXZdUL
 FYZv3N066Mz70esCNL6WnVUvUJooDYcZIVrMNMH6zjX5ZTJ+TyeKVUkHz54PYlOWNANeRQm0
 VqAntXMDDNpsaGIRX/1yltyhW3rUcTyBTFaDRLoXTc4D8/fTJbfZy8jo/55G6Kzy9byAzy1m
 mrMpykljLJVhskOv0lawbwlq2zxznQqZldpjukyYo5Dxl8jDGJCT9DwgWU3Fd4acO6koqCp5
 RDoYfS24uEUFo2qnyeQWugLF7zBz6/aaGWB2QM3QMN5p2zFF5ufkWZ4vmsWyKBBbJ5sRNMVS
 BaL0e+szMYKYyT0Nfcfj3yZUZR3k8AM6ugJptiPM4IROcIuHON21CpvfkWXl3v8i1QhlLp3O
 JGQN66R4YUyV8xaIM6Nb75Fi9cDn3lmrUuKHMyT50r8i9K2OiXKIYrpxXPTNIjVGove/lWMm
 zueXuPXoyhivBrWO3iLqNNLdAhVfBDWx/ne8qRqSwJKGSI/cEkJAP7KyrRncItg95m5XM+Rl
 p1hcie0EGbCuEA=
IronPort-HdrOrdr: A9a23:AJmZdKqcEYOJrC30+g0SZEAaV5tuLNV00zEX/kB9WHVpm5Oj5q
 OTdaUgtSMc1gxxZJh5o6HwBEDhex/hHZ4c2/hpAV7QZniXhILOFvAt0WKC+UyuJ8SazJ8+6U
 4OSdkCNDSdNykcsS++2njHLz9C+qjHzEnLv5aj854Fd2gDAM8QinYcNu/YKDwIeOAsP+tAKH
 Po3Ls8m9PWQwVtUi3UPAhiY8Hz4/fwuNbNZxkACxQ76A+Iow+JxdfBeSSw71M1aR8K5a0t31
 TkvmXCi5lLtcvV9jbsk0voq7hGktrozdVOQOaWjNIOFznqggG0IKx8RryrplkO0aKSwWdvtO
 OJjwYrPsx15X+UVHqyuwHR1w7p1ytrw2P+yGWfnWDoraXCNXAH4ot69Mdkmynimg0dVeJHoe
 R2NqWixsNq5Cb77WDADh7zJklXfwSP0CEfeKUo/g9iuMMlGc1sRMokjQNo+FNqJlOm1Gjhe9
 MeVv309bJYd0iXYGveuXQqyNuwXm4rFhPDWUQavNeJugIm1kyR4nFojPD3pE1wv64VWt1B/a
 DJI65onLZBQosfar98Hv4IRY+yBnbWSRzBPWqOKRC/fZt3d07lutry+vE49euqcJsHwN87n4
 nASkpRsSo3d1j1AcOD0ZVX+lTGQXm7Xz7q1sZCjqIJ94HUVf7uK2mOWVoum8yvr7EWBdDaQe
 +6PNZMD/rqPQLVaM90Ns3FKu9vwFUlIbooU4wAKiezS+rwW/nXitA=
X-Talos-CUID: =?us-ascii?q?9a23=3AbbLQoGv2zk6K3vmzIa9kn/u76IslTSLm70ntIHb?=
 =?us-ascii?q?iJlh0UoeSZmKwqaNdxp8=3D?=
X-Talos-MUID: 9a23:HX7TjAb3+KiBfeBTnjn8lBh+bZxUwP6tGFANns1BnNe9Onkl
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-core-12.cisco.com ([173.37.93.148])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 22:27:17 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
        by rcdn-core-12.cisco.com (8.15.2/8.15.2) with ESMTPS id 3AKMRHNg027854
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 22:27:17 GMT
X-CSE-ConnectionGUID: MshkCJBaTLa1Mi2gW5Z6fQ==
X-CSE-MsgGUID: wFAnzpTwRvaZ1NwFbN055A==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=quarantine dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.04,214,1695686400"; 
   d="scan'208";a="9321095"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by alln-opgw-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 22:27:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF+Co3173H+Ze1o5ZamaU05QeGLw9Gc75yPX4Wrs45Vh6czoa1wvdnqF3H+Sd532KQMnPt1BX2rDnr3Mt1T1mDaDDWPdRNhTSIc+Opf4WtvZFA8JX5uyqhwgg6sjNt+pgs6KI7TDdbJ4VkxPXGbpot+68H5jSlcYRxgUzrg+irSufqHqAjHvMH1tcPYNSKeMFYuRVL9Pt22qXIQmyjBT9ZkswJg6H+KnZnfq2825hlCo0acmeJp+2szNothwe3yGyrTppil+pNkY/XStykwhMw5O76NBdRBnwGieSCfIn7GUSMLco5fQ68YSPkPCYQvF2c0oNYB6XqXINbeA3ELfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4Cn0+Iw1wE+AADQAGZpzjE6aCys1gR8X8FDxwkIlSM=;
 b=kZA7TP1lXLQsNLTArbn4VK62xYbpg/2prRlEYJqdYY8wyqDzH5xUnn4/usD+iOjmFG9cT+AH+HQjruKZ8mTkrZdMFV6+cODW51GMLhD3H2tFJkOIBMWMhb4S3udj4lqyCF/rGHT4IUgWXazJDL65J76jI/icaFFcx8JEGT9yT85kRKluoKNKEdfF+XsWc/rZwdjSHqLtsf8dk4Za3TSJ7DN/oSIGd3Y1fWB/iHmOniR10VvS3d+FkQdjgFbbMQ/ri6uJtwjsBnWHRUl7Ze3uz4vK/LWvprJSsn1qw9UVbtUq2qsgTrdmd4/Js6U8uxO15a8rUy1PBne8Xg2ZgtNjSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4Cn0+Iw1wE+AADQAGZpzjE6aCys1gR8X8FDxwkIlSM=;
 b=NNMqlDknsZJ4OpcgPrWsxu4E4Ol2ak/Rl/oJ51tjD4FoK+qZnitXP9UcyIBct/3SgZA67UMlJFptITWe3TkQmxdkPHyqSthP2Gm92S+p1mf+lBma5VvPNZsBC+2A+DvRjwFBjFerjIh4Fh5Re9rUe0DLcaX0mro3WFZpyHlkAZ8=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH8PR11MB7120.namprd11.prod.outlook.com (2603:10b6:510:214::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.23; Mon, 20 Nov
 2023 22:27:15 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022%7]) with mapi id 15.20.7002.026; Mon, 20 Nov 2023
 22:27:15 +0000
From:   "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Dhanraj Jhawar (djhawar)" <djhawar@cisco.com>,
        "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>,
        "Masa Kai (mkai2)" <mkai2@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>,
        "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>
Subject: RE: [PATCH 13/16] fnic: allocate device reset command on the fly
Thread-Topic: [PATCH 13/16] fnic: allocate device reset command on the fly
Thread-Index: AQHaBkb42cCL+heyGUeyjm7ciZVVH7BtxXAwgAtnMMCAAGhugIACobVAgAMYeqCAA7CpAIAA89uw
Date:   Mon, 20 Nov 2023 22:27:14 +0000
Message-ID: <SJ0PR11MB5896DCA2219FD8C0047B5C13C3B4A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20231023091507.120828-1-hare@suse.de>
 <20231023091507.120828-14-hare@suse.de> <20231024065427.GD9847@lst.de>
 <SJ0PR11MB589682551110734A017D19C3C3AAA@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58960463A1A9D634BE8D2A62C3B2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <a5df8cc9-34c4-4448-817f-0f61f4a493de@suse.de>
 <SJ0PR11MB5896E596C922936ABDDE0567C3B0A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58961DC466F1FC2DAD8825F6C3B7A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <2d5071d6-daab-4585-823f-5f2e9dde8f79@suse.de>
In-Reply-To: <2d5071d6-daab-4585-823f-5f2e9dde8f79@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH8PR11MB7120:EE_
x-ms-office365-filtering-correlation-id: 1f9eb3ec-110f-49f0-8df9-08dbea17d90f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bu6y0E/AR31+J+pDiGFIjRGJg3Hk1BjDqKWd+SiRDJoBQ0JL8lOoXFel3efaXAHAckgymZVp964WmlTnR3W/9B2sgjyKSzCM6T7IDqR2lHAPqrchSZQcmeLroe3IPks0sgrgo0TyTnQw/4wcraXD2E7+bLeSd0JNcDruh9IYrW2wr39WHSIFltZ4JYJ1GK7yBcURM7Bw7EGRDwzQjZZaAlT/faIsza45jBk11BKc0DvlbwHpCh6OITTKP218VhsJfkPx2RfK8gHTy9SeHG84gJeg7mB0JV7WvNsqow9UloWRvV68FljfYTJqnFjyxW2OLeBa7IDz1bhF2/WLy63cE0k7JXlh9kOXme3BVJzPJ92pknQIHMqG+cdBqvnYc8ZT93+GtUrw0j2L836MdYknw2EdaqOD9ds/fmXAdEhgZokFLwrsGTa1+EqJZZMu/VeDb0+I6sTJpV5XLh/V9P/5d7RQvm/G+vnNUZzmPeIeRwJA3NZTHcV4tQtziaKOF+FS6vHP/LinlcFC40xxyX59rakGwjTR2DR4dNVceoR6lUY2Lh5JLd48836PcHcG1fgJLTsMMG4Q+pHtOLGPB7rcBVbKNo+9fBdYl0qKb947FfmdwDS0r8nMkFqSqz/5yCyI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(2906002)(478600001)(52536014)(4326008)(55016003)(8676002)(5660300002)(8936002)(53546011)(6506007)(7696005)(66556008)(64756008)(66946007)(316002)(66446008)(110136005)(54906003)(76116006)(71200400001)(66476007)(107886003)(41300700001)(9686003)(83380400001)(38070700009)(122000001)(86362001)(38100700002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXU5b1MrNzlmUDVpTTBoWFVJaU1yc3VpbVROeXZnZ0lHT25jYjVVTi84blVi?=
 =?utf-8?B?QWZSMW81bW9RQ3pZNXlWVldiM3BSeTJ5aDFqK1I5WmgwcDkwZGFOdWxuSHhI?=
 =?utf-8?B?b2Y4QS9QMTRONVdmZVFFZ1I1RGdUSVZNQVEwQTkxYXZQNW91UTRIcXNDbkRP?=
 =?utf-8?B?NWVJU1dMd2g5VVVCSzgwM0ZjUnQ2Y1VYdmxXdUc3T3BKQmFzK2hmYnp2bUps?=
 =?utf-8?B?b09EWlNTclRLaWlpTFFBK25wWmxFamxpbUU3OFZVMGxSZHMralhvOTlJSWlv?=
 =?utf-8?B?elJUWXBwZlZFejJiNU5WcSt4RDlmNU9FVEsrUzN6ZVlHUjFvZEVQeE9GS3pW?=
 =?utf-8?B?dHVBV0NsbXNxRlBBeTdqTVFFaW1LcTBTcWxpR1FZS1hlc0RHa3BueFdOWEox?=
 =?utf-8?B?OFQ1ZjFXbkwwcDJ1UmtleTI0ZDdmZ0Z0bURZeEpFQi9nRXJ6R1Zrek9kV1FK?=
 =?utf-8?B?aDVCc29Gd0hUV0xVeWNqWkpEdmowK0RVUEtqTXV0MkZubTFDcU5pNFgyUklG?=
 =?utf-8?B?eDAvNTVXRFpvTUFQdnYzOFVvYW0weVZiMElKZDQyVElidkxscHNXZU8rOWVN?=
 =?utf-8?B?S0ZLUkRFb0VGMHhVeFQvTHNzRXlBcVAydW1KRDRxbVR2QVJOU3FEbjkvV1J2?=
 =?utf-8?B?RGkwOWpJdFd3SnpKb3pkVmhwNlR2STc1OVVQeGhyOTczSmNPdHF4bHRUdTdk?=
 =?utf-8?B?SjVIeFliUUdkM1IvbVI5aHdmRDNBWSt2dGRGYW9lL1RzaStsSkZ6dkNuRjdZ?=
 =?utf-8?B?RWp6MGZicXVHRk42ZVRLNTVGUkl0a2x5bFRHbVFRZWpNK056R01tMFcxb05B?=
 =?utf-8?B?UG5WWHB6U01KMi9PMUk0dENuMktXbXZqMmlsOC9ibUhES0JWaFZoNllYSml5?=
 =?utf-8?B?akR4OG83cmhRekl6dzEvMFI4SWJWQ1l3TUFLQUJhaVp3SjVvdnp5c0xpQ0cv?=
 =?utf-8?B?NThUTk1qQXNLU2lHYUpOc21jRXlrT3BOeXo1SllIZk5BSHNGMjJyZ3ZVZ2s3?=
 =?utf-8?B?c2xhMS9UZTlpUUE0WWZpMC8yUTNoaXVGbm9Rckh3a0hQanFHN20zR090cUc0?=
 =?utf-8?B?QkVsUWlZOFdMYmdJbUMxWmdoT0pFSUNHQ2JoYnJkQzNoeGM2bGdYT0kzbXl5?=
 =?utf-8?B?MG5ld2JOblpSOWVPK3lick5WbWpNMHlMSnB5NlJBM21yaFB2OUNCM1NjWllN?=
 =?utf-8?B?dlVnakVmeWJJUUxCejJjOFpXUmpZM0FhbGwzSG84ekVqTzRuNUNLbW5zdjB2?=
 =?utf-8?B?US9qcU9pbFMvbHZ6S1puTlpQblRaeVNUTWVjdkg3dVBEKzBaaHNUWWVwSjUz?=
 =?utf-8?B?UmJCZW5pZHRNRUpPcDR0Y1NrTHVrek5OdWliQkVsQVZJQ1Y4M2kvZDJnSG1q?=
 =?utf-8?B?VGYySS9RRG8xWTE3T3FzN2haYWVaeUw5OHd4L1hmc0xIZ3NPeG9VMTRsbml2?=
 =?utf-8?B?Nm0zZGZyOUxheTNmTHNFMFl6MjlLRFY3WkIxWDllRnp4eDNiZlpnVExKNWc2?=
 =?utf-8?B?UDNnSXd0L08vKzBJaDlwY3N2cUsyYUVaZ2E4UTVmN1NoM3hVM3p1dDdXY25x?=
 =?utf-8?B?ZXAwUzJScjRTSGJ4WnBSeFV6bVhYMzBJREx1YzV4NnVPdW5TTys5YnZBZ2hu?=
 =?utf-8?B?OEc0YWNkdWJVTmVCd2JTVzhxSldZaFJSaFVWMFdTUlgrdWtibFpITUhiUlJE?=
 =?utf-8?B?L0hhQ0pNZlY3SUZsMVN5MUNlNElyZ0tpNUZ4U2JEdEpmMVZRTXlUbFB6M3J0?=
 =?utf-8?B?NnBabjNvWG1kRm5qYndWOERTWGJVUWp2dE1OMXZSNmtEMTVEN0I4Q1pmNjhO?=
 =?utf-8?B?M2I1aVovTzV0anNTcmJlcUEyVlZwK3cwMFRycVlJRHlMOXp1TXdLUWx3eGZn?=
 =?utf-8?B?TERlVUxLVVBiNnE1TTFveS82blVBVi8vWDlOTmZvd09VcUhQVVNISWQ5bU9M?=
 =?utf-8?B?bHRlRHl5TlVhMUNQM2RYN0ppdHNBSlBSVE9OZnA0WnF3TklwcnVhMkVKWVVh?=
 =?utf-8?B?VkNuWEx2UlRTaC8xc2tEYkRGYlI2Y0JqbXdqdm1jY1U4NjhsZXdaZDlEclA3?=
 =?utf-8?B?Y3B3TlpCQ2FmN1R3cWt0bDVuc21pRFNIcmJZN3c0b2pJZ3ZZcUF0RFY4MUR6?=
 =?utf-8?B?ZmxGU3p3ck13NTRGcjJIcXI4S2xTMFQ0N1BNNnZUVG4xLy9Bb1dHUGN4UVQ3?=
 =?utf-8?Q?T5EV52fEksRy67KSjw7wLdpPz0dR9aKroPNOLYuF8PJL?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9eb3ec-110f-49f0-8df9-08dbea17d90f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2023 22:27:14.9717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yoEczyARbVl5rr05gRa/O477bIdgjRc946/kGbq/DCr+iDGBPgvrMZb5gsNzZCnDmr4ri2+beawNyfk8twrDnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7120
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: rcdn-core-12.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU3VuZGF5LCBOb3ZlbWJlciAxOSwgMjAyMyAxMTo1MCBQTSwgSGFubmVzIFJlaW5lY2tlIDxo
YXJlQHN1c2UuZGU+IHdyb3RlOg0KPiBTZWVtcyB0aGF0ICdibGtfcXVldWVfZW50ZXIoKScgY2Fs
bGVkIGZyb20gc2NzaV9hbGxvY19yZXF1ZXN0KCkgaXMNCj4gZmFpbGluZywgcHJlc3VtYWJseSBh
cyB0aGUgcXVldWUgaXMgZnJvemVuL3F1aWVzY2VkLg0KPiBDYW4geW91IHRyeSB3aXRoIHRoZSBh
dHRhY2hlZCBwYXRjaCBpbnN0ZWFkIG9mIHRoZSBwcmV2aW91cyBkZWJ1ZyBwYXRjaD8NCj4NCj4g
T24sIGFuZCBpbmNpZGVudGFsbHk6IHRoZXJlJ3MgYW4gdW5sb2NrIG1pc3Npbmc6DQo+DQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX3Njc2kuYyBiL2RyaXZlcnMvc2NzaS9m
bmljL2ZuaWNfc2NzaS5jDQo+IGluZGV4IDAyNzhjNGEyMDdmMy4uNDdiY2M2YmQ3Mzc2IDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX3Njc2kuYw0KPiArKysgYi9kcml2ZXJz
L3Njc2kvZm5pYy9mbmljX3Njc2kuYw0KPiBAQCAtMjIzMyw4ICsyMjMzLDEwIEBAIGludCBmbmlj
X2RldmljZV9yZXNldChzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpDQo+IGlvX2xvY2sgPSBmbmlj
X2lvX2xvY2tfaGFzaChmbmljLCBzYyk7DQo+IHNwaW5fbG9ja19pcnFzYXZlKGlvX2xvY2ssIGZs
YWdzKTsNCj4gaW9fcmVxID0gZm5pY19wcml2KHNjKS0+aW9fcmVxOw0KPiAtICAgICAgIGlmIChp
b19yZXEpDQo+ICsgICAgICAgaWYgKGlvX3JlcSkgew0KPiArICAgICAgICAgICAgICAgc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZShpb19sb2NrLCBmbGFncyk7DQo+IGdvdG8gZm5pY19kZXZpY2VfcmVz
ZXRfZW5kOw0KPiArICAgICAgIH0NCj4NCj4gaW9fcmVxID0gbWVtcG9vbF9hbGxvYyhmbmljLT5p
b19yZXFfcG9vbCwgR0ZQX0FUT01JQyk7DQo+IGlmICghaW9fcmVxKSB7DQo+DQo+IE1heWJlIGZv
bGQgaXQgaW4gd2l0aCB5b3VyIHBhdGNoc2V0IChpZiBpdCdzIG5vdCBhbHJlYWR5IG1lcmdlZCku
DQo+DQoNClRoYW5rcyBIYW5uZXMuIEkndmUgbW9kaWZpZWQgdGhlIGNvZGUgYmFzZWQgb24geW91
ciBwYXRjaC4gSGVyZSdzIHRoZSByZXBybyBsb2c6DQoNCk5vdiAyMCAxMzo1OTowMSByaGVsLWM0
czUga2VybmVsOiBmbmljPDc+OiBVVDogZm5pY19mY3Bpb19pY21uZF9jbXBsX2hhbmRsZXI6IDg0
NzogdGFnOiAweGYgc2M6IDAwMDAwMDAwZDBiYzYwMTQgQ0RCIE9wY29kZTogMHgyOCBEcm9wcGlu
ZyBpY21uZCBjb21wbGV0aW9uDQpOb3YgMjAgMTM6NTk6MzEgcmhlbC1jNHM1IGtlcm5lbDogc2Nz
aSBob3N0NzogQWJvcnQgQ21kIGNhbGxlZCBGQ0lEIDB4NTIwNjFiLCBMVU4gMHgyIFRBRyBmIGZs
YWdzIDMNCk5vdiAyMCAxMzo1OTozMSByaGVsLWM0czUga2VybmVsOiBzY3NpIGhvc3Q3OiBDQkQg
T3Bjb2RlOiAyOCBBYm9ydCBpc3N1ZWQgdGltZTogMzAwMjkgbXNlYw0KTm92IDIwIDEzOjU5OjMx
IHJoZWwtYzRzNSBrZXJuZWw6IHNjc2kgaG9zdDc6IGZuaWM8Nz46IFVUOiBmbmljX2ZjcGlvX2l0
bWZfY21wbF9oYW5kbGVyOiAxMTEzOiB0YWc6IDB4ZiBzYzogMDAgc3RhdHVzOiBGQ1BJT19JT19O
T1RfRk9VTkQgRHJvcHBpbmcgYWJvcnQgY29tcGxldGlvbg0KTm92IDIwIDEzOjU5OjUzIHJoZWwt
YzRzNSBrZXJuZWw6IHNjc2kgaG9zdDc6IFJldHVybmluZyBmcm9tIGFib3J0IGNtZCB0eXBlIDIg
RkFJTEVEDQpOb3YgMjAgMTM6NTk6NTMgcmhlbC1jNHM1IGtlcm5lbDogc2NzaSBob3N0NzogRGV2
aWNlIHJlc2V0IGNhbGxlZCBGQ0lEIDB4NTIwNjFiLCBMVU4gMHgyIHNjOiAwMDAwMDAwMGQwYmM2
MDE0DQpOb3YgMjAgMTM6NTk6NTMgcmhlbC1jNHM1IGtlcm5lbDogc2NzaSBob3N0NzogRGV2aWNl
IHJlc2V0IGFsbG9jYXRpb24gZmFpbGVkIChlcnJvciAtMTEpDQpOb3YgMjAgMTM6NTk6NTMgcmhl
bC1jNHM1IGtlcm5lbDogc2NzaSBob3N0NzogZm5pY19yZXNldCBjYWxsZWQNCk5vdiAyMCAxMzo1
OTo1MyByaGVsLWM0czUga2VybmVsOiBzY3NpIGhvc3Q3OiBmbmljX3Jwb3J0X2V4Y2hfcmVzZXQg
Y2FsbGVkIHBvcnRpZCAweGZmZmZmYw0KTm92IDIwIDEzOjU5OjUzIHJoZWwtYzRzNSBrZXJuZWw6
IHNjc2kgaG9zdDc6IGZuaWNfcnBvcnRfZXhjaF9yZXNldCBjYWxsZWQgcG9ydGlkIDB4NTIwNjFi
DQpOb3YgMjAgMTM6NTk6NTMgcmhlbC1jNHM1IGtlcm5lbDogc2NzaSBob3N0NzogZm5pY19ycG9y
dF9leGNoX3Jlc2V0IGNhbGxlZCBwb3J0aWQgMHg1MjA1ZjINCk5vdiAyMCAxMzo1OTo1MyByaGVs
LWM0czUga2VybmVsOiBzY3NpIGhvc3Q3OiBmbmljX3Jwb3J0X2V4Y2hfcmVzZXQgY2FsbGVkIHBv
cnRpZCAweDUyMDVjYg0KTm92IDIwIDEzOjU5OjUzIHJoZWwtYzRzNSBrZXJuZWw6IHNjc2kgaG9z
dDc6IGZuaWNfcnBvcnRfZXhjaF9yZXNldCBjYWxsZWQgcG9ydGlkIDB4NTIwNWNhDQpOb3YgMjAg
MTM6NTk6NTMgcmhlbC1jNHM1IGtlcm5lbDogc2NzaSBob3N0NzogdXBkYXRlX21hYyAwMDoyNTpi
NTpjYzphYTowMA0KTm92IDIwIDEzOjU5OjUzIHJoZWwtYzRzNSBrZXJuZWw6IHNjc2kgaG9zdDc6
IElzc3VlZCBmdyByZXNldA0KTm92IDIwIDEzOjU5OjUzIHJoZWwtYzRzNSBrZXJuZWw6IHNjc2kg
aG9zdDc6IHNldCBwb3J0X2lkIDAgZnAgMDAwMDAwMDAwMDAwMDAwMA0KTm92IDIwIDEzOjU5OjUz
IHJoZWwtYzRzNSBrZXJuZWw6IHNjc2kgaG9zdDc6IFJldHVybmluZyBmcm9tIGZuaWMgcmVzZXQg
U1VDQ0VTUw0KTm92IDIwIDEzOjU5OjUzIHJoZWwtYzRzNSBrZXJuZWw6IHNjc2kgaG9zdDc6IGZu
aWNfcnBvcnRfZXhjaF9yZXNldCBjYWxsZWQgcG9ydGlkIDB4ZmZmZmZjDQpOb3YgMjAgMTM6NTk6
NTMgcmhlbC1jNHM1IGtlcm5lbDogc2NzaSBob3N0NzogZm5pY19jbGVhbnVwX2lvOiB0YWc6MHhm
IDogc2M6MHgwMDAwMDAwMGQwYmM2MDE0IGR1cmF0aW9uID0gNTIwODkgRElEX1RSQU5TUE9SVF9E
SVNSVVBURUQNCk5vdiAyMCAxMzo1OTo1MyByaGVsLWM0czUga2VybmVsOiBzY3NpIGhvc3Q3OiBD
YWxsaW5nIGRvbmUgZm9yIElPIG5vdCBpc3N1ZWQgdG8gZnc6IHRhZzoweGYgc2M6MHgwMDAwMDAw
MGQwYmM2MDE0DQpOb3YgMjAgMTM6NTk6NTMgcmhlbC1jNHM1IGtlcm5lbDogc2NzaSBob3N0Nzog
cmVzZXQgY21wbCBzdWNjZXNzDQpOb3YgMjAgMTM6NTk6NTMgcmhlbC1jNHM1IGtlcm5lbDogc2Nz
aSBob3N0NzogZm5pY19ycG9ydF9leGNoX3Jlc2V0IGNhbGxlZCBwb3J0aWQgMHg1MjA2MWINCk5v
diAyMCAxMzo1OTo1MyByaGVsLWM0czUga2VybmVsOiBzY3NpIGhvc3Q3OiBmbmljX3Jwb3J0X2V4
Y2hfcmVzZXQgY2FsbGVkIHBvcnRpZCAweDUyMDVmMg0KTm92IDIwIDEzOjU5OjUzIHJoZWwtYzRz
NSBrZXJuZWw6IHNjc2kgaG9zdDc6IGZuaWNfcnBvcnRfZXhjaF9yZXNldCBjYWxsZWQgcG9ydGlk
IDB4NTIwNWNiDQpOb3YgMjAgMTM6NTk6NTMgcmhlbC1jNHM1IGtlcm5lbDogc2NzaSBob3N0Nzog
Zm5pY19ycG9ydF9leGNoX3Jlc2V0IGNhbGxlZCBwb3J0aWQgMHg1MjA1Y2ENCk5vdiAyMCAxMzo1
OTo1NSByaGVsLWM0czUga2VybmVsOiBob3N0NzogQXNzaWduZWQgUG9ydCBJRCAwZDA4ODANCk5v
diAyMCAxMzo1OTo1NSByaGVsLWM0czUga2VybmVsOiBzY3NpIGhvc3Q3OiBzZXQgcG9ydF9pZCBk
MDg4MCBmcCAwMDAwMDAwMGExYzQ1M2I5DQpOb3YgMjAgMTM6NTk6NTUgcmhlbC1jNHM1IGtlcm5l
bDogc2NzaSBob3N0NzogdXBkYXRlX21hYyAwZTpmYzowMDowZDowODo4MA0KTm92IDIwIDEzOjU5
OjU1IHJoZWwtYzRzNSBrZXJuZWw6IHNjc2kgaG9zdDc6IEZMT0dJIHJlZyBpc3N1ZWQgZmNpZCBk
MDg4MCBtYXAgMCBkZXN0IDhjOjYwOjRmOjk1OmVhOmE0DQpOb3YgMjAgMTM6NTk6NTUgcmhlbC1j
NHM1IGtlcm5lbDogc2NzaSBob3N0NzogZmxvZyByZWcgc3VjY2VlZGVkDQpOb3YgMjAgMTQ6MDA6
MDYgcmhlbC1jNHM1IGtlcm5lbDogc2QgNzowOjM6MjogUG93ZXItb24gb3IgZGV2aWNlIHJlc2V0
IG9jY3VycmVkDQpOb3YgMjAgMTQ6MDA6MDYgcmhlbC1jNHM1IGtlcm5lbDogc2QgNzowOjM6Mjog
YWx1YTogdHJhbnNpdGlvbiB0aW1lb3V0IHNldCB0byAxMjAgc2Vjb25kcw0KTm92IDIwIDE0OjAw
OjA2IHJoZWwtYzRzNSBrZXJuZWw6IHNkIDc6MDozOjI6IGFsdWE6IHBvcnQgZ3JvdXAgM2U5IHN0
YXRlIEEgbm9uLXByZWZlcnJlZCBzdXBwb3J0cyBUb2xVc05BDQoNClRoaXMgaXMgd2hhdCB0aGUg
Y29kZSBsb29rcyBsaWtlIGZvciB0aGUgYWJvdmUgdGVzdDoNCg0KICAgICAgICByZXEgPSBzY3Np
X2FsbG9jX3JlcXVlc3Qoc2Rldi0+cmVxdWVzdF9xdWV1ZSwgUkVRX09QX0RSVl9JTiwNCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIEJMS19NUV9SRVFfTk9XQUlUIHwgQkxLX01RX1JF
UV9QTSk7DQogICAgaWYgKElTX0VSUihyZXEpKSB7DQogICAgICAgICAgICAgICAgLyoNCiAgICAg
ICAgICAgICAgICAgKiBSZXF1ZXN0IGFsbG9jYXRpb24gbWlnaHQgZmFpbCwgaW5kaWNhdGluZyB0
aGF0DQogICAgICAgICAgICAgICAgICogYWxsIHRhZ3MgYXJlIGJ1c3kuDQogICAgICAgICAgICAg
ICAgICogQnV0IGRldmljZSByZXNldCB3aWxsIGJlIGNhbGxlZCBvbmx5IGZyb20gd2l0aGluDQog
ICAgICAgICAgICAgICAgICogU0NTSSBFSCwgYXQgd2hpY2ggdGltZSBhbGwgSS9PIGlzIHN0b3Bw
ZWQuIFNvIHRoZQ0KICAgICAgICAgICAgICAgICAqIG9ubHkgYWN0aXZlIHRhZ3Mgd291bGQgYmUg
Zm9yIGZhaWxlZCBJL08sIGJ1dA0KICAgICAgICAgICAgICAgICAqIHdoZW4gYWxsIEkvTyBpcyBm
YWlsZWQgaXQnbGwgYmUgYmV0dGVyIHRvIGVzY2FsYXRlDQogICAgICAgICAgICAgICAgICogdG8g
aG9zdCByZXNldCBhbnl3YXkuDQogICAgICAgICAgICAgICAgICovDQogICAgICAgICAgICAgICAg
Rk5JQ19TQ1NJX0RCRyhLRVJOX0VSUiwgZm5pYy0+bHBvcnQtPmhvc3QsDQogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAiRGV2aWNlIHJlc2V0IGFsbG9jYXRpb24gZmFpbGVkIChlcnJvciAl
bGQlcyVzKVxuIiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBUUl9FUlIocmVxKSwN
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNkZXYtPnJlcXVlc3RfcXVldWUtPm1xX2Zy
ZWV6ZV9kZXB0aCA/ICIsZnJvemVuIiA6ICIiLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgc2Rldi0+cXVpZXNjZWRfYnkgPyAiLHF1aWVzY2VkIiA6ICIiKTsNCiAgICAgICAgICAgICAg
ICByZXR1cm4gcmV0Ow0KICAgICAgICB9DQogICAgICAgIHNjID0gYmxrX21xX3JxX3RvX3BkdShy
ZXEpOw0KDQogICAgICAgIHRhZyA9IHJlcS0+dGFnOw0KICAgICAgICBpb19sb2NrID0gZm5pY19p
b19sb2NrX2hhc2goZm5pYywgc2MpOw0KICAgICAgICBzcGluX2xvY2tfaXJxc2F2ZShpb19sb2Nr
LCBmbGFncyk7DQogICAgICAgIGlvX3JlcSA9IGZuaWNfcHJpdihzYyktPmlvX3JlcTsNCiAgICAg
ICAgaWYgKGlvX3JlcSkgew0KICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShpb19s
b2NrLCBmbGFncyk7DQogICAgICAgICAgICAgICAgZ290byBmbmljX2RldmljZV9yZXNldF9lbmQ7
DQogICAgICAgIH0NCg0KUmVnYXJkcywNCkthcmFuDQo=
