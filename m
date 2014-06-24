From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 12:08:48 -0500
Message-ID: <53A9B0A0.6000103@cs.wisc.edu>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net> <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu> <53A9A702.8050503@dev.mellanox.co.il> <20140624163040.GA11499@infradead.org> <53A9AEB8.4040104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53A9AEB8.4040104@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/24/2014 12:00 PM, Mike Christie wrote:
> On 06/24/2014 11:30 AM, Christoph Hellwig wrote:
>> On Tue, Jun 24, 2014 at 07:27:46PM +0300, Sagi Grimberg wrote:
>>> This condition only matters in the bidi case, which is not relevant for the
>>> PI case.
>>> I suggested to condition that in libiscsi (posted in the second thread,
>>> copy-paste below).
>>> Although I do agree that scsi_transfer_length() helper is not really just
>>> for PI and not more.
>>> I think Mike's way is cleaner.
>>
>> But for bidi there are two transfers.  So either scsi_transfer_length()
>> needs to take the scsi_data_buffer, or we need to avoid using it.
>>
>> For 3.16 I'd prefer something like you're patch below.  This patch which
>> has been rushed in last minute and not through the scsi tree has already
>> causes enough harm.  If you can come up with a clean version to
>> transparently handle the bidi case I'd be happy to pick that up for
>> 3.17.
>>
>> In the meantime please provide a version of the patch below with a
>> proper description and signoff.
>>
> 
> It would be nice to just have one function to call and it just do the
> right thing for the drivers. I am fine with Sagi's libiscsi patch for
> now though:
> 
> Acked-by: Mike Christie <michaelc@cs.wisc.edu>

Actually, let me take this back for a second. I am not sure if that is
right.
