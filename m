Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4338C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 09:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240289AbiFTJCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 05:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240291AbiFTJCj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 05:02:39 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B26212D18
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2022 02:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655715758; x=1687251758;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mue/++QDfHz8s1SYDN3tHd/HyVbuNLYnPaXV0dMyj+Q=;
  b=ZRPyqGBgSUgdmGFSLVEVBqlrAV8QZwxFkTvOjEQo5zGb7SubrLtaMkD4
   fy6rUCnq+dAPzrh5SOEwR10Tw3DJ247PeoWlKWEu+CqLnwk0CNSOGxssj
   nNO4EiJIkMuXUYbzU7rHIWmcgbY7k4bC1x+U7mlEyZU+2IzT0dhGc9gwy
   mzrQrsRlVYu8V8YYIUJCco3QXA8zyq4vgp2cZ7qw82rO+vD/KKqO9P4U3
   bBIuaoMjSwt8+P43MHz99BVIDLv3v2WJDOBbrT4xlnv7GG1CPPWsXgbCG
   SbE0QRWH5crBx0nav2y85OixHE7WEguJg3Y6/T96q/1nmpl1SvRQhZevJ
   g==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650902400"; 
   d="scan'208";a="315708108"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jun 2022 17:02:36 +0800
IronPort-SDR: /W1shMsJ6HiOC4JsTpllBvHyNj0O6/wfoT4/EVmlu6Mz1OTNmsJSp8abDiGUwp+86tK06mUsxI
 eT/uFchC8ncdS1wIP+Ge4LjcNTVjoDF5pjvvwLOuNUfQihnj1vJ07+pRA4iRUfSSwO4IXEgBth
 1HQ4Qf4PbhNE1Yntbk8+GRQxj3MTWMxR5p8N6T73OIBdUnLG5L1BEo3m9l6knXyOiYpvAytndK
 kI3Dg/orOTqNN0StFMA4iRCXGxBBVe46WzfEi+nbkXVi507QVbPkwKuxPGSJMCigFksXIkLlGK
 fzJM4A2ulSUgzaDjl94Jdtkn
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jun 2022 01:20:45 -0700
IronPort-SDR: OznQOoHEOXnulOV1TejW/voGQsGwgwKPelOS0LHYq9ws2e1iiWSarJSUdVy24R8FI9OsnyOIWC
 g05VjNuPnM+JXPFoGYejvaQRgO5j9x0Ay88LMOig3D+EKftOEsksNUazWPhl6BxBck7Cd+DSph
 nwp5hJU63nE7ud6pMe/PNyYp7NKWqcWu6rYQSUZz7fcayWbblnT+D4hszS/7uJzZcEBPDh/y6u
 JuvewCzArUIILYhq+WLQyuo6512P8h66Xqqt653wK+1QOR3JB/sGlcZU0+u3fPfb6+3WwW+4+a
 PQE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jun 2022 02:02:36 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LRNvb5ZR2z1SVp4
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2022 02:02:35 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655715754; x=1658307755; bh=mue/++QDfHz8s1SYDN3tHd/HyVbuNLYnPaX
        V0dMyj+Q=; b=YImFIRiRrDrgmr3/CEXK4JaNZm2henKy6eXOW8Fx7be6OCimAUO
        vVRJhcrAWF4ByFk/qtKoneoqPkzk8ZCcJZzh0LvUeCom0GvZQ45o+/SfEadD0myk
        G8QSjaIQYCmttrgg8eReXFIgcSpnuL5hDoqSGwK9CprdB2CZsydiA6wlWujoBRUZ
        K3wOnJZuz2vGbegW08TX5gOqWVXaTfHt3agijgDcCQFPi+yj/pa399xOMHOM1fzm
        b7ZMn9pGKSNseyvjU8vqKQsW0m5BHKBA1J1nCbVMRqotF6aflfttWu/wLauLdZKb
        joRhsl6kPOpZ2b+0jg7Htwqd+9oNfs7lDEg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dPTijR99gBcy for <linux-scsi@vger.kernel.org>;
        Mon, 20 Jun 2022 02:02:34 -0700 (PDT)
Received: from [10.225.163.87] (unknown [10.225.163.87])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LRNvW6yG3z1Rvlc;
        Mon, 20 Jun 2022 02:02:31 -0700 (PDT)
Message-ID: <9de5ed1b-e874-28ac-0532-cd5420892064@opensource.wdc.com>
Date:   Mon, 20 Jun 2022 18:02:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC v2 03/18] scsi: core: Implement reserved command
 handling
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com, brking@us.ibm.com,
        hch@lst.de
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        chenxiang66@hisilicon.com
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-4-git-send-email-john.garry@huawei.com>
 <b4a0ede5-95a3-4388-e808-7627b5484d01@opensource.wdc.com>
 <9e89360d-3325-92af-0436-b34df748f3e2@acm.org>
 <e36bba7e-d78d-27b4-a0e2-9d921bc82f5d@opensource.wdc.com>
 <3a27b6ff-e495-8f11-6925-1487c9d14fa9@huawei.com>
 <c702f06e-b7da-92be-3c4f-5dd405600235@opensource.wdc.com>
 <ecfb0694-21b8-55b4-c9b8-5e738f59ce8d@huawei.com>
 <98fa010d-3555-a82b-e960-f47aeeb38151@opensource.wdc.com>
 <7b046321-fdb3-33f0-94a0-78a25cbbe02e@suse.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <7b046321-fdb3-33f0-94a0-78a25cbbe02e@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/20/22 17:27, Hannes Reinecke wrote:
> On 6/16/22 10:41, Damien Le Moal wrote:
>> On 2022/06/16 17:24, John Garry wrote:
>>> On 16/06/2022 03:47, Damien Le Moal wrote:
>>>>>> so going backward several years... That internal tag for ATA does not
>>>>>> need to be reserved since this command is always used when the drive is
>>>>>> idle and no other NCQ commands are on-going.
>>>>>
>>>>> So do you mean that ATA_TAG_INTERNAL qc is used for other commands
>>>>> apart from internal commands?
>>>>
>>>> No. It is used only for internal commands. What I meant to say is that
>>>> currently, internal commands are issued only on device scan, device
>>>> revalidate and error handling. All of these phases are done with the
>>>> device under EH with the issuing path stopped and all commands
>>>> completed,
>>>
>>> If I want to allocate a request for an ATA internal command then could I
>>> use 1x from the regular tags? I didn't think that this was possible as I
>>> thought that all tags may be outstanding when EH kicks in. I need to
>>> double check it.
>>
>> When EH kicks in, the drive is in error mode and all commands are back to the
>> host. From there, you need to get the drive out of error mode with read log 10h
>> and then internal commands can be issued if needed. Then the aborted commands
>> that are not in error are restarted.
>>
>> For the non-error case (revalidate), ap->ops->qc_defer() will make sure that NCQ
>> and non-NCQ commands are never mixed. Since all internal commands are non-ncq,
>> when an internal command is issued, there are necessarily no other commands
>> ongoing, but 32 NCQ commands may be waiting, without any free tag. The internal
>> command being non-NCQ can still proceed since it does not need a real device tag.
>>
>> The joy of ATA...
>>
>>> Even if it were true, not using a reserved tag for ATA internal command
>>> makes things more tricky as this command requires special handling for
>>> scsi blk_mq_ops and there is no easy way to identify the command as
>>> reserved (to know special handling is required).
>>
>> Yes. Having the ATA_TAG_INTERNAL tag as a reserved tag is fine. But from the
>> above, you can see that this is not really needed at all to make things work.
>> The management of ATA_TAG_INTERNAL as a reserve tag is really about getting your
>> API to simplify the code.
>>
>> What I am thinking is that with your patches as is, it seems that we can never
>> actually reserve a real tag for ATA to do internal NCQ commands... We do not
>> really need that for now though, apart maybe for speeding up device revalidate.
>> Everytime that one runs, one can see a big spike in read/write IO latencies
>> because of the queue drain it causes.
>>
> Hmm. But doesn't that mean the we can reserve one tag, _and_ set the 
> queue depth to '32'?
> We'll need to fiddle with the tag map on completion (cf my previous 
> mail), but then we might need to do that anyway if we separate out 
> ATA_QCFLAG_INTERNAL ...

Reserving a tag is not enough. As explained, even if I can get a tag for a
qc, I need a proper req to safely issue an ncq command (because of the
potential need to delay and requeue even if we have a free tag !).

So reserving a tag/req to be able to do NCQ at the cost of max qd being 31
works for that. We could keep max qd at 32 by creating one more "fake" tag
and having a request for it, that is, having the fake tag visible to the
block layer as a reserved tag, as John's series is doing, but for the
reserved tags, we actually need to use an effective tag (qc->hw_tag) when
issuing the commands. And for that, we can reuse the tag of one of the
failed commands.

> 
> Cheers,
> 
> Hannes


-- 
Damien Le Moal
Western Digital Research
