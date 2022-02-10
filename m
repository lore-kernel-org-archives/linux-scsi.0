Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8862C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 07:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbiBJHcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 02:32:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiBJHcS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 02:32:18 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062C1270
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 23:32:19 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 95E241F391;
        Thu, 10 Feb 2022 07:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644478338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjlN/oDNGN8CfiI0p5i+bn3CubKZX63GM6jod1ValIA=;
        b=WF6d4S/xJ92enVyFE51KZLTtr2Mv0eRNzfJ3C0MkIf2ZzUw2bhFF8A97akd3rd1UxODRoA
        qgCFFzC0L1BFNzkXq3L7DMVFmHFGoxoYwI+4Mo5dhoXEAZDahFB+aTW5WFvZo9b1O4ctp7
        GJ6V2CgXwbcxuE3DpdF0Cg0R6D8rSB8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644478338;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjlN/oDNGN8CfiI0p5i+bn3CubKZX63GM6jod1ValIA=;
        b=PlAJYRS+PUHA/8MLDcV3pd7UCWx51WztPrbnnWPTSwka8LcIiRooFDfilMFI4ZpdaPUJZf
        FmeE+fEezeFvg4DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 36EF013B2D;
        Thu, 10 Feb 2022 07:32:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kn0PDIK/BGKyGgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 10 Feb 2022 07:32:18 +0000
Message-ID: <cb986e55-2505-fab4-aff2-e4fa59d4dbe0@suse.de>
Date:   Thu, 10 Feb 2022 08:32:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 20/44] hptiop: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-21-bvanassche@acm.org>
 <726f470b-0262-7416-e2dc-8b68424fb74b@suse.de>
 <ceebc6a6-6515-f66d-bfd3-40693a2f0888@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <ceebc6a6-6515-f66d-bfd3-40693a2f0888@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 19:24, Bart Van Assche wrote:
> On 2/8/22 23:57, Hannes Reinecke wrote:
>> On 2/8/22 18:24, Bart Van Assche wrote:
>>> -struct hpt_scsi_pointer {
>>> +struct hpt_cmd_priv {
>>
>> Why not keep the name? You have been using 'struct scsi_pointer' with 
>> all the other drivers ...
> 
> I assume that "SCSI pointer" refers to a section in the SCSI II 
> specification with the same title. The hptiop private data is not 
> related to the SCSI II "SCSI pointer" section. Hence the renaming of 
> this data structure.
> 
Ah, right. Misread the patch.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
