Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF8EE92703
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 14:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjJEOWT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbjJEOUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 10:20:18 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2081e.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::81e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7216D10F
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 19:56:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcKqoZhSCt86xrfhL15KDnbOJT/l3kfIb79moeQ1HT2VAW91rAmPgQteRxwQByCh8KdBbSBASeeXdMH2Wmal1D/T0BN2CJHrl0dg+tdv/yunL2/6YuxVje6YbI/hSrurRV3Wr8cNg7o0iCBQxY1FFpnZ7MEWvyVaHmb6WWgX7COE8fyv5PBEFxO+cXy3Bq8g2627kYDVZyoPoPOBgmosGHnSpm2ZjxWyiiIK/BZvo0BTns81SRlJRgxDtm5Tewv4A5kdt0icGZnciYpfscL9VbrS03u+MwdbiX7oT+pmvhrUvVuYNrOnb5SqGtd0KVoQ2Tnq6RR1KmyJ5rxe0USYCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71ciRhf9qQ3wjDKsqGKqMsP7OuEHk/q4yhAjX7L/Qn4=;
 b=PDWXaY1Iy/EcJgp6AWxh1bs6Eop2Lhy/j6WdaJBtLPqg+uQQEcJ0Mknc/QWvNHkA7gNg2WHNonr2a2FUbvhSh8+kHlkbss4d8gQiA3Zc6pHjiPyo7rmF04OBSzpwnixVoFB3m9WV+oWVHIkVA6v30Mj/nCKwYYffA3IwWzF2iPbwi96RQqwXehFSLvrJAqOMzHbU48eeo0Kd8ecbKkThyVq5Y86NLdBRr/08KxTQW5n4CIyPNN0skX9GZ4sLAaVTGYt5qYLuQHXonyZO056k8HqXALniLq0c8I4wrFwAXqKnnNfHdmwSojdsGmDhJxSTrMR3Fs3E5QxLJZ4Zxdla2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71ciRhf9qQ3wjDKsqGKqMsP7OuEHk/q4yhAjX7L/Qn4=;
 b=AgWMLQYUq/Kt2gkOnNgWmfTZuMX9deP1Qt/6BAYlkcg6RcrHomwDhetrSnnA4wh/t3+VPmtc3VZwUA+FER0aEA5nH2qwJUcHthB+hMnL0kUgkIUOhal0+uwJfaH5uU2EZ6CNsrOpsasmOknKPkCip4sa7ywA9Cp4tgyJ/44bDQwapBhbOoKh/R/iqV4mPjRE5EWke/a81XvF5JGRjb3LUvYoddLHggHJ/2VnEbaHVEZhLLyFgwNpmdlVmsHjl+ahob3WDnA0JkPO9eVlgA+lAMvcSCPEmLzmXSF0Fr7eV3WpJyDsmQZgu8cG9d7NXDdmOhwkk+4GlmlpkjOXV8Q3QA==
Received: from TYBP286MB0207.JPNP286.PROD.OUTLOOK.COM (2603:1096:404:802b::15)
 by TYVP286MB3652.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:36d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.26; Thu, 5 Oct
 2023 02:55:55 +0000
Received: from TYBP286MB0207.JPNP286.PROD.OUTLOOK.COM
 ([fe80::376d:6ccf:bbf9:5f6c]) by TYBP286MB0207.JPNP286.PROD.OUTLOOK.COM
 ([fe80::376d:6ccf:bbf9:5f6c%4]) with mapi id 15.20.6863.024; Thu, 5 Oct 2023
 02:55:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   hikingsale@outlook.com
To:     linux-scsi@vger.kernel.org
Subject: Re: Fiberglass Insect Screen/Pleated Screen Mesh
Date:   Thu, 5 Oct 2023 02:55:54 +0000
X-TMN:  [YHlpAoue0QFR/mfe8DXqODO4PtXc+gLb]
X-ClientProxiedBy: TYAPR01CA0036.jpnprd01.prod.outlook.com
 (2603:1096:404:28::24) To TYBP286MB0207.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:802b::15)
Message-ID: <TYBP286MB02079B9256CD0FEE16E120A0CDCAA@TYBP286MB0207.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYBP286MB0207:EE_|TYVP286MB3652:EE_
X-MS-Office365-Filtering-Correlation-Id: efef0a68-b912-40b3-741a-08dbc54e9817
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcLd9JimXjbQb4Qqr3fX+gspBZqDuj+1fhQ2QHb/PvxpW3QvhtSt8ZQWMvzo0twvLYyvGhSUukCEOjbSuXRCJTOUwNPkHOwDfx9WUR8X/QqCMAFcbIHD7SpjOiYuCy2kG1EvOHWns3ccUp6tFUuN6r/zMjgjaHljnPkCr6uqbsfeknRcU1ES3ds/jquG1IliYBsSfqDay+OAsr5cLeMtYSw7+swm7smeCh/WdowYTkK6FKBK7/wCcuFiKDAIA2D3pbZy+vV6TmOVFItl1P7XuGB41G4rUM0ad/QtWU3J5j30TyI5fAl0MpuM+B2XQ5eMI6p4ZgnRBf+2k0Hl45KNss3BnQF+y0UThe9V0wG6/X75jMrcO3uDZLlsGsBnRzSUIUG6TpKBLXdk0BxJKBjau5hXcGRL2Ix4UwA+BgJZMICyn6HKkeNFJkG8IDn8fmu9jEpwczr0Nezn6AxcMAF47PH4v6Dc5iAwHQsmK9CzsCOhBdZknHvtCLpOqt6xrhAOfnvaJ/F5fkUevbm/MWs2Hhkg2zc/4IyUhsrIs8eZ097MmlKxQcYsXRMPiy1OG7nW
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWRxaTU5dlpWaDJTV0k1ZFFGZTRscnBjSWR4ZjMxaHBoM25PYml1QnRxK0NB?=
 =?utf-8?B?RW9FeklueHB4SjU2NWJRWnZ2OWpwaUx1YW9TWi8raTJGYW9vRnhCdytLYUpH?=
 =?utf-8?B?bnp6Wi9FOGwzdkoyZmc0MW1uZW5RaWcwaGl3TFFKSld0SVVCOTh0SDVyaXkx?=
 =?utf-8?B?cHhDWGNySURnUHV3NHN1cm9KT05DalRKRTNZSDVjYnBJSFByN29jOTdiekRl?=
 =?utf-8?B?VWYyL2RCdEkzbEpLSVcwTWtwdHlHVG1sVDRyYW9QNXJOdTU4dWZPWjlTZklq?=
 =?utf-8?B?NzRoaEtpK0pBOVM4UzA1eXpSQjAyc25XNG4yeW8xVGUwZEV5LzJIbkRpcWxk?=
 =?utf-8?B?SU94b3NxdFRRMG1kOEE1bk02d082NGJ3SnI4KzJBRzBOM1Q1Mnk4YW5sNHp0?=
 =?utf-8?B?MEkwVTZ4N2IwODVkL0p5a21oeDBTMVV4NnhJdDBnQ0orek9TZDVCdG1kdmZl?=
 =?utf-8?B?aEdlOUwwVEd5bXg4eXdHcnlqbmlhcG9QWCtNM2wzKzJYUFdzSi9KUDJYMGZv?=
 =?utf-8?B?a1RsVUl1VThJWktubDEyRmM4d3NTSzFNZndhNmxwVTZmQkJOeVB0QzBiSU10?=
 =?utf-8?B?US85dUxvUUpZY0o5WnVlOUtYY0pReTk1WFU2Uk9CeW14Si92VmRTTkkreGFE?=
 =?utf-8?B?SWNURE5hNm5CeDNBMUp6TmpPTUdaNXFmR1RJTERMeXpYaVIybnZkUkJlNTBC?=
 =?utf-8?B?ZDZLUlUrYU1rd21vL1ZXK00vdG8vTU96MVdBUjhHNFhhUXB4dnBKckRvc212?=
 =?utf-8?B?Vzkyeks1N05XTzA2VjR0ZENlSTZYa04xT28yL2NHNys2Nm1HVEdTMzNFSFoy?=
 =?utf-8?B?STFMV21BYXh1dFJpNnFMeVZIY0hBNmZ3YXdJSGxnZ29keEFDTDFVTGtFcDJ0?=
 =?utf-8?B?dWsvbWVzYmtPT1BETnNnbmlxMnp0ckdKaFgzK0tkaFJPOHFBcTVyMmljN2VO?=
 =?utf-8?B?cHhXQUl3dkpsTkoxVEtrb1BQbDhhOXVGYzM0R2dvN2VBV0dGa2VQS2p3WjVU?=
 =?utf-8?B?UjRLNzNvdFJIamF6Um81Z3d1TWpMZ29Td2oxSmE2WFZjalQzU0RGS2h6NTk5?=
 =?utf-8?B?VUVMeEw1Y295b0piZThOZUdya0lTSnFtR25MSUx0NElHZHVpK1ZwWms4OVRG?=
 =?utf-8?B?NmNNNzhQTkE1NXIrTnhaZkpmZThEWG1DMjFlN01CTFZlbVROaFF3TGp1WDFw?=
 =?utf-8?B?T3ZpeFdlcW9EbjNFL2Fqa2oycFlpRGo3Wm83aUJWajVGdTVxeXpMYUw3Wk1S?=
 =?utf-8?B?QWdZUTFxK0w0YUtoclFkelBxbTN0YzRSYSs2ZTNWeHY0RlRJM2tEemh5RkRj?=
 =?utf-8?B?TmlFYmlBRzd6cDdCK3YzdkdMZkRvSlREa1FRUWFldWx5NVZkU2pEb0VTc0Zh?=
 =?utf-8?B?aUs0V3FmUFBkbFlWM0FKNGlFUXB6VEsxUVhUZFcxVGh6R3VPd2NFNnZqT2pl?=
 =?utf-8?B?MTJNZ1pXbkdHQUxYQlRScVVNVmdtRWJ2VTNuaGtHZlFVUWJaaHZGWFRXUDZV?=
 =?utf-8?B?L0o4REd6QnpIc0dXdndqa2ZLZXQvTXlVbzZBUno1aGVYN2FqYTd5N2gxTVMr?=
 =?utf-8?B?SXlzdUNwNk5XWFAyQUdGaHBIZEdOajNoYTVHalNPZVJFeXBNampaWkU2SEpG?=
 =?utf-8?Q?1rLMihUPl96Z2qdEI+EuCmEvkhOP9yrk1+jplFgAN1qo=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efef0a68-b912-40b3-741a-08dbc54e9817
X-MS-Exchange-CrossTenant-AuthSource: TYBP286MB0207.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 02:55:55.7017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVP286MB3652
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGVsbG8gbWFuYWdlciwKCkdyZWV0aW5ncyBmcm9tIExpbmRhLCBhIENoaW5lc2UgbWFudWZhY3R1
cmVyIG9mIG1vc3F1aXRvIG5ldHMgYW5kIHBsZWF0ZWQgbW9zcXVpdG8gbmV0cy4KCldlIGV4cG9y
dCBsYXJnZSBxdWFudGl0aWVzIHRvIEV1cm9wZWFuIGNvdW50cmllcyBzdWNoIGFzIFNwYWluLCBQ
b2xhbmQsIEdyZWVjZSwgSXRhbHkgZXRjLgpIZXJlIGFyZSBvdXIgc3RhbmRhcmQgc3BlY2lmaWNh
dGlvbnM6CjEpIEZpYmVyZ2xhc3MgSW5zZWN0IFNjcmVlbjogZGVuc2l0eTogMTgqMTYvaW5jaCBv
ciAxNyoxNS9pbmNoLCB3aWR0aDogMS4wLTMuMG0sIGxlbmd0aDogMzBtLTMwMG0vcm9sbDsKMikg
UGxlYXRlZCBtb3NxdWl0byBuZXRzOiBkZW5zaXR5OiAyMCoxOS9pbmNoLCB3aWR0aDogMS4wLTMu
MG0sIGxlbmd0aDogMzBtL3BjcywgZm9sZGluZyBoZWlnaHQ6IDE0LTIwbW07CgpQcmljZSBjYW4g
YmUgb2ZmZXJlZCBpbW1lZGlhdGVseSBhZnRlciByZWNlaXZpbmcgeW91ciByZXBseS4KRG8geW91
IG5lZWQgYW55IG9mIHRoZW0/CgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpMaW5k
YSBaaGFvClByb2plY3QgTWFuYWdlcgpFeHBvcnRpbmcgRGVwYXJ0bWVudAoKQWRkcmVzczogQnVp
bGRpbmcgMTgsIE5vLiA3LCBLYWlUdW8gUm9hZCwgSHVhbmdkYW8gRGlzdHJpY3QsIFFpbmdkYW8s
IFNoYW5kb25nLCBDaGluYQpNb2JpbGUvV2hhdHNhcHA6ICs4NiAxNTc2MjI4MTA5NQo=
