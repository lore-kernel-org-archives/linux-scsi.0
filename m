Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3AAEB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 13:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjGUNnl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 09:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjGUNnj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 09:43:39 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF841731;
        Fri, 21 Jul 2023 06:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689947017; x=1721483017;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=09FVy9pEDcXTYiUlR2nKy56R7UzK4a6RxKsiZcBPyZU=;
  b=gjjSw5oX1UJXZdTjtMQg16omFXOTe8agjZOosV4SUjHyO+qMS+I8TQ+u
   Qecv8QFRpaN9b+zNKfQCmOGP5CFUHR/ZPV9auj5JXhd7/DAiHWL5NKhmF
   06e+UlCVmFiG1/5a/FCyrO9uLxALP8jSkWrb+0CfgITOXsR1pMBUPbFWu
   SkFMTSdSEouz4LsVnKrMGs7mnGj4n3I3MeRijMua5BGhzHUVyJDE29l9f
   F+XrKj6yO/gQiE7SNc7AWvH/byskNIL7Xc+eE0yiyFCMpA0+HUsZkJ2rV
   tYGhuxnjpdBLPUBH1UkfNlhPn1I+ShM50Y4vSNMwQKHwCE+Q2tQyvKkOd
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,220,1684771200"; 
   d="scan'208";a="243359679"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2023 21:43:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edGVZAXIQ2dM6nSiwz6sXlPS0bdauZ3ggyuAqTox6GA8g6IOfNn25t9RNXe8hstafzyLRGp8gorXp4yOUdPoXqcmz+npPkzZfLZyqDxezahU4otuWUfYwfRdWbR+r+hV+vYWyq9eKGgYcP/UJkEsZ7lnSgplgl4AyMzA+39CJYmrRDTGS33wRh7B1yZdhDTIljX/0HXwRL5X8AJ4GnvkhiOKbv4qDglh7cr3X7WpGRMovuKy2Kdxtp2jubjrM3/+5/6BT3SaxmIclaEBHYpOvCp7OGUeR2teSJWNYRvvvxtcFx7R1ff/bazPgLlWTsh91Bkd/Iky3BRhkEvKpqkwHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09FVy9pEDcXTYiUlR2nKy56R7UzK4a6RxKsiZcBPyZU=;
 b=GQBmibsn8hDRqyHQmZteWMAtGh9ai2t07UkfqT0tF4cX1mwEC5INU+/5LfqNn3P39KyzRjh8xHOvxi3xSSm6q2OtJRRAcTBRtpNJXGVMUFfY2FkCClct42U9xsaaw30yaVdvLXX5qVwb58laX/CVl5KA454e1eYykjd+awhpEUNeMS2x78EiUqD5XkH0wHAfs4HtJGJmNUO8nzowtzgljFh54UXYH+LfkUuTgqrClTdDQ7PPI0RUmBlFbujmlhgzeAbSmYuCR9bdM0k133LaxnwIKdOcdF6B3c3K0cN/+OxY77c3MRgiLOy8LiJvUHlCCPvYaZ/251R++BFzeRzgWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09FVy9pEDcXTYiUlR2nKy56R7UzK4a6RxKsiZcBPyZU=;
 b=D4+q31oi2WHHiASLJqqMf/OhxzyAw8qqDnkLgUxZuibXBirzkiABGfTz7+zm5ls9Pqng8/aF/sXIdub1f4R7LMQwWTkOASTip6ENbXue6ejIY6JG48Bpfp66Trf8v+6OWvq0hoL0S+HZRguj2C53BucstTTN0teUSIAsdaGo5cQ=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM8PR04MB8184.namprd04.prod.outlook.com (2603:10b6:8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.28; Fri, 21 Jul 2023 13:43:34 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 13:43:34 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     John Garry <john.g.garry@oracle.com>
CC:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/8] ata,scsi: cleanup ata_port_probe()
Thread-Topic: [PATCH v2 6/8] ata,scsi: cleanup ata_port_probe()
Thread-Index: AQHZuqOzHvvQLiUnL0q8tJi8oZWPsq/CUt2AgAHqioA=
Date:   Fri, 21 Jul 2023 13:43:33 +0000
Message-ID: <ZLqLhV+IHgIdmtAp@x1-carbon>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-7-nks@flawful.org>
 <9beb180c-b762-a227-bf5a-48ffcdb7dfd7@oracle.com>
In-Reply-To: <9beb180c-b762-a227-bf5a-48ffcdb7dfd7@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM8PR04MB8184:EE_
x-ms-office365-filtering-correlation-id: 943532ed-eb40-4fe4-c567-08db89f07a4e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Wu7+aLY9qrWeJpMFlhoAl8n7R+By1pk7YhoaQn3fEU8xY8BN3FVogT60ShQCqwksw2c40b7EkkeGcx5+L4/FL3y+O9Lo/iy7ba7H+jMeCfDcJAnSki569FIGv2Ffy6RsXh+c86r/XkAFCfAOR5E8esh+CRCiPrNjZm6bkNsSmHUXF/uwrFhkmVlAsvh13x1rjzh9jnf4nqPdTYzAHiXX+Tn3yukJ43ijFq+WWtn0TcVTeDr2dJ/wRmSUIc60wWGIaFDeLO/okxbszsczyonOWIacgLnGZhZLNrMW8mU5uY8EmhfpinhwYLV98krYyQCrpX/kAhfWpJj7JXtkmbS244466b17ndumcJHDn77B2x3Z5ooG97kYyNSRdbq4BrCjwQHg0OkqvOTUQwE8obPVG+L5O7w74vUESF/ZEdfRRbO3hIcK3JRYG1sofyI59lr7v1TJo+wiMxLcBfgeeQRzZp93mnTMaVkn3ROJz2BXtZF6ZqbMkZGnX2985BXaGm8zyNreFE8Rwg721Tv2CSFrM40hR31iADPzAYk/UDoLFZXTzDkwKKrYCzHKYo2E0q4l9buRK+r0ijCJ8mKPUw3VY7pBk0yV5PmA4qFRLeBTbQNwbOQd59oi++3CM25uzOTsOEfsnSkyIP8b5Bs8mK30w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199021)(4326008)(6486002)(2906002)(6916009)(54906003)(66446008)(66476007)(66556008)(91956017)(64756008)(478600001)(316002)(9686003)(6512007)(66946007)(76116006)(4744005)(71200400001)(186003)(8676002)(83380400001)(41300700001)(26005)(53546011)(6506007)(8936002)(7416002)(38100700002)(122000001)(33716001)(82960400001)(5660300002)(38070700005)(86362001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m0GzoSwg5W5ELYiA//VmYDBJkhEDn0BaIsdHYM+ZBq99n1bJ9Yp89+GPk2rG?=
 =?us-ascii?Q?ZIE+wogoAEaD64rDkZeEBgIn+zj9n9HhqC8gz/a0cQkgWR82Tl96Ov7D8xLX?=
 =?us-ascii?Q?fDSThMTxZFsB/uCFifkJdLSR1YyyiRqvz+eYIJOoXWJtZprJjcJOCFi0vQsu?=
 =?us-ascii?Q?B3a7xVecO380ErQJJj8+CfmAXFrkKoExqudAurD5GISZYFZaFTcm5yxryBBS?=
 =?us-ascii?Q?RONWKKNhgnB53qLz8P007ZetMQChfOajDdTcQo6NSzLnRARHUWjZR+PdJ+BO?=
 =?us-ascii?Q?m/zVJ4YjeVjV4dSGEcNvV/J6hSkajbfaEZeY9DiCEY2UxEXGHDldUTdqR+6V?=
 =?us-ascii?Q?3Qw41+nOdu2XFjnmcWBhNWDpCvxphCB9u+A4HzUbGdLRIcbfrY30jpxLWLsD?=
 =?us-ascii?Q?A/uRxeF/MnyWSfunACQ6FOBVgsYunfklHJxTQ98Synw2Cw5yeM47++3gedqn?=
 =?us-ascii?Q?EbVzKrlFqm3FLVeUif/SS5B8TdxGvNcuxm2Ju0wJwj/r4HDVmmSdZc9SvJCh?=
 =?us-ascii?Q?Et0SToGM1vTyEokbPmeVBD3MAWytDgLp8VupOQAHJnmnW5l3xkUlUUSVKItq?=
 =?us-ascii?Q?IjnWJq/04Buu37wTXqNt9Txw/9RQz0bxgPj3KaJuHOaJogs8A6qfvv/Uddi+?=
 =?us-ascii?Q?bzcA1y7iXmZYSKez2va7WgshNf7RLp5bWcSRy3CwGJOFs2CZJG72c4VEqR/u?=
 =?us-ascii?Q?NpwrV8As/kXwLwuIAfReOms2x1H8EU52DC0nAX4hRLFSCfmFuZPE6rote4vb?=
 =?us-ascii?Q?NQsmeLIB00QpC66RTldyFQoIIq7EVNmaXLzRdmR6acjFpNh7tpMsPwGwqCX4?=
 =?us-ascii?Q?JoXbZoR9DbIqvqNtCl5Ymgjb6CHlRp3s8T1hEsd7dUdQuySIyquV2K5Lb8ak?=
 =?us-ascii?Q?2VwJ7nVuY0AJEn+y4bt/HYFY9bl4E5PO/rGzi+p+Lu+Pce4uFC223sw9b/7s?=
 =?us-ascii?Q?K6/zfUvS60s/6ZsjJUaKvzOP/UbfBjmEP7h43f3NMdXeKJyU06LpbQINFnqc?=
 =?us-ascii?Q?+nsaXxLF0LHQhS0f+Ffka4/mXoqK18nQLJuolAZ+oJqMhylgYgG/LFx7ElcX?=
 =?us-ascii?Q?kkhMQdb/Q6iKQ97eTzITqtJ8KMom42yMnslFFjz+ME7V15nw+LqBMYIXwLY8?=
 =?us-ascii?Q?LVpl73jUv3Lv+kGbDzenl2VgRAB3wGGFWx+y3M3Ji17UaHq7uxWdaLOKWJHs?=
 =?us-ascii?Q?c31deYtBO30gJxdl1cUyO1kKzIwRaIasebFfIbuaGmfjWulG+IEpKSYrpXFZ?=
 =?us-ascii?Q?XtmNlFPxKN2R3IBNPdm//HVAt9ekKsT2/LGi/Ku05VOjS+pERy4Za6c85piz?=
 =?us-ascii?Q?UvksDXokPaQqL2LFd7YWHSwIT2GwvMPBb1qd5jIa2AL3QVGEqTz0gz2GnvyX?=
 =?us-ascii?Q?Mvu7+8Wlu45PfIlPXRQKBrLNoU0U02ffQ281JMLv7LkLa3WCEI4eQkMjEWIK?=
 =?us-ascii?Q?TLf+zCu+5LexdcruP2UnSnaco/6LD+IyxMn5CYuuBejosz4w/N0GEDe95ro9?=
 =?us-ascii?Q?RlGSg6bHNVHfnRb9AuKxUtHGayLKd+kRu+1mcphEsfjxNkXOMb4TlGtXX7lJ?=
 =?us-ascii?Q?jtV4kKAmlheAGxI8nseDEZnawNCCdlwzSh8Z+O4SqFq6OYdVdAdcDO0tmq8K?=
 =?us-ascii?Q?Rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <91E8ECEEEA7CA247A24EC080F6797799@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?MI7DaDKvQfDpgpsqwDT0tmTjJIHMSnui9QHjKO8RGsnKmV1uuHRaGFbX5Luj?=
 =?us-ascii?Q?OHtrv2aiz7gm0828LUXhsoe2WWKbWDN4JkYVEFzdWlovhQEDe/9eza1375Hg?=
 =?us-ascii?Q?fXoTEq68hgI65Ibz5fvc7Qxa8tjbmPoOX2lN4V39yfy6BB1bhd4JhcFqmzyQ?=
 =?us-ascii?Q?UnHl0YXQha0Sh8/pkIAFw3dwNSI2y/6EjHIm8cYt2IzFCayd83iRfF79pJwl?=
 =?us-ascii?Q?ootIUW+DBw8ur5pWDLpqzZg0Ny0tGmcptg5Gzg33bzGc+gZa/pQl+Y1JNuUy?=
 =?us-ascii?Q?Y3pYoxjokwCfBoWOtKHsg7MZhtiAHzKO+ZcXxdjFec9GzT8aef/Lt8TU2Vy9?=
 =?us-ascii?Q?Qel+phxgAmVklePsX5HHllc+YNvW3PksJMmVOxTMcH82Epl43s1FhFvcwu/G?=
 =?us-ascii?Q?XgOJqbzutvHpNEuaXpKQTHVXkyK9y3aC+MY6XbhdsRMINeTnIzpjdLe2fRKp?=
 =?us-ascii?Q?sA8hvIGTLJQ5/LtrY7152/DPnkSmDxqdNPJJJOZZfHx6C9ps6XIANnR3rYnV?=
 =?us-ascii?Q?RnToStMN4DRdvWVEbm2G5Pp8XGXGNCXlbaDNSxbX6JqlXVyPOCAEsMKjzu18?=
 =?us-ascii?Q?Y7H6k2kbVfVDox/csAmAwxIX52Xx/h4/GO7/Z8NTPPQVXNQhndAjUdqp0Y6r?=
 =?us-ascii?Q?bLRlzB/geH5yyGbEjSDYwA3Zus7Y5hnZjNGXE3LwhTosxXIBomLBV86sxxkp?=
 =?us-ascii?Q?OmuFGDCCNx3+o/shKz6bTUq+MQU7Cy7FnL5HpgYwMQTPqvZrP+JU2gF/0Xhj?=
 =?us-ascii?Q?XLj+AFSLQIyV5icEd/HKD8uTiyr0tNWnylzeAsKjhEnl74FzeP870U9OEDez?=
 =?us-ascii?Q?kDGSZR4zfXBqOZ/2hjl/GCmb1zsab67KT+Urz676HjCs1LrhYTv8bp7I9LY9?=
 =?us-ascii?Q?fPVbANlMVRKCECnIRwnol641K2wj1sHiyuAVArITYOnWj9+hHWV54+Ew8NkF?=
 =?us-ascii?Q?b8st9oSC/T8hgU8xoPzAIOvlf1y9mxsP5iS4YQHuhow=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943532ed-eb40-4fe4-c567-08db89f07a4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 13:43:34.0199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EjT4qYD+37ARCHXk7i4qS3CsnJlnAxdC0S7Df46reHkxKq4ryOfBgUue/RPePyv3cpTtDMpbXxLEybm7GlwZAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8184
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 20, 2023 at 09:27:51AM +0100, John Garry wrote:
> On 20/07/2023 01:42, Niklas Cassel wrote:
> > From: Hannes Reinecke<hare@suse.de>
> >=20
> > Rename __ata_port_probe() to ata_port_probe() and drop the wrapper
> > ata_sas_async_probe().
>=20
>=20
> It is confusing that the previous patch is "inline ata_port_probe" - from
> that I would expect it to be gone, but here is it back again :)


Yes, I agree.
Remember, I'm not the author of most of these patches :)

I will change commit message from:
ata,scsi: cleanup ata_port_probe()
to
ata,scsi: cleanup __ata_port_probe()

I hope that is enough to address your comment.


Kind regards,
Niklas=
