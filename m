From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 18/34] iscsi-target: call complete on conn_logout_comp
Date: Sat, 05 Mar 2016 13:02:30 -0800
Message-ID: <1457211750.28660.29.camel@haakon3.risingtidesystems.com>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
	 <f98923031c5958e73ce1ac13a5fc7f68ba19391f.1455467089.git.varun@chelsio.com>
	 <56C205C7.9000503@dev.mellanox.co.il> <20160301145214.GE9738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160301145214.GE9738@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-03-01 at 06:52 -0800, Christoph Hellwig wrote:
> On Mon, Feb 15, 2016 at 07:07:19PM +0200, Sagi Grimberg wrote:
> > >+	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
> > >+	    (conn->conn_transport->transport_type == ISCSI_TCP_CXGB4))
> > >  		complete(&conn->conn_logout_comp);
> > 
> > IMO, this is an indication that this condition is a bandage in the first
> > place...
> 
> Agreed.  Nevermind the fact that a spurious complete() is perfectly
> harmless..
> 

iser-target uses the same completion isert_wait4logout() waiting for a
logout_posted response, which is why a spurious wakeup is not OK here.
