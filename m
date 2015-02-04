From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 5/9] vhost/scsi: Add ANY_LAYOUT vhost_virtqueue
 callback
Date: Wed, 04 Feb 2015 02:41:07 -0800
Message-ID: <1423046467.28700.48.camel@haakon3.risingtidesystems.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
	 <1422945003-24538-6-git-send-email-nab@daterainc.com>
	 <20150203101436.GO2830@redhat.com>
	 <1423042825.28700.26.camel@haakon3.risingtidesystems.com>
	 <20150204094252.GI9920@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150204094252.GI9920@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-02-04 at 10:42 +0100, Michael S. Tsirkin wrote:
> On Wed, Feb 04, 2015 at 01:40:25AM -0800, Nicholas A. Bellinger wrote:
> > > > +		/*
> > > > +		 * Any associated T10_PI bytes for the outgoing / incoming
> > > > +		 * payloads are included in calculation of exp_data_len here.
> > > > +		 */
> > > > +		if (out_size > req_size) {
> > > > +			data_direction = DMA_TO_DEVICE;
> > > > +			exp_data_len = out_size - req_size;
> > > > +		} else if (in_size > rsp_size) {
> > > > +			data_direction = DMA_FROM_DEVICE;
> > > > +			exp_data_len = in_size - rsp_size;
> > > > +		} else {
> > > > +			data_direction = DMA_NONE;
> > > > +			exp_data_len = 0;
> > > > +		}
> > > 
> > > We must validate this doesn't cause exp_data_len to be negative.
> > > 
> > 
> > AFAICT, exp_data_len is always >= 0 here.
> 
> What guarantees out_size > req_size and in_size > rsp_size,
> respectively?
> 

Mmm, point taken.

So moving this part after copy_from_iter() ensures that at least
req_size bytes exists of out_size.  Making this change now.

For in_size > rsp_size there is no guarantee, and falls back to
data_direction = DMA_NONE + exp_data_len = 0;

Is this what you had in mind..?

--nab

