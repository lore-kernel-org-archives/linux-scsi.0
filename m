Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38015C3F2D2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 13:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1625F2064A
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 13:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgCBNPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 08:15:44 -0500
Received: from verein.lst.de ([213.95.11.211]:43786 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgCBNPo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 08:15:44 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 54D7C68B20; Mon,  2 Mar 2020 14:15:41 +0100 (CET)
Date:   Mon, 2 Mar 2020 14:15:41 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: avoid to fetch scsi host template instance in IO
 path
Message-ID: <20200302131541.GA13265@lst.de>
References: <20200228093346.31213-1-ming.lei@redhat.com> <f23daab7-7aa0-1c34-8137-7abead09016c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f23daab7-7aa0-1c34-8137-7abead09016c@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 02, 2020 at 10:58:55AM +0000, John Garry wrote:
> On 28/02/2020 09:33, Ming Lei wrote:
>> scsi host template struct is quite big, and the following three
>> fields are needed in SCSI IO path:
>>
>> - queuecommand
>> - commit_rqs
>> - cmd_size
>
> Would it have been nearly as good to reorganise Scsi host template 
> structure to ensure that these are adjacent?
>
> I say nearly, as it avoids the shost->hostt read.

That would be worth trying.  Replicating function pointers out of
read-only data structures generally isn't a very good idea.
