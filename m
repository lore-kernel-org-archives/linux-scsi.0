Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4B9C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 19:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbjKFTmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 14:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjKFTma (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 14:42:30 -0500
Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445BD98
        for <linux-scsi@vger.kernel.org>; Mon,  6 Nov 2023 11:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=646; q=dns/txt; s=iport;
  t=1699299748; x=1700509348;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ygpxHS6pogonwBMSl13h/VkcCjVwcWvd43jm/jobWzI=;
  b=aFuCJ2mGnENywjvbk6gqE0YilDS/7Qz5WvG5e76MRGwQPHkUgh/FHgX4
   UmK4J+fN+b8F602tYsA12G52KlK4wY30JyRAXHs/Ty6XB7AWyHChZotk4
   GBsmSjLIEtyA7hLS0/x0ZYGzjTqdy/6mENuzynYZ27gfr79MbkA+JLcRd
   U=;
X-CSE-ConnectionGUID: nCYnZrlVTb6WURRf+tSceA==
X-CSE-MsgGUID: 9qcZKjLwTXSfATYThaFcVw==
X-IPAS-Result: =?us-ascii?q?A0A/AABtQEllmJ1dJa1aHQEBAQEJARIBBQUBQCWBFggBC?=
 =?us-ascii?q?wGBZlJ4WyoSSIgeA4ROX4hlnX4UgREDVg8BAQENAQFEBAEBhQYChyYCJjQJD?=
 =?us-ascii?q?gECAgIBAQEBAwIDAQEBAQEBAQIBAQUBAQECAQcEFAEBAQEBAQEBHhkFEA4nh?=
 =?us-ascii?q?WgNhkwBAQEBAxIoBgEBNwEPAgEIDgoeEDIlAgQBDQUIGoJcgl8DAaBSAYFAA?=
 =?us-ascii?q?oooeIE0gQGCCQEBBgQFsmwJgUgBiAkBhVGENScbgg2BV4JoPoJhAoFHG4QSg?=
 =?us-ascii?q?i+JLgcygiKDVI0IgQAEQ3AbAwcDgQAQKwcEMBsHBgkULSMGUQQoJAkTEj4Eg?=
 =?us-ascii?q?WOBUQqBAj8PDhGCPyICBzY2GUiCWAkVDDVKdhAqBBQXgREEagUYFR43ERIFE?=
 =?us-ascii?q?g0DCHYdAhEjPAMFAwQzChINCyEFFEMDQgZJCwMCGgUDAwSBNgUNHgIQGgYNJ?=
 =?us-ascii?q?wMDE00CEBQDOwMDBgMLMQMwVUQMUANsHzYJPA8MHwIbHg0nKAI1QwMRBRICG?=
 =?us-ascii?q?AMWA0QdQAMLbT01FBsFBGRZBaEQgQuCSYEDlUWufAqEDKE/F4NuphKHbJBSI?=
 =?us-ascii?q?KgIAgQCBAUCDgEBBoFjOoFbcBWDIlIZD44gGYNfj3l2OwIHCwEBAwmLSgEB?=
IronPort-PHdr: A9a23:k54opxwfCjTL1mjXCzMRngc9DxPP8539OgoTr50/hK0LK+Ko/o/pO
 wrU4vA+xFPKXICO8/tfkKKWqKHvX2Uc/IyM+G4Pap1CVhIJyI0WkgUsDdTDCBjTJ//xZCt8F
 8NHBxd+53/uCUFOA47lYkHK5Hi77DocABL6YAl8PPj0HofRp8+2zOu1vZbUZlYAiD+0e7gnN
 Byttk2RrpwPnIJ4I6Atyx3E6ndJYLFQwmVlZBqfyh39/cy3upVk9kxt
IronPort-Data: A9a23:HTQRD6ieZHetN+qtcZrwQ2l0X161fxAKZh0ujC45NGQN5FlHY01je
 htvW23TM6nYa2X9LdAjOtjgoB9Uv8TXyYVhSAVornthRSJjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+1H1dOCn9CEgvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZWEULOZ82QsaDlNsvrd8EgHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 woU5Ojklo9x105F5uKNyt4XQGVTKlLhFVTmZk5tZkSXqkMqShrefUoMHKF0hU9/011llj3qo
 TlHncTYpQwBZsUglAmBOvVVO3kWAEFIxFPICX6UgMqh1Un4T3Gy/MhUNk91IbYT988iVAmi9
 dRAQNwMRgqIi+Tzy7WhR6wywM8iN8LseogYvxmMzxmAUq1gGs+FEv6MvIIHtNszrpgm8fL2Z
 MMDdTtrZRfoaBxUMVBRA5U79AutriCkKmIJ9wnM9cLb5UCC1QdD87rJL+blQdKjefRpnk+2r
 VzZqjGR7hYybYzDlmXtHmiXruvOmz7rHZkZD7yQ6PFnmhuQy3YVBRlQUkG0ycRVkWakUN5Zb
 kcT4Cdr8+459VegSZ/2WBjQTGO4UgA0XfFhFd8g7D+xwPTr3jyjCCsYdTVMQYlz3CMpfgAC2
 liMltLvIDVgtryJVH6Qnot4SxvvZ0D5ykdfNUc5oRs5D8rL+95s00qeJjp3OOvk0Y2vQGCYL
 yWi9XBm390uYdg3O7JXFG0rbhq2rZTPCwUy/AiSACSu7xhyY8iuYInABbnnARRoctrxorqp5
 SVsdy2iAAYmUcjleMulG7VlIV1Rz6zZWAAweHY2d3Xbyxyj+mS4Yadb6yxkKUFiP64sIGG4M
 RWC5F8NvM8OZBNGiJObharvU6zGKoC+TbzYugz8MrKin7AoLlbcpXEyDaJu9zq1yRZEfV4D1
 WezKJbwUily5VVPxzutTOBVyq4w2i073gvuqWPTkXyaPU6lTCfNE98taQLWBshgtfPsiFuOq
 b53aZDVoyizpcWjOEE7B6ZJcwBTRZX6bLirw/FqmhmreVE5QDhxWqCOm9vMueVNxsxoqwsBx
 VnkMmdww1vkjnqBIgKPAk2Popu2NXqjhRrX5RARAGs=
IronPort-HdrOrdr: A9a23:r11SmKwSAfhPxYY4aFlGKrPxaegkLtp133Aq2lEZdPULSL36qy
 n+ppQmPEHP6Qr5AEtQ6OxoWJPtfZvdnaQFmLX5To3SLDUO31HYYr2KjLGSjAEIfheOlNK1up
 0QDpSWZOeAamSSyPyKnjVQcOxQgeVvkprY+ds2pk0FJWoFGsQQizuRSDzrbXGeLzM2fabRYa
 DsnPav0ADQAkj/AP7LYEUtbqzonfGOvpTgZhINGh4g7yezrR7A0tTHOind9C0zFxdUz5kf0U
 WtqWHED6OY3M2T+1v57Sv+/p5WkNzuxp9oH8qXkPUYLT3ql0KBeJlhc6fqhkF3nMifrHIR1P
 XcqRYpOMp+r1nLeHuunBfr0w78lB4z9n7Zz0OCi3eLm726eNt6MbsFuWtqSGqf16MShqA77E
 uN5RPBi3NjN2KFoM063amRa/glrDvunZNoq59hs5UWa/ptVFYWl/1ewKuQe61wQR4TL+scYb
 NTJdCZ6/BMfVyAaXfF+mFp3dy3R3w2WgyLW04Yp6WuonJrdV1CvgMlLfYk7zw93YN4T4MB6/
 XPM6xumr0LRsgKbbhlDONERcesEGTCTR/FLWrXeD3cZe06EmOIr4Sy7KQ+5emsdpBNxJwumI
 7ZWFcdsWIpYUrhBcCHwZUO+BHQR2e2Wyjr16hlltVEk6y5QKCuPTyISVgoncflq/IDAtfDU/
 L2I55SC++LFxqmJW+I5XyJZ3B/EwhobCROgKdPZ7unmLO+FrHX
X-Talos-CUID: 9a23:CeChOG9meDtpwmGLfP6Vv0g/K8YXaHnj8H2OHHKCM2gqVIaeRHbFrQ==
X-Talos-MUID: 9a23:h9TwwwQjoxw2AOUkRXS9nTpQF8VM/JieM04kraQ6u8CqPhJvbmI=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 19:42:27 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id 3A6JgQ1c030201
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Mon, 6 Nov 2023 19:42:26 GMT
X-CSE-ConnectionGUID: J4X7cquoSWCSkol+4FcL+A==
X-CSE-MsgGUID: k9Dxr3hkT8eiyyH9/Dmf0A==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=quarantine dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.03,282,1694736000"; 
   d="scan'208";a="7144951"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by alln-opgw-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 19:42:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfLTgc8ciclmOgM7bAYWK7tB+hX6K76oWVgsXatZoz4n/nKr5fTG1cp+p7ky/a2R60CrMBCKhSLo+jMqJpeb7RyUvzguuL5EOaeLgvSLR/biNGvSKBb+rhpPtNH8dFEypAthOqA5VxOR9GV4vbBXqi37bSv8bSAjmF3LKJHDQsWhBVK7o+OSfksjmrVvLmRV9EL4iz25xJOBb0yuFtBHMyuA5GQPmcv3BuD/gKnmelsqVpcgBl3stcANtEzV4mMbQ6p8KpLPbccP6XS5n41X/whPoE8lahlY+1QKXhCxWyiVsUtdjy9+UWQhfsV7ozWqBaT4hxQRXnbMFwS6SG12eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygpxHS6pogonwBMSl13h/VkcCjVwcWvd43jm/jobWzI=;
 b=UXUKJHrBZ4n3dXh5Ocjvf+rXOs7f3b3FB3XS7cIfV0ajQg1PoKA/dToVZJELoT0nnB0vwI8aKQvd9cf6qcphiJ+LEXB41GnUJfqzkzoLRYPk/pL8e4540o//5IJQC5LdtRWhmYObi6XO5C63YyOtbPR5rUiKZJtFpI/26PFdkzqv6ifMYx0vVRBs/1H6MQERyT8DIPS8/v1m3o+BrNTNZrEKfNjEgL7J2FIV3O1o4V4uwxpdRPOCJjP1NQY+Ug+d0PrldxfAu/1fm8qXtpquKPhQl8EA2W+eOIbdOHTZyz1Eab9lpPCbiMS7mXAoTdGW51EOgu/gJf3KI5XF07UlBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygpxHS6pogonwBMSl13h/VkcCjVwcWvd43jm/jobWzI=;
 b=nfN3yEuaIE3HpYh/BmneXBaR5VpVw9cDn451CfftJUzJF6ug4gcZe9JYdwRYFFeKOzLD3hYAu+NINNPFZSiu2BRbDrsx8Bn1BOVURqJMnI6eBLtbdbQg9gyh8dytDLEccxnCjHhf2Ab6qerICoGmsEE5Qo+Hm3dB2a6/czQfZYQ=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH8PR11MB7023.namprd11.prod.outlook.com (2603:10b6:510:221::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.27; Mon, 6 Nov
 2023 19:42:25 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022%7]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 19:42:25 +0000
From:   "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
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
Thread-Index: AQHaBkb42cCL+heyGUeyjm7ciZVVH7BtxXAw
Date:   Mon, 6 Nov 2023 19:42:25 +0000
Message-ID: <SJ0PR11MB589682551110734A017D19C3C3AAA@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20231023091507.120828-1-hare@suse.de>
 <20231023091507.120828-14-hare@suse.de> <20231024065427.GD9847@lst.de>
In-Reply-To: <20231024065427.GD9847@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH8PR11MB7023:EE_
x-ms-office365-filtering-correlation-id: cfc9a2da-9942-4969-6088-08dbdf008076
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lihYXPSvywca1hg9O3AUVMG86chhKKnr1/tUSr3t83N1a+ELyiUQi6FwWikBzHuxS9C5Eknm3KTwDzXtmhtI8YCzWkMsoSGH7ljyhmbaEymICdAmzPBQTs+TaS4CUHTGJraw194t9C9LBAh1/XJbAHPR4AOVCiTBzOicRmg2gu8nBCHTa5VyT0dOLd6areim8fX190ESFu+zv++WpWiXgTTi3R0nas8H1kRYu/oHEI6smGo1LSXxS+wxWjFt6S9Qchx0lHpot9i6uJj5qsGx5JZsoueeXkZhqa59Mh/Ce0UwgiMhORLSBmf6yjqniDUWyLpahnBCQXRPtfo8CYwO0i5MOmt8hC6HFpX05bofp+b/s23ETZc6k2WVQ+NLuyTfgk7GFHR35azV88SBPJZbYKImakhSBoGThI3Wtczf4sG9nqpX6aVb/XEQTLBNSwyw02o8Hq6NfWkkysmGXj/Jljj4+FS0LQM0C+3Hs3WkEtraAoC4ufiUmdzhwqVJ3hSVdhJ7zzB3ArAvkbjg+5CnLeyIftK8KuFiCiD7ZSj2oJADowPBQMBisQZ0UaGhGARWjCDf8MTso5rEcGj3O92XkxzPZ8Y05J+0FRMqZHgujnrV0HexqdBgabwBj3vMADcD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(366004)(39860400002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(8676002)(122000001)(9686003)(107886003)(52536014)(5660300002)(76116006)(478600001)(66946007)(66556008)(54906003)(66446008)(66476007)(64756008)(110136005)(7696005)(316002)(38070700009)(53546011)(6506007)(71200400001)(4326008)(55016003)(2906002)(38100700002)(4744005)(33656002)(8936002)(41300700001)(86362001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Eex+mNRwRSkRJd50oOMOv/vTufHIQ0NJ59kosIjFc4tG0G0WksTBwGc4s/gx?=
 =?us-ascii?Q?TcM90xQCxA/gpOjniDeGN+ir2BTArR77uueiMzPSwZpy+KrU5ZWMdwD0aQkO?=
 =?us-ascii?Q?VO+C/WPDpaTwFFmV2WmQPSUfF5G5lMvgrF/1Pm3vkr6FCZ8lpDmS8DZVetih?=
 =?us-ascii?Q?CBnqjigbynLOMFqegHKUhe/gG1lT9UUc5KMjKRanN+6TB8u1h5hzGewq3nLS?=
 =?us-ascii?Q?QT6g/oy7XI2wHNSW0GlDWwVbYZkgnDmZSfKQ/YpnEB6bY2XDpWPUwcdofWHH?=
 =?us-ascii?Q?gLJqcraVYZshrCx8xd+hd1sUzZ7Ng9UP1psW8tv2w0sblH3xW0yKnAiS9grN?=
 =?us-ascii?Q?tv2hMqwRy4zwmVwmtokPbO7Zk/FZ1jJo4a4hSy9ZxpfNajFx7wDh5iLza8Jd?=
 =?us-ascii?Q?991iBxutwo3JC120Ig6oYcPssGHeGzrHO6MwaXi1VzSBTbD+pIrFlmRhUq3t?=
 =?us-ascii?Q?tE1tVfToWul9zKztnWRU4gN7tWV6QEyd0lzPo677FlBkxX5e7po0zWeGNy2I?=
 =?us-ascii?Q?QlH4ldxXQFGPPgL3uLfogoiszyan7zwmVctp1I4+vHrjetH6Z+JTNvqYfSiC?=
 =?us-ascii?Q?Z/kyrFUBfMxyYcWTyTvRAUO6GXBICGGRZCjSTx3BuOpM+gcUiaCaibOorU2j?=
 =?us-ascii?Q?P56qZMuXviq3GQ9IPLguTlgWvdKM1bL7ZFggXqpGmDfWKhMBsVjv/2wqltTC?=
 =?us-ascii?Q?2JmrY4aii8Jaf2qwJW28bU4oh63FabQ6VyHnq12i8Wor+5QFxehVMCxBgvjm?=
 =?us-ascii?Q?6EbD9s+7voYpBZyL8H0m3t7Q8qmPf9YKgpmnSROs+1+pFU01i1BKYUM1p9cK?=
 =?us-ascii?Q?CDATsMN7T+5V2oOMqTWh943Jf9kAv/TNxfxRnyszmAxapGxHowR4GCMLOooI?=
 =?us-ascii?Q?PiiG2drWnLDocWbM6rEZkrAkSlQF/ZVDqsfxT0DBUmSFpNqAETkqKwfcJ/rf?=
 =?us-ascii?Q?dO8D43+aUb3vHGD5wzZ7JCTkxSetu5vWQIMK5VpR/QhkH0G7oHZ07txvZcuL?=
 =?us-ascii?Q?HAoQxwUSCxc1vsM7rAR9OkET6vY6BreU/zWD6WB93jRAKuedsMgVh2o/Vx8x?=
 =?us-ascii?Q?xgtEEICK770mx5LeY5YCbE4F/O93Q+n1uWN3nMkCIsByzMQKNiMXgW38Ambm?=
 =?us-ascii?Q?MxJWr8vj0fD1JIIqoV6C65k+yrNHbO5n+zey5c2NX2Ap/SIElUQGi7j+3zvG?=
 =?us-ascii?Q?WYVbXZnuGvLX+wYFDBW+IRyq5gKx84slCUOuOOa5v+fLqCw61OkR1P9mGFnL?=
 =?us-ascii?Q?8hkHLAGSy4Sev9YwCq9hgoa3O8cx4/8yuthm1Z74BOegV7GTKE5z1HrLOrSK?=
 =?us-ascii?Q?NjQ2RBU0mnGfSaHi+ZkxIpwGms4xd9Oxhk/kx7fDgOdDmUB/6ZUFh8OHDIl+?=
 =?us-ascii?Q?4p+gY56uQQOXAuiylsaR7+r79uonQA+4SfHGST78uif3BduJRgOFDfl9on6B?=
 =?us-ascii?Q?wyh0JVEAyamYtGHsSghAj9/psK1lzP/IdclRoNbA0nTFtyY7cIN7cPt+kjkR?=
 =?us-ascii?Q?ySQ0B2ox7NHR7L3mnU4u7is6sde5qjVYoo0AbIUePJg8H39vI75pxYYsaPpi?=
 =?us-ascii?Q?LGoXwqK09W1fXVYvRYZB2apogMDTOSk4WbftzgsBmuDbHYaWnfYT0nvJLwKo?=
 =?us-ascii?Q?hCaowHWTuSKgWGH0OduSyx0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc9a2da-9942-4969-6088-08dbdf008076
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2023 19:42:25.0771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RYId6jszD6nbiBCkri/c/Rpt+xRo+Zv1ZfWM+qCShxqfPeC2zPg+2zHni9wnbfDmN5MwryNqTahvtQr1rSV/xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7023
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: rcdn-core-6.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Monday, October 23, 2023 11:54 PM, Christoph Hellwig <hch@lst.de> wrote:
>
> Adding the fnic maintainers as they are probably most qualified to review=
 and test this.
>
> On Mon, Oct 23, 2023 at 11:15:04AM +0200, Hannes Reinecke wrote:
> > Allocate a reset command on the fly instead of relying on using the
> > command which triggered the device failure.
> > This might fail if all available tags are busy, but in that case it'll
> > be safer to fall back to host reset anyway.
> >

Thanks for this fix, Hannes.
I'm working on integrating these changes and testing them.=20
I'll get back to you about this.

Regards,
Karan
