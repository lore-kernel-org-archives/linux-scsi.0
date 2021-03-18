Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36D9C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 08:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A5164EE7
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 08:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhCRIEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 04:04:09 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:47770 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhCRIEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 04:04:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616054645; x=1647590645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LrLWcQP4XcBiNVgJn80GCKrrxo495Qjrd8BEcftA3cM=;
  b=iCPzJ3+N4g31VwQ5d2T/QaRrhNxJjNBraNGYUQ3+e/mlQU3RaRYNcPpV
   nD/n5Pzy2XoaOEWBf6iraXR1xyJ3izCb8+mlygw5xuInZEXXDszHRE6TW
   emoEpIOs+oqfp/2yow8KJfRgPu39YFjyejlLkjQnwNxHBGqEMBbFcpoKF
   y23D74pQUwOr5xTbXtfqoFeP0htvA9LdIV9827dr+5AMYHgI3gug+J0II
   qHwEbx0CS12wQncCyXcZ5w+G40kOLgMXoRkCmDz00NwHvlTnZkW1c4wnB
   +CwJR33JLbFS4VQnXzBsQGrAWeFl+nWMzjWGsYkxT1zX28HsQRdLgbzvD
   Q==;
IronPort-SDR: TnI2mcpc851BeCSI5zYDwiOYuhMG1djZUZcZWH9CEgG1GNU7T4s/PEq7UOtsu2D04gJ8lt2WTM
 3wMSgYcvCQlvMZu5Et8mq9ZtAk0nErZ0vMudQDnDQe/1B1Vux9GrwCKCNlA1k2QZ+XFTTtmwnI
 4NDF13kdZOH4aJVv2xvYHEv6mwaRIL2AF68N08Ym40/PI81zDGb6mHJbVZrHDadV6QM8GaUf9j
 c8ht5QxPHoiwvT0v0fxdFV/O2088MnGwFnArUC/1Mwys6HsgpIbw+X2dsZmuW2cT4mHPHWZC5c
 ptc=
X-IronPort-AV: E=Sophos;i="5.81,257,1610380800"; 
   d="scan'208";a="162411091"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 18 Mar 2021 16:04:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFRKFQ9trWfqY5Ib/S/VY0hWZw3FgVzHL6PrZedLQbWCIwKb2FDecLdqm9UkmeAOa+MiXJPapSWhMR3TML3KcPedxu7aXCNAP52fvU3Z3l2Vwwjw8nj9ieDxdD0TEJIc48KIDXS6cljobCEt/8XiBQQWfNH+iW5syAtze36+IelDFpbfLZAhuvevnSOwF96gUMzeXQHmjmeGRi3U33CnYtO+KN4P5jOM78jMFlL6/BKhcioi4TSvs1635zMJxRGor+HcQaACa2w054iqG3ppNOFVPKDiqeOqZsvhgp1K7rKdl9/7JFsIUwhPMNU4n5ikg6pn5LNV0LcluD9S4M2BzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0q+jHzrvJzYannVor8S5lqQRn3MrZZxhNUxeM1/f8w=;
 b=AKi3YMu39A+ZMeC4r1RHMWiHZz3Y2v+v1BnsHYx23JNgCqU0/WTOxbRv/H/fLPncrGMQoFN7Y1HYLoyRDBrvUFyYRZaNzT1aVh0419t4zFus9xbRsM3j/NYH9U0VLOZhPo9x3AtdIMn33zMju363gG5ZEaj7l+UvPnfdszawj1DEAu+yuheXDdq+/02XWwPTJUKqQFgTCsoHpuAK5Hh9NputZvs2USBPMTB7nMJvwkrFMtOhyxilswM/Ke+w4qLepaUAX7eLLS/krsmPHJs+T6PGPrYCV7+U42n5hEb+g/jOPgu5WHdjAr38ZTYervMzwNn6rHc+/q3pnZim8pVSQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0q+jHzrvJzYannVor8S5lqQRn3MrZZxhNUxeM1/f8w=;
 b=U7uVN0X4yVUiNPvtIgSALsEVb5NO7vglLF32gpzKn6WMHHNv88WarVSFj1sZU8VMkhDhNhnW1FoVYcA8ddV40LNATG4IInWHnMuKtwQmQVuQXuDz3rKI94uXLc0FmQofvmjOQLfRqMSziiZQ7Nrw5JASb8RX0GlGkrIKIIxUilw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7114.namprd04.prod.outlook.com (2603:10b6:5:243::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Thu, 18 Mar 2021 08:04:02 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 08:04:02 +0000
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
Subject: RE: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
Thread-Topic: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
Thread-Index: AQHXD2ex1y1f5g2rP02e5lIjKmzR26qIGY0AgAAGPJCAAA7hAIAAAEIAgAAbY4CAAAQzAIAACHQAgAAQ5TCAAJ2RgIAAdVtA
Date:   Thu, 18 Mar 2021 08:04:02 +0000
Message-ID: <DM6PR04MB657590BD9CAB3BAE180C7AE5FC699@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-7-avri.altman@wdc.com>
 <59a62fc17ec9229a8498e696eb0474be@codeaurora.org>
 <DM6PR04MB6575006E0682C3D11F54965DFC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1d0e3c5441ecf14b6614ec0af0d30af6@codeaurora.org>
 <DM6PR04MB65750C0AE1F1EDB41EDEE491FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <37d0a4f115ad5d08ab12a76e6cbe17a5@codeaurora.org>
 <DM6PR04MB65755C69AD3D64BC5B1E93D8FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <4562e78aee9c5fbb7bbff65930fc81cd@codeaurora.org>
 <DM6PR04MB65757E84F80B654689FBAE05FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <546d67b328afcd0d26dff41180288b63@codeaurora.org>
In-Reply-To: <546d67b328afcd0d26dff41180288b63@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d8d83ed1-3960-443c-a328-08d8e9e464d5
x-ms-traffictypediagnostic: DM6PR04MB7114:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB711426CFB521B6B1205AF7B4FC699@DM6PR04MB7114.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EPfDEuU/e9zMszZrwmFKk6Lwyura/76PPIVnf0VET0r0qCKzFixklwvP10CH/832+fAMXGjvkxM31gNZPnTSIsbiPsmY7zYcuxq++35c0Ko/ESkQ8ec60cZaqCpHH65F7lmECOKafcwSiXkYJzPsv9friwgN5+izbsl+zMCp/YWHciduJ4lMH4eWYMY+4JIm+Vxpln2ew5te6rV1G61QUxUqXxpTI+Ji7EnTdF1zgB12Ztu1SMS4GEMeGcNtvrfgggcEUOCWytOfgf9LcyEzxa73/hz0kaQXTJv3EgmiF6wTeLuiLNlkAi8SUi9Kusd+YgY2b6bytMaZl2NQHiU4hVfysz1A7hvSDxbfJmRUK/EQjRhyko6sAldeyVbZ2iLe4C6DtyU/Hf/46a7YBT0q237T0yVzhQPtmnkgoLaQ+fhLmQCrTICJj54oWJKxsdW/LMGVPk1ka21vjfDg8Bi7yW1xpV1luyxjWBJ6WJdi1S+GY84J9JQh6FoDaWq6CfpPM90ynRpthhMLCwJi52i0Ig1obE2UxQRUK2ts5pDd/oZxeZvpdVxtLUxPs5xy3LQ3DqKQNdEVLDyrAucyqCC+mEFdbeK++UN7uFEhRRhI1rIQkXhuXOOpTCa/34FF7Uan
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(2906002)(66446008)(54906003)(53546011)(52536014)(86362001)(478600001)(64756008)(66556008)(6916009)(76116006)(7696005)(38100700001)(6506007)(186003)(66946007)(66476007)(83380400001)(7416002)(26005)(71200400001)(5660300002)(4326008)(8936002)(9686003)(33656002)(8676002)(316002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rnE24CBWo21ZvzkOIem38waCODCZlq9afbElnu1TbpEN+aa087kSjQ/vT+cK?=
 =?us-ascii?Q?pzspPBlyIRT9D5ro+cLFu7uuZTsSidDFcij8bizORCo3bTzSx1rkOeUadRfd?=
 =?us-ascii?Q?xEyrUtkRSW48jE9OPhaBEsXVZB6AnjhdfeDLjZpOHRUY3FiY6QGyhbBCu42t?=
 =?us-ascii?Q?r43sEvbq4h/G9yADgq+kdJN0dZ1UurE3HJZHoPRxYVidoHB0shQYChJY3IHt?=
 =?us-ascii?Q?d12XTMck39I/N7GsLwq83z8SYLo767fmrsFEXulqAjflBLYC2cg4CH11u2r5?=
 =?us-ascii?Q?TO24AVezLUrVOJPIJiC1MgjX+JkjycwU+jEYAEe1sEKtQpyGmgxFbwlYqwwU?=
 =?us-ascii?Q?Lh5nvfgYZMrbVEdmmjTSx/QwFSwqnfk0zDTIVuBzUBKWYL0JI791b07Dy0FC?=
 =?us-ascii?Q?BJNWs40bBLrh3I4JQE/ZP+yW76mr3Pspgx9T2tkDzVxcJUQR5FdUBGvQlQLg?=
 =?us-ascii?Q?5mHVNU33HOb91FcqzXOZw8zVKaxUiraM1N/MEVFxfrSypCPkIsI3/nHhU3kr?=
 =?us-ascii?Q?nWs/GaicrptdO5QxuYQf9ox0JLKR9cqa+AyKgO6hvFWS1XuUWHFAghvooeuP?=
 =?us-ascii?Q?Yv/VxLR5ihQ9n6XYRzn2Qabc3gZ8SflnYEXwPxfxeKY55KmdgHnnuMZYJ5SB?=
 =?us-ascii?Q?XdD/foaL3WnNlXc8pNxAM7zFb/0Vb0fEmXUMgQEDUyYIVWtPuw1qvXVpGRCW?=
 =?us-ascii?Q?KGAAihkIwjRQ3eU6xIDzU/VoeIqbjOzL7HXTfrbwexMsFECFacdRMH6uM9HA?=
 =?us-ascii?Q?oVHIXtdKAAmFNWThUj8epQ8/scMuLkEOdCbMclj2kL4XmIaXEH0v0HY415Tr?=
 =?us-ascii?Q?eIQ/hM5Ir97ai5T09TFDUCvDU3CYO98oH8NTLzx291eTn8srDZuSyD6FpoSH?=
 =?us-ascii?Q?2jaQ3BTriagKUXwN6uM061mm8/ySAGigM1pnrNxgtmwcy1HS7MZ2coUls/58?=
 =?us-ascii?Q?5HoZngZX7LDa8T1zWPvSe0o9Tm/fLwlqVFjH0Li2zkh/tYjDauvnGoInNwgf?=
 =?us-ascii?Q?jv5GPgKKUH6mlKOM+KMYppRnr2hb6tOf1SWLwF6APk8jsdCBCVs3cXKcM706?=
 =?us-ascii?Q?avY0GYAS0B3bic9J7gaB8up5cJK3kGyRANyq+30g+2W6AFKB7/6+Qws+nuhG?=
 =?us-ascii?Q?RRoTrYl9QNLRXtQOWRxKVsWAEJv8+ro8OOTe5RGCxbzC9Ra3qgXJI3/4+FTs?=
 =?us-ascii?Q?5iB4WBQv3xAQ9eQp4OnCuCWRbhhQuD29GY1KywtoLSJRzBuNA0INe1CF3gv2?=
 =?us-ascii?Q?5BJgqk9UA4x8qyl4a6rSTWkFw9IdM4cYVJvmnunR8NPkN7E+p6oWE+OE7fOn?=
 =?us-ascii?Q?LUHI0j2ZQQeBc2hIBo4FDjVi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d83ed1-3960-443c-a328-08d8e9e464d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 08:04:02.4820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IaY+bATR+FMVcipT420dFeh4IuXi4ZaesAA4M8EW/wioITnebl2PLCW4ZQ26OZlhJTMdINttetae4g8lXh0QdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2021-03-17 23:46, Avri Altman wrote:
> >> >> >> >>
> >> >> >> >> Just curious, directly doing below things inside ufshpb_rsp_u=
piu()
> >> >> >> >> does
> >> >> >> >> not
> >> >> >> >> seem a problem to me, does this really deserve a separate wor=
k?
> >> >> >> > I don't know, I never even consider of doing this.
> >> >> >> > The active region list may contain up to few thousands of regi=
ons -
> >> >> >> > It is not rare to see configurations that covers the entire de=
vice.
> >> >> >> >
> >> >> >>
> >> >> >> Yes, true, it can be a huge list. But what does the ops
> >> >> >> "HPB_RSP_DEV_RESET"
> >> >> >> really mean? The specs says "Device reset HPB Regions informatio=
n",
> >> >> >> but
> >> >> >> I
> >> >> >> don't know what is really happening. Could you please elaborate?
> >> >> > It means that the device informs the host that the L2P cache is n=
o
> >> >> > longer valid.
> >> >> > The spec doesn't say what to do in that case.
> >> >>
> >> >> Then it means that all the clean (without DIRTY flag set) HPB entri=
es
> >> >> (ppns)
> >> >> in active rgns in host memory side may not be valid to the device
> >> >> anymore.
> >> >> Please correct me if I am wrong.
> >> >>
> >> >> > We thought that in host mode, it make sense to update all the act=
ive
> >> >> > regions.
> >> >>
> >> >> But current logic does not set the state of the sub-regions (in act=
ive
> >> >> regions) to
> >> >> INVALID, it only marks all active regions as UPDATE.
> >> >>
> >> >> Although one of subsequent read cmds shall put the sub-region back =
to
> >> >> activate_list,
> >> >> ufshpb_test_ppn_dirty() can still return false, thus these read cmd=
s
> >> >> still think the
> >> >> ppns are valid and they shall move forward to send HPB Write Buffer
> >> >> (buffer id =3D 0x2,
> >> >> in case of HPB2.0) and HPB Read cmds.
> >> >>
> >> >> HPB Read cmds with invalid ppns will be treated as normal Read cmds=
 by
> >> >> device as the
> >> >> specs says, but what would happen to HPB Write Buffer cmds (buffer =
id
> >> >> =3D
> >> >> 0x2, in case
> >> >> of HPB2.0) with invalid ppns? Can this be a real problem?
> >> > No need to control the ppn dirty / invalid state for this case.
> >> > The device send device reset so it is aware that all the L2P cache i=
s
> >> > invalid.
> >> > Any HPB_READ is treated like normal READ10.
> >> >
> >> > Only once HPB-READ-BUFFER is completed,
> >> > the device will relate back to the physical address.
> >>
> >> What about HPB-WRITE-BUFFER (buffer id =3D 0x2) cmds?
> > Same.
> > Oper 0x2 is a relative simple case.
> > The device is expected to manage some versioning framework not to be
> > "fooled" by erroneous ppn.
> > There are some more challenging races that the device should meet.
> >
>=20
> But I don't find the handling w.r.t this scenario on HPB2.0 specs -
> how would the device re-act/respond to HPB-WRITE-BUFFER cmds with
> invalid HPB entries? Could you please point me to relevant
> section/paragraph?
The spec does not handle that.
HPB-WRITE-BUFFER 0x2 is not a stand-alone command, it always tagged to a HP=
B-READ command.
It is up to the device to handle invalid ppn and always return the correct =
data.
The expected performance in that case is like a regular READ10.

Thanks,
Avri=20

>=20
> Thanks,
> Can Guo.
>=20
> > Thanks,
> > Avri
> >>
> >> Thanks,
> >> Can Guo.
> >>
> >> >
> >> >>
> >> >> >
> >> >> > I think I will go with your suggestion.
> >> >> > Effectively, in host mode, since it is deactivating "cold" region=
s,
> >> >> > the lru list is kept relatively small, and contains only "hot" re=
gions.
> >> >>
> >> >> hmm... I don't really have a idea on this, please go with whatever =
you
> >> >> and Daejun think is fine here.
> >> > I will take your advice and remove the worker.
> >> >
> >> >
> >> > Thanks,
> >> > Avri
> >> >
> >> >>
> >> >> Thanks,
> >> >> Can Guo.
> >> >>
> >> >> >
> >> >> > Thanks,
> >> >> > Avri
> >> >> >
> >> >> >>
> >> >> >> Thanks,
> >> >> >> Can Guo.
> >> >> >>
> >> >> >> > But yes, I can do that.
> >> >> >> > Better to get ack from Daejun first.
> >> >> >> >
> >> >> >> > Thanks,
> >> >> >> > Avri
> >> >> >> >
> >> >> >> >>
> >> >> >> >> Thanks,
> >> >> >> >> Can Guo.
> >> >> >> >>
> >> >> >> >> > +{
> >> >> >> >> > +     struct ufshpb_lu *hpb;
> >> >> >> >> > +     struct victim_select_info *lru_info;
> >> >> >> >> > +     struct ufshpb_region *rgn;
> >> >> >> >> > +     unsigned long flags;
> >> >> >> >> > +
> >> >> >> >> > +     hpb =3D container_of(work, struct ufshpb_lu,
> >> >> ufshpb_lun_reset_work);
> >> >> >> >> > +
> >> >> >> >> > +     lru_info =3D &hpb->lru_info;
> >> >> >> >> > +
> >> >> >> >> > +     spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> >> >> >> >> > +
> >> >> >> >> > +     list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_=
lru_rgn)
> >> >> >> >> > +             set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
> >> >> >> >> > +
> >> >> >> >> > +     spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> >> >> >> >> > +}
> >> >> >> >> > +
> >> >> >> >> >  static void ufshpb_normalization_work_handler(struct
> work_struct
> >> >> >> >> > *work)
> >> >> >> >> >  {
> >> >> >> >> >       struct ufshpb_lu *hpb;
> >> >> >> >> > @@ -1798,6 +1832,8 @@ static int
> ufshpb_alloc_region_tbl(struct
> >> >> >> >> > ufs_hba *hba, struct ufshpb_lu *hpb)
> >> >> >> >> >               } else {
> >> >> >> >> >                       rgn->rgn_state =3D HPB_RGN_INACTIVE;
> >> >> >> >> >               }
> >> >> >> >> > +
> >> >> >> >> > +             rgn->rgn_flags =3D 0;
> >> >> >> >> >       }
> >> >> >> >> >
> >> >> >> >> >       return 0;
> >> >> >> >> > @@ -2012,9 +2048,12 @@ static int ufshpb_lu_hpb_init(struct
> >> >> ufs_hba
> >> >> >> >> > *hba, struct ufshpb_lu *hpb)
> >> >> >> >> >       INIT_LIST_HEAD(&hpb->list_hpb_lu);
> >> >> >> >> >
> >> >> >> >> >       INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
> >> >> >> >> > -     if (hpb->is_hcm)
> >> >> >> >> > +     if (hpb->is_hcm) {
> >> >> >> >> >               INIT_WORK(&hpb->ufshpb_normalization_work,
> >> >> >> >> >                         ufshpb_normalization_work_handler);
> >> >> >> >> > +             INIT_WORK(&hpb->ufshpb_lun_reset_work,
> >> >> >> >> > +                       ufshpb_reset_work_handler);
> >> >> >> >> > +     }
> >> >> >> >> >
> >> >> >> >> >       hpb->map_req_cache =3D
> >> kmem_cache_create("ufshpb_req_cache",
> >> >> >> >> >                         sizeof(struct ufshpb_req), 0, 0, NU=
LL);
> >> >> >> >> > @@ -2114,8 +2153,10 @@ static void
> >> ufshpb_discard_rsp_lists(struct
> >> >> >> >> > ufshpb_lu *hpb)
> >> >> >> >> >
> >> >> >> >> >  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
> >> >> >> >> >  {
> >> >> >> >> > -     if (hpb->is_hcm)
> >> >> >> >> > +     if (hpb->is_hcm) {
> >> >> >> >> > +             cancel_work_sync(&hpb->ufshpb_lun_reset_work)=
;
> >> >> >> >> >               cancel_work_sync(&hpb->ufshpb_normalization_w=
ork);
> >> >> >> >> > +     }
> >> >> >> >> >       cancel_work_sync(&hpb->map_work);
> >> >> >> >> >  }
> >> >> >> >> >
> >> >> >> >> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/u=
fshpb.h
> >> >> >> >> > index 84598a317897..37c1b0ea0c0a 100644
> >> >> >> >> > --- a/drivers/scsi/ufs/ufshpb.h
> >> >> >> >> > +++ b/drivers/scsi/ufs/ufshpb.h
> >> >> >> >> > @@ -121,6 +121,7 @@ struct ufshpb_region {
> >> >> >> >> >       struct list_head list_lru_rgn;
> >> >> >> >> >       unsigned long rgn_flags;
> >> >> >> >> >  #define RGN_FLAG_DIRTY 0
> >> >> >> >> > +#define RGN_FLAG_UPDATE 1
> >> >> >> >> >
> >> >> >> >> >       /* region reads - for host mode */
> >> >> >> >> >       spinlock_t rgn_lock;
> >> >> >> >> > @@ -217,6 +218,7 @@ struct ufshpb_lu {
> >> >> >> >> >       /* for selecting victim */
> >> >> >> >> >       struct victim_select_info lru_info;
> >> >> >> >> >       struct work_struct ufshpb_normalization_work;
> >> >> >> >> > +     struct work_struct ufshpb_lun_reset_work;
> >> >> >> >> >
> >> >> >> >> >       /* pinned region information */
> >> >> >> >> >       u32 lu_pinned_start;
