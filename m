Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FA1C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 07:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D438C6138B
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 07:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244220AbhDFHT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 03:19:27 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41110 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244296AbhDFHTY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 03:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617693557; x=1649229557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=M7UxGJ8zqXIhGR7zHZQkyUzjVr09pkJzKK8qZYULq6A=;
  b=DwGr2FzTkUyiwZm4uC4eeZ66zDN265yCbFXrf+JNShGRu5uB4RvdfieU
   Bkc2KuUJciz4MSP1m8lLNClUuOORS6gNhcsPlDH85G0b3GIGPAsak635Y
   Ax+4OT632tCvNieBsYeeAkd4/eZb1QC5TGFU405u809eqD6YYR1VhbTSM
   DGRH0dVnbINn8/A5NrQx9D5yPFqIqUOztmtbHi4yokvWQ/F5TPLFros49
   bSQlO5dtLWkE7cJvzKVb9ayysXBUZTJrqs+odVT8n1Slll/tE/GzjwivR
   5Q7lZxscuIukqe5kXtDZua/RG3P32fwiYMd0QsrxltRP2yBdSlWmX2+VG
   w==;
IronPort-SDR: 66mNgyJgx5bY80xMKbBDsfcwLUWWMpbJHi+SkDxaOWRCJLGgptwWz2NhARvSXjgN+Dso7qrsEr
 yeUY3pNdRmcuL4k1+u8bHBc3P6vgW3sZCfJzQWDSul3O7WPdD3djWGkbiwtP6wYGcfWjc0JeMs
 D24cj2E57CIzeDnLWvHRsXIjKYtiAEnzSu6VfJScCpSHSEFDvrH1rlYajR3dLYD39gBcH+KQe1
 c8Qce3TwjbNTzBw/Uc9ELEfm2m1VyJ370r1/So7U+kpIJ3pa8uKcl1JU2xVh3vzuI/i4xpLWan
 +Ak=
X-IronPort-AV: E=Sophos;i="5.81,308,1610380800"; 
   d="scan'208,223";a="163730595"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2021 15:16:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guOkWV3yFxfPDKI2XiYmgu9SYtcxOmRYf/ZSztl2lA96jZefuM0YBXzhNVynCRgDhJdZuWpqJmIGN+O+0VGDCVjsQhGdaP/fThG8GpetecKVySoQJjG6sFIUet17KaP5N/CgHVGkhBn1PuUM7F6XrcidXr/prloXX8koFC8CFP6bvjtUeW81PiIkKM+dhYnXLOC8MmMgXXyfRcX+cNOEjq2HDoxXfstH46Wk0ddUmRcvifWZ3hWfU5p/5ft6fseLYTd8Hxu9jH0B0nVNfyeK7gFLd3RyKgajBs+3cjKOmiDQhW6C6pqPAZpKMvd18i9Z1/rIkCSArhCoidTg22++3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fEnfH7wsQYtTSYdo2GCWFAtPpAlMTU6ktUxAtPf4Yk=;
 b=kzswavrqEcfUv9xGbpp1KSjIwIDc8BV91/A/VqmHH0XcadKu/mz1BXI7akPtGsF0iDpUtZISPhufb/5yCmzi2Y1IunGEu78spcNpLo31SLvyIBCNJ7gIZwEsnQ4dyA8S7QMOZpWEDyUAbg8BEavC/uuceETXdSiG++0fJWmoY9g0UOSD6Sf2Mb6HmjI+63Bo4+9/mSJ1ei215mN0uNN0kFVG9tihpHcIfGKui5ERBk6FsiuGBsYabuLDh1b+cOVxtZGmSg88eHgSh7OwYWYhv/pMYCK9KBSwYjlzx8WqKNEONdb7KvNHKfzoQmty/vmdkVWOUraichmmXlmsbEtEXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fEnfH7wsQYtTSYdo2GCWFAtPpAlMTU6ktUxAtPf4Yk=;
 b=pweSjtoowpD8K0TB1thew1eA5b97izryWIWJNvdo3m+jCeVR6HmIw1G8JwnWV1yrWtg2PRJGEySAFVTmG5+gWcxpnnvXMm9Cvsc4JyUF/cKCDpEGiFxXX76mMn1Nv9vnUSa+4gdXA5IYIPm6C0lfFtlSGsSAzvSmUiQ2WeLGsTw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4842.namprd04.prod.outlook.com (2603:10b6:5:1e::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.29; Tue, 6 Apr 2021 07:16:47 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 07:16:47 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v7 06/11] scsi: ufshpb: Region inactivation in host mode
Thread-Topic: [PATCH v7 06/11] scsi: ufshpb: Region inactivation in host mode
Thread-Index: AQHXJgEueLuV4ularE+yUH8qPo3IjKqm9ZCAgAAHZsCAAAthAIAABAWQgAADOYCAAAxloA==
Date:   Tue, 6 Apr 2021 07:16:47 +0000
Message-ID: <DM6PR04MB657516510061FCFF7755DF74FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
 <20210331073952.102162-7-avri.altman@wdc.com>
 <e29e33769f23036f936a6b60c7430387@codeaurora.org>
 <DM6PR04MB6575719C78D67B7FA1557C21FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
 <6bb2fd28feb0cd6372a32673d6cfa164@codeaurora.org>
 <DM6PR04MB65752BA21FA1857D6EA10B62FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
 <a11edfeed79b8f411dc1948aadae0f25@codeaurora.org>
In-Reply-To: <a11edfeed79b8f411dc1948aadae0f25@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06778686-84dd-4935-6906-08d8f8cbf105
x-ms-traffictypediagnostic: DM6PR04MB4842:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB4842CAAD619DBD13F6C53AEFFC769@DM6PR04MB4842.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dIx3rJl3PdAAKn00LdVYmB3neI9qk7tkX4Px5vYDG51j7BMsttWWSRr1WnINVWdEB+LfiJ0nAnGvAocrnvoEL3Wzksr2LkXUpHAGqcy/mhxLJD7TyU3E+FrlG8hWyneiGbnpCn0Y/f+Ym3YIxYxl+JyKY4Z+sI4ioFpWjbhcIONSoR3L/Q29JqIkXUln/G3QtihrKFpaFGARcC0lAs0YNnkuFQ1BSP6AeMeB7c1fiufOnZhj8xZfs9bWwzTEvQ7QKgx/DijEzRQlpBnOukA2i1JQ3tykdiv3begiKVkS84RZrlXFXhtXo3tRFip7D46PO2rNCYn944eVi7W8TwW1Be9CMRUsZ7BYUc64GHkSeqA8zkDw1bflx6KwWN/BA1y9ovH9cscJI1FajOjy37O/8lwZtgST0mG6FYAGhQuHRTwgin5XdkxVLuZ9s9Uk1a/IOtvtmtfazu+3CWLzFwW1BbxXJq3+p3+HQvHkpDW9HDvnonv+WrJo2MXUwg4eHPILzu6pBkLnOWV1s+NLvmLDF8ZwafL3SAraOH/+jnz0poXPfAzY1ytyhFF8KeIxi7Dpq4kbdO0TsyY/8DkR6ISxM+6eLU6a6tDLXh8spngAHhJTcaxN0k09IQHxs5emmNWBQ3Jbdq31Dk2hyzMUIVjlP076KOAx5l1fIcrKn5wxXfI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(6916009)(186003)(8936002)(54906003)(71200400001)(33656002)(2906002)(83380400001)(6506007)(53546011)(8676002)(4326008)(55016002)(9686003)(99936003)(38100700001)(66476007)(66616009)(66446008)(64756008)(66556008)(66946007)(26005)(7696005)(316002)(52536014)(86362001)(5660300002)(76116006)(7416002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5mTi090ZAL9st0UUXQeQDqH31flab3bMduxTNkPuSHgVcBxdx1HmFT1rNuZm?=
 =?us-ascii?Q?9L2KhyQYyAxJTVpgOzMs4WDzYT3B8ZSAAVKHmWKwd3u7Vcbwza8pI3rQ7RTs?=
 =?us-ascii?Q?MreYxeMBoIeDgp6rwHjLOJHY2NrPzs7rXYR3Wh1i/jeDAht6LtynT+/pQfZf?=
 =?us-ascii?Q?6/1xkkckX/LDBn5g0wfcO+ykW7Z3k4IjDoLJpC5ixenA1/dWBjjJmxTQzsZN?=
 =?us-ascii?Q?erxA4cAOHNQ2et2Ba7EQdRLdTEb+hBIWoOCJSpB1EZo/iJdvjCVzzMhoWrwX?=
 =?us-ascii?Q?kW5mz6H/84JYW7Wlm//o6whSn0OB4BCyf2xDPlRG5CsJ9o9S2LWEplfjGWTQ?=
 =?us-ascii?Q?jKWJ0Rzt4oigf+Rm2458/gREPnQIC1GJUwAp+eySOkaND4E5bohZa1XrZkSH?=
 =?us-ascii?Q?+V+8wgB4OEqnzfkpWSXs3jjat9j6IJpdIhYnhN7nIBD65g1bdRlKpElEuTpm?=
 =?us-ascii?Q?eva5ySLshkG0IYX+jH9ZjOeo2V/8weItIkGSpVILJHV5XvmduNYPmA0djrhC?=
 =?us-ascii?Q?BWYzN6/wo1P9waHE9cTJrv8ybbpsQQ0rstKirddma7vnUmDoI97ZDMSzcM24?=
 =?us-ascii?Q?mwAkza6BHEpf/SihuvxnAqhhbtMzCMmew0V3XzDYQUrwIhTmbSQRn9vc9DzI?=
 =?us-ascii?Q?UBOiF2PmdGyY0aW2ZkmoRd2+LLTBkhil26T0iJvvPNwY4+B1n4DZjkRccOch?=
 =?us-ascii?Q?DnoEJjRqkPBkoNqi2O9A3rN4EySq54vOZJS3tDkf2IntbZJyihrPkiLRr2PP?=
 =?us-ascii?Q?PAM7QPPCXaC0Lw6SP7yRMwiKZJqQFogy+lg/NWwDWn8qblNO+dBEs+DSEBD4?=
 =?us-ascii?Q?B5f27s2vCSCk8ozD3FQjqqRq9TC06P8iSkteE06oLrJ13AOO2xdZxQYWcbCw?=
 =?us-ascii?Q?EAfq2B+GVBt1m7aSMGm6xWM5yHVzYCx/VmXFisdGXA6h0GY6UkgyAbppnwNT?=
 =?us-ascii?Q?xI7WZldB1vhLUSYgrAaHaEQZvaRq/bi1jioYEVzjy0q/bltQWfvUgA8Hxn0s?=
 =?us-ascii?Q?/n3RSY69v7padhZSJyCuqP609jCKCRjyNeIo3bpi0FR4AqbfzP4e3TlRZcw8?=
 =?us-ascii?Q?kKCOTBT/PC4vwpqM+HVDIGjjwecAnjm0suAHq16s666i7/i6B62jIATTMlwc?=
 =?us-ascii?Q?LviAqcvUvGkNLvXJzFA/M8jbY8DpZEXgNiExStOOXaZYoLz+tc+wASf/S2aG?=
 =?us-ascii?Q?L85958ZftwkYngUwUdjOSK9wUfJAm+mSc3CuZMqngQ3+oCRWpBKpJhGvcegn?=
 =?us-ascii?Q?V3JukDQLPpW9mykP4KUQxMgjX9lJIyzHrdFcFniJ+ty7ZtDW+i4eSCYETd8b?=
 =?us-ascii?Q?P/ssp6kNnoruv5dUqA4+EfMV?=
Content-Type: multipart/mixed;
        boundary="_002_DM6PR04MB657516510061FCFF7755DF74FC769DM6PR04MB6575namp_"
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06778686-84dd-4935-6906-08d8f8cbf105
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 07:16:47.8050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HdaTLQR5Lknota9ClPeqJfqFVOXGXIxbMOlEINQi5kvJ124aSzZDpqLyU5wDQmAedlkw+DBSaTIw0bGRz6JTsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4842
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--_002_DM6PR04MB657516510061FCFF7755DF74FC769DM6PR04MB6575namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> >>
> >> On 2021-04-06 13:20, Avri Altman wrote:
> >> >> > -static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
> >> >> > -                               struct ufshpb_region *rgn)
> >> >> > +static int __ufshpb_evict_region(struct ufshpb_lu *hpb,
> >> >> > +                              struct ufshpb_region *rgn)
> >> >> >  {
> >> >> >       struct victim_select_info *lru_info;
> >> >> >       struct ufshpb_subregion *srgn;
> >> >> >       int srgn_idx;
> >> >> >
> >> >> > +     lockdep_assert_held(&hpb->rgn_state_lock);
> >> >> > +
> >> >> > +     if (hpb->is_hcm) {
> >> >> > +             unsigned long flags;
> >> >> > +             int ret;
> >> >> > +
> >> >> > +             spin_unlock_irqrestore(&hpb->rgn_state_lock, flags)=
;
> >> >>
> >> >> Never seen a usage like this... Here flags is used without being
> >> >> intialized.
> >> >> The flag is needed when spin_unlock_irqrestore ->
> >> >> local_irq_restore(flags) to
> >> >> restore the DAIF register (in terms of ARM).
> >> > OK.
> >>
> >> Hi Avri,
> >>
> >> Checked on my setup, this lead to compilation error. Will you fix it
> >> in
> >> next version?
> >>
> >> warning: variable 'flags' is uninitialized when used here
> >> [-Wuninitialized]
> > Yeah - I will pass it to __ufshpb_evict_region and drop the
> > lockdep_assert call.
> >
>=20
> Please paste the sample code/change here so that I can move forward
> quickly.
Thanks a lot.  Also attaching the patch if its more convenient.

Thanks,
Avri

$ git show 5d33d36e8704
commit 5d33d36e87047d27a546ad3529cb7837186b47b2
Author: Avri Altman <avri.altman@wdc.com>
Date:   Tue Jun 30 15:14:31 2020 +0300

    scsi: ufshpb: Region inactivation in host mode
   =20
    In host mode, the host is expected to send HPB-WRITE-BUFFER with
    buffer-id =3D 0x1 when it inactivates a region.
   =20
    Use the map-requests pool as there is no point in assigning a
    designated cache for umap-requests.
   =20
    Signed-off-by: Avri Altman <avri.altman@wdc.com>
    Reviewed-by: Daejun Park <daejun7.park@samsung.com>
    Change-Id: I1a6696b38d4abfb4d9fbe44e84016a6238825125

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index aefb6dc160ee..54a3ea9f5732 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -914,6 +914,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu *hp=
b,
=20
        blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
=20
+       hpb->stats.umap_req_cnt++;
        return 0;
 }
=20
@@ -1110,18 +1111,35 @@ static int ufshpb_issue_umap_req(struct ufshpb_lu *=
hpb,
        return -EAGAIN;
 }
=20
+static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
+                                       struct ufshpb_region *rgn)
+{
+       return ufshpb_issue_umap_req(hpb, rgn);
+}
+
 static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
 {
        return ufshpb_issue_umap_req(hpb, NULL);
 }
=20
-static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
-                                 struct ufshpb_region *rgn)
+static int __ufshpb_evict_region(struct ufshpb_lu *hpb,
+                                struct ufshpb_region *rgn,
+                                unsigned long flags)
 {
        struct victim_select_info *lru_info;
        struct ufshpb_subregion *srgn;
        int srgn_idx;
=20
+       if (hpb->is_hcm) {
+               int ret;
+
+               spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+               ret =3D ufshpb_issue_umap_single_req(hpb, rgn);
+               spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+               if (ret)
+                       return ret;
+       }
+
        lru_info =3D &hpb->lru_info;
=20
        dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n", rgn->rgn_=
idx);
@@ -1130,6 +1148,8 @@ static void __ufshpb_evict_region(struct ufshpb_lu *h=
pb,
=20
        for_each_sub_region(rgn, srgn_idx, srgn)
                ufshpb_purge_active_subregion(hpb, srgn);
+
+       return 0;
 }
=20
 static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region=
 *rgn)
@@ -1151,7 +1171,7 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb,=
 struct ufshpb_region *rgn)
                        goto out;
                }
=20
-               __ufshpb_evict_region(hpb, rgn);
+               ret =3D __ufshpb_evict_region(hpb, rgn, flags);
        }
 out:
        spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
@@ -1285,7 +1305,9 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, s=
truct ufshpb_region *rgn)
                                "LRU full (%d), choose victim %d\n",
                                atomic_read(&lru_info->active_cnt),
                                victim_rgn->rgn_idx);
-                       __ufshpb_evict_region(hpb, victim_rgn);
+                       ret =3D __ufshpb_evict_region(hpb, victim_rgn, flag=
s);
+                       if (ret)
+                               goto out;
                }
=20
                /*
@@ -1856,6 +1878,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
=20
 static struct attribute *hpb_dev_stat_attrs[] =3D {
        &dev_attr_hit_cnt.attr,
@@ -1864,6 +1887,7 @@ static struct attribute *hpb_dev_stat_attrs[] =3D {
        &dev_attr_rb_active_cnt.attr,
        &dev_attr_rb_inactive_cnt.attr,
        &dev_attr_map_req_cnt.attr,
+       &dev_attr_umap_req_cnt.attr,
        NULL,
 };
=20
@@ -1988,6 +2012,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
        hpb->stats.rb_active_cnt =3D 0;
        hpb->stats.rb_inactive_cnt =3D 0;
        hpb->stats.map_req_cnt =3D 0;
+       hpb->stats.umap_req_cnt =3D 0;
 }
=20
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 87495e59fcf1..1ea58c17a4de 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -191,6 +191,7 @@ struct ufshpb_stats {
        u64 rb_inactive_cnt;
        u64 map_req_cnt;
        u64 pre_req_cnt;
+       u64 umap_req_cnt;
 };
=20
 struct ufshpb_lu {

--_002_DM6PR04MB657516510061FCFF7755DF74FC769DM6PR04MB6575namp_
Content-Type: application/octet-stream;
	name="v8-0006-scsi-ufshpb-Region-inactivation-in-host-mode.patch"
Content-Description:
 v8-0006-scsi-ufshpb-Region-inactivation-in-host-mode.patch
Content-Disposition: attachment;
	filename="v8-0006-scsi-ufshpb-Region-inactivation-in-host-mode.patch";
	size=4074; creation-date="Tue, 06 Apr 2021 07:14:23 GMT";
	modification-date="Tue, 06 Apr 2021 07:14:05 GMT"
Content-Transfer-Encoding: base64

RnJvbSA1ZDMzZDM2ZTg3MDQ3ZDI3YTU0NmFkMzUyOWNiNzgzNzE4NmI0N2IyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4KRGF0
ZTogVHVlLCAzMCBKdW4gMjAyMCAxNToxNDozMSArMDMwMApTdWJqZWN0OiBbUEFUQ0ggdjggMDYv
MTFdIHNjc2k6IHVmc2hwYjogUmVnaW9uIGluYWN0aXZhdGlvbiBpbiBob3N0IG1vZGUKCkluIGhv
c3QgbW9kZSwgdGhlIGhvc3QgaXMgZXhwZWN0ZWQgdG8gc2VuZCBIUEItV1JJVEUtQlVGRkVSIHdp
dGgKYnVmZmVyLWlkID0gMHgxIHdoZW4gaXQgaW5hY3RpdmF0ZXMgYSByZWdpb24uCgpVc2UgdGhl
IG1hcC1yZXF1ZXN0cyBwb29sIGFzIHRoZXJlIGlzIG5vIHBvaW50IGluIGFzc2lnbmluZyBhCmRl
c2lnbmF0ZWQgY2FjaGUgZm9yIHVtYXAtcmVxdWVzdHMuCgpTaWduZWQtb2ZmLWJ5OiBBdnJpIEFs
dG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4KUmV2aWV3ZWQtYnk6IERhZWp1biBQYXJrIDxkYWVq
dW43LnBhcmtAc2Ftc3VuZy5jb20+Ci0tLQogZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIuYyB8IDMz
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLQogZHJpdmVycy9zY3NpL3Vmcy91ZnNo
cGIuaCB8ICAxICsKIDIgZmlsZXMgY2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNocGIuYwppbmRleCBhZWZiNmRjMTYwZWUuLjU0YTNlYTlmNTczMiAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIuYworKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hwYi5jCkBAIC05MTQsNiArOTE0LDcgQEAgc3RhdGljIGludCB1ZnNocGJfZXhlY3V0ZV91bWFw
X3JlcShzdHJ1Y3QgdWZzaHBiX2x1ICpocGIsCiAKIAlibGtfZXhlY3V0ZV9ycV9ub3dhaXQoTlVM
TCwgcmVxLCAxLCB1ZnNocGJfdW1hcF9yZXFfY29tcGxfZm4pOwogCisJaHBiLT5zdGF0cy51bWFw
X3JlcV9jbnQrKzsKIAlyZXR1cm4gMDsKIH0KIApAQCAtMTExMCwxOCArMTExMSwzNSBAQCBzdGF0
aWMgaW50IHVmc2hwYl9pc3N1ZV91bWFwX3JlcShzdHJ1Y3QgdWZzaHBiX2x1ICpocGIsCiAJcmV0
dXJuIC1FQUdBSU47CiB9CiAKK3N0YXRpYyBpbnQgdWZzaHBiX2lzc3VlX3VtYXBfc2luZ2xlX3Jl
cShzdHJ1Y3QgdWZzaHBiX2x1ICpocGIsCisJCQkJCXN0cnVjdCB1ZnNocGJfcmVnaW9uICpyZ24p
Cit7CisJcmV0dXJuIHVmc2hwYl9pc3N1ZV91bWFwX3JlcShocGIsIHJnbik7Cit9CisKIHN0YXRp
YyBpbnQgdWZzaHBiX2lzc3VlX3VtYXBfYWxsX3JlcShzdHJ1Y3QgdWZzaHBiX2x1ICpocGIpCiB7
CiAJcmV0dXJuIHVmc2hwYl9pc3N1ZV91bWFwX3JlcShocGIsIE5VTEwpOwogfQogCi1zdGF0aWMg
dm9pZCBfX3Vmc2hwYl9ldmljdF9yZWdpb24oc3RydWN0IHVmc2hwYl9sdSAqaHBiLAotCQkJCSAg
c3RydWN0IHVmc2hwYl9yZWdpb24gKnJnbikKK3N0YXRpYyBpbnQgX191ZnNocGJfZXZpY3RfcmVn
aW9uKHN0cnVjdCB1ZnNocGJfbHUgKmhwYiwKKwkJCQkgc3RydWN0IHVmc2hwYl9yZWdpb24gKnJn
biwKKwkJCQkgdW5zaWduZWQgbG9uZyBmbGFncykKIHsKIAlzdHJ1Y3QgdmljdGltX3NlbGVjdF9p
bmZvICpscnVfaW5mbzsKIAlzdHJ1Y3QgdWZzaHBiX3N1YnJlZ2lvbiAqc3JnbjsKIAlpbnQgc3Jn
bl9pZHg7CiAKKwlpZiAoaHBiLT5pc19oY20pIHsKKwkJaW50IHJldDsKKworCQlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZocGItPnJnbl9zdGF0ZV9sb2NrLCBmbGFncyk7CisJCXJldCA9IHVmc2hw
Yl9pc3N1ZV91bWFwX3NpbmdsZV9yZXEoaHBiLCByZ24pOworCQlzcGluX2xvY2tfaXJxc2F2ZSgm
aHBiLT5yZ25fc3RhdGVfbG9jaywgZmxhZ3MpOworCQlpZiAocmV0KQorCQkJcmV0dXJuIHJldDsK
Kwl9CisKIAlscnVfaW5mbyA9ICZocGItPmxydV9pbmZvOwogCiAJZGV2X2RiZygmaHBiLT5zZGV2
X3Vmc19sdS0+c2Rldl9kZXYsICJldmljdCByZWdpb24gJWRcbiIsIHJnbi0+cmduX2lkeCk7CkBA
IC0xMTMwLDYgKzExNDgsOCBAQCBzdGF0aWMgdm9pZCBfX3Vmc2hwYl9ldmljdF9yZWdpb24oc3Ry
dWN0IHVmc2hwYl9sdSAqaHBiLAogCiAJZm9yX2VhY2hfc3ViX3JlZ2lvbihyZ24sIHNyZ25faWR4
LCBzcmduKQogCQl1ZnNocGJfcHVyZ2VfYWN0aXZlX3N1YnJlZ2lvbihocGIsIHNyZ24pOworCisJ
cmV0dXJuIDA7CiB9CiAKIHN0YXRpYyBpbnQgdWZzaHBiX2V2aWN0X3JlZ2lvbihzdHJ1Y3QgdWZz
aHBiX2x1ICpocGIsIHN0cnVjdCB1ZnNocGJfcmVnaW9uICpyZ24pCkBAIC0xMTUxLDcgKzExNzEs
NyBAQCBzdGF0aWMgaW50IHVmc2hwYl9ldmljdF9yZWdpb24oc3RydWN0IHVmc2hwYl9sdSAqaHBi
LCBzdHJ1Y3QgdWZzaHBiX3JlZ2lvbiAqcmduKQogCQkJZ290byBvdXQ7CiAJCX0KIAotCQlfX3Vm
c2hwYl9ldmljdF9yZWdpb24oaHBiLCByZ24pOworCQlyZXQgPSBfX3Vmc2hwYl9ldmljdF9yZWdp
b24oaHBiLCByZ24sIGZsYWdzKTsKIAl9CiBvdXQ6CiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
aHBiLT5yZ25fc3RhdGVfbG9jaywgZmxhZ3MpOwpAQCAtMTI4NSw3ICsxMzA1LDkgQEAgc3RhdGlj
IGludCB1ZnNocGJfYWRkX3JlZ2lvbihzdHJ1Y3QgdWZzaHBiX2x1ICpocGIsIHN0cnVjdCB1ZnNo
cGJfcmVnaW9uICpyZ24pCiAJCQkJIkxSVSBmdWxsICglZCksIGNob29zZSB2aWN0aW0gJWRcbiIs
CiAJCQkJYXRvbWljX3JlYWQoJmxydV9pbmZvLT5hY3RpdmVfY250KSwKIAkJCQl2aWN0aW1fcmdu
LT5yZ25faWR4KTsKLQkJCV9fdWZzaHBiX2V2aWN0X3JlZ2lvbihocGIsIHZpY3RpbV9yZ24pOwor
CQkJcmV0ID0gX191ZnNocGJfZXZpY3RfcmVnaW9uKGhwYiwgdmljdGltX3JnbiwgZmxhZ3MpOwor
CQkJaWYgKHJldCkKKwkJCQlnb3RvIG91dDsKIAkJfQogCiAJCS8qCkBAIC0xODU2LDYgKzE4Nzgs
NyBAQCB1ZnNocGJfc3lzZnNfYXR0cl9zaG93X2Z1bmMocmJfbm90aV9jbnQpOwogdWZzaHBiX3N5
c2ZzX2F0dHJfc2hvd19mdW5jKHJiX2FjdGl2ZV9jbnQpOwogdWZzaHBiX3N5c2ZzX2F0dHJfc2hv
d19mdW5jKHJiX2luYWN0aXZlX2NudCk7CiB1ZnNocGJfc3lzZnNfYXR0cl9zaG93X2Z1bmMobWFw
X3JlcV9jbnQpOwordWZzaHBiX3N5c2ZzX2F0dHJfc2hvd19mdW5jKHVtYXBfcmVxX2NudCk7CiAK
IHN0YXRpYyBzdHJ1Y3QgYXR0cmlidXRlICpocGJfZGV2X3N0YXRfYXR0cnNbXSA9IHsKIAkmZGV2
X2F0dHJfaGl0X2NudC5hdHRyLApAQCAtMTg2NCw2ICsxODg3LDcgQEAgc3RhdGljIHN0cnVjdCBh
dHRyaWJ1dGUgKmhwYl9kZXZfc3RhdF9hdHRyc1tdID0gewogCSZkZXZfYXR0cl9yYl9hY3RpdmVf
Y250LmF0dHIsCiAJJmRldl9hdHRyX3JiX2luYWN0aXZlX2NudC5hdHRyLAogCSZkZXZfYXR0cl9t
YXBfcmVxX2NudC5hdHRyLAorCSZkZXZfYXR0cl91bWFwX3JlcV9jbnQuYXR0ciwKIAlOVUxMLAog
fTsKIApAQCAtMTk4OCw2ICsyMDEyLDcgQEAgc3RhdGljIHZvaWQgdWZzaHBiX3N0YXRfaW5pdChz
dHJ1Y3QgdWZzaHBiX2x1ICpocGIpCiAJaHBiLT5zdGF0cy5yYl9hY3RpdmVfY250ID0gMDsKIAlo
cGItPnN0YXRzLnJiX2luYWN0aXZlX2NudCA9IDA7CiAJaHBiLT5zdGF0cy5tYXBfcmVxX2NudCA9
IDA7CisJaHBiLT5zdGF0cy51bWFwX3JlcV9jbnQgPSAwOwogfQogCiBzdGF0aWMgdm9pZCB1ZnNo
cGJfcGFyYW1faW5pdChzdHJ1Y3QgdWZzaHBiX2x1ICpocGIpCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hwYi5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIuaAppbmRleCA4NzQ5
NWU1OWZjZjEuLjFlYTU4YzE3YTRkZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
cGIuaAorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5oCkBAIC0xOTEsNiArMTkxLDcgQEAg
c3RydWN0IHVmc2hwYl9zdGF0cyB7CiAJdTY0IHJiX2luYWN0aXZlX2NudDsKIAl1NjQgbWFwX3Jl
cV9jbnQ7CiAJdTY0IHByZV9yZXFfY250OworCXU2NCB1bWFwX3JlcV9jbnQ7CiB9OwogCiBzdHJ1
Y3QgdWZzaHBiX2x1IHsKLS0gCjIuMjUuMQoK

--_002_DM6PR04MB657516510061FCFF7755DF74FC769DM6PR04MB6575namp_--
