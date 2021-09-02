Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54A1C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 06:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A310E60FC0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 06:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241969AbhIBGrV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 02:47:21 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44547 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241474AbhIBGrU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 02:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630565183; x=1662101183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bJiVsCt4Hg/7t87yShMNlj3WZ9SJSoBBRBKsTfsJPVw=;
  b=Fb+CMrg+dcuADJLQ21uzQBs3OUJpouCNtn331qD3PNh1SHXM+xh6/G/e
   c3JZCIF/44gI/W3oOOK2lvMLgFAjAi7fqMyDtORozC7vt9t9qCyX9idjW
   8tcHwsA8cdhgXwPr+PFhK8/3QelOqd/RxBatziy0OdILDOTantUeJakaR
   uVaJP1fEUjOYUJDBWgDcrRHUdeEG3a5uTCgjsdgQjDzCCQoQx8NOz7kcX
   oHlVnCQCV2G1bLLE8iSISOljDLjEZz1gPVxnZCUGe26Sb9RLUloHzBsBG
   SAtXbAIFusInbOeQrGZiNH54If7Tp0EefuftuVLQoTqo61beohRkZkirG
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,371,1620662400"; 
   d="scan'208";a="179564117"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 02 Sep 2021 14:46:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMqFLiDmZBAawq/YrFSqZE8CmwHSRnLqKwXqn+85sCUoKq+Kcz+0H03DjzQLZzS23/qDjM3nw8OnF8bgdKCXHXZFbNUm3t3L3V9Nhj+BidvhqCUPCZjecgDwXhp1Bff4dJl0SLyY8HbOP9WI+jCqq0pzQYTx4edMIiigIVguwFuDA9vtSs5ojyqF5Opi/fkTDg4vdQ1LHTnpoDQDl58mjIkK0hOJFNlQNGZrD6+zRVFNOuUnXaK9IxMkdwfkXz4FeCnqCriEklU+4bleGH6KwW8yf9zyRTEZQAiojlgvoDp0qeLT+ntqfzTuj6TGvosS9XBCxFu3c8n+V5vmtG7D8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJiVsCt4Hg/7t87yShMNlj3WZ9SJSoBBRBKsTfsJPVw=;
 b=AE321HCkhzHFtjGliwhS6ae0tUZ6/RWRVSw4PekKnMQdjDT9I3uwQLmECgz3yckISkoHnmaniMedDmilHuo/LqMMHA/QMWO+ssJHw+tj4iWKbns2a9XM4hA9quuFrPLClC8p2zLMsgtGptIBjIhlvOkRVWrZ6tcXIqE3i8Lhdd3y1vQDG7Mv+XGs+oinCQzBOHJvzi9in0zMr1K+Khlojg197KBnwUvkiYwAn4qNV3lb3TC+lCcM5fbDPTDSwF9+Xw6pWi0aXke+CaQXk6SlKpQMGa6L0NgNUHfqc+MA83BUEe5usve3e73oWFnMaRu1kYlIMeVdxysspsZKcDD4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJiVsCt4Hg/7t87yShMNlj3WZ9SJSoBBRBKsTfsJPVw=;
 b=fpKVk1CPukF+FgVsxdkcZa3KnbhXrohIKPTsJzXWj6ZtS92q+/QyaD/lcFhWxjjGpsEIxtnFQl6V8OgnG4TR18hQSksIDTcYdhpkdVnQD/8wrucmrm72mpg5iuwIPpsQjwcBxZU6tzElRN/Q/xDzVL3PR49EQS1H7f7LNylc7qM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6589.namprd04.prod.outlook.com (2603:10b6:5:1ba::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.23; Thu, 2 Sep 2021 06:46:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86%7]) with mapi id 15.20.4457.024; Thu, 2 Sep 2021
 06:46:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH 2/3] scsi: ufs: Add temperature notification exception
 handling
Thread-Topic: [PATCH 2/3] scsi: ufs: Add temperature notification exception
 handling
Thread-Index: AQHXny5LrHCoKD9xLk6N4oKh+hjCxKuPYYIAgAAyrYCAALYbYA==
Date:   Thu, 2 Sep 2021 06:46:20 +0000
Message-ID: <DM6PR04MB6575469BB1401DA5D43CA790FCCE9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
 <20210901123707.5014-3-avri.altman@wdc.com>
 <46a7ea4f-2c6b-7798-5845-ad47c64617dd@acm.org>
 <49a3985a-4d4d-006a-499e-2270bd7db250@codeaurora.org>
In-Reply-To: <49a3985a-4d4d-006a-499e-2270bd7db250@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce66ee0a-2129-4bac-6cdb-08d96ddd5f6f
x-ms-traffictypediagnostic: DM6PR04MB6589:
x-microsoft-antispam-prvs: <DM6PR04MB65897401B1F7888788D51298FCCE9@DM6PR04MB6589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IfUdTuCzo+RBWTnwGA+tTvO1aUIUmZKZtcb09I4vmrfww1irL4iSV+p8LbSa+eKMf0RMh/+qTVcUp+Fz9uSKe3We2q75vAtG4z9+mC4q3VEZUh+YIC6y6yNkEMHtUj3ZB4+YVxu+mUuDV4cOlqX3rlykRbVhyIQVPshW8U5s/PgKqvE7XYmoLEYy30kn4f2eWBP5hLYwDdca439CTTPraZBTnaZoARSHXuZQFKUjxstOG42VJlkd0WejTHhOwyOsaEqIVLTgjifDUXo2r597PwvVGBgs47e7GQF7jyoiMO7YVTnfAL3908/ba2wgpwWeqMUMhIo8El+DrLigGC6VUn9JWBYRkCJdvt5mLYCMxC+dwpE5kN0/E4LuMqr+zzwLmECWd6Nd6za2lcgFnivR38fcZy5Hzdd/l5I6oF4UTyHbRqhovH4t3ivo+GZL4rA6uLJGCUyJvFEmx/8paoQHwCnFJ+jbKTznxWW8RmFjAFkyA6QbUIWE4kEjTmhqHgazTZ1lu2NR5jAy9/Mrjh8tZBo7kPpSz1oD8ZKb/gYOL1N8DqFxe4wmqqQw3rMzXmem5bcvt4rMRzBNvebZY/Nipn6Q4hOiDO+BquQ+sVuXVTgoffhzgP3zi/Exajj9GUO0Q+iSFL5ZRon+gXiBanTedjTF3EvJ9PKzsum8n59vJXABb86rXZE0KuCejgRR+o4K3i1GNgcXU9n5uoTE20alXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(478600001)(52536014)(64756008)(186003)(66556008)(122000001)(66476007)(66446008)(86362001)(38100700002)(316002)(2906002)(9686003)(33656002)(6506007)(110136005)(38070700005)(4326008)(7696005)(5660300002)(8936002)(66946007)(54906003)(55016002)(71200400001)(53546011)(26005)(76116006)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEU5QnZ1dkdUaDRQVk1jamprYUx3dDRLRE1DVHh3bURKRzdSbUg4MlRWLzdn?=
 =?utf-8?B?UkI1aGlSK0gvY2NkK3hIZUZzTHNXMnc5RlFsaDlJT2hCcDFSTDBMVGRKaHo0?=
 =?utf-8?B?V1FDY1NjdGF4OGtNQStkTm80UWx2VVk1b3pnTjlnU21Mb2FsTytUcFZaSCs2?=
 =?utf-8?B?cFJmbHJuK2tEYlloU0Q5RmtPdk5IL2syanhBbVY3N3lXWHhWL3AxMnlMcmVF?=
 =?utf-8?B?cUk2U0U1TitCNnA5aTBQWlAwQkVBMUo0SHBldlQyWUhLckFlUHpxSXZGUVZj?=
 =?utf-8?B?MS8yUHBZemIraUtZdGdDdG5TOG9ZcEl1TEppdXBtZmdnaW9KcnNSYWxXUkV5?=
 =?utf-8?B?cG95TXdudnY4YjRhUGMzY3VmZkxXWlUwc0dadFN6SmlOcHhvbkNYV1dDaUVa?=
 =?utf-8?B?NW9zYmNKNzJCeDR6dHBvU05ka3c1ZXFldjlOU1AybTVEc1R6dWJiUFRIMWg5?=
 =?utf-8?B?WFd1VFVCZU4xN1JEWjdrek4wWUdHQU1JVUQyY0hkQ1pidUxpdnQrdmZpUnQz?=
 =?utf-8?B?aVpiV2NFK1lKdmExSWVNbGpTSjJ0cnlRY1FVd1Nyb1RsekxwaGdYcGRlbGNQ?=
 =?utf-8?B?aDFQd0lYZk43Y0ZjU3d4d2VHRXZYeUhQS2xaWm43ZFNrbVZpMGZSRDhNdi9X?=
 =?utf-8?B?d0dlWjZtMVFZNjZRQWl5endReDI1SXBEVUhGZ0RIQ2tmdjdkT0x1bm1RTHFP?=
 =?utf-8?B?aVZJWHVMaFpVSG9aSWpZU3I4Z2JiWjhMUTErdm9wa1I3VGJRZ2xqbzVMV09W?=
 =?utf-8?B?bURIZXk4VkxsZzVYNlYwdnJYanU5NWNyQndJaUh6NFkvOEVqTXE0VGM4cllo?=
 =?utf-8?B?UnI3U29FVjNyeWxLK0xBVjV0VkVwZlJjc1pmK0QxL09wNW85TmdKeTRVTmlk?=
 =?utf-8?B?U25TVDUzRDJKSGxxYWtielRMRWMrVFcyc3Vpby9vVXlIMzJ3Uk01a2tQVGw1?=
 =?utf-8?B?V2tESG9aTjZmdGxOK0FGeXFZWlArSTVnOGFhWGV6cGUvWnpNNThubzdZL1VH?=
 =?utf-8?B?Q1k5RlZiem5rVjBoTldtNVd0T0pGWkVMMG4zMDQ1YmtUZm9FOW5pbU52ZDZL?=
 =?utf-8?B?eWUvNHRVbnFvZnNVL29aOUpzWE9IZWhHOVRrQWJsYVhKY0RXdXRkdFR1Z2JO?=
 =?utf-8?B?QVROREJJQ2oxR2Nlb0lOL0FuTm4wZEYrWUMvc1EyeUlmV2xhcXVLN09EOHc4?=
 =?utf-8?B?bk5uNlFCL2NOb2FXS3RveUVQMHhLQnFnYTBNdUhLZmI3OHFGOEZtNm9GUHlQ?=
 =?utf-8?B?RzVYMWdPdXBHbnRyNjlMWHBLZi9XSHpnTDRrS1RUNFpRMXAzbmF6ek9RTVBK?=
 =?utf-8?B?b1V2VGYyUlM4MW83NFZncFhnaXQzaERpTlVGTGtZWm5zdW1SelIreUE3R2FM?=
 =?utf-8?B?YXA0Y2JBaTNxZllhT2lMdkExdWVGSUlWd052YTVpbkl5SUI2VFZ1bWZmZTdR?=
 =?utf-8?B?RFhJcUtuVWE0WDFNYmlZWkZ4Q2RuSEV6WmxLdzNJcmtsbm5CbUk1bHZMN0Fk?=
 =?utf-8?B?dm1XYVdzUkR1K3ZpdVMzSUoyZGpYR2pVbldyeHFEQWdTNUpPMDlWRklWT3hO?=
 =?utf-8?B?RkhxL1pPOWVnVGthMXdoV0p4SjVickp3bXl5eTE3UWJaajlkSWNKcGtXNk5r?=
 =?utf-8?B?N1N6WmdzTVpiMW94cENoR3lVYzBVVlpCUWZuQlo3ZDgvT1BGa0hyRzQ1Qkdh?=
 =?utf-8?B?L09lZkJwTHl0WGs1bTZIQ2JnYUJmWFNEc25yRjM0SjcvWHEwUnk3QUVzZkhy?=
 =?utf-8?Q?gRUspCGqkAlsoODhVQ4FdhmdDmXqFjzYLyj0ub+?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce66ee0a-2129-4bac-6cdb-08d96ddd5f6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 06:46:20.4609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4XNfHQkkqQVw2XYhe9o7/q2KWjoLYTE6dUI2kM0i2OxvpFeuDTp9iDm6XU96/5yzCCOVQhP9kadynZzfggtMSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6589
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiA5LzEvMjAyMSA5OjM5IEFNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gT24gOS8x
LzIxIDU6MzcgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+PiBJdCBpcyBlc3NlbnRpYWxseSB1
cCB0byB0aGUgcGxhdGZvcm0gdG8gZGVjaWRlIHdoYXQgZnVydGhlciBhY3Rpb25zIG5lZWQNCj4g
Pj4gdG8gYmUgdGFrZW4uIFNvIGFkZCBhIGRlc2lnbmF0ZWQgdm9wIGZvciB0aGF0LiAgRWFjaCBj
aGlwc2V0IHZlbmRvciBjYW4NCj4gPj4gZGVjaWRlIGlmIGl0IHdhbnRzIHRvIHVzZSB0aGUgdGhl
cm1hbCBzdWJzeXN0ZW0sIGh3IG1vbml0b3IsIG9yIHNvbWUNCj4gPj4gUHJpdmV0IGltcGxlbWVu
dGF0aW9uLg0KPiA+DQo+ID4gV2h5IHRvIG1ha2UgY2hpcHNldCB2ZW5kb3JzIGRlZmluZSB3aGF0
IHRvIGRvIGluIGNhc2Ugb2YgZXh0cmVtZQ0KPiA+IHRlbXBlcmF0dXJlcz8gSSdkIHByZWZlciBh
IHNpbmdsZSBpbXBsZW1lbnRhdGlvbiBpbiB1ZnNoY2QuYyBpbnN0ZWFkIG9mDQo+ID4gbWFraW5n
IGVhY2ggdmVuZG9yIGNvbWUgdXAgd2l0aCBhIGRpZmZlcmVudCBpbXBsZW1lbnRhdGlvbi4NClRo
ZSBzdG9yYWdlIGRldmljZSBpcyBtZXJlbHkgYWN0aW5nIGFzIGEgdGVtcGVyYXR1cmUgc2Vuc29y
Lg0KVGhpcyBpbmZvLCBqb2ludGx5IHdpdGggb3RoZXIgdGVtcGVyYXR1cmUgc2Vuc29ycyBvZiB0
aGUgc3lzdGVtLA0KU2hvdWxkIGJlIHVzZWQgZWxzZXdoZXJlIGluIGEgbXVjaCBicm9hZGVyIHNj
b3BlIC0gcHJvYmFibHkgYnkgQW5kcm9pZC4NCkVpdGhlciB3YXksIHVmc2hjZCBpcyBoYXJkbHkg
dGhlIHBsYWNlIGZvciB0aG9zZSBkZWNpc2lvbnMuDQoNCj4gPg0KPiBJIHRoaW5rIGl0IHNob3Vs
ZCBiZSBlaXRoZXIgaS5lLiBpZiBhIHZlbmRvciBzcGVjaWZpYyBpbXBsZW1lbnRhdGlvbiBpcw0K
PiBkZWZpbmVkIHVzZSB0aGF0IGVsc2UgdXNlIHRoZSBnZW5lcmljIGltcGxlbWVudGF0aW9uIGlu
IHVmc2hjZC4NCj4gVGhlcmUgbWF5IGJlIGEgYnVuY2ggb2YgdGhpbmdzIHRoYXQgZWFjaCB2ZW5k
b3IgbWF5IG5lZWQvd2FudCBkbw0KPiBkZXBlbmRpbmcgdXBvbiB1c2UtY2FzZSwgSSBpbWFnaW5l
Lg0KSSBhZ3JlZSwgYW5kIHRoaXMgaXMgd2h5IEkgd2FudGVkIHRvIGFsbG93IHRoYXQgdGhhdCBm
bGV4aWJpbGl0eS4NCkJ1dCBJIGdldCBCYXJ0J3MgcG9pbnQuIEkgd2lsbCByZWdpc3RlciB0aGUg
c2Vuc29yIGluIHNvbWUgc3Vic3lzdGVtLg0KSXQgc2hvdWxkIGFsbG93IHRoZSByZXF1aXJlZCBk
ZWdyZWVzIG9mIGZyZWVkb20uDQoNClRoYW5rcywNCkF2cmkNCj4gDQo+ID4+ICsgICAgdm9pZCAg
ICAoKnRlbXBfbm90aWZ5KShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MTYgc3RhdHVzKTsNCj4gPg0K
PiA+IFBsZWFzZSBkbyBub3QgYWRkIG5ldyB2b3BzIHdpdGhvdXQgYWRkaW5nIGF0IGxlYXN0IG9u
ZSBpbXBsZW1lbnRhdGlvbiBvZg0KPiA+IHRoYXQgdm9wLg0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+
DQo+ID4gQmFydC4NCj4gDQo+IA0KPiAtLQ0KPiBUaGUgUXVhbGNvbW0gSW5ub3ZhdGlvbiBDZW50
ZXIsIEluYy4gaXMgYSBtZW1iZXIgb2YgdGhlIENvZGUgQXVyb3JhIEZvcnVtLA0KPiBMaW51eCBG
b3VuZGF0aW9uIENvbGxhYm9yYXRpdmUgUHJvamVjdA0K
