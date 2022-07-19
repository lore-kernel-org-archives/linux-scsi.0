Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6C9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 22:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbiGSWs6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237322AbiGSWs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 18:48:57 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2A760532;
        Tue, 19 Jul 2022 15:48:56 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JLmUi4008395;
        Tue, 19 Jul 2022 15:48:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=K5AZoqI4q3vGEPZ0qp0OHo2v3SlmjAYIz8Zm9X7qB1w=;
 b=c5QWG+w3Sjy2Bc6gJ2VvDQsibVpqOIjwOQN9GmPgQ9ny6Tpn/h1xxbLI2jY9elg4OCT8
 +AkKBoReZlfMl4Ng3JvTtw36r/F5Fjc+Z/F3iQg4VxMlk4Y+E4F16bfZsJQWk8E2UJtF
 XhNv/XgbSeELMDiG6bVKkM+AgpBX+kLlMORFW41uCX6nhoAQ9OUYs2AgcnDChU0a3YXm
 m/1WeH1t6COsN3NLbPEi9kgT7iGJCwB+UHsUWRWJeRdR0Bad3ouPXxkWPby05HWX6eGC
 pk8r29TR2RTs8ZZg9sbnUZQIWDFlgl9T4GnNgpvcYMW6YTkKZmO/VZZdeZi3+Lzto4MH lg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3hbvbn71dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 15:48:55 -0700
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 40A1BC0649;
        Tue, 19 Jul 2022 22:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1658270934; bh=K5AZoqI4q3vGEPZ0qp0OHo2v3SlmjAYIz8Zm9X7qB1w=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ipevy2EaiydGVH0qRQHk/TVuV/RspSYSfM62tmqVLwWjEy1M+4BKYoou4c5ZThiem
         XEnS66/spPxvKs1Udsb9lRlsFNRk4vzNoSl0SeoBK/iLGwAnsMTEObmFoQMILduZEo
         xRUqQ3b7eenfnqv+3xXsy1/f0g8zQH+rqYqIFxn0O8no0O/Vt9WyZ/YFrA1GK8iOCv
         Owy3Y4vIX4AmvaEKYChYrarOrJA1A0LHI+6mv4+z9xspDokqy2ohnE8+m9E/PiltZp
         EjHf7x9hmNjEnhguWdG5Tw/0xQbz1o/Gczc06Nan6DQ9WR++QPH1IP9AuAwBU0CF0O
         5P/Syxg+Gz4nw==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 9F23EA006B;
        Tue, 19 Jul 2022 22:48:53 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id BD20280199;
        Tue, 19 Jul 2022 22:48:52 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="Ld3f4f1x";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5Dei1+KQwhiwmXivmoGhc9RwY9RMZaZdl+Jh3Z6xJuUjmXSXGAIFCim+im4XWgTgwPhEjhpy+T1dGaP3nIJnQKxmtChiDM/v8vBmV9vH8UeO8c7+W/aVB1N8cO7Zuzi65zAli3mTUeKc+iJ67haDz5fluVwTKrVWoIBqaphAnCYX+CTJA5BzwllIR8UYbeKl8UbDTZ/MZQd4qSczQLYYVWh7oFbrzfvNBqB2jOjNlscNnEZFuaq+KPSZ1vQn8fwWz1SkVefgh3MRKXtSodh04HSyJsW2Sd6IVeX0BNNRtAuxbqMu/5v1NTgRDEKBV0HwPZqOMLV8FqcSBRW+o8cNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5AZoqI4q3vGEPZ0qp0OHo2v3SlmjAYIz8Zm9X7qB1w=;
 b=HxXuGDYwDkq0NGON1UjPOtYgGsmDaUJpj6Zlgz3pbV1W+yzMZjLvdk9fNJeAd+kkjNsSBpnXtXzT5CdsQUQ1of/GWVLbnLZIhoAMYb2G/VReFD47iqPR2PY05ZiM9YmiNbcND5HXXCwEigWWNqRkcDenlGo4Iq3dKbzg6VMmuwUa5AKiHiGOVR07wzmtAKhLvZs/NSix2CRigfvmxbHhb9Wa8PDKVevDlVIQzNMl4XtyFH1dzVZs0KYPFipdkQGZLv60NdManeQsk4cq+p5sU+T1MTqArolZMACzS2cn76d2JQOItrLIAQzc8USKmv7mBYPKNyq6PggpeqfhQ4I+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5AZoqI4q3vGEPZ0qp0OHo2v3SlmjAYIz8Zm9X7qB1w=;
 b=Ld3f4f1xnx/e+hPPLJL4gxbggwaPhh4mDvQWXENDC2OTgQSTABfakK5a7CQxL199aCjUmhTS5HMEDv0zxSoKh3dAkJVt5LQxiqgrO6FTYEhE8pwQaAfjhuGp2921DlOXhZZ5hde9iCdQPnYKBqiBQT/jt+HaiOaFA15PirXMGRw=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MN2PR12MB3055.namprd12.prod.outlook.com (2603:10b6:208:d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Tue, 19 Jul
 2022 22:48:46 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 22:48:46 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     John Youn <John.Youn@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] target: Handle MI_REPORT_SUPPORTED_OPERATION_CODES
Thread-Topic: [PATCH v2 1/4] target: Handle
 MI_REPORT_SUPPORTED_OPERATION_CODES
Thread-Index: AQHYmxQ+O/Ca80DV0k2VfbAMW2WndK2F0xWAgAB6KgA=
Date:   Tue, 19 Jul 2022 22:48:46 +0000
Message-ID: <87e6e000-7c77-9e50-4b6a-196fa2a88207@synopsys.com>
References: <cover.1658195608.git.Thinh.Nguyen@synopsys.com>
 <41806206e78812afe97101a11881f5a33092a93b.1658195608.git.Thinh.Nguyen@synopsys.com>
 <33b0ed4e-65ba-670a-8cb4-d95bd4006529@oracle.com>
In-Reply-To: <33b0ed4e-65ba-670a-8cb4-d95bd4006529@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8de8f3b4-2565-4e44-556c-08da69d8d6fe
x-ms-traffictypediagnostic: MN2PR12MB3055:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SRVRrZzOfOBxluEL9uJPfM7ATjMxAGpRV9+8rR7yjjOam0T8Txg54d9gBvlE0WHK3MbPieIw7RyEz0/Ibqg+Xf+2QAgBcJKT7rlNnROv/p4wuOlYJF+aZUq63EvKGtNeRbfyAB4teZc1wjEUmQ1cnB3Tr7EZbCt4N7vWOx466570sh8Ay0snUvNLR4sjMM9/PK1GNvSf4sKlt82iSlJvcyqoQYaOGIzovC5OSHvkO0ox4a+h60gFH0wNIl5BDPNnDB7syGve43CL1UqEy8ZZ2UVJReKyxGN+YOMXFKabRIsNNZeFmHVhk3tzBWd6Vn+fgqyCSEQYbdAZT0H4Eh4c2QhZu0UD+P/9zoh8pR0pQl0lRD1m142WD2fW0JbrTPrgze6SDHpn593UafjNUBURopayYyAULUgdMCLFr6NSZHgLL1CY8MO+yRsHs57BWBe7gly3oVqmXRUyo6bsGAQbdn6/rX5ff5qgpAfd5J0NgP4KWy3KZrdNcMYkcXBwcL0ymW+HQknEqU0fpR66mJ3rPV+LYXzRG7rU8fZOozM+WvEdnAMB/qdw68mDw8NquIdCcKG7Gw8fLHHNTRQ28AYhlrdqLJ+l9huOkcsa3dMLmK7JCRjWKuMk7EaUtutIohw3c1x7Ffh81CPz4mdCD2pVkDfQVG7f4PIb7XjIlp8P5DGiMjmir79dUlGps8dfvzyy6X75dO1nvjJyoZ6iSxTNJGPBPNZHMxwLSbtdIIM+3VQoMz58oIOiu8PGLVZKGjATrz0SvCiKJMnfL2pn8n88McWyO/i4H8bhETpKBYttLWH6C8+5ikBqq4aiKbXGYth2ZdovZnCpMv61154H3kBqAPwv3xMKqZfFS0v6XNYC+vRPCVjNtQtxC93eBXLuj5Whd/2owL6FUTevC2bzdg01og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(366004)(376002)(39860400002)(26005)(45080400002)(2616005)(6512007)(64756008)(186003)(41300700001)(122000001)(110136005)(966005)(36756003)(6486002)(31686004)(66476007)(2906002)(478600001)(71200400001)(54906003)(8936002)(38100700002)(86362001)(316002)(66556008)(66946007)(8676002)(53546011)(38070700005)(4744005)(6506007)(5660300002)(76116006)(4326008)(31696002)(66446008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzFCcWVXZ01hemwzR3BGQ1VvUVZMME0zaEdGUHBIR3plakpYSEUxSUE3RVB3?=
 =?utf-8?B?NmhremhtSnp6ckFaUGRLNXB5WmVuVysvVmYwUmdabzBoRHQvVThDcDJOSHNx?=
 =?utf-8?B?dHM3MkxweHMyUlJaZ1Avak15aUFYM3JLck9ZUWdZZVhrVjBFem9BNEY4ZjBJ?=
 =?utf-8?B?SFNkYVBPWEs0dkJ2bi9qNGJrb2NqRzZ0UFF6Q3h2QTNsTTcrWWlVOGllSjU1?=
 =?utf-8?B?Mlg2ZHU5aTQ3R0JvNEE2bXdSMVM3b1BoN2N6cGt6WkM2bENFZkJhS1VoOWQw?=
 =?utf-8?B?RVp1dzVydVdCYmFqS1pxTVhYNGFaYkMvVWgwcXFpZXhDSGpnRERZaEZrbnBm?=
 =?utf-8?B?LzNiMXdWaXg0aTlLQ0hOcFJubk1EVFFDbnEySllTZ0wwaURyT1NSYnFhYWd6?=
 =?utf-8?B?SzBTL3VoUEJoclMvallmRjJzY2NKWm5FTnd0WWlnSFJSbkFFQkNTMkJlMnAr?=
 =?utf-8?B?U2dKT0lHcVJ6OVFQRHFDMk5nVGtpcVNwVGhUYm8yMGNTWGt3RmRoMXdxZDVJ?=
 =?utf-8?B?SE9iZUZTODVjc2kvYlBacm9Wak9KRjkxRk9nQTJGTFNGaGZNa0VyMWhEbzdC?=
 =?utf-8?B?Nkg5VEdPVVpTNG5sbGJtcUE2cFgvN1pSZGxFU2J5VGo0S3pGQXBaSk1ycVhw?=
 =?utf-8?B?NUtXazM2NEx0aElQTlVXZTFyQmtmVktYUjBFNTZ1NjdqNE9zRGlNbXlPWkRj?=
 =?utf-8?B?Q0dreU05ekZmeHZZcEQ5VVo3dE5IcUxRaWF3eUpSMlBoNk5hYzg2U1Q3Rjk3?=
 =?utf-8?B?OTZCcW5zMEdHcHJoV0NZME4wQ3BaNFExaE5Ec0NsRGttbjlYV3laekI5dUpI?=
 =?utf-8?B?T0JsTTVURlU2SGRVVVc2VjdyZUNCb1NUZnVhVW1ja0lOMVhOaHR1SGtjN1Jl?=
 =?utf-8?B?WUhvQ2J3UGVJTXBhb2luWndCMFZKK3hhcWRIRGEvMzdJVDI0WjNlL2hTVXRW?=
 =?utf-8?B?TldnQkVLaEVDeVhHQXJtUjYyVC9mTC82c1J3amhkRG51KzN3R2trbUNjSmZV?=
 =?utf-8?B?U1FXZDJvOVQzQjhLbnI2Q0pCZSt4UE4rb3VESFJQN2JWWVNFSXBUR2lndlV5?=
 =?utf-8?B?eGxiTVVVRVlJcWdLM05tV3o3blJuS1pxTFNyS0ZhQWhINlZNZGxMYm1jVGVS?=
 =?utf-8?B?QjNuT2x5ang5emVmeXZVLzcwaEJtWFg2UWsxNFJtSFVWZTVvN1hlTjRmU3Zk?=
 =?utf-8?B?T29JWWxnWnByV1ltNFJiRlFqZnVOS0tjald5dWVrQytNMW1YV0ZpNTd2VjBV?=
 =?utf-8?B?QXBJR1VEOHV6bGM4cEcwQ0YrMm9Jalh6NThkTGtscFdqQ2o0L0d2amFvRkNZ?=
 =?utf-8?B?bWM5eXBIb0lwWlIzdmpyOStEZGdGbHBnMTd1eStTL3lYT0Q3Q2pZa1BwVUdz?=
 =?utf-8?B?dXlVVVBLR2pzdnFmcVo0dzkySFVrdktqN0VNQVo3Y1lBanlXM0xtZXViNy9a?=
 =?utf-8?B?anFtN2U5cFBLcDNaRnNGRzRRUkxRd2lsU1hVYWwrbU9tWjZNbkhieGNCcXUw?=
 =?utf-8?B?b2J0V1lYdjYvaGFMY0FRRkZKNm4ybHB6cXZ4d1pEVUZkZjNlVC8wSkF6RnhW?=
 =?utf-8?B?Wm9abGl0a2d5cGowaVQ4cXVCNWxOYUJVZ0dnWm9ocDBaR0kxRk84bk1yZnBt?=
 =?utf-8?B?emM5OFIwNVRocUEzZGZ4L09XcWlCdno3MUwrVjJTZVJ0TS9jbUNYcVQzK0Y5?=
 =?utf-8?B?blRlU0ZUZnFPOExoYlZNQ1BXVm1DbjVsMUdxZ2hjUXJqWnF0SThIaFdPOVpX?=
 =?utf-8?B?RStvSWRtOGc1akRJbmlNL3ZzMWhmbHlEYzZYY0VxSGhvL1R2VGdacTlhMkNx?=
 =?utf-8?B?Smt1RFdtV0tRQW9QK25kMjBJTnUyZCs3ZFVMWGNnUysvMjFlTmpNM0t4Ritn?=
 =?utf-8?B?Y2s4V2s3U2JacXduMktQRFJrcHRRbm51Qk9GTTdNWEMzSzJzQzRrRkVPaS9B?=
 =?utf-8?B?bnBjZUFLRjRySm1reVp5VmhERjBwa1BlellBWjQyTXVIRU1VOXEvUUJZNWZT?=
 =?utf-8?B?eGJzdkVhUEIwTGFYZktzai8vdkM4VmRaQUQxY2xGOGNsWG5DTllkbjF3Yjk4?=
 =?utf-8?B?bUYzbTRFcmZvZHZnWU94N3hCNTBXT1gvaUxpL2dCZ0hSM1kwMHpUbFhieXRm?=
 =?utf-8?Q?WSofO6p+ZmRX+NvzcEEC1cgNL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E7908C194FF194992860B583F181041@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de8f3b4-2565-4e44-556c-08da69d8d6fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 22:48:46.6722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E4OE8Ev0ZnM5qLR6njQUht+CjO7J7HwlWHUKFE26e8SD+XoawCqMcjokj99EaFsBjrAxrZD13qidxaPIGCO9Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3055
X-Proofpoint-GUID: h4LmkQaNu0hM5EgJkZSqjSNT-NcBvpgx
X-Proofpoint-ORIG-GUID: h4LmkQaNu0hM5EgJkZSqjSNT-NcBvpgx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_10,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 clxscore=1011 priorityscore=1501 impostorscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207190093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy8xOS8yMDIyLCBNaWtlIENocmlzdGllIHdyb3RlOg0KPiBPbiA3LzE4LzIyIDk6MDcgUE0s
IFRoaW5oIE5ndXllbiB3cm90ZToNCj4+IE1pY3Jvc29mdCBXaW5kb3dzIGNoZWNrcyBmb3IgTUlf
UkVQT1JUX1NVUFBPUlRFRF9PUEVSQVRJT05fQ09ERVMuIExldCdzDQo+PiBoYW5kbGUgdGhpcyBN
QUlOVEVOQU5DRV9JTiBjb21tYW5kIGFuZCByZXBvcnQgc3VwcG9ydGVkIGNvbW1hbmRzLg0KPj4N
Cj4gTGV0J3MgY29uY2VudHJhdGUgb24gRGltaXRyeSdzIHBhdGNoc2V0IGZvciB0aGlzOg0KPg0K
PiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGlu
dXgtc2NzaS8yMDIyMDcxODEyMDExNy40NDM1LTEtZC5ib2dkYW5vdkB5YWRyby5jb20vVC8qdF9f
O0l3ISFBNEYyUjlHX3BnIWFkR3NkbW5BV3ZmX1VSWk9tc3o4SFRHeUtrX1V5RmU5dXJodEYzU3ZJ
aWd0ZEd2VjhOd0dROVRFNDZjd0RQTjFTUkpDSXlzemFxdlYxY0RGM3d1SHN5YzliZkNtdW5ZJA0K
Pg0KPiBJdCdzIGNvbXBsZXRlIGFuZCBzdXBwb3J0cyB3aGVuIHVzZXJzIGNhbiBlbmFibGUvZGlz
YWJsZSBjb21tYW5kcy4NCg0KUmlnaHQsIEkgd2Fzbid0IGF3YXJlLiBJdCdzIGdyZWF0IHRoYXQg
c29tZW9uZSdzIGFkZGluZyBmdWxsIHN1cHBvcnQgZm9yIA0KaXQuIEknbSBkcm9wcGluZyB0aGlz
IHBhdGNoLg0KDQpUaGFua3MsDQpUaGluaA0K
