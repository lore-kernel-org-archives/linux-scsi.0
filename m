Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E825C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 07:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E59BE64FA8
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 07:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhCQH4d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 03:56:33 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:33819 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbhCQH4M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 03:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615967773; x=1647503773;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XZdL92KSVh1F+fyplHjf4Ku71GYo/+3CCuVL7Iw1OQU=;
  b=GeTBuFa2ZSGicN1Ky/4v/kKJYLu5dahwTV5Rk7K7B+at/bQHTG0X/97i
   Iq2NqE54Atwq0SzH7bC4hfAjYh15Z6vUOjmqz2lwA5Q1N+Mg8Fnh4A1Dr
   QlFBKx79PnQRh32oC15U1vE+g86NNT7rWbOn3Pgc3NdrtSc+CfzSyDaI3
   EJJ/Qr3lzoweUZC8kARuoiXga8FqhqFpk4fk70T/6hPXRKAu7TrwxudO0
   9TP859oHKCpdbBg2MH81tScXIuWBoky3HAQEq+pkOFo1852GKFsVVWhS1
   vJSEiTgzLCfrxFz2Bo1yLlnhySp/uDnyE1AWEXC58b+3pEih8B3/0QwJM
   A==;
IronPort-SDR: D6aFrLV9q4hF3P+fIPlY5Tw1t5Tchfx3BJDIoZwNJqqhp5CRiGWZ1SQA7wzeYjuL1Sfc+ZJa6s
 A9p1GYXMPgsW4nACO6LPAc+AeQ7o4RytFfeehie1b80w+7Q9WRqI/8fqX+fC9SuaRupflblBLv
 IfPEXDGi4Ems3jd76ueZXueX7QwEZTs7t46huq4jEQoJGw0yL6vGTAzYPkQVIMGMqf/wp8c6r+
 OWlwx6vwK7+ljNXcV8E/5kLEG/jNLTRF0rOly+3wfh95YNvB7QlMoJmHJ8upKOKVbEfazF+RvA
 6u4=
X-IronPort-AV: E=Sophos;i="5.81,255,1610380800"; 
   d="scan'208";a="266735600"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 15:55:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODB1k+u5arHwD/kiV9Qc6xYusVXdGunZea5U03ziXFLpDsUbta9RMcgkmHJMUtIfUx4+NKIRbFiL/UMgED05bFpQsOr09t/QxoyxEUUKZQI9SJxaFJM920ZaBMzKdQdkr3oT9yaK7R3wX9vDxP2dB0JsNiAhBgKcE/kBnjUz5rxl9QhZAZEMFD7fIjVjsV6eGzaheX6YOCMwUg8w/fJ6P9whpGQMlO9k76C6CPlURckL7P6PL4TemAIkrYu6Bnn68aXPbA+xyfL0ASdwaDNzkkYAE8PpNUWuOvP60gzw2kR7iWLYISEwF33lt027f7nfK3svn1kYdgWQY6odGiObFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ct2QwNI0lMi5TK+cRPeeOdHLgJEaEiVfNWTQGeFggjs=;
 b=cOleetRKj3c77wWIGqRerm8K28L8GBvBdI+clBhlqjT13QsP2mUcg7MSPOeH82KiJ6WNVTCagpzqbrM22QEjtEoE3X9G8QLdgR9ZFLT6OZNjoJL7nw5ruoPUh93iJ+YRLTlr9C/z3P0XjG8bt3aRacVy52iT8C1Z+Q6dgj3Wo/0Eu4CobsWO18PNLLyKquZsRbEnulfHgQIYIdMk+TLjIaYpyUgOfkdW1KN/7EuVPpgWWsx3xR8HroH4BCFtLmugvyA63qVkgkN/VeeqIDKikzjMNneEyXoQgsjjuKACLXP9yYUr7KXAPk3RrDra4b6IhZykRbOdPlLWWwAxILqHyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ct2QwNI0lMi5TK+cRPeeOdHLgJEaEiVfNWTQGeFggjs=;
 b=vB0Xdvx+SF2beNcyvyUmLbH1as3udPUpPldK+hzCkXH8PDB3w7iD41K5yGZzM0qcIoAnx7k/S88eUFxS6M/KXXAmL9PF6mH6J+mtdDzmb9xLteMQyGUBduNCAGDghGDCrAzl9tAmY+AF8QfUF0OC2TVoN9afiVFvijOq/qJ3Sac=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5625.namprd04.prod.outlook.com (2603:10b6:5:16e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Wed, 17 Mar 2021 07:55:46 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 07:55:46 +0000
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
Subject: RE: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
Thread-Topic: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
Thread-Index: AQHXD2e3uMXza01lFEKVh8wFSC1kCqqE3okAgAGGSTCAASt7AIAAVANg
Date:   Wed, 17 Mar 2021 07:55:46 +0000
Message-ID: <DM6PR04MB657542A19075691EC60BCEB7FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-8-avri.altman@wdc.com>
 <be5c0c390d7c0cf13e67f51cdc7dd8c2@codeaurora.org>
 <DM6PR04MB65755EE82C8D19B27E8B576BFC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <5dc7f93e6a1b1328fe8b5bb28a9ea34f@codeaurora.org>
In-Reply-To: <5dc7f93e6a1b1328fe8b5bb28a9ea34f@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 31cb64d9-953f-436b-f89d-08d8e91a1299
x-ms-traffictypediagnostic: DM6PR04MB5625:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB562589AD9253B7D128A9BE5EFC6A9@DM6PR04MB5625.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Zu6z2kqkCXic6wdxgY+0bVD+67Nm+bepURUOVqYHzP2wuFLjoxBTi0FGNT7jQCHmOoh9XaDzozKYQcvyxnhGUkByQYvcKcwT1OlSYNt4eLaCZ1T5zvt6txJZ2ecsNfdSsXsYsqvuu5Z7D0M8wJ4qCtkjf4vlMfaF3Ayg5YcWHHiNPsHXbIrKknyCghE//apncGe/aPmTJjHusb74HxZAMKSZkFVyXA7grOGBGxmNsixqlaFvmEkwQVDh7u/HCyEIuIjp8tP5Sz9/9fSYUlQNMvmiQZ6kvdtdSD2iEKPhVaPkDbN4Ais5Eh3VQDHEpgn8bVhcrEP4aXuZccG1ILFeXS2Fkd5HfpSyIsMitgpe5yhdSGYs/cYI5LdNSgubhscLmYkwKCVB/PsHkht9uRaby1YDKwp1kTDoO69BZekva+y8rMhARImYG6XBzIuB2KXdoACwksFKwL/J2atpj5Kkk71cE+dr1WEDFQwBTXJSO5ZDCUrSG8qZqa0SNQTEINWtocUCVqrlK2Yf6D7CNIXd8N4BkWkUARNG/pdX5T7/WE8EG7HRcTcDpTR1PU99gS5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(4326008)(316002)(64756008)(52536014)(8676002)(83380400001)(76116006)(8936002)(86362001)(54906003)(2906002)(5660300002)(478600001)(66476007)(7416002)(33656002)(26005)(9686003)(6916009)(6506007)(186003)(7696005)(55016002)(66946007)(66556008)(66446008)(71200400001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nRKuFwAQE8SwcbyHwXyo9j3JJRCH50dORK2uEC8/LIxYkzUCwOAFW+E3Qraq?=
 =?us-ascii?Q?YxlUyAQ8A7r7lhwfAjEsaPy+fH3Myzj+9wt8X6unz/xSxtSj5L3PWNEwiSbG?=
 =?us-ascii?Q?dVGX6pz9HNq7MoMZwZ/7/CwO/Sq6zUl+9K6aoWxBbRAEaN9YELhkl5YhoE85?=
 =?us-ascii?Q?sOTKFDy4exe3ry2nqMTSnjF4mS5PZVrffCm8IxMS5WTVYByTHfr37QrvZPlB?=
 =?us-ascii?Q?e/MLN4nvkWvwt3GzmvbMUuWYUZB4/ev1ELIC4vk8tt7MB+QSlBz501TVPMP7?=
 =?us-ascii?Q?31l8Mc5C7dL0UM7Bx+VRgcbfbZYcqvqgq1618Dy6EIoz0Sb+dDsSrMEwA+OG?=
 =?us-ascii?Q?utVOU8NP9jrZH6idxNbgOtWHt+S5tCGpYEvPJXRGCYUe9UTKPQ+vLw9xC1Yn?=
 =?us-ascii?Q?yGh0SzK6EfniRzSRU0g+8d3Ep66J5r5SEzSPvCGg8wVQY4Vv0/O/Ab6GP+Ha?=
 =?us-ascii?Q?uoR13v9kcCO/LEkiXyLRsbjNCYTUBLtARalldx9eELeNFMkpvwW8ohEX+fdv?=
 =?us-ascii?Q?/lTgorqyrB2+wLsRjQg5OIr1Cnf3cTJ0DSp5j5AFOu60phEWuwl2dVPsIZOR?=
 =?us-ascii?Q?C6rNdQhAiP+MeHjPOs1evv5wSZnLEx+Vj1mD1PcNO2RE//nMyPGDyktWrZ7h?=
 =?us-ascii?Q?Zpc5wQOKbivcS1bwC2Bi1AO7rlcFgK+JPQXAWvgTnTypIJkvoZoeSAEExl10?=
 =?us-ascii?Q?EbMVt5rPS073KIHzwku1/etmxE134/k9aaSiDZfRb+y6I1nqfBsG4r6u5/ZK?=
 =?us-ascii?Q?h+GA1QThsX4NDPbGfmfpU371qtiznILlGmJsxrdW99m5U0kmQkLeFsgwUUGd?=
 =?us-ascii?Q?IviXFV958jwC/ZFz85ez1FHujdCHiEUTYtIOWVerIz1Epc6LBFeagSqUVshK?=
 =?us-ascii?Q?lc6tLAcKZ6IKjhXSyfV3BBV9FzauWBRCsV4g9fHoiCS0uL1rYEq84t6uKrT1?=
 =?us-ascii?Q?auXdz5y7rvbRck/kXnKuurewweTnv8pidpfolgSh/dIgwhwtetyv74lEnNBP?=
 =?us-ascii?Q?ZvGLyL7z573IcSf7Zumj1nhPJaRcXZ8YPNandnUjw0g7bDI/qN/vXzI8E6MK?=
 =?us-ascii?Q?C3l3w3WefZfs9lOcCJUoLn/LjnNGjjmY374936NlwizXWbwOou2CV6QQR5o0?=
 =?us-ascii?Q?Vlg2cnfEJN5X5xWQH+Fwf7xFVYbKWul6RLl3jA91F/3LRRcRGoZs7OVYnBz2?=
 =?us-ascii?Q?J1ZRQ+L+iQvayYQ5T7R8HcKzLSVNoslfj9omN/vB8rAhtPlv3Zg/bR7Q6iWd?=
 =?us-ascii?Q?N96ah/ivSgEweaPV7lZ+x/Lyt0GKjVy9ttbeGk5LUYHHHW6iwyKwCUaSN8lV?=
 =?us-ascii?Q?+YE+4p/c5cHJFFJbTtlqmNTJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31cb64d9-953f-436b-f89d-08d8e91a1299
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 07:55:46.2262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xr8CsA5rQPbulF9/QaOYWa2UQiXrP9k6FpTzdfUKruqHY2zv/NABjqvNRIIaFFHkZSHF0ztniZzkm635w6luUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5625
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2021-03-16 17:21, Avri Altman wrote:
> >> > +static void ufshpb_read_to_handler(struct work_struct *work)
> >> > +{
> >> > +     struct delayed_work *dwork =3D to_delayed_work(work);
> >> > +     struct ufshpb_lu *hpb;
> >> > +     struct victim_select_info *lru_info;
> >> > +     struct ufshpb_region *rgn;
> >> > +     unsigned long flags;
> >> > +     LIST_HEAD(expired_list);
> >> > +
> >> > +     hpb =3D container_of(dwork, struct ufshpb_lu, ufshpb_read_to_w=
ork);
> >> > +
> >> > +     spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> >> > +
> >> > +     lru_info =3D &hpb->lru_info;
> >> > +
> >> > +     list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn) =
{
> >> > +             bool timedout =3D ktime_after(ktime_get(), rgn->read_t=
imeout);
> >> > +
> >> > +             if (timedout) {
> >> > +                     rgn->read_timeout_expiries--;
> >> > +                     if (is_rgn_dirty(rgn) ||
> >> > +                         rgn->read_timeout_expiries =3D=3D 0)
> >> > +                             list_add(&rgn->list_expired_rgn, &expi=
red_list);
> >> > +                     else
> >> > +                             rgn->read_timeout =3D ktime_add_ms(kti=
me_get(),
> >> > +                                                      READ_TO_MS);
> >> > +             }
> >> > +     }
> >> > +
> >> > +     spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> >> > +
> >> > +     list_for_each_entry(rgn, &expired_list, list_expired_rgn) {
> >>
> >> Here can be problematic - since you don't have the native expired_list
> >> initialized
> >> before use, if above loop did not insert anything to expired_list, it
> >> shall become
> >> a dead loop here.
> > Not sure what you meant by native initialization.
> > LIST_HEAD is statically initializing an empty list, resulting the same
> > outcome as INIT_LIST_HEAD.
> >
>=20
> Sorry for making you confused, you should use list_for_each_entry_safe()
> instead of list_for_each_entry() as you are deleting entries within the
> loop,
> otherwise, this can become an infinite loop. Again, have you tested this
> patch
> before upload? I am sure this is problematic - when it becomes an
> inifinite
> loop, below path will hang...
>=20
> ufshcd_suspend()->ufshpb_suspend()->cancel_jobs()->cancel_delayed_work()
Ahh  - yes.  You are right.  Originally I used list_for_each_entry_safe.
Not sure why I changed it here.  Will fix it.

I openly disclosed that I am testing the code on gs20 and mi10.
Those are v4.19 platforms, and I am using a driver adopted from the origina=
l public hpb driver
Published by Samsung with the gs20 code.
I am also concern as those drivers are drifted apart as the review process =
commences.
Will try to bring-up a more advanced platform (gs21) and apply the mainline=
 hpb driver.


>=20
> >>
> >> And, which lock is protecting rgn->list_expired_rgn? If two
> >> read_to_handler works
> >> are running in parallel, one can be inserting it to its expired_list
> >> while another
> >> can be deleting it.
> > The timeout handler, being a delayed work, is meant to run every
> > polling period.
> > Originally, I had it protected from 2 handlers running concurrently,
> > But I removed it following Daejun's comment, which I accepted,
> > Since it is always scheduled using the same polling period.
>=20
> But one can set the delay to 0 through sysfs, right?
Will restore the protection.  Thanks.

Thanks,
Avri

>=20
> Thanks,
> Can Guo.
>=20
> >
> > Thanks,
> > Avri
> >
> >>
> >> Can Guo.
> >>
> >> > +             list_del_init(&rgn->list_expired_rgn);
> >> > +             spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> >> > +             ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
> >> > +             hpb->stats.rb_inactive_cnt++;
> >> > +             spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> >> > +     }
> >> > +
> >> > +     ufshpb_kick_map_work(hpb);
> >> > +
> >> > +     schedule_delayed_work(&hpb->ufshpb_read_to_work,
> >> > +                           msecs_to_jiffies(POLLING_INTERVAL_MS));
> >> > +}
> >> > +
> >> >  static void ufshpb_add_lru_info(struct victim_select_info *lru_info=
,
> >> >                               struct ufshpb_region *rgn)
> >> >  {
> >> >       rgn->rgn_state =3D HPB_RGN_ACTIVE;
> >> >       list_add_tail(&rgn->list_lru_rgn, &lru_info->lh_lru_rgn);
> >> >       atomic_inc(&lru_info->active_cnt);
> >> > +     if (rgn->hpb->is_hcm) {
> >> > +             rgn->read_timeout =3D ktime_add_ms(ktime_get(), READ_T=
O_MS);
> >> > +             rgn->read_timeout_expiries =3D READ_TO_EXPIRIES;
> >> > +     }
> >> >  }
> >> >
> >> >  static void ufshpb_hit_lru_info(struct victim_select_info *lru_info=
,
> >> > @@ -1813,6 +1865,7 @@ static int ufshpb_alloc_region_tbl(struct
> >> > ufs_hba *hba, struct ufshpb_lu *hpb)
> >> >
> >> >               INIT_LIST_HEAD(&rgn->list_inact_rgn);
> >> >               INIT_LIST_HEAD(&rgn->list_lru_rgn);
> >> > +             INIT_LIST_HEAD(&rgn->list_expired_rgn);
> >> >
> >> >               if (rgn_idx =3D=3D hpb->rgns_per_lu - 1) {
> >> >                       srgn_cnt =3D ((hpb->srgns_per_lu - 1) %
> >> > @@ -1834,6 +1887,7 @@ static int ufshpb_alloc_region_tbl(struct
> >> > ufs_hba *hba, struct ufshpb_lu *hpb)
> >> >               }
> >> >
> >> >               rgn->rgn_flags =3D 0;
> >> > +             rgn->hpb =3D hpb;
> >> >       }
> >> >
> >> >       return 0;
> >> > @@ -2053,6 +2107,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
> >> > *hba, struct ufshpb_lu *hpb)
> >> >                         ufshpb_normalization_work_handler);
> >> >               INIT_WORK(&hpb->ufshpb_lun_reset_work,
> >> >                         ufshpb_reset_work_handler);
> >> > +             INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
> >> > +                               ufshpb_read_to_handler);
> >> >       }
> >> >
> >> >       hpb->map_req_cache =3D kmem_cache_create("ufshpb_req_cache",
> >> > @@ -2087,6 +2143,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
> >> > *hba, struct ufshpb_lu *hpb)
> >> >       ufshpb_stat_init(hpb);
> >> >       ufshpb_param_init(hpb);
> >> >
> >> > +     if (hpb->is_hcm)
> >> > +             schedule_delayed_work(&hpb->ufshpb_read_to_work,
> >> > +                                   msecs_to_jiffies(POLLING_INTERVA=
L_MS));
> >> > +
> >> >       return 0;
> >> >
> >> >  release_pre_req_mempool:
> >> > @@ -2154,6 +2214,7 @@ static void ufshpb_discard_rsp_lists(struct
> >> > ufshpb_lu *hpb)
> >> >  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
> >> >  {
> >> >       if (hpb->is_hcm) {
> >> > +             cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
> >> >               cancel_work_sync(&hpb->ufshpb_lun_reset_work);
> >> >               cancel_work_sync(&hpb->ufshpb_normalization_work);
> >> >       }
> >> > @@ -2264,6 +2325,10 @@ void ufshpb_resume(struct ufs_hba *hba)
> >> >                       continue;
> >> >               ufshpb_set_state(hpb, HPB_PRESENT);
> >> >               ufshpb_kick_map_work(hpb);
> >> > +             if (hpb->is_hcm)
> >> > +                     schedule_delayed_work(&hpb->ufshpb_read_to_wor=
k,
> >> > +                             msecs_to_jiffies(POLLING_INTERVAL_MS))=
;
> >> > +
> >> >       }
> >> >  }
> >> >
> >> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> >> > index 37c1b0ea0c0a..b49e9a34267f 100644
> >> > --- a/drivers/scsi/ufs/ufshpb.h
> >> > +++ b/drivers/scsi/ufs/ufshpb.h
> >> > @@ -109,6 +109,7 @@ struct ufshpb_subregion {
> >> >  };
> >> >
> >> >  struct ufshpb_region {
> >> > +     struct ufshpb_lu *hpb;
> >> >       struct ufshpb_subregion *srgn_tbl;
> >> >       enum HPB_RGN_STATE rgn_state;
> >> >       int rgn_idx;
> >> > @@ -126,6 +127,10 @@ struct ufshpb_region {
> >> >       /* region reads - for host mode */
> >> >       spinlock_t rgn_lock;
> >> >       unsigned int reads;
> >> > +     /* region "cold" timer - for host mode */
> >> > +     ktime_t read_timeout;
> >> > +     unsigned int read_timeout_expiries;
> >> > +     struct list_head list_expired_rgn;
> >> >  };
> >> >
> >> >  #define for_each_sub_region(rgn, i, srgn)                          =
  \
> >> > @@ -219,6 +224,7 @@ struct ufshpb_lu {
> >> >       struct victim_select_info lru_info;
> >> >       struct work_struct ufshpb_normalization_work;
> >> >       struct work_struct ufshpb_lun_reset_work;
> >> > +     struct delayed_work ufshpb_read_to_work;
> >> >
> >> >       /* pinned region information */
> >> >       u32 lu_pinned_start;
