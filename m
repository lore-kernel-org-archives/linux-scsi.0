Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AFFC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 01:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbiBWBaF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 20:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbiBWBaE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 20:30:04 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1D249F90
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 17:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645579778; x=1677115778;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nSHdp0a4GmD+jXxAqqT79DZ6hE1s0OTI3GXP9NWFpG4=;
  b=Zd8ZBKRMSD5/3SnT5cf0KCgFZ8Lk4sU1a9jLJtXL+gZUMEXeQ/vAnMq3
   aq+SuRYIxoGUKaJDeXZbfTv3K+GdAaMhhrW6JNh0zbFCVzr2fhWyHEUSX
   oG+b17a9mR54RSE5r7pj5a90RYzMUS5eNHCsaHTU8WwUQe0FGwNB+crHr
   2MP98ly1zZWtqbgOIvoJ1xOPZLIWQkizN/aVBHWpRN8cAOEzsJBNkBRBa
   ifom0YuHFGgqVI89d/9HZqDyIKPzuEPddFcHrCVPgXMgdwLVjqfjq4Cfy
   tG3Z1a/RPm0Peqk3sjU8hRrCBKts2A/N6i4hn9AtHHbp4muvd/Qs+oMe1
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,389,1635177600"; 
   d="scan'208";a="305621093"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2022 09:29:28 +0800
IronPort-SDR: Z2Nfh8hYTB01i/blFf+9Vt0qydPOQ9IkhGCmZc0fDvCzfIe6LzdRndR6YzzBfD+NMhFqU+LHbm
 /NjGeyH1hg3oPbzJP+42ytSrmujmo8NJYW8fKlkdXeOVNZrR7bRdXQ6m9qaJ3ccYdfKW+Kjbf/
 yV4PnCfo+fBgLLL5xdSJlUR+xfYZGt3oHwIZMhJyxkIAPCEHKKNl8AZfmhsJqoQvFiBP74pmPl
 JAHRYAFCrsX+/glROXGyo7pv0EbLrzyZW93ThdYKYkBVGhJikBqKxjaL14nwy5qleCdvQo9uSd
 XoKDaGC2hhTtFv78eWqwYOvn
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 17:02:06 -0800
IronPort-SDR: 1vZhNPfD1COTH75AprTnvvqtlobzu/iI44wYMd9NI7A1J+D6990hd6dDkfPqQERL7M/lWlUFIB
 LWHoTxhCpoYpc28lTBoBM1oKHAI9uozStoscHiYqm9nhVGryOuUbQlwn1T7Dh2/lWJD9+jaPkj
 AnWNfePhWIMenqwq/xcCATHfHXCGdewt8vTBmXHr3RAndW9dTZKbDYYob0YS+aDAMnNtfSJ8Uf
 kM8a39SNN/hmu6XBOzzND9JhsJAUp7gYpT6PdkYlMmH9F99BG+UlDTsPDuORAtZTUbqH+xLhn0
 ecQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 17:29:28 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K3JNm0zDvz1SVnx
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 17:29:28 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645579766; x=1648171767; bh=nSHdp0a4GmD+jXxAqqT79DZ6hE1s0OTI3GX
        P9NWFpG4=; b=KKQVRAyjau51Pr3UeBfi5TuayEPGl++8gnnXlp2g8aNDH6xeOvW
        U918Vy4SwenFuFF97KR2qLFDtoyJBtfphmAwLab247cfnberH6iiUD3dycLIpt6t
        sIDCi6XfagreGWjzq9T7wNbZGtCf+l6+EmtwJRUTOpGVnYbmIJlzwwoP5zqknv2S
        VEyGa5CaA6qAaKi3/GPnVIdGL7Zisv7gCccVmKT0COg0gMsGh9ZA+yZiQxrnDxIC
        ktsRh2afLTZIvPcntL1GAH5Yt4xLheVnrWrw3baxC8UakDHI5XXOmJDGadGvQyYJ
        WMmDdFKJkSF3FCBu0qcFds0P3w2kS1oapRw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 62ynQaDs5vop for <linux-scsi@vger.kernel.org>;
        Tue, 22 Feb 2022 17:29:26 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K3JNb3h1Dz1Rvlx;
        Tue, 22 Feb 2022 17:29:19 -0800 (PST)
Message-ID: <98ddab1b-6702-f121-9fef-0ce185888a1a@opensource.wdc.com>
Date:   Wed, 23 Feb 2022 10:29:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 02/10] block: Introduce queue limits for copy-offload
 support
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Nitesh Shetty <nj.shetty@samsung.com>
Cc:     hch@lst.de, javier@javigon.com, chaitanyak@nvidia.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        msnitzer@redhat.com, bvanassche@acm.org,
        martin.petersen@oracle.com, hare@suse.de, kbusch@kernel.org,
        Frederick.Knight@netapp.com, osandov@fb.com,
        lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
        josef@toxicpanda.com, clm@fb.com, dsterba@suse.com, tytso@mit.edu,
        jack@suse.com, joshi.k@samsung.com, arnav.dawn@samsung.com,
        nitheshshetty@gmail.com, SelvaKumar S <selvakuma.s1@samsung.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <james.smart@broadcom.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <20220214080002.18381-1-nj.shetty@samsung.com>
 <CGME20220214080605epcas5p16868dae515a6355cf9fecf22df4f3c3d@epcas5p1.samsung.com>
 <20220214080002.18381-3-nj.shetty@samsung.com>
 <20220217090700.b7n33vbkx5s4qbfq@garbanzo> <20220217125901.GA3781@test-zns>
 <YhWGDUyQkUcE6itt@bombadil.infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YhWGDUyQkUcE6itt@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/23/22 09:55, Luis Chamberlain wrote:
> On Thu, Feb 17, 2022 at 06:29:01PM +0530, Nitesh Shetty wrote:
>>  Thu, Feb 17, 2022 at 01:07:00AM -0800, Luis Chamberlain wrote:
>>> The subject says limits for copy-offload...
>>>
>>> On Mon, Feb 14, 2022 at 01:29:52PM +0530, Nitesh Shetty wrote:
>>>> Add device limits as sysfs entries,
>>>>         - copy_offload (RW)
>>>>         - copy_max_bytes (RW)
>>>>         - copy_max_hw_bytes (RO)
>>>>         - copy_max_range_bytes (RW)
>>>>         - copy_max_range_hw_bytes (RO)
>>>>         - copy_max_nr_ranges (RW)
>>>>         - copy_max_nr_ranges_hw (RO)
>>>
>>> Some of these seem like generic... and also I see a few more max_hw ones
>>> not listed above...
>>>
>> queue_limits and sysfs entries are differently named.
>> All sysfs entries start with copy_* prefix. Also it makes easy to lookup
>> all copy sysfs.
>> For queue limits naming, I tried to following existing queue limit
>> convention (like discard).
> 
> My point was that your subject seems to indicate the changes are just
> for copy-offload, but you seem to be adding generic queue limits as
> well. Is that correct? If so then perhaps the subject should be changed
> or the patch split up.
> 
>>>> +static ssize_t queue_copy_offload_store(struct request_queue *q,
>>>> +				       const char *page, size_t count)
>>>> +{
>>>> +	unsigned long copy_offload;
>>>> +	ssize_t ret = queue_var_store(&copy_offload, page, count);
>>>> +
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (copy_offload && !q->limits.max_hw_copy_sectors)
>>>> +		return -EINVAL;
>>>
>>>
>>> If the kernel schedules, copy_offload may still be true and
>>> max_hw_copy_sectors may be set to 0. Is that an issue?
>>>
>>
>> This check ensures that, we dont enable offload if device doesnt support
>> offload. I feel it shouldn't be an issue.
> 
> My point was this:
> 
> CPU1                                       CPU2
> Time
> 1) if (copy_offload 
> 2)    ---> preemption so it schedules      
> 3)    ---> some other high priority task  Sets q->limits.max_hw_copy_sectors to 0
> 4) && !q->limits.max_hw_copy_sectors)
> 
> Can something bad happen if we allow for this?

max_hw_copy_sectors describes the device capability to offload copy. So
this is read-only and "max_hw_copy_sectors != 0" means that the device
supports copy offload (this attribute should really be named
max_hw_copy_offload_sectors).

The actual loop to issue copy offload BIOs, however, must use the soft
version of the attribute: max_copy_sectors, which defaults to
max_hw_copy_sectors if copy offload is truned on and I guess to
max_sectors for the emulation case.

Now, with this in mind, I do not see how allowing max_copy_sectors to be
0 makes sense. I fail to see why that should be allowed since:
1) If copy_offload is true, we will rely on the device and chunk copy
offload BIOs up to max_copy_sectors
2) If copy_offload is false (or device does not support it), emulation
will be used by issuing read/write BIOs of up to max_copy_sectors.

Thus max_copy_sectors must always be at least equal to the device
minimum IO size, that is, the logical block size.


-- 
Damien Le Moal
Western Digital Research
