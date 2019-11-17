Return-Path: <SRS0=Zq1p=ZJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7DCC432C3
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 15:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A822084C
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 15:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfKQPBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 10:01:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:57244 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726316AbfKQPBp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Nov 2019 10:01:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70343B1B4;
        Sun, 17 Nov 2019 15:01:43 +0000 (UTC)
Subject: Re: [PATCH 2/5] dpt_i2o: use midlayer tcq implementation
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191115122757.132006-1-hare@suse.de>
 <20191115122757.132006-3-hare@suse.de> <20191116163120.GC23951@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2132841d-b9e1-f656-7d46-d5c2617a5fcf@suse.de>
Date:   Sun, 17 Nov 2019 16:01:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191116163120.GC23951@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/19 5:31 PM, Christoph Hellwig wrote:
> On Fri, Nov 15, 2019 at 01:27:54PM +0100, Hannes Reinecke wrote:
>> +	cmd->result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
>> +	cmd->scsi_done(cmd);
>>   
>> +	return true;
>> +}
>> +
>> +static void adpt_fail_posted_scbs(adpt_hba* pHba)
>> +{
>> +	scsi_host_busy_iter(pHba->host, fail_posted_scbs_iter, NULL);
> 
> I still think that SAM_STAT_TASK_SET_FULL is a very strange error here,
> and that we should have a helper like adpt_fail_posted_scbs in the
> core SCSI code.  Also your * placement is wrong above.
> 
Ok, will do so.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
