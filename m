Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA22C33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D4A320718
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="4cWDWbC/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgAWWyv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:54:51 -0500
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:48609
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729259AbgAWWyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 17:54:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amas9H55vodIFokZUM2TgTOCEk6hBzWpEUIWU5JcE0++WLBC+xyBgkWPk9YdapR/F4gDIBF7/w87rinr5MZ8SHrvLieJLnsMFicgWxGmy1pGgXHacZuQcIulHSreOqBVmpKeB/zxUnSALb49LFBFh7mXNVVhf+eACwZiP+1gg6lEisb1v/Q7cZri49hYmtTnd1lMHyJicTboW1xlHz4Dut+znGBqI1AVwXbM9m65wAgbSc6QcxnAocKG1HJ+k0/jvWH28HnIgfZEvstwpn6POK7I6yv1DJ4UuthWtY9WXuqbgpuvvPpvD64NiyF8gJNu/uDYAZ6+iSk3OcMPimx8mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQHSGT8zZtT+nSYPAo9CVLpbIisIDPJSrcBn9qzV4Xs=;
 b=I7tlRDZ+OoSM98nUW0INfAmaq5iC3NfM+YwZz6Oi+1d3ofkVvSiCLHUFsUCF0e7vo1ENNCgLE+XiobILPPNdt/KhPLDrve0QwSzQXFSHzG7m7L23kuV0rISZIpqwlaN6GP2+Qf1PwdfVxbHyFq0wKNayqNdYW8gpuB1GLZU05zoD8gDBdN7MjNJoMcctyTItHah/tcsYjVR31Elvu6n2sCCrc5/aGPLXVJvdQ+pfyFnULXt+0o2i3w0yGZCh11e9e8ZMzDC6Yi4lwepyc0BNiXbn8lbujTP5bvRYADX7ZHVp5elhG034XxWWIcfXzlbGD4w7T4WX1Z9mJvt0XY5cHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQHSGT8zZtT+nSYPAo9CVLpbIisIDPJSrcBn9qzV4Xs=;
 b=4cWDWbC/ADfmJ00hcrIKFxVrZ4nMkgSYHfR9q6VIOMw0ZkxAs5YZprnjl6BqCN2PWmerwm8Yq3ZCRClqEUb44eUhjRZ31VuJs+yTCxdKq1Hyg/Szu2lo5bt906qsUyWL9aOSD7Amq3hmX3xiv42MwL9KLSdBiUHWciyzkWUcXAQ=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4051.namprd08.prod.outlook.com (52.132.216.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Thu, 23 Jan 2020 22:54:48 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2665.017; Thu, 23 Jan 2020
 22:54:47 +0000
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
CC:     Sayali Lokhande <sayalil@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v3 1/8] scsi: ufs: Flush exception event before
 suspend
Thread-Topic: [EXT] [PATCH v3 1/8] scsi: ufs: Flush exception event before
 suspend
Thread-Index: AQHV0bQixOXh4tVDZ0qqd1mgEtErcqf43D8A
Date:   Thu, 23 Jan 2020 22:54:47 +0000
Message-ID: <BN7PR08MB568498BD4EEF948B38FCC0A1DB0F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1579759946-5448-1-git-send-email-cang@codeaurora.org>
 <1579759946-5448-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1579759946-5448-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTU3ZWU3Yjc4LTNlMzMtMTFlYS04Yjg5LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw1N2VlN2I3YS0zZTMzLTExZWEtOGI4OS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE0MDYiIHQ9IjEzMjI0MjkzNjgzODI3MDY5OCIgaD0iVWhESVhNQzdVVFlZTm5VaUhQUlBpREJSa0dNPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFEcXJrd2FRTkxWQVNPaE9taXEwcFB3STZFNmFLclNrL0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUEvaFRDdndBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3aac9745-7f5b-4b7e-955a-08d7a0573f1d
x-ms-traffictypediagnostic: BN7PR08MB4051:|BN7PR08MB4051:|BN7PR08MB4051:
x-microsoft-antispam-prvs: <BN7PR08MB4051AE1B01EE97BE35CE3BA3DB0F0@BN7PR08MB4051.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(189003)(199004)(478600001)(8936002)(8676002)(71200400001)(86362001)(81156014)(81166006)(6506007)(7696005)(66556008)(55236004)(76116006)(66446008)(66946007)(64756008)(66476007)(316002)(110136005)(54906003)(15650500001)(9686003)(4326008)(55016002)(2906002)(7416002)(5660300002)(33656002)(186003)(52536014)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4051;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tpFT8C2VRkL3wvSdWSXoRQat5c5M6myZwCxMebRhaQYdyTS6DHgStNkVsGI+2SYYkydz7ztSOol1lDl1Locp37XDjW/KUgbJ4BVa5Bak/0Jzi46KHZUczn8UBKiwZ2yfekXKSauwQ7rxGrfOjajAxdJYugyB+1x66W/6jS6DpjsjCLhQsy37ks/YCbMZ1bE421p0qmqUBLSQIGSdwHZSm758GyAThsLNa9W92KVhUswBmdO630CWmwwiLuG0lfu4wPZnq5qmM8nrnKh3JmZRj0nn8p29b3O2nOJRtFJJ7FAJqYB+LcP7+Kh84AAbrMrVRteQbmzor/GW6FUteb2GIO5cRnLvV1hCFeYs/lgJ0kqlY1JXe8KThy5e6zbi/JXIBHXG+GBwn5kNpjDppa34l37MroIvtBrKUD7ZDV5A8IaiMuEN+C38eqWUffW/QZ1n
x-ms-exchange-antispam-messagedata: A0ZA8iEI4UOwwSsNerkLdmtyVTwIHlGFljOXxlCoi2ghUTePsE3Na7x5u+ghHt90vxkUXun5lGp1QrwGwIJwmVTHCiHgEO9nyUDBObT2BvIWkp82D/MmYL9WuZA4DXwazmpyVj7TMDZGrKjF6X+MDQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aac9745-7f5b-4b7e-955a-08d7a0573f1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 22:54:47.4458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RfxxzRxOnXBECGnFgh9OZk9HxySFh4L5TOKl65yrLEnJCna6ah8UBjtnWxrh8BnSU9prADEkpCqETYlxzzZvkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4051
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Can

>  			 * UFS device needs urgent BKOPs.
>  			 */
>  			if (!hba->pm_op_in_progress &&
> -			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
> -				schedule_work(&hba->eeh_work);
> +			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr)) {
> +				/*
> +				 * Prevent suspend once eeh_work is scheduled
> +				 * to avoid deadlock between ufshcd_suspend
> +				 * and exception event handler.
> +				 */
> +				if (schedule_work(&hba->eeh_work))
> +					pm_runtime_get_noresume(hba->dev);
> +			}
>  			break;
>  		case UPIU_TRANSACTION_REJECT_UPIU:
>  			/* TODO: handle Reject UPIU Response */ @@ -5215,7
> +5222,14 @@ static void ufshcd_exception_event_handler(struct work_struct
> *work)
>=20
>  out:
>  	scsi_unblock_requests(hba->host);
> -	pm_runtime_put_sync(hba->dev);
> +	/*
> +	 * pm_runtime_get_noresume is called while scheduling
> +	 * eeh_work to avoid suspend racing with exception work.
> +	 * Hence decrement usage counter using pm_runtime_put_noidle
> +	 * to allow suspend on completion of exception event handler.
> +	 */
> +	pm_runtime_put_noidle(hba->dev);
> +	pm_runtime_put(hba->dev);
>  	return;
>  }
>=20

You should rebase your this series patch, I installed your patches, it fail=
ed, there are several conflicts.

Thanks,

//Bean
