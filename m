From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 13/34] iscsi-target: add new transport type
Date: Mon, 07 Mar 2016 12:30:55 -0800
Message-ID: <1457382655.30747.8.camel@haakon3.risingtidesystems.com>
References: <cover.1455467089.git.varun@chelsio.com>
	 <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
	 <20160301144848.GB9738@infradead.org>
	 <1457213338.28660.47.camel@haakon3.risingtidesystems.com>
	 <20160307145515.GA2015@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160307145515.GA2015@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-03-07 at 20:25 +0530, Varun Prakash wrote:
> On Sat, Mar 05, 2016 at 01:28:58PM -0800, Nicholas A. Bellinger wrote:
> > On Tue, 2016-03-01 at 06:48 -0800, Christoph Hellwig wrote:
> > > This really looks like an odd interface.  I think everyone will
> > > be much happpier in the long run if you do a generic offload interface
> > > instead of special casing each possible driver.
> > 
> > Yes, I think iscsit_transport_type should to be replaced with an enum
> > defining three types:
> > 
> >   - TCP using Linux/NET + stateless hw offload
> >   - TCP using hw iscsi + network offload
> >   - RDMA using iser-target offload
> > 
> > iscsit_transport_type was originally introduced to support TCP and SCTP
> > network portal (which is still there btw), and since nobody cares about
> > SCTP anymore, we can just drop it.
> > 
> > Varun, let's go in this direction for -v2 code, and use this new enum
> > for existing special cases that -v1 touches.
> 
> Should we allow registration of multiple same transport type
> offload drivers with iscsi-target?

Registration of different hw iscsi + network offload drivers using the
same transport type should be supported, yes.

I don't believe there is a limit wrt to multiple drivers/infiniband/hw/
RNICs using different iscsit_transport registrations today, so it
shouldn't be an issue. 
