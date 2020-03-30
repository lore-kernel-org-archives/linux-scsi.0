Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7085C2D0E9
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 08:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E8AD2073B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 08:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="v1osp7cy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgC3Inn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 04:43:43 -0400
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:6022
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729416AbgC3Inm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Mar 2020 04:43:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mH89A/GppRje0WA5efHopTpZ1omaREYWFEbuqaU4UlrTKDaw7pVEwkur/Mws6lHyieY65YBTUAJs34Q/Mf7LKkeRaDqOFxGDerP4zBqo0ClLHKIgmuWcNolaobWl8cleehfKldfRBaanuD44BiSiJzv9ae4s6iOHEyZXznT2AsoQbLym6Zvb5uTQD7L2pGvsRi95RLuUP8/HfBx9RgdJkMA0eXiKfcmYtZylLtU2V/2MdLehIXFnfTgtFj/KDaArbvL+u3ha8/IipBLXMvStRSVhTs/XWKooOYnjuKtT3T6RlPw1X4GTxyf2QftBdjTOcXwdIW8ws/FEqgltOMSBEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLwpOQaHbWYvdruDqGRmJOPp8saBYUFYSWGAScyQRzE=;
 b=LZ7Jplo9yWyogXnQImYg98WqThzMIVhGqsjiL9pLf0CiWjDd/tcsKrYkjBfjKUVdEZauv0CKAzgxVqwCWlPw+6XmSPXhZL16cANXmsQ1UUBVha6JB6OOoLH7rTf3NHPU2pN3nVfwJUss12bN/yxea2keitqX64nTyHWZVWjj9jiq6HZjbjV+AW0ZluACAXV0DRouXWTQeDkYwytJT5GllUNCfzxOFYTcMJXS7szhjMoVTi9JxjGOmoBsyVFoE1iOOiIIfdhENittxXOccpzUVD8slTZW3WezYEvV/P8CDL8xbGkVZFxCQQ+WTsFL9CpBuUI5EByg93SxfeuckEZXgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLwpOQaHbWYvdruDqGRmJOPp8saBYUFYSWGAScyQRzE=;
 b=v1osp7cyzA6siB+bpkIWJdi9SzKR2dQ5+kyuBZInVolzyH0RX/gqjyYo25cgql1PFdU52M6ZWneR9fFzdwA1DewHDN2WSS6U1ncaf+hrgRLYP7Hj4iBveBnZNZmRwP+DQZp9ZYEO5UzfTl9pSYOvUZt6kePaESfwMZ+D6vePxNo=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB4036.namprd08.prod.outlook.com (2603:10b6:406:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Mon, 30 Mar
 2020 08:43:38 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135%5]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 08:43:38 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link
 was off
Thread-Topic: [EXT] [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link
 was off
Thread-Index: AQHWBKh0Wf5D+Wk3b0quXsvdK7OMg6hg1N7A
Date:   Mon, 30 Mar 2020 08:43:38 +0000
Message-ID: <BN7PR08MB56843F68BAEDFF7BDF8D0169DBCB0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1585362454-5413-1-git-send-email-cang@codeaurora.org>
In-Reply-To: <1585362454-5413-1-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLThhN2MwYTE1LTcyNjItMTFlYS04YjkwLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw4YTdjMGExNy03MjYyLTExZWEtOGI5MC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjI1NSIgdD0iMTMyMzAwMzE0MTU0MjE3NzgxIiBoPSI3dDZ2TFp1MGtYQ0VLQk5EVHVaNEgyY2IyNTA9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUExc2RWTWJ3YldBUmdSUEZwMkRROUJHQkU4V25ZTkQwRUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTlybW53UUFBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.80.135]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a01c6035-a4f1-4796-9177-08d7d486714c
x-ms-traffictypediagnostic: BN7PR08MB4036:|BN7PR08MB4036:|BN7PR08MB4036:
x-microsoft-antispam-prvs: <BN7PR08MB403626627FBF9668FE235391DBCB0@BN7PR08MB4036.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(55016002)(86362001)(76116006)(26005)(186003)(4326008)(9686003)(66476007)(110136005)(66556008)(7696005)(8676002)(6506007)(66446008)(54906003)(64756008)(8936002)(81166006)(52536014)(81156014)(5660300002)(2906002)(55236004)(66946007)(478600001)(316002)(7416002)(71200400001)(558084003)(33656002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cqyFPTXrrCgiI4AQ+bUzDx7MJ/iHNzY5h2vsTfTlaT8S5ME6qUYoDfzJJXA/UxWlaq23mklPlRIJMFXMriPIdpRhj1BQwnJ9bc4vb4F8dTVtkW3N/X5hpbnlyFBmiwPMrOL2+NA6bkHmXgCvQFZitmD3e+XlrVDob0uxNIt/Sl59jmmZndQZS7vPzlR8c0mlKGQCllKtNueibpkVAgR9bRLEODGgtnf4CHeZjHFDHH5M78q/crfi/lJDn1RFgNvrZqGf6GmRKzW9h8SaRk5/iUOjzDUdk4mUPwSSs+8SMQGxJxIFpfUOmwIVcRz2v9qWVPQmScOlbBtc9DJa2XTltFjFUO+KMXGWdFrDiu0HJRvjiV+94+0Bki8YegjutVAPxIEJkbebzpEEShdJx+Vp+XdmTU3JZsQVscfItxGhPAxD6mGznfvXOOEz8eR/Af6A
x-ms-exchange-antispam-messagedata: MCH6oHAFF8f9x2kolxGJVAn9omWH6xrboWj8f7Q+b/29OCVWAxTLidDHtkQtQXIzk5zOYKEhOf/V/hBMWabFWKgnOPi4eYg1PWmSwE6hIrfcHCRPQt0Dvp8EWoFfazL2X0KdyQUu6wIVijbOcXyXoQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a01c6035-a4f1-4796-9177-08d7d486714c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 08:43:38.5695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QQk9gHYXwlmSe/VIi4/BZU+2LORUN9q/AD29kyc/pqNmX/Szmqp42YDDQuId9ZSwuggl5//ZJz/67UyAddKnOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4036
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

