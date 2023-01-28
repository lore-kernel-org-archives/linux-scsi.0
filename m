Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD633C38142
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Jan 2023 00:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbjA1A7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 19:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbjA1A7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 19:59:22 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08E480FA2
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2023 16:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674867561; x=1706403561;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0Enc1ChW/jUaR4OPasM8k1ypKYxaX9fNzHfctVpe1yU=;
  b=gi4gsB3IEUxYfN/343MAjyS6SvN0r75yPaVRel6GzZBatq2EgoAb2ho3
   VtnuphSYFS4LpPQvvUnJEl4vDYJC5tTSJ/sGRmFD4L+qOZrlgNsI+AGkV
   /DeeyBIDM/4eFK2jshfrq5TV7fjvtVS0GPlSVV4g0avsD5hrLJVdxTXxx
   XvN1PdYcq1Ks2IveIAXxOMPORcRGSL3SKeh6Tvp+VDRYZjgFtgKurGfFV
   mziJlUbL6HpTpW/0U/lezTucOljYURMknmdc5rfmpw4JseYq/iRAyvvcY
   DdA3TcVliniXvUAXv6hEuCEi84dbvynGIkIJJKdLRvr4Od285tlg/8CU1
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,252,1669046400"; 
   d="scan'208";a="333915823"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2023 08:59:20 +0800
IronPort-SDR: YRtiNKXZ7xpIZuD3NwARcWpyvGsDCngcnKGqxboPb2VPdR+oxT6IQJItj/TOpp+a4DMoy0m1kE
 mbb+NVWJQ2iQ+NLeRTOOCufSUuWXNtfv4+NQPmYX0qc4AOClIeIVHEEE5FlGwSzauj7AvpHOdw
 ZuDDctHVSRMgHehdWoiuJdUGGf7P2HMjK3r1eUqGabv+7MDrTObCK6A7QAbOiz0Z/QRFAJcf4b
 0Aj4FLA3QKisIVV6G8y7Hod6FAwRXlxeK7vdc35V6DHTrzgew+SiOBZamquGVRY6rTXz4n2Vrf
 i5I=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2023 16:11:04 -0800
IronPort-SDR: 6ypKKXxlHdxSwchHOIulmFYcNn0myo+evhXPRdUuENjYO3Sq7Oh5p14M0ZEk+YMMxNkNGE8dSq
 oXo5HuvrxogoWAkR3HPoajTGHqFg83r823S3tjLQbOGQxPX6hbZJZk+n01+hqY+6J3L9bh5EAa
 xv5dmBhcHxFpzy756U4XupPk5eZdsnq564m8h10EfT/228xFJpAFLNQK3lwVGB0MXwxLyT1tUi
 JxN2shBujhBmgHrHeHcTycxTotGQ1O7AvxRx4TqYcFl3tWygmh9swyFGXo+4qTNP0vfKZbWDt2
 RBQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2023 16:59:21 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P3bgW6zDyz1Rwrq
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2023 16:59:19 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674867559; x=1677459560; bh=0Enc1ChW/jUaR4OPasM8k1ypKYxaX9fNzHf
        ctVpe1yU=; b=sFdZ5J4UDrXEnatR4KZhpRYvKQsrGw+Wnr7GlSyxQ6KLPUGkXQq
        07ZJ5l6C+6MusK8J4u7+2wojs5wLnzxkE3+D/T5aRrdbATkRpfjIIfvTFNuAdRvh
        ShXcdhxl1/m7oXV72uyq3uTpI6gSEyy8UEv9Cu/pJJ2H4yN5aVxlqRYNs5UFDJjA
        SZA/yTWERIjiYA2v6kN5m+YEPv8yrXUQybL4AA3kBkIC0wd6l1unMMuyfhUOob8I
        7BxjmYylesJFo289K8/D41rD24ybrbgv9zvvxhUWSiix13wxRQl1X9USFYpNW8Pq
        H1hAVTQ2SH+73M1IPOs7hZNNPFzuLpVa7Fw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HLrHpUYXsD_A for <linux-scsi@vger.kernel.org>;
        Fri, 27 Jan 2023 16:59:19 -0800 (PST)
Received: from [10.225.163.66] (unknown [10.225.163.66])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P3bgT5KkCz1RvLy;
        Fri, 27 Jan 2023 16:59:17 -0800 (PST)
Message-ID: <4e803108-9526-6a75-f209-789a06ef52f9@opensource.wdc.com>
Date:   Sat, 28 Jan 2023 09:59:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
 <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
 <e8324901-7c18-153f-b47f-112a394832bd@acm.org> <Y9Gd0eI1t8V61yzO@x1-carbon>
 <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
 <Y9KF5z/v0Qp5E4sI@x1-carbon> <7f0a2464-673a-f64a-4ebb-e599c3123a24@acm.org>
 <29b50dbd-76e9-cdce-4227-a22223850c9a@opensource.wdc.com>
 <c8ef76be-c285-c797-5bdb-3a960821048b@opensource.wdc.com>
 <ddc88fa1-5aaa-4123-e43b-18dc37f477e9@acm.org>
 <049a7e88-89d1-804f-a0b5-9e5d93d505f7@opensource.wdc.com>
 <b77d5e44-bc1e-7524-7e09-a609ba471dbc@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <b77d5e44-bc1e-7524-7e09-a609ba471dbc@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/23 09:47, Bart Van Assche wrote:
> On 1/27/23 16:40, Damien Le Moal wrote:
>> On 1/28/23 02:23, Bart Van Assche wrote:
>>> I hope that I have it made it clear that I think that the proposed user
>>> space API will be very painful to use for application developers.
>>
>> I completely disagree. Reusing the prio class/level API made it easy to allow
>> applications to use the feature. fio support for CDL requires exactly *one line*
>> change, to allow for the CDL class number 4. That's it. From there, one can use
>> the --cmdprio_class=4 nd --cmdprio=idx options to exercise a drive. The value of
>> "idx" here of course depends on how the descriptors are set on the drive. But
>> back to the point above. This depends on the application goals and the
>> descriptors are set accordingly for that goal. There is no real discovery needed
>> by the application. The application expect a certain set of CDL limits for its
>> use case, and checking that this set is the one currently defined on the drive
>> is easy to do from an application with the sysfs interface we added.
>>
>> Many users out there have deployed and using applications taking advantage of
>> ATA NCQ priority feature, using class RT for high priority IOs. The new CDL
>> class does not require many application changes to be enabled for next gen
>> drives that will have CDL.
>   As I mentioned before, the new I/O priority class IOPRIO_CLASS_DL 
> makes it impossible to use a single I/O priority class across devices 
> that support CDL and devices that do not support CDL. I'm surprised that 
> you keep denying that IOPRIO_CLASS_DL is a royal pain for users who have 
> to support devices that support CDL and devices that do not support CDL.

I am not denying anything. I simply keep telling you that CDL is not a generic
feature for random applications to use, including those that already use
RT/BE/IDLE. It is for applications that know and expect it, and so have a setup
suited for CDL use down to the drive CDL descriptors. That includes DM setups.

Thinking about CDL in a generic setup for any random application to use is
nonsense. And even if that happens and a user not knowing about it still tries
it, than as mentioned, nothing bad will happen. Using CDL in a setup that does
not support it is a NOP. That would be the same as not using it.

> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

