From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] block: Fix secure erase
Date: Tue, 16 Aug 2016 10:20:25 +0300
Message-ID: <d350c5b0-3ac8-342b-608b-933652c26b65@intel.com>
References: <20160811140533.GA16543@lst.de>
 <1471270071-28921-1-git-send-email-adrian.hunter@intel.com>
 <CAJVOszDxKmaEEsg49yMT+Vr8oNbKLmgAGJ_P9KNa=zQcqcx+CQ@mail.gmail.com>
 <20160815181457.GA9781@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160815181457.GA9781@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Jens Axboe <axboe@fb.com>, Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org, linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Josh Bingaman <josh.bingaman@seagate.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Pawel Wodkowski <pawelx.wodkowski@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 15/08/16 21:14, Christoph Hellwig wrote:
> On Mon, Aug 15, 2016 at 11:43:12AM -0500, Shaun Tancheff wrote:
>> Hmm ... Since REQ_SECURE implied REQ_DISCARD doesn't this
>> mean that we should include REQ_OP_SECURE_ERASE checking
>> wherever REQ_OP_DISCARD is being checked now in drivers/scsi/sd.c ?
>>
>> (It's only in 3 spots so it's a quickie patch)
> 
> SCSI doesn't support secure erase operations.  Only MMC really
> supports it, plus the usual cargo culting in Xen blkfront that's
> probably never been tested..
> 

I left SCSI out because support does not exist at the moment.
However there is UFS which is seen as the replacement for eMMC.
And there is a patch to add support for BLKSECDISCARD:

	http://marc.info/?l=linux-scsi&m=146953519016056

So SCSI will need updating if that is to go in.
