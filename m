From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target: Don't arbitrary limit I/O size to
 fabric_max_sectors
Date: Fri, 09 Jan 2015 06:09:17 -0800
Message-ID: <1420812557.21830.23.camel@haakon3.risingtidesystems.com>
References: <1420590258-21122-1-git-send-email-nab@daterainc.com>
	 <1420647107.12144.8.camel@haakon3.risingtidesystems.com>
	 <yq1zj9t2v9t.fsf@sermon.lab.mkp.net>
	 <1420757368.2842.33.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1420757368.2842.33.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-01-08 at 14:49 -0800, Nicholas A. Bellinger wrote:
> On Thu, 2015-01-08 at 09:37 -0500, Martin K. Petersen wrote:
> > >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> > 
> > nab> IIRC, most modern hardware is reporting a large enough value for
> > nab> queue_max_hw_sectors() to support 8 MB I/Os, but I'm thinking that
> > nab> this could end up being problematic for older hardware that is
> > nab> reporting much smaller values.
> > 
> > Reporting queue_max_hw_sectors sounds sane to me.
> > 
> > What's your concern wrt. older hardware?
> > 
> 
> The target is still enforcing it's own hw_max_sectors in sbc_parse_cdb()
> based upon what queue_max_hw_sectors() reports for IBLOCK, and will
> throw an exception for I/Os who's sector count exceeds this maximum.
> 
> The concern is when older hardware drivers are reporting say
> queue_max_hw_sectors=128 with initiators are not actively honoring block
> limits EVPD MAXIMUM TRANSFER LENGTH, that would result in I/Os over 64K
> generating exception status.
> 
> So the question is what is a sane minimum for IBLOCK's hw_max_sectors so
> that large I/Os (say up to 8 MB) aren't rejected by sbc_parse_sbc(), and
> don't trigger the subsequent checks in generic_make_request() ->
> generic_make_request_checks().
> 

Christoph, any input on this..?

--nab
