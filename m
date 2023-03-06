Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE719C61DA3
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 06:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjCFGQC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 01:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjCFGQB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 01:16:01 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED330CC37
        for <linux-scsi@vger.kernel.org>; Sun,  5 Mar 2023 22:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678083359; x=1709619359;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PZVlkSTTIIAH33GGvxep0wWhh/FWikclrebtH+bQY48=;
  b=k69v2Rc9z3MLlnycIl5DgPL1ErdAaRyb7CnMFXVHSoJFWLvVnRrf9n2o
   giat05P++BNUsbC6/Ak2LgPMneVEJZE8v5rAlXnKsz9bJ3eCMppSmi4Mu
   /frf7kxtASe0f5t0FCYZWqsiTr71FbSqHiSiu9mVPteoL5tnHP4TKLqpY
   e56v5tLCC1FxgLzlDqYEgPsPEqi9PLVUtwc5Z2BN073MnzPh70egUhvon
   1k8n3f58GkCywY3qZY9bVwD/e5YtpmIfGwiPphFEYX2cw9TIGE8lJdO8L
   YnAgX3hDyHqvcU7YMz1XDJ+K7d3zYR41TA/ymfXbUbl8c86tKhUy1dt20
   w==;
X-IronPort-AV: E=Sophos;i="5.98,236,1673884800"; 
   d="scan'208";a="329210726"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 06 Mar 2023 14:15:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbFCIb07ozH7BP0/t5OLIjQXNoB6M/oPDniiUeASys/iSxYIdfIwXlvxIce9cHKwToSim/t3xMPOwhHBkn7ntuSvR4sf0UA6AEuYlJ6Bvnq3gk6dL2OPi/U+NP6u+GyUb1UM37C5u01YLYfZQZ8BDmP00raKUrrTiNHyMbzS+qi/nmhBbYClyMrl/5Ex+7siFSa+GoV0KB+jTL8gicPO5uyW3ff5LvrPfCr4J5s1BrLVic7MFE4tPr1jBy6mRbNh+EqjY0TWVEgxCr1D0sZyN5PyruO8G2ONtPiBzGZKFHdubdu/8YDt79UjDYUtZaRVMb9i0rZCDO1TZT7PGWkFkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6/lSuffebQ7U3zKcufpn0lewdZEgr9rLWx309hktNo=;
 b=MG7SplwMVOJpLoQk5W7Y04Jp3eTneP0HSMVvOaH66vHmkz4Ci47pz5grnm8gvSH6ffuWju4apU5qOvvACx+h3bfcFA4NOLRLBwTSxFsD4yWwC0UcRGVg9cYny2EqRyJP+sVxUChl1J+WTFvpVx5bzbGOMismaWA/ey+lTxEHdCHueRhTh1oFKkojeFFbZSQEgLd8CTiq8I7m0hJFh4ZdabaVpm9Otgr1GnaH/rpoZBTEtP4YSEbyH3pOCelw5g8z+Vs//qgKUo2c52gEHjOr61PNuDOdtvpWjfspy1l3NNfyVUqKqPAnw6PExdBdHWjH0Fi0YKWf6ergVG+xaGkT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6/lSuffebQ7U3zKcufpn0lewdZEgr9rLWx309hktNo=;
 b=hH6rNUJfPLLZ8GMkv2On6uwnEaAW4Zue/OFvEJ7W9s+Q2dBBbcW+tVfb1QLPxFwa9EqF6sCOUlKPlq2MZuEUZRt9MP3x9VEtH1DujkdIlegmShISLqkyJVYc2xqc6ugjq9yrDjTzbF9iI5GE0a2sGBrdGenujI42WxQganXrfEI=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SA2PR04MB7692.namprd04.prod.outlook.com (2603:10b6:806:137::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Mon, 6 Mar
 2023 06:15:56 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::1b90:14dd:1cae:8529]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::1b90:14dd:1cae:8529%9]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 06:15:56 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Thread-Topic: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Thread-Index: AQHZTXGxFBXcbfq9nEK4NrScGRuyTa7pWikAgACWo4CAAM5PgIACjDmA
Date:   Mon, 6 Mar 2023 06:15:56 +0000
Message-ID: <20230306061555.hgiflebppsca7sq7@shindev>
References: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
 <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
 <8be7cebf-a5dc-4742-1ef2-207d1797f2f3@acm.org>
 <23ac3205-d92a-b32f-d0e3-29604cf859cd@opensource.wdc.com>
 <5b81a4b6-82b9-55a2-a75c-486886c96e9e@acm.org>
In-Reply-To: <5b81a4b6-82b9-55a2-a75c-486886c96e9e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SA2PR04MB7692:EE_
x-ms-office365-filtering-correlation-id: 0a7cdad8-b190-4089-79c9-08db1e0a3f36
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B8lN0uljVVtR4sbtmHRRk1jxEFFXuIN3SX+fwnt7tsmGrTSC79/60TtOiiY5vIx+m8qsQiAAEq5Ge7g/8MEqkyql4/CYixJIenvKplbOi4a5TgmXOmMgvYDvBK+LZBfcypJSyBMz3bWJyg8VsXYnK1kuwOtzjGPdRzRMpSnWa0ASBg+5xVfrprm02wTi+dVxOpD+Km4ZPU0phpRy59MiZJo+DVCTUKGf1HkRE12xMIcm7NKKTh1vaRisagfiZbngUaZ1hXXlCT/ojRkYZd38Bw/Kysd1EZsSwPdQyuCA+rR44dKwaJ+Gew/B9IGv/cXIsyM1U2q4uCoAG6fdDVmrE8qtcJjen/+Bh69sj+Jdc0B8dRU/bY66PLaV3xlyE1EbYY1z0diKEOmMj9ATxxmAc4+eA7XURn4VZqaH68xvgk9cOPJv1gBE8Sb4wXtQlsGh7pb3Keqzse6hrS6TRtC3mVhJXtUcjCZch0BednUpDfCJA3ILVTMBh3aXeXkNfWhDRdI9KPXGUenQ088IHAIthd91lf205fTU6c6vtjDcFq6z8cgzoIUpQaAuknTPmIydZxhj8uS91ovkR96OJZ4k4ugT/0ykymQuHX6LOb2RiYpHEHPg+ebodSKkDCxeD0yQBfYLAuujNem7ZHFccWOfEqmjzLwyxr4H56qRVqMOT5KU4+TGnnRuKRpQqQ/DAATZzBQ1sNDgoh4mqgi7bBclbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199018)(33716001)(83380400001)(478600001)(1076003)(9686003)(6506007)(71200400001)(186003)(53546011)(26005)(6512007)(8676002)(2906002)(76116006)(8936002)(6916009)(64756008)(66556008)(66946007)(66446008)(41300700001)(4326008)(66476007)(44832011)(5660300002)(122000001)(86362001)(6486002)(316002)(38100700002)(38070700005)(82960400001)(54906003)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nixVhM9q7i4ImR5Dqg57lTJd5vRyYNncKsyrYjJ4p4KwoCVm11aUTWl2IUAo?=
 =?us-ascii?Q?lLujFbghG46i25OjySNGXrzljIFE33wuDfy6Q17Bq4PVssBc5S5n3ssx8MQ4?=
 =?us-ascii?Q?81toZ1qiS+tU7KxjU9hZF72yuVBjaC+wKR0a+njgs7zDp/cegkwgOvOB0fKd?=
 =?us-ascii?Q?G0U9fuEDlcDJbjHZg1bjglKEbagGk2i+2xTUpmUochzH2nOoMFjKz0QOppSr?=
 =?us-ascii?Q?KABszWoYDDteo3Ugt4ojNIRoWRcYrW+s3hQmHCU3yv+C4srDNzeJI0oVETOV?=
 =?us-ascii?Q?5aFSbMcSp1ikh0nXh7WECJlp7FQ4kMv+pjrdC6sN76Dc6+4NtvouvPOGj8px?=
 =?us-ascii?Q?jg9li7aDMxxsCN6ZRQ700hJuGZmkF28+RLn3tnguqB54U9M9DFXwulioSz7q?=
 =?us-ascii?Q?DJiCovIPd4OjK8RpeevwgUI9p0M3saIdR0aPUXQMEICOgqbzOWft9XBin2V7?=
 =?us-ascii?Q?A8ukW4hcsSmN2RnN6nl/yFN7hRmXd+E8VGM+DEqWD4AGpn2LNZkiqnaW6fhe?=
 =?us-ascii?Q?9MlB4VLcBOk2EczcHGpzm/ZiChkbUfpMZFAVGQL8T9mJx7SfOJuIHjgG1L+o?=
 =?us-ascii?Q?BCGcWjFR4NiXz3WWLcvV+LUuz68dsqYIpSq3fmAE132jVP3s4HKLNE+K4+nL?=
 =?us-ascii?Q?JHMbbstE4HG6BPiQwU77KKNKLskOSKS6YP+00T0pf46sN6EVL7gXh6bGz2Pj?=
 =?us-ascii?Q?4ZZk/XTI1vBJ7dtIS20o33N8FNuCtY63uc80RRE3LMSv/YC28EKGIaI1wP1d?=
 =?us-ascii?Q?0rwdIPUf2w61kBadDXI5YGssvXFIN2nKXkq5mLisfYOz/CAfVUGU1X446uYH?=
 =?us-ascii?Q?yV3KRAfQuDZ8t6CRNd0qjEBY3/yJOiDjEwSNBqya3mfXlpTIBgGhzM/I4/Qp?=
 =?us-ascii?Q?UGm8IolmhIQK6ZHwd67b3WL2dh/JJrTB6nAEyUibk9SBlC9vHoabLiwRIyi0?=
 =?us-ascii?Q?PcTPA+QbnNHvWCqxFLb6BgOOtQyOrnQpqDw6YLBMSBQdLaxhkb8Dxgc+WTCl?=
 =?us-ascii?Q?cCZd3vf1uCO7Cp6EOdWrQDA/juLSOX9PpPrqlkvKRp17F9Y39YAfaoF4/IqL?=
 =?us-ascii?Q?thKsG1bOqKb1BsBiaxnysnTakRQlT8ad/kjPmUteZQvUvkAkwniK5Tx09j8d?=
 =?us-ascii?Q?irbOszTf4xeE8Np7bsr2Dp+uxrhFUtIS3AtBbHmM+306YRjQlBe8FK2rXuhu?=
 =?us-ascii?Q?P/NMIhAI3e0utCdnBH7F1uhodavebx2sJOYxeHrBIk86XgFKiP2REeCdeSEN?=
 =?us-ascii?Q?ulyOMxUf1GwjS+bsfhEPeBCd7AtswzvSBtRGFvjK0SPrRTaXeQbDj+/dfykc?=
 =?us-ascii?Q?5HFWwndqyT/nJGMXz+xq54Zz+eU1u85mnp/Udl66NKabGVnEwchOzWzHfWv8?=
 =?us-ascii?Q?+g85B3qe0rXmneHo584oNvvdIjZMGBr7As900Nzdb+sg5WFK6/p/Elrrk2Q8?=
 =?us-ascii?Q?A8fDSUwxhtZAlQwsD6/JKk6JoyKwHmNCHNx33c7jMrCX3mmrdhzE4SBDlNrn?=
 =?us-ascii?Q?/YC344/qohoAy4zMbcGgbw1G7vjB/Pqvuwi8K6JfgUVTemZGO5CuUIbnD0dg?=
 =?us-ascii?Q?ZKZQrGKl5Ipu46raWtX1eHynt3orNuvOccMBoZx7RuNf3Z3nV5EKMIkZXcFF?=
 =?us-ascii?Q?JcuC26zNEDt93Xcyrri1OXk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4FFF8ECAA65EA34D8FA445403DD14D0A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: thapTOUJTX7v+pz1FF4TCuZi7aQ8VWTngWbRBMe7V1KhlsAhuAfIjlUeXVavOsqb6qslDMgjmbe3ntLcRxkjCQan2BYvK3dczrIioct9IEaBYcgpVpoqaQuL1v0QMVyyz51NMQZ56lTm4n6HbC73hh6aJaMAO6IlYeNuGMfPBEsmvVutG5yFudAXwaRrg+yLTxK5MZSJmTIY7AdKpNxoKQnjOFSh4zaKsgyVYa4cet3Xw3zjN7xY/JgPIOyb+Wt8FkgcuD+H/0fHh/tsFB/puLrUvP1RkRRn7GF3/0PdGdgUiXv00RJE1hLSxgI7OjOhP9dzJXqNKO9fjInyXbpkZl5GmwoByBqR9P2HoGELTqX5LRdwibZtKKjBFGbbaHhSMl9tvZknSNfAsZsEY+WWNuAfbMsmrx7mvSmOFCQuFaPwkIT5QVNeOZu/ddpUrfrflmfILkHci/6fRfDZKM4FmoHqspQckxL7bpBzoARy1NBFbQYpB5OJQxx9aO1U8uTkhZESS3LveWFvW8S9JXiKGOPI3HEq/MP0e2rddjFJn0wtYuz2mo/H8ffekKBarnDqXyqwwe1WKDSEc6F1wxLCvau5i0L9PJlNo98D/yTabkKJUmTWiYX4iCFwOK2MIrbupObbzmiSZJ439K9ha4Ahk/kG888cXTGxKXbG8bjFFpOhebt/e2QeebRkSYoetTmMCPbsYinQSsnyEmumUAOJg4A3fenhc2QiSi7JRw3/Q7UTum0LGZ3kUYNKYMbXuS7AnoA/GI43GtDlbnOvFc0FuCnQU9ere9v+cyjZQjq/EXF0Uznu6OkZgRTn3su4DXg9mZX2qjr5yafOBBvXzn7vzA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7cdad8-b190-4089-79c9-08db1e0a3f36
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 06:15:56.1629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w0acOSmG44bCYtl49uNm50C40jbRP/IyFEhoYgEzJR4lFcL3CTQ7TCJBe85HLnf/KZAUtRnDgjb8mTDFp/BWLGjKDTWD/fCqBZQQVNGhDO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7692
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mar 04, 2023 / 07:21, Bart Van Assche wrote:
> On 3/3/23 19:03, Damien Le Moal wrote:
> > On 3/4/23 03:03, Bart Van Assche wrote:
> > > On 3/2/23 17:44, Shin'ichiro Kawasaki wrote:
> > > > +	if (sdkp->device->type =3D=3D TYPE_ZBC && blk_rq_zone_is_seq(rq) =
&&
> > > > +	    (req_op(rq) =3D=3D REQ_OP_WRITE || req_op(rq) =3D=3D REQ_OP_Z=
ONE_APPEND) &&
> > > > +	    (!IS_ALIGNED(blk_rq_pos(rq), pb_sectors) ||
> > > > +	     !IS_ALIGNED(blk_rq_sectors(rq), pb_sectors))) {
> > > > +		scmd_printk(KERN_ERR, cmd,
> > > > +			    "Sequential write request not aligned to the physical block=
 size\n");
> > > > +		goto fail;
> > > > +	}
> > >=20
> > > I vote -1 for this patch because my opinion is that we should not
> > > duplicate checks that must be performed by the storage controller any=
way
> > > inside the sd driver.
> >=20
> > Sure, the drive will fail this request, so the end result is the same. =
But what
> > is the point of issuing such unaligned request that we know will fail ?=
 The
> > error message also make it easier to debug as it clarifies that this is=
 not a
> > write pointer violation. So while this change is not critical, it does =
have
> > merits in my opinion.
>=20
> I think that there are other ways to debug software that triggers an
> unaligned write, e.g. ftrace.

I see, then let me drop this patch. I will repost the second patch only for
reviews.

--=20
Shin'ichiro Kawasaki=
