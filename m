From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 18 Jan 2017 16:27:24 +0200
Message-ID: <e3438024-e0f2-db96-5122-4508863be603@grimberg.me>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me>
 <53a3fb6c-c75a-519a-f669-2bcab404e01d@grimberg.me>
 <20170117162752.GE6067@linux-x5ow.site>
 <6df6bf6a-7cd3-1700-2b0a-e140325ebf47@grimberg.me>
 <20170118135156.GG3514@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170118135156.GG3514@linux-x5ow.site>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org


> So what you say is you saw a consomed == 1 [1] most of the time?
>
> [1] from http://git.infradead.org/nvme.git/commitdiff/eed5a9d925c59e43980047059fde29e3aa0b7836

Exactly. By processing 1 completion per interrupt it makes perfect sense
why this performs poorly, it's not worth paying the soft-irq schedule
for only a single completion.

What I'm curious is how consistent is this with different devices (wish
I had some...)
