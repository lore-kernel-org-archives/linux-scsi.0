Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250C1C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 08:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiCFIlo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 03:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiCFIln (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 03:41:43 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941751D332;
        Sun,  6 Mar 2022 00:40:51 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 43D9767373; Sun,  6 Mar 2022 09:40:47 +0100 (CET)
Date:   Sun, 6 Mar 2022 09:40:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 04/14] sd: rename the scsi_disk.dev field
Message-ID: <20220306084046.GA22113@lst.de>
References: <20220304160331.399757-1-hch@lst.de> <20220304160331.399757-5-hch@lst.de> <7ff2340d-892b-94b5-ec39-355a8f8adc73@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ff2340d-892b-94b5-ec39-355a8f8adc73@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Mar 05, 2022 at 05:38:40PM -0800, Bart Van Assche wrote:
> On 3/4/22 08:03, Christoph Hellwig wrote:
>> +	/*
>> +	 * This device is mostly just used to show a bunch of attributes in a
>> +	 * weird place.  In doubt don't add any new users, and most importantly
>> +	 * don't use if for any actual refcounting.
>> +	 */
>> +	struct device	disk_dev;
>
> Isn't "weird place" subjective? How about mentioning the sysfs path 
> explicitly (/sys/class/scsi_disk/H:C:I:L)? How about explaining why no new 
> sysfs attributes should be added to that device instance?

Well, weird place means that all normale drivers would just use
attributes on the gendisk for it, but sd creates a completely pointless
device under the gendisk device for it.  If you have a better wording
I can change it.
