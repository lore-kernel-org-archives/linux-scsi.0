Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9A3C25B47
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Oct 2023 05:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345123AbjJ0FF7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Oct 2023 01:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345118AbjJ0FF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Oct 2023 01:05:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0ED71BE
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 22:05:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 526C521AD8;
        Fri, 27 Oct 2023 05:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698383153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TH9xj8js/C8M9fvcfUBMnV9xMDihw9+YlXtBXYw6I0o=;
        b=rZmVSVw5P3KakJylzc8Gn0VXrfP+ZZt3uB52wBG7aXbNPm3Chu9H6Kzhdr5nk2JQmnIFSD
        xtzCyQmBzjdb04WndK4mbQ7COc1rFbtLHXWyPHCU2QRjbCMOW+spTTyNkCArB2LiSuDQIL
        KwRvF63VAvXAyuAlEX/f24PCZrkAw24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698383153;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TH9xj8js/C8M9fvcfUBMnV9xMDihw9+YlXtBXYw6I0o=;
        b=fyc+DjoJhpBYXcKjE6ArdawT8hyJtrN0o4qJt4DK6q74F/UOZ8519Z1G3l72u5LIwIPycO
        uDoB0c3XpEBCvPDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1D1DE13524;
        Fri, 27 Oct 2023 05:05:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8LdeBTFFO2VoUgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Oct 2023 05:05:53 +0000
Message-ID: <cc883518-1c57-4272-aa4d-389203501dc1@suse.de>
Date:   Fri, 27 Oct 2023 07:05:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] scsi_error: map FAST_IO_FAIL to -EAGAIN in SCSI EH
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-10-hare@suse.de>
 <6ba0093c-9c0f-4669-b1fd-ec2baa1738e2@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <6ba0093c-9c0f-4669-b1fd-ec2baa1738e2@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-7.09 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         RCPT_COUNT_FIVE(0.00)[6];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/23 18:50, Mike Christie wrote:
> On 10/23/23 4:28 AM, Hannes Reinecke wrote:
>> Returning FAST_IO_FAIL from any of the SCSI EH functions is perfectly
>> valid, and indicates that the request could not be executed due to
>> the transport being busy.
> 
> I'm not sure if that's completely correct or maybe we have a different
> view of what it means to be busy.
> 
> FC, iSCSI and SRP normally return it when the transport is marked as
> offline/lost, so for normal IO we fail it upwards and userspace gets
> an error.
> 
> What drivers use it as temp busy error code? Is it the lpfc one
> or a snic one?
> 
This patch is primarily for sg_reset(), which would return -EIO whenever
one of the EH functions would return FAST_IO_FAIL.
It got triggered by my patch to zfcp, which now returns FAST_IO_FAIL
from host reset as remote port login is happening from a worker thread,
and the devices are not (yet) available.

>> But that is not an I/O error, and we should return -EAGAIN from
>> scsi_ioctl_reset() to correctly inform userspace.
> For the sg_reset example, if you tried to run sg_reset again it would
> fail. When sg_reset tries to open the device the open function will
> return failure in the open call because the device is in the
> transport-offline state for FC/iSCSI/SRP.
> 
> If you are going to change the return value why not sync it with
> what we return for normal IO and return BLK_STS_TRANSPORT/-ENOLINK?

Good point.
The alternative would be to map FAST_IO_FAIL back to SUCCESS as after
all the host reset completed successfully, and blocked ports are not
really an error.
Lemme check.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

