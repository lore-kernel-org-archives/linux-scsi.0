From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 22/34] iscsi-target: call Rx thread function
Date: Sat, 05 Mar 2016 15:16:23 -0800
Message-ID: <1457219783.28660.86.camel@haakon3.risingtidesystems.com>
References: <cover.1455467089.git.varun@chelsio.com>
	 <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
	 <20160301150137.GH9738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160301150137.GH9738@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-03-01 at 07:01 -0800, Christoph Hellwig wrote:
> On Sun, Feb 14, 2016 at 11:15:29PM +0530, Varun Prakash wrote:
> > call Rx thread function if registered
> > by transport driver, so that transport
> > drivers can use iscsi-target Rx thread
> > for Rx processing.
> > 
> > update iSER target driver to use this
> > interface.
> 
> Not related to your new driver, but what's the point of even starting a
> RX thread for iSER?

Originally, this was added to avoid having multiple connection shutdown
special cases in now defunct iscsi_target_tq.c code.

With that part out of the way, it's should be straight-forward to avoid
starting conn->rx_thread all-together for iser-target.
