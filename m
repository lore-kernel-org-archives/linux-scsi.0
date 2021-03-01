Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D84C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 10:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E49C64E10
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 10:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbhCAKm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 05:42:56 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:30777 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbhCAKmx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 05:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614596560; x=1646132560;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=rDPOl4+RvFP348YBD5mmt8kPWFWWSkvGjcq6/OlQRNDgUFgXyjaQvlH1
   nVUSv4tRr8FFvl/IwvCEpXRzR7FDJ1f6pm7Jq+2yYmZTX0zpUNEiXhwN9
   tj+JNJjzfSc8RRDU5BL6enenVE8yA/AG+ZDNnx498t4eHcGTodwBe0t5I
   2NNJuE4aRFi3IPpMtyViK/YZGlPtkDAzth86q5oYw+Nozt1/32Wb6av62
   uuermUZCTsjvd0Twxtn/7mZoJpkoBPEUaq8AVN1Vv3hAat8qm8Fj+ghbq
   YOjs92wtrUTjISD6gYd3uRCIlhihIxiE7OIQ30FPmq7WfddRh8zrU02iU
   g==;
IronPort-SDR: 2eAlnoxrZrX5rlvnTEZT1jtutNFyKsIXT+KKZR4PwSwRxU+ZJH5KnQ8ank5fkbXFL0VgygpZdP
 RXbQujHPFYv8C/4xHbHNAmelNDXmwk4UxXQaNPwdwEz+TdCDpUYf1mt84cbg856rXNTz9WDTbW
 5vgOzuSUpQ0DtOrOHCx+qc41v00ZQ18d66eC7f3SYxDfLPofTjySrbH4BU99HBZDMabBtg2L4Z
 zPU5xqg9eYydmaToFF2Uq+wFj0fB5DJhk2KR4npCjxIETYsxjU5ANlL5AuIVa7gmBQD0LOk6ID
 i5I=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="265323002"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 19:00:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nj9WusQh8iWmVSIlCCHjE9uDPrETZ0YB/hwCAOa8OcBoQIa60biWdJdBpNWHVU9UjhhG1dgI7pvec0Z3ybdbMXkzT4BdFy+9/RBPchR60lO6AEkQT+QUnVGCmYLmGL7WxvOmvwACzJptX2mnEWJo/xDr9Ij0Cit4w+aI66LZ/UQno3fbQ+jziosiDDXl/kQjwaQfxgxL+PsVmb70umLezl6pjxfge8sjsh+qE6SfDNt6SIhTHxEwEpYLBRZSuv6F36v71jDB3z/+YyY1U9hUJmdf2pvD6vizucvpsSvdpAkGzRYBN0oXkoHCUM1BQS89vfzJbO0GUo5H3vN26zj90Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=jjlAtB8H0+G+jvnyDIckifc31FSNcR4d5GzwjBRnzo+tcRoQJl6oh6eAe9pNIWXVobgLla265VVBmsKgf/eZ87/WdomGS602k9clQsGhbJpVb49WCLAY6NEUBwghGKdV+n1oxD+BerpebiAcPN30V2DqylWIyXFBS706AB0jo+rT1ACEspT0tjYhlsRJX6FFqtXIvzWdYiTbm9wpnNzCF2SYIrgDOtnOmM0PXv2tqAccDkEdh3ILFS7Svb+XWnO/cjxLNhROzSpyORDXql18ls0RynGTnEBO9Ev8kgkmRZf6JVQ1oJCANhDKdoKoJhijkELiquvR7SOdBURVcegkpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ufzINKbztLBSsUvyCdyBXEddZ0h3O/dlf++dyyt/fR7FopO/fhUYYQwU3jpqI/6WrSTyyyJgGb4zXBqnmlnURYjypGnZ4ZABUBAx7fFqlYircmGb239gNeKbC56TePgdaSM1F8Lr6pD5nSlbpjhxZqWJD0etgBn+DU+6nwvtwyA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7464.namprd04.prod.outlook.com (2603:10b6:510:15::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 10:41:39 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 10:41:39 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 02/23] target/iblock: trim down line longer than 80 char
Thread-Topic: [PATCH 02/23] target/iblock: trim down line longer than 80 char
Thread-Index: AQHXDZcC84Nq5bcEFUaSGLHEGkOraw==
Date:   Mon, 1 Mar 2021 10:41:39 +0000
Message-ID: <PH0PR04MB7416BF12F6872D937FFDBBCF9B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-3-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b442c6e1-99d2-4c81-8ebb-08d8dc9e98aa
x-ms-traffictypediagnostic: PH0PR04MB7464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7464E86C260D69139B9D68B39B9A9@PH0PR04MB7464.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tKMCNhpPhJyOXciZAKXyaYJnwEIbY7bZt5bAtgvwqqyV806++fbWUt+8D2Felo076x3rOVGoQKThlvBdSrVPmPq7oek55Bky5NV8BGRX/0vNenJEpDxDRD5QOeGcOCG1D2waz5hg6TaVfKLMXb67YW7utcLjRgw7FcdCchITRq9vdQohzLb7uJ20sO8sILQ2Tlu2lmtlYE8aA08Tn52wm8oiPTW4ThMpgsa+p9i+AetuFteOmPwkLDvFMsbXe+53MWWk8IaGNsomOyVWQNRsgB5SjFgRMG9NsKyyzjKHnBUtHlXQSyj7FamIsy/TnnxoHYJmrY+h9ty2zEpu2UQDuhbREe6KQEUIHGSNiSlB4JRXshbBLD9E/rI7UBYhUdGzgEVUTydtEWBWGdnN5RYutU7qQsyrDV6o7kR97yk8QpIlj5WqdTSBa2Hu2+JIMqU1oPap4a1uO9uljmlEx/CXsv1kyh6yoeaLVQPFz8P+DmchLSL8OYRFPCHpDDxWH/XZykBSOVitStlEacQ0sQtb3OMouIwV+5PjBiXznE194rIZta3arxMfBxY8DCE/5jzH/+Lm1T41gCBbdbE8cr/TFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(376002)(39850400004)(71200400001)(4270600006)(6506007)(52536014)(33656002)(4326008)(8936002)(8676002)(7696005)(5660300002)(2906002)(66476007)(66556008)(66946007)(64756008)(66446008)(558084003)(19618925003)(76116006)(186003)(316002)(86362001)(478600001)(91956017)(55016002)(54906003)(26005)(9686003)(110136005)(148743002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PgnCdg4xNm5ht9gVMlBbgxg7QNtxWjcAYDUuouiR01jrO1eZAXxnCi9Cfyfn?=
 =?us-ascii?Q?TddeaVgRDEEFvKD5dLuOUe3O+qA9TxNKbdywnzAfPAiGIPln4O83U9YUTP9C?=
 =?us-ascii?Q?+IIPNykj+75qHZAJUuGQov4yG+pWE5HxtrtMxdvu6MxerNyMQOwfN23DVyMf?=
 =?us-ascii?Q?u82cRIqohlYOU8QQm7l9t/Xlf0rsyMEYC5WNJ3/KKJpA2sH08Njwhj/P7rqy?=
 =?us-ascii?Q?yV6dw6LL4muhHlzCkoeiXswbrReWIL850qjjborQ+miBVJqrLsEm6pH1ShxA?=
 =?us-ascii?Q?IRMjT2tShQFC9K4oZot+sUBTJZv3QHMTP0ONP6r/77Qcjxsd17GDqkP8nN9T?=
 =?us-ascii?Q?Oqn5VEaQLXvYgUh9UtOus/yFihU90zbVcjIrQI8QegrqopXYoz2beBXEDG7f?=
 =?us-ascii?Q?uy6k9SfL0TsUwmTfOvDr0Z9661XHWJfE5wIlxQXnUPzm7MEYJVrr9LA1a6qS?=
 =?us-ascii?Q?cbWuEM9QuoaI6hn+glcKLm2oV9XZKwsQ05O+1XrNhPw1YY6JndFdhrto169t?=
 =?us-ascii?Q?aE3gKQ8YBjd0IArtCQ6OqfVXz+hikyuDVHrDlxuUgf6aJqNigoQngmV4fSfE?=
 =?us-ascii?Q?o7TM33zsQ28KBG2ytaRdzJHvHn0ZQVdggpGEKGPpfZjQkXnoQsWjjuyNZ8/j?=
 =?us-ascii?Q?vhkLaJf1lKF7XLWbuMN27q0ykxjgJKmnBT9vj5V+yjIvoWtqFCG/WfRN4n0H?=
 =?us-ascii?Q?xRk4VROsYSIiOGsqlxJ0fsGVEPNJak4XnKnuGr55M2coFbUDBg+C8ZdlHgA1?=
 =?us-ascii?Q?i3VY7e05AJbWK4RDi0oXWw0V6yvmqUYumr3HctosscDgJwL9N9YcWgVal/5n?=
 =?us-ascii?Q?fcoHOcPWqrALrHjELgYqoLmJkd2x+HO/l39VzrUP/+S2spOXBtjMkhFcBlwz?=
 =?us-ascii?Q?kYNosyj+KcTqjUgSGyiZE71HHYjFIZySj+XpgKBP6t4XUabp4FkWolBIZP/y?=
 =?us-ascii?Q?1DFuaUmgjADXWMGJhTEZI8JEDImzfJW0RjCzNLAUXCzozoTuv9g8X9U8fETA?=
 =?us-ascii?Q?wmtS3o/RG8hd059J7pu352Sxk4DxSAbDtwYWRMDvDeFlvE8gO6PCuz8FbhDp?=
 =?us-ascii?Q?dw/f67cX9CRwqmhQ+kZMj3lYxKCKTDm1sUEHGgXlrxMFBxbyPpbpsXhLRu4C?=
 =?us-ascii?Q?OfL8OHxEVyFIurl0YoRBjxUW5DDtuHGUpdgfsn51Jf949cpg0BfYUK1752ZW?=
 =?us-ascii?Q?DYXUwfMTbcxlcQFRjJEn0rbrdU6Ii4Rok8E7OLMDCpeD9/1rHmyCBT7uPy+Q?=
 =?us-ascii?Q?ua+XPH4cziak6MF0ZlO8s6GfCXkJcAKWc4PGebXPSoCv+qruJ+HzIGqN/iFT?=
 =?us-ascii?Q?ZJszStYHE/9cdA/8jKqPm/30f44McKFowZl/hK5GFnhiDA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b442c6e1-99d2-4c81-8ebb-08d8dc9e98aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 10:41:39.6287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HOnCZV1E7TxyR71Fb0NRS/EoAyVt0mLcbh6k1o8tDI7gx1HW0uWzLf1s90h9ISNsADbAYwzQEszk6QssUtIsuDvx20bLN+y8LWE0vHx0UpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7464
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
