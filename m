From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: support ranges TRIM for libata
Date: Thu, 23 Mar 2017 11:39:06 -0400
Message-ID: <yq1a88cdmud.fsf@oracle.com>
References: <20170320204319.12628-1-hch@lst.de>
        <20170321185901.GB3706@htj.duckdns.org> <20170322181947.GA4733@lst.de>
        <1490276861.2202.8.camel@HansenPartnership.com>
        <20170323135521.GA30361@lst.de>
        <1490279706.2202.17.camel@HansenPartnership.com>
        <20170323144330.GA31447@lst.de> <20170323153001.GA32484@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170323153001.GA32484@lst.de> (Christoph Hellwig's message of
        "Thu, 23 Mar 2017 16:30:01 +0100")
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com, axboe@kernel.dk, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Meh, I remember why I gave up on it - to support queued trim passthrough
> we'd need to implement ATA 32 for the auxiliary fields and thus support
> 32-bit CDBs.  I don't really want to go there..

I wish we could stick with SATL. However, I have attempted this a few
times over the years and I am with Christoph here. Due to the
discrepancies between ACS and SBC it's a twisted mess. And the iterative
approach has not worked well for HBA SATLs either. Quite the contrary.

So I think sticking the DSM TRIM payload onto a SCSI command is the path
of least resistance. And then NAK'ing attempts to issue these commands
through sg.

I'll take closer look at the entire series tomorrow or Monday. I want to
test multiple ranges on my "Little Shop of SSD Horrors" when I get back
home from LSF/MM.

-- 
Martin K. Petersen	Oracle Linux Engineering
