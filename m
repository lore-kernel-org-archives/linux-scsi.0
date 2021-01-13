Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF4DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 06:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 509402311F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 06:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbhAMGha (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 01:37:30 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:61342 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbhAMGha (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 01:37:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610519849; x=1642055849;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=IF8MKUuLiK9o5OJetMnzov/tKtcMuPBJjgPMOQN7Kig=;
  b=XD1hG+VzMHoAjeg9M/ADgq7fXx+WNpc299G06gKWybW4xKhLDDEqeRYl
   Qy1aqAyAAw8wTb76k/Ru6k4mOlF600w0A8TCAoNm2lxsEdyO7iEZ1kFm6
   nNCyTVphUoiW10Bw2oK2OAu+qXINEpTlPtu95Rfr4j6W3Gm4kqprdkuI+
   wbAh6/8eeeJzUjDVa4qYMXvyEIjVJGDYy5KmIw6kX1XAU07km94/q9W9u
   664vSsSQ1A+3UhfPqQO9RsDY3asOJc9t2YgnOVgimHTD7CDeArSTRKNqp
   aFNgxjQzCUfnlfLHGarjjfFA4O7rF2ZSrAjhYVhi6qG3MfCQ43jVrZ8go
   Q==;
IronPort-SDR: 6Kt87QdrWq2jhfhVLVxN3KD3JgTXpuJ74rDZ5x+VzySVPCscofhUcGphFkSsQnawWIXNLd3GSN
 5cT6Yupv2Lx9tJSOVa+F9nGOqt6LgWzMXlQKdxzz3huTWsMO0NwD1x5shbTZ+sXp7aXlANgM0v
 TBMWun2ic6GmHO6JatJr5O0ia2yHoNw4aoUyZ+Ct6if4NyaecAEZ9SrNcKi03Nebmcm23Q6nZO
 h5jROeXLO4iaPU6IFDlzdntt7xJq3nRJXc27tsNiv8dQdxnWk9cUNIVIR+K88ZQja2yIddYSuU
 KeI=
X-IronPort-AV: E=Sophos;i="5.79,343,1602518400"; 
   d="scan'208";a="157311972"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jan 2021 14:36:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vr8KVvzIKmZRIGUbiUeUBEUPl/5+4sxFjeR7puiaHc/++ZbkHYRV2FNP8TrJzqykcdZqNVEgMHLDB9iBzRwJo+A+UnMPOtCQ69v6LkZdigIrW6FHFnSWCSM/1Q298RM2Lk4Ca41+UGCY7RQ+4YPcItuz/fGrWqt7HN/oGuPOGZqg0SXHJK2gctczwjA2nS4HBKD0AVwyx8P2apORn63lOMxthJbIgXrrWn5D/n66cj5duA7Lofm2HoILYhOYrUbUTbp2wz4QRurYhveG7lhwy+xp+oa0bdZEU3A71UX1cbS7AJSjFIKJJTv1VJtUO8Ouho5WYE2nYYNGHydHFY/u3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF8MKUuLiK9o5OJetMnzov/tKtcMuPBJjgPMOQN7Kig=;
 b=N+dmNR0qY9zs6j671b53McLtQiKer5niMlmQqBZfZBXzzA2W0zD918BsYXzhkSQpPO/PJXns5+7Dr+8zgT5LtampbtFz69umUKZQROpDLXHmPkPTI2Lcys4Vww4NfGGTCo68rynLz1HDvJ/Tck4/bdSHRTOFeWCiuGwPomWo1I2SoBJ0N8idWgn9Q0ac0UFcYe2tlQlItx4Z7uxRPtZTU2wGlOCm5q8PRuNpeqS49CzAJVR00sQSKGAL65/Ex5y9FzKp03e0fEuxKQKqQufOkHZsWoVTDRZ0xjE55c/iB8U3IebUWxcgeotHQhe1eHj2Wtkm7um4bHmdRd76hx5+Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF8MKUuLiK9o5OJetMnzov/tKtcMuPBJjgPMOQN7Kig=;
 b=SAgbLwvpwMPrgRRfenS/03aj/98ZV5vsvLxKVrNcKVs7AQ7vi8lv1Jo3vDmGuBhZ0QzxKuZ1NSw+5m7jiyfKLYsbTmJX8MjQXrDinUmvZeb9xnM60v9ln4viXUNd7/Mc1xwh47cJifpkjpOhRc6SDgJ+VHgQJuoe30dFquMbVtQ=
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
 by CH2PR04MB6617.namprd04.prod.outlook.com (2603:10b6:610:6e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 06:36:22 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a]) by CH2PR04MB6522.namprd04.prod.outlook.com
 ([fe80::897c:a04b:4eb0:640a%8]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 06:36:22 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>
CC:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        chenxiang <chenxiang66@hisilicon.com>
Subject: Re: About scsi device queue depth
Thread-Topic: About scsi device queue depth
Thread-Index: AQHW6DZDkGmGUhtJTUyXH1t3aSt6mA==
Date:   Wed, 13 Jan 2021 06:36:22 +0000
Message-ID: <CH2PR04MB65220517ECC4015D8A9002BEE7A90@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
 <yq1eeip1j4u.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:e53d:bea0:4863:19b6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e463ef3b-689b-42cb-cfe6-08d8b78d8b15
x-ms-traffictypediagnostic: CH2PR04MB6617:
x-microsoft-antispam-prvs: <CH2PR04MB6617F12F5ED955531620A7AEE7A90@CH2PR04MB6617.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x42Sj2QXw3QKjf+eQ/7K9pcgq7vhpoz0b8Ud8ptCPYZGPERG3wwn+ricN7nao1AmCfR1VkdgGK3y5YlqNRMzQGFlcEG1S6kJkfd4JIMAZrSV5sj24IxV4U1P6z/ORRc7HnoqBFfBOwsEefe7Xk6SmoyC/J0H+ymDYHLpGG3ysykeGeqB3g8J8H+ntWWbjN2EKSy9P8eLZTX3bm4Ws+Fz97kY5FagsFuohU4mO/Qatt5mZVD4IPQ5qyggJl0ZVQ9JYxl+PZ3RG0M0yLnVvyV3jrN7nsecs1gW7H342+iYdGeuYagBONqf+iS7NHJ++UaacTQF/IQF86gPSg7aNcXdSJxGdt2kXs/5T/k9GgZl5LM43/VIOcTzqb5LAbecLdIWZme8QOjkUtDWEh4tMuimcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6522.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(9686003)(186003)(91956017)(6506007)(55016002)(86362001)(66476007)(8936002)(71200400001)(54906003)(66556008)(66946007)(66446008)(316002)(5660300002)(110136005)(64756008)(478600001)(8676002)(2906002)(53546011)(52536014)(7416002)(76116006)(4326008)(7696005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Kspej9Ut2hQwGqaWmDVgjebxTOriS74wPcJlnnREYq/557fFrU8UOmPUFd1N?=
 =?us-ascii?Q?kecclc5S3Sj5jO0O9v0fKqdE+AZxTH+7ACtmK0ms2UN31y39iuiO7hFufFdF?=
 =?us-ascii?Q?2157VRylYDNUpqhcUIwfj03F3jqgggQxRo2itWSaXbKjQQ1ri/twZxQI+gLn?=
 =?us-ascii?Q?WfvhgMOyeraFwaKEIfLPuMQJHymmwXXewf9wwAkZE2xybT0aQb4kn38jMgOk?=
 =?us-ascii?Q?7psJNzqU8zGzdwWIN4RBN0k5qiDnIJawmaHa7hCAVgT89ZLyNEkBpMJjfW3y?=
 =?us-ascii?Q?gf9VZa/oZDuCjHdpr4aTnIznuSpmIqD70u2wBMerMfVDywQ5Jsmd1gwSjsZg?=
 =?us-ascii?Q?e230BkjRFFfUrabsL3z4ZPJJ+f2VPh68djHQp9nXlwsdxwU/n1fMqfoJxvlo?=
 =?us-ascii?Q?ocvvIQwS5+l1BDx6NR8QatMu5VeGvZGuhPlghOFkAneqV7qH17obO9aBv7QS?=
 =?us-ascii?Q?/CvjEqHAsKRB1AnODH1/8PtMwlZqUghGu+MgUFL5Qxtw5RpgmwHUfEZDfAnd?=
 =?us-ascii?Q?nsT6YOnmJ8QNCTrAaIiwIG07/xnc/jSvCeVFJG/u0yZxBEFM9q0kXphKGqZl?=
 =?us-ascii?Q?oIBISniuwfED0cMYMY23c73Aj321VjXeFXSgdzsGQMezBDl6QfDzwYZSUkd8?=
 =?us-ascii?Q?PM6XBiDgrGk0AQgdwYzBxcjzMxlM0yesFFDDul0Nf1GAUVDk9X7bPp23uQSK?=
 =?us-ascii?Q?2moTYRP/E4fPcmUAAi7Y6/+AbP3lT4mR11/TBXv8QCSDT9awxXTsBzYLXBo7?=
 =?us-ascii?Q?4tdKThcBTyOsNks98QLtDX7MrXkc6Ug03uB8F+oYL7GTPQBDM5CgCU9UjtGk?=
 =?us-ascii?Q?7JjW6xqb3swDvhtWMqvSGY3dWMAcqxHzRckIzmFRO8+yvcqY8dzuOm20yW+n?=
 =?us-ascii?Q?dRX+y+8CeXvhmsRiNNuY1by1aAYk8ePhWO1d2e62ujurEF0y5LjBocAy51lo?=
 =?us-ascii?Q?PB6yDDd7OUwdlbuE+rKt/t6e6Q437cUrc3qzDywsdsCXCZTPGui8qfKEmGts?=
 =?us-ascii?Q?1fw8nnzEI8tef9g0H2L/90xx2qkWq0OaMm89bjB1KJ8xuvY7ycOzY/0hc5qH?=
 =?us-ascii?Q?AtuDtFF3?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e463ef3b-689b-42cb-cfe6-08d8b78d8b15
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 06:36:22.3345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bYnRTDFZ8UYmdZ7GpXY8NiNqHqgBI7zFa20YaeIoZHM9t3xdUywi0yG1/gzVdY9H2QOpYfYo2qwF0qd1G9n2wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6617
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/13 15:10, Martin K. Petersen wrote:=0A=
> =0A=
> James,=0A=
> =0A=
>> A co-operative device can help you find the optimal by returning=0A=
>> QUEUE_FULL when it's fully occupied so we have a mechanism to track=0A=
>> the queue full returns and change the depth interactively.=0A=
> =0A=
> Many disk drives and SSDs only return QF/TSF when they are out of actual=
=0A=
> command slots (so typically 255). There is often a watertight barrier=0A=
> between the transport-specific command processing and the media=0A=
> management code. Very sad.=0A=
> =0A=
> So while the exponential backoff approach works great for disk arrays,=0A=
> it's hit or miss with drives. And it's really hard to come up with a=0A=
> good heuristic since the optimal queue depth is highly workload and=0A=
> device-specific.=0A=
> =0A=
> We had a few folks looking at managing write queue depth based on=0A=
> completion latency a couple of years ago but it didn't come to fruition.=
=0A=
=0A=
And if IO priorities are in use... And there is the latency target specs co=
ming=0A=
soon to make things even more interesting :)=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
