Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EB1C11F9C
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 11:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BB7361353
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 11:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhGFLmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 07:42:42 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60645 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbhGFLbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 07:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625570922; x=1657106922;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=BMzve/VF3g1xlL+OUM2bWl+3C1jxynPH3zpF99L/FKM=;
  b=CkNW5Mr1P9K20X5SAylfRIVt9ywg3NTqFhC+ScYhkl1b/I9yAaagmme7
   8lsM/X9IlMaDs74+uLUVXw8B9/todayYAeNbKnbTF2nDNHFVkr5bYsFxd
   +158BJGqV8MV5kT+vl/7vHX2K/1YyCiTtP1TgVcjAFzzPNklRQTe3b5Sd
   nmSsmqBnc0/EpD3jgjNlWtnA4l9mr97NtMjvcfDrE2/YMCOg7iIUYLG8I
   Fo+58y6snZO8z3kgKESOmreLKLZl/OoCqH8/A7CX00YhxvqZeFL8Ub9Ac
   N/BA21jg/bfrAPsJjC2pMlNa5knFoiZ79HKe3hOkUhxDUZoi7z5gJL9Mb
   w==;
IronPort-SDR: xVgK+xeAjORznN91e47Q1Kw5vhrO6n2ufvtHjjbpL8XkRLP4jKqUZgt8hnudQeo9oVE6Fnliym
 +Sx0wp6dbj9m2kM+0V0UbUkp6zc4xuul297c2O9DG7oSYJFir8bznmGz+ySDTWWClpY+2nF9N0
 lJml6rdlRXKTe4Q2U+nMl0i8EUP6qMifpdrChJqLRyKJo6cPFmo4amhbWzLLbWx3us5ygJl2Vn
 5Ahmp+/NQNFWisCQcJe4NnTbFt54gUDzXM6LaVWSaRiIiGoLHTh3tl/CPJ/MqSEKHnIAnrvrpY
 ytc=
X-IronPort-AV: E=Sophos;i="5.83,328,1616428800"; 
   d="scan'208";a="173814170"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2021 19:28:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OesV2+kz6TeSd2VcxptrVIFKC16SXlJgtAi7SUYzXSM2BaMYi1Zs2fDn933YgEaG9ZAgfMIxwbST3GxEys0ofZ60tKp82fZy75yereECAV7pUqLVJUZKd959D/+LoJtoEuss5/vv6aM0zsYT+9BaIEKlk3IW3kFDuIMaEGdRSFgMfE6rzaPEHe3aKwbQbpDURvvgEc5B0qJW/3M9KlpMuMKFKECLeZnKjZ0v8UnYNEIBFgtQIIk2M6ex/PhJOe7b8M4xNXvLrBuJZqv1E6YiFSoSLGwkks13y/unT2BnS06VU70yZTYkJq5fPiwbY1Rk7LDax0315KLZ3zR9Y1Tc7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7uZyvCggrg88pyaKjuCRHYV+PdFh5dWoyFlY5nLYis=;
 b=PGGlUD49yD3uMOaZP6EVALNCWSF8S00POwVImXqsE60udbidvtqP6rd8H7+Y4kDSna+BwEDn/ZjjKEvi672vMJ2rQdtO1VAiyeASkNb/DDZOIRSLH/cXJT4Db7tNIOiPFrr7Lp+YtDgxpjPJcRMaYcgd85H8mJH6f0+Nmlsz5yuXp5INCzDwXW8yRnkY2AjyUklvmwe9n0LvkL/xupXJNXyMH63Ku2aXc1zTcle4pO23Go5OgTopey2L5hA3IrYDkGTEExDg5JfecFEBdvQEHf5aA7j15UMwEvAPmQJYOy/CN0Wq/RwVKpVOV3VYh09UypxP9G2LNIOGFC4kfX/97w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7uZyvCggrg88pyaKjuCRHYV+PdFh5dWoyFlY5nLYis=;
 b=GuPRQPPgz5QYkjj7cAfezWkOBroraBugoPgnYN1W/KtDu+q1HcCY529JJrDtUOwsx+UJvxCywtgxb6kUzM7yjwXVCXqWfXQGBIOzxVgyE1sE66+0HjUB9oUqyWvf9z3F44fqd9fCsezYRfWRjUtHixn1iHnLRCuJzTJMgDPUn/8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0539.namprd04.prod.outlook.com (2603:10b6:3:9e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.22; Tue, 6 Jul 2021 11:28:40 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 11:28:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH 00/21] UFS patches for kernel v5.15
Thread-Topic: [PATCH 00/21] UFS patches for kernel v5.15
Thread-Index: AddyWGA8ujAt33mZQJ6jhMRLkMu8vg==
Date:   Tue, 6 Jul 2021 11:28:40 +0000
Message-ID: <DM6PR04MB65755CE992094A6CDA56EDFDFC1B9@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90b852bc-2fb6-48ef-1166-08d9407134a1
x-ms-traffictypediagnostic: DM5PR04MB0539:
x-microsoft-antispam-prvs: <DM5PR04MB0539DFFFEE77FDEF358BCA3EFC1B9@DM5PR04MB0539.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sut5Z7z/wTWVcdtd3jsuDJ5RdAqb8A/1VFma8dXNkwfk5t2/w3EcKVaOtgcpqv5VBrlXxO9QhKcHfuelvAWMTdrN7agduUSdcOxG+mGwzxIHs4TEa3rtiptdjgM0dTY1MA4fQ5BnFm22CGtpvoIGPewkwq4MtqOXXsZuUyODnIksneRY7Hwgoqo0sSpyN2ovlrCIW6Q4GPEpu892riCPVTBehHKD9838tJ7KY+Y4cAor66gq6aSEsd2GEjfjX6h3xImOHyZfjDCRxApazyLKBDaYQ7UUHTyWMYJO/CfHEcCbTxc/JiQlrLe9i5I7PIKTjXaXhs2C3u+m5QlsIDh2FULr9Fwx9Ao8ZsaNpPinm3aw/46SdHbaB8Mc7x5UC39UULXAxgiy+YZfaBHrWjr4SoYG7e2vWKQpuc74RNl2i3UBRoEp9vxZUbcLVFUuh3vvUOPS6vYdEhCZZ4/Hm+6tGjgPUCtcWdsQ6A8gQS2cohaoe2EfblYD7UVhJoGNucUyGH268ahEVOnshPsSmLb4EGoL9IuL/KgfBCLPxoqCmSlA/IrWNtQOF3+neHTmzZBml/KqqN4JKUg7QkDp6+azcl1D+y30W7UQ50POTg1BjLbwyrMj2bCEoV/lDzVp/IQSYvupFB+5fo+Wm/IswimZjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(5660300002)(86362001)(6506007)(66556008)(54906003)(38100700002)(2906002)(66476007)(478600001)(71200400001)(7696005)(110136005)(52536014)(8936002)(122000001)(4326008)(186003)(7416002)(26005)(83380400001)(76116006)(66446008)(66946007)(64756008)(33656002)(9686003)(55016002)(316002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TGRR5JuCt5rBUInV6v4Izbx4TGe9D5GqCU1RRbxVBLOpfP2f4XAScxFqsh86?=
 =?us-ascii?Q?32lvXQ3+jHMvb/3yOeQF+8MCoA5BW3PUFMwcXo0rIycvk5YAeGen2WwpSe2u?=
 =?us-ascii?Q?7z8MkKknvtBd+NT7HT/rUyFmJXQAeRB5UdxXy65GWbZyhutmKu+ofN3QpMYf?=
 =?us-ascii?Q?VYTlzl/TdHjPgRqwwSWJTEuwLpzUuEJlsPoNsQGqIjWNXYGV4JMQwNYrEOo7?=
 =?us-ascii?Q?aaypbB/+1i5DzK55Q9es6ZrU1imrFYkgNMuOZvXlSzcYcNRnLVGMUmwYhdT4?=
 =?us-ascii?Q?bss97KQCd2rCVkj53s2ZqOYLy0zW5emPhvNAs4B4nH2e6wdeGWWwqxAnYRLQ?=
 =?us-ascii?Q?yilGFgbzOHp9UyPsiFej1CiA78pa7Sxx3esplsM0eHi3s1jMOw3f4+UNpLYw?=
 =?us-ascii?Q?hkQj9BQo27PYylT65bPcwTjdqABZmsaXc5XDhZiN4xwrRn9aDhBeua0nNUxh?=
 =?us-ascii?Q?1OJG9NJfAp6qWeBGfcViCuPTyqxtwLgJFKz49kjv9yR+OxPQilL3dKpXaOMn?=
 =?us-ascii?Q?7mgqCcBsP0v70Fk3YN+NQKsPPPkvRyaj9e5Zn4MNX0jTeYa7R2mgo2QHD925?=
 =?us-ascii?Q?mGDnc22ZebLhMbWQy7dOFnUWt1BOzzplDa7TzuSwNgnfZ+XqBiaPBhn3ub0q?=
 =?us-ascii?Q?8JL/apWqPpxfqqK2HCIGDM/fUgkn/mTrQbvx3SIV/3k0L7jdzsoC87S4yPc+?=
 =?us-ascii?Q?qZZkix3vsrae2ySsfpFkouvzNpdUWpZlqUDQWEjjE3OG8U3RwQEjJiyVJS1d?=
 =?us-ascii?Q?iEJIvc2SmBEm5E4DawxHJ09UB2e5YOkhbSTFlc9LBriEO1DdJvzGSMhHXsQt?=
 =?us-ascii?Q?STY7FhZ03Dh9kIW1G62oaFEZP0dVJ+JtFQwA/mQz3mVTv2Sku7EL85UUmqRD?=
 =?us-ascii?Q?LvCCqYkauUDJQe4jcvlgVX+mhNJLHVagpcQ/lmJqUQ8eu2X1nZngBCaiHg61?=
 =?us-ascii?Q?W+fGN48XuwKLlu/MdrspvtFUWMVCw1z6+zriPuhfOWUynadIVX/VvW3JBig0?=
 =?us-ascii?Q?WwyJnHNPbQ7skXLykwDHJL+ZhEKIcliPbzxk7Lu+ypuG+2iS5BSOT9USO63y?=
 =?us-ascii?Q?KGGaH7qsqm70JJZ6xSbppm/Ifj21NLeBguH8jjbanIsrSQ6GUBcJ+uObHlMs?=
 =?us-ascii?Q?KBQwn4Ue45eEQ2yczFAwupClyD/CCwnJhERsRSWo+68LCPCzhubkKgF4sdFg?=
 =?us-ascii?Q?iGSxIMAfz5Jla3RlN60T8I0bxCkovdT74NdcfPW61iIp00PWtT9Mzho8JumA?=
 =?us-ascii?Q?Y6ycCsepHNaSjrjvjAPjMYmBclY2gQ8JLBMPvmMjP4p/DYmo4RDLMEfqaaqj?=
 =?us-ascii?Q?r0/kqLbYzQcvlcPhD4cO2e1w?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b852bc-2fb6-48ef-1166-08d9407134a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2021 11:28:40.6854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ivLTsBzQxxXWFp8e1jUqFhREroaO9Q5EalvJ0NfAFtwWXM/W1sEY8bSIAj9mRfzkJu2VO03MTXM4/X6HcXAZBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0539
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

>Hi Martin,
>
>Please consider the patches in this series for kernel v5.15. As one can se=
e
>this patch series includes one ATA patch, four SCSI core patches and 16 UF=
S
>patches.

May I suggest to re-group the ufs part of this series so it can be reviewed=
 more effectively:
 - Cleanups (relatively simple & intuitive, so can it be picked up ?)
  ufs: Reduce power management code duplication
  ufs: Only include power management code if necessary
  ufs: Rename the second ufshcd_probe_hba() argument
  ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
  ufs: Remove ufshcd_valid_tag()
  ufs: Verify UIC locking requirements at runtime
  ufs: Improve static type checking for the host controller state
  ufs: Remove several wmb() calls
  ufs: Inline ufshcd_outstanding_req_clear()
  ufs: Rename __ufshcd_transfer_req_compl()

- Fixes of "Optimize host lock" (can those 2 be squashed ?)
  ufs: Fix a race in the completion path
  ufs: Use the doorbell register instead of the UTRLCNR register
 =20
 - Revamping ufs error handling
  ufs: Fix the SCSI abort handler
  ufs: Request sense data asynchronously
  ufs: Synchronize SCSI and UFS error handling
  ufs: Retry aborted SCSI commands instead of completing these successfully


Thanks,
Avri
