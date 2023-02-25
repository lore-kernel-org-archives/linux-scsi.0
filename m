Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91254C64EC7
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Feb 2023 04:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjBYEP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 23:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBYEP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 23:15:58 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7585A9EE6
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 20:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677298557; x=1708834557;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6z1EbfuPho1rVew+raNNpBWD/Q7390l2PiIhpI4miCQ=;
  b=c8kcb5UwWc5GFc4pUvctBDVD6gjwR8qEfac8BaLvmE+2yCeUT6Ubw6Pc
   hdZtRj0QWnWCbaueTFjZa4iLYwoPyrziZcweyUpVqsp3m6ia9w6AzD9Eh
   2d8i5e1uY9Enqmyo/bnf/UsjBpOHq7cC90iaDOMFKNhcrcH5jblV0JwNc
   5R1TghqxNHgQTgvJ7BQ2dREk1XFikYadhYe/sROMlNL3HkU9QSA13X5cg
   LKOfX1j/1uP8uU8HwV+aBVtPe6ij3JKbpkOYv2vqqGexsDfgL5Dza6mlI
   pOZITZZDszGL9hWbmvLbNFD9TwNg6pcbx6FneTqNUm+6G3SKAHYinvK3S
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,326,1669046400"; 
   d="scan'208";a="224192359"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2023 12:15:53 +0800
IronPort-SDR: +G64sM/4Ub0sPOLq+mz7oWoBKOcKQ7Gb9x9NuWsP1X0fCT/S4ydYh1WRISwgyTEzmQT9hL+uDC
 5CcGU/ZPRnR6Fsns1ATiznCwZQpSHtTFkWw44AMkDXPlmF+uPEBcpxpNF0x8dDxUl2Vb+3B1Cs
 RFAf6Vx/OiEnb39/1WixZ5I0ZULE3SvdpXks27qtAitGfKideATcWI/gA2D2fv2BzBnvBiPCvn
 uOldW4V/E2bEtO8UM7n7Kz3Mg62Z7JgCaVwEK+Fp8j8Fw+TaZ3j9K2Y+jb/iXUXJ0iDKOXvfi5
 U68=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Feb 2023 19:27:04 -0800
IronPort-SDR: As3ZM9FDt7i5ApWQ7P7q6RjJpvH484XaJTHgai00QBX6ZSQUhvFC9pEMmjci0ELbisac3CKSx6
 qTCv1zZEFHRKsiLK264eSZ08X83DWSPLdb+HZmfm+axtT4dJnySeLhx4lXVSjGcarwdUJWrDCL
 NeIVYbaCcKMVy0+4lPfzWt3+apok3jtlwjKp6kj21gy67z9pWiAXJH813nHd1OiyQ6J6BsQNmA
 pmkhrS4Lx1MEwrqLf7YKOdqQHKAjuj+rVMV6IV5D8eS1mCIT40rud57C1I3mkpKG/DSZE9ca9Z
 bFk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Feb 2023 20:15:55 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PNtjP5Xt1z1Rwtm
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 20:15:53 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1677298552; x=1679890553; bh=6z1EbfuPho1rVew+raNNpBWD/Q7390l2PiI
        hpI4miCQ=; b=kjEXB4EdNnqOPnf/yVVlla+3GG31+P8PUMk6kkv/SZJYwJ/AvA1
        ev34ksvg008CS7Ha+74VydUPMPsAjOsoSvvLiSZshCPRii5ugzFg3T1ba9WLX/fx
        ua5D+R+DHgu0Xg11AsVPA8LasFvnccoUb4OotxuitlB8wpeZKDWLjArMWuYSTUWL
        NfbXULhxfkql/8CA32sQIKzw9qLFTyATM5IZZr2WkWdZFR0TK5ooB2d2pdqGWh56
        /wFYoOMHU1mtQMvJeBJPRjU25kFTXcqRltboZJAoxggo0xv+h7W1W78Q+RC4WgHP
        kh+l+mSauvCcifYKI5euOKBAEzXtJBSaOEA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SlkcaGl8wLFK for <linux-scsi@vger.kernel.org>;
        Fri, 24 Feb 2023 20:15:52 -0800 (PST)
Received: from [10.225.163.34] (unknown [10.225.163.34])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PNtjM1FVwz1RvLy;
        Fri, 24 Feb 2023 20:15:50 -0800 (PST)
Message-ID: <0fe59301-65e6-d8a9-033e-0243ad59c56b@opensource.wdc.com>
Date:   Sat, 25 Feb 2023 13:15:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
To:     Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
 <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
 <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
 <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
 <561afa67-04d0-c675-6bbb-048313da152b@grimberg.me>
 <73b4dd39-9ce8-9b55-8a1d-06865f3bde32@nvidia.com>
 <Y/lpmrwuehnsWmmR@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y/lpmrwuehnsWmmR@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/25/23 10:51, Keith Busch wrote:
> On Fri, Feb 24, 2023 at 11:54:39PM +0000, Chaitanya Kulkarni wrote:
>> I do think that we should work on CDL for NVMe as it will solve some of
>> the timeout related problems effectively than using aborts or any other
>> mechanism.
> 
> That proposal exists in NVMe TWG, but doesn't appear to have recent activity.
> The last I heard, one point of contention was where the duration limit property
> exists: within the command, or the queue. From my perspective, if it's not at
> the queue level, the limit becomes meaningless, but hey, it's not up to me.

Limit attached to the command makes things more flexible and easier for the
host, so personally, I prefer that. But this has an impact on the controller:
the device needs to pull in *all* commands to be able to know the limits and do
scheduling/aborts appropriately. That is not something that the device designers
like, for obvious reasons (device internal resources...).

On the other hand, limits attached to queues could lead to either a serious
increase in the number of queues (PCI space & number of IRQ vectors limits), or,
loss of performance as a particular queue with the desired limit would be
accessed from multiple CPUs on the host (lock contention). Tricky problem I
think with lots of compromises.

-- 
Damien Le Moal
Western Digital Research

