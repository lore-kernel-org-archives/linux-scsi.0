Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF667C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A8C64EDF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhCANB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:01:58 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25745 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbhCANBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:01:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603703; x=1646139703;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=mHFBcwOrXCpADdDqBg3oQbyM2F+fZvXqhQ4XuR8mp8l7jC/e94eWFtAC
   umyQUcUXYj6K5fbuYJ1mypgkmFe16vL0WWVZGT/WhnrFSbdPZt5R4mYyt
   IgPZxOdsykfEOw7/x3GbVM7tSvQ94GdnIISAGEfPs8TPBfnkdiYlMZyzR
   cvhUuS4Yq2sXpp2LbmQsLb6GKu1gEx9YEq1hhMOHLNCgqO2ZVln4Lu20x
   w1ru2q2Sgg0FXBPbOhm331nWHvEpjiYG+dLMYQ5XY2xUGZNrCo+ud+88h
   Tcoi40BtHaV56xedY3Musz7A6NZFWh4b0ALDnUKNT6nqrmpCgoiglQi2S
   A==;
IronPort-SDR: nXkgqClGQ3KBzdqAOqNZlCSpJePAQj7wcuReKZquEd/jyihRA8RkyK1a2hw/p+UggvFGUEY+Zo
 xGOvDJ3x1/gIM/IWBPVPv1Kr+uC4p8ztXwGqpntWv3zay1rtb1mO23a5lSE92Ae/a+egFuYlIE
 lnutVPExMV3OycTas47lGbObhJlDEFxZzAQ0xh5ONpYF+dOfABS+Dlh8DL0t5tMA6e6CgGlVC3
 z5VJdbhZGLWnGKsEuNS594fLkgGmtHgBuqDoFNDiM9vSj3BFeloV7tT06UVgOZJgTThottBrN6
 Qdw=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="271660624"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:00:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKtazl76jUKjIqJCsUufygKSuYq7k0tw3MbbpZTkvQ/IcVJvf6ygh1jUKz66dKVs0uIXpTRU97//0UJR7l7ouIeI/sMXdppFt3T1kTi84GFhJlfWbLLozXNxtqXJqYlJYR4hFKYislezSMFmoDk0GN5H4vIs/JmMf6lsAFM1sx0YKmTjvl2VTl0rmNdJGRzwZhfkTkHiQOkS2rb9PNIcRZrLFr5eO1LMH+rOX5ZcSByS98Iq+u0Qyd5dDmgmcXXMDGcJGrGoa+3+PC350hHsmM/CMdMamKBRZqCI8GRf4kdced5PAM1Ck/N8Zpke6Zj4kCsKBfbSv0JnRpwvDaW+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=lQCA0j1RkS5atAkppxGpazlvfnFjXFp1eBfgndpUmUoe0TmBqOTw8mULf9Q1TQ/4TvmyQpveViyOURSOAheiSo8SxTMayTAsny6Hu5lh3ZfwS+RDOjXZDB99XszG4F5K1lqszQcN88OGpUOaa5h3XLz+AQf9UKUIMerY3dpy3PBUTPxBwJD3mn556ybeMs1XrqfLGvsLnPBXWSJb/z68/QKpcbm3SoY4wV61Dt9WPB/te4S5JPDX8EhX51b0/mTyVeOp+mmsaWHiUmDKY/7XFNEGs8b5rKk7Of/ygr+lhwl6rroSolmaECv+VETNiknfu0B4SiLq+Un4h5lQHHs72Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=K4+R9kgQQ3EZPUX55qWkK0/GPf3DqpnpVHwUW3fONkCI0ssXr16PZlsWEKXKQqYwNkk3egfpKB6R+bgOr7M/ug3D4vB9kadbxrDMFIgPgQXsfajwP2as0Y3LFsl/Tz0PKcxzfGKXtDnEAtqMG6TIQRWazxmyNQQFBSw3dpB2Ens=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7318.namprd04.prod.outlook.com (2603:10b6:510:19::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:00:36 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:00:36 +0000
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
Subject: Re: [PATCH 13/23] target/configfs: remove the memset with
 declare-init
Thread-Topic: [PATCH 13/23] target/configfs: remove the memset with
 declare-init
Thread-Index: AQHXDZcJncGrna9zskWnu+nxkUmRqg==
Date:   Mon, 1 Mar 2021 13:00:36 +0000
Message-ID: <PH0PR04MB74165F9ADC4875D9662BCC009B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-14-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 97a12d53-dd58-48c0-6963-08d8dcb201e6
x-ms-traffictypediagnostic: PH0PR04MB7318:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7318B19436C23087757558F69B9A9@PH0PR04MB7318.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ucn2NWaXAROI3Hg3U454Rh2+DUp3m062y+7XtDh4QTEYKBBdXdGj188N6UE3NbACbvvQmxzLOXf1ZxMHuLPk2z/tygubvY9oaae7gCIJSvukx9Beil+VR4a8gKCIajuVLq8/E+9wkBiSIW7mifNJH0z6RGUboBRJ0fab7yv5Z1ELndpjspRzflGX3l8REXr2ySTc4mqnZTSJpUbZADVtDGNhDKQtInTc5yDdzfQDI9vHPTIe1CjiPs2Zh9hcHpVm+s+KvWeEW9Q45dsUKgwygPRvVa3KdvN7N0vLHhLSwSmAqIwhCuyMeH2ZVim1J/TyH0A9QZ0KQf5JhtM8KFIxIZ0f42rkpxf22IqLX3+K6wAOxXdX1reHhImiOoK3xBBFkoC6r/8e+Ex2HFzg5wf5/nRnk+Slrp7G+o5j2Lnp+OXdTnfUs/fNFN5kEf4H6B1mivj2mqNVm1bgfMA0LEKH82+168PZB+zds8FaDvOjby/3XNoXBaN8e4U1QnzyFlAziKQYYpYVAJEONcq/TWiaWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(316002)(5660300002)(558084003)(52536014)(86362001)(54906003)(478600001)(71200400001)(4326008)(110136005)(66476007)(66446008)(26005)(66946007)(6506007)(55016002)(64756008)(8936002)(8676002)(19618925003)(7696005)(33656002)(4270600006)(2906002)(66556008)(76116006)(9686003)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Vly0woEFfSVH2bRF0qQJFFq/pPx51bt6w9oCYkFYsO8WauE+ENH/kUSsBSJB?=
 =?us-ascii?Q?hDEwQSKxX+7ZfPBJIGPhCF33Es6dINM0Yk86uXND5hPmi9lZSMkspUVW7saD?=
 =?us-ascii?Q?7XPK5uW5SiKfSf/IdFqNzzGUNHkkgM2jHVKrwVvFVzBp+NyVNaN6vP5lngwJ?=
 =?us-ascii?Q?RWDqLhlta0QafLPBXKKvgsL2Y/n2PEt7fCgd6L+X6SUhvpmCyL69zum90mRI?=
 =?us-ascii?Q?CtZ8VY00U5iAYtN1xz1nfl0ZFpcgAyMuhTwFMgmWRJnckMg5YxzktZnFH/wn?=
 =?us-ascii?Q?OtOSlNYwPsDZeaHEsSQSE5xx1UNS4xCc4OzMcibL65dBJ40kytmLFtoKGwRR?=
 =?us-ascii?Q?MtmnpTEZQjTCuc4E2e+KSqNgFOOsNx6IADfewBMcw1Xn5402bxL7eISS9sOV?=
 =?us-ascii?Q?Ca+tu4v+JSXIPATkjcMq+f86Ic3Pp5GNRTxJjXf0gg5IpipZq5W2iOmWsULL?=
 =?us-ascii?Q?jUcLnbenUmgqlw7V3hWgtI3OsxRy+XLwPcRl7+STVUX8AqPYOay63LQuEf2H?=
 =?us-ascii?Q?DW7IzHL9PQbrIQhCi4Vmp5ea38M5/sVvBHkMCVMVSbzDJcm8xYLjP3kQ3HAw?=
 =?us-ascii?Q?CoNCy396XqPFCSlamtlt7ap9gGtmtZ95v4J0AUoVyYNuQPIBXm0Dw7rJOwST?=
 =?us-ascii?Q?i+eVN0eAvo3afMmqzzsZqjeMD3BR1NOqr++/H7+Egb9TOfwfcNj6LB3N8iDF?=
 =?us-ascii?Q?EPIroupqouWlcZPP1GlCS7CqKozNWrTg4HYd0A1JY4OA8Get4wvlom+bFOZy?=
 =?us-ascii?Q?E+ZfXZ4x+LdeBVQOiw9FwlNIS+h1umHyT5KiYz+o+1kFESzEYLrTn1qTrgxf?=
 =?us-ascii?Q?mskSZMlPzKAnUvuyYHxu//0AawIBTlaUJ/247LL6cQpr97iUYmnb4V0ILOAG?=
 =?us-ascii?Q?YQ04Do6iPpP8wNuojMEVw1fWn+G1kSsicC037YEzNUe/q6oCK4FP3F/qG7DZ?=
 =?us-ascii?Q?K2JImL1Z6hN49GmJ5u59bd2yTIDr7DiycqH6u+jfa+fGunk+5dBy8PPymbeN?=
 =?us-ascii?Q?2AzqrHVBa1KMDkHpvCtr+xojsVVeo8OZ9q15HFXRTuKmlzeV1agc41U7pc8h?=
 =?us-ascii?Q?XbbSDsqtCfAVBDMWa7v16lD345qw1jPZwhlLqYB5ThIubavClIK0J5mdkE//?=
 =?us-ascii?Q?DfgabNKsmEBQQL0lwN8jtsNdWj060iUU47TlJODo8balqIBhkqCNu0qNGX4E?=
 =?us-ascii?Q?/jEwA9eDi+9hPeeSH4oQAdCN4VLXfU8EyG2p1ehbkLGP9dAomo0+/2bW+DmE?=
 =?us-ascii?Q?hUgqX+psZAFCOWwsQPWz6gI7qqBQPFAcC4SRI+sbGWEqnwSZrU4xFkQ2xchM?=
 =?us-ascii?Q?N2rwHhwg6wySXOosybX7li6/pKRbCPpDRTi6DCBby3P/cQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a12d53-dd58-48c0-6963-08d8dcb201e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:00:36.5937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m8c8YSRffViSbEdmT11frDa/wxZTbcfR+7AtcRK6JmGtACMNWz/ORZBXlANhsJksJZUCT8TTOe8bMTdiRr5Spf/gm5fVpnOuy5RP6VFIfvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7318
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
