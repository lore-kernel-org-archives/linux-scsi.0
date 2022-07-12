Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E953BC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 02:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiGLCsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 22:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGLCsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 22:48:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAD113F52;
        Mon, 11 Jul 2022 19:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657594130; x=1689130130;
  h=message-id:date:subject:references:in-reply-to:to:cc:
   from:content-transfer-encoding:mime-version;
  bh=I5HX49jOETS0YSV9A9uTIxpUOvVKocYERWmWdylarvY=;
  b=NZPyqjMlNuPcoHgc3ChI2L35jVLJBOE6kYU0BW1pAA1MNbRQs3fL3wAr
   y5oTB3lKgsBLw6ApU2qw6T1DmHruqrudT4AJF4KJhdZvXXlgkg571dFoE
   9MDiirCGD+vUV+c/VhAbulGt5b/HlB+U+dbv9XeNxJzhkOQ8zPYAHqeQW
   33+FcKRHdi31SHSYareUNeGbn2qaIXmWHtEAs1drhGZmCnEWsRybmbPNb
   dJ7FUrdPi2ZCs2UnFiyePYqIA15boZ4r34zaQaAoefPSZnSGkKxiUfEnp
   pkdIckBso4hTUbUhfw17ePTJa4czTKzytCxvdbD2/9xZGOX/E2r5p2rFW
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="371130215"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="371130215"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 19:48:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="684608460"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jul 2022 19:48:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 19:48:49 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 19:48:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 11 Jul 2022 19:48:49 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 11 Jul 2022 19:48:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkdNn3zi7TrYp8/aNvGILr6a3jee2ouTqEpZSIWO89SaRz+4HE/Ivz4142fisvLIaz7gc6oCHyE4MQstJa22oHqhSGhNoKtWCW9+gBfNc2sEdH9AJoS4fVjsQNxvrVUIqQmSn2WI9XDcSyzxzwJPyNDMLkB5QJKya1O8XLhvwb8MQA664ZE/Nkupb0sdWSGC0+lTJBJlkmNAYXyu0suadTh6oRMWL+E8lGwAXW1VanroKrrwlu/q5C23BJFtb5hVz4/ewrTkGROJFmY0FXu1bP3+e8T4sG8EmIr/NEh6uTcklqg7hVd676JvxbRLynz3jRWN4BqOdXrSJ632FpnSZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dl9h6asDC6GVn0uAdnxJKC7nrg/KTP2yKGCn1Iy4PM4=;
 b=fIbmVveNOYSpYPJKtKJ+H0gnXl47m7lyuQ3oV+QYh50eMEdiaQYARuSl6LiYWo5qifFWQ4MIjLTNhOQXwe3DvLVSXqSwR2W71fFv0qwvPvWXsdEGMsd+a/EGLIK2LArWF3MRia/m4Nm3SiP+9dBIuhrjl6E7k7KmbGE03ZRLuyvujxqeDWYwiFzB43pi5sEw2Ss9Q5Z4yEU/9uG2cPqeHPT0ur7M/EUbUo6x8cCCsSrpBca7qoQWAu5wjsO53MkK6K/VxElPwFARyXwWHinLts9ZaGrpEw187p3MH/3lWX53CKadhOrctGWwE7UyQFPU+OGmEHI1KCoDsRbSYkRbTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB5933.namprd11.prod.outlook.com (2603:10b6:303:16a::15)
 by CH2PR11MB4214.namprd11.prod.outlook.com (2603:10b6:610:3c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Tue, 12 Jul
 2022 02:48:47 +0000
Received: from MW4PR11MB5933.namprd11.prod.outlook.com
 ([fe80::71d0:716c:7d6d:94c4]) by MW4PR11MB5933.namprd11.prod.outlook.com
 ([fe80::71d0:716c:7d6d:94c4%3]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 02:48:47 +0000
Message-ID: <d61ef707-d40c-ee1c-2767-9c5bf974ea0d@intel.com>
Date:   Tue, 12 Jul 2022 10:48:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 01/36] target: Handle MI_REPORT_SUPPORTED_OPERATION_CODES
References: <202207120920.oEIle78M-lkp@intel.com>
Content-Language: en-US
In-Reply-To: <202207120920.oEIle78M-lkp@intel.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <llvm@lists.linux.dev>, <kbuild-all@lists.01.org>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>
From:   kernel test robot <yujie.liu@intel.com>
X-Forwarded-Message-Id: <202207120920.oEIle78M-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:3:18::30) To MW4PR11MB5933.namprd11.prod.outlook.com
 (2603:10b6:303:16a::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f86e96e6-a9e5-47d1-3c75-08da63b10ab9
X-MS-TrafficTypeDiagnostic: CH2PR11MB4214:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 61rUEdfh8IaB5PKlaLU1D/xr+w7nEFR2tXK973BzAvsA1/wBPKw4vtBsclLy4++D8mFSYNKn9GznnhpeYOPev6EsG3F8Lih6R+RQfaOrVnECSOytHQiFTSkm+QPd/cMtJFWPXby5XibEXxKuOcpJnR/lkooplyk4IsS1PApB4tvBGKc7XXunMJojix0oyH0UtiuzFg51kRLFyQwywkflZAsVY/u5QmHUwPjzNqh29PlO2Ul7BPIv0MGqxvYszgv6StXn/Wj6bDaMD8ANXrP5oWxW9OHzZWCZ/N8uAF6b8OcytLtucVKmWGkxLfDdZnDFxG7P/Br6x9kueztXKRjnXhrIgdd70c/vUp4RomyKoq3BzY6o9iOzicOyfEzdCfIYQNWqxghDOJ6aM6GWsqz4+advnQRX59mClb2QSbCN7WRNxfGLjAyusGf8ccBwDontxoGIX5Jdxs6w34NrQkvurs+ltXvJGrk53Wwj929FGPHnFz4e7NlLy1m8L09+b6O8bHpLa6ZB91pr3cpftJ43ZroFCI5WG5XeQvsSryW3fSJ2OCSExSAXLTNzld+NRoDzQS33uot5ANGGUNsMA0hWEZw1qGFmIukisYoDuYiscVmv+AZMG+OEDhpFjWQAeV7QY+TYzgKmeX0QPMFpRfgQAGWKs88okTG0OJ6HnW0L0Svp3Gsg/DLnI5WaJVTyramqnYntYj4QgSIlf+MYUb/8ztNTOsB1w8KHtOEet+lB37cbQgxOHEUnMbm98S22sylT1jYEFVu8d2aYBWZrWvxeoz+GYn2lArOV3VcwyS55Y9zRiqfOFHYLKLALtKimfPjuNkoJb+II390IOl2LfVVqFwLlkyjn98df1Z7+WtqcQZwXnvCh2gHSjT2cKUPu1eBNx4LO5qOOqvCqZiEmS1ZjkX0IHvBAeDiKfTW2FlzKY5k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5933.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(396003)(346002)(136003)(366004)(6486002)(110136005)(478600001)(31696002)(966005)(36756003)(86362001)(54906003)(31686004)(2616005)(38100700002)(6666004)(66476007)(4326008)(8676002)(66556008)(186003)(66946007)(316002)(41300700001)(8936002)(5660300002)(7416002)(6512007)(26005)(83380400001)(2906002)(82960400001)(4001150100001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em9SM0VQWisrQ01kRUlpc3RVWG0xYUJ0TUlKQTRFQTIrZzB3aDVlUEF6ZWtB?=
 =?utf-8?B?NVoxZEo3UGR4WXRQZXlYM1dHQ2JSaEg2dWhMZXQ2b2tQVjI2d2hwdkZpaStt?=
 =?utf-8?B?ZzYwOVQxOThURGxOY2JjQ2JBYm1GSjBCVVE1YlNXWmMwRlRZQUkwOG91ZTVP?=
 =?utf-8?B?L0ZJMS9CRTlGbHBFbGs1elhHcFFEZ2dLZmg3TlN5SEhEUUhoNW9seGh0TDcz?=
 =?utf-8?B?dzZMQmFMeWN5U2htdmhSbjR2SzFwZ001QTVFNXVmNE9FZ3QyVWlneXlIYXM3?=
 =?utf-8?B?NmE2RW0yZDhWQ0c3aVZJQm5aSis4dlFrVC9XTXZON1htTlNOYUFNZ1FkcUJ3?=
 =?utf-8?B?LzZDRjRuQko0R21oa2w1U1N3ZHZrRUJPdkxzcHBnNzlodHpDTXczQ2diczRX?=
 =?utf-8?B?eVdud3M5aVNUa0tvenFoZGtFV1pyOGxTMndzVUpvblk1UkhKYy9QVG5TdGpU?=
 =?utf-8?B?VU5wQWVYcngyU2Q3OThMN1dqeVQyTWdCNGI1MW1LVllMY3JhbFBHVU9hclZE?=
 =?utf-8?B?UnRaYnE0YVErejJIZGhSamVmQ2hhYVpFeERGdVhXRVhaY3IwUVRaSk9kZjF5?=
 =?utf-8?B?SWdSWnZpQ1NIUU1DK0M3K1ArcnBFa0RjbUZVU1dtTzRxMGlwSlpBWVJOaW9r?=
 =?utf-8?B?enpwQWFsREdYMEJxdDlJMnhkekFhZWdTQWpOd3A0Y3JvOS9IaitRWmZsM1k1?=
 =?utf-8?B?VFp2a3R1T0FqU3M5MFFzdHY4Z3hwUFFpemR3K2FMa2F2RVlLTlFOQ0h4dCtu?=
 =?utf-8?B?TmQ2azAvTDRmNnBYeUhKVGUrd3BCNjV6aGRXUktXUjdIVTN3MDgwT25BZ2hR?=
 =?utf-8?B?bVpWQzFTRXFqcU5FTEIvaS84N1A3WXNMNGhlejU5cEdkOHNncGQ4d0xSR3pL?=
 =?utf-8?B?ejZXaFFaUEZZRmRjMkxhQk1aSlRhRUhLOGllSXZDWVp3S2kydkoyMWduTVh0?=
 =?utf-8?B?VzA1T2JRU3c0bndoVkp3Y2tLNWlWL2JuYWlyZ3lyNklGRHh4eklaSU05NUYr?=
 =?utf-8?B?bWdIQVpvaWhoeDVMdjBlK3p2NFFBZmcyU096L002QzljSWluVDZRTWk5TEpw?=
 =?utf-8?B?OUNxaDU5MldCYjNiTndZcDc0MXNIWElMTkNzRjcreE9TNTdQM29jQUYrL0JV?=
 =?utf-8?B?TUhvamZRTExFMnpaaE1KUFFINjgrajAwMENBWndEV0Q5Vmt6Q2liMWIwaFRO?=
 =?utf-8?B?N0I4V0cvOFhObTRrMnlKSnI5NExXL1ZmYVdoZUU4QnFZMk1zeDZmSnJtYW9z?=
 =?utf-8?B?M1M0U2F3VC9KQ0ZjdWlYZ0IzRWFzb1daV0NTQkNsVDhIMG82UXBrQThKKzEv?=
 =?utf-8?B?SS9iNXRzVUZpNW11UENFTS9GWWJGTEthY08wQ1JKcHNuT0FwaDdlUVpTbW9n?=
 =?utf-8?B?Sms1OWl0a2RxOFlwazcvMlZmcWJuY3BoK0p4RVloaUovTWYwTlBjN3RHY3Jy?=
 =?utf-8?B?V21zV29kZUpjS2VmUWxZbFZ3UDlLNGFFbmxpbFg5TlJwODdVcWlWanBCM0k3?=
 =?utf-8?B?WVI4NXZyU2FCRWx0S3hwcUlxczJqelY4Z3hyaHptdTBQYUhwYjJ1dFNRRytW?=
 =?utf-8?B?Smt5eTBhQ1F3UG1rT1dHUzFva0RNd01HQ2s4dFNGd3p0WmVJb3IrcUlxU2pv?=
 =?utf-8?B?SzlEK1cwRE9JSk1KclUrNCtDbElmblovaE4rMUQ5TkFTdHlqTUMvNElhaHZT?=
 =?utf-8?B?cXNCczhHajhzbEo5YW01dlM0VFVkTG9ZSU1hbis4Nk90bUhIVG1mSUR3S1p4?=
 =?utf-8?B?bTJNbXRqM2pZUi9mR0NsZVE4YktERUdvWWR1R0NJeUtxQmZHcDRxQ3ZGV1VR?=
 =?utf-8?B?TlQ0RFlkbTBSOEdlc3JxS3BMQ0owQmZlSStmWXloZEFFOE1IVnBKQWNTRkNL?=
 =?utf-8?B?YmhRMEU2T09URnoycEhVUHl1djFENEpYcEZxUUpPT2xHOWZRcUlDdTd6SUpU?=
 =?utf-8?B?WTV2aS9SZ2F5WElUR1RMK1NmcGcrU1BNdTBYdVBwQWRCNUdhSktjcWgyeDJq?=
 =?utf-8?B?WDhIMisxY3VUYnZLOUFXQ0ZmSUgvelNTWk5mMXRvbS9iRDFySExWMXhvYUZW?=
 =?utf-8?B?Rng2RTUwYThvNEpQS29GZWU1SkoxWDBPMytzV2duV3V2SCtzVEJZTXNvM2NP?=
 =?utf-8?Q?5+iCp5isQGyd5MLgD1GEek+0d?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f86e96e6-a9e5-47d1-3c75-08da63b10ab9
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5933.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 02:48:46.9743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SVL+ds1EOlCn3s3mIKcaT2Ly7gYrhkbE7ONEJq591GE9/yI6kj83cmwCJoeNIZA9ss71m1TPsuUlI8+ja/qFGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4214
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thinh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 90557fa89d3e99286506593fd5180f699c41b152]

url:    https://github.com/intel-lab-lkp/linux/commits/Thinh-Nguyen/usb-gadget-f_tcm-Enhance-UASP-driver/20220707-074014
base:   90557fa89d3e99286506593fd5180f699c41b152
config: s390-randconfig-c005-20220710 (https://download.01.org/0day-ci/archive/20220712/202207120920.oEIle78M-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 6ce63e267aab79ca87bf63453d34dd3909ab978d)
reproduce (this is a W=1 build):
         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
         chmod +x ~/bin/make.cross
         # install s390 cross compiling tool for clang build
         # apt-get install binutils-s390x-linux-gnu
         # https://github.com/intel-lab-lkp/linux/commit/9a7c7d74b2c2d3c8524342cb0278ab8b77714bad
         git remote add linux-review https://github.com/intel-lab-lkp/linux
         git fetch --no-tags linux-review Thinh-Nguyen/usb-gadget-f_tcm-Enhance-UASP-driver/20220707-074014
         git checkout 9a7c7d74b2c2d3c8524342cb0278ab8b77714bad
         # save the config file
         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=s390 clang-analyzer

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <yujie.liu@intel.com>


clang-analyzer warnings: (new ones prefixed by >>)

 >> drivers/target/target_core_alua.c:323:9: warning: Array access (from variable 'buf') results in an undefined pointer dereference [clang-analyzer-core.NullDereference]
            buf[1] = supported;
            ~~~    ^
    drivers/target/target_core_alua.c:271:2: note: 'buf' declared without an initial value
            unsigned char *buf;
            ^~~~~~~~~~~~~~~~~~
    drivers/target/target_core_alua.c:274:6: note: Assuming the condition is true
            if (cdb[2] != 1) {
                ^

vim +/buf +323 drivers/target/target_core_alua.c

c66ac9db8d4ad9 Nicholas Bellinger 2010-12-17  261
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  262  /*
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  263   * REPORT_SUPPORTED_OPERATION_CODES
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  264   *
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  265   * See spc4r17 section 6.27
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  266   */
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  267  sense_reason_t
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  268  target_emulate_report_supported_opcodes(struct se_cmd *cmd)
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  269  {
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  270  	unsigned char *cdb = cmd->t_task_cdb;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  271  	unsigned char *buf;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  272  	u8 supported = 0;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  273
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  274  	if (cdb[2] != 1) {
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  275  		pr_warn("Invalid command format %d\n", cdb[2]);
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  276  		goto out;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  277  	}
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  278
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  279  	buf = transport_kmap_data_sg(cmd);
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  280  	if (!buf)
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  281  		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  282
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  283  	switch (cdb[3]) {
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  284  	case INQUIRY:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  285  	case MODE_SENSE:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  286  	case MODE_SENSE_10:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  287  	case READ_CAPACITY:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  288  	case SERVICE_ACTION_IN_16:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  289  	case REPORT_LUNS:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  290  	case REQUEST_SENSE:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  291  	case SYNCHRONIZE_CACHE:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  292  	case REZERO_UNIT:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  293  	case SEEK_6:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  294  	case SEEK_10:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  295  	case TEST_UNIT_READY:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  296  	case SEND_DIAGNOSTIC:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  297  	case MAINTENANCE_IN:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  298  	case READ_6:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  299  	case READ_10:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  300  	case READ_16:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  301  	case WRITE_6:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  302  	case WRITE_10:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  303  	case WRITE_16:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  304  	case VERIFY_16:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  305  	case MODE_SELECT:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  306  	case MODE_SELECT_10:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  307  	case START_STOP:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  308  	case SECURITY_PROTOCOL_IN:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  309  	case SECURITY_PROTOCOL_OUT:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  310  		supported = 3;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  311  		break;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  312  	case ATA_12:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  313  	case ATA_16:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  314  	case VERIFY:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  315  	case ZBC_IN:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  316  	case ZBC_OUT:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  317  	default:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  318  		break;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  319  	}
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  320
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  321  	transport_kunmap_data_sg(cmd);
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  322  out:
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06 @323  	buf[1] = supported;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  324  	target_complete_cmd(cmd, SAM_STAT_GOOD);
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  325  	return 0;
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  326  }
9a7c7d74b2c2d3 Thinh Nguyen       2022-07-06  327

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
