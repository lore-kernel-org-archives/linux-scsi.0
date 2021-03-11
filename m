Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1E1C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A7164EFD
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhCKIHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:07:03 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10639 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhCKIGp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 03:06:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615450005; x=1646986005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hdbe8uTPhjdtLyG+aQpNF5foKXamVlrODMuusa9kmvU=;
  b=QPzfpp6Q4doz2jZjkWFt88LKpMpwuH7oNuDPoeWl7CpKIg/Ftu2C0mWS
   xbA0lEnkfC3sOzvt7QJmXbIsV5Bcjr/QMx18Cu8sSliU5eliGFnwyiRnp
   dp0G0qZc1LxkjNNzj8obNyplxedV560dltIfld3Ase+R2W+7FbdCSSHEn
   f3nC0mcFIhylZ0dTZ8Jh4B2sJs0fGQolSwqR8PaRY3CXGUi3IyU1hsDyB
   VsfTKt5NvtBuGlV8itwCA5Wfn1LxK56TdKdPiAOunaWS8GNS3hX1aDvpn
   yn9lHcpRXep2O63P3PgE5dcf7+j1aWrxnUlDkFSpb0tSdUmIqB5TGtB8e
   A==;
IronPort-SDR: uYGnzy5PoBMxi6l9qYp+pCEsTkzH5SGPnimad2J/qpF86uI8EvZYSFnWP2R0jlxAjAsx6mExHO
 U5k64m53wIuQxOq7uROQYEUMFOGv4CMicVxw7/QB+I0+dda59DxxPjJbax3XT/tLO4HcXRdAAn
 kEhpWSyO5xa90YSQTBYnoRheYePyT9p5c7zXpMvykSbypfw8Lq7nDzo2fMf1qZAIx2TCbaJxxp
 jYSoZ3xmFVXR4+jziHVL7d/osDXEScm4G3DAUX2bX3e9QcE5FoSGRm/xn97YefL8iGQwc4OW/d
 gR4=
X-IronPort-AV: E=Sophos;i="5.81,239,1610380800"; 
   d="scan'208";a="166395369"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 16:06:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTHwkCzgwtCkXYxkXWJz/8MrF06GcJls8YgwVKgDn2QY3Y/4Ip5Z8if51Bam89Fei/RfQl1ujV4qAAx4JEbbJezMTCO7Ob3akx9zDqNgP9oBaVMYPTOkYkMtb6bnBGXfEhAN6sZWsG4Lso4gj5JsJaXjcbPJjCpBfnnUDcv7FJUTrie+oUdoSLLEys5Kk65zjHh/i3Q6JHecuYeTZ4mPWOGFYRGdW7KHcxzOelW+vF4CSvRs6awjw6A4Dtv2DS8LRJk12CZhTPQSOtj6DzJkE6c4teQOlC5AF3Nyrt7kTCxmktq2unI3/C/332oH/X1OxLywp7KlmMCHk+sy2R89MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQ2Nuc0O28Zitxx/IS+YOZgAMoe2juiLjR3PZM8XXmE=;
 b=XW9+nrMG2D2bWb9HFmg9692dcUtuKBktBeRTrZ4MWdtfQIkNtUCsap1z08h2RsEJCo/NaTfL3M7mEy4wCQQiS/ixJioUPUmIXKkxL4MBepclSSA452nXzOXpUrelPVDYd/lTjrKFXqMZsUcbR7ggbqjwaf2iNlJEEaPqMqKmRvrg2cMntyBAQdaV7fnJ3kgZN5qeu5dS/cLM5y8ZNSnVM8FYHsTDKZu4m+TC2Oc4aomrIHhm3bQiCtPRAdrQXqCbEcMKBpCMTN/CtYpSh04/2CdsHs7z7n07R5pRsgLDF47Qvh5R8SUbLKzr6987XBPzoJ3i3ml17NesDzb0/VpIgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQ2Nuc0O28Zitxx/IS+YOZgAMoe2juiLjR3PZM8XXmE=;
 b=k6MKMdocXgSdbD+x+4BJn+qgjkdboay53arSfCTfcHMbbZCrwIu4F6HGXJZEaZ39SUJEsUCr9YB1lRobWjrGMZl6s+VIPpsP+pqLQYm+qYbQ2SPSZYAwpSuZdpl4zWyqpLH6lAqpq6J1pJ2W2n2rSHvua1NJWNTaMHP5ag1sk0w=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5626.namprd04.prod.outlook.com (2603:10b6:5:167::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Thu, 11 Mar 2021 08:06:29 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.039; Thu, 11 Mar 2021
 08:06:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v5 04/10] scsi: ufshpb: Make eviction depends on region's
 reads
Thread-Topic: [PATCH v5 04/10] scsi: ufshpb: Make eviction depends on region's
 reads
Thread-Index: AQHXD2enfl0FRI4liUichXYuitc7Nap+eIqAgAADWFA=
Date:   Thu, 11 Mar 2021 08:06:28 +0000
Message-ID: <DM6PR04MB6575DE95293E84B67983AE98FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-5-avri.altman@wdc.com>
 <76763b655ef8ffec56123ff1ac56f474@codeaurora.org>
In-Reply-To: <76763b655ef8ffec56123ff1ac56f474@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 738f1aa0-fc1b-482a-d1b9-08d8e4649335
x-ms-traffictypediagnostic: DM6PR04MB5626:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB562602456DAAB82C3C955AFCFC909@DM6PR04MB5626.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SeNEFlSX5zU8eWjGH5hMCr9eUSObp8MhCMKrrlf946vRKKskg+EuNBF0ElUwjRRgViP0FEQClasD7zz99uUKOSg/aDok6Czf+m9h5wIO/Ld3K8hSONHtmNE3aAUlOH7DiE/H5kfzw+Qf/e1IvfDQ8IPQX4Yb7+Di199AjHGuVeOebEn7tCR6tOkKnQgWDE/QfXQpy8r7TwUEA+sbSVoditvemshjNtOGpNItf7mTIOx0NrrFZBieAlMDqQPU4woqx+4Zn7sBm2P+djU1a7LPvA0e7bDcEPyrIChwhg0LMZftgTofLLoPUzmVlMabw7E6PQA4NY6e8nPoM7I+DCKZRHgu6Ddv8xDNafXQ5zOG239+/tqetHqCKbWMzbfo8Bwux//vJ1zUaP9Y7vDDqiJTnxAM05DzZy4RkZZwncVvo0nV4rjuagJDj5+vSV8cGtjnOpZG9TRYXapV1BREQgH+HlUS2J0O2xwJjwGn/o2z/1VYVBW8+SXpd4PZNmkK6uw9hlIF6XAINMvELRc3qI/lx0j56yTKHw/F3J8qJ02ZUGCNITMqoQ5T5ewZcTRqk1d5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(66556008)(64756008)(76116006)(7416002)(66946007)(7696005)(66446008)(66476007)(33656002)(186003)(83380400001)(6506007)(52536014)(54906003)(316002)(4326008)(8676002)(5660300002)(478600001)(4744005)(6916009)(71200400001)(86362001)(8936002)(55016002)(9686003)(26005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?44x5PUH9tcMrDesSqCkqpT+l2+YVV6Q5+Av+bZUxQCyt82ZCUQs4yFqMxNE3?=
 =?us-ascii?Q?OY5vfrLCqDQZRH4qlR7UJKfQslm07pta0ery2vsZeK9UtVzYEG5v6xcSulnQ?=
 =?us-ascii?Q?7DB4xVqOQgzPlqZatfXE17hbqhB6oAVR9ZCL4EHxkJ02+BHC+NrrLt90W+A2?=
 =?us-ascii?Q?WTzEF8InGwTZRO/NLa6JTleNvG+LWuwHo1zUZ7osYuKBay7RG9GiS88SX77A?=
 =?us-ascii?Q?mw0sCB8XDujPazzvFZjI52Zc1tN5u9zBTHvxNJ5gpq+UikMkeDRpFyqVBIuC?=
 =?us-ascii?Q?UBKsGpPyMd100oNryXHwuKTCjFjFzcBw+gtYgjLh14vwJrZVPGfdtpit/79z?=
 =?us-ascii?Q?wCfARd01Ocz9BHBl8uBpbKMFbYRgDeicjJXsxvtlvEIGL9iWBYgqvdsoe/Ym?=
 =?us-ascii?Q?TiLaSF0cunvDvvkr1IJfjL+iJ25uWXAfuY7+6D1ol+bZiWT+amHfUZ+ciAz3?=
 =?us-ascii?Q?xNEQtf1n9H0ZcRlzqy0JWwcBRmG78AZXVnZ/Cre/9ZfBlFSH1v9WUsXDLj15?=
 =?us-ascii?Q?yQvOoieFThfOqHRnxn4pmptOT6jphco7nNLSWSmb9IYA5aeIySTdJdY24owe?=
 =?us-ascii?Q?zND8592yRQU2tA7iAFy7b86wyXwmusSu94+nKustj+eKIT9OBTfay4rHkOQe?=
 =?us-ascii?Q?sujmtXlXZ4q2v6PxrNKrMCOTedJsnr51OmuM0jqwXHFxEY7KRd9r9fAczkF/?=
 =?us-ascii?Q?xgKDA5uettoRXkUhDH2s949/by8bM/go/xDWNvbFYAY7aQsA3yPjyDMtrR15?=
 =?us-ascii?Q?jjjgeJ4Wi089MWAPkU1vDPrnravsX01Aqv1FWqGLGm8xOyQBoihOOpAH4efg?=
 =?us-ascii?Q?UIckUpEPzXNfnC/s6dWeHLRqLV6ZoUgibp/tA7PJkDe9YGsgDrmOSyyuoIUJ?=
 =?us-ascii?Q?IiqMgrqb4DN+sTvWJOqMReSX4b/951FEAZs+AKirPwSzGX5L/wzHjrwZylk3?=
 =?us-ascii?Q?3P/s2FTdhIyFY0f/S+HaI0XHa3QpOXGHY3mYv8GAwhrmFwjxb2lHkCDkphlH?=
 =?us-ascii?Q?/EkW7YXquFsiUEc2XX5zVaiye0flV+eTKwnDqTtqw9flcxJPgAMzuwlTtanV?=
 =?us-ascii?Q?/Q8Teei9fv/M9s6ZrqucFe7+YK2rgu+/H3NY1nzWRs9+KXVvdFc753x3Becj?=
 =?us-ascii?Q?lM5krW3a+GDNCBpBIA09IyYnGB65cLCaTCLaKdupIXw3k1/R1HpHjTi5hsdV?=
 =?us-ascii?Q?wf2iTJ2g/PPe9tb8pljVLESauqhnnwxRhYtJGjMNFBaCPOA7Wdg8ODn4xe+m?=
 =?us-ascii?Q?xXijoWwZNomuBKzfidVQz5UuuqhIlpmxZenEPARwAxEtHEyPOMYqM1k5rSg1?=
 =?us-ascii?Q?i6YWhx1FgwU+ZKI55jb97ivK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 738f1aa0-fc1b-482a-d1b9-08d8e4649335
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 08:06:28.9589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n0X+wfOHY0eXbWCeiGgkxowIzyS87xa+gmbVlMEA5wUrpW69VAAWbDD6tSOsBSeK65SJFp55WwloTeyBJZ9eeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5626
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > index a8f8d13af21a..6f4fd22eaf2f 100644
> > --- a/drivers/scsi/ufs/ufshpb.c
> > +++ b/drivers/scsi/ufs/ufshpb.c
> > @@ -17,6 +17,7 @@
> >  #include "../sd.h"
> >
> >  #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
> > +#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs
> */
>=20
> Same here, can this be added as a sysfs entry?
Yes.  Please see last patch.

Thanks,
Avri

>=20
> Thanks,
> Can Guo.
