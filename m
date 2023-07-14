Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4CBC0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 05:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbjGNFla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 01:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbjGNFl1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 01:41:27 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EA82738;
        Thu, 13 Jul 2023 22:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689313286; x=1720849286;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=FWt2HmPi+3eDHi2RJTrpR5j16WxGBONolERUv39FJBY=;
  b=kky61Ncf9GhnL25JZgOAdzQaCdZLYHwlRoDgIlBvSxhO/x2jVnDQlCdw
   rVy0Jp0gkvM75KfMDBaJKt/KrUq4HH7K0pRTnnu1p9mdOSA5daM/rZBXE
   i6f7/83WPTNzUDcW6cFUCdMNWt8sWxG8S2l6Ufcwas0n/uvLwlcFPIedY
   V0s1XiHQ6T6N7ONkLY+ft8Zw6z68otXT5c5LI8a9smbofiYq5OvGNBdal
   wwrdllh88PnSAK9HDqjLmVNPTG+fs9RHreC2O6rx39r/X9rWP2Ah6/agm
   bIDjRl1ca8cXRSMRjcTIymzddDnlIcQtTEEouli6+eMDNOQ7S3ZZd/1P3
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,204,1684771200"; 
   d="scan'208";a="236380059"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jul 2023 13:41:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5Jfs5GQirAZJ0C1Ml2Y94jQQ1I9OzIYxYyzZ9LEojAE9KEeNR+3itdhSnMmtdBDjzb0XTPTaVMmsYgUhRVEzzk7jrzoPXqGaU9KMGIajGYwn5zEWIEJMAnZpSCwpMyNmv97quKNThBB3IlRkVmkfDndbzxVJvJkBGc9ydIjBheW9npqCpx0jdvuA1O+4gwujneGDchfutDSOOJXDKDWyfPogK31Etwe6HbaVfYJTEJGp3Q/UfayhkSb7YMEfn+SoukLS/KzARg694T9CJ/mwzFuhHxAN4r1SV6vn+A/zDdR5EybHRdKUZ6n2D3e+9qzmXNskX4coY45nNzXMW3NMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWt2HmPi+3eDHi2RJTrpR5j16WxGBONolERUv39FJBY=;
 b=DAampQS0IBUGxZT/2z2hwn6T7HYVLGfoeDOH4TS6QczuvzbwsjRBxS3h3N/4cC0+N87IhpIXX+Tjq+5cN1eK71risbAL5hYX+P7h5kfoncdgU7p7jcwlpoG5Rrg4R+BqqbydffUqk6Z4MBr6MeqLmNs1P6kB6/M+sIeLvh3dpAQXdsK6mUObah6RMB8rEAFnlmDHTezyRfJ8CXIoUWodF+4CFp2SfT2WYKDEjYeBpSbDXLi2QmHG3e+vYrbt2ooXdh3ByhDdexhXg/C8wzvJDK4LgZI8Qd7d3E1R3/2o2Eemd56YRtmt8PPSIDqbBWz/fIxWvytq88TihTW9Z47fXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWt2HmPi+3eDHi2RJTrpR5j16WxGBONolERUv39FJBY=;
 b=MtW6zMiA1nYYLm6uCnTwasgBl3OSAtLg23Tz0lRliy0V9knpZkImi690ym4DYJTI3qU4XAvTOat77d/2bOQKOR5HmJk5EVz2H/xLjaolxMCA2xXmcu5+w+sxh0tiWwVpqz5cqe059zPHSGqVGVgf/Dy8c0+9fAl3ozk7SzaMvK8=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB6379.namprd04.prod.outlook.com (2603:10b6:5:1ea::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.26; Fri, 14 Jul 2023 05:41:23 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::bfa:d453:e7e9:8f98]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::bfa:d453:e7e9:8f98%7]) with mapi id 15.20.6588.027; Fri, 14 Jul 2023
 05:41:23 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.5-rc1
Thread-Topic: blktests failures with v6.5-rc1
Thread-Index: AQHZthXSM9oXIpjPxkCbYOzYJytcVQ==
Date:   Fri, 14 Jul 2023 05:41:23 +0000
Message-ID: <mklc3tlep35diuya2nnthlx2n5g75kikcqvmims4uox5qsszay@crbdp52wenhc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB6379:EE_
x-ms-office365-filtering-correlation-id: 519a2014-2da6-4dd8-c430-08db842cf541
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FG3p0FzELmzDNIYDj0L9KCdYeRV5l91iaO6uIPS3gGLM4YhM+NmmpG5pZMX/ZJO2EWUbmsyXyRXtZg2XRtAmuIadvKGlfXDeuiKWIXGiOprpsQfzCw0PsA9I+f+gOBsiwTdk5BpxtDvXQoMo+uu1XPRz0933aYY7z4Z088kT0Lb1gDZfwalbZ52tCsz0Z2ufsDY1T7aqh1khnaXurN6F2FiCPy4Vp4bn4P3YwaOjJJlD0rylDZQ4EiEi2JX7JhYd66VlywXZdlpnCE5U6ESEO068mXr6SHWVNVUMIA2gZNaA0xRAhrM/HryE6+G2ALmNtTz7MXcg1V2sGtq+CxDnu/sqxgai0azdmI+BsjMbAkULeU8ry+rWJTEJL4YCNk7cJM2hm3LmBpwPI85soSGpEB+iXWBNFfq/uW5KqZNpPuRbB0Xzok56maH8aXH6PgZF2LW7F2nmse3kWQoLuuKDDgVVwriccsLNCR+48pGB9J6hnn/lpkPe6b2oUoqX6rQOB4BYQMCPFP1UGr1plCsmftDdOfJrtRZeForyVw+n86VOC+t3mewi7DFuqWeV8qebxDcT9fOjuwFffCI1Iv9lmrNCWYoGrIu9yxQeMcM4UY8IcBWWZGI534ypfyjCNfooNA8Xypy/zjyzJI2WN1pthg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199021)(66946007)(66556008)(9686003)(110136005)(83380400001)(2906002)(6486002)(64756008)(66446008)(76116006)(478600001)(91956017)(316002)(71200400001)(66476007)(8936002)(6506007)(186003)(5660300002)(44832011)(26005)(41300700001)(6512007)(966005)(8676002)(38100700002)(82960400001)(33716001)(86362001)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SWFNJy+2NAaNyAVGq6yB1GKsJJWqj2qgWpUG2mrujvB/MCkhkHSHIp4n2V+O?=
 =?us-ascii?Q?/9LidUdjpqlaAUQ+8M3V5nASTpJCpNnijccF3W2eTeOAnL445Rs26BMOSjZo?=
 =?us-ascii?Q?d6O26Jzo+uJ82If0B7X6TN7Mhqd0jao1Pj1wAp0sW0onH/xYUPJQSlEi0GGC?=
 =?us-ascii?Q?bxB+Aj6rZdimFhM93QrzbnbTwf4FCyEl85oo36/ocnSkOJB4OkIxJfgnDHZ1?=
 =?us-ascii?Q?WVgXLsQ0DQs4sUKB4hwMujnXde6uilsF5hs0a+Rlussby5a7LnarXatZHtSE?=
 =?us-ascii?Q?E48sGsu0C7YfxcDmYzHTZCyO0GU6lG9LGwL0Vwj0OOJDUtXR9ZL2r3MQzVnE?=
 =?us-ascii?Q?gXGn2eLMxgaKSTD+Yy9JxoX/FPOVlRNsHnhBRGruaI2DFhsD8aCLDfn2XD6t?=
 =?us-ascii?Q?pOQRHv9kCuLXZ01BkeW1bDn2psVWHXRbFmEhOfMze3D5mO8Z6a8P/JXchkku?=
 =?us-ascii?Q?lVKBtsz+thfgwUT/3+9wQ7qlVNApVAHwlCet3Y1O50C+mC6TOrtySpjLU72O?=
 =?us-ascii?Q?J+ADOD/MrnGqrqCT2Tee7z6JrguYze9+ltgOpGgmuz/+9Bddyax6jvYY2e1u?=
 =?us-ascii?Q?o0Brds5VKlySXWCRQwBLgWo9Jr/SPfK8GtYgvzaTKdUd2QJBu/iP8+ZC36/m?=
 =?us-ascii?Q?Y23IC3GQTGCw3qPuPnapFBYVZI94lYu5XyZzbSJFEjTqbir+oa67jIZYywX1?=
 =?us-ascii?Q?gURFzaLRKfD1JE2kGvzx7YKhrSEJEUGm/QIfnoGViPj8sbIzS5gs3ZyzlyWH?=
 =?us-ascii?Q?tQXXTz/KOHUkU73L49+7hyv/6zm2zbSmj3PltDOhKQ1jTGUorkHEV3N5iAHO?=
 =?us-ascii?Q?FqRxpoua0N92ky7JCnjt6GN32M2b/bBhODvSD97+TB32TQwoHNH/rf4ZipPC?=
 =?us-ascii?Q?VZj+tjPNQYhvKucV6gRkDL3rgA9OKU9XiyQ5Pat/DmPUxTvIZ73q1O1VtFJe?=
 =?us-ascii?Q?KtP664ADA28h7Ip9y06IgJKpiVditwGI1PTMJp8Y7DS5ufwYo+9vtSLA70PE?=
 =?us-ascii?Q?1B8/d2AOBXYp8Gf6cNNd7bm2o7pB8kmn954uCab2BIkSDkJdY80C5e7Cu789?=
 =?us-ascii?Q?4dne9fvqbr8doy9dZVNw/In7/H8/lRiF7jHLrptq6U+KMFElbOWHdMjuWw/t?=
 =?us-ascii?Q?JZGIrbIdOROWpjKMCmzQLRwd5E2FlK+hau4F7BY7+vP3a6CJ3LqpSRiwcEfo?=
 =?us-ascii?Q?n+k+RSzej/napoE6h8UEfsWpjgdxjkW96J8HV8SuMgHTDUJ4K19TPqWAz/Dn?=
 =?us-ascii?Q?jsCq9/qvcdhu5nJrVFkZzWeFfK0bY89g5fPO7RbzsNexaOI5I9zWDM9YjrsD?=
 =?us-ascii?Q?1G/PI05kGlfa92ei53msr7Pq+AjX7DwgER+VeefTLF0wCE6CcNQ8uClXmHRY?=
 =?us-ascii?Q?a+U3kAPFhfc9ngM1QZPB6Bm07Kto46laihJNKdNJdmp8OlZW3aWp5BWOh6fw?=
 =?us-ascii?Q?DWnNkMWygK+oysU2+JhGcKQ8rI2J4Y/gik6Cc7Irs1JdlF7rsdZGWBd9mpiC?=
 =?us-ascii?Q?2wX4dgFiqWALter5g7CN8ygrvXBUZEg7uZABWzma4J6xtVZGKicMFJHpVFKn?=
 =?us-ascii?Q?VGas39lBT1oklYhVLo1TniM6W7MLlOl+xalcfFTkAiFGhBFlVJmJL9HeCUMj?=
 =?us-ascii?Q?Qz7DF2V6XoLMHkGN8kV48cA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6942E16A7DC8E4DAA75B2EAAAC4D839@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XnZ89kypdyXYizDJed6CgBtJZkoVK4sp6xqbmqmTbiMLvJiD0gZcb49ZwCU7DHpmyUHcSxrFJe9Sbpi7huHMEm25bbRY4g+NPgjaxSbQQfdfIHwPZqbMd6z0Lx+J0Z1fl86MU2ZwPfpDZxSkAFWPcNmqCpVLMxFZP41K53AnvajnzhH5/qSnv/gi68XLRlq1PaT1p8eIaZMzUHJUsBWWM4F07X34zvc2C0+xYUi0JNAAMLup2JvUp7I0lN+KOEZRGGLxXpxoxcuoQLfHZlyiktA3GKjAjPrvmU8oTdaNkpopYdazZK4zbjhVhNovqS0VtNA7YS26yJyVOvV+CuUBQPezOh38nmQ/49Bp3wxnXH+7teNRt2ZqKwEmbBeA2Qlo3wU8AceaEd6kCmrI50Enk8fYwkJErA2Y4pGqWOOcOkd3iXClO+XJCG4B+uBCprlU/nFPzCexr4f9371CS+r0RhXvg47NpEfo029t8ejZZxXTKFmo75gVlhfrfo04ree4zx6ezia/2Yaaa0ZpCA6QbKy4RDMelWIhFkFnQ9MKpGoNMQB7Lmaa10qWUTt6JoaXGevqiErFFJaOJ4i4+1nUIx1qzM18kRgApOE5BoaobevCgHhWkGbb7wd3jky9Ne6db2KDma9qbV6Z4AqItGlIy+jYoQ73DafJJU+6p+yAYdrmtJc/w3KoS91KWHrTxFmeUnYUyzpsKCL866IfSp3G9mjnDQFFE1TPfrJeMh3A6sJ/vcRj6D7hMwVVxjk3Ttl/bGVNtJZqlZ5E87hmIlAqIFLIAhKLE3lwu+g2e0p3OnzCh4KERvRdZ0wVl2MJN9KxC8rYYQA/ZcsuHAZKWa71SQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 519a2014-2da6-4dd8-c430-08db842cf541
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2023 05:41:23.0914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wu2OfeRr8cWVG3ArkY1ysaDgzTxJE4MfzbPpYNyVH3Xe+U5su0ZH0P0KmxhavuRnojdzOU9v4vFiMMb6PY/VkW7S11Y0jRAT6ydGagKXIhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6379
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I ran the latest blktests (git hash: acc408477e85) with v6.5-rc1 kernel and
observed new failures those were not observed with v6.4. FYI, here I list t=
he
new failures. As for the failures observed with v6.4, please refer [1].

[1] https://lore.kernel.org/linux-block/lkmloyrqpebispffur5udxdiubmevvodtsv=
nap3jz7tv5ihstr@jg7ejye3bein/

List of new failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/004, block/005, zbd/005, zbd/006
#2: scsi/002
#3: zbd/010

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: block/004, block/005, zbd/005, zbd/006

The test cases fail when TEST_DEV is device-mapper, such as dm-linear.
They fail because the test cases set /sys/block/*/queue/scheduler, which
is no longer available for device-mapper from v6.5-rc1. Blktests fix will
be required. I will work on the fix.

#2: scsi/002

With kernel v6.5-rc1, /dev/sg* files are not created for SCSI devices. It m=
akes
scsi/002 fail. A kernel fix is posted [2].

[2] https://lore.kernel.org/linux-scsi/20230705024001.177585-1-yukuai1@huaw=
eicloud.com/

#3: zbd/010

With kernel v6.5-rc1, f2fs mount fails on zoned block devices. It makes zbd=
/010
fail. A kernel fix candidate is posted [3].

[3] https://lkml.kernel.org/linux-f2fs-devel/20230711050101.GA19128@lst.de/
