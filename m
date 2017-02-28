From: James Smart <james.smart@broadcom.com>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Tue, 28 Feb 2017 10:14:56 -0800
Message-ID: <7ed64006-84cd-06a0-3894-6d635fdc435a@broadcom.com>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
 <fc019750-b054-d9f7-0d5e-e6c7128073d8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:35726 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdB1Spy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 13:45:54 -0500
Received: by mail-wr0-f170.google.com with SMTP id g10so14944423wrg.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 10:45:14 -0800 (PST)
In-Reply-To: <fc019750-b054-d9f7-0d5e-e6c7128073d8@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, jsmart2021@gmail.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>


On 2/28/2017 8:34 AM, Hannes Reinecke wrote:
> Can you clarify these?
> Are these 'just' resource allocation problems or something else, too?

Most are resource allocation - buffer pools, dma pools, pages for 
resources, and hw resource allocation splits. However, async receive RQ 
policies are a case where initiator and target have to share the policy 
and perhaps a buffer pool, so they have to be careful. Another area is 
in ABTS handling. Initiators typically leave things up to the hardware, 
and do little if any ABTS handling. Most targets though, as CMD IU may 
be received without an assign exchange context and be buffered until the 
target is ready to do something, require that they handle ABTS's.  Some 
of the target features, when enabled, dictate host ownership of ABTS 
policy. So, if running I+T, it gets rather tricky.

-- james
