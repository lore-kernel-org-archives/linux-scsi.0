Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D8CC64ED8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 21:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjB0VmH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 16:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjB0VmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 16:42:06 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC661ACE1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 13:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677534125; x=1709070125;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E16+HmI91qcq4n85XyiBcodRpHC0xN8mBwf0nq/L8Kk=;
  b=KDW/N30DpjzCOaqpbgvfVe3feZPCx+BLIYModHCEYDCLzoKqZIwdX0Xz
   eIARr4mNd2UVKoYyyXHbzZvZD34t80zaUSmICB1XKIdhvtisiyqlxG7Uo
   2NrVRru8K19It5jUT65+W9EGbzWCoxgSVFd9i+XYyS4XJh3GfkgQOi50t
   XSwfpEWkUmRyTwsnzGqD+w/Hy1xKl1AXrrETWzNfcaBRILmWRXGn1Bs0y
   Liqkc7v+PCr9mrhS2Gbs6HMkoXaB3waqefSLOv3xeAE4CokXf0xgLH+xe
   IAlPwdtP8cX4fXlKBvJEVVuEE2HbJWxWL7I4WIaQ+GKatgrEcG4+90PvK
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,220,1673884800"; 
   d="scan'208";a="328673535"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2023 05:42:04 +0800
IronPort-SDR: XoG2QWNEzGl7He2uW2gTRaRNqWrHOPcifKavWCQ02R2JZeO7JV6O8IlqmU7JUvO0TDo0xeBOdD
 9Z2DWvjXD5DBjB7PrmklsRAbKJEC6gUMXd0ujObimsTQQ3DUftRK9XIdVko8NdFr4bBTAwwebb
 8XERm3Pnf68OeotMYYTEYRNBKhwAoSavZgqE7z+aALnDVTqu4y4AML3jzMuiHjv6vhsuufAeVA
 BrwasWw/NITDCYmQn5RqczhAcmBf09Idus3Sxn2ahi5pioOMUYLmomkinBPQ+O2+bDA/mpEUPj
 7Dk=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Feb 2023 12:53:11 -0800
IronPort-SDR: ZH4v5G1oQhVNInNmHWxd3Yuvd7zDg9WO0GRekZ7/1sXPSjoKTEDDtr5PN/3OgX3rKXFcZjQDS5
 Oas5cDd9mrFsvp1teKVxUgPsW14ycK6B3OUpBRDSUPGT0wo7FSCv6FqfXk9005zr22ru8MhTGs
 QbLfF3+CWyFEO3pQDcwNn/YM8Ey1STHLJU/bq815jo+z2Vj8JVr9xiLb9g/PSZ+8fNTJx51hPu
 y0zQM+MypVgIlCqeBcNv3VYVP9BkRThFEkzunTXgs8E1MxvqhaXR2QCbzUUIbLEUFlQrwpzAE6
 VuY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Feb 2023 13:42:05 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PQYqc03chz1Rwtm
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 13:42:04 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1677534123; x=1680126124; bh=E16+HmI91qcq4n85XyiBcodRpHC0xN8mBwf
        0nq/L8Kk=; b=ZDIJKxZC/XiBEFR1lU5bIqmUDLpKvv3mVUtzX+l+JOr1/H3c6o2
        bgjlE20HVQFCtxvgkyjUyzSnC+AFx6ptm/8HIXD7hcxLI/U4RNA0nd70r/YOuXsu
        CilEATzEr28n12S7pkjSLWEQJN4NYDeM6QwR/aRKUz8JJ3XLWTCGV296TWQBOoN7
        SgIgpfNN09SDg3s1N3uLHwyKLOWMCRjJnJroz0gXnFMFRYsq4g1/ro001OvSJZ2d
        1yPNrEFKtKf38tyW6eIEl8FBnB9WN+G/f8PQ7G3rSIeOOIngIHdr9sTE7N5bJlER
        L+dvopUXf7Z3pnIboSAdeaJiL9pGMoexDZA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xnVM6k5Ml4uo for <linux-scsi@vger.kernel.org>;
        Mon, 27 Feb 2023 13:42:03 -0800 (PST)
Received: from [10.225.163.44] (unknown [10.225.163.44])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PQYqY2qRZz1RvLy;
        Mon, 27 Feb 2023 13:42:01 -0800 (PST)
Message-ID: <9e1d83e8-e382-59a6-3283-e4f4a5dc7f56@opensource.wdc.com>
Date:   Tue, 28 Feb 2023 06:42:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
References: <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
 <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
 <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
 <561afa67-04d0-c675-6bbb-048313da152b@grimberg.me>
 <73b4dd39-9ce8-9b55-8a1d-06865f3bde32@nvidia.com>
 <Y/lpmrwuehnsWmmR@kbusch-mbp.dhcp.thefacebook.com>
 <0fe59301-65e6-d8a9-033e-0243ad59c56b@opensource.wdc.com>
 <316431ed-1727-7e80-2090-84ac5b334f74@grimberg.me>
 <3ea301b1-c808-ce08-8ec8-3a631b385fb9@suse.de>
 <Y/zsE9i7012Ivwe1@kbusch-mbp.dhcp.thefacebook.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y/zsE9i7012Ivwe1@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/28/23 02:44, Keith Busch wrote:
> On Mon, Feb 27, 2023 at 06:28:41PM +0100, Hannes Reinecke wrote:
>> On 2/27/23 17:33, Sagi Grimberg wrote:
>>>
>>> I'm not up to speed on how CDL is defined, but I'm unclear how CDL at
>>> the queue level would cause the host to open more queues?
> 
> Because each CDL class would need its own submission queue in that scheme. They
> can all share a single completion queue, so this scheme doesn't necassarily
> increase the number of interrupt vectors.
> 
>>> Another question, does CDL have any relationship with NVMe "Time Limited
>>> Error Recovery"? where the host can set a feature for timeout and
>>> indicate if the controller should respect it per command?
>>>
>>> While this is not a full-blown every queue/command has its own timeout,
>>> it could address the original use-case given by Hannes. And it's already
>>> there.
>> I guess that is the NVMe version of CDLs; can you give me a reference for
>> it?
> 
> They're not the same. TLER starts timing after a command experiences a
> recoverable error, where CDL is an end-to-end timing for all commands.

Note here that with the current T10/T13 CDL definitions, end-to-end actually
means from the time the command is received by the device to the time the device
signals the command completion.

That does not include the transport & host adapter queueing (if there is an
HBA). And I guess this is the issue at hand for fabrics: how to integrate the
transport times. I guess the CDL descriptors could have one additional limit for
that, but then the duration guideline limit definition would need to be tweaked.

-- 
Damien Le Moal
Western Digital Research

