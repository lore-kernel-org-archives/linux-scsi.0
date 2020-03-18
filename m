Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F159C10DCE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 08:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66AF52076D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 08:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SvWd/t03";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yeUeL3V8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgCRIgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 04:36:20 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:46956 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgCRIgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 04:36:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584520579; x=1616056579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kTDZqZ+Cci2yIZ3WB5hR7miwbECKorCfJozXnVrB2H4=;
  b=SvWd/t0344Y6gqzGNLPVYQo3coh0+p0ohUNaOwl38s7oL3dQu97pU4HY
   D5UCnvO19Sl044rN3ZUfIUJg4oPIuHu+x97/68jQnRuh213B6VnvEzhq3
   Q2NVQymvoQNfyRtGc3MIAk14ZMHayaRpnFmj3IxglOEcZIuqoWpceqcGh
   xd16s1yeKjqRrR8TyF0Gp5xwEVAxMHiTjWl5OJ9NYdCImaMDHv/HTyy1T
   H7G28V4CMygBX7h056TVGmCS/5fSrYPfZ3ZbRw9Ozi4+9LPaxqwG4h3Yc
   pV8SzeWaA3juMFtLVmLQyIunK3u2W09DvK1TUKLUMsKvMkHAu8u+t9/Oa
   w==;
IronPort-SDR: Ex7j509d8ZfM5HuMsDorOQZJEVl75u8UapKFrJwIIxUi4MQ122GICdOeirrHrxbwrIvp+Ped2i
 /L/seHYr+EX4XMEpk8J5ENylOf3HmQbHqFWkhdaYf+SumfeVfFNWYybpWRlfyVpXvqIEdKIOMU
 oQzZcjA3PKfSLJh7CKW4lFHm8UQlwYFVkxeiVLRK6iUgs60BeIw9CbPTdZrvPn5xHzDPEbvpwa
 3on2nx0EyBO+Ofy6fMyQxpfKyImgqnm4VcC/r4rO2WJ2sRVficg3lWpEmh2+7pjtCs00I3AgSx
 l6k=
X-IronPort-AV: E=Sophos;i="5.70,566,1574092800"; 
   d="scan'208";a="132831515"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 18 Mar 2020 16:36:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfUaj+ORrWeFnh1SRx5K7UBsHdoDmQam2KWoes0N82vLJ9kVjUFCCAVFaUi/2A+5Hwkr/CKvk2k3vXiviwmCqlf6mOHIF3BiH443dpHhxVX5nf8oRnEX0ZojHcXWcDIinFnrN9fy02CisDGsbHTyLT/kYQMq7ShO8Dg9dCLQlPcDlQYxGk37/iCyDz7uu4fkmNXy4Ez7Z5lAuGpTnc5uJcfN2SkeShW9xKzJ2rmWtNmMbQBuFecBCekLcKmmhstptgF0dPJRKhM8MBJyjxOU0AX1L7LY5KzJ4W8XpnI+6tSwzwEM0/3O4pTgZP9hrrxMoTGQJ40XKXs9PbWuhT6AEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTDZqZ+Cci2yIZ3WB5hR7miwbECKorCfJozXnVrB2H4=;
 b=VYOFOkbx5rOvIqlOPDAcWAy8OTzwntMkXEJOwPR5fmbfF1T++Uqo+mfJCCa/2bVqJQsqB+Lhdk2AZrsUu6zyygXsP5y8YQNpWNOfVmGhIlbKlFk3wBoZtz+A4uI7nk7IhEPhm34oN/nr+VLfof9j2GcblH3jkk1Y3C0vktzdMNxDALxkryjaNesSpVseQqNTdoblrK6yTtDfkhiBKZTNifIII1fhG3+MyWlwmx9T5gLei20+IE9kpnUZH5UJs93t06hAtuYejHsYavr7+RvMakp64CcpaXdLzxyHLpej5nA5u8+zckIDtTGp5E461M94Zhw0aggcAOguKIWyZjjdJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTDZqZ+Cci2yIZ3WB5hR7miwbECKorCfJozXnVrB2H4=;
 b=yeUeL3V8GTaowbX1BXFUTIUfxUUkFCSiRz3/dUulhm6niV5qgQ8MxcFxEs9rt3MPoFiD8Uf8PPA8cGujDbNdrai6OfLWVm+t7OpC2n5byNtVlRdoRFjku6nMD5nfjQmk3wLEEPcGpxa0ZinmZaJVEgEEKqBHyJ/GZXNcJzCTwvw=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4814.namprd04.prod.outlook.com (2603:10b6:805:b0::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Wed, 18 Mar
 2020 08:36:16 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 08:36:16 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
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
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: ufs: Do not rely on prefetched data
Thread-Topic: [PATCH 2/2] scsi: ufs: Do not rely on prefetched data
Thread-Index: AQHV+2Fz/ktorSMsl0u3fCEPwdu7N6hOCR/w
Date:   Wed, 18 Mar 2020 08:36:15 +0000
Message-ID: <SN6PR04MB4640313249285DB4E56678D9FCF70@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1584342373-10282-1-git-send-email-cang@codeaurora.org>
 <1584342373-10282-3-git-send-email-cang@codeaurora.org>
In-Reply-To: <1584342373-10282-3-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4ed08e72-8564-413b-c7f5-08d7cb176c73
x-ms-traffictypediagnostic: SN6PR04MB4814:
x-microsoft-antispam-prvs: <SN6PR04MB4814F98125E855EEE776ED0BFCF70@SN6PR04MB4814.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(199004)(9686003)(64756008)(66476007)(66556008)(66446008)(4744005)(55016002)(71200400001)(26005)(66946007)(186003)(52536014)(110136005)(33656002)(316002)(54906003)(5660300002)(76116006)(478600001)(2906002)(81156014)(8936002)(4326008)(86362001)(7696005)(7416002)(6506007)(81166006)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB4814;H:SN6PR04MB4640.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XTGee1z2REfYV+3+Yv38eHcgjuGv+0rJKQMZsjG0FBYy3EC7uSiH3Ht37UCVJ45tsytAFABIb17DUFCfArfxJeVAXJCuSg5EgVp3BAs/evNZc3MYjVXHMFl9HhL5b9bSeH8PEjy4vW7YW7x11F/3G0JC/t6+XWHHQoj6tu0G5Q5zk2V6qXK+Pyc1P4yTJVqHKdMSPRTEpOr8RsxybayuOyEZVytINgNoN1dPwzUKLBMgubNZ7ziXKQRCK1k/5qlUcMThXvOZ8SIcDOZQuscnFyS4Rdri+JNmGuIMviVrHtcwVORdU1JUpVAVRynaQ8vjzxK7PgWK1VtTdSATv1KKLhA4VnDUZhMrSt9xNio/gk8YJnt2IXKBwRO5+WYI9Se5tO9TkTifS3EHJne4PY+dEeVZIp5p9KnbDSHaW3wbYrGNuGdkb2FFVSKyiJLV/8Lj
x-ms-exchange-antispam-messagedata: qJlbqtPwxSSfe/SfC+rQ0/cBXTVY7i8hcpO2UjykTL/RuxXlq6gT0mvE/f7MSfEXbkl0A7rXMx8uj5CpluUo16NKCHhBp8n5nFFWigsJFUmk36LrvhRcChusupHyrhl1Wi4itxYzFOA/t9atOGoyaA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed08e72-8564-413b-c7f5-08d7cb176c73
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 08:36:15.8559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IOST9AMlSl6VEZbN0P4x+asAT/asoeMora4mg9t1fK4VRXoNCS3+1+M3ooN1zizh81quMtwUz6UH0dVxn1rn6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4814
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> We were setting bActiveICCLevel attribute for UFS device only once but
> type of this attribute has changed from persistent to volatile since UFS
> device specification v2.1. This attribute is set to the default value aft=
er
> power cycle or hardware reset event. It isn't safe to rely on prefetched
> data (only used for bActiveICCLevel attribute now). Hence this change
> removes the code related to data prefetching and set this parameter on
> every attempt to probe the UFS device.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Thanks for fixing this.
Avri
