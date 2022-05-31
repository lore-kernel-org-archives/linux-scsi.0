Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CABC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 21:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348075AbiEaV5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 17:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbiEaV5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 17:57:16 -0400
Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [139.138.35.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51962E0BC;
        Tue, 31 May 2022 14:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1654034228; x=1685570228;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XfKtO0iCBHg0YHgC//5POBeZCoyEnGBLCY/XTvJtCv8=;
  b=Rz4isDuUl7jBTE/3cf3NdGafjg27XZo0DL239uaUf3S6IbeuhnD5+pgw
   QikRJfeDbapOsNQnyb7bmZx7gu4X4W3RQIq6d4AZhDQJDiouPmso8G9Rn
   YmwQXTLdZ9qrzquHoou5phAXxt8iv62Osuu5rUAOidxrhCFmXbzDPEZFZ
   s=;
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 14:57:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNZdQe18aAdoH6ziJFPKcm93uFlv5IehA7okMhA9caWAkDaIaCKtlZ+tikkFCNsY8F+8RA+2BvKWKHFGl8pJOq0poTDch6n9zgerj9VciLrw2/jGXgLV0UxTVtK0XuG1UMpEgzOHw90zM0R2OENmaFG3c3Zew8TFF7HmcqLLG4Cg6OXC1cE3Yx8Z0kTfX1NMH2LDSlcADccfFOcCuplizHt9QPsWxJHWoiPkMOsxOGamfqpt+PNicfdbGRV3qR6pZ3ub2osxTmcGIk8HhY7XtSj+MTwRNhtB+OAI68A8L/Hqn3Yh7iaXPpbrZZRqECmY+2kR8Cy4PQTQ/uAnzHYtXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XfKtO0iCBHg0YHgC//5POBeZCoyEnGBLCY/XTvJtCv8=;
 b=WFcFyC6+MBagtyUZGJv64sicT0XyP+u+qWVCcaIevzaK7CVNNZ/I9xOdeJ7R4xxfRfB1w2A4z7tkm766GRrSSwkffbHk+a7OijlCe0Xsy0fQapN13jrTfGgKaEQ8f7AVOtIPvuou/g5hNJExUR9/Qcyuo96mqLudW3vUGbX4BUjJSVyyUyOznvhMjr605tDb1WWuTQFS3fssDV+hej7sP/zb0/ck8l+4nz0jV/A4Xs09WXAqvZke28vdi0uEgcJB5A8TdfDcPOGGnnVr9mm36KCi35d0+yDwb+uVm09cA9UqQGTP1uawcH0jVhPJ1NeD/EfaWMCoI9CyaR23C0rojw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seagate.com; dmarc=pass action=none header.from=seagate.com;
 dkim=pass header.d=seagate.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfKtO0iCBHg0YHgC//5POBeZCoyEnGBLCY/XTvJtCv8=;
 b=HrrW1cxhKxD2UisXivIkuKQxBmbrjIOF3NgKjgVdKj5x00rKutSmF/jXi+5GodMTtJ/iFKWdPcmLsZBsaE7wJl526ykQ7FrxUP8E/EQWgyIyG9ZX5DN+9ki6dl764E34ROmvGz01Emo6jAFY7qF/4YWCEx5D/1pHjjF7gncu6QY=
Received: from DS7PR20MB4782.namprd20.prod.outlook.com (2603:10b6:8:9a::14) by
 MWHPR20MB1648.namprd20.prod.outlook.com (2603:10b6:300:13a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 31 May
 2022 21:57:02 +0000
Received: from DS7PR20MB4782.namprd20.prod.outlook.com
 ([fe80::3459:208b:7758:d2ce]) by DS7PR20MB4782.namprd20.prod.outlook.com
 ([fe80::3459:208b:7758:d2ce%4]) with mapi id 15.20.5314.012; Tue, 31 May 2022
 21:57:02 +0000
From:   Tyler Erickson <tyler.erickson@seagate.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Muhammad Ahmad <muhammad.ahmad@seagate.com>,
        Michael English <michael.english@seagate.com>
Subject: RE: [PATCH 2/2] [PATCH v1 2/2] sd: Fixing interpretation of VPD B9h
 length
Thread-Topic: [PATCH 2/2] [PATCH v1 2/2] sd: Fixing interpretation of VPD B9h
 length
Thread-Index: AQHYdRcVFUUVG8J6kU6nGKd1w+kj6605gRgAgAAGDDA=
Date:   Tue, 31 May 2022 21:57:02 +0000
Message-ID: <DS7PR20MB4782A25AD396D20EF23CE64389DC9@DS7PR20MB4782.namprd20.prod.outlook.com>
References: <20220531175009.850-1-tyler.erickson@seagate.com>
 <20220531175009.850-3-tyler.erickson@seagate.com>
 <a24e7a79-ff46-158f-92b0-1f667d4d2153@opensource.wdc.com>
In-Reply-To: <a24e7a79-ff46-158f-92b0-1f667d4d2153@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_Enabled=true;
 MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_SetDate=2022-05-31T21:57:00Z;
 MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_Method=Standard;
 MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_Name=Seagate Internal;
 MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_SiteId=d466216a-c643-434a-9c2e-057448c17cbe;
 MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_ActionId=484e59b3-94ef-4c42-9fe7-ecc059d20c93;
 MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_ContentBits=2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seagate.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29eaceba-61b4-4f3c-dd17-08da43507e45
x-ms-traffictypediagnostic: MWHPR20MB1648:EE_
x-microsoft-antispam-prvs: <MWHPR20MB164821E3ED8A9E9314FE6FE389DC9@MWHPR20MB1648.namprd20.prod.outlook.com>
stx-hosted-ironport-oubound: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vl47NKikuYbCJUKXDPqN1bycodrJuh3OQM6rm7fz91QcsAZNguvcOuFtA7o1m9YfXL7fjnxXWESEs5Rp21jTYKvKFnXhTQ6STH4RGCjZyDTQjBKDSS8AYOEQLOdjGyYW0V7iIkMLnJws9YN+3SERBiELAHtzTNLj2HVKSu/jYUS54wr9IydcO17B7SqeT4zRYS/kCtg/ExQDLPTRiPSmQy/joMUc2619cy3s/x+jvpZbAXk7uNwT+I/9ygqTFdwoDpW2hVpVpQ25X9bkK0upZtEctMenB/Z6ey7FHHuGUhGa923xbi048GxwMsmqOi8eYbSzerM9mSwYNB3MDOJWXZA0g4RUJriOwGoA6678GN3vZIpPjnaUDDFJk/GTiLiu04tLXR3+ckAYCmBnfSepV7AMcXmKo+whFsvRo+tXU8pSkJ+o0DixlCOLEb4sxURdeFzOo2CvRqeTPTgoOgGh1HjRu4PbeRePOoj1TDMzhXkaqvhKlBtJ8nZfZ7sC/dnZyg6cvvZ/XhMClbIFEn/JmaTp+gwU34iE9KPzbNikYzIcrWrkaJck0+x8L/w502TEYHdiva7e3rJlsGIWlHYbgl+z+KsuMwaBJWc6bgvgSZ/BLLBPBfB+3h/DZb/DkP4uRFcExA6m1eenkctnleEeafFRKUeDboOAEIXN040dbugUuL7uh99vXND277V5TzZWx38rr0k2hYTWmiGsAKvvmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR20MB4782.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(66946007)(38070700005)(66556008)(4326008)(66446008)(8676002)(2906002)(122000001)(508600001)(66476007)(64756008)(76116006)(110136005)(86362001)(54906003)(316002)(9686003)(186003)(107886003)(53546011)(7696005)(6506007)(83380400001)(38100700002)(26005)(55016003)(5660300002)(8936002)(44832011)(52536014)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmRubVd3ZE12K3hjWFRRcXhyQTRTWGxXMEZndGF5dWVDem12Z1ZIYURwbVpX?=
 =?utf-8?B?VXA0YnlZYnJvT1RmZFF1QUl1UUIvSHZRcUZPekRlVnAya1F4RDlIZjErdTBF?=
 =?utf-8?B?d25xN3dEQ2d1ZE5GK0RBQWhGL2hKQUc0eFlUT1gyTlI3Wmd4SitwbjJUdnFE?=
 =?utf-8?B?WnJKaUtLQUdxNkJnd3JrZFQ1WHRUeFVLNEFEcEIxSDBGVFBDYndKRG9MeWFT?=
 =?utf-8?B?b09wWlczNnJzU2xzNEpRMmtwUjZweHBxeFFQL0FwakxUQnQ1MEFiUUNQMFpt?=
 =?utf-8?B?SGpRL1Juc1A4WHNkalZ2YVl6cHpZTU9MSzhKNlhPS2RKWURTTktBeUxHNnEy?=
 =?utf-8?B?RUJ1N3U5WUJ0ZTY3N1JCQUx1ZzhTZTFiVVo4WW5MNVJ5M3lHbXgxTjBQMm93?=
 =?utf-8?B?V2drWUNPc09hclVuaXZyWGc5d1VwM2hJQnF1VjJ6MlV6dGVpYXJIektQTU93?=
 =?utf-8?B?QXZ3cTVxYnJabk5paHdaQTE2bGkyS2NlaEtLaVZZekQ4OXpDWStJbHJnVFM4?=
 =?utf-8?B?K3J2U1BvOUxqTVBBVTdjOTIrajBIQWVIUzdPZEE0K1VKWERqOHlpNXN4Zm52?=
 =?utf-8?B?QWxOREVCOC8xL01mc0kxeDZiNENxL3Q4ZWcrM2R4OExLV2FXckF6YkpXcjN6?=
 =?utf-8?B?ZU5jSEVxcFlhb3NJMVJnRExFc2NYbk5oY01MUWI0cDIxV045UmtseTNDbDNE?=
 =?utf-8?B?SjNZZ2NPUk9zanRET3R1OE5IOTJSLzdmRy9pZURybEZrL0d3U2JZb0JJLytZ?=
 =?utf-8?B?SVltWmo5UGM4MWxVbVhlcElwM3NpbHZJWFdIYmVYSHhJSFJ0d0RtTUtva2hk?=
 =?utf-8?B?MDQyQjRsdHhnM082Ujg3R0hNUSsvME1IVDlXS0ZtUDJ6RGFxbS94cnprWFI4?=
 =?utf-8?B?TFNURFl0Y1AvMjVaai9PMEt0ZzczM00zSkVhTlQweFczdkRTRTJyUm5VbnB5?=
 =?utf-8?B?LzdhM0ZlUVI5cXBTRHFIZEFOUy9jKzdQNUd6ZWluNU14RzRUUFFhWlNCLy94?=
 =?utf-8?B?OUYyamtwUisvS2M0c3piRkxqajVDaktnZ1lucklnVzF2Q3JNTDdleExZOXho?=
 =?utf-8?B?dTJLekhaeDhsMHJnaEdGUis4bUN2bTVZWHZhRlBOYWNDa0h3cE51VjA1b2lE?=
 =?utf-8?B?VHNTTVUrT3Q3RWRwcXRuRllkMjQ0bkI1dTI4QkdHUm0vMWUrVTVpRnY1Ym1i?=
 =?utf-8?B?VnhRcFkyNjNWbFJDRDVNcFIrdG92ZitubCt6cE5WZ3NZWjNHWHB4OHlqbi9k?=
 =?utf-8?B?OElhS1Uzam42OTlWdENqMTJFMTNVd2FxUWE3eW9WRHI3eVErN29uUFdsZWJF?=
 =?utf-8?B?Nk4vNVNoWm5YZTRlQWt4T1NOeXNiUEhEUUM0eHNpVTdRL0ZsbjVSTzR0VGF3?=
 =?utf-8?B?NFl4SEIweEVCZ0lIeTRueXlRcXRJM1RoNG1oNDdVejFMcXA0UXZINE5wZ3pQ?=
 =?utf-8?B?N0dEbXNRSmI0YWtOaVN1cUlBQ3ZXNTlIUUhNWjBNV2VoRGcvK3lpaXBQaTFK?=
 =?utf-8?B?Zjl0UGRoUjg0YVhITWRYeExCTDlIR1h2VXVBQ3pFQmFyTng1WmsxMThHZGRz?=
 =?utf-8?B?bElUQmZ4Z0ZUTmZMS3lEcVgyRlNMVWtIQ0Z6amVsQVVjWEhPaDAvZHJtVDI4?=
 =?utf-8?B?b0ZOa1llZzBOeFlJbVdscTBzN05idjNWeXVyQTYrdG56M25yUGJCVjZMSjhE?=
 =?utf-8?B?aEtucU4reWkvMWYvMHBWeWg2bDVEYW8rYWp1MVNCWHE5ZFUxb2RYWklhTmYr?=
 =?utf-8?B?U1VTYUR2TVJ3N3VLNUt3QnJHQWRxSEpzK1JiQVFuNElkbk1NME91NEIvSmt5?=
 =?utf-8?B?SnAxQjEvdWJrZ2wwMWFONGlMcHNZTU5Zd216T2lZVHA3bGlOall6RWZzM0xr?=
 =?utf-8?B?Vkl0T1p1eDBRNkQxVE9PZm44KzI1OUJKdWVET1ZPWFN3eEc4cXo2aWV6MVBn?=
 =?utf-8?B?UmJqbWV5R3FIazBxajhvK2lJRGs3Q0lvNEJnZE9MS2FhSXFsRmNVM0Z3c3hX?=
 =?utf-8?B?cVhTWit3bVIraFE5UE84WEdhNjU0UWhzYlZTM1ZvUUVJVGlGdHBFQjBWb3RY?=
 =?utf-8?B?TENBM09Dd1V2NnR4dU9PNHc0NmNyZGVoYUNzV2pZRStkNHdGWXpWWmordUhF?=
 =?utf-8?B?dERKNUtiZFFzbGdRZkNxS1VJWnNmbjMxd2xKWkoxb3BZTTBncVgwR2tUemhs?=
 =?utf-8?B?S2hDRDNWT29hTDlHRWkrU3RobVRqcVNzVFZvZjE0TkRKMVhyNHFNVU9uNC9s?=
 =?utf-8?B?aGV1b0VDYmluTWNoWFVVUWFDam9YUTQ5Q2lZSTV2aHFKOGNSVURFbWRVTm1r?=
 =?utf-8?B?OHArZWRaQVg1MFhWZGw3TnM4eWQ4cjNaSkxzNDlRUVhKbCtZc09lWnpwcFNh?=
 =?utf-8?Q?sqxTNOSBaZoGdueA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR20MB4782.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29eaceba-61b4-4f3c-dd17-08da43507e45
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2022 21:57:02.1142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EcNCJrvutB1rzn5C0a/aBCQlGF0r1O54a+b7aUMqa+WSMf7eyn6Z7B0RtD1etoAEEJNJq2KDQ8oBtaYvW43YijowA1/bVTSvlMFiTfbBZpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR20MB1648
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIGZvciB0aGUgZmVlZGJhY2suIA0KSSBkaWQgdXNlIGdpdCBmb3JtYXQtcGF0Y2guIEkg
d2lsbCBkb3VibGUgY2hlY2sgbXkgd29yayBhbmQgc2VlIGlmIEkgY2FuIGZpZ3VyZSBvdXQgd2hh
dCBjYXVzZWQgdGhlIGZvcm1hdHRpbmcgaXNzdWVzIGFuZCByZXN1Ym1pdCB3aXRoIHRoZSBjaGFu
Z2VzIHlvdSBoYXZlIG1lbnRpb25lZC4NCg0KVHlsZXIgRXJpY2tzb24NClNlYWdhdGUgVGVjaG5v
bG9neQ0KDQoNClNlYWdhdGUgSW50ZXJuYWwNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
CkZyb206IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQG9wZW5zb3VyY2Uud2RjLmNvbT4g
DQpTZW50OiBUdWVzZGF5LCBNYXkgMzEsIDIwMjIgMzozMCBQTQ0KVG86IFR5bGVyIEVyaWNrc29u
IDx0eWxlci5lcmlja3NvbkBzZWFnYXRlLmNvbT47IGplamJAbGludXguaWJtLmNvbTsgbWFydGlu
LnBldGVyc2VuQG9yYWNsZS5jb20NCkNjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsgbGlu
dXgtaWRlQHZnZXIua2VybmVsLm9yZzsgTXVoYW1tYWQgQWhtYWQgPG11aGFtbWFkLmFobWFkQHNl
YWdhdGUuY29tPjsgTWljaGFlbCBFbmdsaXNoIDxtaWNoYWVsLmVuZ2xpc2hAc2VhZ2F0ZS5jb20+
DQpTdWJqZWN0OiBSZTogW1BBVENIIDIvMl0gW1BBVENIIHYxIDIvMl0gc2Q6IEZpeGluZyBpbnRl
cnByZXRhdGlvbiBvZiBWUEQgQjloIGxlbmd0aA0KDQoNClRoaXMgbWVzc2FnZSBoYXMgb3JpZ2lu
YXRlZCBmcm9tIGFuIEV4dGVybmFsIFNvdXJjZS4gUGxlYXNlIHVzZSBwcm9wZXIganVkZ21lbnQg
YW5kIGNhdXRpb24gd2hlbiBvcGVuaW5nIGF0dGFjaG1lbnRzLCBjbGlja2luZyBsaW5rcywgb3Ig
cmVzcG9uZGluZyB0byB0aGlzIGVtYWlsLg0KDQoNCk9uIDYvMS8yMiAwMjo1MCwgVHlsZXIgRXJp
Y2tzb24gd3JvdGU6DQo+IEZpeGluZyB0aGUgaW50ZXJwcmV0YXRpb24gb2YgdGhlIGxlbmd0aCBv
ZiB0aGUgQjloIFZQRCBwYWdlIA0KPiAoY29uY3VycmVudCBwb3NpdGlvbmluZyByYW5nZXMpLiBB
ZGRpbmcgNCBpcyBuZWNlc3NhcnkgYXMgdGhlIGZpcnN0IDQgDQo+IGJ5dGVzIG9mIHRoZSBwYWdl
IGlzIHRoZSBoZWFkZXIgd2l0aCBwYWdlIG51bWJlciBhbmQgbGVuZ3RoIA0KPiBpbmZvcm1hdGlv
bi4gQWRkaW5nIDMgd2FzIGxpa2VseSBhIG1pc2ludGVycHJldGF0aW9uIG9mIHRoZSBTQkMtNSAN
Cj4gc3BlY2lmaWNhdGlvbiB3aGljaCBzZXRzIGFsbCBvZmZzZXRzIHN0YXJ0aW5nIGF0IHplcm8u
DQo+DQo+IFRoaXMgZml4ZXMgdGhlIGVycm9yIGluIGRtZXNnOg0KPiBbIDkuMDE0NDU2XSBzZCAx
OjA6MDowOiBbc2RhXSBJbnZhbGlkIENvbmN1cnJlbnQgUG9zaXRpb25pbmcgUmFuZ2VzIA0KPiBW
UEQgcGFnZQ0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBUeWxlciBFcmlja3NvbiA8dHlsZXIuZXJpY2tz
b25Ac2VhZ2F0ZS5jb20+DQo+IFJldmlld2VkLWJ5OiBNdWhhbW1hZCBBaG1hZCA8bXVoYW1tYWQu
YWhtYWRAc2VhZ2F0ZS5jb20+DQo+IFRlc3RlZC1ieTogTWljaGFlbCBFbmdsaXNoIDxtaWNoYWVs
LmVuZ2xpc2hAc2VhZ2F0ZS5jb20+DQoNClRoaXMgbmVlZHMgYSBmaXhlcyB0YWcgYW5kIGNjIHN0
YWJsZS4gWW91ciBwYXRjaCBmb3JtYXQgaXMgYWxzbyBzdGFybmdlLg0KSXQgaXMgbWlzc2luZyB0
aGUgIi0tLSIgc2VwYXJhdG9yIGFmdGVyIHRoZSB0YWdzLiBUaGlzIGlzIG5vdCBnb2luZyB0byBh
cHBseS4gRGlkIHlvdSBnZW5lcmF0ZSB0aGlzIHdpdGggZ2l0IGZvcm1hdC1wYXRjaCA/DQoNCj4N
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zZC5jIGIvZHJpdmVycy9zY3NpL3NkLmMgaW5k
ZXggDQo+IGRjNmU1NTc2MWZkMS4uMTQ4NjdlOGNkNjg3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L3Njc2kvc2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvc2QuYw0KPiBAQCAtMzA2Nyw3ICszMDY3
LDcgQEAgc3RhdGljIHZvaWQgc2RfcmVhZF9jcHIoc3RydWN0IHNjc2lfZGlzayAqc2RrcCkNCj4g
ICAgICAgICAgICAgICBnb3RvIG91dDsNCj4NCj4gICAgICAgLyogV2UgbXVzdCBoYXZlIGF0IGxl
YXN0IGEgNjRCIGhlYWRlciBhbmQgb25lIDMyQiByYW5nZSBkZXNjcmlwdG9yICovDQo+IC0gICAg
IHZwZF9sZW4gPSBnZXRfdW5hbGlnbmVkX2JlMTYoJmJ1ZmZlclsyXSkgKyAzOw0KPiArICAgICB2
cGRfbGVuID0gZ2V0X3VuYWxpZ25lZF9iZTE2KCZidWZmZXJbMl0pICsgNDsNCj4gICAgICAgaWYg
KHZwZF9sZW4gPiBidWZfbGVuIHx8IHZwZF9sZW4gPCA2NCArIDMyIHx8ICh2cGRfbGVuICYgMzEp
KSB7DQo+ICAgICAgICAgICAgICAgc2RfcHJpbnRrKEtFUk5fRVJSLCBzZGtwLA0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICAiSW52YWxpZCBDb25jdXJyZW50IFBvc2l0aW9uaW5nIFJhbmdlcyBW
UEQgDQo+IHBhZ2VcbiIpOw0KDQoNCi0tDQpEYW1pZW4gTGUgTW9hbA0KV2VzdGVybiBEaWdpdGFs
IFJlc2VhcmNoDQo=
