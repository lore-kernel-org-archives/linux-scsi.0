Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BC3C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 15:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06A7B222C2
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 15:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgBFP0d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 10:26:33 -0500
Received: from m9a0014g.houston.softwaregrp.com ([15.124.64.90]:52802 "EHLO
        m9a0014g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727512AbgBFP0d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 10:26:33 -0500
Received: FROM m9a0014g.houston.softwaregrp.com (15.121.0.190) BY m9a0014g.houston.softwaregrp.com WITH ESMTP
 FOR linux-scsi@vger.kernel.org;
 Thu,  6 Feb 2020 15:25:35 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 6 Feb 2020 15:23:00 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (15.124.8.12) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 6 Feb 2020 15:23:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ayv5AV6jsHNPRSrpNUwpMRNxfsK7TFWUyhcQiiNZRzTNHFivFsKk9csy5KV0YQPal5YQ6gmEfqWaG7qm2Fiij4zffHST+fybc27YHT98/eGl60BaKWdyBl+3rNN2zbgFC4BoeuD22CX/l9CKXXqS/qknaiTu5IiOrLaksPrY/cdXYB0Il3JEY/m5pKjCT4me53HN3dmDcomI6wSiUiuZbKHqAjG4FnBNGtRlGoQq0HQRoqEVrfhq7Fs64Zqg9SwyWxz4lQiJqGujDatBYdrgcyJu8UPaTajNlTLyLTn/6gf4EEMR7TJeQYBxlngIBDIJVfIwzQHioY6XmtkBB4alSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7ng+O2i6YqenVr4xS9a8KtoVO6qVKMwRtKK5vm+QK8=;
 b=am83vmj/q70Ar4eBpS71gQgcBSVzFRONlN8zQYGdhx795SPbTQbSC5Wgy7tmPG8O/inqgkC2VCTu9Z9FQ93iY3YS+xrv8Gw43hr5ZSNdOG4IS0ZE/00xhAy75yW4S3kqAiFXVoo5dBRcqEsmmylNQWt+EoQ0skeIghm2sloW/ZWcffAuOC1KJoeiN2bI2yZCl+6SbrwvGlUcWI9bLJUXYaFfs0elAlwW2mQ8bA9RG5uJcpbpAQS4Qjl5XIbV1J223sqZ5FKLKzGi0c80tXtaHdudhx2Z0Lg1t225CtS2W8bxmC5c02b/NTNzTjGsNoIxQBsemlbyRo2Cj/wqnbx+iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from CH2PR18MB3269.namprd18.prod.outlook.com (52.132.245.10) by
 CH2PR18MB3269.namprd18.prod.outlook.com (52.132.245.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Thu, 6 Feb 2020 15:22:59 +0000
Received: from CH2PR18MB3269.namprd18.prod.outlook.com
 ([fe80::a9e1:c2b0:3b67:abb3]) by CH2PR18MB3269.namprd18.prod.outlook.com
 ([fe80::a9e1:c2b0:3b67:abb3%6]) with mapi id 15.20.2686.035; Thu, 6 Feb 2020
 15:22:59 +0000
Subject: Re: [PATCH] qla2xxx: Remove non functional code
To:     Daniel Wagner <dwagner@suse.de>, <linux-scsi@vger.kernel.org>
References: <20200206135443.110701-1-dwagner@suse.de>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <57515620-6680-8a7e-2ac7-759f059f79bf@suse.com>
Date:   Thu, 6 Feb 2020 07:22:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200206135443.110701-1-dwagner@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0078.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::18) To CH2PR18MB3269.namprd18.prod.outlook.com
 (2603:10b6:610:27::10)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by LNXP265CA0078.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:76::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Thu, 6 Feb 2020 15:22:57 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a8bd5ce-18b1-4612-f4c8-08d7ab1872bb
X-MS-TrafficTypeDiagnostic: CH2PR18MB3269:
X-Microsoft-Antispam-PRVS: <CH2PR18MB3269F4EC8520B2B4B547646ADA1D0@CH2PR18MB3269.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(189003)(199004)(2906002)(6486002)(26005)(31686004)(186003)(8936002)(16526019)(8676002)(86362001)(6666004)(52116002)(956004)(36756003)(5660300002)(478600001)(81166006)(81156014)(66476007)(66946007)(66556008)(16576012)(2616005)(53546011)(31696002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3269;H:CH2PR18MB3269.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rFebeYEjT/pFh0xSg30qoQA+c/pjlDGncifaVxAn1q7HwKWOyK5UNuIU21yOUMtj4O0yNSTAJ/WIDKe1iXoj+ipR4sewspKH65Y/pfxH08LbMTFdf0SyR3/22Cs29x9ZtegI0hJgBwnb8PZolqem0JF0/LaAVc0p3/DCKEfo3MumRpYURy8cd2gTacs7iOm3euG7xjtw26RMb3QYl+AxmtpNvQBnlDhPJtS9vC7KMEv3KqBKUdJZ84bCVm90bMwitCTKp9V9iAkqKXJcMSCC+DtPVUOqwFIMPBgAUPMS03qRIQeRxpm755JhUh8nimL+flFsCn1enwx9vXLAYTuxCwoR4o7D4hqjwZG79XGzqOfuEZenUP3o3U+03iDEA+bGuYm+x/2hHnuPqbAUn27pzpdspBNLi4FXy3/vEXxdDKsLiyvUdFU2kuU+jtvspmxW
X-MS-Exchange-AntiSpam-MessageData: YUIJTvFr+iRWFhg8fp9+0pzRMwIpleYvWreNjvwiz9IShRk/Gl+ix+KzhfGqNYdxSGkrwXsa1A34ENtg12OFDIacyGgLlc5A+qwwjx8M/LpSfAMWMNqFel+zn0nl9puWbcOHRERMCuCCj1bKabD2RQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8bd5ce-18b1-4612-f4c8-08d7ab1872bb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 15:22:59.0638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ETdp6ks37bBCdN01gEnqf9sp3AGADF2Raq3WoKNjbYp43dWgAk3p23u51QHHJI4PtUdZY7TC/E9YhTvesK5PKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3269
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/20 5:54 AM, Daniel Wagner wrote:
> Remove code which has no functional use anymore since
> 3c75ad1d87c7 ("scsi: qla2xxx: Remove defer flag to indicate immeadiate
> port loss").
> 
> While at it remove also the stale function documentation.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 23 -----------------------
>  1 file changed, 23 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 79387ac8936f..27a5d0c7e246 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3909,19 +3909,6 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
>  	set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
>  }
>  
> -/*
> - * qla2x00_mark_all_devices_lost
> - *	Updates fcport state when device goes offline.
> - *
> - * Input:
> - *	ha = adapter block pointer.
> - *	fcport = port structure pointer.
> - *
> - * Return:
> - *	None.
> - *
> - * Context:
> - */
>  void
>  qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
>  {
> @@ -3933,16 +3920,6 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
>  	list_for_each_entry(fcport, &vha->vp_fcports, list) {
>  		fcport->scan_state = 0;
>  		qlt_schedule_sess_for_deletion(fcport);
> -
> -		if (vha->vp_idx != 0 && vha->vp_idx != fcport->vha->vp_idx)
> -			continue;
> -
> -		/*
> -		 * No point in marking the device as lost, if the device is
> -		 * already DEAD.
> -		 */
> -		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
> -			continue;
>  	}
>  }
>  
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
