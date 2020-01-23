Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C72C33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 23:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E2D21835
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 23:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="Lz8+ARta"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgAWXJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 18:09:36 -0500
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:51041
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727056AbgAWXJg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 18:09:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X22wiXcewopjOqsmzKBchIGcGBpAHRR0vH0dLFaxOf/S9SZzmJv8mMc9ppbnkeWju/xgdMZiUThYHDBhx2gU9aZqJxh48ezdRy2A8qHxfjER8nQggLdMrivsmOW7mT8D9gRFpIZ+dBTGUHaZfC4vBgLxw3AkQGYeiZq2dr8KzrIUXq/3AQqGHLzIHFk2GYHhUDZSXHWQlB7LXAxAw4hzxmvpJREHQjfZHDBlij0MyTTEt7mRWzFJ+aVz3Bu34dYei7w6dJMnUoCCsy7jeP/CivaQ0ur2u1NYCQOMoP8mySt1V6lJGnOD+OVqAOLar1YFrugKVJhNeKMU7e55ddkTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k41R4cJlHs3A4fvr4R1rXw5XwgdcK02Vhgt2B3OIbqU=;
 b=d07U5bF3L93x1dTNiLnBq0kJrrsmWUBSvAbTa+eHNcsXZ59RMKqTEWcXh315jO6AbmwXune+XyHQS2Et4bwyrs+PErLj0nGUc8ANNvtLjgZ4bsAEibKqESUAd31hke/yj/I3cIOUDUMI4ISFFvEcOLMN5ulr+DTQhXS50P9K0RX7LNR77XiQ4Jo5BPmqeU+7MQgMv19WB8JNN993D/hf29a55gAyM8BrTsGxEXC2GlgIq6Hob7Mw7mufMmApt/Y/n3jaMB0hDocumNWnu91jgG9CMD8PyenEZkNGpgw2thl4P0sBuk1VJKYvCnhYadB80giNK7xs5GePdsieEA4dkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k41R4cJlHs3A4fvr4R1rXw5XwgdcK02Vhgt2B3OIbqU=;
 b=Lz8+ARtah5vOgvQK+louRCwJLTsPpT8VBXl3iRUQsjDaS7Wy1Qqzughcnk6w1frVRlgeRU4Y/FJ6KiX3OpF2PrhWTg1jghKp1kUDcXT+B1u173BjNGrGbjFZsqJ2GBSyEegD39XRPhwWhkZ8GpQKtX9OPXGKgM6oKGcKnyqDMfE=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4146.namprd08.prod.outlook.com (52.132.216.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Thu, 23 Jan 2020 23:09:33 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2665.017; Thu, 23 Jan 2020
 23:09:33 +0000
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
Subject: RE: [EXT] [PATCH v4 1/8] scsi: ufs: Flush exception event before
 suspend
Thread-Topic: [EXT] [PATCH v4 1/8] scsi: ufs: Flush exception event before
 suspend
Thread-Index: AQHV0b5gyvtnMcTz1ketHJeig0sH8Kf44HvQ
Date:   Thu, 23 Jan 2020 23:09:32 +0000
Message-ID: <BN7PR08MB56848366A5AE715C879B7436DB0F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1579764349-15578-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTY4MDUyZWE5LTNlMzUtMTFlYS04Yjg5LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw2ODA1MmVhYi0zZTM1LTExZWEtOGI4OS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9Ijc1MCIgdD0iMTMyMjQyOTQ1Njk3OTgwOTcwIiBoPSJFTGxYRzF6UDhYa2NDSXdVdHVXQUl0RWUxeEE9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUFxSW1FcVF0TFZBV2s1L2FZNSsxa3phVG45cGpuN1dUTUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQS9oVEN2d0FBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92ca06f1-153a-4d30-45b3-08d7a0594ec1
x-ms-traffictypediagnostic: BN7PR08MB4146:|BN7PR08MB4146:|BN7PR08MB4146:
x-microsoft-antispam-prvs: <BN7PR08MB41465D9C2CED0D565D1647B7DB0F0@BN7PR08MB4146.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(199004)(189003)(15650500001)(71200400001)(64756008)(76116006)(66946007)(5660300002)(66476007)(33656002)(66556008)(66446008)(8676002)(478600001)(4744005)(7696005)(52536014)(7416002)(81166006)(55236004)(9686003)(6506007)(316002)(54906003)(26005)(2906002)(186003)(8936002)(4326008)(86362001)(55016002)(110136005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4146;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XvjRC6kDPAfOgtznGYMZcIH00IQScroFHDggJHS2AUnW6SB0++P5k+1B2IzjhNXxqTTfMPR6s8P3n5AFVLMdBxGbFUemhJk2R0eYaAaPadZd2nQJjgl2KBzumReiSbDR2Uq7EXEqsV/PYngcoxTr6VNfVskSaWpGV/WWC2jGaaj3qr6poYCKSinevA0bkyHAXPVu6m2Yi3lQWnx3LIAfKdYoDGGJyG8EacHpsn4lf6Xx7Yrl5dnmOSet52KQcJmkZfVdrTDNHa19weUT5DS+gNY6cCk6uklbp6jhupV6rh38STUkcajZCXSNGjDBi05ZcZjgieq1OZL7d6g65mkulVqrWtzQ1NJksiEcceqz9+GxMCz2nMxttRiLhksYkHTbhm2tajjYUBL7h0K6PtBrVPnhKPIyoS+A2CG9MWvcAfu+b3PtDyaLK0zUAyaxuGCB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ca06f1-153a-4d30-45b3-08d7a0594ec1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 23:09:32.7208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5mXe//2WnX7q35xfEgGv7LJqZlXGcHbUmc8MROtAc/epp7RRDwBrmWqy/WHDrTAqM4Zo0cssdV8NIeBD/Z4yGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4146
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi, Can

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
Rebased this patch.
Thanks,=20
//Bean
