Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA666CA0FFB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 18:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240616AbjIES2W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 14:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbjIES2V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 14:28:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D46E41;
        Tue,  5 Sep 2023 11:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693938467; x=1725474467;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=CA47Hagpsq6xrlWnHNnK/rL9D0GIqPltg1bO/Uubtsk=;
  b=XGo7RxgkezKL6b+nwISj4KP2jvaKH0dvOiNz9jezpgxyo9MqtryB/r+2
   J7qbAhoQlQ5jfEBFE+un4JGbgUzc0nU6ZeMoxbg3R7C5ON3jtvXPHgddv
   DKpZPJO/8f5DYjCe9KP4pSXx444HDEUFAIJwD0tqLWG0ADGpMLjKERqs+
   IrFu7WcEBPpX9j3zJti4TPZJCibejxDvNoWEfbVlGYfJYqVqUjlfT3O93
   cubUAsXD03q+sw1jBf7WG9hrpKG4bOuwXspKTrKFj5wQsdJ1C0LxdCz71
   l1zTVVS5IUlUlv1z6Z7Vt0AZq43p7rjUXLNt7RXwMhHWwZz8xk+4YkTXC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="443245771"
X-IronPort-AV: E=Sophos;i="6.02,229,1688454000"; 
   d="scan'208";a="443245771"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 10:17:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="690998084"
X-IronPort-AV: E=Sophos;i="6.02,229,1688454000"; 
   d="scan'208";a="690998084"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2023 10:17:50 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 10:17:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 10:17:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 5 Sep 2023 10:17:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 5 Sep 2023 10:17:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DANI9zXjZ4IOPU6ETxf52+uqc4iBSmrN8Y7sT0I4vtotbF/1dzI4YOcW8CszA1y5eZFzZVraaTexb23sLmmQKD4Fe+nr0f+jpKF0UsasKpeat9KCyYO/+QbgblJNKfQmpTLSVVXDcUkTM4pmW9gs7vX45iV8vxDPU7ghahRHbILGN+EZ/fxMRkif5OjGIIxA9gHKl9+pNx8grnWCY0wW7Rmxr56RRF72xUdLCcbcNzW2nzegtEWUPDpbfW/5WU/hRXEHE8Qiz+a4qFVIpB/YpLMGEK7VCfwR7HdXXRTvJC3I1zYs2DpUrcZW3U7mqfquhpAyiUeTjQ11a4+wMxqWqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMfkRoKFQpgZZ1DeZweN23rGcCQ/969BoFDmLKH3IR4=;
 b=bdQXdviS85+E1YDM58y9G79Q/yMFs+w9eXwNdD8SOY5w7rX1K0xaWZMnLuovt7PZ5LoKatmbnaOWbdFNTscg/fiVM83xVNJL0wJx/JN5xQGyCMwZ2JWLifR82cX4fV96CLTB7g1iWamN81roVRALy0yj4ubS4IB3FU5mmBwH8+bLO9WvE2DP1CTAbnrHkhQaNjNcyJjzcvULMU755csr2w9IgFAO3jsf8PnZGsGupRJi3wH4K/Dv13XnoBBwkPayfH7DXdwuHAGkp+JRqEYtbuDO+e6xwdgVS4nMKCfXJDMB3qWE3k4W8kfzq72ooQ5TzGnllCt30rAwI8ilP/DIgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by DS0PR11MB6470.namprd11.prod.outlook.com (2603:10b6:8:c2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.18; Tue, 5 Sep 2023 17:17:45 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7f94:b6c4:1ce2:294]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7f94:b6c4:1ce2:294%5]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 17:17:45 +0000
Date:   Tue, 5 Sep 2023 13:17:40 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "regressions@leemhuis.info" <regressions@leemhuis.info>,
        "dalzot@gmail.com" <dalzot@gmail.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "paula@soe.ucsc.edu" <paula@soe.ucsc.edu>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Message-ID: <ZPditFZNQWQw5yp3@intel.com>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ZOehTysWO+U3mVvK@rdvivi-mobl4>
 <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
 <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
 <ccf3d87c-6517-6f01-a32a-4c98b841c7d4@kernel.org>
 <ZO+/Rz4Q5+qvj5Bs@intel.com>
 <289a94c6-a437-626f-c7c4-f0d3aa8c2b79@kernel.org>
 <9e09411348ae7469b4a9a7d076a8c42f84d12823.camel@intel.com>
 <83ebb54c-a114-7cd9-4eb4-b9860f1afd26@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83ebb54c-a114-7cd9-4eb4-b9860f1afd26@kernel.org>
X-ClientProxiedBy: BYAPR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:a03:54::22) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|DS0PR11MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: a96ee71e-ce0d-4db1-9206-08dbae3404f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jLTSeN+ROc/oS2dowSRrd59ST6pBfLWSPAAFFBOlMDcTrWv/Y5k6X1LxaPDkddyJlfNpTv3bYebvtjSQ1+gAr+WtzcXpzDtO+5GxsF5xU8/1izfYeO/ySaWHqWQb8bqjZ+QOcnHCBIJVnYb25PsYYG13dm0KQhhPZxMG8Fe/nUmtlyEBOKglOaw7z9VjAdx4ojd36IgB0vnm7rMP8kUypWXdwOT76Q5icQScfb2Ct5+7+pF2rDGCC1bOVbYRjfYf5AI8lCDDkoWjHtZmYpEN1VerKZqhte1R46I0ZFT0i2H+Gb5t6MnPKIPlNfUnhBcYClCcgLDUrFu14znmDmQVqwydXsR9itAZ0WpBTUfW3sM/ku/13i7chByEVsmRwSAnOweGfyuH4zQ+i+pr92+kZd9oXFiGtyql3Cn5//hRp5z7ZOjIc7g6ZkJS0XByV9nEMAMpVtX8BrQ5dkLnNCXU82xEikJ8OCFEvOQIGcX/dfs7oOTeW1wzs2GMEOlQc8jtGKyy5NUAytE1SzbI01LEYHQmUXljS3zZY1mhnrTLhsGJtvrDVqrV/b4j+YWHhe+M5JDYf3qp3zyzfwWuTihscg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199024)(186009)(1800799009)(30864003)(66946007)(2906002)(66899024)(86362001)(66476007)(8936002)(5660300002)(54906003)(6916009)(44832011)(316002)(4326008)(41300700001)(8676002)(66556008)(36756003)(6506007)(6486002)(966005)(38100700002)(82960400001)(6512007)(53546011)(2616005)(26005)(478600001)(6666004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWFEdXlHM0JkS2U0L0JBR1V1VXJBNVpINHkydEcrT3ZCeXl4Wm9GQmxWdURY?=
 =?utf-8?B?TWpRVldPeGNSZk9XOXF5VWlhUytLWUlkQUFNVFJBT0MrckxjT2pQL29yeERt?=
 =?utf-8?B?UDhHdDBEYnVuQ2haVkdPUGtYb3l2UVFjc25lRXpLR0RkbVBMSTIrNzg5aXdS?=
 =?utf-8?B?MTlBL0k0WTUyRjNZbW9GY0UxUkVFeVJvZExIQTVEeVJmY3NncFg5UGZlRkY3?=
 =?utf-8?B?dnBjTFk5dDY0QzlvRDJObHh6QU9wTGlLWFNOdHgwbnZFOXkrRHZETXJnREN2?=
 =?utf-8?B?bVFTV3Y0TGpZS3V5T0FFTkFjdk13bktBZzFVTENzVld0bHlGVmpRRXF5L09O?=
 =?utf-8?B?TDg2WXRKOWxyb25uUzgrRndEVCtrY2Q3NFlsbUMzeTNGRm9BeHBNZUdmOWpa?=
 =?utf-8?B?aFZjYzhYNTFtY1IySWorQmsvUm1mdDVTY0xIMXIyZ3hSNEtEdmhZSmRmZk9P?=
 =?utf-8?B?ZjhSZkMreXM5YVlGZGFXQ3EvdEVnRktQMWpKUnFqUldQKzhNeHUycHRIbnl2?=
 =?utf-8?B?d0p1R1d6L09OVnN5S2NIWUo5WWtKUjNDS2REdC9PTXBpbXcvZVN5NVhlem1n?=
 =?utf-8?B?ZVI1M2YwTmQ5TjJJZFZMOEZZNWhUMUJqdUVaN204OGtuSHMydk1wL2lYU1Jp?=
 =?utf-8?B?MGNORzBGSWM4Wk9jQlVlbkJXTHBDT2N1TWhXNk5PT0xJSVBSUEtwTEtmZUxi?=
 =?utf-8?B?MHJSaW85akcyZDRSanJseG15a1NTa2lrQnpjbHNNTHVQd2ZWOVBCTGlNOWhw?=
 =?utf-8?B?dkNnK3ZCVFVsK3UxQ0QzSVJldjM5WDRlSjVtaklWcHNob2lnVzlMWjloMFlZ?=
 =?utf-8?B?RGhLREdGRFFVcW53QU1ZYjM3Sm11TmYxa251SDRRbitqNEh4K2N3UkFWRlV0?=
 =?utf-8?B?M0l0Vms2YnlGL1dObmpQNjRTejFnNTVPeEdTeE5XakxmZWNLN1o5cjhkb0VR?=
 =?utf-8?B?Tk5LREhSbWhpNWRUamkwTFlIUEYybmNkUFJEUWV2TDk1VzhiQ0hpZkpldXZy?=
 =?utf-8?B?bEl1OElVY0JhZE1RUitBc0tIV3RINDQ1N3JFZnI3U0J2d2FvVzBqdzNDbjkv?=
 =?utf-8?B?MFFvWkVYeC9iRHM0QU1URzRkbEFpd1d3dUttWnBIVGFjbk1Jd2dkbTFoZDJy?=
 =?utf-8?B?eWFHUmRrUlZwNDdscGNyN2lKeHJvYlFjcENKRG84amxuY1dnby9iUGVwTk5l?=
 =?utf-8?B?QzhXU3FrZU1RbGl4Yk04Q204MEZwWGwwVjVTamhuaHppRmoyNHoyUU5lYnRm?=
 =?utf-8?B?Y05SV20zVTdNakxIN1duOGNscG9pQ2xFbVFHMWE0cDlFQWxlZklWUFdTYUMy?=
 =?utf-8?B?blVFMjdkc2ZLaVJKa3lUYXdHakZDcjhaOVBtMUdqZnpxVnpZcHRWVWhLTDZ4?=
 =?utf-8?B?RTJMczQwNVZYMS9mVUk0VC9ORmhiNHAxMnVWSDVUZFFzdnZPQVdDeEVPV29N?=
 =?utf-8?B?dWVNMTZBSm0yeWpBd0tmU0lxYURRWEdjR3BFT3JUSFh0M29xR1JZalFUTmk1?=
 =?utf-8?B?ZmhNRS9CUk95bnM5M3ViekxGOWVPZjV6cVRHVmR2ZXB5Y1NiYUJGaE9xRWsv?=
 =?utf-8?B?S2hiK1VXVVpKUkJEc3RnSXBLYzdhN1pPRzlVbTVXMjhsUkRMVjI2alBCTkpp?=
 =?utf-8?B?QU9hcHllWXBGUyt6RTBvWkREeTAwWmVpZnpwN3V2NkpKTlVzcDIxMWFyejZn?=
 =?utf-8?B?MCsya1p2a2NGV1BOWGtLOTlpRi9aQ2FHbmMwV2tqSnJnSlYwc0o0VktwYS9P?=
 =?utf-8?B?WXR1VzE2MXQwVHFKdmNyNER2NmRGaTNmRXRubHVjWFVEdkpMNzBqbXhkdVdn?=
 =?utf-8?B?U211NlVYeGw0R241SUZ4NVVlbnhlWGxuTnltY1Y0N1Jva2VEZ1U0YVlCVkZk?=
 =?utf-8?B?dUd0cTFTWDI0L3dXWkpuUGZGdmF6bGVUajFNRnNjR2YwTGp2bU4ycENFMWkr?=
 =?utf-8?B?MlNTcVA2RUozVmhYbDZJMkZieTNIZXRvU3JnRnpSOWZ5ZENqbFQ0U3lQUVM2?=
 =?utf-8?B?ZUJyc2hiUzgydXdBc0NpNTJweFhWaUQrZ0lLZURhMERncEVSRVdlSXYrcDBT?=
 =?utf-8?B?b1hCSWxpS1dscGhKNE9uU1NmS3UwVER2MWNtaldYRmpkZWdwdjZMbmxXb1U0?=
 =?utf-8?Q?VaGPrJl0oyEgNEt6wCeKn5F80?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a96ee71e-ce0d-4db1-9206-08dbae3404f5
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 17:17:45.0941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boWP2+mhTQeU449frlXe0V1+nZ/cuyzx6BdTqNXGikBTIsUVM1tD7O/22a+Rzp7NThwYG17EG7NHJeH8CVFbTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6470
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 05, 2023 at 02:20:23PM +0900, Damien Le Moal wrote:
> On 8/31/23 10:48, Vivi, Rodrigo wrote:
> > On Thu, 2023-08-31 at 09:32 +0900, Damien Le Moal wrote:
> >> On 8/31/23 07:14, Rodrigo Vivi wrote:
> >>> On Tue, Aug 29, 2023 at 03:17:38PM +0900, Damien Le Moal wrote:
> >>>> On 8/26/23 02:09, Rodrigo Vivi wrote:
> >>>>>>> So, maybe we have some kind of disks/configuration out
> >>>>>>> there where this
> >>>>>>> start upon resume is needed? Maybe it is just a matter of
> >>>>>>> timming to
> >>>>>>> ensure some firmware underneath is up and back to life?
> >>>>>>
> >>>>>> I do not think so. Suspend will issue a start stop unit
> >>>>>> command to put the drive
> >>>>>> to sleep and resume will reset the port (which should wake up
> >>>>>> the drive) and
> >>>>>> then issue an IDENTIFY command (which will also wake up the
> >>>>>> drive) and other
> >>>>>> read logs etc to rescan the drive.
> >>>>>> In both cases, if the commands do not complete, we would see
> >>>>>> errors/timeout and
> >>>>>> likely port reset/drive gone events. So I think this is
> >>>>>> likely another subtle
> >>>>>> race between scsi suspend and ata suspend that is causing a
> >>>>>> deadlock.
> >>>>>>
> >>>>>> The main issue I think is that there is no direct ancestry
> >>>>>> between the ata port
> >>>>>> (device) and scsi device, so the change to scsi async pm ops
> >>>>>> made a mess of the
> >>>>>> suspend/resume operations ordering. For suspend, scsi device
> >>>>>> (child of ata port)
> >>>>>> should be first, then ata port device (parent). For resume,
> >>>>>> the reverse order is
> >>>>>> needed. PM normally ensures that parent/child ordering, but
> >>>>>> we lack that
> >>>>>> parent/child relationship. I am working on fixing that but it
> >>>>>> is very slow
> >>>>>> progress because I have been so far enable to recreate any of
> >>>>>> the issues that
> >>>>>> have been reported. I am patching "blind"...
> >>>>>
> >>>>> I believe your suspicious makes sense. And on these lines, that
> >>>>> patch you
> >>>>> attached earlier would fix that. However my initial tries of
> >>>>> that didn't
> >>>>> help. I'm going to run more tests and get back to you.
> >>>>
> >>>> Rodrigo,
> >>>>
> >>>> I pushed the resume-v2 branch to libata tree:
> >>>>
> >>>> git@gitolite.kernel.org:pub/scm/linux/kernel/git/dlemoal/libata
> >>>> (or
> >>>> https://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata.gi
> >>>> t)
> >>>>
> >>>> This branch adds 13 patches on top of 6.5.0 to cleanup libata
> >>>> suspend/resume and
> >>>> other device shutdown issues. The first 4 patches are the main
> >>>> ones to fix
> >>>> suspend resume. I tested that on 2 different machines with
> >>>> different drives and
> >>>> with qemu. All seems fine.
> >>>>
> >>>> Could you try to run this through your CI ? I am very interested
> >>>> in seeing if it
> >>>> survives your suspend/resume tests.
> >>>
> >>> well, in the end this didn't affect the CI machinery as I was
> >>> afraid.
> >>> it is only in my local DG2.
> >>>
> >>> https://intel-gfx-ci.01.org/tree/intel-xe/bat-
> >>> all.html?testfilter=suspend
> >>> (bat-dg2-oem2 one)
> >>>
> >>> I just got these 13 patches and applied to my branch and tested it
> >>> again
> >>> and it still *fails* for me.
> >>
> >> That is annoying... But I think the messages give us a hint as to
> >> what is going
> >> on. See below.
> >>
> >>>
> >>> [   79.648328] [IGT] kms_pipe_crc_basic: finished subtest pipe-A-
> >>> DP-2, SUCCESS
> >>> [   79.657353] [IGT] kms_pipe_crc_basic: starting dynamic subtest
> >>> pipe-B-DP-2
> >>> [   80.375042] PM: suspend entry (deep)
> >>> [   80.380799] Filesystems sync: 0.002 seconds
> >>> [   80.386476] Freezing user space processes
> >>> [   80.392286] Freezing user space processes completed (elapsed
> >>> 0.001 seconds)
> >>> [   80.399294] OOM killer disabled.
> >>> [   80.402536] Freezing remaining freezable tasks
> >>> [   80.408335] Freezing remaining freezable tasks completed
> >>> (elapsed 0.001 seconds)
> >>> [   80.439372] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
> >>> [   80.439716] serial 00:01: disabled
> >>> [   80.448011] sd 4:0:0:0: [sda] Synchronizing SCSI cache
> >>> [   80.448014] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
> >>> [   80.453600] ata6.00: Entering standby power mode
> >>
> >> This is sd 5:0:0:0. All good, ordered properly with the
> >> "Synchronizing SCSI cache".
> >>
> >>> [   80.464217] ata5.00: Entering standby power mode
> >>
> >> Same here for sd 4:0:0:0.
> >>
> >>> [   80.812294] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl
> >>> 300)
> >>> [   80.818520] ata8.00: Entering active power mode
> >>> [   80.842989] ata8.00: configured for UDMA/133
> >>
> >> Arg ! sd 7:0:0:0 is resuming ! But the above "Synchronizing SCSI
> >> cache" tells
> >> us that it was suspending and libata EH did not yet put that drive to
> >> standby...
> >>
> >>> [   80.847660] ata8.00: Entering standby power mode
> >>
> >> ... which happens here. So it looks like libata EH had both the
> >> suspend and
> >> resume requests at the same time, which is totally weird.
> > 
> > although it looks weird, it totally matches the 'use case'.
> > I mean, if I suspend, resume, and wait a bit before suspend and resume
> > again, it will work 100% of the time.
> > The issue is really only when another suspend comes right after the
> > resume, in a loop without any wait.
> > 
> >>
> >>> [   81.119426] xe 0000:03:00.0: [drm] GT0: suspended
> >>> [   81.800508] PM: suspend of devices complete after 1367.829 msecs
> >>> [   81.806661] PM: start suspend of devices complete after 1390.859
> >>> msecs
> >>> [   81.813244] PM: suspend devices took 1.398 seconds
> >>> [   81.820101] PM: late suspend of devices complete after 2.036
> >>> msecs
> >>
> >> ...and PM suspend completes here. Resume "starts" now (but clearly it
> >> started
> >> earlier already given that sd 7:0:0:0 was reactivated.
> > 
> > that is weird.
> > 
> >>
> >>> �[   82.403857] serial 00:01: activated
> >>> [   82.489612] nvme nvme0: 16/0/0 default/read/poll queues
> >>> [   82.563318] r8169 0000:07:00.0 enp7s0: Link is Down
> >>> [   82.581444] xe REG[0x223a8-0x223af]: allow read access
> >>> [   82.586704] xe REG[0x1c03a8-0x1c03af]: allow read access
> >>> [   82.592071] xe REG[0x1d03a8-0x1d03af]: allow read access
> >>> [   82.597423] xe REG[0x1c83a8-0x1c83af]: allow read access
> >>> [   82.602765] xe REG[0x1d83a8-0x1d83af]: allow read access
> >>> [   82.608113] xe REG[0x1a3a8-0x1a3af]: allow read access
> >>> [   82.613281] xe REG[0x1c3a8-0x1c3af]: allow read access
> >>> [   82.618454] xe REG[0x1e3a8-0x1e3af]: allow read access
> >>> [   82.623634] xe REG[0x263a8-0x263af]: allow read access
> >>> [   82.628816] xe 0000:03:00.0: [drm] GT0: resumed
> >>> [   82.728005] ata7: SATA link down (SStatus 4 SControl 300)
> >>> [   82.733531] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl
> >>> 300)
> >>> [   82.739773] ata5.00: Entering active power mode
> >>> [   82.744398] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl
> >>> 300)
> >>> [   82.750618] ata6.00: Entering active power mode
> >>> [   82.755961] ata5.00: configured for UDMA/133
> >>> [   82.760479] ata5.00: Enabling discard_zeroes_data
> >>> [   82.836266] ata6.00: configured for UDMA/133
> >>> [   84.460081] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl
> >>> 300)
> >>> [   84.466354] ata8.00: Entering active power mode
> >>> [   84.497256] ata8.00: configured for UDMA/133
> >>> ...
> >>
> >> And this looks all normal, the drives have all been transitioned to
> >> active
> >> power mode as expected. And yet, your system is stuck after this,
> >> right ?
> > 
> > yes
> 
> I think I have now figured it out, and fixed. I could reliably recreate the same
> hang both with qemu using a failed suspend (using a device not supporting
> suspend) and real hardware with a short rtc wake.
> 
> It turns out that the root cause of the hang is ata_scsi_dev_rescan(), which is
> scheduled asynchronously from PM context on resume. With quick suspend after a
> resume, suspend may win the race against that ata_scsi_dev_rescan() task
> execution and we endup calling scsi_rescan_device() on a suspended device,
> causing that function to wait with the device_lock() held, which causes PM to
> deadlock when it needs to resume the scsi device. The recent commit 6aa0365a3c85
> ("ata: libata-scsi: Avoid deadlock on rescan after device resume") was intended
> to fix that, but it did so less than ideally and the fix has a race on the scsi
> power state check, thus not always preventing the resume hang.
> 
> I pushed a new patch series that goes on top of 6.5.0: resume-v3 branch in the
> libata tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata.git
> 
> This works very well for me. Using this script on real hardware:
> 
> for (( i=0; i<20; i++ )); do
> 	echo "+2" > /sys/class/rtc/rtc0/wakealarm
> 	echo mem > /sys/power/state
> done
> 
> The system repeatedly suspends and resumes and comes back OK. Of note is that if
> I set the delay to +1 second, then I sometime do not see the system resume and
> the script stops. But using wakeup-on-lan (wol command) from another machine to
> wake it up, the machine resumes normally and continues executing the script. So
> it seems that setting the rtc alarm unreasonably early result in it being lost
> and the system suspending wating to be woken up.
> 
> I also tested this in qemu. As mentioned before, I cannot get rtc alarm to wake
> up the VM guest though. However, using a virtio device that does not support
> suspend, resume strats in the middle of the suspend operation due to the suspend
> error reported by that device. And it turns out that systemd really insists on
> suspending the system despite the error, so when running "systemctl suspend" I
> see a retry for suspend right after the first failed one. That is enough to
> trigger the issue without the patches.
> 
> Please test !

\o/ works for me!

Feel free to use:
Tested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

Thank you so much,
Rodrigo.

> 
> Thanks.
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
