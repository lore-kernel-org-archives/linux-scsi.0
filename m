From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 13/34] iscsi-target: add new transport type
Date: Sat, 05 Mar 2016 13:28:58 -0800
Message-ID: <1457213338.28660.47.camel@haakon3.risingtidesystems.com>
References: <cover.1455467089.git.varun@chelsio.com>
	 <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
	 <20160301144848.GB9738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160301144848.GB9738@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-03-01 at 06:48 -0800, Christoph Hellwig wrote:
> This really looks like an odd interface.  I think everyone will
> be much happpier in the long run if you do a generic offload interface
> instead of special casing each possible driver.

Yes, I think iscsit_transport_type should to be replaced with an enum
defining three types:

  - TCP using Linux/NET + stateless hw offload
  - TCP using hw iscsi + network offload
  - RDMA using iser-target offload

iscsit_transport_type was originally introduced to support TCP and SCTP
network portal (which is still there btw), and since nobody cares about
SCTP anymore, we can just drop it.

Varun, let's go in this direction for -v2 code, and use this new enum
for existing special cases that -v1 touches.
