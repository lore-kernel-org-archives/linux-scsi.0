From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
 IO sg-chaining
Date: Tue, 24 Jul 2007 17:01:23 +0300
Message-ID: <46A60633.2020904@panasas.com>
References: <20070724181635G.fujita.tomonori@lab.ntt.co.jp>	<46A5CDFE.3020801@panasas.com>	<20070724201247A.fujita.tomonori@lab.ntt.co.jp> <20070724110138P.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21401 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757070AbXGXOFM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 10:05:12 -0400
In-Reply-To: <20070724110138P.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> I should have said that, was the approach to use separate buffer for
> sglists instead of putting the sglists and the parameters in one
> buffer completely rejected?

I think that James should be asked this question.
My understanding was that he preferred allocating the sgtable
header along with the scatterlist array.

There are pro's and con's either way.  In my opinion separating
the headers is better for mapping buffers that have a power of 2
#pages (which seems to be the typical case) since when you're
losing one entry in the sgtable for the header you'd waste a lot
more when you just cross the bucket boundary. E.g. for 64 pages
you need to allocate from the "64 to 127" bucket rather than the
"33 to 64" bucket).  Separated, one sgtable header structure
can just be embedded in struct scsi_cmnd for uni-directional transfers
(wasting some space when transferring no data, but saving space and
cycles in the common case vs. allocating it from a separate memory pool)
and the one for bidi read buffers can be allocated separately just for
bidi commands.

Benny
