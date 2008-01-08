From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Open-FCoE on linux-scsi
Date: Tue, 08 Jan 2008 20:38:29 +0300
Message-ID: <4783B515.1030001@vlnb.net>
References: <10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com>	<200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>	<477FCD8C.2040404@vlnb.net> <20080106103138Q.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:34470 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751210AbYAHRiK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 12:38:10 -0500
In-Reply-To: <20080106103138Q.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: robert.w.love@intel.com, yi.zou@intel.com, christopher.leech@intel.com, vasu.dev@intel.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
>>Thus, I believe, that partial user space, partial kernel space approach 
>>for building SCSI targets is the move in the wrong direction, because it 
>>brings practically nothing, but costs a lot.
> 
> We have not discussed such topic. FCoE target can be implemented fully
> in user space if I understand correctly.

Really? FCoE target doesn't need an FC hardware target? And FCoE isn't 
sensitive to the packets forwarding latency?

For fully in-kernel approach it is possible to make the packets 
forwarding zero-copy in both directions FC<->Ethernet, which is 
practically impossible with user space. Modern memory has few GB/s 
throughput, so guess how much latency data copying will add on 10Gbps 
speed. Thus, I believe, if performance matters, FCoE should be in 
kernel, at least hot processing path, when management possibly done in 
user space as for open-iscsi. But user space/kernel separation should 
only be done if the additional user space/kernel interface won't 
complicate things too much.

Vlad
