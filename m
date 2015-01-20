From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 00/11] scsi: fix module reference mismatch for scsi
 host
Date: Tue, 20 Jan 2015 10:18:24 -0500
Message-ID: <20150120151824.GA8684@htj.dyndns.org>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
 <20150119142206.GE8140@htj.dyndns.org>
 <CAC5umyh+x_B3GOc4q=Q+2NsAK8KmaHvpyW329iG-d1yAUwN02A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAC5umyh+x_B3GOc4q=Q+2NsAK8KmaHvpyW329iG-d1yAUwN02A@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, Hans de Goede <hdegoede@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Robert Love <robert.w.love@intel.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, fcoe-devel@open-fcoe.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

Hello, Akinobu.

On Tue, Jan 20, 2015 at 11:57:37PM +0900, Akinobu Mita wrote:
> The reason I didn't move sht from the core driver to the LLDDs for
> fixing ufs and ums-* in the first place is to avoid exporting many
> symbols for callbacks in sht.  But I realized that we can do it
> without that many exported symbols by creating a single function that
> returns a kmemdup()ed sht with a few change including ->module.

Hmmm, libata already exports most of the necessary symbols.  libahci
or platform drivers might have to export more but that shouldn't be
much.  For libata, pushing sht's to the leaf drivers would make far
more sense as sht's already get inherited and modified along the
hierarchy.

Thanks.

-- 
tejun
