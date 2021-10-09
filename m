Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E16AC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 02:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5177C60F51
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 02:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244132AbhJICNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 22:13:10 -0400
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:31712
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231947AbhJICNJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Oct 2021 22:13:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSrXC4M6uv+R+vFrAAbu1J8l0S5xtuQfz/1ySqccL60YOIJIz4gwW5tKWoLK6wyVjnK6dwEyYCZdzgxwKul9Xr8TZl1FMd7dbQtRxBZQVnPv6TLN1a0g9RAXHHdQz5fL0X/qNzkBRT6lhaL/1/NyT9SOkJPegws7hDTrFLDq1zCUTyZUCeT566JOLGvqe8aJ5tzSMRaOU2vXqKFSzqjhi0jwGDjl193Mo+xvAwJ/ZVL7xOFfTsHkPYOnB4ytbn5ntz8+Qg+yOkI5s3fRXtlND6C6/+PD1VNhhbCuuiIU4XZ2JR4X9FDvQhgCSzRDojXg8mMHYcwF+deFbkq27ZWLnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9te389VPVa1aqg1szmxuceeqseT0UbuXKFGAalgHp8=;
 b=bRscECmjIIOvBtN2BaW/NdD1wI4CvOONlFlxoowxcJ/HsILMRdGZlUJQnDr7qvuZB3TQR85KiHsUleIBCG9zeWM5zpwT6lHi2vqUMUCqsWoqpgA0HFR/7BlmXFYiMvegu5KQj21dZ7PAVhOZ0eEzpC0ZOW3KYMj507cBGrhQDoX6mSoyd5ytRMw4JfbpGZa9CBrLSuRzK7jyBi5OsDW9JlV54dCbkZ8IW5SCLzP04vf7IdpvlH7NgoemrqzOiU+B0DySORvsgONiJz+lUVhI0mimtn5h25/Qa5mkF4ITTJMMJyRrEA7mVzX3wJD0ZiryHszj4Yn+XUSHZn950EqGTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=unisys.com; dmarc=pass action=none header.from=unisys.com;
 dkim=pass header.d=unisys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9te389VPVa1aqg1szmxuceeqseT0UbuXKFGAalgHp8=;
 b=I5adnBrCV6vZwIiDgfmfLmpwFo721aQ3y/1Tfq6P4fFUbiRwGbguqJYczGRKpVZCiKqAOWDWCunF18JVG4t1E5sr8XwyCZejYLgVuLGVhYECtXQ6LR2j/3UgUL9e7f/K9PD7ZJbbopEjWgjP3abfyDftZDTiribI/Q1DmDDfJGXWfa02CuopkVGuNsGlzj46Hg3mrzBciZiqCBEskDRZ5l72cpMHC7mRhTkHrpXBryCJT/AjrFPUnY6ZBgrvU8/RXU7dBpqA532dxJBReG6JGkBi3gVTRUvOMyjpcrmFofHDTN25pgKypAV01BO4h3tNeNpeNXBpFbfmcihrkHvEcQ==
Received: from BN8PR07MB6868.namprd07.prod.outlook.com (2603:10b6:408:7e::15)
 by BN6PR07MB3489.namprd07.prod.outlook.com (2603:10b6:405:6a::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Sat, 9 Oct
 2021 02:11:10 +0000
Received: from BN8PR07MB6868.namprd07.prod.outlook.com
 ([fe80::fdc8:4245:7507:48f7]) by BN8PR07MB6868.namprd07.prod.outlook.com
 ([fe80::fdc8:4245:7507:48f7%3]) with mapi id 15.20.4587.024; Sat, 9 Oct 2021
 02:11:10 +0000
From:   "Kershner, David A" <David.Kershner@unisys.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Song Chen <chensong_2000@189.cn>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: RE: [PATCH v3 44/46] scsi: unisys: Remove the shost_attrs member
Thread-Topic: [PATCH v3 44/46] scsi: unisys: Remove the shost_attrs member
Thread-Index: AQHXvIKjs7DE6WwHVEC9pikKxg0ZOqvJ6+uQ
Date:   Sat, 9 Oct 2021 02:11:10 +0000
Message-ID: <BN8PR07MB68688FBCE9D735E8B7557AC6F0B39@BN8PR07MB6868.namprd07.prod.outlook.com>
References: <20211008202353.1448570-1-bvanassche@acm.org>
 <20211008202353.1448570-45-bvanassche@acm.org>
In-Reply-To: <20211008202353.1448570-45-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=unisys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16827adc-31c6-4065-931c-08d98aca0fd7
x-ms-traffictypediagnostic: BN6PR07MB3489:
x-microsoft-antispam-prvs: <BN6PR07MB3489AE49E7C7C03843557334F0B39@BN6PR07MB3489.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j5wGq9ohSlWlFVk5zimbkmNs/R5uLFptI25k7zxkYMAZ4QZn2beYTJ7bkBhOQn/DfrhdZtoPaMUyC/ZMlr4uqdn1H62lqdg5EdQmOpVPHLce0gRhWSGcfpqJ8uuR8gtatRmyez1KbcdIbBy2OYIM/UgpGJWxwJv5t30StldS8aQCRBu0LjLANIsY48N0Q1LtBPGh34DBIPHRdW94KJxxs8+Umk1/48EIYom/a6KfF8V5qh6d/4MubYITfmevhQGD5o5U/2wcCxJgaHw25G9an7wnJEc3HiwtWGLbelZ6ZBxeN6sIt6Bkp2lQvjTEUJgBUev4nXWbi77Gnb6a1wyk/V086LwtlbIUtZxORr3+1AYMcdBHivdGjLpeL2zyw+LVyVk3KPq5eICXZ56Ws2dGqUjUZ0gJQ2897hU6ZeyLtqYPumDVkz0+TvxjjpHqYqH+bW90Qv5KmGcdhw0sxqo7yW739XbKL06GAG33TCUyJkeUsXHmFP0sCcTSr5n4F1O99slZI0q3BUg4pu9145v/5L8VmFExHuQIu9ZRAyScP746iYTTSTIH3d7XlgV3/zzAeQp8X+3R52NtJP2SiGyJgCASqJz4RkWAD3/3XwRt8M0n1TZD/8lnJL6XG7vLAvp5u20kyIfzZtDeo8cuOyYjg52D8Xml8qHKhDhpUbsiBCL9h3PUGBkfjjpJniIDDHBBeuOjrJ0+FenvqKEOmdKJrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR07MB6868.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(76116006)(64756008)(66556008)(66446008)(83380400001)(316002)(38070700005)(4326008)(66946007)(66476007)(33656002)(99936003)(5660300002)(54906003)(71200400001)(86362001)(186003)(55016002)(9686003)(38100700002)(122000001)(8676002)(52536014)(53546011)(26005)(8936002)(110136005)(2906002)(7696005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sixZ4V2O+v3lMoMDyzc2HMQgdrYV5SwePLjNWQX3ojP4yHLX/2V7d9Dkwk60?=
 =?us-ascii?Q?SGbACED+mrpIqAxXGX0uQHpec2lVg873ULcILNLT9eBgqAEu+r0CY+MYECoy?=
 =?us-ascii?Q?Z9jhw3GwsOSzxkKucx+PBkRa90uR1NJ03moExFZANImvRzojNo3kV7nFDbFw?=
 =?us-ascii?Q?xYXUIGiIyRuZcHr/4nIXJaRkGctymPEgvhmkRgGDR9xDpxps51rI2TF/doeJ?=
 =?us-ascii?Q?gOJuyKcctmsjO6h6gNPPwhbhlCrb7Br3WsCFGwd9bTSZGgq6CeSc7VKfTHL6?=
 =?us-ascii?Q?WtyW1MMQkn+daH069iTDYiITs3KY5o5JzXNZKOwLcwG9FdysLEI+1R4WRIN/?=
 =?us-ascii?Q?9hxcrHu2peQeAL0Pm+jnJWTgFzXyY+/+Apn+sMNRlLnftliMdhOvc9kJ3i+5?=
 =?us-ascii?Q?nCEn5NBszYJ1ruHc8uZKPGQkeGXnFaDlu8bsO3WlcYCc0Mq306SfzCb7X85T?=
 =?us-ascii?Q?VIoIu4DgchzQTgF/YnEo/AKl+qLzeJZowrW+OcpnI1hgDChmOIldCiorJjpo?=
 =?us-ascii?Q?3AXnBgZzriWgppBf5fxL5gvwfyR/+60cjYwOk/A2rKtLb955d+O/r7Fd1wui?=
 =?us-ascii?Q?spBcMdaWQKuqK1+R946bbhvn5Y7PddD2FLkJbWv3wGmDJz1feTxEoeLrnAcP?=
 =?us-ascii?Q?wwCQKFb/n4XIfotD/WbRd6RIi4vkp0NBvnGJRMJvqFj9OJ59V+wyWLmsInJr?=
 =?us-ascii?Q?zUqkho5JN0hk08nBq3InRmmoSHQ7RSN/rQA+lYYpqiPuSFx1X5kdKk5qwUW6?=
 =?us-ascii?Q?Ip2TmnGIIZdZ/ITAciIQyAhaVICaA5rwbr5RXvC2pyx6itHemjvxISeycin+?=
 =?us-ascii?Q?TW+2Hwl5VNVoECfEu9PA8Umj7utUzvUdipPf5WE2g2hlAVUNKnlCsZi5N3u6?=
 =?us-ascii?Q?LT5t2/+cRQMOXihetAg6nLy6HAcLm+uq2r1zpDayBS2tWVKeCgSRqFpHxFnq?=
 =?us-ascii?Q?PvFSf3tmAeNn82Y50bMKUDH14kbBPYG31DB3BpJtPlCqLHF4pYYnKXqWPW8M?=
 =?us-ascii?Q?f0a68qPvkMpN6FTgX5cU5ESGNhdXfRDUPLqU7Sxyoyn6PMx75WN6Nsc1Mw56?=
 =?us-ascii?Q?ibRujXsAIJkKtWLI37a1zB3/npQGA8fisBfQV3S9j4CCmvj88TtS1mwX4Q1j?=
 =?us-ascii?Q?I6PjlCgRKd8bWxDFcOVTZ8P1tGAE8xVxQxDm8+r6IvBv6t1L44nu9CGI7fuA?=
 =?us-ascii?Q?VB5Ab3c0ASexb4HVrarc0iv+HDUIh0JR+etJpXNXJoj8R3SYOcLxogrW6PCZ?=
 =?us-ascii?Q?7PbJ+mim3OA17o9TIy6fu//ve4fXetoXFL8IavkBxSjJMogDX46C+moCRtXe?=
 =?us-ascii?Q?O+8R44eLeF1qF3Qc/UmsRiQh?=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed;
        protocol="application/x-pkcs7-signature";
        micalg=SHA1;
        boundary="----=_NextPart_000_0045_01D7BC91.6496E750"
MIME-Version: 1.0
X-OriginatorOrg: unisys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR07MB6868.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16827adc-31c6-4065-931c-08d98aca0fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2021 02:11:10.1626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8d894c2b-238f-490b-8dd1-d93898c5bf83
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MAr88wIcSE8dCCF97zFYzo+X7weSL9txZhWwd+RfZsMO0iVvP6XGewa0IgfL1dH0ma6A/1Eq8YOFh59VZtd91a8r9d0ITcoM5PN9PFAd3D4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR07MB3489
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

------=_NextPart_000_0045_01D7BC91.6496E750
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit



> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Friday, October 8, 2021 4:24 PM
> To: Martin K . Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; Bart Van Assche <bvanassche@acm.org>;
> Kershner, David A <David.Kershner@unisys.com>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; Dan Carpenter
> <dan.carpenter@oracle.com>; Song Chen <chensong_2000@189.cn>; Fabio
> M. De Francesco <fmdefrancesco@gmail.com>
> Subject: [PATCH v3 44/46] scsi: unisys: Remove the shost_attrs member
> 
> This patch prepares for removal of the shost_attrs member from struct
> scsi_host_template.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: David Kershner <david.kershner@unisys.com>

> ---
>  drivers/staging/unisys/visorhba/visorhba_main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c
> b/drivers/staging/unisys/visorhba/visorhba_main.c
> index 41f8a72a2a95..f0c647b97354 100644
> --- a/drivers/staging/unisys/visorhba/visorhba_main.c
> +++ b/drivers/staging/unisys/visorhba/visorhba_main.c
> @@ -584,7 +584,6 @@ static struct scsi_host_template
> visorhba_driver_template = {
>         .eh_device_reset_handler = visorhba_device_reset_handler,
>         .eh_bus_reset_handler = visorhba_bus_reset_handler,
>         .eh_host_reset_handler = visorhba_host_reset_handler,
> -       .shost_attrs = NULL,
>  #define visorhba_MAX_CMNDS 128
>         .can_queue = visorhba_MAX_CMNDS,
>         .sg_tablesize = 64,

------=_NextPart_000_0045_01D7BC91.6496E750
Content-Type: application/pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIa5zCCBJEw
ggN5oAMCAQICBEVrUFQwDQYJKoZIhvcNAQEFBQAwgbAxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1F
bnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BTIGlzIGluY29ycG9yYXRl
ZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDA2IEVudHJ1c3QsIEluYy4xLTArBgNVBAMT
JEVudHJ1c3QgUm9vdCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0wNjExMjcyMDIzNDJaFw0y
NjExMjcyMDUzNDJaMIGwMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjE5MDcG
A1UECxMwd3d3LmVudHJ1c3QubmV0L0NQUyBpcyBpbmNvcnBvcmF0ZWQgYnkgcmVmZXJlbmNlMR8w
HQYDVQQLExYoYykgMjAwNiBFbnRydXN0LCBJbmMuMS0wKwYDVQQDEyRFbnRydXN0IFJvb3QgQ2Vy
dGlmaWNhdGlvbiBBdXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC2lbZD
QvrGbSpvSN+UTDlXBe7DeRFBaDbt7P6aAY+hOCj89xBGZi5NHhqxGk7G0cCViLDJ/zGLMwPbt4N7
PiCEXu2yViin+OC5QHE3xctHDpcqaMAilWIV20fZ9dAr/4JLya0+3kzbkIBQPwmKhADsMAo9GM37
/SpZmiOVFyxFnh9uQ3ltDFyY/kinxSNHXF79bucetPZoRdGGg1uiio2x4ymA/iVxiK2+vI+sUpZL
qlGN5BMxGehOTZ/brLNq1bw5VHHKenp/kN19HYDZgbtZJsIR/uaT4veA5GX7NDcOKYBwTa84hi6e
f1evnheu6xzLKCFfthzY56IEIvnT2tjLAgMBAAGjgbAwga0wDgYDVR0PAQH/BAQDAgEGMA8GA1Ud
EwEB/wQFMAMBAf8wKwYDVR0QBCQwIoAPMjAwNjExMjcyMDIzNDJagQ8yMDI2MTEyNzIwNTM0Mlow
HwYDVR0jBBgwFoAUaJDkZ6SmU4DHhmak8fdLQ/uEvW0wHQYDVR0OBBYEFGiQ5GekplOAx4ZmpPH3
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
dHRwOi8vdWlzcGtpLnVuaXN5cy5jb20vcmVwL1VJUy1JbnRCLUNBKDYpLmNybIYvaHR0cDovL3Br
aXJlcC51bmlzeXMuY29tL3JlcC9VSVMtSW50Qi1DQSg2KS5jcmwwgbUGCCsGAQUFBwEBBIGoMIGl
MDsGCCsGAQUFBzAChi9odHRwOi8vdWlzcGtpLnVuaXN5cy5jb20vcmVwL1VJUy1JbnRCLUNBKDYp
LmNydDA7BggrBgEFBQcwAoYvaHR0cDovL3BraXJlcC51bmlzeXMuY29tL3JlcC9VSVMtSW50Qi1D
QSg2KS5jcnQwKQYIKwYBBQUHMAGGHWh0dHA6Ly9wZWNzMS51bmlzeXMuY29tL29jc3AvMA0GCSqG
SIb3DQEBCwUAA4IBAQBYiof97fGpKRcq4dARLjktwo68ISItT/jTBrpb/yNVY0FSekMfa6RLE6xW
WtcP0yfAr4WSfrlZO+ANNhNZShHR/+VDGtI3+DRFG+bbvo77MTcTFTi3Lu7zMsiOx6iByKDII2Q+
qeUQ9kmxhkY7FEzorXjkJxtXb+3NHavjJZ/FXsdbyd9ARyxdUOVjWKd8hje7uZx/q5MH/edWsCpP
oVV30VlM/5WEaGOqv2CMix8288Yl4XnoVa0nPs48AVBOdyO/QVwwexDyTjvi8G3T0h0MRjrUdKYo
40HnJagJQui+rAC68W1BpSp4WxNtkkyVNlLieQtyuSzQFlWP3jAxeboTMYIDkzCCA48CAQEwcDBZ
MRMwEQYKCZImiZPyLGQBGRYDY29tMRYwFAYKCZImiZPyLGQBGRYGdW5pc3lzMRMwEQYKCZImiZPy
LGQBGRYDdWlzMRUwEwYDVQQDEwxVSVMtSXN1QjEtQ0ECEzkAHrUiOTipFaa1FxYABwAetSIwCQYF
Kw4DAhoFAKCCAfgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEx
MDA5MDIxMTA3WjAjBgkqhkiG9w0BCQQxFgQUTBfvj4QPqN+AnSIT7i73N89h9/8wfwYJKwYBBAGC
NxAEMXIwcDBZMRMwEQYKCZImiZPyLGQBGRYDY29tMRYwFAYKCZImiZPyLGQBGRYGdW5pc3lzMRMw
EQYKCZImiZPyLGQBGRYDdWlzMRUwEwYDVQQDEwxVSVMtSXN1QjEtQ0ECEzkAIdaxs04vuMX+odwA
BwAh1rEwgYEGCyqGSIb3DQEJEAILMXKgcDBZMRMwEQYKCZImiZPyLGQBGRYDY29tMRYwFAYKCZIm
iZPyLGQBGRYGdW5pc3lzMRMwEQYKCZImiZPyLGQBGRYDdWlzMRUwEwYDVQQDEwxVSVMtSXN1QjEt
Q0ECEzkAIdaxs04vuMX+odwABwAh1rEwgZMGCSqGSIb3DQEJDzGBhTCBgjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBAjAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAhowCwYJYIZIAWUDBAIDMAsGCWCGSAFlAwQCAjALBglghkgBZQME
AgEwDQYJKoZIhvcNAQEBBQAEggEAywsCqzcxJX9g1dIEB0zNuVAIq933wWuiLc9dyeqKARczirHl
J5muC8r9kHScPPmxv4wLhisFNChvxEDg7rOT65ska//2uGC6E42cLqIr65r1WToTGdfHYejBubCI
u+9E0avs6P0d/Y7ISiIQnpnG76OS0CE/gFWmTBWFggCLyp6otp+6LVkC7hcP+jg8uogEer9XyksE
DcEIQ+335oslDawVTf657QtlvK9QFEU+OWBsqcAnbQRh4Qb2QGn+C15jNnFiwOP73k+i3eCS3cRC
0d0eSGgg8Zeqwt4hQEHw4rg40W1Q0C02Sb7rYVaqYACU7TWPXaTDcHJxHE2Kpie4LAAAAAAAAA==

------=_NextPart_000_0045_01D7BC91.6496E750--
