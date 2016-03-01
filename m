From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 18/34] iscsi-target: call complete on conn_logout_comp
Date: Tue, 1 Mar 2016 06:52:14 -0800
Message-ID: <20160301145214.GE9738@infradead.org>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
 <f98923031c5958e73ce1ac13a5fc7f68ba19391f.1455467089.git.varun@chelsio.com>
 <56C205C7.9000503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56C205C7.9000503@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 15, 2016 at 07:07:19PM +0200, Sagi Grimberg wrote:
> >+	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
> >+	    (conn->conn_transport->transport_type == ISCSI_TCP_CXGB4))
> >  		complete(&conn->conn_logout_comp);
> 
> IMO, this is an indication that this condition is a bandage in the first
> place...

Agreed.  Nevermind the fact that a spurious complete() is perfectly
harmless..

> While this is unrelated to the patch set, we should look into the iscsi
> termination sequences more closely and look if we can dispatch some
> logic to the drivers in places they defer. It will make the code much
> less complicated.

Yes, all I've seen in this series so far suggest that the integration
is a complete mess.  I think this really needs to go back to the drawing
board.
