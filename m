Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D04C83F01
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 22:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245676AbjH3WRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 18:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245639AbjH3WQ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 18:16:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ECD9C;
        Wed, 30 Aug 2023 15:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693433787; x=1724969787;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=v3g9qhONoTKoZSp1ertkw87dTHHwNx7pgjB4sI1RvTM=;
  b=f/QqqwxHmxSxwCFadoF1ZKL1sXcalSvqFUrhFR8SCRkDIX/P7zwxquhV
   9Zr1KGkqR4Lb57haZFbb/UiOCTtddhRH1OST8ExUg82AiiAZqBx/nw366
   x4c85Rh29J2VNjENrYJP76+vUwHNpAlF4HDeQ8uozweKzDpOTcLPIzQlT
   pX768J/2Dlz6nHWCIgIG4OKQU54ao0yXWN34sYVLoQO9l8dcTJCA9seg2
   xogiwlXaQegfEAtLSgfYbzWErYLl32Q+gvuWPx8eoPLdNfgENXKq19S1j
   OhtmPEtFCVlqzhIox6qMPIn+IyL79M9eMAuyDfJiOpvKTrbFYWD/EIQmS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="360749393"
X-IronPort-AV: E=Sophos;i="6.02,214,1688454000"; 
   d="scan'208";a="360749393"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 15:14:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="912984657"
X-IronPort-AV: E=Sophos;i="6.02,214,1688454000"; 
   d="scan'208";a="912984657"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 30 Aug 2023 15:14:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 15:14:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 30 Aug 2023 15:14:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 30 Aug 2023 15:14:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYSzggp440KXWauDxBwuBgASIJ4iBfvPTqWNpjC/bW6do0hbgksTp9LSy5C2nxbncE8VF7xqzfPkyVb84UXZa9IysFP6Bb+MjVQ/Wms7ta3hbwvQuXLy9B7IaSfH9Ac33gr5b7W51wOdTzL506j06SLgfYPswzR4wKmboJ4YrmYg2ySwDzzruzEcHQ/+VkO2DgE8SoB2wXOi1nFVlWhRFK3U5+uy0wr3WBfvNi2Zy8f1uOA85XS6I0DepRlKqD6d3+oXtlkWnNc73XbpyhyOPlOc+k0olhFDXTMH6XKoZVrAoe4abcfIvtiUM4NMK8XrgC6XgxWUFI0Rt6Jlppq4LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tupvZPOsvrFksxLLcDYN76lz481GRuNv5b38GfofsZc=;
 b=G8/frJ3dnZSmJLaNsxEkHlIvAel8qyAaTxJiZuF2Yd+dTeYelUC4AhXkwSSeW0zDxXowBcinsQcVKHsf2KItlBjXG8lb5QwMd5ujdosJ0f9sieLkBhc1ErX1eoqjQQeUyelPhYAOTXdeVgnbalpwkiWJ3wRCWSjsFxg8my9YoFYSbpJwoTxKG2UVPB1giLgMuGVOk64IK/IFzIhq/mA6+6APwqH+0w+Ek/S0RzAwbcxfS18mUcZ4/90RuGtJCSnK3Y+GoQS3xzKrU/jv5ZooHlw5ciqasmEzMWc5jDLAJW9Ztviu/A0RDGLeC0qNN07scjuzkYBCwqclXmMCq8YwXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by DM4PR11MB6214.namprd11.prod.outlook.com (2603:10b6:8:ac::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.34; Wed, 30 Aug 2023 22:14:38 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7f94:b6c4:1ce2:294]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7f94:b6c4:1ce2:294%5]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 22:14:38 +0000
Date:   Wed, 30 Aug 2023 18:14:31 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     Rodrigo Vivi <rodrigo.vivi@kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        "Thorsten Leemhuis" <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, <regressions@lists.linux.dev>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Message-ID: <ZO+/Rz4Q5+qvj5Bs@intel.com>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ZOehTysWO+U3mVvK@rdvivi-mobl4>
 <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
 <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
 <ccf3d87c-6517-6f01-a32a-4c98b841c7d4@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccf3d87c-6517-6f01-a32a-4c98b841c7d4@kernel.org>
X-ClientProxiedBy: BYAPR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::27) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|DM4PR11MB6214:EE_
X-MS-Office365-Filtering-Correlation-Id: 2276bf44-cb4c-4e07-e2ac-08dba9a67fb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2wp356Oa8bJKWU3GgF0pEHzbz5WbgwNnC9nVVaH57S0dasLzSsBv4MxesV+WlNMHKfzVisQVBfR7orphC1ckJroSUVGuKHxNlHBnG6RUkHuInhFBcbPeBBOfTSXiJu8YiR2CyVgrtz3xQaFt4zuPLuB2dwz7NQ5KNE9YO02atlH6Tuj4FvBAfY9yV1ugDjnZPCgSh15LkMNkviQ/ZjkWzLMtPFD1YWPJsKOVJZBxdz5EH6p1fI0VgvlgS50/YhAauh5SXqfu7rQaLPY/Z65ZdDLhXCu+qIIPYA2EjaIG7UWRmJ3+tdEyMDx0KWgV4UqXiROFjCCVnKnx6Qr/z6e/9/eAUKDR0M17uhYxbOrACnJTnN99WG2Rf7z4ccSZk8tw5gRLaJ26gZ7CtgQZWzJFo/svxACf/TzLq/5Y4pCzTTeNzvFszXr4DjGHbow4+pnPQ9t7qHydQdID5xjuPfolClJ+9CLRXm+tFRoIu2E5QG43q0CqZdQpEnnthexqKBzBJOlTK4xolcvv3+adJPLhj69Rkci33niqMgcXGrJshBT1w6g6lqTdWy8DUGhWnhPZsbUK2HayWH0YQBm+IKGWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(366004)(346002)(136003)(1800799009)(451199024)(186009)(8936002)(4326008)(8676002)(6916009)(2906002)(66556008)(54906003)(66946007)(36756003)(66476007)(316002)(5660300002)(44832011)(7416002)(41300700001)(6666004)(6512007)(26005)(53546011)(6506007)(82960400001)(478600001)(966005)(6486002)(83380400001)(38100700002)(2616005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWVURmV0QTVOT0l1MDlBTmgwZXc3QnFTOXpnblBaZXJVbmdWMWFIK3hJL0xR?=
 =?utf-8?B?YnIyc3k1amp2NkRNOUdZVmtZcnVweXhGT1ZXS2E2UGtFaC9UTzJaUXM0UEdj?=
 =?utf-8?B?czJxQklmOFVuS3I1YU1XdnhVRWxaemFTdzJsWVJIK044RHEyWVlEQko2WEFx?=
 =?utf-8?B?anlQclFOUGNZSXNKb3p2RHVPQjRGQ2Z4QndscGpBcThFYjZsbm1hTnR2SjBD?=
 =?utf-8?B?YmxrWXBoeDZBYjkrYnpOSzZsZnljUzBWNE1HdWtEUVpIVU1VYmhNdHZOTUhP?=
 =?utf-8?B?UXVydzBEOW9pakIvZGFkTFdNdXJwVkZaZERYUms2QzhTcm0xSTNKcm94ZjJU?=
 =?utf-8?B?Qks5MVdmbFI5alFoS3RjcklBZGVSNUkwSmlXdkxCZGVYbWdzLzZ6UUtCQWpH?=
 =?utf-8?B?Vjh1YmZnR1JLM3doaS9mTm8vZ0J6Ukc1eWhyaTdBYjVJS1hyUi9lZWJQSFlE?=
 =?utf-8?B?bnhNN0hiekN2bWR0d0RXeFVzRmhqYzNib2Zra2xNWnQ0Q20vNFhZU1JhUCtP?=
 =?utf-8?B?YTM4ZXVpdVpnVFZVMlNON3RMK1ZCdDlqQmFTamd4MXN5MGNNR0RYSWg2Ukpo?=
 =?utf-8?B?cEZaVHE0NExBa1RLSU03WkFHMEhsVy82YnpaS2JKSVY5aWVSTjdQQW40aE0v?=
 =?utf-8?B?YzkrSFdNdm9HSDByalZkdWxvYUVWTU5YYmhRYVFhZ1BMRHBpMzhJYXFxU1hK?=
 =?utf-8?B?M1ZadSs2RG5NTVRFUmhybGxSdy9MZjRqZzcrSU1RbUFBTm9pTk1ja2haNHNk?=
 =?utf-8?B?SVVYYmxzSW1YUGUvcmhZd3dXaHBPdmZ3RHFoNEJYN01pVEJOVmtFT0ovYWhX?=
 =?utf-8?B?ekFwZjdMUElrZWxZLzMyUlIzbkQxd1lBMWcwZmgrdmJSTGdDZ2FLb2kxK1Rq?=
 =?utf-8?B?ZlVwV2RXeFVyL3o4SWJlSkZxQ3JVR05ORlIzaHptREVNUDNmZ3QyQzhGbzFE?=
 =?utf-8?B?T0MrTUxPVXFBNmUwTUVmSHN2QytabDFVWXk0ZXZqeFNTWkx3c2VmSW9Wem43?=
 =?utf-8?B?bXFBZEl1NVprejBYejl3dnJ1WUFiLzdWNTJ0VW5iQWdER2lNb2ZsSHovR2VO?=
 =?utf-8?B?Rno3OHRPTWhEUzBJVnVzZk1HRnVZVm9KclFmUGhLSk9uak8rKzNMSW9Nb1RR?=
 =?utf-8?B?WDErMWhqM1FVcUNPdWczTDY5SXE2T2pTYm1GMEl0c1FCRXdMazdxSCtFQnlH?=
 =?utf-8?B?ZmdwYkh4eTI2U05XTC8rVGtvcFBZM2ZpN2tkM21qNDdITkoza3ViSWswTFNB?=
 =?utf-8?B?enErOWNPdlNXNTlpZHZmYWlFTXlxMjdqVlg0RG5RRW9YQmlESFpHd0h2YUlJ?=
 =?utf-8?B?NUdtSVhyVmhwNlVrTjcveXFVaUV1UXZCTUEvYkZZK1ZkeEdYNXZWczdORSs2?=
 =?utf-8?B?SkVLZkxVRGxpZ3dXWjcrREFzMmoxSG5YSkdJS3RxQ1lKTENqcmVTMTdEVGpN?=
 =?utf-8?B?enEySThUUzBaUEx4dWdzWElKQkhaRUJUMFlNVEpXMkluSFE4L3dhUjNlbmI2?=
 =?utf-8?B?Q0JrcTAvbXdicEpmMjh4YTcwTkNYcFlZODhCd0FqTUIwdnQyY1cveXNjZHdh?=
 =?utf-8?B?M1FZR25OQ3dWblc1cW9UL0w1RFF4Q0xJbUMwQWRGLzFyVDVDc2lVRm1XZ0c1?=
 =?utf-8?B?YmQ1S3pGeFAzWkJ0NVVGUUQ3bEJsa2tOYTRDVjk4QlpVRmc2SklRTXY3OWFa?=
 =?utf-8?B?R3hTb1d6QTZYWHo3a1MzTmg3ZVlvRmxlL0FRK3pKM0FISlpXbGRyTmV4ZXBC?=
 =?utf-8?B?ZS9zY1lTRnc5Y3BPT2VaM24rd2dON1ZyNEg4c0JiUzdock9xdmthZEVWMnV3?=
 =?utf-8?B?bFBnMUFqZ2lqQjZta3g4bjRITXJPN0ZTcDFqcFJmRit0M21pd210aFdvK2pz?=
 =?utf-8?B?R08xRTNQWlpSTFhqb013VUlpN1FEalJRNHowTHFqRGQ0aEZDMjAzc0twalk5?=
 =?utf-8?B?Y2prQTBUVjlCUlZBU3RiUjRzYWNlb0F3ZzZtcXpGQkpvRFlPWVFmaWcyNFlR?=
 =?utf-8?B?TWJqOC9YenhPQnByUVhpSzJ6QTAyb2Y1bGZJZ1djY1h1bEZ0TmM0NHFUa2c0?=
 =?utf-8?B?ang5S3k5R3pCRkhBdXFCYXY4U3ZLbGpOZlNXYm9yUWt0c1AwWEY0V2prbHNO?=
 =?utf-8?B?M1hjc0E3UVMwc0tlRlRCUVF1UFFwL0habnFDZFNnUXdFckZXS2NodjZLS1hI?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2276bf44-cb4c-4e07-e2ac-08dba9a67fb4
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2023 22:14:37.9284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WZy0/XD9KejFj60boDhKE9rzacJtJDICR6bGIgHMYqsT38stGkQcCZu5XQM98Vu7QodnDsdTLo8AsKGdGdDaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6214
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 29, 2023 at 03:17:38PM +0900, Damien Le Moal wrote:
> On 8/26/23 02:09, Rodrigo Vivi wrote:
> >>> So, maybe we have some kind of disks/configuration out there where this
> >>> start upon resume is needed? Maybe it is just a matter of timming to
> >>> ensure some firmware underneath is up and back to life?
> >>
> >> I do not think so. Suspend will issue a start stop unit command to put the drive
> >> to sleep and resume will reset the port (which should wake up the drive) and
> >> then issue an IDENTIFY command (which will also wake up the drive) and other
> >> read logs etc to rescan the drive.
> >> In both cases, if the commands do not complete, we would see errors/timeout and
> >> likely port reset/drive gone events. So I think this is likely another subtle
> >> race between scsi suspend and ata suspend that is causing a deadlock.
> >>
> >> The main issue I think is that there is no direct ancestry between the ata port
> >> (device) and scsi device, so the change to scsi async pm ops made a mess of the
> >> suspend/resume operations ordering. For suspend, scsi device (child of ata port)
> >> should be first, then ata port device (parent). For resume, the reverse order is
> >> needed. PM normally ensures that parent/child ordering, but we lack that
> >> parent/child relationship. I am working on fixing that but it is very slow
> >> progress because I have been so far enable to recreate any of the issues that
> >> have been reported. I am patching "blind"...
> > 
> > I believe your suspicious makes sense. And on these lines, that patch you
> > attached earlier would fix that. However my initial tries of that didn't
> > help. I'm going to run more tests and get back to you.
> 
> Rodrigo,
> 
> I pushed the resume-v2 branch to libata tree:
> 
> git@gitolite.kernel.org:pub/scm/linux/kernel/git/dlemoal/libata
> (or https://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata.git)
> 
> This branch adds 13 patches on top of 6.5.0 to cleanup libata suspend/resume and
> other device shutdown issues. The first 4 patches are the main ones to fix
> suspend resume. I tested that on 2 different machines with different drives and
> with qemu. All seems fine.
> 
> Could you try to run this through your CI ? I am very interested in seeing if it
> survives your suspend/resume tests.

well, in the end this didn't affect the CI machinery as I was afraid.
it is only in my local DG2.

https://intel-gfx-ci.01.org/tree/intel-xe/bat-all.html?testfilter=suspend
(bat-dg2-oem2 one)

I just got these 13 patches and applied to my branch and tested it again
and it still *fails* for me.

[   79.648328] [IGT] kms_pipe_crc_basic: finished subtest pipe-A-DP-2, SUCCESS
[   79.657353] [IGT] kms_pipe_crc_basic: starting dynamic subtest pipe-B-DP-2
[   80.375042] PM: suspend entry (deep)
[   80.380799] Filesystems sync: 0.002 seconds
[   80.386476] Freezing user space processes
[   80.392286] Freezing user space processes completed (elapsed 0.001 seconds)
[   80.399294] OOM killer disabled.
[   80.402536] Freezing remaining freezable tasks
[   80.408335] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[   80.439372] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
[   80.439716] serial 00:01: disabled
[   80.448011] sd 4:0:0:0: [sda] Synchronizing SCSI cache
[   80.448014] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
[   80.453600] ata6.00: Entering standby power mode
[   80.464217] ata5.00: Entering standby power mode
[   80.812294] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   80.818520] ata8.00: Entering active power mode
[   80.842989] ata8.00: configured for UDMA/133
[   80.847660] ata8.00: Entering standby power mode
[   81.119426] xe 0000:03:00.0: [drm] GT0: suspended
[   81.800508] PM: suspend of devices complete after 1367.829 msecs
[   81.806661] PM: start suspend of devices complete after 1390.859 msecs
[   81.813244] PM: suspend devices took 1.398 seconds
[   81.820101] PM: late suspend of devices complete after 2.036 msecs
�[   82.403857] serial 00:01: activated
[   82.489612] nvme nvme0: 16/0/0 default/read/poll queues
[   82.563318] r8169 0000:07:00.0 enp7s0: Link is Down
[   82.581444] xe REG[0x223a8-0x223af]: allow read access
[   82.586704] xe REG[0x1c03a8-0x1c03af]: allow read access
[   82.592071] xe REG[0x1d03a8-0x1d03af]: allow read access
[   82.597423] xe REG[0x1c83a8-0x1c83af]: allow read access
[   82.602765] xe REG[0x1d83a8-0x1d83af]: allow read access
[   82.608113] xe REG[0x1a3a8-0x1a3af]: allow read access
[   82.613281] xe REG[0x1c3a8-0x1c3af]: allow read access
[   82.618454] xe REG[0x1e3a8-0x1e3af]: allow read access
[   82.623634] xe REG[0x263a8-0x263af]: allow read access
[   82.628816] xe 0000:03:00.0: [drm] GT0: resumed
[   82.728005] ata7: SATA link down (SStatus 4 SControl 300)
[   82.733531] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   82.739773] ata5.00: Entering active power mode
[   82.744398] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   82.750618] ata6.00: Entering active power mode
[   82.755961] ata5.00: configured for UDMA/133
[   82.760479] ata5.00: Enabling discard_zeroes_data
[   82.836266] ata6.00: configured for UDMA/133
[   84.460081] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   84.466354] ata8.00: Entering active power mode
[   84.497256] ata8.00: configured for UDMA/133
...

> 
> If you can confirm that all issues are fixed, I will rebase this on for-next and
> post.
> 
> Thanks !
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
