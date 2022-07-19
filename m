Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12B5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 22:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbiGSWon (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiGSWok (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 18:44:40 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036B46111D;
        Tue, 19 Jul 2022 15:44:39 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JLcfMa027451;
        Tue, 19 Jul 2022 15:44:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=K0siLZcQUBC68kiIuDJZ8E8DRtXQuWGgf3kGNd2906s=;
 b=Hg0Xnixzi2WkKgmaKRW3M+ybt9f+18RlT89NABD4nKOi/P85ZuAIjoQEW42CCR0IdJTi
 Yws1cKHcHdkhrx70uuKtbNu+MN7swBLfM7MpcCw71px2XtzCBIswL/rLxj2za4X/lwrf
 c/mWGKw/x1JZFRxLuYgWn+YsRfWhfnFV4MittlMxTXWe12L0FjwlgYgiIkeyxRpyJDM0
 Pc1XTqUgUJJQDxfLBOoot1L/wTl4DKs3LiqHI4+7xeZGJxsefD6SqcZXf29Tm6VRl6pJ
 raLQVEi5EFGI/47X5neje5sZ3xTBSlCVrA8EUTFFGRN5dTPdZRRQZjjKJKlxI9uHTJUw iw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3hc6dep68k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 15:44:37 -0700
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 76C6B40088;
        Tue, 19 Jul 2022 22:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1658270676; bh=K0siLZcQUBC68kiIuDJZ8E8DRtXQuWGgf3kGNd2906s=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=F3mtoOZadUN0a9BZy6feBD2GD9479dV0cAQWUPxarJ0GZv5EaZqp7x/yowEHynPym
         d+yz5ZpyOs9lvgTl/xyAkM++WsKj8v/p1XTXtofCzhDOkjWlI/QtfEJyXYg6tgQBg5
         9G/RbYfcY/TA6buBG/8kwEaicTe/8BHnmfHpPX5wflemT6/U4EZrN7lNcpMqHy2e0A
         K1vA/kBD59X97zj0X8YHwdLBSVN0p5b6rN9gBIZoFDu2bzZixnNtd9Z5VB4M+tRPRo
         tC7praJdS0XjX/+wmh4SJPzfg5wW/BSTE4WUZsBaE74qRTXUEZoyYoCSd83WEhf8KI
         qCoDYWpDZGVzg==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2D1E2A006D;
        Tue, 19 Jul 2022 22:44:36 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id A113140085;
        Tue, 19 Jul 2022 22:44:35 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="HiAzYdJS";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eauobz9ofkhRWdiP6ymvWd33dtkBfFEMGboQzgdaU9seVaBClWFE6DTfAdrj2LKqlSZ49aMXhDPuoZua60jo+RAhgiVfnmqloaYZRVm5C2l6ibS13nzBtd87yKOtQxZC8Ts4DEhPRXtf2RTUBRwMoiYuoR5tnJ1gHCM4uVhMbXH7ef4g0xSJwDlEHcRwsMc5GUwQ9faFC6MeoDEsoLC6ecjbYzRvei+NsB+csZOBGl3y7ObIUCUwcbO7HOUxQe/+HHJ1k7Xsmb25fcQPb8yTd9spP7gb5zYVlaZ5Ax7C+vAiYbmsS4JnusM1nhJvYKh2eELjJimU1fVCma9RhiGdLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0siLZcQUBC68kiIuDJZ8E8DRtXQuWGgf3kGNd2906s=;
 b=dIeRP+y9XCCX/dm4YCZLhLpxnTpF9I/THi/Sg8wfuAq+BZ80YA1tyBHB11ewaZI2KVIQobQKUXWYi7DaLATUe7zLRRvnzTRNDdySTAz/a9Xr+LKacXjSobWS1BXqTYih64x616/xL8cKYFnXBkS4DwrwJla9FMxpwQ0tsunup8eVqQcURkl2R/7xV/0TCxZfF7NbN2y1pQS788J9FK16OY6wy3vmAYKCL+nB/zIpCFsMSIcMbTZOFQB3PnOxbBzzLxr6VPJBzYh3p2nPf3UeuA0XqBN1evF8+JUd0IY8tzlWPzCYGVeUiNP11Knf0ttrObV2Gr0cVlVjiW72CiCfyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0siLZcQUBC68kiIuDJZ8E8DRtXQuWGgf3kGNd2906s=;
 b=HiAzYdJSTpxnsy4oYqtZGZkvHJXbK7TLyN6VXx3NtI8fMSTFsjfRG3pjQ/xOZVUAbWBu1i/wWe+PcYUDYU6Y8HnkFyPrL6M1OtohZbtL7rNroP/ea8AOJkQPXgTgTbN04TNhpB+4SYZz/NICSaJTzgiePEyBNWjqxDMia3fO4NY=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MWHPR12MB1453.namprd12.prod.outlook.com (2603:10b6:301:e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Tue, 19 Jul
 2022 22:44:33 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 22:44:33 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] target: Handle MI_REPORT_SUPPORTED_OPERATION_CODES
Thread-Topic: [PATCH v2 1/4] target: Handle
 MI_REPORT_SUPPORTED_OPERATION_CODES
Thread-Index: AQHYmxQ+O/Ca80DV0k2VfbAMW2WndK2FsZsAgACad4A=
Date:   Tue, 19 Jul 2022 22:44:33 +0000
Message-ID: <42d3c473-fd59-587a-9df3-3e946577e578@synopsys.com>
References: <cover.1658195608.git.Thinh.Nguyen@synopsys.com>
 <41806206e78812afe97101a11881f5a33092a93b.1658195608.git.Thinh.Nguyen@synopsys.com>
 <YtayPpMGagzPSff+@yadro.com>
In-Reply-To: <YtayPpMGagzPSff+@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90cf3636-d516-4b93-d868-08da69d84025
x-ms-traffictypediagnostic: MWHPR12MB1453:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t7d6r4XtABJxeGxMoFC9mnfABoKzbLjhTgPCwczsNzDQJvpyza+5EkFCZeqn8OCGybYnjDxdL7zXUwdX41z88YhEuelmhdrcLuRQp5+HFEWv3XFeSJYQFGE2ESF9JbCE7mOiRvcak8K783QCVWOTpqsv+sgA2NkcIlA2hVoGE+4HAOTgiU4klNiF3ZdNFF9LeTkmib/6a0+mF/AS0aOGhvMr6KCA9k8RLQiSN3Oga56Goa8wi/45ArOKv0bvVTmy0xyUVnKXQBk95WMNo3MCmmqb89du36yHkYITi9Y286wouOzAEkrB6rUe67uTd2Lu9C5rWUbmVLG8dZ/Iy20zIDotAOugjrrawqDAZ8GT7/8zERbmP0bcDcyx2d9mzq/08UtjPAC+HVb3H8sDmI3mPoQdJpzuABvbwznf7XJ3X75CKIsktq0EnpBRFON1bt09mYuuD7LearHCcESsWPA2UA4p4ElCc8pdg2zuNI2+HspvpDQ68uBtj0UkfjYp6L/3StR4c89dfVMibYsnXcj6gFtSCr8iCpaypnM+hpmXi5EsrJmP4xHSU6iUdW5XkJH5opV9PoG7eIPUkohplhyPpPAFtKLvHJW8axNjrAsLa8wt2JbSkDAmGfBHMjACwuHjAG9t1Z8fjKXKZ3H5TrZVomDhlcy2L59N74Q1nzGhgmz9vTh9GESrhr1Znz1Mu6g2lB/8ZD8zL4/6zZLvYn6u9V9L2Is00OAMbgbv4J6xm5mMwaiTI7ddHX7lISStUro82Kra2vZhq4neqzV/bM/drMLR/9S47AaIaBASlZkxFVZEFjockzJwu+rQZUmkpdjQ0h04FclWwx2Ss0zqH+9WvG8feJZRcrK9K0pg5yx8cYfWZ6h/BPJX6ctS8uMzERxeY68G0I8JYvoupyXRNgkrMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(396003)(366004)(136003)(110136005)(38070700005)(54906003)(45080400002)(316002)(6512007)(4326008)(2616005)(122000001)(41300700001)(71200400001)(76116006)(6506007)(31696002)(64756008)(66446008)(8676002)(186003)(31686004)(86362001)(26005)(5660300002)(8936002)(4744005)(66946007)(66476007)(66556008)(2906002)(36756003)(6486002)(478600001)(38100700002)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmFYczdKUjU4V0JuUWgvYkN2cWx3WTJGbXFKajlTY0dQTmtBVDFNWGlxeXAr?=
 =?utf-8?B?L3pXV1crMHlPaWxNWGRaaUFoTzg2cGdXU1psU2x4TkZkdS96MlpjeFZQM0Ny?=
 =?utf-8?B?WWpIZkhrQ3dvS1ZsQXpJQlpQVjV1QytKUEdPazdBbER3MHc2ZDdISFFUWEgw?=
 =?utf-8?B?c2V3emxDbUtsRTlLWEtNWTNTMU9hZFRhYkM0dDFmWWpNdDBYTlNsZnZHS1hr?=
 =?utf-8?B?OE9GTlBGWlN2ZTA5NHd3UncvWEFFM002dGthbDRIVURTQklvU1RZY0NaQ2VS?=
 =?utf-8?B?L1BnYXNVVjZEakhDY2wxaGxPcUE5c0ZXbzRLOEh3OVE2VTZNZHlEbkJ0ckhO?=
 =?utf-8?B?TTA5Z1FOT1RiNm02eWZiMjhPbmhBcVl1cmNpbWlHSXBEUmNHbEZTRm8vNUpY?=
 =?utf-8?B?RW5oVGR1Zlpzdk42d21TTHdZYWJXUFY0QzlxOWNCTmRycUFZQ09zY3JFY0g3?=
 =?utf-8?B?QTdPVWdKazVzS2s3Y1MwT09EU3BvMjhqc1RyenVtZmpiVlFnekFlNnRKQWM2?=
 =?utf-8?B?R3BJQ25tRXpiNUFJNno2MVVncDlsZ1hyZ2d2cHZJblpUT0d0SkJnV2phdGlx?=
 =?utf-8?B?TGlnMVZoaEtvaWJmcjgyRFVzTmZiU1hmQW1VdXVGbzd4QVlKUXpYbWVud1VO?=
 =?utf-8?B?eG5Ua0NUNGswZjJ2eVVEVEI0Qm5SNTRvUkFiM0hLV3pNemsvbEZ5cHdaZHF1?=
 =?utf-8?B?aDRZZWZZN3lxTFY4VWFiWTRsOUhqTUpBT3VUVkhURDQ2Ty9NUCs3dGdEbDFw?=
 =?utf-8?B?WDlMTEd1UEdGbUp3aUUydm5mM29WakYvUTFtcWJ6OXZIRnJuMjVaYlZvUjEr?=
 =?utf-8?B?L1p6QXhnRmNmajVCR1FjcktOdlk2dGpVYTU4WU5UU3EvdE5odUJFVW9IQXZ3?=
 =?utf-8?B?bExJU3JtYXlMUkk1MzMvRkc5aUtkMWVSZzh4cHZQalNMWDFaYmNjcWNaWTVH?=
 =?utf-8?B?VVJwbmJEcUUzOUI4cHdJSHl0bXp3NjR0M3p4RlNmZFhqbjVtK1p1aVhORXZy?=
 =?utf-8?B?bW5iT3dvMU9WM2t1VmwwaE55b0ExR1FBbkFzTk9oZFNNWGczV05iazg2ai9z?=
 =?utf-8?B?cW55Q0t3U21NOVJSRFpTOVZZTGF5VVlianNmZmxObk9VUHVRSVNqSy90ek5s?=
 =?utf-8?B?ckd3Q25JVkpVQkszTC9IK2M2Q3ZpVjRzaFAwSUxmL1REekRPb1lCY3JQTTRC?=
 =?utf-8?B?TUVvRUJJdmxYWEZkNXAyYnJzaDhPYVlJZG5lOTE1K0I4aFFTd1dUb2xNZmRE?=
 =?utf-8?B?bG9VTEFUbjJ0S3FSVTVXRkFld1NyQVIzY0FZQU1yWi9TTEVValRIeEpKQ2Uz?=
 =?utf-8?B?MG92UjM3aTRKL1VzUDFXM2Q2V1liK3Z0UXNrYTJMZTIyV0F0d3BEV0Vzbmox?=
 =?utf-8?B?L1ZmVUEwajVWNkM5WjErT0ZBdVNkV1paUk9mZmF0dkRVc0pjczJSQXdoKzJT?=
 =?utf-8?B?RmtVN0h3VklkemlnVXFuTW0xNGVpRHZWbGxzbFdROFZONnV1R0FHNjZ4ZEta?=
 =?utf-8?B?MldJai96UG1nWHZ1SVB3Mm1uR0x1SmJobE1QZVdHNlRjMis5UnRabFhKeThx?=
 =?utf-8?B?ZS9BRWQreGRaaVNuRm5yZGt3ei9iU1d2cjJiQ3ZHdkpvMjdWbURCOStEY040?=
 =?utf-8?B?VmljMzVxWDdzakt2eklnZEZzV3lMTms2QU1iNXI5bVlNSzBHR2UvOUVXRWNE?=
 =?utf-8?B?NnNpaFF2QVBXNlB1RzRjT0NKZmZ5SnRtNGxvNGhoM2VUcllabXlJRzV5YzZJ?=
 =?utf-8?B?dDBNZjZveS9HbzNOM08rNDR3a3pEUlVEeWY0eUdLU0ZtM0NmSVNycGZ2WEdP?=
 =?utf-8?B?MW53MndpbWMrOU1WWjhidnVtRWU5bU1ZeldrYjI0TkVIUS9IUm5COTlUQnN5?=
 =?utf-8?B?UW1RUDVpQkVnMVZIU2luaml5RTFnNGczNllsYmJ6QnVublJiS2VIRTVGUnph?=
 =?utf-8?B?NzdkUERGWFcwbzVqZHBpaFRXS0tMUTQrWkNOTXdxcGVOMFRlVEdBQmUraU10?=
 =?utf-8?B?RjVLNVlHbysxOUVhU2Y1Z0JzVFJFaXlyWFlXUWlBRW9oOEZka0ZkNFVBOGJC?=
 =?utf-8?B?KzNxNWl0VVBrVXVhVktkS0xBQkpoOU9nT1drK3BLaGdyNzZaQnVUOVBZaDQv?=
 =?utf-8?Q?TdTN/vXN+HWjzYhsRBEBW3DxK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5B902B40C158C498BF79BADC3B5B699@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90cf3636-d516-4b93-d868-08da69d84025
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 22:44:33.5795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jcON3/2NUce0vjsG65bmEqWG3dWLT+EYysvOaGRp2wyHnz49UkosLvYhfQs/9PZQCbUUu1JFMKalpYZdI6lMTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1453
X-Proofpoint-ORIG-GUID: v7eu0fTbWyK_I5g2jd9LO-liTjpgXTX6
X-Proofpoint-GUID: v7eu0fTbWyK_I5g2jd9LO-liTjpgXTX6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_09,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=987 clxscore=1011 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207190093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy8xOS8yMDIyLCBLb25zdGFudGluIFNoZWxla2hpbiB3cm90ZToNCj4gT24gTW9uLCBKdWwg
MTgsIDIwMjIgYXQgMDc6MDc6MDBQTSAtMDcwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPj4gTWlj
cm9zb2Z0IFdpbmRvd3MgY2hlY2tzIGZvciBNSV9SRVBPUlRfU1VQUE9SVEVEX09QRVJBVElPTl9D
T0RFUy4gTGV0J3MNCj4+IGhhbmRsZSB0aGlzIE1BSU5URU5BTkNFX0lOIGNvbW1hbmQgYW5kIHJl
cG9ydCBzdXBwb3J0ZWQgY29tbWFuZHMuDQo+IFBsZWFzZSBzZWUgdGhlIFJTT0MgcGF0Y2ggc2Vy
aWVzWzFdLg0KPg0KPiBbMV06IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2xv
cmUua2VybmVsLm9yZy90YXJnZXQtZGV2ZWwvMjAyMjA3MTgxMjAxMTcuNDQzNS0xLWQuYm9nZGFu
b3ZAeWFkcm8uY29tL1QvKnRfXztJdyEhQTRGMlI5R19wZyFhU1U1MHhrRlV1Vy0xT2JvOW9TZ2Ry
Z01WcGp4YjdpZGJ0S2hOenhDYVk0VWxiWXhjTmkxTEZvenIwVThpcTlKZGp5WldHUDB3TENKTHEz
cWd3SEhLb0VpUVEkDQoNCkdyZWF0IQ0KDQpUaGFua3MsDQpUaGluaA0K
