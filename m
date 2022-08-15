Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5D2C00140
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 05:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiHOF4F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 01:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiHOF4E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 01:56:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28395BCBF
        for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2022 22:56:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D558F201B2;
        Mon, 15 Aug 2022 05:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660542958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jlWCmLykmeA8uKPQs6RNLVRg3DyxBvBEEoXLbScAJW8=;
        b=Zuj+XjDT6RQg07lvuF1Q/vBI9aWdMZ6uXmFwoVdx7iT2r+OmcmI0YAeDja+9ei4oGw9o/M
        yGASUTBogaANUxGB+s+1t/6+Zo0Mol5y++AjZ+edomjpjNt7keJlRoLJx16DwJHHV8S8nL
        QP9XRewyqScBwZQWooEB0KEwU/n5QbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660542958;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jlWCmLykmeA8uKPQs6RNLVRg3DyxBvBEEoXLbScAJW8=;
        b=brenKPHcbNV0aWZjxBS1sdF7dfOK/NZplQTeOudeT2J2cHJLnKVGWeSE+PbxNekmr0+Y/p
        GzPxeefKmEjt+dDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8C2C113A99;
        Mon, 15 Aug 2022 05:55:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jzOXIO7f+WI2BQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 15 Aug 2022 05:55:58 +0000
Message-ID: <68af1d0a-b8ff-9be4-e6ab-424945ac1891@suse.de>
Date:   Mon, 15 Aug 2022 07:55:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/4] Remove procfs support
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220812204553.2202539-1-bvanassche@acm.org>
 <DM6PR04MB6575F397E1B519922D3C2C5AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
 <e71a33f6-0a65-561b-33b9-6772239c21df@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <e71a33f6-0a65-561b-33b9-6772239c21df@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/22 16:27, Bart Van Assche wrote:
> On 8/14/22 05:54, Avri Altman wrote:
>>> The SCSI sysfs interface made the procfs interface superfluous. sysfs 
>>> support
>  >
>> Field application engineers are using #cat /proc/scsi/scsi to get the 
>> devices's fw version - Rev: xxx
>> Where should they look for that now?
> 
> Hi Avri,
> 
> Please take a look at the output of the following command:
> 
> find /sys -name inquiry | xargs grep -aH .
> 

The canonical method would 'lsscsi'; _slightly_ more convenient :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
