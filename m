Return-Path: <SRS0=2jUW=7T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67CDC433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 12:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B11502073E
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 12:11:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ieOHWAP3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SjvXsn5y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgFFMLy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Jun 2020 08:11:54 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37876 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgFFMLx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jun 2020 08:11:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591445514; x=1622981514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0UvpaTggVviL7Y6cQfkAGJSoSMX4omv7poMYlsyuAo4=;
  b=ieOHWAP3kezAR9/Yf8UzxSQmebGjrPH/iB+RAHRgB7Px71UAL5p8ARwQ
   tyXgdFleKmRji9Dm2dWFh34QNfJ+Vz5udPYri4oZ93hsMTiu8aJVDviue
   vlZlOBGtVYDju9FFVGrhYRQRJU0zAFFu/CDaC48PC6yKdowZnqxN0ya02
   F8pH/Yb/D40qJLyc1v2v8P/k3xQqoRwxkDC7NEignGgjGEzHl/Muje4c/
   N9TZPXMB3bTHgwBvhXMtHkEAJsEEexlLGSjGvQLVrjzDByGHDqET9jtsM
   13FaL6ypO023tgkLAaTcPPzgPdUsZDNhIysXYvhFu5rUrvntSkgtA+SeS
   w==;
IronPort-SDR: TS/VTXzrgpseGsusLkHf1o7uk39aPc4GexORT3SiwH/g4SSjMlBOzA1rjJUkD0Ea6rL/4mQn38
 c/8re5B3l8M3bNlo4JluJ9DxZQcy5mQnyaoDRP66QlvlBvJYEWpqQh5GEJMkiRn7v6EqBb5wxX
 RNKDhfonO92/wJX+qF197QCRGbkn+cJ8WuSnAigNKP3lzwvHLD8nOxKQaWaeKPHkOnDUFN2Hlz
 JIe4gQTvIH3cBgIG5fHL9bODm86Pabr0r6oLqiHlxBJfvadLEpfxUnl4X3fxt4Sjqd5wu1aPj2
 O2w=
X-IronPort-AV: E=Sophos;i="5.73,480,1583164800"; 
   d="scan'208";a="139658213"
Received: from mail-sn1nam04lp2052.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.52])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jun 2020 20:11:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdGSnzbLMFcCH3amsyaUgskaApEh/3NbFJYqP4kgyroaBKIATGOyaUHIMvPyw4E+WRbx9GNhowgZn4dMJSlAaqmh9UetoHZV9mgoVLXrzaB90IxA2NkOuWbE0UdbRRHWpbribGAeNmjFCQ0kN1CsV0GooNAp0H3Wn7uPjr9t4OmoUtPjAOaohBuw2MVDwms6xj3TrcWRQUpgo/7mXxXdkmBPDq3FsCSZNmw9nkjIir2BdYeN03RXDSk1TGfvnYRGX7ajLZGTVYBMaKc7H/m1rDVftDbFv6uhwi3YwoVcjLK55zn31KEMnvHBA3tHEoHPGrBqcb0KCGQgxhROferB7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UvpaTggVviL7Y6cQfkAGJSoSMX4omv7poMYlsyuAo4=;
 b=Tuux+VDr8YiHaAPwY9Z21gjirMjfQUGb+JBpptOYz7JSxoAZuIUPSKvkLHJ5WA7z63+XP1o6uF8JQxN7T/87vtYH+MD4JbLIekKmZLHFSpLoUlXXq7UTgWqIjw8fqBvn7R2ZkknXpDpDAoeun3UT6i09lSlX8VRSJnTud3jcn4jDM/f/Jt0N/NDipJfdBldvM7LxP9Ez8/Er2L9byUBM/VWwRJKWCRK2VAQycuXAnMZ1SI6m2V2rhAZTQggbrPT6iav02CsPn4K/sSs/7OejkKDt4CsxPRpwFdq1kqGRqXmfnsSwgTHSqOBlVS5O0miQMDcPBCOHeAxlwQM/FWfkLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UvpaTggVviL7Y6cQfkAGJSoSMX4omv7poMYlsyuAo4=;
 b=SjvXsn5yUSNqBAO+y87vckCWOVxCUXNHvOqOkVFWhkd+6ZMwbe+wBHdbZ82aNRagSqB85AUdKan/FiLfCws4jCQh9FdkwHq7rQi67VMCwKZvNwi399qieX/nE2OWxIHypl+p8J6Ub8J2w2oqnQth3/85SWtRQUta99iQrk1P7y8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4573.namprd04.prod.outlook.com (2603:10b6:805:ae::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Sat, 6 Jun
 2020 12:11:43 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3066.019; Sat, 6 Jun 2020
 12:11:43 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH 1/5] scsi: ufs: Add UFS feature related parameter
Thread-Topic: [RFC PATCH 1/5] scsi: ufs: Add UFS feature related parameter
Thread-Index: AQHWOtgmh/ITzF1fakK28dCo02EUzKjLgTfg
Date:   Sat, 6 Jun 2020 12:11:43 +0000
Message-ID: <SN6PR04MB46403840179D1962FCEC363BFC870@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p5>
 <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
In-Reply-To: <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3086ef1e-6372-4607-906b-08d80a12c712
x-ms-traffictypediagnostic: SN6PR04MB4573:
x-microsoft-antispam-prvs: <SN6PR04MB4573A01D1F3316FAFC48B56DFC870@SN6PR04MB4573.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 04267075BD
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M3egWuiqd11OgIn9IrcA+bgSpuy/pBG/mO6cOJeiu5DoQ8sluGh8FlewbX5xZefFaKqjwMFrfXyCgLAJEcGNlAwEnYyFSJG2usIAjmf4uriJ1ICSO0fe/+z8yqMhYdv1ohZDPy7xRToW+F+fW7SZutoy2lbr+pB8CRP0jeQsIfu5Is4lejrvChb88SgiYO0lvTc3PuMNF0zDJHLp+QIJWeWPCL29pCvXvjWrGn6thaaKjFZ6CpTIpBsJIJRRczJmwerm5vdIuffRs9RpR9LkRQUxeAakuQUu908Ji5pMN9aLZ7mytBqe+mMd+AHx1F8+DswJOnAP56EfIZXajlas4GGSjeLFUHcgxJg11fRLVhr/cxPF+zhorJD5A92Me+Np
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(55016002)(9686003)(4744005)(26005)(86362001)(2906002)(7416002)(7696005)(6506007)(4326008)(186003)(66946007)(71200400001)(110136005)(76116006)(66476007)(66556008)(478600001)(5660300002)(64756008)(66446008)(52536014)(33656002)(54906003)(316002)(8936002)(8676002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: hRuhswzILQNSCBrm1ySpv7/E9yJR/ytEyDCvsYTEx7IRRevtvMlPmwI4hC7KFbuKethaqeBdUbjvN54YRRTSGpNINKgb5/4ANHjMwes22v3nTbmawCR052XF1OM8jO39H3Kg1kfNr83F4aGznLtZMzHZ46rWBSfCPeTlOVahHf4VybnAL5SbmOBW6bC8CqSJ4VkntYV/0FFiKG794bdXWQZSpw4TKvKRxiX/iKgnbDhN2ApIvhMuru7w6lgD+EpVg8mCkWmYisrVY4BQnFqWwGEIEEDtnA4NVMV0IvKTM64LXHAQ+AWYgnjOLNVbIr87RyvjANvZqNid+Kv/4lRajQkPaqc46MUne2GFUG6LoZXsTcqBS6LwIK9N4vuRXKG0qGro4kEYHc9H1DlfO84k6wlgWCs64lMBLfVgEAOAxNFpN2V4O5dOsG1PifvUDikqvI8WY8yO3dukWc0Qp2GxdVFTvIxK/63M0oDSPDaSTds=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3086ef1e-6372-4607-906b-08d80a12c712
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2020 12:11:43.7557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cYjXx3uDnWd5HpV0rzJBLvRNYp/+H6BJHyqcREkRxAnSP582t+NywIGLTzdshDny9Mof5SDSclH/3g/ZBSqI+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4573
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpPTUVUUllfREVTQ19QQVJBTV9FTk00X0NBUF9BREpfRkNUUiAgID0gMHg0MiwNCj4gICAgICAg
ICBHRU9NRVRSWV9ERVNDX1BBUkFNX09QVF9MT0dfQkxLX1NJWkUgICAgPSAweDQ0LA0KPiArICAg
ICAgIEdFT01FVFJZX0RFU0NfSFBCX1JFR0lPTl9TSVpFICAgICAgICAgICA9IDB4NDgsDQo+ICsg
ICAgICAgR0VPTUVUUllfREVTQ19IUEJfTlVNQkVSX0xVICAgICAgICAgICAgID0gMHg0OSwNCj4g
KyAgICAgICBHRU9NRVRSWV9ERVNDX0hQQl9TVUJSRUdJT05fU0laRSAgICAgICAgPSAweDRBLA0K
PiArICAgICAgIEdFT01FVFJZX0RFU0NfSFBCX0RFVklDRV9NQVhfQUNUSVZFX1JFR0lPTlMgICAg
ID0gMHg0QiwNCj4gICAgICAgICBHRU9NRVRSWV9ERVNDX1BBUkFNX1dCX01BWF9BTExPQ19VTklU
UyAgPSAweDRGLA0KPiAgICAgICAgIEdFT01FVFJZX0RFU0NfUEFSQU1fV0JfTUFYX1dCX0xVTlMg
ICAgICA9IDB4NTMsDQo+ICAgICAgICAgR0VPTUVUUllfREVTQ19QQVJBTV9XQl9CVUZGX0NBUF9B
REogICAgID0gMHg1NCwNCg0KTWF5YmUgYWxzbyBhZGQgYml0NyB0byB0aGUgZW51bSBvZiBkRXh0
ZW5kZWRVRlNGZWF0dXJlc1N1cHBvcnQgPw0KDQo+IEBAIC01NzEsNiArNTgxLDcgQEAgc3RydWN0
IHVmc19kZXZfaW5mbyB7DQo+ICAgICAgICAgdTggKm1vZGVsOw0KPiAgICAgICAgIHUxNiB3c3Bl
Y3ZlcnNpb247DQo+ICAgICAgICAgdTMyIGNsa19nYXRpbmdfd2FpdF91czsNCj4gKyAgICAgICB1
OCBiX3Vmc19mZWF0dXJlX3N1cDsNCj4gICAgICAgICB1MzIgZF9leHRfdWZzX2ZlYXR1cmVfc3Vw
Ow0KPiAgICAgICAgIHU4IGJfd2JfYnVmZmVyX3R5cGU7DQo+ICAgICAgICAgdTMyIGRfd2JfYWxs
b2NfdW5pdHM7DQo+IC0tDQo+IDIuMTcuMQ0K
