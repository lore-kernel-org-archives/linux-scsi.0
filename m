From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 10/17] target: Add protection SGLs to target_submit_cmd_map_sgls
Date: Wed, 22 Jan 2014 12:07:22 +0200
Message-ID: <52DF985A.60301@dev.mellanox.co.il>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>	 <1390099480-29013-11-git-send-email-nab@daterainc.com>	 <52DBC145.7040104@dev.mellanox.co.il> <1390342665.5567.776.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:59554 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaAVKHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2014 05:07:30 -0500
Received: by mail-we0-f169.google.com with SMTP id u57so142541wes.14
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 02:07:29 -0800 (PST)
In-Reply-To: <1390342665.5567.776.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>

On 1/22/2014 12:17 AM, Nicholas A. Bellinger wrote:
> On Sun, 2014-01-19 at 14:12 +0200, Sagi Grimberg wrote:
>> On 1/19/2014 4:44 AM, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>
>>> This patch adds support to target_submit_cmd_map_sgls() for
>>> accepting 'sgl_prot' + 'sgl_prot_count' parameters for
>>> DIF protection information.
>>>
>>> Note the passed parameters are stored at se_cmd->t_prot_sg
>>> and se_cmd->t_prot_nents respectively.
>>>
>>> Also, update tcm_loop and vhost-scsi fabrics usage of
>>> target_submit_cmd_map_sgls() to take into account the
>>> new parameters.
>> I didn't see that you added protection allocation to transports that
>> does not use
>> target_submit_cmd_map_sgls() - which happens to be iSCSI/iSER/SRP :(
>>
>> Don't you think that prot SG allocation should be added also to
>> target_alloc_sgl()? by then
>> se_cmd should contain the protection attributes and this routine can
>> know if it needs to
>> allocate prot_sg as well. This is how I used it...
> Yes, this specific bit was left out for the moment as no code in the
> patch for v3.14 actually uses it..
>
> I'm planning to add it to for-next -> v3.15 code as soon as the merge
> window closes.
>
> --nab
>

Yes, that makes sense to me.

Sagi.
