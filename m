Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003EC4F20F
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 21:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="k/7TbzAa";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iMz2ksZq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1704920980; x=1736456980;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QfFPKE6Spop+mboEEMEky8HnHyy3D8Hf1JEWJZY8hnc=;
  b=k/7TbzAaHV2x/gtzs6fYZQhs4qsTZvZ46i9Ia0fht+wyKktt1x3ZWLdm
   qYHM10KCS+DEwZhzIZV4IgY0z0K64i6zTaOOxp6r6PLRwigmUU5a5TK3y
   EYmT0DrO5jm42dNWezBUcu5FnJqC58ickwtjzcV+csb9cplIAfacwqcTU
   vSyKJYlvz8QJEwsw+KZu4WoteGD8aTh/XL/VjFVbk9vhyA9sQs/SWAJjO
   Z5lu2ZocuzUIiS8XMGVTloS3NuXIpPe9o0rFGrdQmHJGvbzS5+uMWYLVB
   AppS963vudL2C6fmBS8e3dVd8CD7efFo7hPOI2lT438k73qpu31xt4VYV
   Q==;
X-CSE-ConnectionGUID: GInsAT3wRn6sg2+jfema1A==
X-CSE-MsgGUID: qCynScTNSz67LMH232q/QA==
X-IronPort-AV: E=Sophos;i="6.04,184,1695657600"; 
   d="scan'208";a="7067669"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2024 05:09:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNCXiMkTU/j0igSWGi3uzJ+3hKX8RuXBBhRUtoBwD06mq32PCzPJ5N0T7dCzgzdrQQt9QfYrfErNkp4coW+UHexZ2mHRus17mT2OpnSDuEtmJTMODxLpWP84WyU1JgRvPCU9p5asLk3rAICwY6VPGOnaBE0H98EQj9mrlcMLwptaddw6x30iL0BTqgSD3gs9MeWJ7ImGgnzbQHyuT9Com0C0kvY5s+PZkSrlL4UVr/8sLIN6G/NqrVJwZD10MgO9WD4NojsOKVU6zUFoQY0EPI3NjPUjbRKw0d464LFmfpMhOluVeVD7bNjaI95giYELSD3WaNFaEwgcetTls/g9AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfFPKE6Spop+mboEEMEky8HnHyy3D8Hf1JEWJZY8hnc=;
 b=TuZXXHMwkSWhXZ0UXXYXH1lnZdLCOrYqcPUs6/y8MdE7bqOnZGVYk9fAlXNeHEDCyAhTY9bMShs5D3DnVKKIm25rKGD/+alc6ZjB/WUxDsJFQJH8giSbpXvwLnhRyhQ1YRb5Ke53OeG7YJarUkkiRC58NgSDNVAWt75uii1pAJ8Tmz9cbMD+7unaG4b1IftV/31x/vAjQJpwMWGs0u7bI5GCZLp8xcuTyjz3432L87QOS0xeYjDtFj6TU3nEhhQxDuNp6qHmNTUMApRRLzvTkCJUwZJVeqHAvRtcZK5hAHW4WKKjOSKjHcI7oR5CWiREpfzkYnE5DJOb/j1zCoRLvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfFPKE6Spop+mboEEMEky8HnHyy3D8Hf1JEWJZY8hnc=;
 b=iMz2ksZqSPi6yNUuxlSuR2k3uOwobKHtWrnLP9bR9Tdx+h3VsSrAwKxvZmFIwf8J6EaktmFIFwON7n3eiu3cwFHS91fSbObjFk9HlZhsQ6o6rr0LoJnv2OPaM3IkHXkB0/P16EzH34myqKsPo/Wac+JXFrXCs5+GDpx+SqC+q2I=
Received: from BL0PR04MB4850.namprd04.prod.outlook.com (2603:10b6:208:5f::14)
 by SN4PR04MB8335.namprd04.prod.outlook.com (2603:10b6:806:1ea::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.18; Wed, 10 Jan
 2024 21:09:34 +0000
Received: from BL0PR04MB4850.namprd04.prod.outlook.com
 ([fe80::56e9:30a:5826:79fa]) by BL0PR04MB4850.namprd04.prod.outlook.com
 ([fe80::56e9:30a:5826:79fa%4]) with mapi id 15.20.7181.018; Wed, 10 Jan 2024
 21:09:34 +0000
From: Niklas Cassel <Niklas.Cassel@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: Kevin Locke <kevin@kevinlocke.name>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ming Lei
	<ming.lei@redhat.com>, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Thread-Topic: [Regression] Hang deleting ATA HDD device for undocking
Thread-Index:
 AQHaQmrU1AR/SYLpv0uiByM2A945NLDQb+2AgAAF8ACAAY3ggIAAAc0AgAARIQCAAXFyAIAAAP8AgAAErIA=
Date: Wed, 10 Jan 2024 21:09:34 +0000
Message-ID: <ZZ8HjQXC3vp2lCuv@x1-carbon>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>
 <ZZxvPtrf5hLeZNY5@kevinlocke.name>
 <8bbbd233-69c6-4f20-904c-332bb838cc42@acm.org>
 <ZZ2-hMYVJlF4ayqk@kevinlocke.name>
 <d585753a-b5f3-410f-a949-8b52252307ab@acm.org> <ZZ8CzOaXBkxyKxNw@x1-carbon>
 <1c34e2e4-4bc5-4142-bc21-3db3a55f638e@acm.org>
In-Reply-To: <1c34e2e4-4bc5-4142-bc21-3db3a55f638e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB4850:EE_|SN4PR04MB8335:EE_
x-ms-office365-filtering-correlation-id: bc2fe4e6-edbb-4a73-6e12-08dc12207263
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 5U9JveKqHqEGYp91asmOyO/DwRYbhnSWWzYATaggZImMSQ0QzEgKW6NZ0Zj2Luru4ka3PkAhMZt6mCGV++zZw3TFZK2TBezPrmHzMGnagTe2JUd07wB6pp4pPfDUf6BSz6bV67yLCStapUKec5+AdRjBBwt4jtxfIFQDMT+RY3xpZiM7+9nQp4GNDRl9a+0DVHxMksHFsvM+84PpbbX98Nj+akuD5cSkGsJEZt+9Ks4JTJ1vFn9XzYVxC3QVN1qcDVRvLM2/+E1jg61y8L/bsuGgzK61H4FJtnqA7L+BcDDnE5Lglt0Lnfx7iRAUXWpdFpFpB4DM16hd8PTmY898r25uFDiMiASahm0xPTQmdWE5Ogp1N0EG1WbwKn76h25cVap8RIs7zOIE/xe0iOI4rkYBLu1sgp/m9sQa4hpmw/5Cgfi7ZhO0IAMahPR1xtv3h8Ddg9kAx5ygGklmmV02lTsrAE05S7cRJt5fWcZoG9mRnbNqkyPHXnZ3YuI/HquewcMd3AWePcCZg9Al7X9oooKmkZ361sqzKp83YRQml3ot6kkke6amber+dmAqaaFbm5KcNtPjJvFj1CrNYwja21zBbMu6hUiT1rTARtJJ3BU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB4850.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(26005)(6512007)(71200400001)(966005)(478600001)(9686003)(53546011)(6506007)(83380400001)(5660300002)(2906002)(33716001)(41300700001)(91956017)(76116006)(66946007)(8676002)(8936002)(6916009)(64756008)(54906003)(6486002)(66476007)(316002)(66446008)(66556008)(4326008)(82960400001)(86362001)(122000001)(38100700002)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qm2NAnZWSnnZuRYi/zADl0sfddB3TndFttybK3cUTbmIMgf1KyoBZRrhOb1V?=
 =?us-ascii?Q?oy9rwOvnvJOxILeTm9IEGxJvZAAkxVKbGtcNrERSrJKw1CAY4L0ODkoxuCi3?=
 =?us-ascii?Q?eNfA9PdUfhDc/RmEg2/XXCTZZxan8G+KVXjjbsTiZX1KFV2RitgPjiNNvagS?=
 =?us-ascii?Q?BcJpgSC4l0BZa4D9AmNre82eoNUZIvZbJQWmOLh6+Rj8jt2LZgP55DXgKN7T?=
 =?us-ascii?Q?BMcyHtOQEySQUashQVZBsqjC7YXYkl2wGUUgwdasHHdFOmNtQdG5RMFxURT8?=
 =?us-ascii?Q?+yawJRPbH1bf7VDU6ospX4harJzsmhWtd9MT1bpd7fYDspxPL1kwEIY2ZJdc?=
 =?us-ascii?Q?ZF5TISHrfXKL8AXADbnXFvgSiauTQXw/gceFsF+X93nPpEDSCPAO4TbOFxAv?=
 =?us-ascii?Q?VWIxuee+8PKXBojvrzirx1hQpaxgg7MWQKGB17B32Uzpfm+ZTpk+uP19IDTt?=
 =?us-ascii?Q?ig3PXx0JB9STZDIrI6tsHp0k0rSy1SMWOBvp7ckKumopeCsQ9Rig4eCxrI7U?=
 =?us-ascii?Q?oOjPpXZJ5GB95Kioh1s9KlZYXVQdQkC/9WFIfDjx6jTRJIbsFqldAGlxy1xA?=
 =?us-ascii?Q?FISLoqM/Zt5oIj4HyEvAojPGIAgviiSP2gnBYXsn6KCBmVwHchN9DVPFQmRd?=
 =?us-ascii?Q?vgVV9c2AHB9fWGgjUSCE2i8lTb+Nwo1xINw3FycfUiAoMLWwvTwVaWsrd8EM?=
 =?us-ascii?Q?H6qLdZWy7q/okpFmk4CLeyEFyie1yadupl45SrpHuH+Ukc73IxnkDCDG3SGG?=
 =?us-ascii?Q?jtc6438PBl9g/A23AJ836btEykeSqfDX/7AEXo9bGKn28oFaYSfy5aKvi9Bh?=
 =?us-ascii?Q?MpRQrUc0u3XLGisx3qn5dOd2xG3KFgD38U80DxfwztxKJTDhSJXjO14t5AqB?=
 =?us-ascii?Q?n0mxMzq1KYcM8OIk8Eg4UA141Rtmj6gKRneXg4FwdSGL8QpRZNf5ESF7eIu5?=
 =?us-ascii?Q?6lVmO5SrKZUmneMg4olPILkECXrufKIA1lcKJZ7RSQuInEG7Z+v4cde3WvUI?=
 =?us-ascii?Q?BRrmdVLlrtHa4l+HtBkBno+ZebRTNYqUNiM9PzjL6PWcDXEIcfyMfsbiaw0R?=
 =?us-ascii?Q?McFfcvsKYEShBb1sL7kU3kczyRt8eKJEyovLfDf/ymbtjLWIEYxGlMVZdcuK?=
 =?us-ascii?Q?Mz2TZIAN90cNElHgbE//5+INu03ljwQzBCONKaHwGVl4RypUw5yRODR4COd+?=
 =?us-ascii?Q?U3lAqMQQx8IQU+AZ6/wJPT8eeK3tLb+NjIDAED/idM8Re5iSCGKnvP4biGK9?=
 =?us-ascii?Q?Pf+cMiXGo7T4HjW3nfRPU1mc9kvuuwpIf11Ni6J1SBw0DpY+04d24Oh5hgoV?=
 =?us-ascii?Q?aLFBSczLROhUqEEg+mMvfYVIT/EcoE5tHffY0d7Pm7spt2doTwcnEFGlzOjS?=
 =?us-ascii?Q?ogdYxT3fLMtdfAokJX9okk0/Gge2fSEVllgB4tLyIy74PnldxkSP/zZGvgrq?=
 =?us-ascii?Q?IlUPBLgjWk/YfKEX7FCdbiV5OZR9JmYHqGWZx25JgLrvZdy9vJgf4KwnKsv9?=
 =?us-ascii?Q?7ohn8CdrEbOTvlQnK1gNn/aj/QHQBDwR6s2YuCnKdKOIK837rMMeFZijNtZx?=
 =?us-ascii?Q?zE/hEFffL58vOKHnqcw0bcUCUNzdVw9RINKZZvk9DyV7JAgfrnQcL3HSjtFX?=
 =?us-ascii?Q?3g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <349ABD970E6A494CA18FAE1E14C3DBFA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bXJyxoZS2RQkTxyj1RqmnnjxNuj0hL3P0wt02A+zXUHYJ0iDzMYCuvpCFHyZYs+NgwOPplSnT6rG/O0seevtTc0e00N/WAnEPdIBun8uyMwHYgmOWm4Pe05g1Cfz5Yd9XvgiBNqXEHD3XHdrFy5SS8Awxx+pWGQFzBP7qzts5GB8HLOo9u2Y73xNV4n9rbDE5gFtWjJiYq449FNARlJ94+FDN6LaToXe8Ju9Fro3M6FOWrHID5rltk48arnX2gEKOvef90Yeg1w/4Fjar0lmgwRsQyfC0UFB2zG4TgyiZzmLTrf6PrYW6OZw1C64nFVJDe14yYKM/VcO380Qu9Fz/2ft6JiVSHjE8gLGDkCyFsaD7TbgkJ7kn5fPQ8SwMaTLwetZKw6P+LnCTyxTEwX3EuGqq8TDUw0odX0m/KDa3aCOppPvaYv7VPsRffrYG102LWjDm29uiyLoUUpTKeBAAO4yLrRufRi0ILsBNTEf9Tf+lpufQGjCSK1AYoB0ikfYVgdKfQpBcEyEvtMZBF3Jf22nlZPHFtpQS9UuGKqNaOhoJ1YQs8luDmVJW+R3srYTxguK5TGOqA3leBawAkSIBlqbPX82G+6VwzMn9qM6f2CI4oG18K/jqSBsCAFxfQ+a
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB4850.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2fe4e6-edbb-4a73-6e12-08dc12207263
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2024 21:09:34.6534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: afCUDuDdUAgEZJGvCVObrCbb0+5kVnpIgOb/CwpIk+kc1Kyq8E+BbtDWMSTOvMNSgz2UVnzIRGGYYZQLXVS0/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB8335

On Wed, Jan 10, 2024 at 12:52:50PM -0800, Bart Van Assche wrote:
> On 1/10/24 12:49, Niklas Cassel wrote:
> > However, I'm worried that applying that libata patch will simply hide
> > an actual problem in SCSI, which might lead to someone else stumbling
> > on this SCSI bug in the future.
> >=20
> > Thoughts?
>=20
> Since the hang is caused by submitting a SCSI pass-through command, I'm
> not sure this issue can be called a SCSI core bug. Aren't users on their
> own who mix SCSI pass-through commands with commands submitted by the sd
> driver?

I tend to agree with you, but at the same time, it used to work,
so in one way it is a regression...

(I can hear Linus's voice saying "Never break user space!"... in my head.)

And since there seems to be at least one script mixing hdparm with sysfs
delete:
https://www.thinkwiki.org/wiki/How_to_hotswap_Ultrabay_devices#Script_for_U=
ltrabay_eject

there are probably others as well.


We can work around it in libata.
I'm just worried if there are any SCSI drivers using scsi_eh_scmd_add()
together with scsi_eh_flush_done_q() that will hit this in the future.

Perhaps some libsas driver?


Kind regards,
Niklas=
