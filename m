Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7363FC433DB
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 01:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3304E23A03
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 01:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbhAIB11 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jan 2021 20:27:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:50567 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbhAIB11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Jan 2021 20:27:27 -0500
IronPort-SDR: SZZHvTH4jzrRzmk2V629i7ByuRAkLY8x6A36qhXCFu4SmRRSJEZKeuTYnILrnpibuDYLiIY9Qy
 2dTYF3/O9M8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="241751945"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="241751945"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 17:26:45 -0800
IronPort-SDR: M5Tr2XvGFmxX+W4P8wLF02CuPB7ws/wk22au9Q44KKdH932StrzCfalObBHczxDvZ9P6SgNFNJ
 KTEFGhp599sQ==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="399163877"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.196.132]) ([10.212.196.132])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 17:26:43 -0800
Subject: Re: [RFC PATCH v2 net-next 00/12] Make .ndo_get_stats64 sleepable
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Florian Westphal <fw@strlen.de>, linux-s390@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        dev@openvswitch.org
References: <20210105185902.3922928-1-olteanv@gmail.com>
 <20210106134516.jnh2b5p5oww4cghz@skbuf>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <e0edda65-5421-94aa-19c5-1bd88a602f92@intel.com>
Date:   Fri, 8 Jan 2021 17:26:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210106134516.jnh2b5p5oww4cghz@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 1/6/2021 5:45 AM, Vladimir Oltean wrote:
> On Tue, Jan 05, 2021 at 08:58:50PM +0200, Vladimir Oltean wrote:
>> This is marked as Request For Comments for a reason.
> 
> If nobody has any objections, I will remove the memory leaks I
> introduced to check if anybody is paying attention, and I will resubmit
> this as a non-RFC series.
> 

I read through this, and it makes sense to me. I admit that I still
don't grasp all the details of the locking involved.

Thanks,
Jake
