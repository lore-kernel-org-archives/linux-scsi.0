From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for PI
 errors
Date: Wed, 8 Jul 2015 13:36:04 +0300
Message-ID: <559CFD14.9090803@dev.mellanox.co.il>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-6-git-send-email-sagig@mellanox.com>
 <20150708101931.GD14466@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34817 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431AbbGHKfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 06:35:53 -0400
Received: by wiga1 with SMTP id a1so280996000wig.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2015 03:35:51 -0700 (PDT)
In-Reply-To: <20150708101931.GD14466@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

On 7/8/2015 1:19 PM, Christoph Hellwig wrote:
> On Mon, Jul 06, 2015 at 04:15:08PM +0300, Sagi Grimberg wrote:
>> PI errors should be reported in a descriptor format sense data.
>> Fix that by adding a desc_format flag to struct sense_info and pass
>> it to scsi_build_sense_buffer() to do the right thing.
>
> Do we really need the additional flag?  We only need the descriptor
> sense format because we add the sector information.  So just checking
> for that should be enough, especially when paired with a comment
> explaining that logic in the source file.

We don't have any other information today, but sector is not the only
information that is requires a descriptor format, so maybe it will be a
bit awkward to condition the descriptor format on the sector info?
