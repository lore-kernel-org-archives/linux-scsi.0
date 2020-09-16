Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E30C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1741120715
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="frtaX4Wk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Ww63Ay/Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgIPBLX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:11:23 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60674 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIPBLT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 21:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600218678; x=1631754678;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jabmcDO//KDJ4VPGdJJWoi4X4CcJlUbFKxQX6CpBETU=;
  b=frtaX4WkMoX+c2QUQ2cfRJCpYyak+L4NfbXR0Z/9mttYFrXENn1iMM15
   8AqNsalcHwZSC7xxQfkm2TorV+yhzPpWGAYKxkTpdHClWT13lGKHWU5ur
   Gpt7TiyXoTfbdiKpzNoGNy1g3vwWE9nsFhnHQfCDLTdnU751M85R5NSdk
   g8Yugwd71Qir7N70bgNUmfVIyYkkUZwa/W/knGE7K4rYusdfeE/exMzr2
   P1bCTTU6I+MX1cJKJM9d1TwOy+STo3CGAdHW269iGxpL55AwlF8W13Yn2
   rYYlGoTxrRGOplhBB6b5Ha7OSqNlCJ3S52XljrshSWn3E4XstGd2o/8SF
   A==;
IronPort-SDR: A32BXMt8P5heRLQs9vNb86xPu4HuJXdWTCKxti/V7cI2iFLfl+jr4feve99G4jldKWVgEZF7KW
 c7PLq5Be8RMeES7B4u2T4M4Dp4sVd7xF/Zx7VusynUUlYKy+WKenwZ1KMvwMB5njWubnlm6UAg
 MUXjTvNRxJe+smgOltCyZfzf2YAdsUsmZhASAp1hkplDjD5LA1+AIs3cYJcL6SoKikT518zAbc
 9vxEupKh/5DpcBsqNvJ+YRQSz7KuejdN6rXUloGafkVhNDvleySO5+hwzIvm9BwixRw81roaND
 +0M=
X-IronPort-AV: E=Sophos;i="5.76,430,1592841600"; 
   d="scan'208";a="257125274"
Received: from mail-bl2nam02lp2050.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.50])
  by ob1.hgst.iphmx.com with ESMTP; 16 Sep 2020 09:11:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ya0+Ncjw7UQWVaDfWNJOi5SlurAsjSwXzTBvJ5vbHyoovPHPUW2kd1xjsaJFtGleHaoyP7B5YRwMPkwae2X/DuzvzGUQ78yYWe53zpfBOadSSv9Pc4k4+BRx2OhvYdJ/nGsCAk0Gc2RpaTKetKMHYZN2ar2sbRkFYzHYYWQ2lUeJbWCsEA2KVFidIAcCOLbQZi+P4SfGLR53BBHgDhZPRgWBWOOGKYc/d3acXgmYSYwDStDJurWZOZXDUXoWbcwR1ON9Uml3XhQTijSA61/EI8iBskkNeiQl9kl1V8Hit4gCfkvT81m9ZjKPie0wcmY2PHkpETyv9e3r11RuioQHKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gY6c2A7UDc/m9SJOA4D/yiph5Utnx967jSr4yM33DBc=;
 b=NqqIyhJawNhbDMIVuVzDzKIVBVSmjdfXhcVKyYiz1HfZORqBz8FdIJLwAczt6GSH4pGIMlME4sJTDd3qseD80+OH2MRgaVFKaX0dUoHDMiiLkUXpNmjpWOpuy7yvyysi3myJ/OHiZqA4FO12bk4+2M4iJu7Yus6MTnw7JiYaPOGKP7sXiGCQItC0Pr7uzikGySE+KppylfWB9Hy7SSLm7y1KHO8Dw3pyW6Ud2lheJQiMzAjvTCaE85eyIwRg+hKuROLBWJv2lysyTSjZQuUt4LEcRzXvOrxaMuWiKuRHvyV6GEUJ+Ep9S32cKYf1bYEQT2O/xGh4mAeRT47yrgNstw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gY6c2A7UDc/m9SJOA4D/yiph5Utnx967jSr4yM33DBc=;
 b=Ww63Ay/QWsmdaRCfPIcEOYn6y7T+xdvEnQnJ9BYK75o+6CbG084stPEsAu2UE94hzUjltVpV10dWp6KmuGV3LWyyfohtVqN5sCcvuSYAmlngec4c4Mk+ob5L7rEJa/km+MSdq0Sdr5B672/6xSy8muDe7Nhb/P5NlS6KShbx0jk=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0969.namprd04.prod.outlook.com (2603:10b6:910:55::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.18; Wed, 16 Sep
 2020 01:11:14 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 01:11:14 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Improve error handling
Thread-Topic: [PATCH v2 0/3] Improve error handling
Thread-Index: AQHWh0bXn5AqM4ORU02XGGCJpyXbXg==
Date:   Wed, 16 Sep 2020 01:11:14 +0000
Message-ID: <CY4PR04MB37518B53E5E6F24B0C994D2EE7210@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
 <yq1tuvy1s5r.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:b178:89b:b9c7:c5e0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 948c079f-0c3c-4d3e-a671-08d859dd681f
x-ms-traffictypediagnostic: CY4PR04MB0969:
x-microsoft-antispam-prvs: <CY4PR04MB0969602C4B57C7439BD2881DE7210@CY4PR04MB0969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t1AoEgOe2lJlgungbG5zcOmbjPN9VU5Ci5KzWHjc6CD8XuPm2/B73hugdUG2NRw2AYtV4vb7gG3FoHRwQkmAB3ZRhPSxpTzHu11jdEqXzYFKrbq34ojBTIE/vNac3+0vG059u3mXT173Sn4CujwL8QSMaZ+D882vw0MZN79beus/SY+Ttg2P6p++F7q8IYw2QpVnwy6e1vEMgRYmSTLGAqChBpGTUjhpGTLqB6HQ/4pmzNxueLg0WNewyK+y8lgu1dLi7byqf8g1bGrNGVFUGIia7jGjbRFfpe+fXFzdf8mhGnKo4qT6MSS0QYh7Yytlu5WSgm9Cl9FHeWujXFPqzJ3cn436Cbw9xbiVOCLkU1jDjEuLv3Gu/tzIqAAnxdir
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(4326008)(66946007)(66446008)(66556008)(66476007)(91956017)(64756008)(55016002)(76116006)(9686003)(71200400001)(478600001)(8676002)(86362001)(6506007)(8936002)(7696005)(53546011)(186003)(4744005)(2906002)(83380400001)(6916009)(316002)(33656002)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: w7EdZhnok21gcXEd8+rKtIGX+HFr7l5OxVyomC14RTNWVf5YtUeKtYHyZPVwIGtv792eDmAUYKdzh7BbBHFSjKRr2iELSG3PscobYWyqPf+BxOP0fkZZGqygiGC0gauijhZb9mFhgC67VIABfTP3hl67DEv7A7d8RYhk6QgVIr92j7K6lvAtAzMoESEUE9EKV4Jsmc/PahyX0rg8vRF4j9JuSAvY4mrFWT21h67LyOjLK4GXatY/pQ5OoetWyayTpsOGYSbGpxAj/gLTSK8VMn4GfZCouUiNrLTK89xTIfttRPZF72ePWYop4qOtSJEYSODzzk0wOSPHQPCo8HmDz+w+uj+uTbLlcj+EdqNckr5sVwPHrDfdBnIiiVX44dnMnYwMO5YLKuD4w9pShXlUMygBK/6Ckob73Rtum4LFnyU+2aYaNntwcDg0TVLMyCkDmXta6iU9RAqg5s/kgxvDKqsRubhyzyssxN1mmYD5YbrXFfZ4xd88wUadzow1nFOLwMCyonVAO9d45uiFouQw4DzBQfuCn1TVObmlFwDt5BuaFzglUlb4Xkmlgp9rRs4kVTdBNMfoCtCtb/YSvOnslfFzogSSwDsdWinOqU3/tu+xqoqA7evgwAU/Cv90T2R3Wa6aQRsoYDVzjwhHLiZWZchE3/2XckKMPAd6qyTi24R6lvuXVEAEKMycqtxSZHgkhSNYazkJ+9SnDPSPJcW6sQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948c079f-0c3c-4d3e-a671-08d859dd681f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 01:11:14.1444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wLde7q5XgG2uLtm4+ZTRaNVb8hg0EwmC6JZD0d2b/JUpBVXRHlkSdH+rMK19M8Vfx/H7l6tJspVv0RLO+d1k4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0969
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/16 9:29, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> A small series to improve command error hadling.=0A=
>>=0A=
>> The first patch is a simple code cleanup. The second patch updates=0A=
>> asc/ascq sense codes list. Finally, the third patch adds zone resource=
=0A=
>> errors handling for zoned block deives to return BLK_STS_DEV_RESOURCE,=
=0A=
>> similarly to what the NVMe driver does for ZNS devices.=0A=
> =0A=
> Applied 1+2 to 5.10/scsi-staging. I'll wait to see where the BLK_STS=0A=
> stuff lands before applying patch 3. Thanks!=0A=
=0A=
Working on that with  Keith. Thanks !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
