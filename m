Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FACAC4320E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 22:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA2460F58
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 22:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhHBWw0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:52:26 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12335 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhHBWwY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 18:52:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627944733; x=1659480733;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=TMgJpp8x90MEQD3UB1ZwuK/omOOpx4iEg4iohcsRNss=;
  b=p/75niw4yXXmCO/YrP0s2KDn4vXF7pNRusCqKoAlV0UkapJ92GJA3urp
   uMQpRibsuZEYPdYg1EHHlVFvdQFRk8cJ9/BELngkPt9sM20voJ+njgc8E
   NVfJotRIEAUib6Wi0uUdrJuYbL2z6527qjtmXlc0cMPtmFzppmK+WVhdM
   CQgoF5jBs7+S24mgsMvzpVjNE+y1kshyOdEzBPf0QfqsToOHkF/F40li2
   FvREwDlb4XoglE4bebOhX8O3H3LFIMXRItYZrV2E8kl7D4RUQbQi/FGj1
   mnfbD9DQQYxvFeFA2ds2+GwuI3PhoiZgK/dHL/TqroXjA/rtY6kF/0nNt
   w==;
X-IronPort-AV: E=Sophos;i="5.84,290,1620662400"; 
   d="scan'208";a="176137902"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 03 Aug 2021 06:52:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHWUTpsVqX6ZMkel1jQFyzbv7IcjUZYdashkbxKiYK/7npnBwLC9bwwjj4jFhVFGFeIPAkj/QwqoWqPr+1X0Iv6xdOTU4rPMaELqslUI9ZigeOHsSJWaLwND3f9E7kFRDHxSTpCQq1ajVxAqDUOZIeRhlbZFNMf2qxVR8PllIxrFpQp7ySlYxGxdJEBuniYSafVNem57aDgRCC617B9q6tnNSzZKMKMKLpcA4DP/7xQYfHK/11iwg1tBiA64VKfMnli5wyXBDJ6isFcM70s2uBvecA93FwX55ETjenWsye9wXCHilimoGn8nBjTBFBqs35aC2Msczob6MKE4GbBq6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuKlPiWRyQ1aokf1l4khV7NVwSRyJNZTqb0+xNfsV5w=;
 b=irHjV+YuH6z5AfDNylgPSwoyvYQ9iYUB3KNNB1GiBNCetgQCPsvOI0MY3ON/zkcSgXfI56AK/VEfNAIB3sUpkId3jFzYP1YadXpava3PJPQxmQ1jf9BBJechp9RCImo9DcC0tqbWqDbXBZGpX6zv88kWjT7Os1X/2HK/J8iUvfe9sMXb3mc9+63YhFDKgDXtQdCZbGoK4dTedNU5WmLBp5x3Fw62c2K8xOU59yIW55+IVTMsI3flXMeO1OyJVykJjG8u3RMF1cWkuFe8SEg3cm8puselDhMxG8FwjXlgwa/CBUagsPK3IPtvwQiK6xsX/UuYFnYJ6p00zxsJf5XIXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuKlPiWRyQ1aokf1l4khV7NVwSRyJNZTqb0+xNfsV5w=;
 b=Xb7MDd8zA/8tyBT7I+WQzZkW9TWnagEQ+6970HKe7dGpO1LWeeV9wQIWzSOKw0vLujjLYanTOVAt/+4sOhmyokf1BJ+x0/1+bsSPGl4tlfV3ouyVyqcMl7J7FqzCHoTb9u4Qet/aXyS3yIVD6RktYjbLr0Ep/Znjoc0BEnOH+jk=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6777.namprd04.prod.outlook.com (2603:10b6:5:24b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 22:52:13 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 22:52:13 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 7/7] scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs
 sttribute
Thread-Topic: [PATCH 7/7] scsi: mpt3sas: Introduce sas_ncq_prio_supported
 sysfs sttribute
Thread-Index: AQHXh3078BumpW0MK0yN1KQA+S7ebw==
Date:   Mon, 2 Aug 2021 22:52:12 +0000
Message-ID: <DM6PR04MB70812FF9F398ACB374441255E7EF9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
 <20210802090232.1166195-8-damien.lemoal@wdc.com>
 <82a38e44-f0d5-6089-3297-7a6d1293559c@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e28af4e-dc2e-4098-183b-08d956082b12
x-ms-traffictypediagnostic: DM6PR04MB6777:
x-microsoft-antispam-prvs: <DM6PR04MB67775EA61F0A0E02CC51622EE7EF9@DM6PR04MB6777.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ccP/jQ55djry3G/r11Iiw8nLftzl4w1M4QElc7jP/RvrZco65pXfn2IIWFVf5WW7YsI9rmQ3Crsd1WYNE4oZz+zV3x0nmkgMIVfRsJOLj5PF0qqTeazDDkF5gqB73uz1QytN4loJzrB90U2kbtWdR1jNNAZlQnCP2J0mNZK1WvC5KEKWrCMdnoura2rwc3yDZe571EejaKfciyPbzYLu1wtptpRNU4dOxXwfQO4lYJDbFQl3Lgmq8toLTTSdfk3WMHpN4txuCmkiIrY401xIklLSFKaqxv8O+tzN8RMf/dgGjKK+KPly5kSM08WkyhdW+0VtafF9NLhMGjVBsxs7xyTk6hnbC+4sZEB9LRwOEzSmlZW+SFBC0rCY5cXcKw5Uped0XTxkzyaQulsgG8aFCEzn+jEbg45lNmJAiTf2Kw16esQOOk57toQcxgik45pp2M7s1EfhTCNXzYoLMecSdZJ+CoIK+9Iw882CyGrc8/jkx+2ThUYaZgyZb7x/zCfCkhVlOUhBmlVTnEIZROjIDwDjTXQ4ipOSwm8pFzXdPacVdSLtjEuKNWZjEuslWlEAm4HMoglvl9XZ/0aB5o3cLig6AeEWdXkdwqSkzBFQ5iGMTSvZb8CtE+DXbkbW/amwXnF8W7Hi8A6rK1ZPJ7mNcxSOlrBikzRYAi3u7uKuMxOsTZ68pZWEIFLH3DzhNj1TOrAnF932WLtJbDk9AqbHHXJfTdwjlIw8aljfGb3KPxw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(122000001)(66946007)(76116006)(91956017)(38100700002)(8676002)(86362001)(55016002)(6506007)(53546011)(7696005)(38070700005)(508600001)(4744005)(186003)(4326008)(316002)(66556008)(64756008)(66476007)(5660300002)(66446008)(8936002)(110136005)(54906003)(9686003)(2906002)(71200400001)(26005)(52536014)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Tyb2FGEZJgLgmb7BKKA9uwrT8O0sZknOAW4Z4bD48WbXD2qlRhPRrD+g2ctu?=
 =?us-ascii?Q?7PpMcr0vCZmYlmytmgdfIbZeC+SrEHimoj/mcIdd/5bSucX2nw+PwSUvGwld?=
 =?us-ascii?Q?TpvnzBeQLb4bVlRIxQjbMghbKvg0RbtwOB3ZWEmKCGOR/wq4zG/39mAmIK9S?=
 =?us-ascii?Q?X77EUY7DtbjwLUYIBLpN3YwKUkzecEau12bCtHaYUX+P6gByFBdCOqc7XYUM?=
 =?us-ascii?Q?HJMyinUfE9Ma1vzTFdSaskCVrRsl4I/htIHT6BpM0bW3bL0I/cjEmwtP9mvx?=
 =?us-ascii?Q?rhEmxyYJpu6JPo1/cpWIwwHOtFkDw1Vcji45YZbeirJwQ3YqGBbbwPNja5GD?=
 =?us-ascii?Q?22I3SVKbqnECcbb9OTwXEOrZ9yeD6GvxiCr6xSoelIGYfqvu2Hg5VpukMW3O?=
 =?us-ascii?Q?Xhuy70kXUQZj2jNSE14Bblmk69yCYrkct5DkAt8zLOWa9xCIiU+txqVjDiFg?=
 =?us-ascii?Q?1QRe+jV+OWKG4Ddii1EooOb2riePv0QHuGlpTA4ovclJfGTTOyavL2Kz+U2k?=
 =?us-ascii?Q?iEMZGIuhUaott1RAmEsxuQNzZKdOhOkaWAu2Yae1CUjPP0lbv85j9VZdXFOU?=
 =?us-ascii?Q?44m/t96xAtE35wCpFRhuAMQSmrjzVNkstp8JOsaVYmQrZom95wx8BXqrUXIe?=
 =?us-ascii?Q?KyvbcQlCEjWdjhcnbQ2bT7vdZLi6HCLiyjIHZadPaFytdHIFpVwpR+bi+0Ga?=
 =?us-ascii?Q?ZsC5yJqfuLm1hAt4FIj0yCuo9/Jg4LwWFeHDFljQ1Bs3PxP3E99PDwIgK/Zm?=
 =?us-ascii?Q?rnJ4KwnPfHK5udBhvrLqGufbZziLvmpPA1xELDy5NrnMq9cSAdSsYw8uBYYx?=
 =?us-ascii?Q?plSwZA1P6vF3qGyd9s7YKrV73Kqt0Y5MAhhV8kQcfgJBFW0Pu/ATbFEFrz9m?=
 =?us-ascii?Q?oIMDal46m8JL1kW7DTqwGkywHpDgPPN/O1M9kb459hhSk5rwutOUBUZbQ7sU?=
 =?us-ascii?Q?6mOU8KIQyDVh04wNIjOZlJYXkvhsiLYMEL8NFY719nN5jjDmQsEy1RX23b3J?=
 =?us-ascii?Q?kRMgJhOD4R06eikPQ3QiSU2nL4Q7RHk9MHD1Yj3mX6KX3yG4UL7zZqdV4ECx?=
 =?us-ascii?Q?H01PS/9U94OQWHgJB1eUuFQUy7tB61q7cjQeA9GoRx+P1sfrc4qnGrNqlk04?=
 =?us-ascii?Q?IOMjNWwVq3LJyysjBCzenHgEWnNYOLiANMXPXM85DFlkQPr2OaPFoW2NT5B9?=
 =?us-ascii?Q?pEEIwMkjHxrbZiARb8TxsDm1pYBNg1MLWIwBCj8pxCr7XNhTaS3remHaS7HK?=
 =?us-ascii?Q?DerXz/LpN7EX3idyqwT83naXoWaIKh4xILqCUr83ucjV4vl+bSCngMMiRAr1?=
 =?us-ascii?Q?is512XvTDer2RVDG2Mrse6S+dBbAdQx347jTW8kRWpYibg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e28af4e-dc2e-4098-183b-08d956082b12
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 22:52:12.9390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v6d7+nbh1Bsa2kFKzibbn3LP0mmQKazYyjWKny3rHhQPXSwQBqVwP4ke+nYoFik84UsEbH9iUJTxXciIvQb7fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6777
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/03 1:00, Bart Van Assche wrote:=0A=
> On 8/2/21 2:02 AM, Damien Le Moal wrote:=0A=
>> +/**=0A=
>> + * sas_ncq_prio_supported_show - Indicate if device supports NCQ priori=
ty=0A=
>> + * @dev: pointer to embedded device=0A=
>> + * @attr: sas_ncq_prio_supported attribute desciptor=0A=
>> + * @buf: the buffer returned=0A=
>> + *=0A=
>> + * A sysfs 'read/write' sdev attribute, only works with SATA=0A=
>> + */=0A=
>> +static ssize_t=0A=
>> +sas_ncq_prio_supported_show(struct device *dev,=0A=
>> +			    struct device_attribute *attr, char *buf)=0A=
>> +{=0A=
>> +	struct scsi_device *sdev =3D to_scsi_device(dev);=0A=
>> +=0A=
>> +	return snprintf(buf, PAGE_SIZE, "%d\n",=0A=
>> +			scsih_ncq_prio_supp(sdev));=0A=
>> +}=0A=
>> +static DEVICE_ATTR_RO(sas_ncq_prio_supported);=0A=
> =0A=
> Since this is new code, how about using sysfs_emit() instead of snprintf(=
)?=0A=
=0A=
OK. Will do.=0A=
=0A=
> =0A=
> Thanks,=0A=
> =0A=
> Bart.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
