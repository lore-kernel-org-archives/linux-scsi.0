Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548C2C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 02:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjKNC3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 21:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjKNC3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 21:29:34 -0500
Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6A6198
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 18:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1377; q=dns/txt; s=iport;
  t=1699928971; x=1701138571;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rHQ/IQlrT2RGBCK2cFgqVnseLfnCVCm0uqZYO0Zjy94=;
  b=fYFS5hKdcH26K8VwIEOsAk+JfUmxWozcKQmZyK3j2EIFBfPJBKff827G
   J4/2C4BDmyPAjzBvYkPvrR0H4ZWIaciBLWG7SvVdZWsPVZM1RhST+zTfw
   1NEpp+nyEsFXyPyH58teAf+7VCky0oKp8/cbQgCA48QWCDnJDsgnc2fm3
   s=;
X-CSE-ConnectionGUID: 0KoCyIXESiaOqq85vhpVzg==
X-CSE-MsgGUID: j29yTx5HQ5uZcSuipnLWaA==
X-IPAS-Result: =?us-ascii?q?A0AoAAD42lJlmJJdJa1aHQEBAQEJARIBBQUBQCWBFggBC?=
 =?us-ascii?q?wGBZlJ4WyoSSIgeA4ROX4hmnX4UgREDVg8BAQENAQFEBAEBhQYChygCJjQJD?=
 =?us-ascii?q?gECAgIBAQEBAwIDAQEBAQEBAQIBAQUBAQECAQcEFAEBAQEBAQEBHhkFDhAnh?=
 =?us-ascii?q?WgNhkUBAQEBAxIoBgEBNwEPAgEIDgodARAyJQIEAQ0FCBqCXoJfAwGhMgGBQ?=
 =?us-ascii?q?AKKKHiBNIEBggkBAQYEBbJtCYFIAYgMAYVVhDUnG4INgVeCaD6CYQKBRxuEE?=
 =?us-ascii?q?oIviSMHMoIig1KNWX8EQ3AdAwcDfw8rBwQwGwcGCRQtIwZRBCgkCRMSPgSBY?=
 =?us-ascii?q?YFRCn8/Dw4Rgj8iAgc2NhlIgl4VDDVKdhAqBBQXgRIEagUWFR43ERIFEg0DC?=
 =?us-ascii?q?HQdAhEjPAMFAwQzChINCyEFFEIDRQZJCwMCGgUDAwSBNgUNHgIQGgYNJwMDE?=
 =?us-ascii?q?00CEBQDOwMDBgMLMQMwVUQMUANrHzYJPA8MHwIbHg0nKAIyQwMRBRICFgMkG?=
 =?us-ascii?q?QQ6IwNEHUADC209NRQbBQRkWQWhVAiBA4JJgQOVRa58CoQNoT8XqgOHbZBSI?=
 =?us-ascii?q?KgIAgQCBAUCDgEBBoFjOoFbcBWDIlIZD44gGYNfj3l2OwIHCwEBAwmKYQEB?=
IronPort-PHdr: A9a23:bj80NhFZnYaqqdDx4GMjep1Gfu4Y04WdBeZdwoAsh7QLdbys4NG+e
 kfe/v5qylTOWNaT5/FFjr/Ourv7ESwb4JmHuWwfapEESRIfiMsXkgBhSM6IAEH2NrjrOgQxH
 d9JUxlu+HToeVNNFpPGbkbJ6ma38SZUHxz+MQRvIeGgGYfIk8Wz3uOa8JzIaAIOjz24Mvt+K
 RysplDJv9INyct6f78swwHApGdJfekeyWJzcFSUmRu9rsvl9594+CMWsPUkn/M=
IronPort-Data: A9a23:AamfaqlWGsZHwtmw9UhypNLo5gyzJkRdPkR7XQ2eYbSJt1+Wr1Gzt
 xIZXjuOafeIZWr2KIp2bt/i90gDsJGGmNRhSAU9riA9EVtH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaB4E/rav649SUUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+5a31GONgWYuaTtNsvnb8nuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSq
 zHrlezREsvxpn/BO/v9+lrJWhRiro36YWBivkFrt52K2XCukMCdPpETb5LwYW8P49mAcksYJ
 N9l7fRcQi9xVkHAdXh0vxRwS0lD0aN6FLDveVu4mt2y/2D9cnLL2uw+UV82JbMK9bMiaY1O3
 aRwxDEldBuPgae9x6i2D7A0wM8iN8LseogYvxmMzxmAUq1gGs+FEv6MvIMGtNszrpgm8fL2Z
 MMDdTtrZRfoaBxUMVBRA5U79AutriCkLGYC+QPM+sLb5UDRll1g7KiwEOOIZ+6BfthUhkC8m
 WvvqjGR7hYybYzDlmXtHmiXruvOmz7rHZkZD7yQ6PFnmhuQy3YVBRlQUkG0ycRVkWakUN5Zb
 kcT4Cdr9PB0/02wRd67VBq9yJKZgvICc4JzFMYryTGg8avdxB+AVjUaTiZ/etNz4afaWgcW/
 lOOmtroAxlmv7uUVW+R+9+oQdWaZHV9wYgqOHJscOcV3zXwiNpp306QFL6PBIbw34OqQWuvq
 9yfhHJm74j/m/LnwElSEbrvuTOnppHTQhUy4G07tUr6s1spPeZJi2FUgGU3AN5aJ4qfC1KGp
 nVBwpDY5+EVBpbLnyuIKAnsIF1Lz6jfWNE/qQcyd3XEy9hL0yL4FWy3yG0mTHqFyu5eJVfUj
 Lb74Gu9HqN7MnqwdrNQaImsEcksxqWIPY27B6GFNoIUOcguLV7vEMRSiai4gTiFfK8Ez/lXB
 HtnWZrE4YsyUP4+l2PmG4/xL5dxmH9mrY8seXwL5033jeXBDJJkYbwEK1CJJvso97+JpR69z
 jqsH5Xi9vmra8WnOnO/2ddKdTgidCFnbbio8JY/XrDYfWJb9JQJVqW5LUUJIdI1xsy4V47go
 xmAZ6Ov4AOm3iKecF7VNi0LhXGGdc8XkE/X9BcEZD6A83Mieo2oqqwYcvMKkXMProSPEdYco
 yE5Rvi9
IronPort-HdrOrdr: A9a23:ySbAhKi42ZEjFQVZkjFXIQC+zHBQX5923DAbv31ZSRFFG/FwyP
 re/8jzhCWVtN9OYhAdcIi7Sdi9qBPnmaKc4eEqTM6ftXrdyRuVxeZZnMXfKlzbamLDH4tmpM
 VdmsdFeaDN5DRB/KHHCUyDYqgdKbq8geGVbIXlvgtQpGhRAskKgXYde2Km+w9NNXZ77PECZe
 KhD7981kCdkAMsH7+G7xc+Lo7+juyOvqjLJTQBABkq4hSPizSH1J7WeiLz4j4uFxl07fMH62
 bqryzVj5/Pjxi88HDh/l6Wy64TtMrqy9NFCsDJoNMSMC/QhgGhY5kkc6GevRguydvfq2oCoZ
 3pmVMNLs5z43TeciWeuh32wTTt1z4o9jvL1UKYu33+usb0LQhKSfapxLgpNycx2XBQ++2U45
 g7mV5xcKAnVC8oqR6No+QgkSsaznZc70BSytL7xEYvIrf2IIUh37D3unklUKvp2EnBmd0a+C
 4ENrCH2N9GNVyddHzXpW9p3ZilWWkyBA6PRgwYttWSyCU+pgEy86I0/r1Wop47zuN3d7BUo+
 Dfdqh4nrBHScEbKap7GecaWMOyTmjAWwjFPm6eKUnuUPhvAQOAl7fnpLEuoO26cp0By5U/3J
 zHTVNDrGY3P0bjE9eH0pFH+g3EBG+9QTPuwMdD4IURgMyweJP7dSmYDFw+mcqppPsSRsXdRv
 aoIZpTR+TuKGP/cLw5ljEWm6MiX0X2fPdlzerTAWj+1/4jAreawtDmTA==
X-Talos-CUID: 9a23:AAnPjW71oi69eU5hQtssrG0TMdEEQlDmzX73OlboVHhpUIOHRgrF
X-Talos-MUID: =?us-ascii?q?9a23=3AYiXzBw07P86Z7TcHlYcU4YsdiDUj4f7/GXwdzLU?=
 =?us-ascii?q?/5tS2PhdtOi+bqAu+a9py?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-core-10.cisco.com ([173.37.93.146])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 02:29:30 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
        by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id 3AE2TUDp017725
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2023 02:29:30 GMT
X-CSE-ConnectionGUID: 5+Ki8/cNTxOzBAktuJrn0A==
X-CSE-MsgGUID: pQk/t/pHT0uen0bQyXkftw==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=quarantine dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.03,299,1694736000"; 
   d="scan'208";a="7967326"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 02:29:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXdl8+Yt7yMrubCzZOf4esXeDqQjlWoWuZrOndgcYd/CYrsnRIbQpVC5f+WMZvDWiYFeb0r0Lh1GAII0DWM52Mf015/i9N4Sn+LcbbKKj6cqL/NvfSwfAcyjw9EgH4AyZl9c0ZG0tej+Vh9U9zktZMUC70KQyL5qbkjELQQ58EVuaMAFgvuqRW05WKBWmWZV4iLcjEl4h7N/TCdgXMtgdGjvLfYft6KO+BjUOOkUgSJSG6/d17DhCwxNTVsdBFjE2oTytorIYeDE7awmv9zJJ8pXDn8aw7nPNFIbVr8tRml+ZCr5MoPo8Lsv+YHF4zOHd19MGMygttPXeulB9+bX0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHQ/IQlrT2RGBCK2cFgqVnseLfnCVCm0uqZYO0Zjy94=;
 b=LuFrNwPeqse/r98SRblRPqqwpaX2LGFlRfsJCA+pRwO6ztU1WNKVDenK77PgDpjzIucLYgqeIuR+d1qnz7HoN0mfoAEm5oqYDBHJqBh5WgSjUKcsvigcISqpqpDu9XzJk+s2Jn+OOGOydoKCSxmumETs6lmMSRkR9nCaPsD7Bh8RUDGT8dUhAwJMmBpg3p6p662DnKEqap7swlcpntV0MExoPnxmydPgf8Je7tpvVwOYhI1l2b21dNgkiD7lMrpxexaQYIjAs21l2pjW5UtyBlql+IvbZ/egOSs/jFRNES8myDUMRJZNVgyDrbS69LD5TrJACbi/JxCHQMAjYmuzcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHQ/IQlrT2RGBCK2cFgqVnseLfnCVCm0uqZYO0Zjy94=;
 b=SSyPGmViYFXJrDL8KexLiUepQcVcNjPiecGxVGhLt46NBlKZ8OMlMGJALXaweueF0R46lsQrZSJK1uqI2++NrY9IsO33d1jCWrEp/wM620z0kNj1DgVJVoQfCYQrIh8V2MWpaW5knI0LwnLOSGwNUZNvp8ajyHjOmO7tFIFPhSs=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 02:29:28 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::24ee:3bbf:e40:6022%7]) with mapi id 15.20.6977.028; Tue, 14 Nov 2023
 02:29:28 +0000
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
Thread-Index: AQHaBkb42cCL+heyGUeyjm7ciZVVH7BtxXAwgAtnMMA=
Date:   Tue, 14 Nov 2023 02:29:28 +0000
Message-ID: <SJ0PR11MB58960463A1A9D634BE8D2A62C3B2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20231023091507.120828-1-hare@suse.de>
 <20231023091507.120828-14-hare@suse.de> <20231024065427.GD9847@lst.de>
 <SJ0PR11MB589682551110734A017D19C3C3AAA@SJ0PR11MB5896.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB589682551110734A017D19C3C3AAA@SJ0PR11MB5896.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|MW4PR11MB5911:EE_
x-ms-office365-filtering-correlation-id: c69e70f7-269b-4a7e-d80e-08dbe4b986c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R74EUBZNYh5I0zRkQmk5G0LBouz6swlWTt+X7JSv1GDcRrpt4rmNshdFTKElKkH0SGgGd2uTCwoffoxJoQTGb8lbkgEsYB4mEHIVhOBCpNufQTENcQOlnBtfOfW4CI66AU3ohyu60gIvJnaOgYgLX+3JDq7wHTTcfUOv8dUE1K256IyDRW3S8eHvQVZ3p9gRFKACBqtJ0W4X6fRctJu6LJMhLM16Q0/k8PhqZXbj3yD/73X4bUdIxbpsfIHRUIJudBioRUaz1xZk4WuWtf8cZ3MftpSKA5OOZyYV6pZwo1GwH6eH7WOEVDoNcLNmwG/ziZYtwa75yUPQXAYUy8AYuSc041J/BxELaXXPSEq5VnoOdtDEXR6WXTUAqv7k4s5OA5cDmjIDf1rJMG7W2DvCW1/HfLOIad0rDNz/v+WzkvBwpR3vkiIkOAli9cOuM8+EewoRWi5QMHHheMCl70riSy8xZuEKQU2re8EW9ZHRt3nBhQ/7tieft1IJwXriyqSv+ZNaao6QFca0/3VJcMzUzQhiI7nl4WxJ4izXTOc3DDiN+o4a2qGbf9QoGxBaWZtjbkDbpse80G/OPPtBZQG/XBkNYicZhhJcgacrYPCd1GFVPGKw+UXb+4P6SzOVtkQ+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(83380400001)(38070700009)(122000001)(107886003)(110136005)(478600001)(53546011)(7696005)(6506007)(71200400001)(9686003)(5660300002)(38100700002)(86362001)(52536014)(33656002)(2906002)(41300700001)(66556008)(66946007)(66446008)(76116006)(66476007)(316002)(64756008)(54906003)(8676002)(4326008)(8936002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JUBN0txjS0PMYSjbqpCPncm4muYD0HifpYMrBsZvCZAYWR4dbPeHDsq0+Hme?=
 =?us-ascii?Q?ChLBjDx5Au4rTEpbZoULTYGQ/dWvpOvT6NCIp1MyKWcKTtlhXpRzhgBZMSL2?=
 =?us-ascii?Q?NS1yCAjCP16wbTEhmltD407NrET6RDo3r9CP4K7w+JBMdtQKrR7MpGFvkFbT?=
 =?us-ascii?Q?W+3lq+p776pNlzAz9jiiRzWov62l1mWwCsZ11FuYtYpGZ2VzEA/NbypVHxqo?=
 =?us-ascii?Q?GVvgWtIGlLRGTCFNYSilHLqEFiR+kwkUgbHj5KGfyhxE2e0RmTz8B4uRFVHm?=
 =?us-ascii?Q?f0P0aJ16moCWav3OHGNozF5XB35UPj81zu0pvjrNZliip2w5Ax71LqvP0kaV?=
 =?us-ascii?Q?0TxJLQ5F4O0ZUz4myt1cpw7OsFlf3EnWRlkntUxxwYzkgXhhko4mGtiV/lAJ?=
 =?us-ascii?Q?DFiR+JLpwDkfOdbJ2ZSLa047SOgJzPvIhznw0evQJwQhOaIxmB5RzmdzY3wB?=
 =?us-ascii?Q?ZGvU3OwKgb51rTrgkyUADzCEp/Dzfa653SR12+FVDwdU6+6WZNfD6pYz/LD5?=
 =?us-ascii?Q?2d+A8Z9YHYhJu4pOKdGmMHfSUpAfmVD+WBwVwzEUUXnRUxGR6OEnb7K3w6hx?=
 =?us-ascii?Q?mV1LH5iisYzdM2CkiYCoVvhWfOvfuAZi/x3ykZpTbRXIjRRQ/own+8jajifC?=
 =?us-ascii?Q?QlVa44HwAxe/3hco0ukn9sr4Yu7JUoLfIGjaEds8aGkznpC29x3v0qUivWJP?=
 =?us-ascii?Q?k13T2ARJBB25nBvA5OeEleDv+lFmt2qzLUY0xDBCThFhfPMEQkodAY917OAX?=
 =?us-ascii?Q?qMSsU4R72LbCzFIIgqL7lpbqtfcbcvNZ48GHIQBwr4cppaq9rwqwXCZO9K0e?=
 =?us-ascii?Q?0vGJCKzTsmp/D2Tan0xh8P08ov4ZnnGITjthoZhkp877eSzKFZlXzyxJyq/6?=
 =?us-ascii?Q?lmYZ0uYPE9lL/swscv7i74tRJfXQReejOzhiBGyAyBsobhAzp/RE94zVy+46?=
 =?us-ascii?Q?ppAOMutepq1BdIAyeN79t6Oe+yFVavOawd26kkTFDiIoLWU9jLDjZe2ObuZl?=
 =?us-ascii?Q?hfr5QJmPK8QzvcDXFrP0J/9i91FOjH4P6nifQ4T/xeGWjKnD3ni1qUk946mU?=
 =?us-ascii?Q?daCJFKTpWHiHApyGrUZp6rDRG/exz3VvkKsnhW+3jeAZTOLBXS85q0C1IJRC?=
 =?us-ascii?Q?EvP/GMXN7u6lMEJhFFQvexXxt6HQbrRLdOxLMrY2X62d9wH4/qM3mFaoDvld?=
 =?us-ascii?Q?rEuTJkUCbRak4t/zdF/SwwqnsGaFipegzjZC9yDYFCfeUlJqfx14Jxj7dfI5?=
 =?us-ascii?Q?YIMg86xoFRxBtmm7/TGiaNUmmLBc0CgugoQi3fVW4um4oqmjQBV5/YGVKWfY?=
 =?us-ascii?Q?h6aebpQ/Ud8eKimFo2NI366BCCLDLNyh6JAP8E6O3I8rOXA0z7jDMDLVPsde?=
 =?us-ascii?Q?meOwEpNLEHKp0yL+R9LrHhzymwleIgiTdV21utlNxRwJs2mEADRmtju1gVmo?=
 =?us-ascii?Q?wzeNvf+ZexYqGIQ3YHxbrbp4fXlG3b2B3JwJG2TbhxZbPLER8eGtwqPG+pJ7?=
 =?us-ascii?Q?Y2LlKxOeBkGM0a+MvwOM+gSTxINHWLzZs9CMzYRuwTDwIvccNQyYF1NcJcL/?=
 =?us-ascii?Q?pv5EosCTxHp4ljMaXf4zRt0AEnxbeUKh5j+9V0AI/RAagwfw/57Q3g1Vd8p3?=
 =?us-ascii?Q?YTqif5cOaKFHHUhFgqePu90=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c69e70f7-269b-4a7e-d80e-08dbe4b986c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2023 02:29:28.4240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z+0wsw6jC7M3fV+j2r2pbhqyKLL005INKnykm6MwB5NHALcEMUbeNBk2KksinmyxPsX8tR9uy58tEVoq53u71A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: rcdn-core-10.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Monday, November 6, 2023 11:42 AM, Karan Tilak Kumar (kartilak) wrote:
>
> On Monday, October 23, 2023 11:54 PM, Christoph Hellwig <hch@lst.de> wrot=
e:
> >
> > Adding the fnic maintainers as they are probably most qualified to revi=
ew and test this.
> >
> > On Mon, Oct 23, 2023 at 11:15:04AM +0200, Hannes Reinecke wrote:
> > > Allocate a reset command on the fly instead of relying on using the
> > > command which triggered the device failure.
> > > This might fail if all available tags are busy, but in that case
> > > it'll be safer to fall back to host reset anyway.
> > >
>
> Thanks for this fix, Hannes.
> I'm working on integrating these changes and testing them.
> I'll get back to you about this.
>

I integrated your patch set using "b4 shazam" and built all the changes to =
do some dev testing.
I instrumented the code to do the following:

- After one million IOs, drop one IO response.
- This will trigger an abort. Drop that abort response.
- This will trigger a device reset. I'm seeing that the tag here is 0xFFFFF=
FFF (SCSI_NO_TAG).

This tag fails the out-of-range tag check and escalates to host reset.
I've been able to repro this three times with the same result.

The expectation with this test case is that the device reset should go thro=
ugh successfully without escalating to host reset.

Regards,
Karan
