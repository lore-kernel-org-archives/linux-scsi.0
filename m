From: Varun Prakash <varun@chelsio.com>
Subject: Re: [RFC 13/34] iscsi-target: add new transport type
Date: Mon, 7 Mar 2016 20:25:16 +0530
Message-ID: <20160307145515.GA2015@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
 <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
 <20160301144848.GB9738@infradead.org>
 <1457213338.28660.47.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:59251 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbcCGO4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 09:56:10 -0500
Content-Disposition: inline
In-Reply-To: <1457213338.28660.47.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com

On Sat, Mar 05, 2016 at 01:28:58PM -0800, Nicholas A. Bellinger wrote:
> On Tue, 2016-03-01 at 06:48 -0800, Christoph Hellwig wrote:
> > This really looks like an odd interface.  I think everyone will
> > be much happpier in the long run if you do a generic offload interface
> > instead of special casing each possible driver.
> 
> Yes, I think iscsit_transport_type should to be replaced with an enum
> defining three types:
> 
>   - TCP using Linux/NET + stateless hw offload
>   - TCP using hw iscsi + network offload
>   - RDMA using iser-target offload
> 
> iscsit_transport_type was originally introduced to support TCP and SCTP
> network portal (which is still there btw), and since nobody cares about
> SCTP anymore, we can just drop it.
> 
> Varun, let's go in this direction for -v2 code, and use this new enum
> for existing special cases that -v1 touches.

Should we allow registration of multiple same transport type
offload drivers with iscsi-target?
