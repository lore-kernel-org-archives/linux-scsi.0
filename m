Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24B8C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 22:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2FC9206E2
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 22:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="TVFjhakG";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="PbnHfdst"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731196AbgFRWqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 18:46:17 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1404 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730939AbgFRWqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 18:46:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IMkDOu025516;
        Thu, 18 Jun 2020 15:46:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=vLrh9PYIAYAxAxUbDVzY6h578et2M6ZL8s4spWk55AA=;
 b=TVFjhakGsNpUOGpChvUAy2C233rJE8MMLisC14KaGY9EoZc6WQyUKE+0wS8wyZzvPdQZ
 OYP+Zc3WjSMpQDck9FsdNN1eQOYLMrA+HxPoVFla02KU4VcMgN8+BFbRUv2G7FvMgLqf
 HX1thJ5ckTgocqKOWGBcQRUlt6J52Nwvtd33kT2+2IkVCZU4nP4bsIZ3oFB11qaYT2MB
 yvmFA0nkfnfQ+uEpqTaA1wO2lAgkRZh6cNul3V9ks0IMJMh/OoBKp3KClrDLvdS3Q9K2
 w4cIZMteUONtRVOGnahw292zkW25yhC6cA3mLCLRKBQVmULnLfuxZlrT3ftKsBXkxdZ2 0Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31q676vs6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 15:46:13 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Jun
 2020 15:46:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 18 Jun 2020 15:46:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcveBkH6K9awtJIHYNLIGFXu6qn0VhDriqPgj3dUDiK7yWlofrBnYi92c1mBWilwL/d3SCT16y+khhe+a88wxJeyeAP8zrvyCFAcTombC03hyVIBpDN8iDWtCopsIVwKBSJNcvYqcnf5V28KcQhqpWBhYRy7XYljuVKbzCTUJcIhFvyIJjzPBUWcvbNc2qsdnXUrylk9k80IaxFKd3ePnnmuzgvYnJnYRfV6fwpSEWIoIKsdyzzBfRNmjjPjfZAE7p2tOPb9S9+JrOtv9eDU7Y2H5pL2vGE1MIOLaBEG53lxfnL2ONJCTbFoGy8isKqp9GpJpyooLpUxf9SU3J24Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLrh9PYIAYAxAxUbDVzY6h578et2M6ZL8s4spWk55AA=;
 b=Sy4qZZa6rysy9Eu2NahzVluECe9iIG1GEFrCXbkVyxn+m2aHlOzUqW9HWBVYhAbwSlfQnoC6A9w+CLXTNLOKQ4yScXGmlsR4xgEJUPFCP238XPYdLA0E/mBDT96F4JSDegPxg74cIt8oiM5d7yq4OoYSIWSfXtXQj+CYX+RUL8CTHcWmu9FHilDJwQFRy19WxRkV3P4UzJTgNA8MVyUt/4qilrSL57qmJXW5X2wkNSHm6jxq0Wvu2M47a7RGJfa2BGHbEApxd7HM79acIGLThwC4jqJaF9V4ZjPXpPn6/ADojnT2c0h9QtYGpcvcGkAWOlJVuR3ejzotq9hT+MEdhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLrh9PYIAYAxAxUbDVzY6h578et2M6ZL8s4spWk55AA=;
 b=PbnHfdst+7GU/42lcPRma/NlNVsp0Spuf7WjiciqoPLl98fqAOQvdFPUm9g93aBTaxH8nFk/QqS64HH0zi5FGz9dKgk0IQoPywdlWtl0+QfSnQA7+2Pa1hnKET2GULtynNRRHubSdvUoeVQJtt7Sy7DaVB2+cIPrHvNx/23n6eI=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BYAPR18MB2359.namprd18.prod.outlook.com (2603:10b6:a03:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 22:46:10 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b%7]) with mapi id 15.20.3088.029; Thu, 18 Jun 2020
 22:46:10 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     "james.smart@broadcom.com" <james.smart@broadcom.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "Nilesh Javali" <njavali@marvell.com>
Subject: Re: [PATCH v3 0/2] qla2xxx SAN Congestion Management (SCM) support
Thread-Topic: [PATCH v3 0/2] qla2xxx SAN Congestion Management (SCM) support
Thread-Index: AQHWPzGhOwfQ0CGFzUyl8UmpEAyWtajfBiGA
Date:   Thu, 18 Jun 2020 22:46:10 +0000
Message-ID: <B39919CA-5C0A-4792-9327-0D50DF8AD2F3@marvell.com>
References: <20200610141509.10616-1-njavali@marvell.com>
In-Reply-To: <20200610141509.10616-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:4ee:1dc5:f5ae:881d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30305ac0-9f3f-4e24-c2de-08d813d9657e
x-ms-traffictypediagnostic: BYAPR18MB2359:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2359BACED1A8316AAD7D974AB49B0@BYAPR18MB2359.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eRPdH24FqVvk5JDsXmJfwWHn33ewBZNoEeZQVoETCjPeEVq0Uory7O3ib0qft6RNImAVUUzW8A8DYi8H7zZ9Ls+MHY9gO+dZ+I7JIKA86izCgV7CnVZCloBkyl5jndu8jlW39Ci2PkCN46PqQxsYOYZq/8ilBDwX/FuuJj7CXPPzQmQl1nAdBnjrM3lf3V52pEh9z53EsWilg/TOSartYKzQyfrTXGITphPNxbGSYZAi63b0L1ACc68Ykxhbbw6iloYvfUcOHwoID/6lfp6Qx4XhYrRsEnGGy8IW7PINOSiNLvJpz0EgRY6GHmqn07Qa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(2906002)(54906003)(66946007)(5660300002)(6512007)(76116006)(66476007)(64756008)(66556008)(107886003)(66446008)(4326008)(33656002)(316002)(186003)(36756003)(6506007)(53546011)(478600001)(2616005)(83380400001)(8936002)(8676002)(6486002)(6916009)(86362001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KJFZBtkaGAj/V230NTy3xHvcHmgBwClN6vxmy4hEtp37afTRBEV1lKm5wDsi7ZuMCxTJQ75QuBUh16eAzBw6LLzwZSD4PklsMpGxP/xFlunPeVNXL5ch16lZwGBvVaXpggjgHTkqq4jmgcC7qGKtsb/VlzAu1lMdox+sM/zbi0RfM3Qtx3Ot5hzT72X9ljm3EkS9jazKu+vcRQPfVCzFK9mQWWkeN/mYl4adJfdlpjDACiMgu/7NIDbg+DAA2YmHhxR3l7z9Y/cWVJMJc4Ot8EXajrRCkHrk9Oi8y7/PnSdT9As2iUUplv4H0oY35WA2+IwXTTulGvYFAgtsoiz5+GURXHtbFPaxwhW7s6VqthqRJU7UhEXKIVmWeC26uRmijMHjDGAXqgypTTpFmRtMHw7sP5BlrdsHEetZaJ8EtVzu8ZAgDnmmbSVp3s8ol97XQepnMP49Wf+/doY61vOjTo/uLks0JABris4OkRiPvjAoSBVHv+JcLgegI+OloTrnb+VX/KCyKB0Dp1Cu+Mssd5kwG6FJPpkiFTMQLpivGvK8SGdEkuDXfHA3Ln5GY7Ke
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6A3E2C5200C39E428A568A9075CB0465@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 30305ac0-9f3f-4e24-c2de-08d813d9657e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 22:46:10.2813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gN+aCYBKSoVkNMiXCQrBNw0HoGrT9JORPuInkSHtuTLV0BTBrRPYt9anZaicELrJOJQh/CGHOF+8eiT6eNu8Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2359
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_21:2020-06-18,2020-06-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,
    Could you please review v3 patch-set and let us know if it looks approp=
riate.
  =20
    We should be sending out the next set of changes (to FC Transport) in t=
he first week of July.

Thanks
Shyam


> On Jun 10, 2020, at 7:15 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Martin,
>=20
> Please apply the updated qla2xxx patch series implementing SAN
> Congestion Management (SCM) support to the scsi tree at your
> earliest convenience.
>=20
> We will follow this up with another patchset to add SCM statistics to
> the scsi transport fc, as recommended by James.
>=20
> v2->v3:
> 1. Updated Reviewed-by tags
>=20
> v1->v2:
> 1. Applied changes to address warnings highlighted by Bart.
> 2. Removed data structures and functions that should be part of fc
> transport, to be send out in a follow-up patchset.
> 3. Changed the existing code to use definitions from fc transport
> headers.
>=20
> Thanks,
> Nilesh
>=20
> Shyam Sundar (2):
>  qla2xxx: Change in PUREX to handle FPIN ELS requests.
>  qla2xxx: SAN congestion management(SCM) implementation.
>=20
> drivers/scsi/qla2xxx/qla_dbg.c  |  13 +-
> drivers/scsi/qla2xxx/qla_def.h  |  71 +++++++-
> drivers/scsi/qla2xxx/qla_fw.h   |   6 +-
> drivers/scsi/qla2xxx/qla_gbl.h  |   4 +-
> drivers/scsi/qla2xxx/qla_init.c |   9 +-
> drivers/scsi/qla2xxx/qla_isr.c  | 291 +++++++++++++++++++++++++++-----
> drivers/scsi/qla2xxx/qla_mbx.c  |  64 ++++++-
> drivers/scsi/qla2xxx/qla_os.c   |  37 +++-
> include/uapi/scsi/fc/fc_els.h   |   1 +
> 9 files changed, 428 insertions(+), 68 deletions(-)
>=20
>=20
> base-commit: 47742bde281b2920aae8bb82ed2d61d890aa4f56
> --=20
> 2.19.0.rc0
>=20

