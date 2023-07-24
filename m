Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27C4EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 21:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjGXVjI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 17:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjGXVjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 17:39:07 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9380BF3
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 14:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1690234746; x=1721770746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q8W7GicPxMefvUpjPbs6KsPJDEFYtJDPI2cKdLeYiDQ=;
  b=BMmRd1usMhkmLv2izvriaLRnsbaYjUPPLNlelTCto1n2Cv/HplkGNk+z
   E+thrUHNUfVDm0cWdhUQ8hvZP8oSCBkJAbp86SV4IDBLoiiyIp8TMc4Ev
   2FPvquuDehQ3F8vO+epvPS9ilxt5as2hd/Uye5GpRy8l46DjoVKlNO3+Z
   j+3taW+x9JFmOUySNPbOfqo844UMzFe4hh3Ie1GIZKVi8Y1wYhj8czVDi
   zk2GjhukjGU/YJDp6rjTCjcrHINwf12lA3p9/lXSc2d5Qbc3oyTZdtsf4
   oDCMby4s3uxeLmv/ud1YdQHrLqmjf+VXR8TLuMyEyO4V9pmWxmQae8FKD
   w==;
X-IronPort-AV: E=Sophos;i="6.01,229,1684771200"; 
   d="scan'208";a="243604183"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2023 05:39:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSdJ5+skYAQM7bPBj2qYMDW8BFUVWNqM0+eV3l6j+3eC/apWKCocooks+PSl9LYhh9jY5kSxlNSGX30S4BfSDwGMVX+wJWCnyCcsDagq+wLcI99skib0PPIU/0mEARMEmeaKaDyalXDNqR15vvumhtRdpr4YbKw/oUDtycwlAR8NemvkEKBbe0CJuZHTu49djvllpuzGh84lHpAIfio6SgBMTnLpKAYiMIsm3g6TQofegmQebKAjIBBMJlyeVdQgKETuroY3o/IfQTTjp3ObzBxEN/xj0T4IVcu6W208u5IKDy4ogmFwW0k700P2DCUXNoumOjcri5Q/24hQChqspA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8W7GicPxMefvUpjPbs6KsPJDEFYtJDPI2cKdLeYiDQ=;
 b=QIPSzhyGqtzb8uouyNC40oMOspVEbD3oTFn1q3XgC8Rq41Qo0cHDv0oNitE/2qVDH6B+KelwiRSZkVvBRkv5n6NuBNYsn3kqOV46511gisj92FLxdMh2XcdjaOtT0+Bd8KGMMYNSEQNGGcCl5s1eoJkAs3WzHW1tTo2fHEAwFxxmy3kAQV9AVankKkhKpOl+AjtO6qlmMIJLWu61kYcwC6tlZm45z3T/az9Vehz5PEwnGg1sL3UnLw7+ldyk2mpUQ6azZ9ewxjrKxDEGBjAvrdVCX4ZbL9oxU0RTUmiHsXVPvm5YDw1aoqUnEZV4MDNt9421a467Nll2fSKpeEozBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8W7GicPxMefvUpjPbs6KsPJDEFYtJDPI2cKdLeYiDQ=;
 b=ihXsmyWhp67VnaERGdlXLednBFq6V0sRMgUA2GApddKmXcvxXVx+t7+Yks8ZrnszBGSJrXjyPkdlhx97DrmRYr3oVGp9pecvlY9D+OiFeVHSTOMRIXnxEZs7knkz/5BTcFj1jnYfBsXtFnnd0D1YWB4s45Lk/2KrKplR5E7/FcM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY5PR04MB6343.namprd04.prod.outlook.com (2603:10b6:a03:1f1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 21:39:01 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b%7]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 21:39:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>
Subject: RE: [PATCH 10/12] scsi: ufs: Remove a member variable
Thread-Topic: [PATCH 10/12] scsi: ufs: Remove a member variable
Thread-Index: AQHZvm1oL0dPssjqYEuUE6Oun6mNHq/JcWcw
Date:   Mon, 24 Jul 2023 21:39:01 +0000
Message-ID: <DM6PR04MB65750523394BD25A660E57AEFC02A@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230724202024.3379114-1-bvanassche@acm.org>
 <20230724202024.3379114-11-bvanassche@acm.org>
In-Reply-To: <20230724202024.3379114-11-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BY5PR04MB6343:EE_
x-ms-office365-filtering-correlation-id: 69f1caec-794f-410b-0037-08db8c8e651c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8qTjy70anwiQ/YavSJ+C1JFyvVUrttyYb1eMIjlKlSxp6oL2diPHuBaTmjKQhD9UCaKwP5MFd0axub6FfeBKGO3qtN2QSko8aUi9yxNDjHEWe+sDdKyV0YenXtiqPPg+vyTvsLtNjGD81ALzXbnuewu+Oc+VCj8QgJ9V4dperdYgATvQMKPY4L4/clFz82WxXaCw7k5y2H17PjwLtIki4Wah4xfh0P+SQq4HdwepIaov4UIEBQgL32CjmYeHp46nm/Sa9yknaMEIyidXEbOlVGtVMGaeL7vi0InAIJSa5gEz9uoIkZIgeXKRenaczKBdDIBwQv+z5ywIGxylitPKHcF16lLCiyxnzkcMiu10RwGrm8TXVJzfGDDbVhFB+MyZKZ/uoCSg60jkusJlO2kF0/AXytx6Q9vOyQO4rRbbaVijqZv6lNRrGoBxhhebgozLafDltktLXAwZtZYs9FQZZ7Q2Ft5MgEDV6xlK8PPShO02+BPrWo+yqMcp58Yf+cOXJPgtiVLNDn7kVQkQ6FPZwxrZpT7cBH1zSTGgNqv+ZphDwehJM441whXvlw3JGnogCLUjM2esU2VNtzfExhbSW3gDiTDF2OyiAa9FmzTTeoCEEKWoPw59Tv0EUfWiYs1Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199021)(52536014)(8676002)(8936002)(7416002)(478600001)(110136005)(4744005)(2906002)(66446008)(66476007)(66556008)(66946007)(64756008)(33656002)(4326008)(76116006)(316002)(41300700001)(55016003)(5660300002)(54906003)(38100700002)(6506007)(186003)(86362001)(26005)(122000001)(7696005)(9686003)(38070700005)(71200400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WLLjk1Ncy38eF3fyab48/mqvkv1ymKJ/HF7IV6x67DoEGX3xQDzPwzoVJwg0?=
 =?us-ascii?Q?qI7rn6KQNpd00yD51ULAlgjZF2fCwPJw4IvjHTVjYRjZKo9BwN8u/+QnZq/z?=
 =?us-ascii?Q?+8nVID+L/o9FcjYf5laZ9hStYjqeL9UYGFzMN0U6kmas25NTodb91qg2eMQA?=
 =?us-ascii?Q?yieNythkCldkfS19ZQH2xdLH2izCY+pdNfseKsndV75Rhw6+WiE0Nf/nyhNx?=
 =?us-ascii?Q?HGZf5Nj1+/IO1XFwtKPikCXGaF5JPAguZAOWYEfmQ+y4Dx+o+EAlPc9NfqSk?=
 =?us-ascii?Q?pBA5sySKqm1LQIFsZPVyoVuPqXkQ1bcr5B6hpbQSc4X1xaIGReMlF/rELIXe?=
 =?us-ascii?Q?ldagV/QwfnTl3CzQ1EsvGuqz6oAyJeamCQi4BUQxRQA6/0vKYmWV0elwuN37?=
 =?us-ascii?Q?lBAeE8MG74iJn+YV3Rp6iWtzbz6DDYS26XsG3g4WR99xF4+VN0r17uGpMgpV?=
 =?us-ascii?Q?TJK1D9776cFGQiizSm8NFI6a3Y5AQdrAGV52IwKVTxMLtdYgWr5EZmZda6gL?=
 =?us-ascii?Q?hiRzyQhViyBDgJCaOYHZUXXSJc4VDRiz89rP7bivdj1UzWmaOJLM48v5qH/G?=
 =?us-ascii?Q?HRJ0s6GL9Gd4nc1sD6bjtTKbV90D/Lu/AeL4E00YgBBtMOXW/xV6LDfCJHkN?=
 =?us-ascii?Q?0AAFd0hO6VPKbsJz8Z9y7NiQ297VCEPnO/OLZbbOWAgrig1y/58FR3dL8dTp?=
 =?us-ascii?Q?5T4QHn1hYIRB3dcbZfdoEXqAGNXrbcJKt1qUG6o8/50S8xRbXXSD86VrEWc6?=
 =?us-ascii?Q?4NfTimOsiZqNSLzOa0LlM3Yuxl20hjyfEzwb+alxgZXEn4tWdFdN805wJbd7?=
 =?us-ascii?Q?gmO1gFDIbnn9Rzrgx/RHcboz5l76eRTk8UL44Az+o7o6iWlNKINrz+z0LI97?=
 =?us-ascii?Q?e2dlA6r6Wuy8TxWy0+t6sQ9mZNWm1T7+7BKtCZ0rNX4NWfKFb1FwTJg0r8Rh?=
 =?us-ascii?Q?/ExX2RdyLtJCrsvUHgpypBBONsIENKbZmB8opzVdZtaeGW6ncGFcH6pdmglO?=
 =?us-ascii?Q?ftM4wPl7CF/huFfUTR1Wpr3AIsxwiitYkqliXpaYewdWqMPCprat4kMASyAl?=
 =?us-ascii?Q?wTmuT3yFKmzIZ0UFJgjtDAuOYA7zwq/0xkE5/4hJC5pS0crZ6lvSWqxNoMSk?=
 =?us-ascii?Q?rS7MqzmvC7ixm2cCaciHrr5RfXDVxRHdKwW2r6PoAAaCaZrssRn2eyXsM7kL?=
 =?us-ascii?Q?pDwBH7gIkWm5lwVjGqMmEhYEEcaKYyxVUIvhuD+8nHPD6yHMF4N2Z/sHCZc4?=
 =?us-ascii?Q?51/KPJA0TWdyhMBvNGQrvINiIlGPanQ6ghvNX+kQLwGE/iEWKQXrQnS1Ju0M?=
 =?us-ascii?Q?VDF/R8SzKer22wvinvTJV4Cz+7UmfdJf5/Ff8qH6/z6i33oSZwhpQQKkOLlY?=
 =?us-ascii?Q?I16rRueVamdPgDSBYa1He3dq6MKdoZPPk1T1NHquUKJ0ImobnUHecg+SQ0cy?=
 =?us-ascii?Q?JvS72/ziWAgUz6D0FyvYBKmx9GEIdmfV05KTs0tDjsZUHETPShlzdeFsputT?=
 =?us-ascii?Q?bIFSE0FnnE8S2uTWlQ+E9lRzA6BYFDptW/+cJhW/HKRA78aDFAIK3j+xJF8f?=
 =?us-ascii?Q?HIfCoEKHSos+EnQau6AdxfNFyv4ayvq8x54JaD8f?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?q9P3Zwip0DnbD0zqZlm88dBunEox2EZExoh54k2aJrVoBMOvSw6m2dKJKieQ?=
 =?us-ascii?Q?GXwL5cOMl7yLHmNaoyJddMuQsWAVJ6LMKNufgYdEXwhtQmxi5x37Ao37+O7C?=
 =?us-ascii?Q?7cjw/QDZabzZ+qqrZdHfKmoHUCQPkOaOhtwfF3nFHr8NzL98Qfy2atXbg5Tt?=
 =?us-ascii?Q?Lm1EOp69tvWgDqdASe6NgtRjyKhR6ur4Ouibh6qbIoWPMMntjm0wbIsWCoQp?=
 =?us-ascii?Q?CYOfyeZJBRTJpOtx2KtaXEvpvS4z9JOyzBUlDL7CJ6rQAOff7WuOO0vQ8Y28?=
 =?us-ascii?Q?aarR2gcjee+xuD7CbI2+NVRsPpfWw7uNi14pX8NcLBt33HtSaoCGjgpDnqjN?=
 =?us-ascii?Q?T8ZZI1u3WRPJpXUuuJcJoW8Qd0Pz27Ppas1yPH+e7t3c1Hr4r38tYpU3rySa?=
 =?us-ascii?Q?He3cU0CvKCJ348EZm9qhABctuCTQ7WPoFPYIbWp/U7WRn9/aCTRS3IMq+PB7?=
 =?us-ascii?Q?5jZHgio+20WhYdD1y57UnKiSTauua0IHk/drTxF9dUo418XT4ruIJ5l66jbf?=
 =?us-ascii?Q?4/kvw0LfSMH65XOy6NGCOD0tlrs4rZyHt2aDa2yXX1qeIHOoNAZ8+o7lIZiC?=
 =?us-ascii?Q?YI3J32nAoMOzEeftual0sF3xyB5uezFso0aaVMNoyVwNpf3i5ChJc/4LAJrz?=
 =?us-ascii?Q?xMoDiMyxpzy6PKNks1SKVdyEE7/n7yBVqiB/jef7irxdUpmKjnOrMw5EDWKf?=
 =?us-ascii?Q?ouvJ4pfG6hdtoGtSRLPKxFaOdWnNKbp8g2hXFuw0PqdMZHYtpmh+ZnDBNgVN?=
 =?us-ascii?Q?EPyzyAP22pChkeDAdQ6wyQm401PV7AWe8e42MsIKEoVZIXerLPGyM3H1g80J?=
 =?us-ascii?Q?y5yE9AjIlUenk7oX/tkNn+MoLmu7h70A78LMweU1btnOuLbt2OQ+BMLqUH2M?=
 =?us-ascii?Q?E/2scze1sdyj/aocXJUzv2uawOmGzpJbWK4Vbjq79x9jdPZy/n1DzProqPMA?=
 =?us-ascii?Q?f8FCmkgoTXrGaO04mPj+3FySb3lMp0q4Jrmu93yv7SFe3Qq2HiqtpWPhoYzO?=
 =?us-ascii?Q?X8tol+B9PM6/pUyB8JHb7pjlQrNIGzFhCBdm1JDpvDu0U9SkrfjXeSk7qosw?=
 =?us-ascii?Q?PGtmsv6JuBCcW2VuAH5aGPKqH77C9WsQa/1m1GKE1YrVSgVhaYg=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f1caec-794f-410b-0037-08db8c8e651c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 21:39:01.2131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Z+xJN1ZWQEjUpSg1Oma6Gq40I4kFIIitu1huQ4yCNwc0Hiy9EXeUhBlnG0yBlQgeRKkOQuB0Q7bsTFhYJR0Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6343
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Remove the 'response' member variable because no code reads its value.
> Additionally, move the ufs_query_req and ufs_query_res data structure
> definitions into include/ufs/ufshcd.h because these data structures
> are related to the UFS host controller driver.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

