Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B434C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 23:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3751123A22
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 23:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgLGXt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:49:58 -0500
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:8588 "EHLO
        rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgLGXt6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 18:49:58 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2020 18:49:55 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1698; q=dns/txt; s=iport;
  t=1607384995; x=1608594595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/OiZ/LIsjnOBhkEhPnnkgEQzkr3hbJ8OqLW6sceK8Qo=;
  b=D+T99y92eIPNXQNuHUDl5VYhIvDXIf8+tzSJFDbd+xhrIQJ9km9VPhck
   4kjeESvIZe517H5pVtDFBh4E1tXjCMhdW8i85EoBbl8ReELn+3YYxScUH
   KXOpIzGa92NQzB/qhG6H7soAxwtLvEPha7SO/C3XNa2Dh/CjNyV2XEhmx
   I=;
IronPort-PHdr: =?us-ascii?q?9a23=3A75TbpBWYat6ID8ff24VYlMsSeaPV8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSBNyFufJZgvXbsubrXmlTqZqCsXVXdptKWl?=
 =?us-ascii?q?dFjMgNhAUvDYaDDlGzN//laSE2XaEgHF9o9n22Kw5ZTcD5YVCBomC78jMTXB?=
 =?us-ascii?q?74MFk9KuH8AIWHicOx2qi78IHSZAMdgj27bPtyIRy6oB+XuNMRhN5pK706zV?=
 =?us-ascii?q?3CpX4bdg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CzBQAovM5f/4kNJK1iDg4BAQEBAQE?=
 =?us-ascii?q?HAQESAQEEBAEBQIFPgVJRB4FQLy6IBgONXQOZCIJTA1QLAQEBDQEBLQIEAQG?=
 =?us-ascii?q?ESgKCFQIlOBMCAwEBCwEBBQEBAQIBBgRxhWEMhXIBAQEBAxIVEwYBATcBCwQ?=
 =?us-ascii?q?CAQgRBAEBHxAyHQgCBAENBQgahVoDLgGhdAKBPIhpdIEBM4MEAQEFhTwYghA?=
 =?us-ascii?q?JgTiCc4pOG4IAgVSCVT6BBAGDOwWDQ4IsgkEHdwcMHIEmeqcCkTEKgnSbXqI?=
 =?us-ascii?q?sLZNFoR4CBAIEBQIOAQEFgW0jgVdwFYMkUBcCDY4hg3GKGAUBOnQ3AgYKAQE?=
 =?us-ascii?q?DCXyLeQEB?=
X-IronPort-AV: E=Sophos;i="5.78,401,1599523200"; 
   d="scan'208";a="836142592"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 07 Dec 2020 23:40:08 +0000
Received: from XCH-ALN-002.cisco.com (xch-aln-002.cisco.com [173.36.7.12])
        by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 0B7Ne8Ov019301
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 7 Dec 2020 23:40:08 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-002.cisco.com
 (173.36.7.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Dec
 2020 17:40:08 -0600
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Dec
 2020 17:40:07 -0600
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-001.cisco.com (64.101.210.228) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 7 Dec 2020 18:40:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzrtOsqhvf2TMTornPRHeVfvMrZDKCWbPBD09Vec6+FYryL9rJG+CxVJwqene+aVKz4nu3OEYQhwiQbSNrPP7GTOWuvrWh/gT17G/Z5FKak6urZmVI2PNSzAutmt2TmsvQZOWhc1+9lUNsmv8KFz/V9/yXvOVnIAntZYxG5NXxp6jxYMVBfm2DLo1GcVVa49Xdvu67QAjB2Rv6X3hgUOF0XOA04r7dtt9L3zvCDB6OVxchmK6JhueSUDhVZiWQG5TakPZALkR45c5Dz9x6rFKE6EWyWwwr6BF+E4FWICwac7hPyqTrN3dGCxR4DzRxYGK7kcVy3DZWqb5ahVNcs7vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNtHjjgKbJL6QXKxq3dUNioTzhckAwz7QAsAk7FW8vs=;
 b=VjmZQzvegZDgeFZPnYNNl6U1cozk/I+S6wkIZOGCdQakjMVY7b6L3qyjQUyO2nzZLVp/Qhv+xH7RACPA02M+61jxvkVAhjMhz4rZHmX21hQ6iqHseEMC4tC2AzuRUD9HgLAWJW1FP+X4ViHRpytHrVkUvAqXrMjwm3u/i8zqwSfvr9gWCUyvgQrs1Pe5XqGLJWecTPtNgurpeBofdjAuvDomNGXmd1XbyXKxDbjTxm8pjbe8VOgH+e7K/aec3mwtvhJP1DU98+GPB8AgQvOHKU7hJ4BWtZ0xdfm1++HqShxU5V7mDX155VxwA+niGNZLgRA2jjEzBJYtZSfgdKl4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNtHjjgKbJL6QXKxq3dUNioTzhckAwz7QAsAk7FW8vs=;
 b=al2lGZW+DfTjoQPIZl34M9HQfgOKTE7nC9LnQGA+kx5PIRu6IQYEcWdKjEMDJyBpKetf3rBVmuDqDy1BGkZDHgRD7pgxld2DEic9sF3CfymQc4kbNXl1iG9Z/CA/odhwECb8uRNyJn/5uFGQ4lKtUF4DbzD1UJV/FdP0UCafcFo=
Received: from BY5PR11MB3863.namprd11.prod.outlook.com (2603:10b6:a03:18a::28)
 by SJ0PR11MB5037.namprd11.prod.outlook.com (2603:10b6:a03:2ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 23:40:05 +0000
Received: from BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::5c9b:4162:e0bb:fae4]) by BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::5c9b:4162:e0bb:fae4%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 23:40:05 +0000
From:   "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Joe Eykholt <jeykholt@cisco.com>,
        Abhijeet Joglekar <abjoglek@cisco.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: fix error return code in fnic_probe()
Thread-Topic: [PATCH] scsi: fnic: fix error return code in fnic_probe()
Thread-Index: AQHWyhFQobKBthBd10OdRo1784yP/qnsUCwg
Date:   Mon, 7 Dec 2020 23:40:05 +0000
Message-ID: <BY5PR11MB386336068FCF398218B474CBC3CE0@BY5PR11MB3863.namprd11.prod.outlook.com>
References: <1607068060-31203-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1607068060-31203-1-git-send-email-zhangchangzhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2600:1700:ce00:1710:3408:3f1f:a028:1ae8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10713d81-41e9-48ca-930e-08d89b096cb2
x-ms-traffictypediagnostic: SJ0PR11MB5037:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB5037464D65A920629622E3CEC3CE0@SJ0PR11MB5037.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KId9ZoKkOJhsvGKrTttJctypgdHiR+mj58v8FNV8JSMgJyhBsxA1fMUbG2a7kB8LuF8VSGgJnpjwdGhEdiIjF/TF0S8DRjCNiOV6QFfSgVxGBQlOxKvxUDwFt/NcY3i6ktXae0ThpzkKM60kqSNKbdWxwQXwE3xGT8F9D626/3+CYxPcj0jmDuPtWTaL/MVDTplwWczCLk0bwbQ/RV1X091XtZjeaE3iZdtjQl9s4JRxFYS1Jh+0OeNM2s254nCQAGMVK/8nhx1TrNkV0eWp4u+2XF4WitHF0d9IFkah8xMLehiiJ3hCIGf8OzOm0lNY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3863.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39860400002)(55016002)(53546011)(7696005)(52536014)(478600001)(66476007)(83380400001)(4326008)(64756008)(6636002)(33656002)(76116006)(6506007)(2906002)(9686003)(86362001)(66446008)(71200400001)(5660300002)(8676002)(54906003)(66556008)(316002)(110136005)(8936002)(66946007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1vxKNpq+GdOwrlSxm4autKLnbDjmyzp8rjonMMkQa6FX22MdSMDwHCgS52hx?=
 =?us-ascii?Q?XGZ51hhkuNFzafVb1AHAnDcZvbtq7GP+tNDTW+U0JY5IwqJuHxl17HSOkq2y?=
 =?us-ascii?Q?AMOwOiO71ZR0H5aOM0FS/WzcYQ16fagey37STArGQGNHX70UTFKqf4A9hDz4?=
 =?us-ascii?Q?fQIR6Eix2kqiOBZm97AGX0I0A4zaRACR9vcuJtk4LBICacxZ+AhDeNOW3ulz?=
 =?us-ascii?Q?WJNlbpWzf7mJ37LrY8lY+c3nrBRE233QQ7pJqyEiTX958hYG90ZX5Das/PxY?=
 =?us-ascii?Q?l2gR+C2JIEBYeBGSzPZ1tJUhW7pj3DwzCLB+YU/FisPiW2XdyzZVKReTCKAC?=
 =?us-ascii?Q?0RLVaglbQmYA3HrXb7uXsO03et+wd2Rp5nzDWQnBUhDVNvB7lbRFqZRFmuDI?=
 =?us-ascii?Q?ogs7ODQ+E5hs6Yqfk2/kJnJCmshnYZ/0OiWMtFwQZLaSPgEvwLYjPmYgjiul?=
 =?us-ascii?Q?zb3JF5BM/jotJ/AbM+7Bfv6sQALrkQgDukB67oSVWWdmUbjLr1RExX+CtcEB?=
 =?us-ascii?Q?T4TPGEzvAePsr+6E/44m0WHKwKPwOyM5ME2G80tXxhJfncAvuwz6aXqYwzbZ?=
 =?us-ascii?Q?Oi8Gks7V2hwY7o59/3g1xi6pJmow02kzKN1VwerjTdjXhCURg1RjTHN9xFAL?=
 =?us-ascii?Q?VIY9u1TwN4cWh47ksdBvayedgyv9DARHHHRhY0+e/GQlA7yQL8UtFdLxAiJS?=
 =?us-ascii?Q?kFDAVvKXqxQI7upoqaGwP1rW2gNlqh8TFglktaxnocdakXw8fyWjRzE5rd+e?=
 =?us-ascii?Q?iWetRWPa1CmYlHhtQcmM52v63ULAVmj1PUNjQ5tAMhu9hOsx5z7zr8m7mp0/?=
 =?us-ascii?Q?A1aEDW8fwHXjqWj8sZjaIsFYpKIQ3zsKDr1s1rrFTk3Yn8FQFvqCx82Dymrl?=
 =?us-ascii?Q?AtFnq3xAO2Mifi6hQcJ/uGsxniSBjW4NcMXU6BpCEhPxNMHjywUvl+9vuy2Y?=
 =?us-ascii?Q?UeBnnvHnI2gLlGaWoZzgClLdw5Rsoun5Xq/vJR41PHSJo1WeXsnA18CeVI/4?=
 =?us-ascii?Q?tj8Q9BpKKSr4olJfaXip+7Nwa0KbdB7Dyzd0u5ywFEQ0vVk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3863.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10713d81-41e9-48ca-930e-08d89b096cb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 23:40:05.2699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o04nrw+kVaRyacKKIJOKdsQZ5fCvz8HEqmYKthG5bNA7PcEvrVinDncBiKFrqdd16suNzZVye1L0QGNFE8KKng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5037
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.12, xch-aln-002.cisco.com
X-Outbound-Node: alln-core-4.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good to me.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan

-----Original Message-----
From: Zhang Changzhong <zhangchangzhong@huawei.com>=20
Sent: Thursday, December 3, 2020 11:48 PM
To: Satish Kharat (satishkh) <satishkh@cisco.com>; Sesidhar Baddela (sebadd=
el) <sebaddel@cisco.com>; Karan Tilak Kumar (kartilak) <kartilak@cisco.com>=
; James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen <martin.pet=
ersen@oracle.com>; James Bottomley <James.Bottomley@HansenPartnership.com>;=
 Mike Christie <michaelc@cs.wisc.edu>; Joe Eykholt <jeykholt@cisco.com>; Ab=
hijeet Joglekar <abjoglek@cisco.com>
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fnic: fix error return code in fnic_probe()

Fix to return a negative error code from the error handling case instead of=
 0, as done elsewhere in this function.

Fixes: 5df6d737dd4b ("[SCSI] fnic: Add new Cisco PCI-Express FCoE HBA")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/scsi/fnic/fnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c =
index 5f8a7ef..4f7befb 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -740,6 +740,7 @@ static int fnic_probe(struct pci_dev *pdev, const struc=
t pci_device_id *ent)
 	for (i =3D 0; i < FNIC_IO_LOCKS; i++)
 		spin_lock_init(&fnic->io_req_lock[i]);
=20
+	err =3D -ENOMEM;
 	fnic->io_req_pool =3D mempool_create_slab_pool(2, fnic_io_req_cache);
 	if (!fnic->io_req_pool)
 		goto err_out_free_resources;
--
2.9.5

