From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 6/6] lib/scatterlist: Drop order argument from
 sgl_free_n_order
Date: Wed, 07 Mar 2018 10:30:15 -0800
Message-ID: <1520447415.5558.12.camel@HansenPartnership.com>
References: <20180307124712.14963-1-tvrtko.ursulin@linux.intel.com>
         <20180307124712.14963-7-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180307124712.14963-7-tvrtko.ursulin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel@vger.kernel.org
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-03-07 at 12:47 +0000, Tvrtko Ursulin wrote:
> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Firstly, I don't see any justifiable benefit to churning this API, so
why bother? but secondly this:

> We can derive the order from sg->length and so do not need to pass it
> in explicitly.

Is wrong.  I can have a length 2 scatterlist that crosses a page
boundary, but I can also have one within a single page, so the order
cannot be deduced from the length.

James
