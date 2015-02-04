From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v3 5/9] vhost/scsi: Add ANY_LAYOUT vhost_virtqueue
 callback
Date: Wed, 4 Feb 2015 10:42:52 +0100
Message-ID: <20150204094252.GI9920@redhat.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
 <1422945003-24538-6-git-send-email-nab@daterainc.com>
 <20150203101436.GO2830@redhat.com>
 <1423042825.28700.26.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423042825.28700.26.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 04, 2015 at 01:40:25AM -0800, Nicholas A. Bellinger wrote:
> > > +		/*
> > > +		 * Any associated T10_PI bytes for the outgoing / incoming
> > > +		 * payloads are included in calculation of exp_data_len here.
> > > +		 */
> > > +		if (out_size > req_size) {
> > > +			data_direction = DMA_TO_DEVICE;
> > > +			exp_data_len = out_size - req_size;
> > > +		} else if (in_size > rsp_size) {
> > > +			data_direction = DMA_FROM_DEVICE;
> > > +			exp_data_len = in_size - rsp_size;
> > > +		} else {
> > > +			data_direction = DMA_NONE;
> > > +			exp_data_len = 0;
> > > +		}
> > 
> > We must validate this doesn't cause exp_data_len to be negative.
> > 
> 
> AFAICT, exp_data_len is always >= 0 here.

What guarantees out_size > req_size and in_size > rsp_size,
respectively?

-- 
MST
