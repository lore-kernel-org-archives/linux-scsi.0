Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3330C3A5A2
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 00:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B67BA22DBF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 00:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="p+cpyvU4";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=emc.com header.i=@emc.com header.b="KQ9PH4/T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfIDACT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 20:02:19 -0400
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:63384 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbfIDACS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2019 20:02:18 -0400
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8400Zxx030221;
        Tue, 3 Sep 2019 20:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=78u5oKbk5p5WtiOwZDJHxN5W5SdWA7LBcA5+hvb3k7I=;
 b=p+cpyvU4/cBTY44aF8wROogWyQNlq2gmsaDkKbuBXOSOnEO8hr9P2gmNztUPEClc4BHy
 szRPugZJxp/trucKDX30jF9u6WvsFVWwmQXDgwGKajONUCqqdLdsPTAswIcZ1SS5TktQ
 wjkfN04r5XSpilgzjG4BE4KjUmxz2dGlZ3kypEoGLtnI12KOXMCWuRpV0aoxdLYRjh3b
 7eOAZ//yYlTqEa0DPfb6cvMcvi/uO6eje9W00vrmbQfrw7wjX50zcHg0udKQCuYmWZNu
 vHZU9omGFB6QgElaj0ez79cB5hyVsmC8ihuc0Z5uXX3x/rDa2aN3DrMLU2KbMgim4Tp4 sA== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 2uqm2dcwe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 20:02:03 -0400
Received: from pps.filterd (m0144104.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83NwDZg194988;
        Tue, 3 Sep 2019 20:02:02 -0400
Received: from mailuogwdur.emc.com (mailuogwdur.emc.com [128.221.224.79])
        by mx0b-00154901.pphosted.com with ESMTP id 2uspfqkjpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Sep 2019 20:02:02 -0400
Received: from maildlpprd01.lss.emc.com (maildlpprd01.lss.emc.com [10.253.24.33])
        by mailuogwprd52.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id x8401PCL011854
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 3 Sep 2019 20:02:01 -0400
X-DKIM: OpenDKIM Filter v2.4.3 mailuogwprd52.lss.emc.com x8401PCL011854
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=emc.com; s=jan2013;
        t=1567555321; bh=pvLiIkD6cWEMb2D0YMvyTbsQxR0=;
        h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
         Content-Type:Content-Transfer-Encoding:MIME-Version;
        b=KQ9PH4/TaZxYhDpw2BWLRaxY7Aq/ACNNsiCP8afElOJ1+RA8xBR+HK2rVWfKcjLwA
         K67QMCPfdvjPn2jZ7q4dLlv/HNDY2vqGJn2RhSDElqPzs0SaxgRnNwQ1cOc92eUoM5
         lEBdRWQnqiTDIRpvKuTjfOHbqKv+EPacPcz5H4iI=
Received: from mailusrhubprd54.lss.emc.com (mailusrhubprd54.lss.emc.com [10.106.48.19]) by maildlpprd01.lss.emc.com (RSA Interceptor); Tue, 3 Sep 2019 19:59:56 -0400
Received: from MXHUB304.corp.emc.com (MXHUB304.corp.emc.com [10.146.3.30])
        by mailusrhubprd54.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id x83NxuVg012403
        (version=TLSv1.2 cipher=AES128-SHA256 bits=128 verify=FAIL);
        Tue, 3 Sep 2019 19:59:56 -0400
Received: from MX307CL04.corp.emc.com ([fe80::849f:5da2:11b:4385]) by
 MXHUB304.corp.emc.com ([10.146.3.30]) with mapi id 14.03.0439.000; Tue, 3 Sep
 2019 19:59:55 -0400
From:   "Black, David" <David.Black@dell.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Maurizio Lombardi <mlombard@redhat.com>
CC:     "cleech@redhat.com" <cleech@redhat.com>,
        "mchristi@redhat.com" <mchristi@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Black, David" <David.Black@dell.com>
Subject: RE: [RFC PATCH 0/4] iscsi: chap: introduce support for SHA1 and
 SHA3-256
Thread-Topic: [RFC PATCH 0/4] iscsi: chap: introduce support for SHA1 and
 SHA3-256
Thread-Index: AQHVYiVAhCItdVtPYk+m4jn3w2zzh6cam73A
Date:   Tue, 3 Sep 2019 23:59:55 +0000
Message-ID: <CE03DB3D7B45C245BCA0D24327794936306D540B@MX307CL04.corp.emc.com>
References: <20190829155929.27701-1-mlombard@redhat.com>
 <20190903070013.GA12256@infradead.org>
In-Reply-To: <20190903070013.GA12256@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=david.black@emc.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2019-09-03T23:42:48.1963259Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual;
 aiplabel=External Public
x-originating-ip: [10.238.21.131]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Sentrion-Hostname: mailusrhubprd54.lss.emc.com
X-RSA-Classifications: public
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_05:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030240
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1011 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909030240
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Christoph,

> Adding Dave Black who has helped with IANA interaction in NVMe recently.

I see my cue ... please keep me cc:'d on this conversation, as I'm not on e=
ither of the mailing lists.

> But we'll need IANA assignments and IETF consensus before adding new
> algorithms to ensure we have interoperable implementations.

In reverse order ...

-- IETF Consensus:=20

My sense of the IETF view on secure hashes is that MD5 and SHA1 are broken,=
 whereas the SHA2 algorithms are proving to be longer-lived (more resistant=
 to attack) than expected, and the SHA3 algorithms are fine.

That suggests that registration of codepoints for both SHA2 and SHA3 would =
be a good thing to do, as opposed to only SHA3.  I'd suggest starting with =
either SHA-256 or SHA-512/256 (both are SHA2 hashes) in addition to SHA3-25=
6, as all three have the same 256-bit output size.

Figuring out exactly what should be done here (e.g., which SHA2 variant to =
register) would benefit from some discussion at IETF.  I would start with t=
he Security Area's saag@ietf.org mailing list.  In addition, as iSCSI falls=
 within IETF's Transport Area, the Transport Area Directors ought to be loo=
ped in beforehand.  Fortunately, publication of an RFC is not necessary, be=
cause ...

-- IANA assignments

... the Registration Procedure for PPP Authentication Algorithms is Expert =
Review.   The long version of what that means is in Section 4.5 of RFC 8126=
: https://tools.ietf.org/html/rfc8126#section-4.5.  The short version is th=
at a request for allocation of these codepoints is submitted to IANA, whose=
 designated expert then makes a decision.  It's probably a good idea for th=
at request to state that the intended usage is iSCSI, and say that it's ok =
to restrict the resulting registrations solely to use by iSCSI.

As Christoph notes, I've helped with IANA interactions at NVMe, and would b=
e likewise willing to help here.  My name is attached to the SHA1 registrat=
ion, so it would make sense for me to ask for the SHA2 and SHA3 registratio=
ns, and I know a number of the people who will be involved in ensuring that=
 the proverbial "right thing" happens, e.g., the Transport Area Directors.

Thanks, --David

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: Tuesday, September 3, 2019 3:00 AM
> To: Maurizio Lombardi
> Cc: cleech@redhat.com; mchristi@redhat.com; linux-scsi@vger.kernel.org;
> target-devel@vger.kernel.org; Black, David
> Subject: Re: [RFC PATCH 0/4] iscsi: chap: introduce support for SHA1 and
> SHA3-256
>=20
>=20
> [EXTERNAL EMAIL]
>=20
> On Thu, Aug 29, 2019 at 05:59:25PM +0200, Maurizio Lombardi wrote:
> > iSCSI with the Challenge-Handshake Authentication Protocol is not FIPS
> compliant.
> > This is due to the fact that CHAP currently uses MD5 as the only suppor=
ted
> > digest algorithm and MD5 is not allowed by FIPS.
> >
> > When FIPS mode is enabled on the target server, the CHAP authentication
> > won't work because the target driver will be prevented from using the
> MD5 module.
> >
> > Given that CHAP is agnostic regarding the algorithm it uses, this
> > patchset introduce support for two new alternatives: SHA1 and SHA3-256.
> >
> > SHA1 has already its own assigned value for its use in CHAP, as reporte=
d by IANA:
> > https://www.iana.org/assignments/ppp-numbers/ppp-numbers.xml#ppp-number=
s-9
> > On the other hand the use of SHA1 on FIPS-enabled systems has been depr=
ecated
> > and therefore it's not a vialable long term option.
> >
> > We could consider introducing a more modern hash algorithm like SHA3-25=
6, as
> > this patchset does.
>=20
> But we'll need IANA assignments and IETF consensus before adding new
> algorithms to ensure we have interoperable implementations.
>=20
> Adding Dave Black who has helped with IANA interaction in NVMe recently.
